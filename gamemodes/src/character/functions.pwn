/*
	oooooooooooo                                       .    o8o
	`888'     `8                                     .o8    `"'
	 888         oooo  oooo  ooo. .oo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o
	 888oooo8    `888  `888  `888P"Y88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8
	 888    "     888   888   888   888  888         888    888  888   888  888   888  `"Y88b.
	 888          888   888   888   888  888   .o8   888 .  888  888   888  888   888  o.  )88b
	o888o         `V88V"V8P' o888o o888o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P'
*/

Character_GetName(playerid, bool:mask = true)
{
	new ret[MAX_PLAYER_NAME + 1];

	format (ret, sizeof ret, CharacterData[playerid][e_CHARACTER_NAME]);
	strreplace (ret, "_", " ");
	return ret;
}

Character_UpdateColor(playerid)
{
	if (AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] && !AccountData[playerid][e_ACCOUNT_ADMIN_HIDE])
	{
		SetPlayerColor(playerid, COLOR_ADMIN);
	}
	else 
	{
		SetPlayerColor(playerid, -1);
	}

	return true;
}

Character_UpdateSpawn(playerid)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	GetPlayerPos(playerid, CharacterData[playerid][e_CHARACTER_POS][0], CharacterData[playerid][e_CHARACTER_POS][1], CharacterData[playerid][e_CHARACTER_POS][2]);
	GetPlayerFacingAngle(playerid, CharacterData[playerid][e_CHARACTER_ANGLE]);
	CharacterData[playerid][e_CHARACTER_WORLD] = GetPlayerVirtualWorld(playerid);
	CharacterData[playerid][e_CHARACTER_INTERIOR] = GetPlayerInterior(playerid);
	return true;
}

Character_SetPos(playerid, Float:x, Float:y, Float:z, Float:angle, world, interior)
{
	CharacterData[playerid][e_CHARACTER_POS][0] = x;
	CharacterData[playerid][e_CHARACTER_POS][1] = y;
	CharacterData[playerid][e_CHARACTER_POS][2] = z;
	CharacterData[playerid][e_CHARACTER_WORLD] = world;
	CharacterData[playerid][e_CHARACTER_INTERIOR] = GetPlayerInterior(playerid);

	if (angle == -1.0)
	{
		GetPlayerFacingAngle(playerid, CharacterData[playerid][e_CHARACTER_ANGLE]);
	}
	else
	{
		CharacterData[playerid][e_CHARACTER_ANGLE] = angle;
	}

	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, world);
	SetPlayerFacingAngle(playerid, CharacterData[playerid][e_CHARACTER_ANGLE]);
	SetCameraBehindPlayer(playerid);
	Streamer_UpdateEx(playerid, x, y, z, world, interior, STREAMER_TYPE_OBJECT, 1000, 1);
	return true;
}

Character_GetFaction(playerid)
{
	foreach (new i : Factions)
	{
		if (CharacterData[playerid][e_CHARACTER_FACTION] != FactionData[i][e_FACTION_ID])
			continue;

		return i;
	}

	return -1;
}

Character_GetMoney(playerid)
{
	return CharacterData[playerid][e_CHARACTER_MONEY];
}

Character_GiveMoney(playerid, money)
{
	CharacterData[playerid][e_CHARACTER_MONEY] += money;
	return GivePlayerMoney(playerid, money);
}