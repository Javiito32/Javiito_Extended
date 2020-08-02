ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('minar:doymineral')
AddEventHandler('minar:doymineral', function(mineral)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(mineral)
	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(mineral, 1)
		local JEXPlayer = CreateJEXPlayer(identifier)
		local level = JEXPlayer.getXPLevel('minero')
		local max = 12
		if level >= 4 then
			max = 5
		elseif level == 3 then
			max = 7
		elseif level == 2 then
			max = 9
		elseif level == 1 then
			max = 10
		end
		local rnd = math.random(1, max)
		if rnd == 1 then
			xPlayer.addInventoryItem("carbon", 1)
			TriggerClientEvent("esx:showNotification", source, "Obtuviste un ~y~material ~s~poco común en esta ~o~roca")
		elseif rnd == 2 then
			xPlayer.addInventoryItem("plata", 1)
			TriggerClientEvent("esx:showNotification", source, "Obtuviste un ~y~material ~s~poco común en esta ~o~roca")
		end
	else
		TriggerClientEvent('esx:showNotification', source, "No puedes cargar más minerales de este tipo")
	end
end)

RegisterServerEvent('minar:recibodata')
AddEventHandler('minar:recibodata',function(data)
	rocas = data
	TriggerClientEvent('minar:recibodatacliente',-1,data)
end)

function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent('minar:craft')
AddEventHandler('minar:craft',function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local quantityMineral = xPlayer.getInventoryItem(item)
		if quantityMineral.count >= 30 then
			xPlayer.removeInventoryItem(item,30)
			xPlayer.addInventoryItem("lingote_"..item,15)
			TriggerClientEvent('esx:showNotification', source, "Has conseguido 15 lingotes de "..item)
		elseif quantityMineral.count < 30 and quantityMineral.count > 1 then
			local qtty = quantityMineral.count
			qtty = round(qtty/2-0.1, 0)
			xPlayer.removeInventoryItem(item, qtty*2)
			xPlayer.addInventoryItem("lingote_"..item, qtty)
			TriggerClientEvent('esx:showNotification', source, "Has conseguido "..tostring(qtty).." lingotes de "..item)
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
		if v == "carbon" or v == "hierro" or v == "plata" or v == "oro" then
			level = level + 1
		end
	end
	return level
end

RegisterServerEvent('minar:quitomin')
AddEventHandler('minar:quitomin',function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	for i = 1, #xPlayer.inventory,1 do
		if xPlayer.inventory[i].name == "lingote_oro" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'minero', count*math.random(22,23))
				--xPlayer.addMoney(count*math.random(22,23))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'minero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "plata" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'minero', count*math.random(5,8))
				--xPlayer.addMoney(count*math.random(5,8))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'minero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "lingote_hierro" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'minero', count*math.random(11,13))
				--xPlayer.addMoney(count*math.random(11,13))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'minero', 1*count)
			end
		elseif xPlayer.inventory[i].name == "carbon" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				TriggerEvent('JEX:getPayment', xPlayer.identifier, 'minero', count*math.random(5,8))
				--xPlayer.addMoney(count*math.random(5,8))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('JEX:addXP', xPlayer.identifier, 'minero', 1*count)
			end
		end
	end
end)


function recarocas()
	for i=1, #rocas, 1 do
		if rocas[i].vida < rocas[i].max then
			if rocas[i].vida + 5 > rocas[i].max then 
				rocas[i].vida = rocas[i].max
			else
				rocas[i].vida = rocas[i].vida + 5
			end
		end
	end
	--Sincroniar
	TriggerClientEvent('minar:recibodatacliente',-1,rocas)
end

function loop()
Citizen.CreateThread(function()
	while true do
		recarocas()
		Citizen.Wait(30000)
	Citizen.Wait(0)
	end
end)
end

ESX.RegisterServerCallback("minar:dineroVehiculo", function(playerId, cb, type)
	xPlayer = ESX.GetPlayerFromId(playerId)
	if type == "get" then
		if xPlayer.getMoney() >= ConfigMina.VehicleMoney then
			xPlayer.removeMoney(ConfigMina.VehicleMoney)
			TriggerClientEvent("esx:showNotification", playerId, "Se te ha cobrado una ~o~fianza ~s~de "..tostring(ConfigMina.VehicleMoney).."~g~$ ~s~por el vehículo")
			cb(true)
		else
			xPlayer.removeMoney(ConfigMina.VehicleMoney)
			TriggerClientEvent("esx:showNotification", playerId, "Te ~r~endeudaste ~s~por "..tostring(ConfigMina.VehicleMoney).."~g~$ ~s~de ~o~fianza ~s~para adquirir el vehículo")
			cb(true)
		end
	elseif type == "return" then
		xPlayer.addMoney(ConfigMina.VehicleMoney)
		cb(true)
	end
end)

RegisterServerEvent('minar:ensureWeapon')
AddEventHandler('minar:ensureWeapon', function(todo)
	local xPlayer = ESX.GetPlayerFromId(source)
	if todo == "dar" then
		xPlayer.addWeapon("WEAPON_BATTLEAXE", 1)
	else
		xPlayer.removeWeapon("WEAPON_BATTLEAXE")
	end
end)

loop()


