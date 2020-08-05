-- Main ESX Integrations Needed
ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
	TriggerServerEvent('JEX:CheckPlayer')
end)

local blip = {}
local activebusiness = nil
local awaitingbusiness = nil

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	activebusiness = nil
	awaitingbusiness = nil
	TriggerServerEvent("JEX:checkBusiness", job.name)
end)

RegisterNetEvent("JEX:BusinessChecked")
AddEventHandler("JEX:BusinessChecked", function(has, stock)
	if has then
		if stock == nil then
			rememberBusiness(PlayerData.job.name)
		else
			activebusiness = PlayerData.job.name
		end
	end
end)

function setblip(name, label, coords, type, colour)       
	blip[name] = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip[name], type)
	SetBlipDisplay(blip[name], 4)
	SetBlipScale(blip[name], 0.9)
	SetBlipColour(blip[name], colour)
	SetBlipAsShortRange(blip[name], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(label)
	EndTextCommandSetBlipName(blip[name])
end

-- Business XP integration

function rememberBusiness(job)
	local requerimentsString = ""
    for i=1, #Config.Business[job].initial_pay, 1 do
        if i == #Config.Business[job].initial_pay then
            requerimentsString = requerimentsString:sub(1, -2)
            requerimentsString = requerimentsString.." y "..tostring(Config.Business[job].initial_pay[i].value).." de "..Config.Business[job].initial_pay[i].item
        else
            requerimentsString = requerimentsString.." "..tostring(Config.Business[job].initial_pay[i].value).." de "..Config.Business[job].initial_pay[i].item..","
        end
    end
	TriggerEvent('chat:addMessage', {
        color = { 255,165,0 },
        multiline = true,
        args = {"Solicitud de mercancia | ", "Traeme "..requerimentsString.." para poder comenzar a obtener beneficios"}
	})
	setblip("businessTask", "Entrega de Mercancia", Config.Business[job].pos, 133, 5)
	SetNewWaypoint(Config.Business[job].pos.x, Config.Business[job].pos.y)

	awaitingbusiness = job
end

RegisterNetEvent('JEX:businessRemember')
AddEventHandler('JEX:businessRemember', function(job)
	rememberBusiness(job)
end)

RegisterNetEvent('JEX:businessIsOwned')
AddEventHandler('JEX:businessIsOwned', function(job)
	activebusiness = job
	awaitingbusiness = nil
end)

RegisterNetEvent('JEX:BusinessBought')
AddEventHandler('JEX:BusinessBought', function(job)
	activebusiness = job
	awaitingbusiness = nil
	RemoveBlip("businessTask")
	ESX.ShowNotification("Has ~g~desbloqueado~w~ el negocio correctamente, como cortesía te hemos regalado 10 de stock")
	ESX.ShowNotification("Ven aquí siempre que quieras para comprar más stock")
end)

RegisterNetEvent('JEX:BusinessUnlock')
AddEventHandler('JEX:BusinessUnlock', function(job)
	TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Nuevo Desbloqueo | ", "Has desbloqueado el negocio de "..getLabelFromWork(job)}
	})
    --for k, v in pairs(Config.Business[job].initial_pay) do
    --    requerimentsString = requerimentsString.." "..tostring(v).." de "..k..","
	--end
	rememberBusiness(job)
end)

function openBusinessMenu(job)
	ESX.TriggerServerCallback("JEX:getBusinessStock", function(stock)
		local _elements = {
			{label = 'Comprar Stock', label_real = 'buystock', value = 1, type = 'slider', min = 1, max = 100},
			{label = "Stock: "..tostring(stock), value = ''},
			{label = "-- Precio del Stock --"},
			
		}
		for k, v in pairs(Config.Business[job].stock_price) do
			if v.value == 1 then
				table.insert(_elements, {label = "Uno de "..v.label})
			else
				table.insert(_elements, {label = v.value.." de "..v.label})
			end
		end
		
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'business_boss',
        {
            title = job,
            align = 'bottom-right',
            elements = _elements

        }, function(data, menu)
			if data.current.label_real == 'buystock' then
				if stock + data.current.value <= Config.maxStock then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'business_confirm_stock', {
						title    = ("¿Estas seguro que quieres comprar "..data.current.value.." de stock?"),
						align    = 'bottom-right',
						elements = {
							{label = 'No',  value = 'no'},
							{label = 'Sí', value = 'yes'},
						}
					}, function(data2, menu2)
						if data2.current.value == 'yes' then
							TriggerServerEvent('JEX:buyBusinessStock', job, data.current.value)
							menu2.close()
							menu.close()
						end
					end, function(data2, menu2) menu2.close() end)
				else
					ESX.ShowNotification("~r~No ~w~puedes superar los "..Config.maxStock.." de stock")
				end
            end
        end, function(data, menu)
            menu.close()
        end)
    end, job)
end

-- Main Thread of Business
Citizen.CreateThread(function()
	while not PlayerData do
		print(100)
		Citizen.Wait(500)
	end
	while true do
		local sleepThread = 1
		local plyPos = GetEntityCoords(GetPlayerPed(-1))
		
		if activebusiness ~= nil then
			local dist = GetDistanceBetweenCoords(plyPos, Config.Business[activebusiness].pos, true)
			if dist < 5 then
				DrawMarker(1, Config.Business[activebusiness].pos.x,  Config.Business[activebusiness].pos.y,  Config.Business[activebusiness].pos.z, 0, 0, 0, 0, 0, 0, Config.Business[activebusiness].size, Config.Business[activebusiness].size, Config.Business[activebusiness].size, 1555, 132, 23,255, 0, 0, 0,0)
				if dist < Config.Business[activebusiness].size then
					ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ para abrir el menú del negocio")
					if IsControlJustReleased(0, 38) then
						openBusinessMenu(activebusiness)
					end
				end
			end
			if dist > 30 then
				sleepThread = 5000
			end
		end

		if awaitingbusiness ~= nil then
			local dist = GetDistanceBetweenCoords(plyPos, Config.Business[awaitingbusiness].pos, true)
			if dist < 5 then
				DrawMarker(1, Config.Business[awaitingbusiness].pos.x,  Config.Business[awaitingbusiness].pos.y,  Config.Business[awaitingbusiness].pos.z, 0, 0, 0, 0, 0, 0, Config.Business[awaitingbusiness].size, Config.Business[awaitingbusiness].size, Config.Business[awaitingbusiness].size, 1555, 132, 23,255, 0, 0, 0,0)
				if dist < Config.Business[awaitingbusiness].size then
					ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ para entregar la mercancía")
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent('JEX:buyBusiness', awaitingbusiness)
					end
				end
			end
			if dist > 30 then
				sleepThread = 5000
			end
		end
		Citizen.Wait(sleepThread)
	end
end)