/*
	oooooooooooo                                   o8o      .
	`888'     `8                                   `"'    .o8
	 888         oooo  oooo  oooo d8b ooo. .oo.   oooo  .o888oo oooo  oooo  oooo d8b  .ooooo.
	 888oooo8    `888  `888  `888""8P `888P"Y88b  `888    888   `888  `888  `888""8P d88' `88b
	 888    "     888   888   888      888   888   888    888    888   888   888     888ooo888
	 888          888   888   888      888   888   888    888 .  888   888   888     888    .o
	o888o         `V88V"V8P' d888b    o888o o888o o888o   "888"  `V88V"V8P' d888b    `Y8bod8P'

*/

// Include
#include <YSI_Coding\y_hooks>

// Function
Furniture_Load()
{
	Iter_Clear(Furnitures);

	inline Furniture_OnLoaded()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_FURNITURE; i++)
		{
			// Reset values
			if (i >= rows)
			{
				FurnitureData[i] = FurnitureData[MAX_FURNITURE];
				continue;
			}

			// Get values
			Iter_Add(Furnitures, i);
			FurnitureData[i][e_FURNITURE_EXISTS] = true;

			cache_get_value_name_int(i, "ID", FurnitureData[i][e_FURNITURE_ID]);
			cache_get_value_name(i, "Nome", FurnitureData[i][e_FURNITURE_NAME]);
			cache_get_value_name_int(i, "Modelo", FurnitureData[i][e_FURNITURE_MODEL]);
			cache_get_value_name_float(i, "PosX", FurnitureData[i][e_FURNITURE_POS][0]);
			cache_get_value_name_float(i, "PosY", FurnitureData[i][e_FURNITURE_POS][1]);
			cache_get_value_name_float(i, "PosZ", FurnitureData[i][e_FURNITURE_POS][2]);
			cache_get_value_name_float(i, "RotX", FurnitureData[i][e_FURNITURE_ROT][0]);
			cache_get_value_name_float(i, "RotY", FurnitureData[i][e_FURNITURE_ROT][1]);
			cache_get_value_name_float(i, "RotZ", FurnitureData[i][e_FURNITURE_ROT][2]);
			cache_get_value_name_bool(i, "PortaTrancada", FurnitureData[i][e_FURNITURE_DOOR_LOCKED]);
			cache_get_value_name_bool(i, "PortaAberta", FurnitureData[i][e_FURNITURE_DOOR_OPENNED]);
			cache_get_value_name_float(i, "PortaPosX", FurnitureData[i][e_FURNITURE_DOOR_POS][0]);
			cache_get_value_name_float(i, "PortaPosY", FurnitureData[i][e_FURNITURE_DOOR_POS][1]);
			cache_get_value_name_float(i, "PortaPosZ", FurnitureData[i][e_FURNITURE_DOOR_POS][2]);
			cache_get_value_name_float(i, "PortaRotX", FurnitureData[i][e_FURNITURE_DOOR_ROT][0]);
			cache_get_value_name_float(i, "PortaRotY", FurnitureData[i][e_FURNITURE_DOOR_ROT][1]);
			cache_get_value_name_float(i, "PortaRotZ", FurnitureData[i][e_FURNITURE_DOOR_ROT][2]);
			cache_get_value_name_int(i, "Preço", FurnitureData[i][e_FURNITURE_PRICE]);
			cache_get_value_name_int(i, "Tipo", FurnitureData[i][e_FURNITURE_LINK_TYPE]);
			cache_get_value_name_int(i, "Propriedade", FurnitureData[i][e_FURNITURE_LINK_ID]);

			new fields[64], out[MAX_FURNITURE_TEXTURE];
			
			cache_get_value_name(i, "Texturas", fields);
			sscanf(fields, "p<|>A<i>(0, 0)["#MAX_FURNITURE_TEXTURE"]", out);
			FurnitureData[i][e_FURNITURE_TEXTURE] = out;

			cache_get_value_name(i, "Cores", fields);
			sscanf(fields, "p<|>A<i>(0, 0)["#MAX_FURNITURE_TEXTURE"]", out);
			FurnitureData[i][e_FURNITURE_TEXTURE_COLOR] = out;

			Furniture_Refresh(i);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Furniture_OnLoaded, "SELECT * FROM `Mobílias` LIMIT %i;", MAX_FURNITURE);
	return true;
}

Furniture_Create(name[], model, price, type, id, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (!(0 <= type < MAX_FURNITURE_LINK_TYPE))
		return false;

	new 
		freeid 		= Iter_Free(Furnitures),
		prop  		= -1
	;

	if (freeid == ITER_NONE)
		return -1;

	// House
	if (type == FURNITURE_LINK_TYPE_HOUSE && (0 <= id < MAX_HOUSES) && HouseData[id][e_HOUSE_EXISTS])
	{
		prop = HouseData[id][e_HOUSE_ID];
	}

	// Businesss
	if (type == FURNITURE_LINK_TYPE_BUSINESS && (0 <= id < MAX_BUSINESS) && BusinessData[id][e_BUSINESS_EXISTS])
	{
		prop = BusinessData[id][e_BUSINESS_ID];
	}

	// Sets a default data
	FurnitureData[freeid] = FurnitureData[MAX_FURNITURE];

	Iter_Add(Furnitures, freeid);
	FurnitureData[freeid][e_FURNITURE_EXISTS] = true;
	format (FurnitureData[freeid][e_FURNITURE_NAME], 64, name);
	FurnitureData[freeid][e_FURNITURE_MODEL] = model;
	FurnitureData[freeid][e_FURNITURE_POS][0] = x;
	FurnitureData[freeid][e_FURNITURE_POS][1] = y;
	FurnitureData[freeid][e_FURNITURE_POS][2] = z;
	FurnitureData[freeid][e_FURNITURE_ROT][0] = rx;
	FurnitureData[freeid][e_FURNITURE_ROT][1] = ry;
	FurnitureData[freeid][e_FURNITURE_ROT][2] = rz;
	FurnitureData[freeid][e_FURNITURE_DOOR_POS][0] = x;
	FurnitureData[freeid][e_FURNITURE_DOOR_POS][1] = y;
	FurnitureData[freeid][e_FURNITURE_DOOR_POS][2] = z;
	FurnitureData[freeid][e_FURNITURE_DOOR_ROT][0] = rx;
	FurnitureData[freeid][e_FURNITURE_DOOR_ROT][1] = ry;
	FurnitureData[freeid][e_FURNITURE_DOOR_ROT][2] = (90.0 - rz);
	FurnitureData[freeid][e_FURNITURE_PRICE] = price;
	FurnitureData[freeid][e_FURNITURE_LINK_TYPE] = type;
	FurnitureData[freeid][e_FURNITURE_LINK_ID] = prop;

	for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
	{
		FurnitureData[freeid][e_FURNITURE_TEXTURE][i] = -1;
		FurnitureData[freeid][e_FURNITURE_TEXTURE_COLOR][i] = -1;
	}

	Furniture_Refresh(freeid);

	// Create & Refresh
	inline Furniture_OnCreated()
	{
		if (cache_affected_rows())
		{
			FurnitureData[freeid][e_FURNITURE_ID] = cache_insert_id();
			Furniture_Save(freeid);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Furniture_OnCreated, "INSERT IGNORE INTO `Mobílias` (`Tipo`, `Propriedade`) VALUES (%i, %i);", type, id);
	return freeid;
}

Furniture_Clone(id, const name[])
{
	if (!(0 <= id < MAX_FURNITURE) || !FurnitureData[id][e_FURNITURE_EXISTS])
		return false;

	new freeid = Iter_Free(Furnitures);

	if (freeid == ITER_NONE)
		return -1;

	// Sets a default data
	FurnitureData[freeid] = FurnitureData[id];

	Iter_Add(Furnitures, freeid);
	FurnitureData[freeid][e_FURNITURE_ID] = -1;
	FurnitureData[freeid][e_FURNITURE_EXISTS] = true;
	FurnitureData[freeid][e_FURNITURE_OBJECT] = INVALID_STREAMER_ID;
	format (FurnitureData[freeid][e_FURNITURE_NAME], 64, name);
	Furniture_Refresh(freeid);

	// Create & Refresh
	inline Furniture_OnCreated()
	{
		if (cache_affected_rows())
		{
			FurnitureData[freeid][e_FURNITURE_ID] = cache_insert_id();
			Furniture_Save(freeid);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Furniture_OnCreated, "INSERT IGNORE INTO `Mobílias` (`Tipo`, `Propriedade`) VALUES (%i, %i);", FurnitureData[id][e_FURNITURE_LINK_TYPE], FurnitureData[id][e_FURNITURE_LINK_ID]);
	return freeid;
}

Furniture_Refresh(id)
{
	if (!(0 <= id < MAX_FURNITURE) || !FurnitureData[id][e_FURNITURE_EXISTS])
		return false;

	if (IsValidDynamicObject(FurnitureData[id][e_FURNITURE_OBJECT]))
	{
		DestroyDynamicObject(FurnitureData[id][e_FURNITURE_OBJECT]);
		FurnitureData[id][e_FURNITURE_OBJECT] = INVALID_STREAMER_ID;
	}

	new 
		world 		= -1,
		interior 	= -1,
		extraid  	= -1
	;

	// House
	if (FurnitureData[id][e_FURNITURE_LINK_TYPE] == FURNITURE_LINK_TYPE_HOUSE && (extraid = House_GetRealID(FurnitureData[id][e_FURNITURE_LINK_ID])) != -1)
	{
		world = HouseData[extraid][e_HOUSE_INSIDE_WORLD];
		interior = HouseData[extraid][e_HOUSE_INSIDE_INTERIOR];
	}

	// Business
	if (FurnitureData[id][e_FURNITURE_LINK_TYPE] == FURNITURE_LINK_TYPE_BUSINESS && (extraid = Business_GetRealID(FurnitureData[id][e_FURNITURE_LINK_ID])) != -1)
	{
		world = BusinessData[extraid][e_BUSINESS_INSIDE_WORLD];
		interior = BusinessData[extraid][e_BUSINESS_INSIDE_INTERIOR];
	}

	// Objeto
	FurnitureData[id][e_FURNITURE_OBJECT] = CreateDynamicObject(
		FurnitureData[id][e_FURNITURE_MODEL],
		FurnitureData[id][e_FURNITURE_POS][0],
		FurnitureData[id][e_FURNITURE_POS][1],
		FurnitureData[id][e_FURNITURE_POS][2],
		FurnitureData[id][e_FURNITURE_ROT][0],
		FurnitureData[id][e_FURNITURE_ROT][1],
		FurnitureData[id][e_FURNITURE_ROT][2],
		world,
		interior
	);

	// Texturas
	for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
	{
		RemoveDynamicObjectMaterial(FurnitureData[id][e_FURNITURE_OBJECT], i);

	    if(FurnitureData[id][e_FURNITURE_TEXTURE][i] != -1 && FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] == -1)
	    {
	    	new textureid = FurnitureData[id][e_FURNITURE_TEXTURE][i];
	    	SetDynamicObjectMaterial(FurnitureData[id][e_FURNITURE_OBJECT], i, g_aTextures[textureid][e_TEXTURE_OBJECT], g_aTextures[textureid][e_TEXTURE_LIB], g_aTextures[textureid][e_TEXTURE_SUB_LIB]);
	    }
		
		if(FurnitureData[id][e_FURNITURE_TEXTURE][i] != -1 && FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] != -1)
	    {
	    	new textureid = FurnitureData[id][e_FURNITURE_TEXTURE][i];
	        new colorid = FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i];
	        SetDynamicObjectMaterial(FurnitureData[id][e_FURNITURE_OBJECT], i, g_aTextures[textureid][e_TEXTURE_OBJECT], g_aTextures[textureid][e_TEXTURE_LIB], g_aTextures[textureid][e_TEXTURE_SUB_LIB], g_aColors[colorid][e_COLOR_ARGB]);
	    }
	    
	    if(FurnitureData[id][e_FURNITURE_TEXTURE][i] == -1 && FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] != -1)
	    {
	    	new colorid = FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i];
	        SetDynamicObjectMaterial(FurnitureData[id][e_FURNITURE_OBJECT], i, 500, "none", "none", g_aColors[colorid][e_COLOR_ARGB]);
	    }
	}

	// Porta
	if (Furniture_IsDoor(FurnitureData[id][e_FURNITURE_MODEL]))
	{
		if (FurnitureData[id][e_FURNITURE_DOOR_OPENNED])
		{
			SetDynamicObjectPos(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_DOOR_POS][0], FurnitureData[id][e_FURNITURE_DOOR_POS][1], FurnitureData[id][e_FURNITURE_DOOR_POS][2]);
			SetDynamicObjectRot(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_DOOR_ROT][0], FurnitureData[id][e_FURNITURE_DOOR_ROT][1], FurnitureData[id][e_FURNITURE_DOOR_ROT][2]);
		}	
		else
		{
			SetDynamicObjectPos(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]);
			SetDynamicObjectRot(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_ROT][0], FurnitureData[id][e_FURNITURE_ROT][1], FurnitureData[id][e_FURNITURE_ROT][2]);
		}
	}

	// Check
	foreach (new i : Player)
	{
		if (GetPlayerVirtualWorld(i) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, FurnitureData[id][e_FURNITURE_OBJECT], E_STREAMER_WORLD_ID))
			continue;

		if (GetPlayerInterior(i) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, FurnitureData[id][e_FURNITURE_OBJECT], E_STREAMER_INTERIOR_ID))
			continue;
		
		Streamer_Update(i, STREAMER_TYPE_OBJECT);
	}
	return true;
}

