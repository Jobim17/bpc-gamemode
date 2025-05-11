/*
	ooooo                 .                                              .
	`888'               .o8                                            .o8
	 888  ooo. .oo.   .o888oo  .ooooo.  oooo d8b  .oooo.    .ooooo.  .o888oo  .oooo.o
	 888  `888P"Y88b    888   d88' `88b `888""8P `P  )88b  d88' `"Y8   888   d88(  "8
	 888   888   888    888   888ooo888  888      .oP"888  888         888   `"Y88b.
	 888   888   888    888 . 888    .o  888     d8(  888  888   .o8   888 . o.  )88b
	o888o o888o o888o   "888" `Y8bod8P' d888b    `Y888""8o `Y8bod8P'   "888" 8""888P'

*/

// Functions
Interact_Load()
{
	Iter_Clear(Interacts);

	inline Interact_OnLoaded()
	{
		new rows;
		rows = cache_num_rows();

		for (new i = 0; i < MAX_INTERACTS; i++)
		{
			// Reset
			if (i >= rows) {
				InteractData[i] = InteractData[MAX_INTERACTS];
				continue;
			}

			// Get values
			InteractData[i][e_INTERACT_EXISTS] = true;
			cache_get_value_name_int(i, "ID", InteractData[i][e_INTERACT_ID]);
			cache_get_value_name_int(i, "Tipo", InteractData[i][e_INTERACT_TYPE]);
			cache_get_value_name_float(i, "PosX", InteractData[i][e_INTERACT_POS][0]);
			cache_get_value_name_float(i, "PosY", InteractData[i][e_INTERACT_POS][1]);
			cache_get_value_name_float(i, "PosZ", InteractData[i][e_INTERACT_POS][2]);
			cache_get_value_name_int(i, "Interior", InteractData[i][e_INTERACT_INTERIOR]);
			cache_get_value_name_int(i, "World", InteractData[i][e_INTERACT_WORLD]);
			Iter_Add(Interacts, i);

			Interact_Refresh(i);
		}

		if (rows)
			printf("[Interact] Loaded %i interactions.", rows);
		else
			print("[Interact] No interactions to load.");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interact_OnLoaded, "SELECT * FROM `Interações` LIMIT %i;", MAX_INTERACTS);
	return true;
}

Interact_Create(playerid, type)
{
	new idx = Iter_Free(Interacts);

	if (idx != ITER_NONE)
	{
		inline Interact_OnCreated()
		{
			if (cache_affected_rows())
			{
				InteractData[idx][e_INTERACT_ID] = cache_insert_id();

				Interact_Save(idx);
				Interact_Refresh(idx);
			}
		}

		InteractData[idx][e_INTERACT_EXISTS] = true;
		InteractData[idx][e_INTERACT_TYPE] = type;

		GetPlayerPos(playerid, InteractData[idx][e_INTERACT_POS][0], InteractData[idx][e_INTERACT_POS][1], InteractData[idx][e_INTERACT_POS][2]);
		InteractData[idx][e_INTERACT_INTERIOR] = GetPlayerInterior(playerid);
		InteractData[idx][e_INTERACT_WORLD] = GetPlayerVirtualWorld(playerid);

		Iter_Add(Interacts, idx);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interact_OnCreated, "INSERT IGNORE INTO `Interações` (`Tipo`, `Criador`) VALUES (%i, '%e');", type, AccountData[playerid][e_ACCOUNT_NAME]);
	}

	return idx;
}

