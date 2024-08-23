local QBCore = nil
local closestDealerShip = nil
local closestDealerShipKey = nil
QBCore = exports['qb-core']:GetCoreObject()

RegisterNuiCallbackType("get_vehicles")
RegisterNUICallback("get_vehicles", function(data, cb)
    Citizen.CreateThread(function()
        local shop = data.shop
        local vehicles = QBCore.Shared.Vehicles
        local shopVehicles = {}
        for k, v in pairs(vehicles) do
            if v["shop"] == shop then
                table.insert(shopVehicles, v)
            end
        end
        cb({vehicles=shopVehicles})
    end)
end)

RegisterNuiCallbackType("buy_vehicle")
RegisterNUICallback("buy_vehicle", function(data, cb)
    TriggerServerEvent("dealership_system:server:buyVehicle", data.vehicle)
    cb(true)
end)

RegisterNetEvent('dealership_system:client:buyVehicle', function(vehicle, plate)
    local vehicleSpawnPoint = closestDealerShip.spawnpoint
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        exports['ti_fuel']:setFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, vehicleSpawnPoint.w)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
        --TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
    end, vehicle, vehicleSpawnPoint, true)
end)

for k, v in pairs(Config.dealerships) do
    local dealership = Config.dealerships[k]
    local dealershipBlip = AddBlipForCoord(dealership.coords)
    SetBlipSprite(dealershipBlip, dealership.blip)
    SetBlipDisplay(dealershipBlip, 4)
    SetBlipScale(dealershipBlip, 1.0)
    SetBlipColour(dealershipBlip, dealership.color)
    SetBlipAsShortRange(dealershipBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(dealership.name)
    EndTextCommandSetBlipName(dealershipBlip)
end

Citizen.CreateThread(function()
    while true do
        GetClosestDealerShip()
        Wait(15000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local dealership = closestDealerShip
        if dealership == nil then
            Wait(2000)
            return
        end
        local distance = #(playerCoords - dealership.coords)
        if distance < 5.0 then
            DrawMarker(dealership.marker.type, dealership.coords.x, dealership.coords.y, dealership.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, dealership.marker.scale.x, dealership.marker.scale.y, dealership.marker.scale.z, 255/dealership.marker.color.x, 255/dealership.marker.color.y, 255/dealership.marker.color.z, 100, false, true, 2, false, false, false, false)
            if distance < 3 then
                local screenCoords, sX, sY = GetScreenCoordFromWorldCoord(dealership.coords.x, dealership.coords.y, dealership.coords.z + 1) -- returns boolean (if found), [2], [3]
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.5)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString("Press E to open the dealership")
                if screenCoords then
                    DrawText(sX, sY)
                else
                    DrawText(0.5, 0.5)
                end
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("dealership_system:Client:OpenScreen", closestDealerShipKey, closestDealerShip)
                end
            end
            Wait(0)
        else
            Wait(2000)
        end
    end
end)

function GetClosestDealerShip()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    local dealerships = Config.dealerships
    local closestkey = nil
    local closest = nil
    local distance = nil
    for k, v in pairs(dealerships) do
        local dist = #(playerCoords - v.coords)
        if not distance or dist < distance then
            distance = dist
            closest = v
            closestkey = k
        end
    end
    closestDealerShip = closest
    closestDealerShipKey = closestkey
end

-- Screen stuff
local screenisopen = false

function ToggleScreen(dealerkey, dealer)
    screenisopen = not screenisopen
    SetNuiFocus(screenisopen, screenisopen)
    SendNUIMessage({
        type = 'toggle_screen',
        value = screenisopen,
        dealership = dealerkey or nil,
        dealerdata = dealer or nil
    })
end

RegisterNetEvent("dealership_system:Client:OpenScreen")
AddEventHandler("dealership_system:Client:OpenScreen", function(dealerkey, dealer)
    ToggleScreen(dealerkey, dealer)
end)

RegisterNuiCallbackType("toggle_screen")
RegisterNUICallback("toggle_screen", function(data, cb)
    ToggleScreen()
    cb("ok")
end)