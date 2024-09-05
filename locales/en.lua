local Translations = {

    ["debug_veh"] = "Vehicle exchange attempt triggered for key: ",
    ["debug_item"] = "Item exchange attempt triggered for key: ",
    ["debug_veh_event"] = "Server event received for vehicle exchange:",
    ["debug_no_coin"] = "does not have enough coins for the purchase",


    ["required"] = "Required:",
    ["player"] = "The player",
    ["buy"] = "has purchased",
    ["plate"] = "with plate",
    ["purchase"] = "Purchase of",
    ["by_player"] = "by the player",
    ["veh_success"] = "Purchase successful: the vehicle",
    ["veh_success_2"] = "has been added to your account",
    ["veh_error"] = "Error adding the vehicle",
    ["no_coin"] = "You don't have enough coins for this purchase",
    ["invalid"] = "Invalid",
    ["item_success"] = "Purchase successful: you received",
    

    ["script_loaded"] = "The script has been loaded. Welcome",

}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end