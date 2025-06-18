-- SCREEN POSITION PARAMETERS
local screenPosX = 0.165                    -- X coordinate (right side of minimap)
local screenPosY = 0.845                    -- Y coordinate (bottom of screen)

-- GENERAL PARAMETERS
local enableController = true               -- Enable controller inputs

-- SPEEDOMETER PARAMETERS
local speedLimit = 65.0                     -- Speed limit for changing speed color
local speedColorText = {196, 196, 196}      -- Color used to display speed label text
local speedColorUnder = {196, 196, 196}     -- Color used to display speed when under speedLimit
local speedColorOver = {255, 96, 96}        -- Color used to display speed when over speedLimit
local speedColorUnderWarn = {242, 185, 39}

-- FUEL PARAMETERS
local fuelShowPercentage = false             -- Show fuel as a percentage (disabled shows fuel in liters)
local fuelWarnLimit = 6.0                   -- Fuel limit for triggering warning color
local fuelColorText = {196, 196, 196}       -- Color used to display fuel text
local fuelColorOver = {196, 196, 196}       -- Color used to display fuel when good
local fuelColorUnder = {255, 96, 96}        -- Color used to display fuel warning

-- GEAR PARAMETERS
local gearColorText = {196, 196, 196}       -- Color used to display gear text

-- CRUISE CONTROL PARAMETERS
local cruiseInput = 137                     -- Toggle cruise on/off with CAPSLOCK or A button (controller)
local cruiseColorOn = {160, 255, 160}       -- Color used when seatbelt is on
local cruiseColorOff = {228, 228, 228}      -- Color used when seatbelt is off

-- LOCATION AND TIME PARAMETERS
local locationAlwaysOn = true              -- Always display location and time
local locationColorText = {228, 228, 228}   -- Color used to display location and time
local laprColorText = {242, 242, 242}

-- Lookup tables for direction and zone
-- local directions = { [0] = 'N', [1] = 'NW', [2] = 'W', [3] = 'SW', [4] = 'S', [5] = 'SE', [6] = 'E', [7] = 'NE', [8] = 'N' }
local directions = { [0] = 'С', [1] = 'СЗ', [2] = 'З', [3] = 'ЮЗ', [4] = 'Ю', [5] = 'ЮВ', [6] = 'В', [7] = 'СВ', [8] = 'С' }
--local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

-- Globals
local pedInVeh = false
local timeText = ""
local locationText = ""
local locationTextHeading = ""
local currentFuel = 0.0

-- Параметры для передачи
local gearText = "P"
local gear = 1
local lastGear = gear
local inVeh = false
local veh = nil
local ped = nil

-- Новые координаты для HUD-элементов (относительно миникарты)
local hudBaseX = screenPosX + 0.065  -- ближе к миникарте
local hudBaseY = screenPosY - 0.13   -- чуть выше центра миникарты
local hudLineStep = 0.045            -- вертикальный отступ между строками

local function getGearText(gearOption)
    if gearOption == 1 then return "P" end
    if gearOption == 2 then return "R" end
    if gearOption == 3 then return "N" end
    if gearOption == 4 then return "D" end
    if gearOption == 5 then return "S" end
    return "?" 
end

RegisterNetEvent("919::SetLimitToCarHud", function(speed)
    -- DEBUG STREETS
    if speed == nil then
        local coords = GetEntityCoords(PlayerPedId())
        local s = string.format("Не найдена улица: %s", GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)))
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"[Ошибка]", s}
        })
        print(s)
        Wait(1000)
    elseif speed == "No Limit" then
        speedLimit = 200.0
    else    
        speedLimit = speed
    end
end)

