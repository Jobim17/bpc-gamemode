/*
	oooooooooooo                         .    o8o
	`888'     `8                       .o8    `"'
	 888          .oooo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o
	 888oooo8    `P  )88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8
	 888    "     .oP"888  888         888    888  888   888  888   888  `"Y88b.
	 888         d8(  888  888   .o8   888 .  888  888   888  888   888  o.  )88b
	o888o        `Y888""8o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P'
		
*/

// Include
#include <YSI_Coding\y_hooks>

// Functions
Faction_Load()
{
	Iter_Clear(Factions);

	inline Faction_OnLoaded()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_FACTIONS; i++)
		{
			if (i >= rows) 
			{
				FactionData[i] = FactionData[MAX_FACTIONS];
				FactionSpawnData[i] = FactionSpawnData[MAX_FACTIONS];
				FactionArsenalData[i] = FactionArsenalData[MAX_FACTIONS];
				FactionLockerData[i] = FactionLockerData[MAX_FACTIONS];
				continue;
			}

			// General Values
			FactionData[i][e_FACTION_EXISTS] = true;
			cache_get_value_name_int(i, "ID", FactionData[i][e_FACTION_ID]);
			cache_get_value_name(i, "Nome", FactionData[i][e_FACTION_NAME], 32);
			cache_get_value_name(i, "Abreviação", FactionData[i][e_FACTION_ABBREV], 12);
			cache_get_value_name(i, "CargoPadrão", FactionData[i][e_FACTION_DEFAULT_RANK], 32);
			cache_get_value_name_int(i, "Cor", FactionData[i][e_FACTION_COLOR]);
			cache_get_value_name_int(i, "Tipo", FactionData[i][e_FACTION_TYPE]);
			cache_get_value_name_int(i, "Cofre", FactionData[i][e_FACTION_VAULT]);
			cache_get_value_name(i, "MOTD", FactionData[i][e_FACTION_MOTD], 128);
			cache_get_value_name_bool(i, "BloquearChat", FactionData[i][e_FACTION_BLOCK_CHAT]);

			// Tier Values
			cache_get_value_name_int(i, "Tier", FactionData[i][e_FACTION_TIER]);
			cache_get_value_name_bool(i, "TierAtivo", FactionData[i][e_FACTION_TIER_ACTIVE]);
			cache_get_value_name_int(i, "Abastecimento", FactionData[i][e_FACTION_TIER_UPDATE]);
			cache_get_value_name_int(i, "Saldo", FactionData[i][e_FACTION_TIER_BALANCE]);
			cache_get_value_name_int(i, "Pontos", FactionData[i][e_FACTION_TIER_POINTS]);
			cache_get_value_name_int(i, "Casa", FactionData[i][e_FACTION_TIER_HOUSE]);

			Iter_Add(Factions, i);

			Faction_LoadSpawn(i);
			Faction_LoadArsenal(i);
			Faction_LoadLocker(i);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnLoaded, "SELECT * FROM `Facções` LIMIT %i;", MAX_FACTIONS);
	return true;
}

Faction_Create(const name[])
{
	new idx = Iter_Free(Factions);

	if (idx != ITER_NONE)
	{
		FactionData[idx] = FactionData[MAX_FACTIONS];

		inline Faction_OnCreated()
		{
			if (cache_affected_rows())
			{
				FactionData[idx][e_FACTION_ID] = cache_insert_id();
				Faction_Save(idx);
			}
		}

		FactionData[idx][e_FACTION_EXISTS] = true;
		format (FactionData[idx][e_FACTION_NAME], 32, name);
		format (FactionData[idx][e_FACTION_ABBREV], 12, "N/A");
		format (FactionData[idx][e_FACTION_DEFAULT_RANK], 12, "Membro");
		FactionData[idx][e_FACTION_COLOR] = -1;

		FactionData[idx][e_FACTION_TIER] = -1;
		FactionData[idx][e_FACTION_TIER_HOUSE] = -1;

		Iter_Add(Factions, idx);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnCreated, "INSERT IGNORE INTO `Facções` (`Nome`) VALUES ('%e');", name);
	}

	return idx;
}

