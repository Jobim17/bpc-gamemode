/*
	oooooooooooo                 .
	`888'     `8               .o8
	 888         ooo. .oo.   .o888oo oooo d8b  .oooo.   ooo. .oo.    .ooooo.   .ooooo.   .oooo.o
	 888oooo8    `888P"Y88b    888   `888""8P `P  )88b  `888P"Y88b  d88' `"Y8 d88' `88b d88(  "8
	 888    "     888   888    888    888      .oP"888   888   888  888       888ooo888 `"Y88b.
	 888       o  888   888    888 .  888     d8(  888   888   888  888   .o8 888    .o o.  )88b
	o888ooooood8 o888o o888o   "888" d888b    `Y888""8o o888o o888o `Y8bod8P' `Y8bod8P' 8""888P'
*/

// Variáveis
static const s_arrayEntranceIcons[] = {
	954, 1210, 1212, 1213, 1239, 1240, 1241, 1242, 1247, 1248, 1252, 1254, 1272, 1273, 1274, 
	1275, 1276, 1277, 1279, 1310, 1313, 1314, 1318, 1550, 1575, 1576, 1577, 1578, 1579, 1580, 
	1581, 1582, 1636, 1650, 1654, 2057, 2060, 2061, 19130, 19131, 19132, 19133, 19134, 19135, 
	19197, 19198, 19320, 19522, 19523, 19524, 19602, 19605, 19606, 19607, 19832
};

static s_pEditingEntrance[MAX_PLAYERS] = {-1, ...};

// Functions	
Entrance_Load()
{
	Iter_Clear(Entrances);

	inline Entrance_OnLoaded()
	{
		new rows;
		rows = cache_num_rows();

		for (new i = 0; i < MAX_ENTRANCES; i++)
		{
			// Reset
			if (i >= rows) {
				EntranceData[i] = EntranceData[MAX_ENTRANCES];
				continue;
			}

			// Get values
			EntranceData[i][e_ENTRANCE_EXISTS] = true;
			cache_get_value_name_int(i, "ID", EntranceData[i][e_ENTRANCE_ID]);
			cache_get_value_name(i, "Nome", EntranceData[i][e_ENTRANCE_NAME]);
			cache_get_value_name_int(i, "Ícone", EntranceData[i][e_ENTRANCE_ICON_MODEL]);
			cache_get_value_name_float(i, "PosX", EntranceData[i][e_ENTRANCE_POS][0]);
			cache_get_value_name_float(i, "PosY", EntranceData[i][e_ENTRANCE_POS][1]);
			cache_get_value_name_float(i, "PosZ", EntranceData[i][e_ENTRANCE_POS][2]);
			cache_get_value_name_int(i, "Interior", EntranceData[i][e_ENTRANCE_WORLD]);
			cache_get_value_name_int(i, "World", EntranceData[i][e_ENTRANCE_WORLD]);
			cache_get_value_name_float(i, "InsidePosX", EntranceData[i][e_ENTRANCE_INSIDE_POS][0]);
			cache_get_value_name_float(i, "InsidePosY", EntranceData[i][e_ENTRANCE_INSIDE_POS][1]);
			cache_get_value_name_float(i, "InsidePosZ", EntranceData[i][e_ENTRANCE_INSIDE_POS][2]);
			cache_get_value_name_float(i, "InsidePosA", EntranceData[i][e_ENTRANCE_INSIDE_POS][3]);
			cache_get_value_name_int(i, "InsideWorld", EntranceData[i][e_ENTRANCE_INSIDE_WORLD]);
			cache_get_value_name_int(i, "InsideInterior", EntranceData[i][e_ENTRANCE_INSIDE_INTERIOR]);

			Iter_Add(Entrances, i);

			Entrance_Refresh(i);
		}

		if (rows)
			printf("[Entrance] Loaded %i entrances.", rows);
		else
			print("[Entrance] No entrances to load.");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Entrance_OnLoaded, "SELECT * FROM `Entradas` LIMIT %i;", MAX_ENTRANCES);
	return true;
}

