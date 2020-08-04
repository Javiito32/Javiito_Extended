local clicks = 0
local roca = nil
local npcvender = true
local level = 3
local fundir = {x = 1110.03, y = -2008.15, z = 31.06}

local JEXMinaLevel = 0

RegisterNetEvent('JEX:setLevel')
AddEventHandler('JEX:setLevel', function(work, level)
    if work == 'minero' then
        JEXMinaLevel = level
    end
end)

local blips = {
    {title="Mina", colour=1, id=653, x = 2952.0, y = 2748.8, z = 43.48-1},
    {title="Fundir lingotes", colour=2, id=653, x = 1110.03, y = -2008.15, z = 31.06-1},
    {title="Venta de minerales", colour=3, id=653, x = 1713.07,y = -1555.44,z = 113.94},
    {title="Vehículo de trabajo", colour=4, id=653, x = 1597.83, y = -1727.66, z = 87.48}
}

RegisterNetEvent('minar:recibodatacliente')
AddEventHandler('minar:recibodatacliente',function(data)
    rocas = data
end)

local job = nil

AddEventHandler("ActualiceBlip", function(_job)
    if _job == "minero" then
        setblipsMina()
    else
        for _, info in pairs(blips) do
            RemoveBlip(info.blip)
        end
    end
    job = _job
end)