Faction_Save(id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	inline Faction_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline Faction_OnSaved,
		"UPDATE IGNORE `Facções` SET \
		`Nome`='%e',\
		`Abreviação`='%e',\
		`CargoPadrão`='%e',\
		`Cor`=%i,\
		`Tipo`=%i,\
		`Cofre`=%i,\
		`MOTD`='%e',\
		`BloquearChat`=%i, \
		`Tier`=%i,\
		`TierAtivo`=%i,\
		`Abastecimento`=%i,\
		`Saldo`=%i,\
		`Pontos`=%i, \
		`Casa`=%i \
		WHERE `ID` = %i;",
		FactionData[id][e_FACTION_NAME],
		FactionData[id][e_FACTION_ABBREV],
		FactionData[id][e_FACTION_DEFAULT_RANK],
		FactionData[id][e_FACTION_COLOR],
		FactionData[id][e_FACTION_TYPE],
		FactionData[id][e_FACTION_VAULT],
		FactionData[id][e_FACTION_MOTD],
		FactionData[id][e_FACTION_BLOCK_CHAT],
		FactionData[id][e_FACTION_TIER],
		FactionData[id][e_FACTION_TIER_ACTIVE],
		FactionData[id][e_FACTION_TIER_UPDATE],
		FactionData[id][e_FACTION_TIER_BALANCE],
		FactionData[id][e_FACTION_TIER_POINTS],
		FactionData[id][e_FACTION_TIER_HOUSE],
		FactionData[id][e_FACTION_ID]
	);

	return true;
}

Faction_Destroy(id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	// Check
	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID] || CharacterData[i][e_CHARACTER_FACTION] != FactionData[id][e_FACTION_ID])
			continue;

		CharacterData[i][e_CHARACTER_FACTION] = -1;
		CharacterData[i][e_CHARACTER_FACTION_MOD] = 0;
		Character_Save(i);

		SendClientMessageEx(i, COLOR_LIGHTRED, "SERVER: Sua facção foi deletada por algum administrador.");
	}

	// Destroy Spawns
	for (new i = 0; i < MAX_FACTION_SPAWN; i++)
	{
		Faction_DestroySpawn(id, i);
	}

	// Destroy Arsenais
	for (new i = 0; i < MAX_FACTION_ARSENAL; i++)
	{
		Faction_DestroyArsenal(id, i);
	}

	// Destroy Armários
	for (new i = 0; i < MAX_FACTION_LOCKER; i++)
	{
		Faction_DestroyLocker(id, i);
	}

	// Destroy Faction
	Iter_Remove(Factions, id);
	FactionData[id] = FactionData[MAX_FACTIONS];
	return true;
}

// Spawn
Faction_LoadSpawn(id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	inline Faction_OnLoadedSpawns()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_FACTION_SPAWN; i++)
		{
			if (i >= rows)
			{
				FactionSpawnData[id][i] = FactionSpawnData[id][MAX_FACTION_SPAWN];
				continue;
			}

			// Get values
			FactionSpawnData[id][i][e_FACTION_SPAWN_EXISTS] = true;
			cache_get_value_name_int(i, "ID", FactionSpawnData[id][i][e_FACTION_SPAWN_ID]);
			cache_get_value_name(i, "Nome", FactionSpawnData[id][i][e_FACTION_SPAWN_NAME]);
			cache_get_value_name_float(i, "PosX", FactionSpawnData[id][i][e_FACTION_SPAWN_POS][0]);
			cache_get_value_name_float(i, "PosY", FactionSpawnData[id][i][e_FACTION_SPAWN_POS][1]);
			cache_get_value_name_float(i, "PosZ", FactionSpawnData[id][i][e_FACTION_SPAWN_POS][2]);
			cache_get_value_name_float(i, "Angle", FactionSpawnData[id][i][e_FACTION_SPAWN_POS][3]);
			cache_get_value_name_int(i, "World", FactionSpawnData[id][i][e_FACTION_SPAWN_WORLD]);
			cache_get_value_name_int(i, "Interior", FactionSpawnData[id][i][e_FACTION_SPAWN_INTERIOR]);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnLoadedSpawns, "SELECT * FROM `FacçãoSpawn` WHERE `Facção` = %i LIMIT %i;", FactionData[id][e_FACTION_ID], MAX_FACTION_SPAWN);
	return true;
}

