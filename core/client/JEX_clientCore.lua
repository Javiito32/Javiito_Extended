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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local blip = {}

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
        if i = #Config.Business[job].initial_pay then
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
end

RegisterNetEvent('JEX:businessRemember')
AddEventHandler('JEX:businessRemember', function(job)
	rememberBusiness(job)
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