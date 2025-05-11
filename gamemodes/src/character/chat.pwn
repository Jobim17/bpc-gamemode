/*
	  .oooooo.   oooo                      .
	 d8P'  `Y8b  `888                    .o8
	888           888 .oo.    .oooo.   .o888oo
	888           888P"Y88b  `P  )88b    888
	888           888   888   .oP"888    888
	`88b    ooo   888   888  d8(  888    888 .
	 `Y8bood8P'  o888o o888o `Y888""8o   "888"

*/

// Include
#include <YSI_Coding\y_hooks>

// Callbacks
public OnPlayerText(playerid, text[])
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	SendProxMessage(20.0, playerid, "%s diz: %.64s", Character_GetName(playerid), text);

	if (strlen(text) > 64)
	{
		SendProxMessage(20.0, playerid, "...%s", text[64]);
	}

	return false;
}

// Comandos
CMD:me(playerid, params[])
{
	if (IsNull(params))
		return SendUsageMessage(playerid, "/me [ação a ser realizada]");

	new id, size = strlen(params);

	// Inside
	if ((id = Business_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 5.0, BusinessData[id][e_BUSINESS_INSIDE_POS][0], BusinessData[id][e_BUSINESS_INSIDE_POS][1], BusinessData[id][e_BUSINESS_INSIDE_POS][2]))
	{
		foreach (new i : Player)
		{
			if (Business_Nearest(i, 5.0) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s", params);
			}
		}
	}
	else if ((id = House_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 5.0, HouseData[id][e_HOUSE_INSIDE_POS][0], HouseData[id][e_HOUSE_INSIDE_POS][1], HouseData[id][e_HOUSE_INSIDE_POS][2]))
	{
		foreach (new i : Player)
		{
			if (House_Nearest(i, 5.0) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s", params);
			}
		}
	}
	else if ((id = Entrance_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 5.0, EntranceData[id][e_ENTRANCE_INSIDE_POS][0], EntranceData[id][e_ENTRANCE_INSIDE_POS][1], EntranceData[id][e_ENTRANCE_INSIDE_POS][2]))
	{
		foreach (new i : Player)
		{
			if (Entrance_Nearest(i, 5.0) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s", params);
			}
		}
	}

	// Outside
	if ((id = Business_Nearest(playerid, 5.0)) != -1)
	{
		foreach (new i : Player)
		{
			if (Business_Inside(i) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s", params);
			}
		}
	}
	else if ((id = House_Nearest(playerid, 5.0)) != -1)
	{
		foreach (new i : Player)
		{
			if (House_Inside(i) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s", params);
			}
		}
	}
	else if ((id = Entrance_Nearest(playerid, 5.0)) != -1)
	{
		foreach (new i : Player)
		{
			if (Entrance_Inside(i) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s", params);
			}
		}
	}

	// Send message
	SendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s %.64s", Character_GetName(playerid), params);

	if (size > 64)
	{
		SendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "...%.64s", params[64]);
	}
	return true;
}

CMD:ame(playerid, params[])
{
	if (IsNull(params))
		return SendUsageMessage(playerid, "/ame [ação a ser realizada]");

	new Float:range = 40.0;

	if (GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid))
		range = 5.0;

	SendClientMessageEx(playerid, COLOR_PURPLE, "> %s %.64s", Character_GetName(playerid), params);

	if (strlen(params) > 64)
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "...%.64s", params[64]);
	}

	SetPlayerChatBubble(playerid, va_return("* %s %s", Character_GetName(playerid), params), COLOR_PURPLE, range, 15000);
	return true;
}