Faction_CreateSpawn(playerid, id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return -1;

	new index = -1;

	for (new i = 0; i < MAX_FACTION_SPAWN; i++)
	{
		if (FactionSpawnData[id][i][e_FACTION_SPAWN_EXISTS])
			continue;

		index = i;
		break;
	}

	if (index != -1)
	{
		inline Faction_OnCreatedSpawn()
		{
			if (cache_affected_rows())
			{
				FactionSpawnData[id][index][e_FACTION_SPAWN_ID] = cache_insert_id();

				Faction_SaveSpawn(id, index);
			}
		}

		FactionSpawnData[id][index][e_FACTION_SPAWN_EXISTS] = true;
		GetPlayerPos(playerid, FactionSpawnData[id][index][e_FACTION_SPAWN_POS][0], FactionSpawnData[id][index][e_FACTION_SPAWN_POS][1], FactionSpawnData[id][index][e_FACTION_SPAWN_POS][2]);
		FactionSpawnData[id][index][e_FACTION_SPAWN_INTERIOR] = GetPlayerInterior(playerid);
		FactionSpawnData[id][index][e_FACTION_SPAWN_WORLD] = GetPlayerVirtualWorld(playerid);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnCreatedSpawn, "INSERT IGNORE INTO `FacçãoSpawn` (`Facção`) VALUES (%i);", FactionData[id][e_FACTION_ID]);
	}

	return index;
}

Faction_SaveSpawn(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_SPAWN) || !FactionSpawnData[id][index][e_FACTION_SPAWN_EXISTS])
		return false;

	inline Faction_OnSavedSpawn() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE, 
		using inline Faction_OnSavedSpawn, 
		"UPDATE IGNORE `FacçãoSpawn` SET \
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`World`=%i,\
		`Interior`=%i \
		WHERE `ID` = %i AND `Facção` = %i;",
		FactionSpawnData[id][index][e_FACTION_SPAWN_POS][0],
		FactionSpawnData[id][index][e_FACTION_SPAWN_POS][1],
		FactionSpawnData[id][index][e_FACTION_SPAWN_POS][2],
		FactionSpawnData[id][index][e_FACTION_SPAWN_WORLD],
		FactionSpawnData[id][index][e_FACTION_SPAWN_INTERIOR],
		FactionSpawnData[id][index][e_FACTION_SPAWN_ID],
		FactionData[id][e_FACTION_ID]
	);
	return true;
}

Faction_DestroySpawn(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_SPAWN) || !FactionSpawnData[id][index][e_FACTION_SPAWN_EXISTS])
		return false;

	inline Faction_OnDestroyedSpawn() {
		FactionArsenalData[id][index] = FactionArsenalData[id][MAX_FACTION_ARSENAL];
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnDestroyedSpawn, "DELETE FROM `FacçãoSpawn` WHERE `ID` = %i AND `Facção` = %i;", FactionSpawnData[id][index][e_FACTION_SPAWN_ID], FactionData[id][e_FACTION_ID]);
	return true;
}

Faction_GetRealID(sqlid)
{
	foreach (new i : Factions)
	{
		if (!FactionData[i][e_FACTION_EXISTS])
			continue;

		if (FactionData[i][e_FACTION_ID] != sqlid)
			continue;

		return i;
	}

	return -1;
}

// Arsenal
Faction_LoadArsenal(id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	inline Faction_OnLoadedArsenals()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_FACTION_ARSENAL; i++)
		{
			if (i >= rows)
			{
				FactionArsenalData[id][i] = FactionArsenalData[id][MAX_FACTION_ARSENAL];
				continue;
			}

			// Get values
			FactionArsenalData[id][i][e_FACTION_ARSENAL_EXISTS] = true;
			cache_get_value_name_int(i, "ID", FactionArsenalData[id][i][e_FACTION_ARSENAL_ID]);
			cache_get_value_name_float(i, "PosX", FactionArsenalData[id][i][e_FACTION_ARSENAL_POS][0]);
			cache_get_value_name_float(i, "PosY", FactionArsenalData[id][i][e_FACTION_ARSENAL_POS][1]);
			cache_get_value_name_float(i, "PosZ", FactionArsenalData[id][i][e_FACTION_ARSENAL_POS][2]);
			cache_get_value_name_int(i, "World", FactionArsenalData[id][i][e_FACTION_ARSENAL_WORLD]);
			cache_get_value_name_int(i, "Interior", FactionArsenalData[id][i][e_FACTION_ARSENAL_INTERIOR]);

			Faction_RefreshArsenal(id, i);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnLoadedArsenals, "SELECT * FROM `FacçãoArsenal` WHERE `Facção` = %i LIMIT %i;", FactionData[id][e_FACTION_ID], MAX_FACTION_SPAWN);
	return true;
}

