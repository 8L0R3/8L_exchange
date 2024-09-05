local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerCoinCount()
    local playerData = QBCore.Functions.GetPlayerData()
    local coinItem = playerData.items and playerData.items["coin"] or nil
    local coinCount = 0

    if coinItem then
        coinCount = coinItem.amount
    end

    return coinCount
end

function OpenMainMenu()
    local coinCount = GetPlayerCoinCount()
    local menuOptions = {
        {
            header = "Server Name",
            txt = "Desc.",
            isMenuHeader = true
        },
        {
            header = "Option 1",
            txt = "Desc",
            params = {
                event = "8L0R3_Store:openVehicleTradeMenu"
            }
        },
        {
            header = "Option 2",
            txt = "Desc",
            params = {
                event = "8L0R3_Store:openItemTradeMenu"
            }
        }
    }

    exports['qb-menu']:openMenu(menuOptions)
end

function OpenVehicleTradeMenu()
    local menuOptions = {}

    for vehicleKey, vehicleConfig in pairs(Config.VehicleTrades) do
        local option = {
            header = '- ' .. vehicleConfig.label,
            txt = Lang:t("required")..' ' .. GetRequiredItemsText(vehicleConfig.itemsRequired),
            params = {
                event = '8L0R3_Store:attemptVehicleExchange',
                args = vehicleKey
            }
        }
        table.insert(menuOptions, option)
    end

    exports['qb-menu']:openMenu(menuOptions)
end

function OpenItemTradeMenu()
    local menuOptions = {}

    for tradeKey, tradeConfig in pairs(Config.ItemTrades) do
        local option = {
            header = '' .. tradeConfig.rewardAmount .. 'x ' .. tradeConfig.label,
            txt = Lang:t("required")..' ' .. GetRequiredItemsText(tradeConfig.itemsRequired),
            params = {
                event = '8L0R3_Store:attemptItemExchange',
                args = tradeKey
            }
        }
        table.insert(menuOptions, option)
    end

    exports['qb-menu']:openMenu(menuOptions)
end

function GetRequiredItemsText(itemsRequired)
    local text = ""
    for itemName, quantity in pairs(itemsRequired) do
        text = text .. quantity .. ' ' .. itemName .. ', '
    end
    return text:sub(1, -3)
end


RegisterNetEvent('8L0R3_Store:openMainMenu')
AddEventHandler('8L0R3_Store:openMainMenu', function()
    OpenMainMenu()
end)


RegisterNetEvent('8L0R3_Store:openVehicleTradeMenu')
AddEventHandler('8L0R3_Store:openVehicleTradeMenu', function()
    OpenVehicleTradeMenu()
end)


RegisterNetEvent('8L0R3_Store:openItemTradeMenu')
AddEventHandler('8L0R3_Store:openItemTradeMenu', function()
    OpenItemTradeMenu()
end)
