// Include
#include <YSI_Coding\y_hooks>

// Forwards
forward OnCharacterLoaded(playerid);
forward OnCharacterSaved(playerid);

// Connection
hook OnPlayerConnect(playerid)
{
	CharacterData[playerid] = CharacterData[MAX_PLAYERS];
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	Character_Save(playerid);
	return true;
}

hook Server_OnUpdate()
{
	if (!(gettime() % 60 * 5))
	{
		foreach (new i : Player)
		{
			if (IsPlayerLogged(i) && CharacterData[i][e_CHARACTER_ID] && CharacterData[i][e_CHARACTER_NAME][0] != '\0')
			{
				Character_Save(i);
			}
		}
	}
}

// Functions
Character_Load(playerid, id)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (CharacterData[playerid][e_CHARACTER_ID])
		return false;

	CharacterData[playerid][e_CHARACTER_LOADED_TIME] = gettime();

	inline Character_OnLoaded()
	{	
		if (!cache_num_rows())
		{
			KickPlayer(playerid);
			Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Não foi possível carregar seu personagem.", "Entendido", "");
			return true;
		}

		// Geral
		cache_get_value_name_int(0, "ID", CharacterData[playerid][e_CHARACTER_ID]);
		cache_get_value_name(0, "Nome", CharacterData[playerid][e_CHARACTER_NAME], MAX_PLAYER_NAME + 1);
		cache_get_value_name_int(0, "Dinheiro", CharacterData[playerid][e_CHARACTER_MONEY]);
		cache_get_value_name_int(0, "DinheiroBanco", CharacterData[playerid][e_CHARACTER_BANK_MONEY]);
		cache_get_value_name_int(0, "Nível", CharacterData[playerid][e_CHARACTER_LEVEL]);
		cache_get_value_name_int(0, "Experiência", CharacterData[playerid][e_CHARACTER_EXP]);
		cache_get_value_name_int(0, "Sede", CharacterData[playerid][e_CHARACTER_HUNGER]);
		cache_get_value_name_int(0, "Fome", CharacterData[playerid][e_CHARACTER_THIRST]);
		cache_get_value_name_int(0, "Skin", CharacterData[playerid][e_CHARACTER_SKIN]);
		cache_get_value_name_int(0, "Emprego", CharacterData[playerid][e_CHARACTER_JOB]);

		new empregoHoras[32], iEmpregoHoras[MAX_JOB];
		cache_get_value_name(0, "EmpregoHoras", empregoHoras);
		sscanf(empregoHoras, va_return("p<|>A<i>(0, 0)[%i]", MAX_JOB), iEmpregoHoras);
		CharacterData[playerid][e_CHARACTER_JOB_HOURS] = iEmpregoHoras;

		cache_get_value_name_int(0, "Paycheck", CharacterData[playerid][e_CHARACTER_PAYCHECK]);
		cache_get_value_name_int(0, "Facção", CharacterData[playerid][e_CHARACTER_FACTION]);
		cache_get_value_name_int(0, "FacçãoMod", CharacterData[playerid][e_CHARACTER_FACTION_MOD]);
		cache_get_value_name(0, "FacçãoRank", CharacterData[playerid][e_CHARACTER_FACTION_RANK]);

		// Aparência
		cache_get_value_name(0, "Olhos", CharacterData[playerid][e_CHARACTER_EYES], 16 + 1);
		cache_get_value_name(0, "Etnia", CharacterData[playerid][e_CHARACTER_ETNIA], 22 + 1);
		cache_get_value_name(0, "CidadeNatal", CharacterData[playerid][e_CHARACTER_ORIGIN], 32 + 1);
		cache_get_value_name(0, "DataNascimento", CharacterData[playerid][e_CHARACTER_BIRTHDATE], 10 + 1);

		// Spawn
		cache_get_value_name_int(0, "SpawnTempo", CharacterData[playerid][e_CHARACTER_SPAWN_EXPIRES]);
		cache_get_value_name_int(0, "SpawnPoint", CharacterData[playerid][e_CHARACTER_SPAWN_POINT]);
		cache_get_value_name_int(0, "SpawnId", CharacterData[playerid][e_CHARACTER_SPAWN_ID]);
		cache_get_value_name_float(0, "PosX", CharacterData[playerid][e_CHARACTER_POS][0]);
		cache_get_value_name_float(0, "PosY", CharacterData[playerid][e_CHARACTER_POS][1]);
		cache_get_value_name_float(0, "PosZ", CharacterData[playerid][e_CHARACTER_POS][2]);
		cache_get_value_name_float(0, "Angle", CharacterData[playerid][e_CHARACTER_ANGLE]);
		cache_get_value_name_int(0, "World", CharacterData[playerid][e_CHARACTER_WORLD]);
		cache_get_value_name_int(0, "Interior", CharacterData[playerid][e_CHARACTER_INTERIOR]);

		// Rádio
		cache_get_value_name_bool(0, "RádioOn", CharacterData[playerid][e_CHARACTER_RADIO_ON]);
		
		new radioCanais[128], radioCanaisOut[MAX_RADIO_SLOTS];
		cache_get_value_name(0, "RádioCanais", radioCanais);
		sscanf(radioCanais, "p<|>A<i>(0, 0)["#MAX_RADIO_SLOTS"]", radioCanaisOut);
		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS] = radioCanaisOut;

		// Informações Gerais
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, CharacterData[playerid][e_CHARACTER_MONEY]);
		SetPlayerScore(playerid, CharacterData[playerid][e_CHARACTER_LEVEL]);

		SetPlayerName(playerid, CharacterData[playerid][e_CHARACTER_NAME]);
		SetPlayerNameForPlayer(playerid, playerid, Character_GetName(playerid));
		SetPlayerColor(playerid, -1);

		// Set Spawn Information
		SetSpawnInfo(playerid, 0, CharacterData[playerid][e_CHARACTER_SKIN], 3000.0, 3000.0, 3000.0, 0.0, 0, 0, 0, 0, 0, 0);

		// Callbacks
		ClearPlayerMessages(playerid);
		CallRemoteFunction("OnCharacterLoaded", "i", playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Character_OnLoaded, "SELECT *, COALESCE(TIMESTAMPDIFF(SECOND, `Acesso`, NOW()), 0) AS `SpawnTempo` FROM `Personagens` WHERE `ID` = %i AND `Conta` = %i LIMIT 1;", id, AccountData[playerid][e_ACCOUNT_ID]);
	return true;
}