CMD:do(playerid, params[])
{
	if (IsNull(params))
		return SendUsageMessage(playerid, "/do [descrição]");

	new id, size = strlen(params);

	// Inside
	if ((id = Business_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 5.0, BusinessData[id][e_BUSINESS_INSIDE_POS][0], BusinessData[id][e_BUSINESS_INSIDE_POS][1], BusinessData[id][e_BUSINESS_INSIDE_POS][2]))
	{
		foreach (new i : Player)
		{
			if (Business_Nearest(i) != id) continue;

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %.64s", params);
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
			}
			else
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %.64s (( %s ))", params, Character_GetName(playerid));
			}
		}
	}
	else if ((id = House_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 5.0, HouseData[id][e_HOUSE_INSIDE_POS][0], HouseData[id][e_HOUSE_INSIDE_POS][1], HouseData[id][e_HOUSE_INSIDE_POS][2]))
	{
		foreach (new i : Player)
		{
			if (House_Nearest(i, 5.0) != id) continue;

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %.64s", params);
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
			}
			else
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %.64s (( %s ))", params, Character_GetName(playerid));
			}
		}
	}
	else if ((id = Entrance_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 5.0, EntranceData[id][e_ENTRANCE_INSIDE_POS][0], EntranceData[id][e_ENTRANCE_INSIDE_POS][1], EntranceData[id][e_ENTRANCE_INSIDE_POS][2]))
	{
		foreach (new i : Player)
		{
			if (Entrance_Nearest(i, 5.0) != id) continue;

			SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %s %.64s", Character_GetName(playerid), params);

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %.64s", params);
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
			}
			else
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[DENTRO] * %.64s (( %s ))", params, Character_GetName(playerid));
			}
		}
	}

	// Outside
	if ((id = Business_Nearest(playerid, 5.0)) != -1)
	{
		foreach (new i : Player)
		{
			if (Business_Inside(i) != id) continue;

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %.64s", params);
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
			}
			else
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %.64s (( %s ))", params, Character_GetName(playerid));
			}
		}
	}
	else if ((id = House_Nearest(playerid, 5.0)) != -1)
	{
		foreach (new i : Player)
		{
			if (House_Inside(i) != id) continue;

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %.64s", params);
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
			}
			else
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %.64s (( %s ))", params, Character_GetName(playerid));
			}
		}
	}
	else if ((id = Entrance_Nearest(playerid, 5.0)) != -1)
	{
		foreach (new i : Player)
		{
			if (Entrance_Inside(i) != id) continue;

			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %.64s", params);
				SendClientMessageEx(i, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
			}
			else
			{
				SendClientMessageEx(i, COLOR_PURPLE, "[FORA] * %.64s (( %s ))", params, Character_GetName(playerid));
			}
		}
	}

	// Send message
	if (size > 64)
	{
		SendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %.64s", params);
		SendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
	}
	else
	{
		SendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %.64s (( %s ))", params, Character_GetName(playerid));
	}
	return true;
}

CMD:ado(playerid, params[])
{
	if (IsNull(params))
		return SendUsageMessage(playerid, "/ado [descrição]");

	new Float:range = 40.0;

	if (GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid))
		range = 5.0;

	if (strlen(params) > 64)
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "> %.64s", params);
		SendClientMessageEx(playerid, COLOR_PURPLE, "...%.64s (( %s ))", params[64], Character_GetName(playerid));
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_PURPLE, "* %.64s (( %s ))", params, Character_GetName(playerid));
	}

	SetPlayerChatBubble(playerid, va_return("* %s (( %s ))", params, Character_GetName(playerid)), COLOR_PURPLE, range, 35000);
	return true;
}

CMD:b(playerid, params[])
{
	if (IsNull(params))
		return SendUsageMessage(playerid, "/b [OOC]");

	if (AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] && !AccountData[playerid][e_ACCOUNT_ADMIN_HIDE])
	{
		if (strlen(params) > 64)
		{
			SendNearbyMessage(playerid, COLOR_GREY, 7.0, "(( [%i] {408080}%s{%06x}: %.64s", playerid, AccountData[playerid][e_ACCOUNT_NAME], COLOR_GREY >>> 8, params);
			SendNearbyMessage(playerid, COLOR_GREY, 7.0, "...%s ))", params[64]);
		}
		else
		{
			SendNearbyMessage(playerid, COLOR_GREY, 7.0, "(( [%i] {408080}%s{%06x}: %.64s ))", playerid, AccountData[playerid][e_ACCOUNT_NAME], COLOR_GREY >>> 8, params);
		}
	}
	else
	{
		if (strlen(params) > 64)
		{
			SendNearbyMessage(playerid, COLOR_GREY, 20.0, "(( [%i] %s: %.64s", playerid, Character_GetName(playerid, false), params);
			SendNearbyMessage(playerid, COLOR_GREY, 20.0, "...%s ))", params[64]);
		}
		else
		{
			SendNearbyMessage(playerid, COLOR_GREY, 20.0, "(( [%i] %s: %.64s ))", playerid, Character_GetName(playerid, false), params);
		}
	}
	return true;
}