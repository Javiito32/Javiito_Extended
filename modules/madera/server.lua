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
	rocas = data
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

RegisterServerEvent('pop_university:setMineLevel')
AddEventHandler('pop_university:setMineLevel',function(skills)
	level = calculateLevel(skills)
	TriggerClientEvent('pop_university:setMineLevel',source,level)
end)

RegisterServerEvent('leñar:quitomin')
AddEventHandler('leñar:quitomin',function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	for i = 1, #xPlayer.inventory,1 do
		if xPlayer.inventory[i].name == "tablon_abedul" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(20,30))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('exp:addExperience',5*count,source)
			end
		elseif xPlayer.inventory[i].name == "tablon_abeto" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(15,25))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('exp:addExperience',5*count,source)
			end
		elseif xPlayer.inventory[i].name == "tablon_nogal" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(15,20))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('exp:addExperience',5*count,source)
			end
		elseif xPlayer.inventory[i].name == "tablon_roble" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(13,15))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('exp:addExperience',3*count,source)
			end
		elseif xPlayer.inventory[i].name == "tablon_pino" then
			if xPlayer.inventory[i].count > 0 then
				local count = xPlayer.inventory[i].count
				xPlayer.addMoney(count*math.random(30,32))
				xPlayer.removeInventoryItem(xPlayer.inventory[i].name,count)
				TriggerEvent('exp:addExperience',3*count,source)
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
	TriggerClientEvent('leñar:recibodatacliente',-1,rocas)
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

ESX.RegisterServerCallback("leñar:dineroVehiculo", function(playerId, cb, type)
	xPlayer = ESX.GetPlayerFromId(playerId)
	if type == "get" then
		if xPlayer.getMoney() >= Config.VehicleMoney then
			xPlayer.removeMoney(Config.VehicleMoney)
			TriggerClientEvent("esx:showNotification", playerId, "Se te ha cobrado una ~o~fianza ~s~de "..tostring(Config.VehicleMoney).."~g~$ ~s~por el vehículo")
			cb(true)
		else
			xPlayer.removeMoney(Config.VehicleMoney)
			TriggerClientEvent("esx:showNotification", playerId, "Te ~r~endeudaste ~s~por "..tostring(Config.VehicleMoney).."~g~$ ~s~de ~o~fianza ~s~para adquirir el vehículo")
			cb(true)
		end
	elseif type == "return" then
		xPlayer.addMoney(Config.VehicleMoney)
		cb(true)
	end
end)

loop()