Citizen.CreateThread(function()
    local  wanted_model= "A_M_O_Tramp_01"
     modelHash = GetHashKey(wanted_model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
       	Wait(1)
    end
    createNPCMina() 
end)

function createNPCMina()
    --PRIMER NPC
	local created_ped = CreatePed(5, modelHash ,1713.07,-1555.44,112.94,247.88, false, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_SMOKING", 0, true)
end

function AbrirMenuMina()

	local elements = {
		{label = "Sí",value = "yes"},
		{label = "No",value = "no"}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'get_job',
		{
			title  = '¿Quieres que me quede con tus minerales y te de dinero a cambio?',
			align    = 'bottom-right',
			elements = elements
		},
		function(data, menu)	
			if data.current.value == 'yes' then
				TriggerServerEvent('minar:quitomin')
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

local isFunding = false

function craftMina(item)
	isFunding = true
	Citizen.CreateThread(function()
		startAnim("mini@repair", "fixing_a_ped")
		Wait(10000)
		ClearPedTasks(PlayerPedId())
		isFunding = false
		TriggerServerEvent('minar:craft',item)
	end)
end

function AbrirFundirMina()

	local elements = {
		{label = "Fundir hierro",value = "hierro"},
		{label = "Fundir oro",value = "oro"},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fundir',
		{
			title  = '¿Quieres fundir algunos de esos materiales?',
			align    = 'bottom-right',
			elements = elements
		},
		function(data, menu)	
			if data.current.value == 'hierro' and isFunding == false then
                craftMina(data.current.value)
                --[[
			elseif data.current.value == 'plata' and isFunding == false then
                craftMina(data.current.value)
                ]]--
			elseif data.current.value == 'oro' and isFunding == false  then
				craftMina(data.current.value)
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

local cooldown = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if job ~= 'minero' then
            Citizen.Wait(5000)
        elseif job == "minero" and cooldown > 0 then
           Citizen.Wait(100)
           cooldown = cooldown - 100
        end
    end
end)

---------------------------------
--------Ropa de trabajo----------
---------------------------------
function setUniformMina(job, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)
  
      if skin.sex == 0 then
        if ConfigMadera.Uniforms[job].male ~= nil then
          TriggerEvent('skinchanger:loadClothes', skin, ConfigMadera.Uniforms[job].male)
        else
          ESX.ShowNotification(_U('no_outfit'))
        end
      else
        if ConfigMadera.Uniforms[job].female ~= nil then
          TriggerEvent('skinchanger:loadClothes', skin, ConfigMadera.Uniforms[job].female)
        else
          ESX.ShowNotification(_U('no_outfit'))
        end
      end
  
    end)
end

local onservice = false
Citizen.CreateThread(function()
    while true do
        if job == 'minero' then
            if IsPedDead then
                clicks = 0
                roca = nil
            end
            Citizen.Wait(0)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for i=1, #rocas, 1 do
                if GetDistanceBetweenCoords(coords.x,coords.y,coords.z,rocas[i].x,rocas[i].y,rocas[i].z) < 75 then
                    if rocas[i].vida >= 50 then
                    DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Roca de ~b~"..rocas[i].tipo.."~w~ : ~g~"..rocas[i].vida.."/"..rocas[i].max)
                    elseif rocas[i].vida >= 25 then
                    DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Roca de ~b~"..rocas[i].tipo.."~w~ : ~b~"..rocas[i].vida.."/"..rocas[i].max)
                    elseif rocas[i].vida < 25 and rocas[i].vida ~= 0 then
                        DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Roca de ~b~"..rocas[i].tipo.."~w~ : ~y~"..rocas[i].vida.."/"..rocas[i].max)
                    elseif rocas[i].vida <= 0 then
                        DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Roca de ~b~"..rocas[i].tipo.."~w~ : ~r~ "..rocas[i].vida.."/"..rocas[i].max)  
                    end
                end
            end

            if GetCurrentPedWeapon(GetPlayerPed(-1),"WEAPON_BATTLEAXE",true) then
                if IsControlJustReleased(1, 24) then --click izq
                    if cooldown == 0 then
                        for i=1, #rocas, 1 do
                            if GetDistanceBetweenCoords(coords.x,coords.y,coords.z,rocas[i].x,rocas[i].y,rocas[i].z) < 1.8 and rocas[i].vida > 0 then
                                roca = i
                                norock = false
                            end
                        end
                        if roca ~= nil then
                            clickMina()
                            Citizen.Wait(2)
                        end
                        cooldown = 300
                    end
                end
            end

            if get3DDistance(coords.x,coords.y,coords.z,2953.68,2790.68,41.28) > 150 then
                if GetCurrentPedWeapon(GetPlayerPed(-1),"WEAPON_BATTLEAXE",true) then
                    --if job == "minero" then
                        RemoveWeaponFromPed(GetPlayerPed(-1),"WEAPON_BATTLEAXE")
                    --end
                end
            end

            if get3DDistance(coords.x,coords.y,coords.z,fundir.x,fundir.y,fundir.z) < 1.5 then
                DrawText3D(fundir.x,fundir.y,fundir.z, "Pulsa E para fundir")
                if IsControlJustReleased(1,38) and isFunding == false then
                    AbrirFundirMina()
                end
            end

            if get3DDistance(2954.86,2743.08,43.69-1,coords.x,coords.y,coords.z) < 100 then
                DrawMarker(1,2954.86,2743.08,43.69-1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 1.5001, 1555, 132, 23,255, 0, 0, 0,0)
            end
            if get3DDistance(2954.86,2743.08,43.69-1,coords.x,coords.y,coords.z) < 1.5 then
                    if onservice then
                        DisplayHelpText("Presiona ~INPUT_CONTEXT~ para dejar tu herramienta y ropa de trabajo")
                        if IsControlJustReleased(1,38) then
                            RemoveWeaponFromPed(PlayerPedId(), "WEAPON_BATTLEAXE")
                            restoreWear()
                            TriggerEvent('x6stress:workState', false)
                            onservice = false
                            Citizen.Wait(500)
                        end
                    else
                        DisplayHelpText("Presiona ~INPUT_CONTEXT~ para coger tu herramienta y ropa de trabajo")
                        if IsControlJustReleased(1,38) then
                            GiveWeaponToPed(PlayerPedId(), "WEAPON_BATTLEAXE",1,false,true)
                            setUniformMina('job_wear', PlayerPedId())
                            TriggerEvent('x6stress:workState', true)
                            onservice = true
                            Citizen.Wait(500)
                        end
                    end
            end

            if npcvender then
                if get3DDistance(1713.07,-1555.44,113.94,coords.x,coords.y,coords.z) < 20 then
                    DrawText3Dlittle(1713.07,-1555.44,113.94, "Parece que este hombre quiere minerales... ~y~[~w~E~y~]~b~ - Interactuar")
                    if IsControlJustReleased(1,38) then
                        AbrirMenuMina()
                    end
                end
            end

                for k, v in pairs(ConfigMina.Zones) do
                    if get3DDistance(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z) < 100 then
                        DrawMarker(1, v.coords.x,  v.coords.y,  v.coords.z-0.7, 0, 0, 0, 0, 0, 0, v.size, v.size, v.height, v.color.r,v.color.g,v.color.b, 50, 0, 0, 0,0)
                    end
                end
                for k, v in pairs(ConfigMina.Zones) do
                    if get3DDistance(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z) < v.size then
                        DisplayHelpText(v.help)
                        if IsControlJustReleased(1, 38) then
                            if k == "spawnMenu" then
                                if ESX.Game.GetVehiclesInArea(v.area, 3)[1] == nil then
                                    ESX.TriggerServerCallback("minar:dineroVehiculo", function(cb)
                                        if cb then
                                            local spawnCoords = ESX.requestJaviitoSpawn(10.0, 5.0, 10, 39, 6.0)
                                            ESX.Game.SpawnVehicle(ConfigMadera.Vehicle, {x = spawnCoords.x, y = spawnCoords.y, z = spawnCoords.z}, spawnCoords.h, function(vehicle)
                                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
                                            end)
                                            Wait(5000)
                                        end
                                    end, "get")
                                else
                                    ESX.ShowNotification("El área está ocupada por ~r~otro ~o~vehículo")
                                end
                            elseif k == "deleteVehicle" then
                                local playerPed = GetPlayerPed(-1)
                                if IsPedInAnyVehicle(playerPed, false) then
                                    local veh = GetVehiclePedIsIn(playerPed, false)
                                    local _ve = ESX.Game.GetVehicleProperties(veh)
                                    if GetDisplayNameFromVehicleModel(_ve.model) == ConfigMina.DeleteVeh then
                                        ESX.TriggerServerCallback("minar:dineroVehiculo", function(cb)
                                            ESX.Game.DeleteVehicle(veh)
                                        end, "return")
                                    else
                                        ESX.ShowNotification("~r~No ~s~estas en el vehículo de ~o~trabajo")
                                    end
                                else
                                    ESX.ShowNotification("~r~No ~s~estas en ningún ~o~vehículo")
                                end
                            end
                        end
                    end
                end
        else
            Citizen.Wait(5000)
        end
	end
end)


function clickMina()
-- Los clicks habrán que equilibrarlos a la dinámica del servidor
    if roca ~= nil then
        if rocas[roca].level > JEXMinaLevel then
            ESX.ShowNotification("~r~No ~w~puedes picar este tipo de roca con tu nivel actual")
            roca = nil
            return false
        end
        if rocas[roca].vida > 0 then
           if clicks >= 2 then 
                clicks = 0
                rocas[roca].vida = rocas[roca].vida - 1
                TriggerServerEvent('minar:doymineral',rocas[roca].data)
                TriggerServerEvent('minar:recibodata',rocas)
                roca = nil
            else
                clicks = clicks + 1 
                roca = nil
            end
        end
    end

end

function setblipsMina()       
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end