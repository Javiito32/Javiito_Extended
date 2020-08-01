ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('leñar:doymineral')
AddEventHandler('leñar:doymineral', function(mineral)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(mineral)
	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(mineral, 1)
	else
		TriggerClientEvent('esx:showNotification', source, "No puedes cargar más madera de este tipo")
	end
end)

RegisterServerEvent('leñar:recibodata')
AddEventHandler('leñar:recibodata',function(data)
	troncos = data
	TriggerClientEvent('leñar:recibodatacliente',-1,data)
end)

function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent('leñar:craft')
AddEventHandler('leñar:craft',function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local quantityMineral = xPlayer.getInventoryItem(item)
		if quantityMineral.count >= 30 then
			xPlayer.removeInventoryItem(item,30)
			xPlayer.addInventoryItem("tablon_"..item,15)
			TriggerClientEvent('esx:showNotification', source, "Has conseguido 15 tablones de "..item)
		elseif quantityMineral.count < 30 and quantityMineral.count > 1 then
			local qtty = quantityMineral.count
			qtty = round(qtty/2-0.1, 0)
			xPlayer.removeInventoryItem(item, qtty*2)
			xPlayer.addInventoryItem("tablon_"..item, qtty)
			TriggerClientEvent('esx:showNotification', source, "Has conseguido "..tostring(qtty).." tablones de "..item)
		else
			TriggerClientEvent('esx:showNotification', source, "Lo siento pero te falta mercancia, necesitas por lo menos 2 piezas.")
		end
	end
end)

-------------------
--UNIVERSIDAD------
-------------------

function calculateLevel(skills)
	local level = 0
	for i,v in pairs(skills) do
		if v == "pino" or v == "roble" or v == "nogal" or v == "sequoia" then
			level = level + 1
		end
	end
	return level
end

RegisterServerEvent('leñar:quitomin')
AddEventHandler('leñar:quitomin',function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	for i = 1, #xPlayer.inventory,1 do
		if xPlayer.inventory[i].name == "tablon_abedul" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'madedero', count*math.random(20,30))
				--xPlayer.addMoney(count*math.random(20,30))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'madedero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "tablon_abeto" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'madedero', count*math.random(15,25))
				--xPlayer.addMoney(count*math.random(15,25))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'madedero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "tablon_nogal" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'madedero', count*math.random(15,20))
				--xPlayer.addMoney(count*math.random(15,20))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'madedero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "tablon_roble" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'madedero', count*math.random(13,15))
				--xPlayer.addMoney(count*math.random(13,15))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'madedero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "tablon_pino" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'madedero', count*math.random(30,32))
				--xPlayer.addMoney(count*math.random(30,32))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'madedero', 1*count)
			end
		end
	end
end)


function recatroncos()
	for i=1, #troncos, 1 do
		if troncos[i].vida < troncos[i].max then
			if troncos[i].vida + 5 > troncos[i].max then 
				troncos[i].vida = troncos[i].max
			else
				troncos[i].vida = troncos[i].vida + 5
			end
		end
	end
    --Sincroniar
	TriggerClientEvent('leñar:recibodatacliente',-1,troncos)
end

function loop()
Citizen.CreateThread(function()
	while true do
		recatroncos()
		Citizen.Wait(30000)
	Citizen.Wait(0)
	end
end)
end

ESX.RegisterServerCallback("leñar:dineroVehiculo", function(playerId, cb, type)
	xPlayer = ESX.GetPlayerFromId(playerId)
	if type == "get" then
		if xPlayer.getMoney() >= ConfigMadera.VehicleMoney then
			xPlayer.removeMoney(ConfigMadera.VehicleMoney)
			TriggerClientEvent("esx:showNotification", playerId, "Se te ha cobrado una ~o~fianza ~s~de "..tostring(ConfigMadera.VehicleMoney).."~g~$ ~s~por el vehículo")
			cb(true)
		else
			xPlayer.removeMoney(ConfigMadera.VehicleMoney)
			TriggerClientEvent("esx:showNotification", playerId, "Te ~r~endeudaste ~s~por "..tostring(ConfigMadera.VehicleMoney).."~g~$ ~s~de ~o~fianza ~s~para adquirir el vehículo")
			cb(true)
		end
	elseif type == "return" then
		xPlayer.addMoney(ConfigMadera.VehicleMoney)
		cb(true)
	end
end)

loop()