Faction_CreateArsenal(playerid, id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return -1;

	new index = -1;

	for (new i = 0; i < MAX_FACTION_ARSENAL; i++)
	{
		if (FactionArsenalData[id][i][e_FACTION_ARSENAL_EXISTS])
			continue;

		index = i;
		break;
	}

	if (index != -1)
	{
		inline Faction_OnCreatedArsenal()
		{
			if (cache_affected_rows())
			{
				FactionArsenalData[id][index][e_FACTION_ARSENAL_ID] = cache_insert_id();

				Faction_SaveArsenal(id, index);
				Faction_RefreshArsenal(id, index);
			}
		}

		FactionArsenalData[id][index][e_FACTION_ARSENAL_EXISTS] = true;
		GetPlayerPos(playerid, FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][0], FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][1], FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][2]);
		FactionArsenalData[id][index][e_FACTION_ARSENAL_INTERIOR] = GetPlayerInterior(playerid);
		FactionArsenalData[id][index][e_FACTION_ARSENAL_WORLD] = GetPlayerVirtualWorld(playerid);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnCreatedArsenal, "INSERT IGNORE INTO `FacçãoArsenal` (`Facção`) VALUES (%i);", FactionData[id][e_FACTION_ID]);
	}

	return index;
}

Faction_RefreshArsenal(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_ARSENAL) || !FactionArsenalData[id][index][e_FACTION_ARSENAL_EXISTS])
		return false;

	if (IsValidDynamic3DTextLabel(FactionArsenalData[id][index][e_FACTION_ARSENAL_LABEL]))
		DestroyDynamic3DTextLabel(FactionArsenalData[id][index][e_FACTION_ARSENAL_LABEL]);

	if (IsValidDynamicPickup(FactionArsenalData[id][index][e_FACTION_ARSENAL_ICON]))
		DestroyDynamicPickup(FactionArsenalData[id][index][e_FACTION_ARSENAL_ICON]);

	// Label
	FactionArsenalData[id][index][e_FACTION_ARSENAL_LABEL] = CreateDynamic3DTextLabel(
		"/arsenal", 
		-1, 
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][0],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][1],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][2],
		15.0, 
		.worldid = FactionArsenalData[id][index][e_FACTION_ARSENAL_WORLD],
		.interiorid = FactionArsenalData[id][index][e_FACTION_ARSENAL_INTERIOR]
	);

	// Icon
	FactionArsenalData[id][index][e_FACTION_ARSENAL_ICON] = CreateDynamicPickup(
		1242, 
		23,
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][0],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][1],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][2],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_WORLD],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_INTERIOR]
	);

	return true;
}

Faction_SaveArsenal(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_ARSENAL) || !FactionArsenalData[id][index][e_FACTION_ARSENAL_EXISTS])
		return false;

	inline Faction_OnSavedArsenal() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE, 
		using inline Faction_OnSavedArsenal, 
		"UPDATE IGNORE `FacçãoArsenal` SET \
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`World`=%i,\
		`Interior`=%i \
		WHERE `ID` = %i AND `Facção` = %i;",
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][0],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][1],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_POS][2],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_WORLD],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_INTERIOR],
		FactionArsenalData[id][index][e_FACTION_ARSENAL_ID],
		FactionData[id][e_FACTION_ID]
	);
	return true;
}

Faction_DestroyArsenal(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_ARSENAL) || !FactionArsenalData[id][index][e_FACTION_ARSENAL_EXISTS])
		return false;

	if (IsValidDynamic3DTextLabel(FactionArsenalData[id][index][e_FACTION_ARSENAL_LABEL]))
		DestroyDynamic3DTextLabel(FactionArsenalData[id][index][e_FACTION_ARSENAL_LABEL]);

	if (IsValidDynamicPickup(FactionArsenalData[id][index][e_FACTION_ARSENAL_ICON]))
		DestroyDynamicPickup(FactionArsenalData[id][index][e_FACTION_ARSENAL_ICON]);

	inline Faction_OnDestroyedArsenal() {
		FactionArsenalData[id][index] = FactionArsenalData[id][MAX_FACTION_ARSENAL];
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnDestroyedArsenal, "DELETE FROM `FacçãoArsenal` WHERE `ID` = %i AND `Facção` = %i;", FactionArsenalData[id][index][e_FACTION_ARSENAL_ID], FactionData[id][e_FACTION_ID]);
	return true;
}

