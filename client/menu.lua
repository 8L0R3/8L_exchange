local QBCore = exports['qb-core']:GetCoreObject()

function OpenMainMenu()
    local menuOptions = {
        {
            header = "NAME OF YOUR SERVER",
            txt = "DESC.",
            isMenuHeader = true  -- Prevent clicking on this item
        },
        {
            header = "First Submenu",
            txt = "Desc",
            params = {
                event = "8L0R3_Store:openVehicleTradeMenu"
            }
        },
        {
            header = "2e Submenu",
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
            txt = 'Required : ' .. GetRequiredItemsText(vehicleConfig.itemsRequired),
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
            txt = 'Required : ' .. GetRequiredItemsText(tradeConfig.itemsRequired),
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

-- Opening the main menu when interacting with the ped
RegisterNetEvent('8L0R3_Store:openMainMenu')
AddEventHandler('8L0R3_Store:openMainMenu', function()
    OpenMainMenu()
end)

-- Opening the vehicle exchange submenu
RegisterNetEvent('8L0R3_Store:openVehicleTradeMenu')
AddEventHandler('8L0R3_Store:openVehicleTradeMenu', function()
    OpenVehicleTradeMenu()
end)

-- Opening the item exchange submenu
RegisterNetEvent('8L0R3_Store:openItemTradeMenu')
AddEventHandler('8L0R3_Store:openItemTradeMenu', function()
    OpenItemTradeMenu()
end)