-- Main thread
Citizen.CreateThread(function()
    -- Initialize local variable
    local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
    local cruiseIsOn = false
    local seatbeltIsOn = false

    while true do
        -- Loop forever and update HUD every frame
        Citizen.Wait(0)

        -- Get player PED, position and vehicle and save to locals
        local player = GetPlayerPed(-1)
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleClass = GetVehicleClass(vehicle)

        -- Set vehicle states
        if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
            
            -- Get current gear and handle gear display
            if GetPedInVehicleSeat(vehicle, -1) == player then
                -- Update speed
                currSpeed = GetEntitySpeed(vehicle)
                
                -- Handle cruise control
                if IsControlJustReleased(0, cruiseInput) and (enableController or GetLastInputMethod(0)) then
                    cruiseIsOn = not cruiseIsOn
                    cruiseSpeed = currSpeed
                end
                local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                SetEntityMaxSpeed(vehicle, maxSpeed)
                
                -- Get gear state
                local isMovingBackwards = GetEntitySpeedVector(vehicle, true).y < -0.5
                local isEngineRunning = GetIsVehicleEngineRunning(vehicle)
                local currentGear = GetVehicleCurrentGear(vehicle)
                
                -- Determine gear text based on vehicle state
                if not isEngineRunning then
                    gearText = "P"
                elseif isMovingBackwards or currentGear == 0 and isEngineRunning then
                    gearText = "R"
                elseif currentGear == 0 and not isMovingBackwards then
                    gearText = "N"
                else
                    gearText = "D"
                end
                
                -- Only display HUD if engine is running and not a bicycle
                if isEngineRunning and vehicleClass ~= 13 then
                    -- Display gear (positioned diagonally above minimap - top left, slightly lowered)
                    drawTxt(gearText, 4, gearColorText, 0.5, screenPosX - 0.045, screenPosY - 0.200)
                    
                    -- Display speed
                    local isMetric = ShouldUseMetricMeasurements()
                    local speed = currSpeed * (isMetric and 3.6 or 2.23694)
                    local speedText = isMetric and "км/ч" or "mph"
                    
                    -- Determine speed color
                    local speedLimit = isMetric and (speedLimit * 1.609344) or speedLimit
                    if speed >= speedLimit then
                        speedColor = speedColorOver
                    elseif speed <= speedLimit - 6.0 then
                        speedColor = speedColorUnder
                    else
                        speedColor = speedColorUnderWarn
                    end
                    
                    -- Format speed display (number only)
                    local speedNumber = ""
                    if speed < 10 then
                        speedNumber = string.format("%.1d", math.ceil(speed))
                    elseif speed < 100 then
                        speedNumber = string.format("%.2d", math.ceil(speed))
                    else
                        speedNumber = string.format("%.3d", math.ceil(speed))
                    end
                    
                    -- Draw speed number (positioned diagonally - middle of diagonal line, raised higher)
                    drawTxt(speedNumber, 4, speedColor, 0.5, screenPosX - 0.025, screenPosY - 0.175)
                    -- Draw speed unit below the number (further increased distance)
                    drawTxt(speedText, 4, speedColorText, 0.35, screenPosX - 0.025, screenPosY - 0.150)
                    
                    -- Draw fuel gauge (positioned diagonally - bottom right of diagonal line, raised higher)
                    local fuelColor = (currentFuel >= fuelWarnLimit) and fuelColorOver or fuelColorUnder
                    -- Всегда показываем в литрах
                    local ceiled_litres = math.ceil(currentFuel)
                    local fuelNumber = ""
                    if ceiled_litres < 10 then
                        fuelNumber = string.format("%.1d", ceiled_litres)
                    else
                        fuelNumber = string.format("%.2d", ceiled_litres)
                    end
                    -- Draw fuel number (raised higher)
                    drawTxt(fuelNumber, 4, fuelColor, 0.5, screenPosX - 0.005, screenPosY - 0.135)
                    -- Draw fuel unit below the number (further increased distance)
                    drawTxt("Л", 4, fuelColorText, 0.35, screenPosX - 0.005, screenPosY - 0.110)
                end
            end
        else
            -- Reset states when not in car
            pedInVeh = false
            cruiseIsOn = false
            seatbeltIsOn = false
        end

        -- Display Location and time when in any vehicle or on foot (if enabled)
        if pedInVeh or locationAlwaysOn then
            if vehicleClass == 15 then -- В ХЕЛИКОПТЕРЕ
                if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                    -- Get time and display
                    drawTxtStreet(timeText, 4, locationColorText, 0.4, screenPosX - 0.135, screenPosY + 0.075)
                    
                    -- Display heading, street name and zone when possible
                    drawTxtStreet(locationText, 4, {219, 219, 219}, 0.45, screenPosX - 0.080, screenPosY + 0.065)
                    drawTxt(locationTextHeading, 4, {219, 219, 219}, 0.5, screenPosX - 0.025, screenPosY + 0.030)
                end
            elseif vehicleClass ~= 15 then -- НЕ В ХЕЛИКОПТЕРЕ
                -- Get time and display
                drawTxtStreet(timeText, 4, locationColorText, 0.4, screenPosX - 0.140, screenPosY + 0.075)
                
                -- Display heading, street name and zone when possible
                drawTxtStreet(locationText, 4, {219, 219, 219}, 0.45, screenPosX - 0.080, screenPosY + 0.065)
                drawTxt(locationTextHeading, 4, {219, 219, 219}, 0.6, screenPosX - 0.025, screenPosY + 0.030)
            end
        end
    end
end)