Interact_Refresh(index)
{
	if(!(0 <= index < MAX_INTERACTS) || !InteractData[index][e_INTERACT_EXISTS])
		return 1;

	if(IsValidDynamicArea(InteractData[index][e_INTERACT_AREA]))
		DestroyDynamicArea(InteractData[index][e_INTERACT_AREA]);

	if(IsValidDynamicPickup(InteractData[index][e_INTERACT_ICON]))
		DestroyDynamicPickup(InteractData[index][e_INTERACT_ICON]);

	if (IsValidDynamic3DTextLabel(InteractData[index][e_INTERACT_LABEL]))
		DestroyDynamic3DTextLabel(InteractData[index][e_INTERACT_LABEL]);

	static
	    pickupid, text[32];

	switch(InteractData[index][e_INTERACT_TYPE]) 
	{
	    case INTERACT_TYPE_PREFEITURA: {
	    	pickupid = 1581;
	    	text = "/prefeitura";
	    }
	    case INTERACT_TYPE_AGENCIA_EMPREGOS: {
	    	pickupid = 1210;
	    	text = "/agencia";
	    }
	    default: {
	    	pickupid = 1239;
	    	text = "/interagir";
	    }
	}

	InteractData[index][e_INTERACT_ICON] = CreateDynamicPickup(
		pickupid, 
		23, 
		InteractData[index][e_INTERACT_POS][0], 
		InteractData[index][e_INTERACT_POS][1], 
		InteractData[index][e_INTERACT_POS][2], 
		InteractData[index][e_INTERACT_WORLD], 
		InteractData[index][e_INTERACT_INTERIOR]
	);

	InteractData[index][e_INTERACT_LABEL] = CreateDynamic3DTextLabel(
		text, 
		-1, 
		InteractData[index][e_INTERACT_POS][0], 
		InteractData[index][e_INTERACT_POS][1], 
		InteractData[index][e_INTERACT_POS][2],
		15.0,
		.worldid = InteractData[index][e_INTERACT_WORLD], 
		.interiorid = InteractData[index][e_INTERACT_INTERIOR]
	);

	InteractData[index][e_INTERACT_AREA] = CreateDynamicSphere(
		InteractData[index][e_INTERACT_POS][0], 
		InteractData[index][e_INTERACT_POS][1], 
		InteractData[index][e_INTERACT_POS][2], 
		2.5, 
		.worldid = InteractData[index][e_INTERACT_WORLD], 
		.interiorid = InteractData[index][e_INTERACT_INTERIOR]
	);

	return 1;
}

Interact_Save(index)
{
	if(!(0 <= index < MAX_INTERACTS) || !InteractData[index][e_INTERACT_EXISTS])
		return 1;

	inline Interact_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE, 
		using inline Interact_OnSaved, 
		"UPDATE IGNORE `Interações` SET \
		`Tipo`=%i,\
		`PosX`='%f',\
		`PosY`='%f',\
		`PosZ`='%f',\
		`Interior`=%i,\
		`World`=%i \
		WHERE `ID` = %i LIMIT 1;",
		InteractData[index][e_INTERACT_TYPE],
		InteractData[index][e_INTERACT_POS][0],
		InteractData[index][e_INTERACT_POS][1],
		InteractData[index][e_INTERACT_POS][2],
		InteractData[index][e_INTERACT_INTERIOR],
		InteractData[index][e_INTERACT_WORLD],
		InteractData[index][e_INTERACT_ID]
	);

	return true;
}

Interact_ReturnType(type)
{
	new ret[32] = "Inválido";

	if ((0 <= type < MAX_INTERACT_TYPE))
	{
		format (ret, sizeof ret, g_arrInteractNames[type]);
	}

	return ret;
}