Furniture_Save(id)
{
	if (!(0 <= id < MAX_FURNITURE) || !FurnitureData[id][e_FURNITURE_EXISTS])
		return false;

	inline Furniture_Saved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline Furniture_Saved,
		"UPDATE IGNORE `Mobílias` SET \
		`Nome` = '%e',\
		`Modelo` = %i,\
		`Texturas` = '%i|%i|%i|%i|%i|%i',\
		`Cores` = '%i|%i|%i|%i|%i|%i',\
		`PosX` = '%f',\
		`PosY` = '%f',\
		`PosZ` = '%f',\
		`RotX` = '%f',\
		`RotY` = '%f',\
		`RotZ` = '%f',\
		`PortaTrancada` = %i,\
		`PortaAberta` = %i,\
		`PortaPosX` = '%f',\
		`PortaPosY` = '%f',\
		`PortaPosZ` = '%f',\
		`PortaRotX` = '%f',\
		`PortaRotY` = '%f',\
		`PortaRotZ` = '%f',\
		`Preço` = %i,\
		`Tipo` = %i,\
		`Propriedade` = %i \
		WHERE `ID` = %i LIMIT 1;",
		FurnitureData[id][e_FURNITURE_NAME],
		FurnitureData[id][e_FURNITURE_MODEL],
		FurnitureData[id][e_FURNITURE_TEXTURE][0],
		FurnitureData[id][e_FURNITURE_TEXTURE][1],
		FurnitureData[id][e_FURNITURE_TEXTURE][2],
		FurnitureData[id][e_FURNITURE_TEXTURE][3],
		FurnitureData[id][e_FURNITURE_TEXTURE][4],
		FurnitureData[id][e_FURNITURE_TEXTURE][5],
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][0],
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][1],
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][2],
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][3],
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][4],
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][5],
		FurnitureData[id][e_FURNITURE_POS][0],
		FurnitureData[id][e_FURNITURE_POS][1],
		FurnitureData[id][e_FURNITURE_POS][2],
		FurnitureData[id][e_FURNITURE_ROT][0],
		FurnitureData[id][e_FURNITURE_ROT][1],
		FurnitureData[id][e_FURNITURE_ROT][2],
		FurnitureData[id][e_FURNITURE_DOOR_LOCKED],
		FurnitureData[id][e_FURNITURE_DOOR_OPENNED],
		FurnitureData[id][e_FURNITURE_DOOR_POS][0],
		FurnitureData[id][e_FURNITURE_DOOR_POS][1],
		FurnitureData[id][e_FURNITURE_DOOR_POS][2],
		FurnitureData[id][e_FURNITURE_DOOR_ROT][0],
		FurnitureData[id][e_FURNITURE_DOOR_ROT][1],
		FurnitureData[id][e_FURNITURE_DOOR_ROT][2],
		FurnitureData[id][e_FURNITURE_PRICE],
		FurnitureData[id][e_FURNITURE_LINK_TYPE],
		FurnitureData[id][e_FURNITURE_LINK_ID],
		FurnitureData[id][e_FURNITURE_ID]
	);


	return true;
}

