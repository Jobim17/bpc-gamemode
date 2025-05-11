/*
	oooooooooo.                           .oooooo.                         oooo
	`888'   `Y8b                         d8P'  `Y8b                        `888
	 888      888  .oooo.   oooo    ooo 888          oooo    ooo  .ooooo.   888   .ooooo.
	 888      888 `P  )88b   `88.  .8'  888           `88.  .8'  d88' `"Y8  888  d88' `88b
	 888      888  .oP"888    `88..8'   888            `88..8'   888        888  888ooo888
	 888     d88' d8(  888     `888'    `88b    ooo     `888'    888   .o8  888  888    .o
	o888bood8P'   `Y888""8o     .8'      `Y8bood8P'      .8'     `Y8bod8P' o888o `Y8bod8P'
	                        .o..P'                   .o..P'
	                        `Y8P'                    `Y8P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Check
static hour;
static s_updateHour = 12;

// Callbacks
hook OnGameModeInit()
{
	new now = gettime();
	s_updateHour = now + (3600 - (now % 3600));
	return true;
}

hook Server_OnUpdate()
{
	new now = gettime();

	if (now >= s_updateHour)
	{
		s_updateHour = now + 3600;
		Log_Create("Tick OSUH", "%i", now);
		CallRemoteFunction("OnServerUpdateHour", "");
	}

	UpdateServerHour();
	return true;
}

// Funções
UpdateServerHour()
{
	return 1;
}

CMD:hora(playerid, params[])
{
	if (IsNumeric(params) && (0 <= strval(params) <= 23))
	{
		SetWorldTime(strval(params));	
	}
	return true;
}

CMD:clima(playerid, params[])
{
	if (IsNumeric(params) && (0 <= strval(params) <= 68))
	{
		SetWeather(strval(params));
	}
	return true;
}