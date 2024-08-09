local QBCore = exports['qb-core']:GetCoreObject()

-- Create a ped at the location specified in config.lua
Citizen.CreateThread(function()
    local pedModel = Config.Ped.model
    local pedPosition = Config.Ped.position
    local pedHeading = Config.Ped.heading

    RequestModel(GetHashKey(pedModel))
    while not HasModelLoaded(GetHashKey(pedModel)) do
        Wait(1)
    end

    local ped = CreatePed(4, GetHashKey(pedModel), pedPosition.x, pedPosition.y, pedPosition.z, pedHeading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- Add the ped as an interactive target
    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = "8L0R3_Store:openMainMenu",
                icon = "fas fa-exchange-alt",
                label = " " .. Config.Ped.name
            },
        },
        distance = 2.5
    })
end)

-- Opening the main menu when interacting with the ped
RegisterNetEvent('8L0R3_Store:openMainMenu')
AddEventHandler('8L0R3_Store:openMainMenu', function()
    OpenMainMenu()
end)

RegisterNetEvent('8L0R3_Store:attemptVehicleExchange')
AddEventHandler('8L0R3_Store:attemptVehicleExchange', function(vehicleKey)
    TriggerServerEvent('8L0R3_Store:attemptVehicleExchange', vehicleKey)
end)

RegisterNetEvent('8L0R3_Store:attemptItemExchange')
AddEventHandler('8L0R3_Store:attemptItemExchange', function(tradeKey)
    TriggerServerEvent('8L0R3_Store:attemptItemExchange', tradeKey)
end)