Faction_NearestArsenal(playerid, Float:radius=2.5)
{
	new id = Character_GetFaction(playerid);

	if (id == -1) return -1;

	for (new i = 0; i < MAX_FACTION_ARSENAL; i++)
	{
		if (!FactionArsenalData[id][i][e_FACTION_ARSENAL_EXISTS])
			continue;

		if (GetPlayerInterior(playerid) != FactionArsenalData[id][i][e_FACTION_ARSENAL_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != FactionArsenalData[id][i])
			continue;

		if (!IsPlayerInRangeOfPoint(playerid, radius, FactionArsenalData[id][i][e_FACTION_ARSENAL_POS][0], FactionArsenalData[id][i][e_FACTION_ARSENAL_POS][1], FactionArsenalData[id][i][e_FACTION_ARSENAL_POS][2]))
			continue;

		return i;
	}

	return -1;
}

// Armários
Faction_LoadLocker(id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	inline Faction_OnLoadedLockers()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_FACTION_LOCKER; i++)
		{
			if (i >= rows)
			{
				FactionLockerData[id][i] = FactionLockerData[id][MAX_FACTION_LOCKER];
				continue;
			}

			// Get values
			FactionLockerData[id][i][e_FACTION_LOCKER_EXISTS] = true;
			cache_get_value_name_int(i, "ID", FactionLockerData[id][i][e_FACTION_LOCKER_ID]);
			cache_get_value_name_float(i, "PosX", FactionLockerData[id][i][e_FACTION_LOCKER_POS][0]);
			cache_get_value_name_float(i, "PosY", FactionLockerData[id][i][e_FACTION_LOCKER_POS][1]);
			cache_get_value_name_float(i, "PosZ", FactionLockerData[id][i][e_FACTION_LOCKER_POS][2]);
			cache_get_value_name_int(i, "World", FactionLockerData[id][i][e_FACTION_LOCKER_WORLD]);
			cache_get_value_name_int(i, "Interior", FactionLockerData[id][i][e_FACTION_LOCKER_INTERIOR]);

			Faction_RefreshLocker(id, i);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnLoadedLockers, "SELECT * FROM `FacçãoArmário` WHERE `Facção` = %i LIMIT %i;", FactionData[id][e_FACTION_ID], MAX_FACTION_LOCKER);
	return true;
}

Faction_CreateLocker(playerid, id)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return -1;

	new index = -1;

	for (new i = 0; i < MAX_FACTION_LOCKER; i++)
	{
		if (FactionLockerData[id][i][e_FACTION_LOCKER_EXISTS])
			continue;

		index = i;
		break;
	}

	if (index != -1)
	{
		inline Faction_OnCreatedLocker()
		{
			if (cache_affected_rows())
			{
				FactionLockerData[id][index][e_FACTION_LOCKER_ID] = cache_insert_id();

				Faction_SaveLocker(id, index);
				Faction_RefreshLocker(id, index);
			}
		}

		FactionLockerData[id][index][e_FACTION_LOCKER_EXISTS] = true;
		GetPlayerPos(playerid, FactionLockerData[id][index][e_FACTION_LOCKER_POS][0], FactionLockerData[id][index][e_FACTION_LOCKER_POS][1], FactionLockerData[id][index][e_FACTION_LOCKER_POS][2]);
		FactionLockerData[id][index][e_FACTION_LOCKER_INTERIOR] = GetPlayerInterior(playerid);
		FactionLockerData[id][index][e_FACTION_LOCKER_WORLD] = GetPlayerVirtualWorld(playerid);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnCreatedLocker, "INSERT IGNORE INTO `FacçãoArsenal` (`Facção`) VALUES (%i);", FactionData[id][e_FACTION_ID]);
	}

	return index;
}

Faction_RefreshLocker(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_LOCKER) || !FactionLockerData[id][index][e_FACTION_LOCKER_EXISTS])
		return false;

	if (IsValidDynamic3DTextLabel(FactionLockerData[id][index][e_FACTION_LOCKER_LABEL]))
		DestroyDynamic3DTextLabel(FactionLockerData[id][index][e_FACTION_LOCKER_LABEL]);

	if (IsValidDynamicPickup(FactionLockerData[id][index][e_FACTION_LOCKER_ICON]))
		DestroyDynamicPickup(FactionLockerData[id][index][e_FACTION_LOCKER_ICON]);

	// Label
	FactionLockerData[id][index][e_FACTION_LOCKER_LABEL] = CreateDynamic3DTextLabel(
		"/armario", 
		-1, 
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][0],
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][1],
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][2],
		15.0, 
		.worldid = FactionLockerData[id][index][e_FACTION_LOCKER_WORLD],
		.interiorid = FactionLockerData[id][index][e_FACTION_LOCKER_INTERIOR]
	);

	// Icon
	FactionLockerData[id][index][e_FACTION_LOCKER_ICON] = CreateDynamicPickup(
		1275, 
		23,
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][0],
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][1],
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][2],
		FactionLockerData[id][index][e_FACTION_LOCKER_WORLD],
		FactionLockerData[id][index][e_FACTION_LOCKER_INTERIOR]
	);

	return true;
}