Interact_Destroy(index)
{
	if(!(0 <= index < MAX_INTERACTS) || !InteractData[index][e_INTERACT_EXISTS])
		return 1;

	if(IsValidDynamicArea(InteractData[index][e_INTERACT_AREA]))
		DestroyDynamicArea(InteractData[index][e_INTERACT_AREA]);

	if(IsValidDynamicPickup(InteractData[index][e_INTERACT_ICON]))
		DestroyDynamicPickup(InteractData[index][e_INTERACT_ICON]);

	if (IsValidDynamic3DTextLabel(InteractData[index][e_INTERACT_LABEL]))
		DestroyDynamic3DTextLabel(InteractData[index][e_INTERACT_LABEL]);

	new query[64];
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Interações` WHERE `ID` = %i;", InteractData[index][e_INTERACT_ID]);
	mysql_tquery (MYSQL_CUR_HANDLE, query);

	InteractData[index] = InteractData[MAX_INTERACTS];
	Iter_Remove(Interacts, index);
	return true;
}

Interact_Nearest(playerid, Float:radius=2.5)
{
	new idx = -1;

	foreach (new i : Interacts)
	{
		if (GetPlayerInterior(playerid) != InteractData[i][e_INTERACT_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != InteractData[i][e_INTERACT_WORLD])
			continue;

		if (GetPlayerDistanceFromPoint(playerid, InteractData[i][e_INTERACT_POS][0], InteractData[i][e_INTERACT_POS][1], InteractData[i][e_INTERACT_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, InteractData[i][e_INTERACT_POS][0], InteractData[i][e_INTERACT_POS][1], InteractData[i][e_INTERACT_POS][2]);
		}
	}

	return idx;
}


// Key
SSCANF:interact(const string[])
{
	if (IsNumeric(string))
	{
		new ret = strval(string);
		
		if (0 <= ret < MAX_INTERACT_TYPE)
		{
			return ret;
		}
	}
	else
	{
		for (new i = 0; i < MAX_INTERACT_TYPE; i++)
		{
			if (strfind(g_arrInteractNames[i], string, true) != -1)
			{
				return i;
			}
		}
	}
	return -1;
}

// Comandos
CMD:criarinteracao(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

	static
		type,
		index;

	if (sscanf(params, "k<interact>", type))
	{
		SendClientMessage(playerid, COLOR_BEGE, "USE: /criarinteracao [Tipo]");

		new idx = 0, str[128] = "[Tipos]: ";

		for (new i = 0; i < MAX_INTERACT_TYPE; i++)
		{
			strcat (str, va_return("%s%i. %s ", (!idx ? ("") : ("| ")), i, g_arrInteractNames[i]));

			idx += 1;

			if (!(idx % 5) || (i == (MAX_INTERACT_TYPE - 1)))
			{
				SendClientMessage(playerid, COLOR_BEGE, str);

				str = "[Tipos]: ";
				idx = 0;
			}
		}

		return true;
	} 

	index = Interact_Create(playerid, type);

	if (index == ITER_NONE)
		return SendErrorMessage(playerid, "Não foi possível criar a interação.");

	Log_Create("[Property Team] Interações", "%s criou uma interação de %s", AccountData[playerid][e_ACCOUNT_NAME], Interact_ReturnType(type));
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s criou uma interação de %s (%i)", AccountData[playerid][e_ACCOUNT_NAME], Interact_ReturnType(type), index);
	return true;
}

CMD:destruirinteracao(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

	static
		index;

	if (sscanf(params, "i", index))
		return SendUsageMessage(playerid, "/destruirinteracao [Id]");

	if (!(0 <= index < MAX_INTERACTS) || !InteractData[index][e_INTERACT_EXISTS])
		return SendErrorMessage(playerid, "Você especificou um ID de interação inválido.");

	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s deletou a interação %s (%i)", AccountData[playerid][e_ACCOUNT_NAME], Interact_ReturnType(InteractData[index][e_INTERACT_TYPE]), index);
	Log_Create("[Property Team] Interações", "%s deletou a interação %s (%i)", AccountData[playerid][e_ACCOUNT_NAME], Interact_ReturnType(InteractData[index][e_INTERACT_TYPE]), InteractData[index][e_INTERACT_ID]);
	Interact_Destroy(index);

	SendClientMessageEx(playerid, COLOR_LIGHTRED, "Você deletou a interação %s (%i)", Interact_ReturnType(InteractData[index][e_INTERACT_TYPE]), index);
	return true;
}