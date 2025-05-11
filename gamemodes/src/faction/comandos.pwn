// Comando Gerais
CMD:membros(playerid)
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return SendErrorMessage(playerid, "Você não faz parte de uma facção.");

	SendClientMessage(playerid, COLOR_GREEN, "Membros da facção online:");

	foreach (new i : Player)
	{
		if (Character_GetFaction(i) != id)
			continue;

		SendClientMessageEx(playerid, (Faction_IsInDuty(i) ? FactionData[id][e_FACTION_COLOR] : COLOR_GREY), "%s %s (ID: %i)", CharacterData[i][e_CHARACTER_FACTION_RANK], Character_GetName(i), i);
	}
	return true;
}

alias:f("fac")
CMD:f(playerid, params[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return SendErrorMessage(playerid, "Você não faz parte de uma facção.");

	if (IsNull(params))
		return SendUsageMessage(playerid, "/(f)ac [mensagem]");

	if (FactionData[id][e_FACTION_TYPE] == FACTION_TYPE_POLICE)
	{
		if (strlen(params) > 64)
		{
			SendFactionMessage(id, COLOR_POLICE, "**(( %s %s: %.64s", CharacterData[playerid][e_CHARACTER_FACTION_RANK], Character_GetName(playerid, false), params);
			SendFactionMessage(id, COLOR_POLICE, "...%.64s ))**", params[64]);
		}
		else
		{
			SendFactionMessage(id, COLOR_POLICE, "**(( %s %s: %.64s ))**", CharacterData[playerid][e_CHARACTER_FACTION_RANK], Character_GetName(playerid, false), params);
		}
	}
	else
	{
		if (strlen(params) > 64)
		{
			SendFactionMessage(id, COLOR_FACTION, "**(( %s %s: %.64s", CharacterData[playerid][e_CHARACTER_FACTION_RANK], Character_GetName(playerid, false), params);
			SendFactionMessage(id, COLOR_FACTION, "...%.64s ))**", params[64]);
		}
		else
		{
			SendFactionMessage(id, COLOR_FACTION, "**(( %s %s: %.64s ))**", CharacterData[playerid][e_CHARACTER_FACTION_RANK], Character_GetName(playerid, false), params);
		}
	}

	return true;
}

CMD:sairfaccao(playerid)
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return SendErrorMessage(playerid, "Você não faz parte de uma facção.");

	if (FactionData[id][e_FACTION_TYPE] == FACTION_TYPE_POLICE)
	{
		SetPlayerArmour(playerid, 0.0);
		ResetPlayerWeapons(playerid);
	}
	
	SendFactionMessage(id, FactionData[id][e_FACTION_TYPE] == FACTION_TYPE_POLICE ? COLOR_POLICE : COLOR_FACTION, "FACTION: %s %s saiu da facção.", CharacterData[playerid][e_CHARACTER_FACTION_RANK], Character_GetName(playerid, false));
	SendClientMessageEx(playerid, COLOR_GREEN, "Você saiu da facção %s (cargo: %s)", FactionData[id][e_FACTION_NAME], CharacterData[playerid][e_CHARACTER_FACTION_RANK]);

	CharacterData[playerid][e_CHARACTER_FACTION] = -1;
	CharacterData[playerid][e_CHARACTER_FACTION_MOD] = 0;
	CharacterData[playerid][e_CHARACTER_FACTION_DUTY] = false;
	format (CharacterData[playerid][e_CHARACTER_FACTION_RANK], 32, "Membro");
	Character_UpdateColor(playerid);
	Character_Save(playerid);
	return true;
}