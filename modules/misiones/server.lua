ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
---------------
--[[ESX.RegisterServerCallback('x6crime:getLicense', function (source, cb, license)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier,
	}, function (result)
		for k,v in pairs(result) do
			if v.type == license then
				cb(true)
			end
		end
	end)
end)]]--

RegisterNetEvent('MissionStart')
AddEventHandler('MissionStart', function(quantity, drug, price, time, title)
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getAccount('black_money').money
	local item = xPlayer.getInventoryItem(drug).count
	if money >= price and item == 0 then
		xPlayer.removeAccountMoney('black_money',price)
		xPlayer.addInventoryItem(drug, quantity)
		TriggerClientEvent('MissionContinue', source, time, title)
	elseif money >= price and item > 0 then
		TriggerClientEvent('esx:showNotification', source, "No mezcles tu mierda con la mía, es de peor calidad, vuelve cuando te hayas desecho de ella")
	elseif money < price then
		TriggerClientEvent('esx:showNotification', source, "Crees que voy a fiarme de ti?, trae el dinero y no me hagas perder el tiempo")
	end
end)

RegisterNetEvent('MissionCompleted')
AddEventHandler('MissionCompleted', function(quantity, drug, reward)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(drug).count
	if item >= quantity then
		xPlayer.removeInventoryItem(drug, quantity)
		xPlayer.addAccountMoney('black_money', reward)
		TriggerClientEvent('esx:showNotification', source, "Me gusta la gente de negocios, y tu eres parte de esa gente.")
	end
end)