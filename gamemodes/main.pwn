/*
	ooooooooo.                          o8o                         .          .oooooo.    o8o      .
	`888   `Y88.                        `"'                       .o8         d8P'  `Y8b   `"'    .o8
	 888   .d88' oooo d8b  .ooooo.     oooo  .ooooo.   .ooooo.  .o888oo      888          oooo  .o888oo oooo    ooo
	 888ooo88P'  `888""8P d88' `88b    `888 d88' `88b d88' `"Y8   888        888          `888    888    `88.  .8'
	 888          888     888   888     888 888ooo888 888         888        888           888    888     `88..8'
	 888          888     888   888     888 888    .o 888   .o8   888 .      `88b    ooo   888    888 .    `888'
	o888o        d888b    `Y8bod8P'     888 `Y8bod8P' `Y8bod8P'   "888"       `Y8bood8P'  o888o   "888"     .8'
	                                    888                                                             .o..P'
	                                .o. 88P                                                             `Y8P'
	                                `Y888P

	
										Autor: Jobim
*/

// Includes
#include <a_samp>
#include <a_http>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <Pawn.CMD>
#include <Pawn.Raknet>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_hooks>
#include <YSI_Coding\y_timers>
#include <YSI_Extra\y_inline_mysql>
#include <YSI_Game\y_vehicledata>
#include <is_android>
#include <fixes>
#include <strlib>
#include <filemanager>
#include <preview-dialog>
#include <easy-dialog>
#include <YSI_Coding\y_va>
#include <vehicle-attach>
#include <gvar>
#include <noclip>
#include <zones>
#include <footer>

/*
		ooooo   ooooo                           .o8
		`888'   `888'                          "888
		 888     888   .ooooo.   .oooo.    .oooo888   .ooooo.  oooo d8b  .oooo.o
		 888ooooo888  d88' `88b `P  )88b  d88' `888  d88' `88b `888""8P d88(  "8
		 888     888  888ooo888  .oP"888  888   888  888ooo888  888     `"Y88b.
		 888     888  888    .o d8(  888  888   888  888    .o  888     o.  )88b
		o888o   o888o `Y8bod8P' `Y888""8o `Y8bod88P" `Y8bod8P' d888b    8""888P'
*/

// Server
#include "./src/server/config.pwn"
#include "./src/server/macros.pwn"
#include "./src/server/colors.pwn"
#include "./src/server/vehicle-data.pwn"

// Jobs
#include "./src/jobs/data.pwn"

// Account
#include "./src/account/data.pwn"

// Premium
#include "./src/premium/data.pwn"

// Admin
#include "./src/admin/data.pwn"

// Dynamic
#include "./src/dynamic/data.pwn"



/*
		ooo        ooooo                 .o8              oooo
		`88.       .888'                "888              `888
		 888b     d'888   .ooooo.   .oooo888  oooo  oooo   888   .ooooo.   .oooo.o
		 8 Y88. .P  888  d88' `88b d88' `888  `888  `888   888  d88' `88b d88(  "8
		 8  `888'   888  888   888 888   888   888   888   888  888   888 `"Y88b.
		 8    Y     888  888   888 888   888   888   888   888  888   888 o.  )88b
		o8o        o888o `Y8bod8P' `Y8bod88P"  `V88V"V8P' o888o `Y8bod8P' 8""888P'
*/

// Server
#include "./src/server/mysql/config.pwn"
#include "./src/server/mysql/startup.pwn"

#include "./src/server/variables.pwn"
#include "./src/server/functions.pwn"

// Account
#include "./src/account/banned.pwn"
#include "./src/account/auth.pwn"
#include "./src/account/crud.pwn"
#include "./src/account/lookup.pwn"

#include "./src/account/characters/cenario.pwn"
#include "./src/account/characters/creation.pwn"
#include "./src/account/characters/interface.pwn"
#include "./src/account/characters/crud.pwn"

// Character
#include "./src/character/spawn.pwn"
#include "./src/character/functions.pwn"
#include "./src/character/chat.pwn"
#include "./src/character/damage.pwn"

// Admin
#include "./src/admin/comandos.pwn"
#include "./src/admin/functions.pwn"
#include "./src/admin/management.pwn"

// Dynamic
#include "./src/dynamic/scripts/interacts.pwn"
#include "./src/dynamic/scripts/entrances.pwn"
#include "./src/dynamic/scripts/factions.pwn"
#include "./src/dynamic/scripts/vehicles.pwn"
#include "./src/dynamic/scripts/business.pwn"
#include "./src/dynamic/scripts/items.pwn"
#include "./src/dynamic/scripts/houses.pwn"
#include "./src/dynamic/scripts/inventory.pwn"
#include "./src/dynamic/scripts/pump.pwn"
#include "./src/dynamic/scripts/furniture.pwn"

