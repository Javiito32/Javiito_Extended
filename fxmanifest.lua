fx_version 'bodacious'
games { 'gta5' }

author 'Javiito_32'

client_scripts {
    '@es_extended/locale.lua',
    'config/config.lua',
    'config/client_config.lua',
    'core/common.lua',
    'core/client/JEX_clientCore.lua',

    'modules/madera/config.lua',
    'modules/madera/client.lua',
    'modules/mina/config.lua',
    'modules/mina/client.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'config/config.lua',
    'config/server_config.lua',
    'config/work_multiplier.lua',
    'config/xp_level.lua',
    'core/common.lua',
    'core/server/JEX_Classes.lua',
    'core/server/JEX_serverCore.lua',

    'modules/madera/config.lua',
    'modules/madera/server.lua',
    'modules/mina/config.lua',
    'modules/mina/server.lua',
}