Entrance_Create(playerid, const name[])
{
	new idx = Iter_Free(Entrances);

	if (idx != ITER_NONE)
	{
		inline Entrance_OnCreated()
		{
			if (cache_affected_rows())
			{
				EntranceData[idx][e_ENTRANCE_ID] = cache_insert_id();

				Entrance_Save(idx);
				Entrance_Refresh(idx);
			}
		}

		EntranceData[idx][e_ENTRANCE_EXISTS] = true;
		format (EntranceData[idx][e_ENTRANCE_NAME], 32, name);

		GetPlayerPos(playerid, EntranceData[idx][e_ENTRANCE_POS][0], EntranceData[idx][e_ENTRANCE_POS][1], EntranceData[idx][e_ENTRANCE_POS][2]);
		EntranceData[idx][e_ENTRANCE_INTERIOR] = GetPlayerInterior(playerid);
		EntranceData[idx][e_ENTRANCE_WORLD] = GetPlayerVirtualWorld(playerid);

		EntranceData[idx][e_ENTRANCE_INSIDE_POS][0] =
		EntranceData[idx][e_ENTRANCE_INSIDE_POS][1] =
		EntranceData[idx][e_ENTRANCE_INSIDE_POS][2] =
		EntranceData[idx][e_ENTRANCE_INSIDE_POS][3] = 0.0;
		EntranceData[idx][e_ENTRANCE_INSIDE_WORLD] = (WORLD_ENTRANCE + idx);

		EntranceData[idx][e_ENTRANCE_ICON_MODEL] = 1239;

		Iter_Add(Entrances, idx);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Entrance_OnCreated, "INSERT IGNORE INTO `Entradas` (`Nome`, `Criador`) VALUES ('%e', '%e');", name, AccountData[playerid][e_ACCOUNT_NAME]);
	}

	return idx;
}

Entrance_Refresh(index)
{
	if(!(0 <= index < MAX_ENTRANCES) || !EntranceData[index][e_ENTRANCE_EXISTS])
		return 1;

	if(IsValidDynamicArea(EntranceData[index][e_ENTRANCE_AREA][0]))
		DestroyDynamicArea(EntranceData[index][e_ENTRANCE_AREA][0]);

	if(IsValidDynamicArea(EntranceData[index][e_ENTRANCE_AREA][1]))
		DestroyDynamicArea(EntranceData[index][e_ENTRANCE_AREA][1]);

	if(IsValidDynamicPickup(EntranceData[index][e_ENTRANCE_ICON]))
		DestroyDynamicPickup(EntranceData[index][e_ENTRANCE_ICON]);

	EntranceData[index][e_ENTRANCE_ICON] = CreateDynamicPickup(
		EntranceData[index][e_ENTRANCE_ICON_MODEL], 
		23, 
		EntranceData[index][e_ENTRANCE_POS][0], 
		EntranceData[index][e_ENTRANCE_POS][1], 
		EntranceData[index][e_ENTRANCE_POS][2], 
		EntranceData[index][e_ENTRANCE_WORLD], 
		EntranceData[index][e_ENTRANCE_INTERIOR]
	);

	EntranceData[index][e_ENTRANCE_AREA][0] = CreateDynamicSphere(
		EntranceData[index][e_ENTRANCE_POS][0], 
		EntranceData[index][e_ENTRANCE_POS][1], 
		EntranceData[index][e_ENTRANCE_POS][2], 
		2.5, 
		EntranceData[index][e_ENTRANCE_WORLD], 
		EntranceData[index][e_ENTRANCE_INTERIOR]
	);

	EntranceData[index][e_ENTRANCE_AREA][1] = CreateDynamicSphere(
		EntranceData[index][e_ENTRANCE_INSIDE_POS][0], 
		EntranceData[index][e_ENTRANCE_INSIDE_POS][1], 
		EntranceData[index][e_ENTRANCE_INSIDE_POS][2], 
		2.5, 
		EntranceData[index][e_ENTRANCE_INSIDE_WORLD], 
		EntranceData[index][e_ENTRANCE_INSIDE_INTERIOR]
	);

	return 1;
}