Character_Save(playerid)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	inline Character_OnSaved() { CallRemoteFunction("OnCharacterSaved", "i", playerid); }

	// Position
	if (IsPlayerSpawned(playerid) && (gettime() - CharacterData[playerid][e_CHARACTER_LOADED_TIME]) > 30)
	{
		GetPlayerPos(playerid, CharacterData[playerid][e_CHARACTER_POS][0], CharacterData[playerid][e_CHARACTER_POS][1], CharacterData[playerid][e_CHARACTER_POS][2]);
		GetPlayerFacingAngle(playerid, CharacterData[playerid][e_CHARACTER_ANGLE]);
		CharacterData[playerid][e_CHARACTER_WORLD] = GetPlayerVirtualWorld(playerid);
		CharacterData[playerid][e_CHARACTER_INTERIOR] = GetPlayerInterior(playerid);
	}

	// Horas
	new empregoHoras[32];

	for (new i = 0; i < MAX_JOB; i++)
	{
		strcat(empregoHoras, va_return("%s%i", (!i ? ("") : ("|")), CharacterData[playerid][e_CHARACTER_JOB_HOURS][i]));
	}

	// Query
	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Character_OnSaved, 
		"UPDATE IGNORE `Personagens` SET \
		`Nome` = '%e', \
		`Dinheiro` = %i, \
		`DinheiroBanco` = %i,\
		`Nível` = %i, \
		`Experiência` = %i, \
		`Sede` = %i, \
		`Fome` = %i, \
		`Skin` = %i, \
		`Olhos` = '%e', \
		`Etnia` = '%e', \
		`CidadeNatal` = '%e', \
		`DataNascimento` = '%e', \
		`Emprego` = %i, \
		`EmpregoHoras` = '%s', \
		`Paycheck` = %i, \
		`Facção`=%i,\
		`FacçãoMod`=%i,\
		`FacçãoRank`='%e',\
		`SpawnPoint`=%i,\
		`SpawnId`=%i,\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`Angle`='%f',\
		`World`=%i,\
		`Interior`=%i,\
		`RádioOn`=%i,\
		`RádioCanais`='%i|%i|%i|%i|%i',\
		`Acesso` = NOW() \
		WHERE `ID` = %i LIMIT 1;",
		CharacterData[playerid][e_CHARACTER_NAME],
		CharacterData[playerid][e_CHARACTER_MONEY],
		CharacterData[playerid][e_CHARACTER_BANK_MONEY],
		CharacterData[playerid][e_CHARACTER_LEVEL],
		CharacterData[playerid][e_CHARACTER_EXP],
		CharacterData[playerid][e_CHARACTER_THIRST],
		CharacterData[playerid][e_CHARACTER_HUNGER],
		CharacterData[playerid][e_CHARACTER_SKIN],
		CharacterData[playerid][e_CHARACTER_EYES],
		CharacterData[playerid][e_CHARACTER_ETNIA],
		CharacterData[playerid][e_CHARACTER_ORIGIN],
		CharacterData[playerid][e_CHARACTER_BIRTHDATE],
		CharacterData[playerid][e_CHARACTER_JOB],
		empregoHoras,
		CharacterData[playerid][e_CHARACTER_PAYCHECK],
		CharacterData[playerid][e_CHARACTER_FACTION],
		CharacterData[playerid][e_CHARACTER_FACTION_MOD],
		CharacterData[playerid][e_CHARACTER_FACTION_RANK],
		CharacterData[playerid][e_CHARACTER_SPAWN_POINT],
		CharacterData[playerid][e_CHARACTER_SPAWN_ID],
		CharacterData[playerid][e_CHARACTER_POS][0],
		CharacterData[playerid][e_CHARACTER_POS][1],
		CharacterData[playerid][e_CHARACTER_POS][2],
		CharacterData[playerid][e_CHARACTER_ANGLE],
		CharacterData[playerid][e_CHARACTER_WORLD],
		CharacterData[playerid][e_CHARACTER_INTERIOR],
		CharacterData[playerid][e_CHARACTER_RADIO_ON],
		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][0],
		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][1],
		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][2],
		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][3],
		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][4],
		CharacterData[playerid][e_CHARACTER_ID]
	);

	return true;
}