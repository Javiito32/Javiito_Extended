--en la zona de minas: x troncos con un máximo extraíble. Se regenera con el tiempo, si llega a 0 no puedes minar.
local clicks = 0
local tronco = nil
local npcvender = true --false si no quieres el npc que te lo cambia por dinero
local level = 4
local fundir = {x = -584.23, y = 5285.78, z = 70.26}
local Maderajob
local blips = {
    {title="Aserradero", colour=1, id=238, x = -552.44, y = 5348.45, z = 74.74-1},
    {title="Cortar/empaquetar madera", colour=2, id=238, x = -584.23, y = 5285.78, z = 70.26},
    {title="Venta de madera", colour=3, id=238, x = 1952.27,y = 3841.63,z = 32.18},
    {title="Vehículo de trabajo", colour=4, id=238, x = 1200.33, y = -1274.0, z = 34.70}
}
local JEXMaderaLevel = 0

RegisterNetEvent('JEX:setLevel')
AddEventHandler('JEX:setLevel', function(work, level)
    if work == 'madedero' then
        JEXMaderaLevel = level
    end
end)

RegisterNetEvent('leñar:recibodatacliente')
AddEventHandler('leñar:recibodatacliente',function(data)
    troncos = data
end)

function DrawText3D(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawText3Dlittle(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.5*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

 function get3DDistance(x1, y1, z1, x2, y2, z2)
    local a = (x1 - x2) * (x1 - x2)
    local b = (y1 - y2) * (y1 - y2)
    local c = (z1 - z2) * (z1 - z2)
    return math.sqrt(a + b + c)
end

function createNPCMadera()
    --PRIMER NPC
    local created_ped = CreatePed(5, modelHash ,1953.37,3840.38,31.18,327.48, false, true)
    local created_ped = CreatePed(5, modelHash ,-584.9,5286.17,69.26,88.48, false, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_SMOKING", 0, true)
end

Citizen.CreateThread(function()
    local  wanted_model= "A_M_O_Tramp_01"
     modelHash = GetHashKey(wanted_model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
       	Wait(1)
    end
    createNPCMadera() 
end)

function AbrirMenuMadera()

	local elements = {
		{label = "Sí",value = "yes"},
		{label = "No",value = "no"}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'get_job',
		{
			title  = '¿Quieres que me quede con tu madera y te de dinero a cambio?',
			align    = 'bottom-right',
			elements = elements
		},
		function(data, menu)	
			if data.current.value == 'yes' then
				TriggerServerEvent('leñar:quitomin')
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

local isFunding = false

function craftMadera(item)
	isFunding = true
	Citizen.CreateThread(function()
		startAnim("mini@repair", "fixing_a_ped")
		Wait(10000)
		ClearPedTasks(PlayerPedId())
		isFunding = false
		TriggerServerEvent('leñar:craft',item)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

function AbrirFundirMadera()

	local elements = {
        {label = "Cortar y empaquetar Pino",value = "pino"},
		{label = "Cortar y empaquetar Roble",value = "roble"},
		{label = "Cortar y empaquetar Nogal",value = "nogal"},
		{label = "Cortar y empaquetar Abeto",value = "abeto"},
		{label = "Cortar y empaquetar Abedul",value = "abedul"},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'fundir',
		{
			title  = '¿Quieres cortar y empaquetar algunas de esas maderas?',
			align    = 'bottom-right',
			elements = elements
		},
		function(data, menu)	
			if data.current.value == 'pino' and isFunding == false then
                craftMadera(data.current.value)
            elseif data.current.value == 'roble' and isFunding == false then
				craftMadera(data.current.value)    
			elseif data.current.value == 'nogal' and isFunding == false then
				craftMadera(data.current.value)
			elseif data.current.value == 'abedul' and isFunding == false  then
				craftMadera(data.current.value)
			elseif data.current.value == 'abeto' and isFunding == false  then
				craftMadera(data.current.value)
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
        if Maderajob ~= "madedero" then
            Citizen.Wait(5000)
        elseif Maderajob == "madedero" and cooldown > 0 then
           Citizen.Wait(100)
           cooldown = cooldown - 100
        end
    end
end)

---------------------------------
--------Ropa de trabajo----------
---------------------------------
function setUniformMadera(job, playerPed)
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

function restoreWear()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local model = nil

        if skin.sex == 0 then
          model = GetHashKey("mp_m_freemode_01")
        else
          model = GetHashKey("mp_f_freemode_01")
        end

        RequestModel(model)
        while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(1)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

        TriggerEvent('skinchanger:loadSkin', skin)
        TriggerEvent('esx:restoreLoadout')

        local playerPed = GetPlayerPed(-1)
        -- SetPedArmour(playerPed, 0)
        ClearPedBloodDamage(playerPed)
        ResetPedVisibleDamage(playerPed)
        ClearPedLastWeaponDamage(playerPed)
      end)
end


---------------------------------
local MaderaActionDisabled = false
local onservice = false
Citizen.CreateThread(function()
    while true do
        if Maderajob == 'madedero' then
            if IsPedDead then
                clicks = 0
                tronco = nil
            end
            Citizen.Wait(0)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for i=1, #troncos, 1 do
                local dist = GetDistanceBetweenCoords(coords.x,coords.y,coords.z,troncos[i].x,troncos[i].y,troncos[i].z)
                if dist < 75 then
                    if troncos[i].vida >= 25 then
                        DrawText3D(troncos[i].x,troncos[i].y,troncos[i].z, troncos[i].tipo.." ~g~"..troncos[i].vida.."/"..troncos[i].max)
                    elseif troncos[i].vida >= 12 then
                        DrawText3D(troncos[i].x,troncos[i].y,troncos[i].z,troncos[i].tipo.." ~b~"..troncos[i].vida.."/"..troncos[i].max)
                    elseif troncos[i].vida < 5 and troncos[i].vida ~= 0 then
                        DrawText3D(troncos[i].x,troncos[i].y,troncos[i].z, troncos[i].tipo.." ~o~"..troncos[i].vida.."/"..troncos[i].max)
                    elseif troncos[i].vida >= 0 then
                        DrawText3D(troncos[i].x,troncos[i].y,troncos[i].z, troncos[i].tipo.." ~r~"..troncos[i].vida.."/"..troncos[i].max)  
                    end
                end
            end

            if GetCurrentPedWeapon(GetPlayerPed(-1),"WEAPON_HATCHET",true) then
                if IsControlJustReleased(1,  24) then --click izq
                    if cooldown == 0 then
                        for i=1, #troncos, 1 do
                            local dist = GetDistanceBetweenCoords(coords.x,coords.y,coords.z,troncos[i].x,troncos[i].y,troncos[i].z)
                            if dist < 1.8 and troncos[i].vida > 0 then
                                tronco = i
                            end
                        end
                        if tronco ~= nil then
                            clickMadera()
                            Citizen.Wait(2)
                        end
                        cooldown = 300
                    end
                end
            end

            if get3DDistance(coords.x,coords.y,coords.z,-552.44,  5348.45,  73.74) > 2000 then
                if GetCurrentPedWeapon(GetPlayerPed(-1),"WEAPON_HATCHET", true) then
                    --if Maderajob == "madedero" then
                        RemoveWeaponFromPed(GetPlayerPed(-1),"WEAPON_HATCHET")
                    --end
                end
            end

            if get3DDistance(coords.x,coords.y,coords.z,fundir.x,fundir.y,fundir.z) < 1.5 then
                DrawText3D(fundir.x,fundir.y,fundir.z, "Pulsa E para cortar y empaquetar")
                if IsControlJustReleased(1,38) and isFunding == false then
                    AbrirFundirMadera()
                end
            end

            if get3DDistance( -552.44,  5348.45,  73.74,coords.x,coords.y,coords.z) < 100 then
                DrawMarker(1,-552.44,  5348.45,  73.74, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 1.5001, 1555, 132, 23,255, 0, 0, 0,0)
            end
            if get3DDistance(-552.44,  5348.45,  73.74,coords.x,coords.y,coords.z) < 1.5 then
                if onservice then
                    DisplayHelpText("Presiona ~INPUT_CONTEXT~ para dejar tu herramienta y ropa de trabajo")
                    if IsControlJustReleased(1,38) then
                        RemoveWeaponFromPed(GetPlayerPed(-1),"WEAPON_HATCHET")
                        restoreWear()
                        TriggerEvent('x6stress:workState', false)
                        onservice = false
                        Citizen.Wait(500)
                    end
                else
                    DisplayHelpText("Presiona ~INPUT_CONTEXT~ para coger tu herramienta y ropa de trabajo")
                    if IsControlJustReleased(1,38) then
                        GiveWeaponToPed(GetPlayerPed(-1),"WEAPON_HATCHET",1,false,true)
                        setUniformMadera('job_wear', GetPlayerPed(-1))
                        TriggerEvent('x6stress:workState', true)
                        onservice = true
                        Citizen.Wait(500)
                    end
                end
            end

            if npcvender then
                if get3DDistance(1952.27, 3841.63, 32.18,coords.x,coords.y,coords.z) < 20 then
                    DrawText3Dlittle(1952.27, 3841.63, 32.18, "Te compro tu madera, quieres vender?... ~y~[~w~E~y~]~b~ - Interactuar")
                    if IsControlJustReleased(1,38) then
                        AbrirMenuMadera()
                    end
                end
            end

            for k, v in pairs(ConfigMadera.Zones) do
                if get3DDistance(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z) < 100 then
                    DrawMarker(1, v.coords.x,  v.coords.y,  v.coords.z-0.7, 0, 0, 0, 0, 0, 0, v.size, v.size, v.height, v.color.r,v.color.g,v.color.b, 50, 0, 0, 0,0)
                end
            end
            for k, v in pairs(ConfigMadera.Zones) do
                if get3DDistance(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z) < v.size then
                    DisplayHelpText(v.help)
                    if IsControlJustReleased(1, 38) and not MaderaActionDisabled then
                        if k == "spawnMenu" then
                            if ESX.Game.GetVehiclesInArea(v.area, 2)[1] == nil then
                                ESX.TriggerServerCallback("leñar:dineroVehiculo", function(cb)
                                    if cb then
                                        MaderaActionDisabled = true
                                        local spawnCoords = ESX.requestJaviitoSpawn(10.0, 5.0, 10, 39, 6.0)
                                        ESX.Game.SpawnVehicle(ConfigMadera.Vehicle, {x = spawnCoords.x, y = spawnCoords.y, z = spawnCoords.z}, spawnCoords.h, function(vehicle)
                                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
                                            MaderaActionDisabled = false
                                            Citizen.Wait(500)
                                        end)
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
                                if GetDisplayNameFromVehicleModel(_ve.model) == ConfigMadera.DeleteVeh then
                                    ESX.TriggerServerCallback("leñar:dineroVehiculo", function(cb)
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

function clickMadera()
-- Los clicks habrán que equilibrarlos a la dinámica del servidor
    if tronco ~= nil then
        if troncos[tronco].level > JEXMaderaLevel then
            ESX.ShowNotification("~r~No ~w~puedes talar este tipo de arbol con tu nivel actual")
            tronco = nil
            return false
        end
        if troncos[tronco].vida > 0 then
           if clicks >= 2 then 
                clicks = 0
                troncos[tronco].vida = troncos[tronco].vida - 1
                TriggerServerEvent('leñar:doymineral',troncos[tronco].data)
                TriggerServerEvent('leñar:recibodata',troncos)
                tronco = nil
            else
                clicks = clicks + 1 
                tronco = nil
            end
        end
    end

end
 
function setblipsMadera()       
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

AddEventHandler("ActualiceBlip", function(_job)
    if _job == "madedero" then
        setblipsMadera()
    else
        for _, info in pairs(blips) do
            RemoveBlip(info.blip)
        end
    end
    Maderajob = _job
end)