Entrance_Save(index)
{
	if(!(0 <= index < MAX_ENTRANCES) || !EntranceData[index][e_ENTRANCE_EXISTS])
		return 1;

	inline Entrance_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE, 
		using inline Entrance_OnSaved, 
		"UPDATE IGNORE `Entradas` SET \
		`Nome`='%e',\
		`Ícone`=%i,\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`Interior`=%i,\
		`World`=%i, \
		`InsidePosX` = '%f',\
		`InsidePosY` = '%f',\
		`InsidePosZ` = '%f',\
		`InsidePosA` = '%f',\
		`InsideWorld` = %i, \
		`InsideInterior` = %i \
		WHERE `ID` = %i LIMIT 1;",
		EntranceData[index][e_ENTRANCE_NAME],
		EntranceData[index][e_ENTRANCE_ICON_MODEL],
		EntranceData[index][e_ENTRANCE_POS][0],
		EntranceData[index][e_ENTRANCE_POS][1],
		EntranceData[index][e_ENTRANCE_POS][2],
		EntranceData[index][e_ENTRANCE_INTERIOR],
		EntranceData[index][e_ENTRANCE_WORLD],
		EntranceData[index][e_ENTRANCE_INSIDE_POS][0],
		EntranceData[index][e_ENTRANCE_INSIDE_POS][1],
		EntranceData[index][e_ENTRANCE_INSIDE_POS][2],
		EntranceData[index][e_ENTRANCE_INSIDE_POS][3],
		EntranceData[index][e_ENTRANCE_INSIDE_WORLD],
		EntranceData[index][e_ENTRANCE_INSIDE_INTERIOR],
		EntranceData[index][e_ENTRANCE_ID]
	);

	return true;
}

