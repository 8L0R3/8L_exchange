local Translations = {

    ["debug_veh"] = "Tentative d'échange de véhicule déclenchée pour la clé : ",
    ["debug_item"] = "Tentative d'échange d'item déclenchée pour la clé : ",
    ["debug_veh_event"] = "Événement serveur reçu pour l'échange de véhicule :",
    ["debug_no_coin"] = "n'a pas assez de coin pour son achat",


    ["required"] = "Requis :",
    ["player"] = "Le joueur",
    ["buy"] = "a acheter",
    ["plate"] = "avec la plaque",
    ["purchase"] = "Achat de",
    ["by_player"] = "par le joueur",
    ["veh_success"] = "Achat réussi : le véhicule",
    ["veh_success_2"] = "a été ajouté à votre compte",
    ["veh_error"] = "Erreur lors de l'ajout du véhicule",
    ["no_coin"] = "Vous n'avez pas les coins nécessaires pour cet achat",
    ["invalid"] = "Non valide",
    ["item_success"] = "Achat réussi : vous avez reçu",
    

    ["script_loaded"] = "Le script a été chargé. Bienvenue",


}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end