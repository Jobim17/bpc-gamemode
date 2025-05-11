/*
	ooooo   ooooo
	`888'   `888'
	 888     888   .ooooo.  oooo  oooo   .oooo.o  .ooooo.
	 888ooooo888  d88' `88b `888  `888  d88(  "8 d88' `88b
	 888     888  888   888  888   888  `"Y88b.  888ooo888
	 888     888  888   888  888   888  o.  )88b 888    .o
	o888o   o888o `Y8bod8P'  `V88V"V8P' 8""888P' `Y8bod8Ps'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Functions
House_Load()
{
	inline House_OnLoaded()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_HOUSES; i++)
		{
			// Reset values
			if (i >= rows)
			{
				HouseData[i] = HouseData[MAX_HOUSES];
				continue;
			}

			// Get values
			cache_get_value_name_int(i, "ID", HouseData[i][e_HOUSE_ID]);
			cache_get_value_name_int(i, "Dono", HouseData[i][e_HOUSE_OWNER]);
			cache_get_value_name_int(i, "Preço", HouseData[i][e_HOUSE_PRICE]);
			cache_get_value_name_int(i, "PreçoAluguel", HouseData[i][e_HOUSE_RENT_PRICE]);
			cache_get_value_name(i, "Rádio", HouseData[i][e_HOUSE_RADIO]);
			cache_get_value_name_float(i, "PosX", HouseData[i][e_HOUSE_POS][0]);
			cache_get_value_name_float(i, "PosY", HouseData[i][e_HOUSE_POS][1]);
			cache_get_value_name_float(i, "PosZ", HouseData[i][e_HOUSE_POS][2]);
			cache_get_value_name_int(i, "World", HouseData[i][e_HOUSE_WORLD]);
			cache_get_value_name_int(i, "Interior", HouseData[i][e_HOUSE_INTERIOR]);
			cache_get_value_name_float(i, "InsidePosX", HouseData[i][e_HOUSE_INSIDE_POS][0]);
			cache_get_value_name_float(i, "InsidePosY", HouseData[i][e_HOUSE_INSIDE_POS][1]);
			cache_get_value_name_float(i, "InsidePosZ", HouseData[i][e_HOUSE_INSIDE_POS][2]);
			cache_get_value_name_float(i, "InsideAngle", HouseData[i][e_HOUSE_INSIDE_POS][3]);
			cache_get_value_name_int(i, "InsideInterior", HouseData[i][e_HOUSE_INSIDE_INTERIOR]);
			cache_get_value_name_float(i, "GaragePosX", HouseData[i][e_HOUSE_GARAGE_POS][0]);
			cache_get_value_name_float(i, "GaragePosY", HouseData[i][e_HOUSE_GARAGE_POS][1]);
			cache_get_value_name_float(i, "GaragePosZ", HouseData[i][e_HOUSE_GARAGE_POS][2]);
			cache_get_value_name_int(i, "Dinheiro", HouseData[i][e_HOUSE_MONEY]);
			cache_get_value_name_bool(i, "Trancada", HouseData[i][e_HOUSE_LOCKED]);
	
			// Update
			HouseData[i][e_HOUSE_EXISTS] = true;
			HouseData[i][e_HOUSE_INSIDE_WORLD] = (WORLD_HOUSE + i);
			Iter_Add(Houses, i);
			House_Refresh(i);
		}

		if (rows)
			printf("[Houses] Loaded %i houses.", rows);
		else
			print("[Houses] No house to load.");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline House_OnLoaded, "SELECT * FROM `Casas` LIMIT %i;", MAX_HOUSES);
	return true;
}

House_Create(playerid, price)
{
	new id = Iter_Free(Houses);

	if (id != ITER_NONE)
	{
		inline House_OnCreated()
		{
			if (cache_affected_rows())
			{
				HouseData[id][e_HOUSE_ID] = cache_insert_id();

				House_Save(id);
				House_Refresh(id);
			}
		}

		HouseData[id] = HouseData[MAX_HOUSES];

		HouseData[id][e_HOUSE_EXISTS] = true;
		HouseData[id][e_HOUSE_INSIDE_POS][0] = 2269.8772; 
		HouseData[id][e_HOUSE_INSIDE_POS][1] = -1210.3240;
		HouseData[id][e_HOUSE_INSIDE_POS][2] = 1047.5625;
		HouseData[id][e_HOUSE_INSIDE_POS][3] = 90.0;
		HouseData[id][e_HOUSE_INSIDE_WORLD] = WORLD_HOUSE + id;
		HouseData[id][e_HOUSE_INSIDE_INTERIOR] = 10;
		HouseData[id][e_HOUSE_PRICE] = price;

		GetPlayerPos(playerid, HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1], HouseData[id][e_HOUSE_POS][2]);
		HouseData[id][e_HOUSE_WORLD] = GetPlayerVirtualWorld(playerid);
		HouseData[id][e_HOUSE_INTERIOR] = GetPlayerInterior(playerid);

		Iter_Add(Houses, id);
		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline House_OnCreated, "INSERT IGNORE INTO `Casas` (`Preço`) VALUES (%i);", price);
	}

	return id;
}

House_Refresh(id)
{
	if (!(0 <= id < MAX_HOUSES) || !HouseData[id][e_HOUSE_EXISTS])
		return false;

	if (IsValidDynamicPickup(HouseData[id][e_HOUSE_ICON]))
	{
		DestroyDynamicPickup(HouseData[id][e_HOUSE_ICON]);
		HouseData[id][e_HOUSE_ICON] = INVALID_STREAMER_ID;
	}

	if (IsValidDynamicArea(HouseData[id][e_HOUSE_AREA]))
		DestroyDynamicArea(HouseData[id][e_HOUSE_AREA]);

	// Area
	HouseData[id][e_HOUSE_AREA] = CreateDynamicSphere(
		HouseData[id][e_HOUSE_POS][0], 
		HouseData[id][e_HOUSE_POS][1], 
		HouseData[id][e_HOUSE_POS][2], 
		2.5, 
		.worldid = HouseData[id][e_HOUSE_WORLD], 
		.interiorid = HouseData[id][e_HOUSE_INTERIOR]
	);

	// Icon
	if (!HouseData[id][e_HOUSE_OWNER])
	{
		HouseData[id][e_HOUSE_ICON] = CreateDynamicPickup(
			19471, 
			23, 
			HouseData[id][e_HOUSE_POS][0], 
			HouseData[id][e_HOUSE_POS][1], 
			HouseData[id][e_HOUSE_POS][2] - 0.4,
			HouseData[id][e_HOUSE_WORLD], 
			HouseData[id][e_HOUSE_INTERIOR]
		);
	}

	return true;
}

House_Save(id)
{
	if (!(0 <= id < MAX_HOUSES) || !HouseData[id][e_HOUSE_EXISTS])
		return false;

	inline House_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline House_OnSaved,
		"UPDATE IGNORE `Casas` SET \
		`Dono`=%i,\
		`Preço`=%i,\
		`PreçoAluguel`=%i,\
		`Rádio`='%e',\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`World`=%i,\
		`Interior`=%i,\
		`InsidePosX`='%f',\
		`InsidePosY`='%f',\
		`InsidePosZ`='%f',\
		`InsideAngle`='%f',\
		`InsideInterior`=%i,\
		`GaragePosX`='%f',\
		`GaragePosY`='%f',\
		`GaragePosZ`='%f',\
		`Dinheiro`=%i,\
		`Trancada`=%i \
		WHERE `ID` = %i LIMIT 1;",
		HouseData[id][e_HOUSE_OWNER],
		HouseData[id][e_HOUSE_PRICE],
		HouseData[id][e_HOUSE_RENT_PRICE],
		HouseData[id][e_HOUSE_RADIO],
		HouseData[id][e_HOUSE_POS][0],
		HouseData[id][e_HOUSE_POS][1],
		HouseData[id][e_HOUSE_POS][2],
		HouseData[id][e_HOUSE_WORLD],
		HouseData[id][e_HOUSE_INTERIOR],
		HouseData[id][e_HOUSE_INSIDE_POS][0],
		HouseData[id][e_HOUSE_INSIDE_POS][1],
		HouseData[id][e_HOUSE_INSIDE_POS][2],
		HouseData[id][e_HOUSE_INSIDE_POS][3],
		HouseData[id][e_HOUSE_INSIDE_INTERIOR],
		HouseData[id][e_HOUSE_GARAGE_POS][0],
		HouseData[id][e_HOUSE_GARAGE_POS][1],
		HouseData[id][e_HOUSE_GARAGE_POS][2],
		HouseData[id][e_HOUSE_MONEY],
		HouseData[id][e_HOUSE_LOCKED],
		HouseData[id][e_HOUSE_ID]
	);

	return true;
}

House_Nearest(playerid, Float:radius=2.5)
{
	new idx = -1;

	foreach (new i : Houses)
	{
		if (GetPlayerInterior(playerid) != HouseData[i][e_HOUSE_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != HouseData[i][e_HOUSE_WORLD])
			continue;

		if (GetPlayerDistanceFromPoint(playerid, HouseData[i][e_HOUSE_POS][0], HouseData[i][e_HOUSE_POS][1], HouseData[i][e_HOUSE_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, HouseData[i][e_HOUSE_POS][0], HouseData[i][e_HOUSE_POS][1], HouseData[i][e_HOUSE_POS][2]);
		}
	}

	return idx;
}

House_Inside(playerid)
{
	foreach (new i : Houses)
	{
		if (HouseData[i][e_HOUSE_EXISTS] && GetPlayerVirtualWorld(playerid) == HouseData[i][e_HOUSE_INSIDE_WORLD] && GetPlayerInterior(playerid) == HouseData[i][e_HOUSE_INSIDE_INTERIOR])
		{
			return i;
		}
	}

	return -1;
}

House_Destroy(id)
{
	if (!(0 <= id < MAX_HOUSES) || !HouseData[id][e_HOUSE_EXISTS])
		return false;

	if (IsValidDynamicPickup(HouseData[id][e_HOUSE_ICON]))
		DestroyDynamicPickup(HouseData[id][e_HOUSE_ICON]);

	if (IsValidDynamicArea(HouseData[id][e_HOUSE_AREA]))
		DestroyDynamicArea(HouseData[id][e_HOUSE_AREA]);

	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
			continue;

		if (House_Inside(i) != id)
			continue;

		Character_SetPos(
			i, 
			HouseData[id][e_HOUSE_POS][0],
			HouseData[id][e_HOUSE_POS][1],
			HouseData[id][e_HOUSE_POS][2],
			-1.0,
			HouseData[id][e_HOUSE_WORLD],
			HouseData[id][e_HOUSE_INTERIOR]
		);

		SendClientMessage(i, -1, "SERVER: A casa que você estava foi destruida.");
	}

	Iter_Remove(Houses, id);
	HouseData[id] = HouseData[MAX_HOUSES];

	new query[64];
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Casas` WHERE `ID` = %i;", HouseData[id][e_HOUSE_ID]);
	mysql_tquery (MYSQL_CUR_HANDLE, query);
	return true;
}

House_GetCount(ownerid)
{
	new count = 0;

	foreach (new i : Houses)
	{
		if (!HouseData[i][e_HOUSE_EXISTS])
			continue;

		if (HouseData[i][e_HOUSE_OWNER] != ownerid)
			continue;

		count += 1;
	}

	return count;
}

House_IsOwner(playerid, id)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (!(0 <= id < MAX_HOUSES) || !HouseData[id][e_HOUSE_EXISTS])
		return false;

	// Property Team em trabalho
	if (Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY, .sendMessage = false) && AccountData[playerid][e_ACCOUNT_ADMIN_DUTY])
		return true;

	// General
	if (HouseData[id][e_HOUSE_OWNER] == CharacterData[playerid][e_CHARACTER_ID])
		return true;

	return false;
}

House_GetAddress(id)
{
	new addr[128] = "Nenhum";

	if ((0 <= id < MAX_HOUSES) && HouseData[id][e_HOUSE_EXISTS])
	{
		format (
			addr, 
			sizeof addr,
			"%s %i, %s %i", ReturnStreet(HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1]), HouseData[id][e_HOUSE_ID], ReturnAreaName(HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1]), ReturnAreaCode(HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1])
		);
	}

	return addr;
}

House_GetRealID(sqlid)
{
	foreach (new i : Houses)
	{
		if (!HouseData[i][e_HOUSE_EXISTS] || HouseData[i][e_HOUSE_ID] != sqlid)
			continue;

		return i;
	}

	return -1;
}

// Comandos
CMD:criarcasa(playerid, params[])
{
    if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
	    return false;

	static
	    price,
	    id;

	if (sscanf(params, "i", price))
		return SendUsageMessage(playerid, "/criarcasa [preço]");

	if (price < 1)
		return SendErrorMessage(playerid, "O valor minímo é $1.");

	id = House_Create(playerid, price);

	if (id == ITER_NONE)
		return SendErrorMessage(playerid, "O servidor chegou ao limite máximo de casas.");

	SendClientMessageEx(playerid, COLOR_GREEN, "Você criou com sucesso a casa ID: %d.", id);
	return 1;
}

CMD:destruircasa(playerid, params[])
{
    if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
	    return false;

	static
	    id = 0;

	if (sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/destruircasa [id da casa]");

	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][e_HOUSE_EXISTS])
		return SendErrorMessage(playerid, "Você especificou um ID de casa inválido.");

	House_Destroy(id);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você destruiu com sucesso a casa ID: %d.", id);
	return 1;
}

CMD:editarcasa(playerid, params[])
{
 	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
	    return false;

	static
	    id,
	    type[24],
	    string[128];

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
 	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarcasa [id] [opção]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opções]: localizacao, interior, preco");
	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return 1;
	}

	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][e_HOUSE_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de casa inválido.");

	if (!strcmp(type, "localizacao", true))
	{
		GetPlayerPos(playerid, HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1], HouseData[id][e_HOUSE_POS][2]);
		HouseData[id][e_HOUSE_WORLD] = GetPlayerVirtualWorld(playerid);
		HouseData[id][e_HOUSE_INTERIOR] = GetPlayerInterior(playerid);

		House_Refresh(id);
		House_Save(id);

      	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou a localização da casa: %d.", AccountData[playerid][e_ACCOUNT_NAME], id);
	}
	else if (!strcmp(type, "interior", true))
	{
		GetPlayerPos(playerid, HouseData[id][e_HOUSE_INSIDE_POS][0], HouseData[id][e_HOUSE_INSIDE_POS][1], HouseData[id][e_HOUSE_INSIDE_POS][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][e_HOUSE_INSIDE_POS][3]);
		HouseData[id][e_HOUSE_INSIDE_INTERIOR] = GetPlayerInterior(playerid);

        foreach (new i : Player)
		{
			if (Entrance_Inside(i) != id)
				continue;

			Character_SetPos(
				i, 
				HouseData[id][e_HOUSE_INSIDE_POS][0],
				HouseData[id][e_HOUSE_INSIDE_POS][1],
				HouseData[id][e_HOUSE_INSIDE_POS][2],
				HouseData[id][e_HOUSE_INSIDE_POS][3],
				HouseData[id][e_HOUSE_INSIDE_WORLD],
				HouseData[id][e_HOUSE_INSIDE_INTERIOR]
			);
		}
		
		House_Save(id);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o interior da casa: %d.", AccountData[playerid][e_ACCOUNT_NAME], id);
	}
	else if (!strcmp(type, "preco", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	        return SendUsageMessage(playerid, "/editarcasa [id] [preço] [novo preço]");

	    if (price < 1)
	    	return SendErrorMessage(playerid, "O valor minímo é $1.");

	    HouseData[id][e_HOUSE_PRICE] = price;

	    House_Refresh(id);
	    House_Save(id);
       
       	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o preço da casa: %d para %s.", AccountData[playerid][e_ACCOUNT_NAME], id, FormatMoney(price));
	}

	return true;
}