Furniture_Delete(id)
{
	if (!(0 <= id < MAX_FURNITURE) || !FurnitureData[id][e_FURNITURE_EXISTS])
		return false;

	if (IsValidDynamicObject(FurnitureData[id][e_FURNITURE_OBJECT]))
	{
		DestroyDynamicObject(FurnitureData[id][e_FURNITURE_OBJECT]);
		FurnitureData[id][e_FURNITURE_OBJECT] = INVALID_STREAMER_ID;
	}

	new query[64];
	mysql_format(MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Mobílias` WHERE `ID` = %i LIMIT 1;", FurnitureData[id][e_FURNITURE_ID]);
	mysql_query(MYSQL_CUR_HANDLE, query);

	Iter_Remove(Furnitures, id);
	FurnitureData[id] = FurnitureData[MAX_FURNITURE];
	return true;
}

Furniture_GetCount(type, id)
{
	new count = 0;

	foreach (new i : Furnitures)
	{
		if (!(FurnitureData[i][e_FURNITURE_EXISTS] && FurnitureData[i][e_FURNITURE_LINK_TYPE] == type && FurnitureData[i][e_FURNITURE_LINK_ID] == id))
			continue;

		count += 1;
	}

	return count;
}

Furniture_GetMaxSlots(playerid)
{
	if (!IsPlayerConnected(playerid))
		return -1;

	switch(Premium_GetLevel(playerid))
	{
		case PREMIUM_LEVEL_GOLD: 
			return MAX_FURNITURE_SLOT_GOLD;

		case PREMIUM_LEVEL_SILVER: 
			return MAX_FURNITURE_SLOT_SILVER;

		case PREMIUM_LEVEL_BRONZE: 
			return MAX_FURNITURE_SLOT_BRONZE;

		default:
			return MAX_FURNITURE_SLOT_REGULAR;
	}

	return -1;
}

Furniture_GetRealID(id)
{
	foreach (new i : Furnitures)
	{
		if (!FurnitureData[i][e_FURNITURE_EXISTS] || FurnitureData[i][e_FURNITURE_ID] != id)
			continue;

		return i;
	}

	return -1;
}

Furniture_IsDoor(model)
{
	switch (model)
	{
		case 1496, 1497, 2949, 977, 1493, 1495, 1536, 1498, 1569, 1567, 1557, 1535, 1504, 1505, 1507, 1499, 19861, 1522, 8957, 13188, 7709, 7707, 13028, 11416, 1506, 19860, 19875, 19857, 3089, 19619:
		{
			return true;
		}
	}

	return false;
}

Furniture_NearestDoor(playerid, Float:radius = 2.5)
{
	new idx = -1;

	foreach (new i : Furnitures)
	{
		if (!FurnitureData[i][e_FURNITURE_EXISTS] || !IsValidDynamicObject(FurnitureData[i][e_FURNITURE_OBJECT]))
			continue;

		if (GetPlayerInterior(playerid) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, FurnitureData[i][e_FURNITURE_OBJECT], E_STREAMER_INTERIOR_ID))
			continue;

		if (GetPlayerVirtualWorld(playerid) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, FurnitureData[i][e_FURNITURE_OBJECT], E_STREAMER_WORLD_ID))
			continue;

		if (!Furniture_IsDoor(FurnitureData[i][e_FURNITURE_MODEL]))
			continue;

		if (GetPlayerDistanceFromPoint(playerid, FurnitureData[i][e_FURNITURE_POS][0], FurnitureData[i][e_FURNITURE_POS][1], FurnitureData[i][e_FURNITURE_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, FurnitureData[i][e_FURNITURE_POS][0], FurnitureData[i][e_FURNITURE_POS][1], FurnitureData[i][e_FURNITURE_POS][2]);
		}
	}

	return idx;
}

Furniture_GetTextureName(id)
{
	new name[64] = "Desconhecida";

	if (0 <= id < sizeof g_aTextures)
	{
		if(strlen(g_aTextures[id][e_TEXTURE_NAME]) > 0)
		{
			format (name, sizeof name, g_aTextures[id][e_TEXTURE_NAME]);
		}
		else
		{
			format (name, sizeof name, "%i, %s, %s", g_aTextures[id][e_TEXTURE_OBJECT], g_aTextures[id][e_TEXTURE_LIB], g_aTextures[id][e_TEXTURE_SUB_LIB]);
		}
	}

	return name;
}