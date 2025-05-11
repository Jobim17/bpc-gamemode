/*
	 .oooooo..o                                    .                 .
	d8P'    `Y8                                  .o8               .o8
	Y88bo.      oo.ooooo.   .ooooo.   .ooooo.  .o888oo  .oooo.   .o888oo  .ooooo.
	 `"Y8888o.   888' `88b d88' `88b d88' `"Y8   888   `P  )88b    888   d88' `88b
	     `"Y88b  888   888 888ooo888 888         888    .oP"888    888   888ooo888
	oo     .d8P  888   888 888    .o 888   .o8   888 . d8(  888    888 . 888    .o
	8""88888P'   888bod8P' `Y8bod8P' `Y8bod8P'   "888" `Y888""8o   "888" `Y8bod8P'
	             888
	            o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Hooks
hook native TogglePlayerSpectating(playerid, toggle)
{
	if (toggle && IsPlayerLogged(playerid) && CharacterData[playerid][e_CHARACTER_ID] && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		Character_UpdateSpawn(playerid);

		GetPlayerHealth(playerid, CharacterData[playerid][e_CHARACTER_HEALTH]);
		GetPlayerArmour(playerid, CharacterData[playerid][e_CHARACTER_ARMOUR]);
	}

	return continue(playerid, toggle);
}