/*
	ooooo                   .o8                           .             o8o
	`888'                  "888                         .o8             `"'
	 888  ooo. .oo.    .oooo888  oooo  oooo   .oooo.o .o888oo oooo d8b oooo   .oooo.    .oooo.o
	 888  `888P"Y88b  d88' `888  `888  `888  d88(  "8   888   `888""8P `888  `P  )88b  d88(  "8
	 888   888   888  888   888   888   888  `"Y88b.    888    888      888   .oP"888  `"Y88b.
	 888   888   888  888   888   888   888  o.  )88b   888 .  888      888  d8(  888  o.  )88b
	o888o o888o o888o `Y8bod88P"  `V88V"V8P' 8""888P'   "888" d888b    o888o `Y888""8o 8""888P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Callbacks
hook OnGameModeInit()
{
	Industry_Load();
	Industry_LoadStorage();
	return true;
}

hook OnServerUpdateHour()
{
	foreach (new i : Industries)
	{
		if (IndustryData[i][e_INDUSTRY_EXISTS])
		{
			Industry_Process(i);
		}
	}
}

hook OnCargoShipDocked()
{
	new id;

	foreach (new i : IndustryStorages)
	{
		if ((id = Industry_GetId(IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN])) == -1)
			continue;

		if (IndustryData[id][e_INDUSTRY_TYPE] != 0) // Não é navio
			continue;

		IndustryStorageData[i][e_INDUSTRY_STORAGE_INTERIOR] = 0;
		IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] = 0;

		IndustryStorage_Refresh(i);
	}
}

hook OnCargoShipUndocked()
{
	new id;

	foreach (new i : IndustryStorages)
	{
		if ((id = Industry_GetId(IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN])) == -1)
			continue;

		if (IndustryData[id][e_INDUSTRY_TYPE] != 0) // Não é navio
			continue;

		IndustryStorageData[i][e_INDUSTRY_STORAGE_INTERIOR] = 1;
		IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] = 0;

		IndustryStorage_Refresh(i);
	}
}

// Functions
Industry_Load()
{
	inline Industry_OnLoaded()
	{
		new rows;
		rows = cache_num_rows();

		for (new i = 0; i < MAX_INDUSTRY; i++)
		{
			// Reset
			if (i >= rows) {
				IndustryData[i] = IndustryData[MAX_INDUSTRY];
				continue;
			}

			// Get values
			IndustryData[i][e_INDUSTRY_EXISTS] = true;

			cache_get_value_name_int(i, "ID", IndustryData[i][e_INDUSTRY_ID]);
			cache_get_value_name(i, "Nome", IndustryData[i][e_INDUSTRY_NAME]);
			cache_get_value_name_int(i, "Tipo", IndustryData[i][e_INDUSTRY_TYPE]);
			cache_get_value_name_bool(i, "Fechado", IndustryData[i][e_INDUSTRY_LOCKED]);

			Iter_Add(Industries, i);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Industry_OnLoaded, "SELECT * FROM `Indústrias` ORDER BY `Tipo` ASC LIMIT %i;", MAX_INDUSTRY);
	return true;
}

Industry_GetId(id)
{
	foreach (new i : Industries)
	{
		if (!IndustryData[i][e_INDUSTRY_EXISTS]) continue;
		if (IndustryData[i][e_INDUSTRY_ID] != id) continue;

		return i;
	}

	return -1;
}

Industry_LoadStorage()
{
	inline IndustryStorage_OnLoaded()
	{
		new rows;
		rows = cache_num_rows();

		for (new i = 0; i < MAX_INDUSTRY_STORAGE; i++)
		{
			// Reset
			if (i >= rows) {
				IndustryStorageData[i] = IndustryStorageData[MAX_INDUSTRY_STORAGE];
				continue;
			}

			// Get values
			IndustryStorageData[i][e_INDUSTRY_STORAGE_EXISTS] = true;

			cache_get_value_name_int(i, "ID", IndustryStorageData[i][e_INDUSTRY_STORAGE_ID]);
			cache_get_value_name_int(i, "Indústria", IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN]);
			cache_get_value_name_float(i, "PosX", IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][0]);
			cache_get_value_name_float(i, "PosY", IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][1]);
			cache_get_value_name_float(i, "PosZ", IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][2]);
			cache_get_value_name_int(i, "Interior", IndustryStorageData[i][e_INDUSTRY_STORAGE_INTERIOR]);
			cache_get_value_name_int(i, "World", IndustryStorageData[i][e_INDUSTRY_STORAGE_WORLD]);
			cache_get_value_name_int(i, "Estoque", IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK]);
			cache_get_value_name_int(i, "TamanhoEstoque", IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE]);
			cache_get_value_name_int(i, "Consumo", IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION]);
			cache_get_value_name_int(i, "Produto", IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY]);
			cache_get_value_name_int(i, "Preço", IndustryStorageData[i][e_INDUSTRY_STORAGE_PRICE]);
			cache_get_value_name_int(i, "Venda", IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING]);

			Iter_Add(IndustryStorages, i);
			IndustryStorage_Refresh(i);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline IndustryStorage_OnLoaded, "SELECT * FROM `IndústriaEstoque` LIMIT %i;", MAX_INDUSTRY_STORAGE);
	return true;
}

Industry_Process(id)
{
	if (!(0 <= id < MAX_INDUSTRY) || !IndustryData[id][e_INDUSTRY_EXISTS])
		return false;

	if (IndustryData[id][e_INDUSTRY_TYPE] == 0) // Navio
		return false;

	foreach (new i : IndustryStorages)
	{
		if (!IndustryStorageData[i][e_INDUSTRY_STORAGE_EXISTS] || IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN] != IndustryData[id][e_INDUSTRY_ID])
			continue;

		// Primária
		if (IndustryData[id][e_INDUSTRY_TYPE] == 1 && IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING])
		{
			IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] += IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION];

			if (IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] > IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE])
			{
				IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] = IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE];
			}
		}

		// Secundária
		else if (IndustryData[id][e_INDUSTRY_TYPE] == 2)
		{
			new bool:passed = true;

			foreach (new x : IndustryStorages)
			{
				if (!IndustryStorageData[x][e_INDUSTRY_STORAGE_EXISTS] || IndustryStorageData[x][e_INDUSTRY_STORAGE_PATTERN] != IndustryData[id][e_INDUSTRY_ID])
					continue;

				if (IndustryStorageData[x][e_INDUSTRY_STORAGE_SELLING])
					continue;

				if (IndustryStorageData[x][e_INDUSTRY_STORAGE_STOCK] >= IndustryStorageData[x][e_INDUSTRY_STORAGE_CONSUMPTION])
					continue;

				passed = false;
				break;
			}

			if (passed)
			{
				if (IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING])
				{
					IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] += IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION];
					
					if (IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] > IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE])
					{
						IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] = IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE];
					}
				}
				else
				{
					IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] -= IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION];
				}
			}
		}

		// Terciária
		else if (IndustryData[id][e_INDUSTRY_TYPE] == 3 && !IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING])
		{
			IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] -= IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION];
			
			if (IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] < 0)
			{
				IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK] = 0;
			}
		}

		IndustryStorage_Save(i);
		IndustryStorage_Refresh(i);
	}

	return true;
}

IndustryStorage_Refresh(id)
{
	if (!(0 <= id < MAX_INDUSTRY_STORAGE) || !IndustryStorageData[id][e_INDUSTRY_STORAGE_EXISTS])
		return false;

	if (IsValidDynamicPickup(IndustryStorageData[id][e_INDUSTRY_STORAGE_ICON]))
		DestroyDynamicPickup(IndustryStorageData[id][e_INDUSTRY_STORAGE_ICON]);

	if (IsValidDynamic3DTextLabel(IndustryStorageData[id][e_INDUSTRY_STORAGE_LABEL]))
		DestroyDynamic3DTextLabel(IndustryStorageData[id][e_INDUSTRY_STORAGE_LABEL]);

	IndustryStorageData[id][e_INDUSTRY_STORAGE_ICON] = CreateDynamicPickup(
		1318, 
		23, 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][0], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][1], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][2], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_WORLD], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_INTERIOR]
	);

	new line[128];
	format (line, sizeof line, "{DFDFDF}[{E5FF00}%s{DFDFDF}]\nEstoque: %i / %i\nPreço: %s / unidade", Commodity_GetLowerName(IndustryStorageData[id][e_INDUSTRY_STORAGE_COMMODITY]), IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK], IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK_SIZE], FormatMoney(IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));

	IndustryStorageData[id][e_INDUSTRY_STORAGE_LABEL] = CreateDynamic3DTextLabel(
		line, 
		-1, 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][0], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][1], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][2], 
		15.0, 
		INVALID_PLAYER_ID,
		INVALID_VEHICLE_ID, 
		0, 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_WORLD], 
		IndustryStorageData[id][e_INDUSTRY_STORAGE_INTERIOR] 
	);
	return true;
}

IndustryStorage_Save(id)
{
	if (!(0 <= id < MAX_INDUSTRY_STORAGE) || !IndustryStorageData[id][e_INDUSTRY_STORAGE_EXISTS])
		return false;

	if (IndustryData[Industry_GetId(IndustryStorageData[id][e_INDUSTRY_STORAGE_PATTERN])][e_INDUSTRY_TYPE] == 0)
		return false;

	inline IndustryStorage_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline IndustryStorage_OnSaved,
		"UPDATE IGNORE `IndústriaEstoque` SET \
		`Indústria`=%i,\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`Interior`=%i,\
		`World`=%i,\
		`Estoque`=%i,\
		`TamanhoEstoque`=%i,\
		`Consumo`=%i,\
		`Produto`=%i,\
		`Preço`=%i,\
		`Venda`=%i \
		WHERE `ID` = %i LIMIT 1;",
		IndustryStorageData[id][e_INDUSTRY_STORAGE_PATTERN],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][0],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][1],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_POS][2],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_INTERIOR],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_WORLD],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK_SIZE],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_CONSUMPTION],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_COMMODITY],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_SELLING],
		IndustryStorageData[id][e_INDUSTRY_STORAGE_ID]
	);

	return true;
}

Industry_ReturnType(type)
{
	new ret[16];

	switch (type)
	{
		case 0: ret = "navio";
		case 1: ret = "primária";
		case 2: ret = "secundária";
		case 3: ret = "terciária";
		default: ret = "N/A";
	}

	return ret;
}

IndustryStorage_Nearest(playerid, Float:radius=3.0)
{
	new idx = -1;

	foreach (new i : IndustryStorages)
	{
		if (GetPlayerVirtualWorld(playerid) != IndustryStorageData[i][e_INDUSTRY_STORAGE_WORLD])
			continue;

		if (GetPlayerInterior(playerid) != IndustryStorageData[i][e_INDUSTRY_STORAGE_INTERIOR])
			continue;

		if (GetPlayerDistanceFromPoint(playerid, IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][0], IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][1], IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][0], IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][1], IndustryStorageData[i][e_INDUSTRY_STORAGE_POS][2]);
		}
	}

	return idx;
}