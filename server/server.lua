local QBCore = exports['qb-core']:GetCoreObject()
print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Loading...')
Citizen.Wait(2500)
print('[^4Script^7][^6LUA^7][^18L_Exchange^7] as been loaded. Welcome')
print('[^4Script^7][^6LUA^7][^18L_Exchange^7] script made by 8L0R3 for QBCore')

function SendDiscordWebhook(message)
    local webhook = Config.DiscordWebhook
    if webhook == "" then return end

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "[8L_Exchange] Store",
        embeds = {{
            color = 3447003,
            title = "New Trade",
            description = message,
            footer = {
                text = os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

-- Function to generate a unique 7 character license plate
function GetRandomPlate()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local numbers = "0123456789"
    local plate = ""

    for i = 1, 4 do
        plate = plate .. letters:sub(math.random(1, #letters), math.random(1, #letters))
    end

    for i = 1, 3 do
        plate = plate .. numbers:sub(math.random(1, #numbers), math.random(1, #numbers))
    end

    if #plate > 7 then
        plate = plate:sub(1, 7)
    end 
    return string.upper(plate)
end

local function generateUniquePlate()
    local plate
    local plateExists = true

    while plateExists do
        plate = string.upper(GetRandomPlate())
        MySQL.Async.fetchScalar('SELECT COUNT(*) FROM player_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        }, function(count)
            if count == 0 then
                plateExists = false
            end
        end)
        Citizen.Wait(100)
    end

    return plate
end

-- Function to manage the exchange of items for vehicles
RegisterServerEvent('8L0R3_Store:attemptVehicleExchange')
AddEventHandler('8L0R3_Store:attemptVehicleExchange', function(vehicleKey)
    print("[^4Script^7][^6LUA^7][^18L_Exchange^7] Server event received for vehicle exchange :", vehicleKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerLicense = Player.PlayerData.license
    local playerCitizenID = Player.PlayerData.citizenid
    local vehicleConfig = Config.VehicleTrades[vehicleKey]

    if vehicleConfig then
        local vehicleToInsert = vehicleConfig.vehicle
        local vehicleHash = GetHashKey(vehicleToInsert)
        local plate = generateUniquePlate()

        local hasAllItems = true

        -- Verification of required items
        for itemName, requiredQuantity in pairs(vehicleConfig.itemsRequired) do
            local playerItem = Player.Functions.GetItemByName(itemName)
            if not playerItem or playerItem.amount < requiredQuantity then
                hasAllItems = false
                break
            end
        end

        if hasAllItems then
            -- Remove required items
            for itemName, requiredQuantity in pairs(vehicleConfig.itemsRequired) do
                Player.Functions.RemoveItem(itemName, requiredQuantity)
            end

            -- Insert the vehicle into the database
            local query = [[
                INSERT INTO player_vehicles (
                    license, citizenid, vehicle, hash, mods, plate, fakeplate, garage, fuel, engine, body, state, depotprice,
                    drivingdistance, status, balance, paymentamount, paymentsleft, financetime
                ) VALUES (
                    @license, @citizenid, @vehicle, @hash, @mods, @plate, @fakeplate, @garage, @fuel, @engine, @body, @state, @depotprice,
                    @drivingdistance, @status, @balance, @paymentamount, @paymentsleft, @financetime
                )
            ]]
            local parameters = {
                ['@license'] = playerLicense,
                ['@citizenid'] = playerCitizenID,
                ['@vehicle'] = vehicleToInsert,
                ['@hash'] = vehicleHash,
                ['@mods'] = '{}',
                ['@plate'] = plate,
                ['@fakeplate'] = 'nil',
                ['@garage'] = 'store',             -- Name of your main garage
                ['@fuel'] = 100,
                ['@engine'] = 1000,
                ['@body'] = 1000,
                ['@state'] = 1,
                ['@depotprice'] = 0,
                ['@drivingdistance'] = nil,
                ['@status'] = nil,
                ['@balance'] = 0,
                ['@paymentamount'] = 0,
                ['@paymentsleft'] = 0,
                ['@financetime'] = 0
            }

            MySQL.Async.execute(query, parameters, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
                    TriggerClientEvent('QBCore:Notify', src, 'Successful exchange : the vehicle ' .. vehicleToInsert .. ' has been added to your account.', 'success')
					local message = "Player **" .. GetPlayerName(src) .. "** exchanged item for one **" .. vehicleConfig.vehicle .. "** with plate **" .. plate .. "**."
                    SendDiscordWebhook(message)
                    print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Purchase of ^1' .. vehicleConfig.vehicle .. '^7 by the player ^1' .. GetPlayerName(src) .. '^7 (plate : ^1' .. plate .. '^7 )')
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Error adding vehicle to your account.', 'error')
                    print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Player ^1' .. GetPlayerName(src) .. '^7 had an error while adding his vehicle. ( ^1' .. vehicleConfig.label .. '^7 )')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have the items needed for this exchange.', 'error')
            print('[^4Script^7][^6LUA^7][^18L_Exchange^7] ^1' .. GetPlayerName(src) .. '^7 does not have enough money for his purchase')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Invalid exchange.', 'error')
    end
end)

-- Function to manage the exchange of items for other items
RegisterServerEvent('8L0R3_Store:attemptItemExchange')
AddEventHandler('8L0R3_Store:attemptItemExchange', function(tradeKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tradeConfig = Config.ItemTrades[tradeKey]

    if tradeConfig then
        local hasAllItems = true

        -- Verification of required items
        for itemName, requiredQuantity in pairs(tradeConfig.itemsRequired) do
            local playerItem = Player.Functions.GetItemByName(itemName)
            if not playerItem or playerItem.amount < requiredQuantity then
                hasAllItems = false
                break
            end
        end

        if hasAllItems then
            -- Remove required items
            for itemName, requiredQuantity in pairs(tradeConfig.itemsRequired) do
                Player.Functions.RemoveItem(itemName, requiredQuantity)
            end

            -- Give the reward item
            Player.Functions.AddItem(tradeConfig.rewardItem, tradeConfig.rewardAmount)

            -- Success notification
            TriggerClientEvent('QBCore:Notify', src, 'Successful exchange : you received ' .. tradeConfig.rewardAmount .. 'x ' .. tradeConfig.rewardItem .. '.', 'success')
            local message = "Player **" .. GetPlayerName(src) .. "** exchanged items for **" .. tradeConfig.rewardAmount .. "x " .. tradeConfig.rewardItem .. "**."
            SendDiscordWebhook(message)
            print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Player ^1' .. GetPlayerName(src) .. '^7 to buy the item ^1' .. tradeConfig.rewardItem .. '^7 ')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have the coins needed for this exchange.', 'error')
            print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Player ^1' .. GetPlayerName(src) .. '^7 does not have enough coins to purchase ')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Invalid exchange.', 'error')
    end
end)
