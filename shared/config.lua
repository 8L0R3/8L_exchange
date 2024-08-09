Config = {}

-- Discord webhook for notifications
Config.DiscordWebhook = "YOUR_WEBHOOK" -- Replace with your webhook URL

-- Ped Config
Config.Ped = {
    model = "s_m_m_movspace_01",                       -- Ped Model
    name = "Interact with ped",                        -- Ped Name (QB-Target)
    position = vector3(45.62, -904.44, 29.97 - 0.99),  -- Ped Position
    heading = 341.21                                   -- Ped heading
}

-- Config trade Item for Car
Config.VehicleTrades = {
    ["BMW M8"] = {                        -- Trade name
        vehicle = "mansm8",               -- Car model
        label = "BMW M8",                 -- Item name in menu
        itemsRequired = { coin = 3000 }   -- Item name = amount
    },
    ["Continental"] = {
        vehicle = "17bcs",
        label = "Continental",
        itemsRequired = { coin = 4000 }
    },
    ["Chiron"] = {
        vehicle = "chironss",
        label = "Chiron",
        itemsRequired = { coin = 5000 }
    },
    -- Add here another vehicle
}

-- Config trade Item for Item
Config.ItemTrades = {
    ["trade1"] = {                   -- Trade name
        rewardItem = "case_recoil",  -- The item the player will receive
        label = "Case Recoil",       -- Item name in menu
        rewardAmount = 1,            -- The quantity of the item that the player will receive
        itemsRequired = {
            ["coin"] = 500,          -- Item name = amount
         -- ["bread"] = 2
        }
    },
    ["trade2"] = {
        rewardItem = "case_prisma2",  
        label = "Case Prisma",
        rewardAmount = 1,            
        itemsRequired = {
            ["coin"] = 800,           
        }
    },
    ["trade3"] = {
        rewardItem = "case_falcion",  
        label = "Case Falcion",
        rewardAmount = 1,            
        itemsRequired = {
            ["coin"] = 1000,           
        }
    },
    -- Add here another item
}
