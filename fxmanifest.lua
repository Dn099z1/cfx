fx_version "bodacious"
game "gta5"
lua54 "yes"
version "1.5.0"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"bank/client-side/*/*/*",
	"barbershop/client-side/*/*/*",
	"chat/client-side/*/*/*",
	"megazord/client-side/*/*/*",
	"painel/client-side/*/*/*",
	"party/client-side/*/*/*",
	"skinshop/client-side/*/*/*",
	"spawn/client-side/*/*/*",
	"survival/client-side/*/*/*",
	"tablet/client-side/*/*/*",
	"tattooshop/client-side/*/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"bank/server-side/*/*/*",
	"barbershop/server-side/*/*/*",
	"chat/server-side/*/*/*",
	"megazord/server-side/*/*/*",
	"painel/server-side/*/*/*",
	"party/server-side/*/*/*",
	"skinshop/server-side/*/*/*",
	"spawn/server-side/*/*/*",
	"survival/server-side/*/*/*",
	"tablet/server-side/*/*/*",
	"tattooshop/server-side/*/*"
}

files {
	"@vrp/lib/Utils.lua",
	"bank/web-side/*/*/*",
	"barbershop/web-side/*/*/*",
	"chat/web-side/*/*/*",
	"megazord/web-side/*/*/*",
	"painel/web-side/*/*/*",
	"party/web-side/*/*/*",
	"skinshop/web-side/*/*/*",
	"spawn/web-side/*/*/*",
	"survival/web-side/*/*/*",
	"tablet/web-side/*/*/*",
	"tattooshop/web-side/*/*"
}

shared_scripts {
	"shared-side/*"
}