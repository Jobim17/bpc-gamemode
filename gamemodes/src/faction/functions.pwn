Faction_IsInDuty(playerid)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (!Faction_IsGovEmployee(playerid))
		return true;

	return false;
}

Faction_IsGovEmployee(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID] || CharacterData[playerid][e_CHARACTER_FACTION] == -1)
		return -1;

	new id = Character_GetFaction(playerid);

	if (id == -1) return -1;

	switch (FactionData[id][e_FACTION_TYPE])
	{
		case FACTION_TYPE_MEDIC, FACTION_TYPE_POLICE, FACTION_TYPE_GOV: return true;
	}

	return -1;
}

Faction_GetPlayerType(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID] || CharacterData[playerid][e_CHARACTER_FACTION] == -1)
		return -1;

	new id = Character_GetFaction(playerid);

	if (id == -1) return -1;

	return FactionData[id][e_FACTION_TYPE];
}

SendFactionMessage(factionid, color, const msg[], va_args<>)
{
	if (!(0 <= factionid < MAX_FACTIONS) || !FactionData[factionid][e_FACTION_EXISTS])
		return false;

	new out[144];
	va_format(out, sizeof out, msg, va_start<3>);

	foreach (new i : Player)
	{
		if (CharacterData[i][e_CHARACTER_FACTION] != FactionData[factionid][e_FACTION_ID])
			continue;

		SendClientMessage(i, color, out);
	}
	
	return true;
}