Faction_SaveLocker(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_LOCKER) || !FactionLockerData[id][index][e_FACTION_LOCKER_EXISTS])
		return false;

	inline Faction_OnSavedArsenal() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE, 
		using inline Faction_OnSavedLocker, 
		"UPDATE IGNORE `FacçãoArmário` SET \
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`World`=%i,\
		`Interior`=%i \
		WHERE `ID` = %i AND `Facção` = %i;",
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][0],
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][1],
		FactionLockerData[id][index][e_FACTION_LOCKER_POS][2],
		FactionLockerData[id][index][e_FACTION_LOCKER_WORLD],
		FactionLockerData[id][index][e_FACTION_LOCKER_INTERIOR],
		FactionLockerData[id][index][e_FACTION_LOCKER_ID],
		FactionData[id][e_FACTION_ID]
	);
	return true;
}

Faction_DestroyLocker(id, index)
{
	if (!(0 <= id < MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
		return false;

	if (!(0 <= index < MAX_FACTION_LOCKER) || !FactionLockerData[id][index][e_FACTION_LOCKER_EXISTS])
		return false;

	if (IsValidDynamic3DTextLabel(FactionLockerData[id][index][e_FACTION_LOCKER_LABEL]))
		DestroyDynamic3DTextLabel(FactionLockerData[id][index][e_FACTION_LOCKER_LABEL]);

	if (IsValidDynamicPickup(FactionLockerData[id][index][e_FACTION_LOCKER_ICON]))
		DestroyDynamicPickup(FactionLockerData[id][index][e_FACTION_LOCKER_ICON]);

	inline Faction_OnDestroyedArsenal() {
		FactionLockerData[id][index] = FactionLockerData[id][MAX_FACTION_LOCKER];
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Faction_OnDestroyedArsenal, "DELETE FROM `FacçãoArmário` WHERE `ID` = %i AND `Facção` = %i;", FactionLockerData[id][index][e_FACTION_LOCKER_ID], FactionData[id][e_FACTION_ID]);
	return true;
}

Faction_NearestLocker(playerid, Float:radius=2.5)
{
	new id = Character_GetFaction(playerid);

	if (id == -1) return -1;

	for (new i = 0; i < MAX_FACTION_LOCKER; i++)
	{
		if (!FactionLockerData[id][i][e_FACTION_LOCKER_EXISTS])
			continue;

		if (GetPlayerInterior(playerid) != FactionLockerData[id][i][e_FACTION_ARSENAL_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != FactionLockerData[id][i])
			continue;

		if (!IsPlayerInRangeOfPoint(playerid, radius, FactionLockerData[id][i][e_FACTION_LOCKER_POS][0], FactionLockerData[id][i][e_FACTION_LOCKER_POS][1], FactionLockerData[id][i][e_FACTION_LOCKER_POS][2]))
			continue;

		return i;
	}

	return -1;
}

// Sscanf Key
SSCANF:factiontype(const string[])
{
	if (IsNumeric(string))
	{
		new ret = strval(string);
		
		if (0 <= ret < MAX_FACTION_TYPE)
		{
			return ret;
		}
	}
	else
	{
		for (new i = 0; i < MAX_FACTION_TYPE; i++)
		{
			if (strfind(g_arrayFactionTypes[i], string, true) != -1)
			{
				return i;
			}
		}
	}
	return -1;
}

// Comandos
CMD:listafaccao(playerid)
{
	new count = 0;

	foreach (new i : Factions)
	{
		if (!FactionData[i][e_FACTION_EXISTS])
			continue;

		SendClientMessageEx(playerid, -1, "[ID: %i] {%06x}%s", i, FactionData[i][e_FACTION_COLOR] >>> 8, FactionData[i][e_FACTION_NAME]);
		count += 1;
	}

	if (!count)
		SendClientMessage(playerid, COLOR_LIGHTRED, "Nenhuma facção criada no servidor.");

	return true;
}

CMD:criarfaccao(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_FACTION))
		return true;

	if (IsNull(params))
		return SendUsageMessage(playerid, "/criarfaccao [nome da facção]");

	if (strlen(params) > 32)
		return SendErrorMessage(playerid, "Você especificou um nome muito extenso para a facção.");

	static 
		index;

	index = Faction_Create(params);

	if (index == ITER_NONE)
		return SendErrorMessage(playerid, "Não foi possível criar a facção.");

	Log_Create("[Faction Team] Facções criadas", "%s criou a facção \"%s\"", AccountData[playerid][e_ACCOUNT_NAME], params);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s criou a facção %s (ID: %i).", AccountData[playerid][e_ACCOUNT_NAME], params, index);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você criou a facção %s (ID: %i).", params, index);
	return true;
}

