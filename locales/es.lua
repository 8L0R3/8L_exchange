local Translations = {

    ["debug_veh"] = "Intento de intercambio de vehículo activado para la clave: ",
    ["debug_item"] = "Intento de intercambio de artículo activado para la clave: ",
    ["debug_veh_event"] = "Evento de servidor recibido para el intercambio de vehículos:",
    ["debug_no_coin"] = "no tiene suficientes monedas para su compra",


    ["required"] = "Requerido:",
    ["player"] = "El jugador",
    ["buy"] = "ha comprado",
    ["plate"] = "con la placa",
    ["purchase"] = "Compra de",
    ["by_player"] = "por el jugador",
    ["veh_success"] = "Compra exitosa: el vehículo",
    ["veh_success_2"] = "ha sido añadido a tu cuenta",
    ["veh_error"] = "Error al añadir el vehículo",
    ["no_coin"] = "No tienes las monedas necesarias para esta compra",
    ["invalid"] = "Inválido",
    ["item_success"] = "Compra exitosa: recibiste",
    

    ["script_loaded"] = "El script ha sido cargado. Bienvenido",

}


if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end