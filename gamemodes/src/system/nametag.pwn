/*
	ooooo      ooo                                           .
	`888b.     `8'                                         .o8
	 8 `88b.    8   .oooo.   ooo. .oo.  .oo.    .ooooo.  .o888oo  .oooo.    .oooooooo
	 8   `88b.  8  `P  )88b  `888P"Y88bP"Y88b  d88' `88b   888   `P  )88b  888' `88b
	 8     `88b.8   .oP"888   888   888   888  888ooo888   888    .oP"888  888   888
	 8       `888  d8(  888   888   888   888  888    .o   888 . d8(  888  `88bod8P'
	o8o        `8  `Y888""8o o888o o888o o888o `Y8bod8P'   "888" `Y888""8o `8oooooo.
	                                                                       d"     YD
	                                                                       "Y88888P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Callbacks
hook OnPlayerStreamIn(playerid, forplayerid)
{
	Nametag_Check(playerid, forplayerid);
	return true;
}

// Functions
Nametag_Update(playerid)
{
	if (IsPlayerConnected(playerid))
		return false;

	foreach (new i : Player)
	{
		if (!IsPlayerStreamedIn(playerid, i))
			continue;

		Nametag_Check(playerid, i);
	}
	return true;
}

Nametag_Check(playerid, forplayer)
{
	new name[MAX_PLAYER_NAME + 1];

	format (name, sizeof name, Character_GetName(playerid, true));
	SetPlayerNameForPlayer(forplayer, playerid, name);
	return true;
}

SetPlayerNameForPlayer(playerid, setname, name[])
{
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(setname))
		return false;

	new BitStream:bs = BS_New();
	
	BS_WriteValue(
		bs,
		PR_UINT16, setname,
		PR_UINT8, strlen(name),
		PR_STRING, name,
		PR_UINT8, 1
	);

	PR_SendRPC(bs, playerid, 11, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
	return true;
}