#include "./src/dynamic/startup.pwn"
#include "./src/dynamic/interface.pwn"

// System
#include "./src/system/address.pwn"
#include "./src/system/logs.pwn"
#include "./src/system/spectate_fix.pwn"
#include "./src/system/daycycle.pwn"
#include "./src/system/hands.pwn"
#include "./src/system/nametag.pwn"
#include "./src/system/animations.pwn"
#include "./src/system/schedule.pwn"
//#include "./src/system/basemodels.pwn"

#include "./src/system/comandos/geral.pwn"
#include "./src/system/comandos/portas.pwn"
#include "./src/system/comandos/radio.pwn"

// Jobs
#include "./src/jobs/agencia.pwn"
#include "./src/jobs/paycheck.pwn"

#include "./src/jobs/trucker/commodities.pwn"
#include "./src/jobs/trucker/dropped.pwn"
#include "./src/jobs/trucker/industries.pwn"
#include "./src/jobs/trucker/ship.pwn"
#include "./src/jobs/trucker/tpda.pwn"
#include "./src/jobs/trucker/core.pwn"

// Factions
#include "./src/faction/gestao.pwn"
#include "./src/faction/functions.pwn"
#include "./src/faction/comandos.pwn"

// Veículos
#include "./src/vehicle/comandos.pwn"

// Empresas
#include "./src/business/purchase.pwn"
#include "./src/business/prices.pwn"
#include "./src/business/comandos.pwn"

// Inventory
#include "./src/inventory/core.pwn"

// Mobília
#include "./src/furniture/core.pwn"
#include "./src/furniture/shop.pwn"
#include "./src/furniture/textures.pwn"
#include "./src/furniture/inventory.pwn"

/*
		 .oooooo..o     .                          .
		d8P'    `Y8   .o8                        .o8
		Y88bo.      .o888oo  .oooo.   oooo d8b .o888oo oooo  oooo  oo.ooooo.
		 `"Y8888o.    888   `P  )88b  `888""8P   888   `888  `888   888' `88b
		     `"Y88b   888    .oP"888   888       888    888   888   888   888
		oo     .d8P   888 . d8(  888   888       888 .  888   888   888   888
		8""88888P'    "888" `Y888""8o d888b      "888"  `V88V"V8P'  888bod8P'
		                                                            888
		                                                           o888o
*/

main() 
{
	ManualVehicleEngineAndLights();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	EnableStuntBonusForAll(false);
	SetNameTagDrawDistance(20.0);
	DisableInteriorEnterExits();
	ShowPlayerMarkers(0);
	SetWeather(1);

	SendRconCommand("mapname "SERVER_MAPNAME"");
	SendRconCommand("language "SERVER_LANG"");
	SendRconCommand("weburl "SERVER_WEBURL"");
}

public OnGameModeInit()
{
	SendRconCommand("hostname "SERVER_HOSTNAME"");
	SetGameModeText(SERVER_MODETEXT);
	return true;
}

public OnGameModeExit()
{
	Streamer_DestroyAllItems(STREAMER_TYPE_OBJECT, 			0);
	Streamer_DestroyAllItems(STREAMER_TYPE_PICKUP, 			0);
	Streamer_DestroyAllItems(STREAMER_TYPE_CP, 				0);
	Streamer_DestroyAllItems(STREAMER_TYPE_RACE_CP, 		0);
	Streamer_DestroyAllItems(STREAMER_TYPE_MAP_ICON, 		0);
	Streamer_DestroyAllItems(STREAMER_TYPE_3D_TEXT_LABEL, 	0);
	Streamer_DestroyAllItems(STREAMER_TYPE_AREA, 			0);

	mysql_close(MYSQL_CUR_HANDLE);
	return true;
}

/*
	 .oooooo..o                                                        ooooooooooooo  o8o            oooo
	d8P'    `Y8                                                        8'   888   `8  `"'            `888
	Y88bo.       .ooooo.  oooo d8b oooo    ooo  .ooooo.  oooo d8b           888      oooo   .ooooo.   888  oooo
	 `"Y8888o.  d88' `88b `888""8P  `88.  .8'  d88' `88b `888""8P           888      `888  d88' `"Y8  888 .8P'
	     `"Y88b 888ooo888  888       `88..8'   888ooo888  888               888       888  888        888888.
	oo     .d8P 888    .o  888        `888'    888    .o  888               888       888  888   .o8  888 `88b.
	8""88888P'  `Y8bod8P' d888b        `8'     `Y8bod8P' d888b             o888o     o888o `Y8bod8P' o888o o888o
	
*/

task Server_OnUpdate[1000]()
{
	return true;
}