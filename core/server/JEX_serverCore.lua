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
    xPlayer.setJob(work, tonumber(level)-1)
    TriggerClientEvent('JEX:setLevel', xPlayer.source, work, tonumber(level))
    TriggerClientEvent('chat:addMessage', xPlayer.source, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Subida de nivel | ", "Has subido al nivel "..level.. " de " .. getLabelFromWork(work)}
    }) 
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

    else
        local changes = false
        local xp = json.decode(data[1].xp)
        local xplevels = json.decode(data[1].levelsxp)

        for k, v in pairs(WorkLevels) do
            local coincide = false
            for a, b in pairs(xp) do
                if a == k then
                    coincide = true
                    break
                end
            end
            if not coincide then
                xp[k] = 0
                xplevels[k] = 0
                changes = true
            end
        end

        if changes then
            print("Se ejecuta eso")
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
    local job = xPlayer.getJob()
    if job.grade >= WorkLevels[job.name]-1 then
        TriggerClientEvent('JEX:businessRemember', source, job.name)
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
    TriggerClientEvent('JEX:BusinessUnlock', job)
end

-- End of XP system