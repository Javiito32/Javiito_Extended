RegisterNetEvent('JEX:addFishes')
AddEventHandler('JEX:addFishes', function(level)
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalFishes = {}
    TriggerEvent('JEX:addXP', xPlayer.identifier, "fisherman", math.random(2,4))
    for k, v in pairs(ConfigFishing.Levels) do
        if level >= v then
            table.insert(totalFishes, k)
        end
    end
    if #totalFishes <= 2 then
        for _, v in pairs(totalFishes) do
            local xItem = xPlayer.getInventoryItem(v)
            local random = math.random(5, 8)
            if xItem.count + random <= xItem.limit then
                xPlayer.addInventoryItem(v, random)
            end
        end
    elseif #totalFishes <= 4 then
        for _, v in pairs(totalFishes) do
            if math.random(1, 10) <= 5 then
                local xItem = xPlayer.getInventoryItem(v)
                local random = math.random(4, 6)
                if xItem.count + random <= xItem.limit then
                    xPlayer.addInventoryItem(v, random)
                end
            end
        end
    elseif #totalFishes <= 6 then
        for _, v in pairs(totalFishes) do
            if math.random(1, 10) <= 4 then
                local xItem = xPlayer.getInventoryItem(v)
                local random = math.random(4, 6)
                if xItem.count + random <= xItem.limit then
                    xPlayer.addInventoryItem(v, random)
                end
            end
        end
    elseif #totalFishes <= 10 then
        for _, v in pairs(totalFishes) do
            if math.random(1, 10) <= 3 then
                local xItem = xPlayer.getInventoryItem(v)
                local random = math.random(4, 6)
                if xItem.count + random <= xItem.limit then
                    xPlayer.addInventoryItem(v, random)
                end
            end
        end
    end
end)

RegisterNetEvent('JEX:sellFishes')
AddEventHandler('JEX:sellFishes', function(level)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amountToPay = 0
    for k, v in pairs(ConfigFishing.Prices) do
        local xItemCount = xPlayer.getInventoryItem(k).count
        if xItemCount > 0 then
            xPlayer.removeInventoryItem(k, xItemCount)
            amountToPay = amountToPay + v*xItemCount
        end
    end
    TriggerEvent('JEX:getPayment', xPlayer.identifier, 'fisherman', amountToPay)
end)