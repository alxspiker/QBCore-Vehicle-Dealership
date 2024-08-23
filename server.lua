local QBCore = nil
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' has been started.')
    QBCore = exports['qb-core']:GetCoreObject()
    RegisterNetEvent('dealership_system:server:buyVehicle', function(vehicle)
        local src = source
        local pData = QBCore.Functions.GetPlayer(src)
        local cid = pData.PlayerData.citizenid
        local cash = pData.PlayerData.money['cash']
        local bank = pData.PlayerData.money['bank']
        local vehiclePrice = QBCore.Shared.Vehicles[vehicle]['price']
        local plate = GeneratePlate()
        if cash > tonumber(vehiclePrice) then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                pData.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0
            })
            TriggerClientEvent('QBCore:Notify', src, "Vehicle purchased!", 'success')
            TriggerClientEvent('dealership_system:client:buyVehicle', src, vehicle, plate)
            pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-showroom')
        elseif bank > tonumber(vehiclePrice) then
            MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
                pData.PlayerData.license,
                cid,
                vehicle,
                GetHashKey(vehicle),
                '{}',
                plate,
                'pillboxgarage',
                0
            })
            TriggerClientEvent('QBCore:Notify', src, "Vehicle purchased!", 'success')
            TriggerClientEvent('dealership_system:client:buyVehicle', src, vehicle, plate)
            pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-showroom')
        else
            TriggerClientEvent('QBCore:Notify', src, "Not enough money!", 'error')
        end
    end)
end)

function GetFiveMId(player)
    local identifiers = GetPlayerIdentifiers(player)
    for _, v in pairs(identifiers) do
        if string.find(v, "fivem") then
            return v
        end
    end
end

function GetPlayerFromFiveM(fivem_id)
    for _, v in pairs(GetPlayers()) do
        if GetFiveMId(v) == fivem_id then
            return v
        end
    end
end

function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    --print(plate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end
