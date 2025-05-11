/*
	oooooooooooo                                       .    o8o
	`888'     `8                                     .o8    `"'
	 888         oooo  oooo  ooo. .oo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o
	 888oooo8    `888  `888  `888P"Y88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8
	 888    "     888   888   888   888  888         888    888  888   888  888   888  `"Y88b.
	 888          888   888   888   888  888   .o8   888 .  888  888   888  888   888  o.  )88b
	o888o         `V88V"V8P' o888o o888o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P'
*/

Admin_CheckPermission(playerid, level, bool:working = false, bool:sendMessage = true)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (GetPlayerVirtualWorld(playerid) == WORLD_PLAYER_LOGIN)
		return false;

	if (level > AccountData[playerid][e_ACCOUNT_ADMIN] || GetGVarInt("CLOSED_BETA") == 0 && AccountData[playerid][e_ACCOUNT_ADMIN_TEMP])
	{
		if (sendMessage) {
			SendErrorMessage(playerid, "Você não tem permissão para usar este comando.");	
		}

		if (AccountData[playerid][e_ACCOUNT_ADMIN_TEMP])
		{
			AccountData[playerid][e_ACCOUNT_ADMIN] = 0;
			AccountData[playerid][e_ACCOUNT_ADMIN_TEMP] = false;
			Account_Save(playerid);
		}

		return false;
	}

	if (working && !AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] && AccountData[playerid][e_ACCOUNT_ADMIN] < 5)
	{
		if (sendMessage) {
			SendErrorMessage(playerid, "Você precisa estar em serviço administrativo.");
		}	

		return false;
	}

	return true;
}

Admin_SendMessage(level, color, const msg[], va_args<>)
{
	new out[144];
	va_format(out, sizeof out, msg, va_start<3>);

	foreach (new i : Player)
	{
		if (!Admin_CheckPermission(i, level, false, false))
			continue;

		SendClientMessage(i, color, out);
	}

	return true;
}

Admin_SendOnDutyMessage(level, color, const msg[], va_args<>)
{
	new out[144];
	va_format(out, sizeof out, msg, va_start<3>);

	foreach (new i : Player)
	{
		if (!Admin_CheckPermission(i, level, true, false))
			continue;

		if (!AccountData[i][e_ACCOUNT_ADMIN_DUTY])
			continue;

		SendClientMessage(i, color, out);
	}

	return true;
}

Admin_CheckTeam(playerid, team, bool:sendMessage = true)
{
	if (!Admin_CheckPermission(playerid, 1))
		return false;

	if (!((AccountData[playerid][e_ACCOUNT_ADMIN_TEAMS]) & team) && AccountData[playerid][e_ACCOUNT_ADMIN] < LEAD_ADMIN)
	{
		if (sendMessage)
			SendErrorMessage(playerid, "Você não tem permissão para usar este comando.");	

		return false;
	}

	return true;
}

Admin_LevelName(level)
{
	new ret[32] = "N/A";

	switch (level)
	{
		case JUNIOR_ADMIN: ret = "Junior Admin";
		case GAME_ADMIN_I: ret = "Game Admin I";
		case GAME_ADMIN_II: ret = "Game Admin II";
		case SENIOR_ADMIN: ret = "Sênior Admin";
		case LEAD_ADMIN: ret = "Lead Admin";
		case MANAGER: ret = "Manager";
	}

	return ret;
}

Admin_GetStars(playerid)
{
	if (!(0 <= playerid < MAX_PLAYERS))
		return 0;

	if (!AccountData[playerid][e_ACCOUNT_ADMIN_AVALIATIONS])
		return 0;

	return (((AccountData[playerid][e_ACCOUNT_ADMIN_STARS]) / (AccountData[playerid][e_ACCOUNT_ADMIN_AVALIATIONS] * 5)) / 2);
}