fx_version 'cerulean'
game 'gta5'

author 'Knard'
description 'Duck_Society - Gestion des sociétés'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'shared/database.lua',
    'server/society_roles.lua',
    'server/society_members.lua',
    'server/society.lua',
    'server/identity.lua',
    'server/player.lua',
    'server/main.lua',
}