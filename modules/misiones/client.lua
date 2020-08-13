ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
--------------------

local timer = 0
local actual = nil

function markblips()
    for i=1, #Config.Missions, 1 do
        ESX.TriggerServerCallback('x6crime:getLicense', function(haslicense)
            if haslicense then
                --blip poner blip en el mapa en coordst y coordsa con el tipo blipt y blipa
            end
        end, Config.Missions[i].license)
    end
end

function markerst()
    local coords2 = GetEntityCoords(GetPlayerPed(-1))
    for i=1, #Config.Missions, 1 do
        local tspace2 = GetDistanceBetweenCoords(coords2, Config.Missions[i].coordst)
        --local aspace2 = GetDistanceBetweenCoords(coords2, Config.Missions[i].coordsa)
        --ESX.TriggerServerCallback('x6crime:getLicense', function(haslicense)
        --    if haslicense then
                if tspace2 < 5 then
                    DrawMarker(1, Config.Missions[i].coordst.x, Config.Missions[i].coordst.y, Config.Missions[i].coordst.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                end
        --    end
        --end, Config.Missions[i].license)
    end
end

function markersa()
    local coords2 = GetEntityCoords(GetPlayerPed(-1))
    for i=1, #Config.Missions, 1 do
        --local tspace2 = GetDistanceBetweenCoords(coords2, Config.Missions[i].coordst)
        local aspace2 = GetDistanceBetweenCoords(coords2, Config.Missions[i].coordsa)
        --ESX.TriggerServerCallback('x6crime:getLicense', function(haslicense)
        --    if haslicense then
                if aspace2 < 5 then
                    DrawMarker(1, Config.Missions[i].coordsa.x, Config.Missions[i].coordsa.y, Config.Missions[i].coordsa.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                end
        --    end
        --end, Config.Missions[i].license)
    end
end

function tmenu(quantity, price, time, drug, title)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tmenu', 
	{
		title = 'Misión',
		align = 'bottom-right',
		elements = {
            {label = "Transporte de droga ^5"..price.." $" , value = "start"}
		}
	},
	function(data, menu)
        if data.current.value == "start" then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Confirmacion', 
            {
                title = '¿Deseas continuar?',
                align = 'bottom-right',
                elements = {
                    {label = "Sí", value = "yes"},
                    {label = "No", value = "no"}
                }
            },
            function(data, menu)
                if data.current.value == "yes" then
                    --timer = time
                    TriggerServerEvent('MissionStart', quantity, drug, price, time, title)
                elseif data.current.value == "no" then
                    ESX.ShowNotification("No me hagas perder el tiempo y decidete")
                    menu.close()
                end
                menu.close()
            end, 
            function(data, menu)
                menu.close()
            end)
        end
		menu.close()
	end, 
	function(data, menu)
		menu.close()
	end)
end

function amenu(title, quantity, drug, reward)
    if title == actual and timer > 0 then
        ESX.ShowNotification("Descargando mercancia...")
        Citizen.Wait(5000)
        actual = nil
        TriggerServerEvent("MissionCompleted", quantity, drug, reward)
    elseif title == actual and timer <= 0 then
        ESX.ShowNotification("Llegaste tarde, no me gusta la impuntualidad")
        actual = nil
    elseif title ~= actual then
        ESX.ShowNotification("¿Que es eso?, espabila y no me traigas cosas que no son mias")
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        --markblips()
        markerst()
        markersa()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if timer > 0 then
            timer = timer - 1
        end
    end
end)

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local pcoord = GetEntityCoords(GetPlayerPed(-1), 1)
        for i=1, #Config.Missions, 1 do
            ESX.TriggerServerCallback('x6crime:getLicense', function(haslicense)
                if haslicense then
                    local spacet = GetDistanceBetweenCoords(pcoord.x, pcoord.y, pcoord.z, Config.Missions[i].coordst.x, Config.Missions[i].coordst.y, Config.Missions[i].coordst.z)
                    local spacea = GetDistanceBetweenCoords(pcoord.x, pcoord.y, pcoord.z, Config.Missions[i].coordsa.x, Config.Missions[i].coordsa.y, Config.Missions[i].coordsa.z)
                    if spacet < 5 then
                        ESX.ShowHelpNotification('Pulsa ~INPUT_CONTEXT~ para ver la misión')
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsControlJustReleased() then
                            ESX.ShowNotification("Ten algo de respeto y baja del coche para hablar")
                            tmenu(Config.Missions[i].qtty, Config.Missions[i].price, Config.Missions[i].time, Config.Missions[i].drug, Config.Missions[i].title)
                    elseif spacea < 5 then
                        ESX.ShowHelpNotification('Pulsa ~INPUT_CONTEXT~ para entregar la misión')
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsControlJustReleased() then
                            ESX.ShowNotification("Ten algo de respeto y baja del coche para hablar")
                            amenu(Config.Missions[i].title, Config.Missions[i].qtty, Config.Missions[i].drug, Config.Missions[i].reward)
                        else
                    end
                end
            end, Config.Missions[i].license)
        end
    end
end)]]--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local pcoord = GetEntityCoords(GetPlayerPed(-1), 1)
        for i=1, #Config.Missions, 1 do
            local spacet = GetDistanceBetweenCoords(pcoord.x, pcoord.y, pcoord.z, Config.Missions[i].coordst.x, Config.Missions[i].coordst.y, Config.Missions[i].coordst.z)
            if spacet < 5 then
                ESX.ShowHelpNotification('Pulsa ~INPUT_CONTEXT~ para ver la misión')
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsControlJustReleased(0, 38) then
                    ESX.ShowNotification("Ten algo de respeto y baja del coche para hablar")
                elseif not IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback('esx_license:checkLicense', function(haslicense)
                        if haslicense then
                        tmenu(Config.Missions[i].qtty, Config.Missions[i].price, Config.Missions[i].time, Config.Missions[i].drug, Config.Missions[i].title)
                        else
                            ESX.ShowNotification("Yo no te conozco, largo de aquí")
                        end
                end, GetPlayerServerId(), Config.Missions[i].license)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local pcoord = GetEntityCoords(GetPlayerPed(-1), 1)
        for i=1, #Config.Missions, 1 do
            local spacea = GetDistanceBetweenCoords(pcoord.x, pcoord.y, pcoord.z, Config.Missions[i].coordsa.x, Config.Missions[i].coordsa.y, Config.Missions[i].coordsa.z)
            if spacea < 5 then
                ESX.ShowHelpNotification('Pulsa ~INPUT_CONTEXT~ para ver la misión')
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsControlJustReleased(0, 38) then
                    ESX.ShowNotification("Ten algo de respeto y baja del coche para hablar")
                elseif not IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback('esx_license:checkLicense', function(haslicense)
                        if haslicense then
                            amenu(Config.Missions[i].title, Config.Missions[i].qtty, Config.Missions[i].drug, Config.Missions[i].reward)
                        else
                            ESX.ShowNotification("Yo no te conozco, largo de aquí")
                        end
                    end, GetPlayerServerId(), Config.Missions[i].license)
                end
            end
        end
    end
end)



RegisterNetEvent('MissionContinue')
AddEventHandler('MissionContinue', function(time, title)
    actual = title
    timer = time
end)