Config = {}

Config.DiscordWebhook = "Change WebHook Here"

Config.Ped = {
    model = "s_m_m_movspace_01", 
    name = "Interact",        
    position = vector3(45.62, -904.44, 29.97 -0.99), 
    heading = 341.21      
}

Config.VehicleTrades = {
    ["BMW M8"] = {
        vehicle = "mansm8",
        label = "BMW M8",
        itemsRequired = { coin = 3000 }
    },
    ["Continental"] = {
        vehicle = "17bcs",
        label = "Continental",
        itemsRequired = { coin = 4000 }
    },
    -- Add more
}


Config.ItemTrades = {
    ["trade1"] = {
        rewardItem = "case_recoil",  
        label = "Case Recoil",
        rewardAmount = 1,            
        itemsRequired = {
            ["coin"] = 500,          
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
    -- Add more
}
