local QBCore = exports['qb-core']:GetCoreObject()
local language = GetConvar('qb_locale')
print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Loading script...')
print('[^4Script^7][^6LUA^7][^18L_Exchange^7] Loading language : ( '..language..' ) ...')
Citizen.Wait(2500)
print('[^4Script^7][^6LUA^7][^18L_Exchange^7] '.. Lang:t("script_loaded") .."")

function SendDiscordWebhook(message)
    local webhook = Config.DiscordWebhook
    if webhook == "" then return end

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "[8L_Exchange]",
        embeds = {{
            color = 3447003,
            title = "LOGS",
            description = message,
            footer = {
                text = os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

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


RegisterServerEvent('8L0R3_Store:attemptVehicleExchange')
AddEventHandler('8L0R3_Store:attemptVehicleExchange', function(vehicleKey)
    print("[^4Script^7][^6LUA^7][^18L_Exchange^7] "..Lang:t("debug_veh_event"), vehicleKey)  -- Débogage
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

        
        for itemName, requiredQuantity in pairs(vehicleConfig.itemsRequired) do
            local playerItem = Player.Functions.GetItemByName(itemName)
            if not playerItem or playerItem.amount < requiredQuantity then
                hasAllItems = false
                break
            end
        end

        if hasAllItems then
            
            for itemName, requiredQuantity in pairs(vehicleConfig.itemsRequired) do
                Player.Functions.RemoveItem(itemName, requiredQuantity)
            end

            
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
                ['@mods'] = 'default',
                ['@plate'] = plate,
                ['@fakeplate'] = 'default',
                ['@garage'] = 'boutique',
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
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("veh_success")..' ' .. vehicleToInsert .. ' '..Lang:t("veh_success_2"), 'success')
					local message = Lang:t("player")" **" .. GetPlayerName(src) .. "** "..Lang:t("buy").." **" .. vehicleConfig.vehicle .. "** "..Lang:t("plate").." **" .. plate .. "**."
                    SendDiscordWebhook(message)
                    print('[^4Script^7][^6LUA^7][^18L_Exchange^7] '..Lang:t("purchase")..' ^1' .. vehicleConfig.vehicle .. '^7 '..Lang:t("by_player")..' ^1' .. GetPlayerName(src) .. '^7 ('..Lang:t("plate")..' : ^1' .. plate .. '^7 )')
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("veh_error"), 'error')
                    print('[^4Script^7][^6LUA^7][^18L_Exchange^7] '..Lang:t("player")..'^1' .. GetPlayerName(src) .. '^7 '..Lang:t("veh_error")..' ( ^1' .. vehicleConfig.vehicle .. '^7 )')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("no_coin"), 'error')
            print('[^4Script^7][^6LUA^7][^18L_Exchange^7] ^1' .. GetPlayerName(src) .. '^7 '..Lang:t("debug_no_coin"))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("invalid"), 'error')
    end
end)

RegisterServerEvent('8L0R3_Store:attemptItemExchange')
AddEventHandler('8L0R3_Store:attemptItemExchange', function(tradeKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tradeConfig = Config.ItemTrades[tradeKey]

    if tradeConfig then
        local hasAllItems = true

        for itemName, requiredQuantity in pairs(tradeConfig.itemsRequired) do
            local playerItem = Player.Functions.GetItemByName(itemName)
            if not playerItem or playerItem.amount < requiredQuantity then
                hasAllItems = false
                break
            end
        end

        if hasAllItems then
            for itemName, requiredQuantity in pairs(tradeConfig.itemsRequired) do
                Player.Functions.RemoveItem(itemName, requiredQuantity)
            end

            Player.Functions.AddItem(tradeConfig.rewardItem, tradeConfig.rewardAmount)

            TriggerClientEvent('QBCore:Notify', src, Lang:t("item_success")..' ' .. tradeConfig.rewardAmount .. 'x ' .. tradeConfig.rewardItem .. '.', 'success')
            local message = Lang:t("player").." **" .. GetPlayerName(src) .. "** "..Lang:t("buy").." **" .. tradeConfig.rewardAmount .. "x " .. tradeConfig.rewardItem .. "**."
            SendDiscordWebhook(message)
            print('[^4Script^7][^6LUA^7][^18L_Exchange^7] '..Lang:t("player")..' ^1' .. GetPlayerName(src) .. '^7 '..Lang:t("buy")..'^1' .. tradeConfig.rewardItem .. '^7 ')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("no_coin"), 'error')
            print('[^4Script^7][^6LUA^7][^18L_Exchange^7] '..Lang:t("player")..' ^1' .. GetPlayerName(src) .. '^7 '..Lang:t("debug_no_coin"))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("invalid"), 'error')
    end
end)
