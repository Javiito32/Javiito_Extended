local workingInProgress = false
local JEXFishingLevel = 0
local FishingJob
local VehicleBlip
local SellBlip

function setBlips()
    local VehicleBlip = AddBlipForCoord(ConfigFishing.Zones.VehicleSpawner.Pos.x, ConfigFishing.Zones.VehicleSpawner.Pos.y, ConfigFishing.Zones.VehicleSpawner.Pos.z)
    SetBlipSprite  (VehicleBlip, 68)
    SetBlipDisplay (VehicleBlip, 4)
    SetBlipScale   (VehicleBlip, 1.2)
    SetBlipCategory(VehicleBlip, 3)
    SetBlipColour  (VehicleBlip, 1)
    SetBlipAsShortRange(VehicleBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehículo para la pesca")
    EndTextCommandSetBlipName(VehicleBlip)

    local SellBlip = AddBlipForCoord(ConfigFishing.Zones.SellPoint.Pos.x, ConfigFishing.Zones.SellPoint.Pos.y, ConfigFishing.Zones.SellPoint.Pos.z)
    SetBlipSprite  (SellBlip, 68)
    SetBlipDisplay (SellBlip, 4)
    SetBlipScale   (SellBlip, 1.2)
    SetBlipCategory(SellBlip, 3)
    SetBlipColour  (SellBlip, 2)
    SetBlipAsShortRange(SellBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Venta de Pescados")
    EndTextCommandSetBlipName(SellBlip)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    FishingJob = job.name
    if job.name == 'fisherman' then
        setBlips()
    else
        DeleteBlip(VehicleBlip)
        DeleteBlip(SellBlip)
    end
end)

local VehicleOfTheJob
local disableControl = false

RegisterNetEvent('JEX:setLevel')
AddEventHandler('JEX:setLevel', function(work, level)
    if work == 'fisherman' then
        JEXFishingLevel = level
    end
end)

function setUniformPesca(job, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)
  
      if skin.sex == 0 then
        if ConfigFishing.Uniforms[job].male ~= nil then
          TriggerEvent('skinchanger:loadClothes', skin, ConfigFishing.Uniforms[job].male)
        else
          ESX.ShowNotification(_U('no_outfit'))
        end
      else
        if ConfigFishing.Uniforms[job].female ~= nil then
          TriggerEvent('skinchanger:loadClothes', skin, ConfigFishing.Uniforms[job].female)
        else
          ESX.ShowNotification(_U('no_outfit'))
        end
      end
  
    end)
end

function GetClosestFishPoint()
    local plyPos = GetEntityCoords(GetPlayerPed(-1))
    local distances = {}
    for k, v in pairs(ConfigFishing.FishPoint) do
        table.insert(distances, {key = k, distance = GetDistanceBetweenCoords(v.x, v.y, v.z, plyPos.x, plyPos.y, plyPos.z, true)})
    end
    table.sort(distances, function(a,b) return a.distance < b.distance end)
    local RandomNumber = math.random(1, 3)
    return ConfigFishing.FishPoint[distances[RandomNumber].key]
end

local TotalFishedPoints = 0

function PointFishing(point)
    SetNewWaypoint(point.x, point.y)
    local playerPos = GetEntityCoords(GetPlayerPed(-1))
    local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, point.x, point.y, point.z, true)
    local draw = true
    Citizen.CreateThread(function()
        while draw and workingInProgress do
            Citizen.Wait(1)
            DrawMarker(1, point.x,  point.y,  point.z-1.5, 0, 0, 0, 0, 0, 0, 10.0, 10.0, 3.0, 215, 215, 103, 255, 0, 0, 0,0)
        end
    end)
    while workingInProgress and distance > 10 do
        playerPos = GetEntityCoords(GetPlayerPed(-1))
        distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, point.x, point.y, point.z, true)
        Wait(500)
    end
    playerPos = GetEntityCoords(GetPlayerPed(-1))
    distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, point.x, point.y, point.z, true)
    if distance <= 10 then
        draw = false
        local complete = false
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Fishing",
            duration = ConfigFishing.TimeToFish, -- 1000ms * x seconds
            label = "Pescando pececillos",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false,
            }
            
        }, function(status)
            complete = true
            if GetVehiclePedIsIn(GetPlayerPed(-1), false) == VehicleOfTheJob then
                TriggerServerEvent('JEX:addFishes', JEXFishingLevel)
            else
                ESX.ShowNotification("No puedes pescar sin el barco de trabajo, ve al siguiente punto con el")
            end
        end)
        TotalFishedPoints = TotalFishedPoints + 1
        while not complete and workingInProgress do
            Wait(500)
        end
        if workingInProgress then
            FishSessionStart()
        end
    end
