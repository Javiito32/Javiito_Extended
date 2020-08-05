-- Main ESX Integrations Needed
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Start of JEX Integrations

-- Start of XP system
AddEventHandler('JEX:addXP', function(identifier, work, xp)
    local JEXPlayer = CreateJEXPlayer(identifier)
    JEXPlayer.addXP(work, xp)
end)

AddEventHandler('JEX:LevelUpgrade', function(identifier, level, work)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    xPlayer.setJob(work, tonumber(level))
    TriggerClientEvent('JEX:setLevel', xPlayer.source, work, tonumber(level))
    TriggerClientEvent('chat:addMessage', xPlayer.source, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Subida de nivel | ", "Has subido al nivel "..level.. " de " .. getLabelFromWork(work)}
    })
    TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, 'levelup',  0.8)
    if level >= #WorkLevels[work] then
        addBusiness(identifier, work, xPlayer.source)
    end   
end)

AddEventHandler('JEX:getPayment', function(identifier, work, payment, paymentType)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    local JEXPlayer = CreateJEXPlayer(xPlayer.identifier)

    if paymentType == 'bank' then
        xPlayer.addAccountMoney('bank', ESX.Math.Round(payment*JEXPlayer.getXPmultiplier(work)))
    elseif paymentType == 'black' then
        xPlayer.addAccountMoney('black', ESX.Math.Round(payment*JEXPlayer.getXPmultiplier(work)))
    else
        xPlayer.addMoney(ESX.Math.Round(payment*JEXPlayer.getXPmultiplier(work)))
    end
end)

RegisterNetEvent('JEX:CheckPlayer')
AddEventHandler('JEX:CheckPlayer', function()
    local _source = source
    local steam64id
    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.match(v, "steam:") then
            steam64id = v
            break
        end
    end

    local data = MySQL.Sync.fetchAll("SELECT * FROM jex_users WHERE identifier = @steam64_hex", {
        ['@steam64_hex'] = steam64id
    })

    if #data == 0 then

        local xp = {}
        local xplevels = {}
        for k, v in pairs(WorkLevels) do
            xp[k] = 0
            xplevels[k] = 0
        end

        MySQL.Async.execute('INSERT INTO jex_users (identifier, xp, levelsxp) VALUES (@steam64_hex, @_xp, @_levelsxp)',
        { 
            ['@_xp'] = json.encode(xp),
            ['@_levelsxp'] = json.encode(xplevels),
            ['@steam64_hex'] = steam64id
        })

        for k, v in pairs(xplevels) do
            TriggerClientEvent('JEX:setLevel', _source, k, tonumber(v))
        end
    else
        local changes = false
        local xp = json.decode(data[1].xp)
        local xplevels = json.decode(data[1].levelsxp)

        for k, v in pairs(WorkLevels) do
            if not xp[k] then
                xp[k] = 0
                xplevels[k] = 0
                changes = true
            end
        end

        if changes then
            MySQL.Async.execute('UPDATE jex_users SET xp = @_xp, levelsxp = @_levelsxp WHERE identifier = @steam64_hex',
            { 
                ['@_xp'] = json.encode(xp),
                ['@_levelsxp'] = json.encode(xplevels),
                ['@steam64_hex'] = steam64id
            })
        end

        for k, v in pairs(xplevels) do
            TriggerClientEvent('JEX:setLevel', _source, k, tonumber(v))
        end
    end
end)

RegisterCommand('addXP', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('JEX:addXP', xPlayer.identifier, 'minero', 50)
end)
-- End of XP system

-- Player Connection Exec

AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local JEXPlayer = CreateJEXPlayer(xPlayer.identifier)
    local job = xPlayer.getJob()
    if WorkLevels[job.name] then
        if job.grade >= #WorkLevels[job.name]-1 then
            MySQL.Async.fetchAll('SELECT u.job, n.* FROM users AS u, negocios AS n WHERE u.identifier = n.identifier AND u.job = n.job AND n.identifier = @steam64_hex', {
                ['@steam64_hex'] = xPlayer.identifier
            }, function(results)
                if #results > 0 then
                    if results[1].stock == nil then
                        TriggerClientEvent('JEX:businessRemember', source, results[1].job)
                    else
                        TriggerClientEvent('JEX:businessIsOwned', source, results[1].job)
                    end
                end
            end)
        end
    end
end)

-- End of Player Connection Exec

-- Start of Business XP System

function addBusiness(steam64id, job, id)
    MySQL.Async.execute('INSERT INTO negocios (identifier, job) VALUES (@steam64_hex, @_job)',
    { 
        ['@_job'] = job,
        ['@steam64_hex'] = steam64id
    })
    TriggerClientEvent('JEX:BusinessUnlock', id, job)