-- Secondary thread to update strings
Citizen.CreateThread(function()
    while true do
        -- Update when player is in a vehicle or on foot (if enabled)
        if pedInVeh or locationAlwaysOn then
            -- Get player, position and vehicle
            local player = PlayerPedId()
            local position = GetEntityCoords(player)

            -- Update time text string
            local timeScale = 20
            local lastUpdateTime = GetGameTimer()
            
            Citizen.CreateThread(function()
            while true do
            Citizen.Wait(20 * 1000 / timeScale)
            local hour = GetClockHours()
            local minute = GetClockMinutes()
            minute = minute + 1
            
            if minute >= 60 then
            hour = hour + 1
            minute = 0
            end
            
            if hour >= 24 then
            hour = 0
            end
            
            SetClockTime(hour, minute, 0)
            
            local hour = GetClockHours()
            local minute = GetClockMinutes()
            timeText = ("%.2d"):format((hour == 0) and 12 or hour).. ":".. ("%.2d"):format(minute)
            end
            end)

            -- Get heading and zone from lookup tables and street name from hash
            local heading = directions[math.floor((GetEntityHeading(player) + 22.5) / 45.0)]
            --local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
            local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
            
            -- Update location text string
            locationTextHeading = heading
            --locationText = (streetName == "" or streetName == nil) and (locationTextHeading) or (locationTextHeading .. " | " .. streetName)
            locationText = streetName
            --locationText = (zoneNameFull == "" or zoneNameFull == nil) and (locationText) or (locationText .. " | " .. zoneNameFull)

            -- Update fuel when in a vehicle
            if pedInVeh then
                local vehicle = GetVehiclePedIsIn(player, false)
                if fuelShowPercentage then
                    -- Display remaining fuel as a percentage
                    currentFuel = 100 * GetVehicleFuelLevel(vehicle) / GetVehicleHandlingFloat(vehicle,"CHandlingData","fPetrolTankVolume")
                else
                    -- Всегда отображаем топливо в литрах
                    currentFuel = GetVehicleFuelLevel(vehicle)
                end
            end

            -- Update every second
            Citizen.Wait(1000)
        else
            -- Wait until next frame
            Citizen.Wait(0)
        end
    end
end)

-- Helper function to draw text to screen
function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    --SetTextDropShadow(0, 0, 0, 0,255)
    --SetTextDropShadow()
    --SetTextEdge(4, 0, 0, 0, 255)
    
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function drawText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 150)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function drawTxtStreet(content, font, colour, scale, x, y)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    --SetTextDropShadow(0, 0, 0, 0,255)
    --SetTextDropShadow()
    --SetTextEdge(4, 0, 0, 0, 255)
    SetTextCentre(true)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function pluralizeLiters(number)
    remainder10 = number % 10
    remainder100 = number % 100
    
    if remainder10 == 1 and remainder100 ~= 11 then
        return "галлон"
    elseif remainder10 >= 2 and remainder10 <= 4 and (remainder100 < 10 or remainder100 >= 20) then
        return "галлона"
    else
        return "галлонов"
    end
end