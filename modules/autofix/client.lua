Citizen.CreateThread(function()
    while true do
        local plyPos = GetEntityCoords(GetPlayerPed(-1))
        local dist = GetDistanceBetweenCoords(plyPos.x, plyPos.y, plyPos.z, 304.24, -586.6, 43.28, true)
        if dist < 10 then
            if plyPos.z < 42.10 then
                SetEntityCoords(GetPlayerPed(-1), 303.43, -609.46, 44.35)
            end
        elseif dist > 50 then
            Citizen.Wait(500)
        end
        Citizen.Wait(10)
    end
end)