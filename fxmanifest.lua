fx_version 'cerulean'
games { 'gta5' }
version '1.0.0'
author 'Alx <alxtheprogrammer@gmail.com>'
description ''
repository ''

ui_page '/web-files/index.html'

files {
    "/web-files/*",
}

shared_script 'config.lua'

server_script '@oxmysql/lib/MySQL.lua'

server_script 'server.lua'

client_script 'client.lua'