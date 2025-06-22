fx_version 'cerulean'
game 'gta5'

author 'Knard'
description 'Duck_Society - Gestion des sociétés'
version '1.1.0'

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/protos/*.lua',
    'server/utils/*.lua',
    'server/classes/*.lua',
    'server/main.lua',
}