local SpeedLimitEnabled = true
local UIOpen = true

-- TEST COMMAND
--[[
RegisterCommand('speedlimit', function(source, args)
    SpeedLimitEnabled = not SpeedLimitEnabled
end)
]]

RegisterNetEvent("919-speedlimit:client:ToggleSpeedLimit", function(toggle)
    if toggle then
        SendNUIMessage({action = "show"})
        UIOpen = true
        SpeedLimitEnabled = true
    else
        SendNUIMessage({action = "hide"})
        UIOpen = false
        SpeedLimitEnabled = false
    end
end)

RegisterNetEvent("discordcheck:fivepdreturn", function() -- Catch this event for autostart fivepd speedlim event
    TriggerEvent("speedlim:isRU", Config.IsRussian)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local vehicleClass = GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false))
        if IsPedInAnyVehicle(PlayerPedId()) and vehicleClass ~= 15 then
            if SpeedLimitEnabled and not UIOpen then
                SendNUIMessage({action = "show"})
                UIOpen = true
            elseif SpeedLimitEnabled and UIOpen then
                local speed = GetSpeedLimit()
                if speed ~= nil and speed ~= "No Limit" then
                    -- Force Russian style speed limit signs
                    SendNUIMessage({action = "setlimit_ru", speed = speed})
                else
                    -- Force Russian style no limit sign
                    SendNUIMessage({action = "404_ru"})
                end
                TriggerEvent("919::SetLimitToCarHud", speed)
            end
        else
            if SpeedLimitEnabled and UIOpen then
                SendNUIMessage({action = "hide"})
                UIOpen = false
            end
        end
    end
end)

function GetSpeedLimit()
    local coords = GetEntityCoords(PlayerPedId())
    return Config.SpeedLimits[GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))]
end