CMD:editarfaccao(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarfaccao [Id] [Opção]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opções]: nome, abreviacao, tipo, cor, cargopadrao, tier");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opções]: tierpontos, tieratualizacao, cofre");
		return 1;
	}

	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de facção inválido.");

	if (!strcmp(type, "nome", true))
	{
		static name[32];

		if (sscanf(string, "s[32]", name))
			return SendUsageMessage(playerid, "/editarfaccao id nome [NovoNome]");

		if (!(1 <= strlen(name) <= 32))
			return SendErrorMessage(playerid, "O novo nome pode conter até 32 caracteres.");

		Log_Create("[Faction Team] Facções editadas", "%s ajustou o nome da facção \"%s\" para \"%s\" [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_NAME], name, FactionData[id][e_FACTION_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o nome da facção %i para \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], id, name);
	
		format (FactionData[id][e_FACTION_NAME], 32, name);
		Faction_Save(id);
	}
	else if (!strcmp(type, "abreviacao", true) || !strcmp(type, "abreviaçao", true) || !strcmp(type, "abreviacão", true) || !strcmp(type, "abreviação", true))
	{
		static abbrev[12];

		if (sscanf(string, "s[12]", abbrev))
			return SendUsageMessage(playerid, "/editarfaccao id abreviacao [NovaAbreviacao]");

		if (!(1 <= strlen(abbrev) <= 12))
			return SendErrorMessage(playerid, "A nova abreviação pode conter até 12 caracteres.");

		Log_Create("[Faction Team] Facções editadas", "%s ajustou a abreviação da facção \"%s\" para \"%s\" [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_ABBREV], abbrev, FactionData[id][e_FACTION_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou a abreviação da facção %i para \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], id, abbrev);
	
		format (FactionData[id][e_FACTION_ABBREV], 12, abbrev);
		Faction_Save(id);
	}
	else if (!strcmp(type, "tipo", true))
	{
		static tipo;

		if (sscanf(string, "k<factiontype>", tipo))
		{
			SendClientMessageEx(playerid, COLOR_BEGE, "USE: /editarfaccao id tipo [NovoTipo] (Atual: %s)", g_arrayFactionTypes[FactionData[id][e_FACTION_TYPE]]);

			new idx = 0, str[128] = "[Tipos]: ";

			for (new i = 0; i < MAX_FACTION_TYPE; i++)
			{
				strcat (str, va_return("%s%i. %s", (!idx ? ("") : (", ")), i, g_arrayFactionTypes[i]));

				idx += 1;

				if (!(idx % 5) || (i == (MAX_FACTION_TYPE - 1)))
				{
					SendClientMessage(playerid, COLOR_BEGE, str);

					str = "[Tipos]: ";
					idx = 0;
				}
			}

			return true;
		}

		Log_Create("[Faction Team] Facções editadas", "%s ajustou o tipo da facção \"%s\" para %s [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_ABBREV], g_arrayFactionTypes[tipo], FactionData[id][e_FACTION_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o tipo da facção %i para %s.", AccountData[playerid][e_ACCOUNT_NAME], id, g_arrayFactionTypes[tipo]);
	
		FactionData[id][e_FACTION_TYPE] = tipo;
		Faction_Save(id);
	}
	else if (!strcmp(type, "cor", true))
	{
		static cor;

		if (strlen(string) != 6)
			return SendErrorMessage(playerid, "A nova cor da facção precisa estar no formato HEX (RRGGBB).");

		strcat(string, "FF");

		if (sscanf(string, "x", cor))
			return SendUsageMessage(playerid, "/editarfaccao id cor [NovaCorHex] - (padrões: 8D8DFF, 2828FF, FFFFFF)");

		Log_Create("[Faction Team] Facções editadas", "%s ajustou a cor da facção \"%s\" para \"%06x\" [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_ABBREV], cor >>> 8, FactionData[id][e_FACTION_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o tipo da facção %i para \"%06x\".", AccountData[playerid][e_ACCOUNT_NAME], id, cor >>> 8);
		
		FactionData[id][e_FACTION_COLOR] = cor;
		Faction_Save(id);

		foreach (new i : Player)
		{
			if (!CharacterData[i][e_CHARACTER_ID])
				continue;

			if (CharacterData[i][e_CHARACTER_FACTION] != FactionData[id][e_FACTION_ID])
				continue;

			Character_UpdateColor(i);
		}

	}
	else if (!strcmp(type, "cargopadrao", true) || !strcmp(type, "cargopadrão"))
	{
		static rank[32];

		if (sscanf(string, "s[32]", rank))
			return SendUsageMessage(playerid, "/editarfaccao id cargopadrao [NovoCargoPadrao]");

		if (!(1 <= strlen(rank) <= 32))
			return SendErrorMessage(playerid, "O novo cargo padrao pode conter até 32 caracteres.");

		Log_Create("[Faction Team] Facções editadas", "%s ajustou o cargo padrão da facção \"%s\" para \"%s\" [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_NAME], rank, FactionData[id][e_FACTION_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o cargo padrão da facção %i para \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], id, rank);
	
		format (FactionData[id][e_FACTION_DEFAULT_RANK], 32, rank);
		Faction_Save(id);
	}
	else if (!strcmp(type, "cofre", true))
	{
		static value;

		if (sscanf(string, "i", value))
			return SendUsageMessage(playerid, "/editarfaccao id cofre [NovoValor]");

		if (value < 0)
			return SendErrorMessage(playerid, "Você não pode especificar um valor negativo.");

		Log_Create("[Faction Team] Facções editadas", "%s ajustou o cofre da facção \"%s\" para %s [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_NAME], FormatMoney(value), FactionData[id][e_FACTION_ID]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o cofre da facção %i para %s.", AccountData[playerid][e_ACCOUNT_NAME], id, FormatMoney(value));
	
		FactionData[id][e_FACTION_VAULT] = value;
		Faction_Save(id);
	}
	else SendErrorMessage(playerid, "Você especificou uma opção inválida.");

	return true;
}

CMD:destruirfaccao(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_FACTION))
		return true;

	static 
		id;

	if (sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/destruirfaccao [FacçãoId]");

	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][e_FACTION_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de facção inválido.");

	Log_Create("[Faction Team] Facções deletadas", "%s deletou a facção \"%s\" [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_NAME], FactionData[id][e_FACTION_ID]);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s deletou a facção \"%s\" (ID: %i).", AccountData[playerid][e_ACCOUNT_NAME], FactionData[id][e_FACTION_NAME], FactionData[id][e_FACTION_ID]);
	
	Faction_Destroy(id);
	return true;
}

CMD:setlider(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_FACTION))
		return true;

	static 
		id, faction;

	if (sscanf(params, "ui", id, faction))
		return SendUsageMessage(playerid, "/setlider [ID/Nome/ParteDoNome] [FacçãoId]");

	if ((faction < 0 || faction >= MAX_FACTIONS) || !FactionData[faction][e_FACTION_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de facção inválido.");

	Log_Create("[Faction Team] Líderes setados", "%s deu a liderança da facção \"%s\" para %s (%i) [%i]", AccountData[playerid][e_ACCOUNT_NAME], FactionData[faction][e_FACTION_NAME], Character_GetName(id, false), CharacterData[id][e_CHARACTER_ID], FactionData[faction][e_FACTION_ID]);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s deu a liderança da facção \"%s\" para %s.", AccountData[playerid][e_ACCOUNT_NAME], FactionData[faction][e_FACTION_NAME], Character_GetName(id, false));
	SendClientMessageEx(playerid, COLOR_YELLOW, "Você deu a liderança da facção %s para %s.", FactionData[faction][e_FACTION_NAME], Character_GetName(id, false));
	SendClientMessageEx(id, COLOR_YELLOW, "Administrador %s lhe deu a liderança da facção %s.", AccountData[playerid][e_ACCOUNT_NAME], FactionData[faction][e_FACTION_NAME]);
	
	CharacterData[id][e_CHARACTER_FACTION] = FactionData[faction][e_FACTION_ID];
	CharacterData[id][e_CHARACTER_FACTION_MOD] = 6;
	format (CharacterData[id][e_CHARACTER_FACTION_RANK], 32, "Líder");
	Character_Save(id);
	return true;
}