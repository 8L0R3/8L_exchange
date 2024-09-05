local QBCore = exports['qb-core']:GetCoreObject()

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


RegisterNetEvent('8L0R3_Store:openMainMenu')
AddEventHandler('8L0R3_Store:openMainMenu', function()
    OpenMainMenu()
end)

RegisterNetEvent('8L0R3_Store:attemptVehicleExchange')
AddEventHandler('8L0R3_Store:attemptVehicleExchange', function(vehicleKey)
    print(Lang:t("debug_veh"), vehicleKey)  
    TriggerServerEvent('8L0R3_Store:attemptVehicleExchange', vehicleKey)
end)

RegisterNetEvent('8L0R3_Store:attemptItemExchange')
AddEventHandler('8L0R3_Store:attemptItemExchange', function(tradeKey)
    print(Lang:t("debug_item"), tradeKey)
    TriggerServerEvent('8L0R3_Store:attemptItemExchange', tradeKey)
end)