Entrance_Destroy(index)
{
	if(!(0 <= index < MAX_ENTRANCES) || !EntranceData[index][e_ENTRANCE_EXISTS])
		return 1;

	if(IsValidDynamicArea(EntranceData[index][e_ENTRANCE_AREA][0]))
		DestroyDynamicArea(EntranceData[index][e_ENTRANCE_AREA][0]);

	if(IsValidDynamicArea(EntranceData[index][e_ENTRANCE_AREA][1]))
		DestroyDynamicArea(EntranceData[index][e_ENTRANCE_AREA][1]);

	if(IsValidDynamicPickup(EntranceData[index][e_ENTRANCE_ICON]))
		DestroyDynamicPickup(EntranceData[index][e_ENTRANCE_ICON]);

	new query[64];
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Entradas` WHERE `ID` = %i;", EntranceData[index][e_ENTRANCE_ID]);
	mysql_tquery (MYSQL_CUR_HANDLE, query);

	foreach (new i : Player) 
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
			continue;

		if (Entrance_Inside(i) != index)
			continue;

		Character_SetPos(
			i, 
			EntranceData[index][e_ENTRANCE_POS][0], 
			EntranceData[index][e_ENTRANCE_POS][1], 
			EntranceData[index][e_ENTRANCE_POS][2],
			-1.0, 
			EntranceData[index][e_ENTRANCE_WORLD],
			EntranceData[index][e_ENTRANCE_INTERIOR]
		);

		SendClientMessage(i, COLOR_LIGHTRED, "Esse interior foi apagado por algum administrador.");
	}

	EntranceData[index] = EntranceData[MAX_ENTRANCES];
	Iter_Remove(Entrances, index);
	return true;
}

Entrance_Inside(playerid)
{
	foreach (new i : Entrances)
	{
		if (EntranceData[i][e_ENTRANCE_EXISTS] && GetPlayerVirtualWorld(playerid) == EntranceData[i][e_ENTRANCE_INSIDE_WORLD] && GetPlayerInterior(playerid) == EntranceData[i][e_ENTRANCE_INSIDE_INTERIOR])
		{
			return i;
		}
	}

	return -1;
}

Entrance_Nearest(playerid, Float:radius=2.5)
{
	new idx = -1;

	foreach (new i : Entrances)
	{
		if (GetPlayerInterior(playerid) != EntranceData[i][e_ENTRANCE_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != EntranceData[i][e_ENTRANCE_WORLD])
			continue;

		if (GetPlayerDistanceFromPoint(playerid, EntranceData[i][e_ENTRANCE_POS][0], EntranceData[i][e_ENTRANCE_POS][1], EntranceData[i][e_ENTRANCE_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, EntranceData[i][e_ENTRANCE_POS][0], EntranceData[i][e_ENTRANCE_POS][1], EntranceData[i][e_ENTRANCE_POS][2]);
		}
	}

	return idx;
}

// Dialogs
Dialog:DIALOG_ENT_EDIT_ICON(playerid, response, listitem, inputtext[])
{
	if (response && (0 <= listitem < sizeof s_arrayEntranceIcons))
	{
		new index = s_pEditingEntrance[playerid], icon = s_arrayEntranceIcons[listitem];

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o ícone da entrada %i para o modelo %i.", AccountData[playerid][e_ACCOUNT_NAME], index, icon);

		EntranceData[index][e_ENTRANCE_ICON_MODEL] = icon;
		Entrance_Save(index);
		Entrance_Refresh(index);
	}

	return true;
}

// Comandos
CMD:criarentrada(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

	static
		index;

	if (IsNull(params))
		return SendUsageMessage(playerid, "/criarentrada [Nome]");

	if (strlen(params) > 32)
		return SendErrorMessage(playerid, "Nome de entrada muito extenso.");

	index = Entrance_Create(playerid, params);

	if (index == ITER_NONE)
		return SendErrorMessage(playerid, "Não foi possível criar a entrada.");

	Log_Create("[Property Team] Entradas", "%s criou a entrada \"%s\"", AccountData[playerid][e_ACCOUNT_NAME], params);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s criou a entrada \"%s\" (%i)", AccountData[playerid][e_ACCOUNT_NAME], params, index);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você criou a entrada \"%s\" (ID: %i).", params, index);
	return true;
}

CMD:editarentrada(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

	static
	    id,
	    type[24],
	    string[128];

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarentrada [id] [opção]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opções]: nome, ícone, localizacao, interior, mundo");
		return 1;
	}

	if ((id < 0 || id >= MAX_ENTRANCES) || !EntranceData[id][e_ENTRANCE_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de entrada inválido.");

	if (!strcmp(type, "nome", true))
	{
		new name[32];

		if (sscanf(string, "s[32]", name))
			return SendUsageMessage(playerid, "/editarentrada id nome [NovoNome]");

		if (!(1 <= strlen(name) <= 32))
			return SendErrorMessage(playerid, "O novo nome precisa ter de 1 a 32 caracteres.");

		Log_Create("[Property Team] Entradas", "%s ajustou o nome da entrada \"%s\" para \"%s\" [%i]", AccountData[playerid][e_ACCOUNT_NAME], EntranceData[id][e_ENTRANCE_NAME], name, EntranceData[id][e_ENTRANCE_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o nome da entrada %i para \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], id, name);
	
		format (EntranceData[id][e_ENTRANCE_NAME], 32, name);
		Entrance_Save(id);
	}
	else if (!strcmp(type, "ícone", true) || !strcmp(type, "icone", true))
	{
		new dialog[1024];

		for (new i = 0; i < sizeof s_arrayEntranceIcons; i++)
		{
			strcat (dialog, va_return("\n%i\t%i", s_arrayEntranceIcons[i], s_arrayEntranceIcons[i]));
		}

		s_pEditingEntrance[playerid] = id;
		Dialog_Show(playerid, DIALOG_ENT_EDIT_ICON, DIALOG_STYLE_PREVIEW_MODEL, va_return("ícone de %s", EntranceData[id][e_ENTRANCE_NAME]), dialog, "Selecionar", "Voltar");
	}
	else if (!strcmp(type, "localizacao", true))
	{
		GetPlayerPos(playerid, EntranceData[id][e_ENTRANCE_POS][0], EntranceData[id][e_ENTRANCE_POS][1], EntranceData[id][e_ENTRANCE_POS][2]);
		EntranceData[id][e_ENTRANCE_WORLD] = GetPlayerVirtualWorld(playerid);
		EntranceData[id][e_ENTRANCE_INTERIOR] = GetPlayerInterior(playerid);

		Entrance_Save(id);
		Entrance_Refresh(id);

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou a posição da entrada \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], EntranceData[id][e_ENTRANCE_NAME]);
	}
	else if (!strcmp(type, "interior", true))
	{
		foreach (new i : Player) 
		{
			if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
				continue;

			if (Entrance_Inside(i) != id)
				continue;

			Character_SetPos(
				i, 
				EntranceData[id][e_ENTRANCE_POS][0], 
				EntranceData[id][e_ENTRANCE_POS][1], 
				EntranceData[id][e_ENTRANCE_POS][2],
				-1.0, 
				EntranceData[id][e_ENTRANCE_WORLD],
				EntranceData[id][e_ENTRANCE_INTERIOR]
			);

			SendClientMessage(i, COLOR_LIGHTRED, "A posição do interior foi reajustada por um administrador.");
		}

		GetPlayerPos(playerid, EntranceData[id][e_ENTRANCE_INSIDE_POS][0], EntranceData[id][e_ENTRANCE_INSIDE_POS][1], EntranceData[id][e_ENTRANCE_INSIDE_POS][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][e_ENTRANCE_INSIDE_POS][3]);
		EntranceData[id][e_ENTRANCE_INSIDE_INTERIOR] = GetPlayerInterior(playerid);

		Entrance_Save(id);
		Entrance_Refresh(id);

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou a posição do interior da entrada \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], EntranceData[id][e_ENTRANCE_NAME]);
	}
	else if (!strcmp(type, "mundo", true))
	{
		foreach (new i : Player) 
		{
			if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
				continue;

			if (Entrance_Inside(i) != id)
				continue;

			SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
		}

		EntranceData[id][e_ENTRANCE_INSIDE_WORLD] = GetPlayerVirtualWorld(playerid);
		Entrance_Save(id);
		Entrance_Refresh(id);

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o mundo da entrada \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], EntranceData[id][e_ENTRANCE_NAME]);
	}
	else SendErrorMessage(playerid, "Você especificou uma opção inválida.");

	return 1;
}

CMD:destruirentrada(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

	static
		index;

	if (sscanf(params, "i", index))
		return SendUsageMessage(playerid, "/destruirentrada [Id]");

	if (!(0 <= index < MAX_ENTRANCES) || !EntranceData[index][e_ENTRANCE_EXISTS])
		return SendErrorMessage(playerid, "Você especificou um ID de entrada inválido.");

	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s deletou a entrada \"%s\" (%i)", AccountData[playerid][e_ACCOUNT_NAME], EntranceData[index][e_ENTRANCE_NAME], index);
	Log_Create("[Property Team] Entradas", "%s deletou a entrada \"%s\" (ID: %i)", AccountData[playerid][e_ACCOUNT_NAME], EntranceData[index][e_ENTRANCE_NAME], EntranceData[index][e_ENTRANCE_ID]);
	
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "Você deletou a entrada \"%s\" (%i)", EntranceData[index][e_ENTRANCE_NAME], index);
	Entrance_Destroy(index);
	return true;
}