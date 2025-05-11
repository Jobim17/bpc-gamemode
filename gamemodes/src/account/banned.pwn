/*
	oooooooooo.                                                    .o8
	`888'   `Y8b                                                  "888
	 888     888  .oooo.   ooo. .oo.   ooo. .oo.    .ooooo.   .oooo888
	 888oooo888' `P  )88b  `888P"Y88b  `888P"Y88b  d88' `88b d88' `888
	 888    `88b  .oP"888   888   888   888   888  888ooo888 888   888
	 888    .88P d8(  888   888   888   888   888  888    .o 888   888
	o888bood8P'  `Y888""8o o888o o888o o888o o888o `Y8bod8P' `Y8bod88P"
*/

// Include
#include <YSI_Coding\y_hooks>

// Forwards
forward OnPlayerRequestLogin(playerid, accountid);

// Callbacks
public OnPlayerRequestClass(playerid)
{
	SetPlayerColor(playerid, COLOR_GREY);

	inline Ban_OnChecked()
	{
		if (cache_num_rows())
		{
			return true;
		}

		inline Login_Request()
		{	
			static id;

			if (!cache_num_rows()) id = -1;
			else cache_get_value_name_int(0, "ID", id);

			CallRemoteFunction("OnPlayerRequestLogin", "ii", playerid, id);
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Login_Request, "SELECT `ID` FROM `Contas` WHERE `Nome` = '%e' LIMIT 1;", ReturnPlayerName(playerid));
	}
		
	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Ban_OnChecked, "SELECT * FROM `Banimentos` WHERE (`Nome` = '%e' OR `IP` = '%e') AND (`Tempo` IS NULL OR `Tempo` > %i) LIMIT 1;", ReturnPlayerName(playerid), ReturnPlayerIP(playerid), gettime());
	return true;
}

public OnPlayerRequestSpawn(playerid) return false;