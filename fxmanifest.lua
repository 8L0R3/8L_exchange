fx_version 'cerulean'
game 'gta5'

name '8L_Exchange'
description 'Exchange menu item & vehicle for QBCore'
author '8L0RE'
version '1.6.0'
repository 'https://github.com/8L0R3/8L_exchange'

shared_scripts {
    'shared/config.lua',
    '@qb-core/shared/locale.lua'
}

client_scripts {
    '@qb-menu/client/main.lua',
    'client/menu.lua',
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@qb-core/shared/locale.lua',
    'server/server.lua'
}

dependencies {
    'qb-core',
    'qb-menu',
    'oxmysql',
    'qb-vehiclekeys',
    'qb-target'
}