end

function FishSessionStart()
    if TotalFishedPoints < ConfigFishing.Max then
        ESX.ShowNotification("Ve al punto de pesca para pescar algun pececillo")
        local nextPoint = GetClosestFishPoint()
        PointFishing(nextPoint)
    else
        ESX.ShowNotification("Vuelve al puerto a devolver el barco para vender tu pescado")
        TotalFishedPoints = 0
        SetNewWaypoint(ConfigFishing.Zones.VehicleCollect.Pos.x, ConfigFishing.Zones.VehicleCollect.Pos.y)
    end
end

function ControlAction(action)
    if action == 'VehicleSpawner' then
        local spawnCoords = ESX.requestJaviitoSpawn(35.0, 15.0, 20, 35, 20.0)
        DoScreenFadeOut(500)
        Wait(1000)
        setUniformPesca('job_wear', GetPlayerPed(-1))
        ESX.Game.SpawnVehicle(ConfigFishing.Vehicle, {x = spawnCoords.x, y = spawnCoords.y, z = spawnCoords.z}, spawnCoords.h, function(vehicle)
            VehicleOfTheJob = vehicle
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
        end)
        DoScreenFadeIn(500)
        workingInProgress = true
        disableControl = false
        FishSessionStart()
    elseif action == 'SellPoint' then
        disableControl = false
        TriggerEvent("mythic_progbar:client:progress", {
            name = "RobbingTheBank",
            duration = ConfigFishing.TimeToSell, -- 1000ms * x seconds
            label = "Vendiendo la mercancía",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 49
            }
        }, function(status)
            TriggerServerEvent('JEX:sellFishes', JEXFishingLevel)
        end)
    elseif action == 'VehicleCollect' then
        disableControl = false
        local PlayerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(PlayerPed, false)
        if vehicle == VehicleOfTheJob then 
            DoScreenFadeOut(500)
            Wait(1000)
            DeleteEntity(vehicle)
            vehicle = nil
            restoreWear()
            SetEntityCoords(PlayerPed, ConfigFishing.Zones[action].tp.x, ConfigFishing.Zones[action].tp.y, ConfigFishing.Zones[action].tp.z)
            DoScreenFadeIn(500)
            TotalFishedPoints = 0
            endAllLoops = true
            Wait(500)
            endAllLoops = false
            workingInProgress = false
        else
            ESX.ShowNotification("Este vehíulo ~r~no es~w~ el que te hemos ofrecido para realizar el trabajo")
        end
    end
end

-- Actions Thread
Citizen.CreateThread(function()
    while true do
        if FishingJob == 'fisherman' then
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(ConfigFishing.Zones) do
                local distance = GetDistanceBetweenCoords(v.Pos, playerPos, true)
                if distance < v.DrawDistance then
                    DrawMarker(1, v.Pos.x,  v.Pos.y,  v.Pos.z-1, 0, 0, 0, 0, 0, 0, v.size, v.size, v.size, v.color.r, v.color.g, v.color.b,255, 0, 0, 0,0)
                    if distance <= v.size then
                        if v.workInProgress == workingInProgress then
                            ESX.ShowHelpNotification(v.HelpMessage)
                            if IsControlJustReleased(0, 38) and not disableControl then
                                disableControl = true
                                Citizen.CreateThread(function()
                                    ControlAction(k)
                                end)
                            end
                        elseif v.NoHelpMessage ~= nil then
                            ESX.ShowHelpNotification(v.NoHelpMessage)
                        end
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(5000)
        end
    end
end)