end

RegisterNetEvent('JEX:buyBusiness')
AddEventHandler('JEX:buyBusiness', function(job)
    local isable = true
    local xPlayer = ESX.GetPlayerFromId(source)
    for i = 1, #Config.Business[job].initial_pay, 1 do
        local xItem = xPlayer.getInventoryItem(Config.Business[job].initial_pay[i].item)
        if xItem.count < Config.Business[job].initial_pay[i].value then
            TriggerClientEvent('esx:showNotification', source, "Te faltan "..Config.Business[job].initial_pay[i].value-xItem.count.." de "..xItem.label)
            isable = false
        end
    end
    if isable then
        for i = 1, #Config.Business[job].initial_pay, 1 do
            xPlayer.removeInventoryItem(Config.Business[job].initial_pay[i].item, Config.Business[job].initial_pay[i].value)
        end
        TriggerClientEvent('JEX:BusinessBought', source, job)
        --TriggerClientEvent('esx:showNotification', source, "Has ~g~desbloqueado~w~ el negocio correctamente, como cortesía te hemos regalado 10 de stock")
    end
    MySQL.Async.execute('UPDATE negocios SET stock = 10 WHERE identifier = @steam64_hex AND job = @_job',
    { 
        ['@_job'] = job,
        ['@steam64_hex'] = xPlayer.identifier
    })
end)

RegisterNetEvent('JEX:buyBusinessStock')
AddEventHandler('JEX:buyBusinessStock', function(job, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isable = true
    for i = 1, #Config.Business[job].stock_price, 1 do
        local xItem = xPlayer.getInventoryItem(Config.Business[job].stock_price[i].item)
        local mustHave = Config.Business[job].stock_price[i].value*quantity
        if xItem.count < mustHave then
            TriggerClientEvent('esx:showNotification', source, "Te faltan "..mustHave-xItem.count.." de "..xItem.label)
            isable = false
        end
    end
    if isable then
        for i = 1, #Config.Business[job].stock_price, 1 do
            local toBeDeleted = Config.Business[job].stock_price[i].value*quantity
            xPlayer.removeInventoryItem(Config.Business[job].stock_price[i].item, toBeDeleted)
        end
        TriggerClientEvent('esx:showNotification', source, "Has obtenido ~g~"..quantity.." de stock")
        MySQL.Async.execute('UPDATE negocios SET stock = stock + @_stock WHERE identifier = @steam64_hex AND job = @_job',
        { 
            ['@_job'] = job,
            ['@_stock'] = quantity,
            ['@steam64_hex'] = xPlayer.identifier
        })
    end
end)

ESX.RegisterServerCallback("JEX:getBusinessStock", function(source, cb, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT stock FROM negocios WHERE identifier = @steam64_hex AND job = @_job', {
        ['@steam64_hex'] = xPlayer.identifier,
        ['@_job'] = job
    }, function(results)
        cb(results[1].stock)
    end)
end)

RegisterNetEvent("JEX:checkBusiness")
AddEventHandler("JEX:checkBusiness", function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local data = MySQL.Sync.fetchAll('SELECT job, stock FROM negocios WHERE identifier = @steam64_hex AND job = @_job', {
        ['@steam64_hex'] = xPlayer.identifier,
        ['@_job'] = job
    })
    if #data > 0 then
        local stock = data[1].stock
        TriggerClientEvent("JEX:BusinessChecked", _source, true, stock)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3600000)
        MySQL.Async.fetchAll('SELECT u.job, n.* FROM users AS u, negocios AS n WHERE u.identifier = n.identifier AND u.job = n.job AND stock <> NULL', {}, function(results)
            for i=1, #results, 1 do
                local xPlayer = ESX.GetPlayerFromIdentifier(results[i].identifier)
                if results[i].stock > 0 then
                    if xPlayer ~= nil then
                        TriggerClientEvent('esx:showNotification', xPlayer.source, "Has recibido la ~g~paga~w~ de tu negocio de "..getLabelFromWork(results[i].job))
                        xPlayer.addAccountMoney('bank', Config.Business[results[i].job].reward)
                    else
                        MySQL.Async.execute('UPDATE `users` SET `bank` = `bank` + @bank WHERE `identifier` = @identifier',{['@bank'] = tonumber(Config.Business[results[i].job].reward), ['@identifier'] = results[i].identifier})
                    end
                else
                    if xPlayer ~= nil then
                        TriggerClientEvent('esx:showNotification', xPlayer.source, "Tu negocio de "..getLabelFromWork(results[i].job).." se ha quedado ~r~sin stock")
                    end
                end
            end
        end)
    end
end)

-- End of XP system