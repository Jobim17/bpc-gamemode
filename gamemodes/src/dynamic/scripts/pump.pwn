/*
	ooooooooo.
	`888   `Y88.
	 888   .d88' oooo  oooo  ooo. .oo.  .oo.   oo.ooooo.
	 888ooo88P'  `888  `888  `888P"Y88bP"Y88b   888' `88b
	 888          888   888   888   888   888   888   888
	 888          888   888   888   888   888   888   888
	o888o         `V88V"V8P' o888o o888o o888o  888bod8P'
	                                            888
	                                           o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Variáveis
static s_pEditGasPump[MAX_PLAYERS] = {-1, ...};

// Callbacks
hook OnPlayerConnect(playerid)
{
	s_pEditGasPump[playerid] = -1;
	return true;
}

hook OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (s_pEditGasPump[playerid] != -1 && response != EDIT_RESPONSE_UPDATE)
	{
		static id;
		id = s_pEditGasPump[playerid];

		if ((0 <= id < MAX_GAS_PUMP) && PumpData[id][e_PUMP_EXISTS])
		{
			if (response == EDIT_RESPONSE_FINAL)
			{
				PumpData[id][e_PUMP_POS][0] = x;
				PumpData[id][e_PUMP_POS][1] = y;
				PumpData[id][e_PUMP_POS][2] = z;
				PumpData[id][e_PUMP_POS][3] = rz;
				Pump_Save(id);

				SendClientMessageEx(playerid, COLOR_GREEN, "Você editou a posição da bomba de combustível ID: %i.", id);
			}
			else
			{
				SendErrorMessage(playerid, "Você cancelou a edição da bomba de combustível ID: %i.", id);
			}

			Pump_Refresh(id);
		}

		CancelEdit(playerid);
		s_pEditGasPump[playerid] = -1;
	}

	return true;
}

// Functions
Pump_Load()
{
	inline Pump_OnLoaded()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_GAS_PUMP; i++)
		{
			if (i >= rows)
			{
				PumpData[i] = PumpData[MAX_GAS_PUMP];
				continue;
			}

			// Get values
			cache_get_value_name_int(i, "ID", PumpData[i][e_PUMP_ID]);
			cache_get_value_name_int(i, "Empresa", PumpData[i][e_PUMP_BUSINESS]);
			cache_get_value_name_float(i, "PosX", PumpData[i][e_PUMP_POS][0]);
			cache_get_value_name_float(i, "PosY", PumpData[i][e_PUMP_POS][1]);
			cache_get_value_name_float(i, "PosZ", PumpData[i][e_PUMP_POS][2]);
			cache_get_value_name_float(i, "Rot", PumpData[i][e_PUMP_POS][3]);
			cache_get_value_name_int(i, "World", PumpData[i][e_PUMP_WORLD]);
			cache_get_value_name_int(i, "Interior", PumpData[i][e_PUMP_INTERIOR]);
			PumpData[i][e_PUMP_EXISTS] = true;

			Pump_Refresh(i);
		}

		if (rows)
			printf("[Pump] Loaded %i pumps.", rows);
		else
			print("[Pump] No pumps to load.");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Pump_OnLoaded, "SELECT * FROM `Bombas` LIMIT %i;", MAX_GAS_PUMP);
	return true;
}

Pump_Create(playerid, bizid)
{
	if (!(0 <= bizid < MAX_BUSINESS) || !BusinessData[bizid][e_BUSINESS_EXISTS])
		return false;

	static Float:angle;

	for (new id = 0; id < MAX_GAS_PUMP; id++) if (!PumpData[id][e_PUMP_EXISTS])
	{
		inline Pump_OnCreated()
		{
			if (cache_affected_rows())
			{
				PumpData[id][e_PUMP_ID] = cache_insert_id();
				Pump_Save(id);
			}
		}

		PumpData[id] = PumpData[MAX_GAS_PUMP];

		PumpData[id][e_PUMP_EXISTS] = true;
		PumpData[id][e_PUMP_BUSINESS] = BusinessData[bizid][e_BUSINESS_ID];
		
		GetPlayerPos(playerid, PumpData[id][e_PUMP_POS][0], PumpData[id][e_PUMP_POS][1], PumpData[id][e_PUMP_POS][2]);
		GetPlayerFacingAngle(playerid, angle);

		PumpData[id][e_PUMP_POS][0] += 5.0 * floatsin(-angle, degrees);
		PumpData[id][e_PUMP_POS][1] += 5.0 * floatcos(-angle, degrees);

		PumpData[id][e_PUMP_WORLD] = GetPlayerVirtualWorld(playerid);
		PumpData[id][e_PUMP_INTERIOR] = GetPlayerInterior(playerid);

		Pump_Refresh(id);
		
		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Pump_OnCreated, "INSERT IGNORE INTO `Bombas` (`Empresa`) VALUES (%i);", BusinessData[bizid][e_BUSINESS_ID]);
		return id;
	}

	return -1;
}

Pump_Refresh(id)
{
	if (!(0 <= id < MAX_GAS_PUMP) || !PumpData[id][e_PUMP_EXISTS])
		return false;

	if (IsValidDynamic3DTextLabel(PumpData[id][e_PUMP_LABEL]))
	{
		DestroyDynamic3DTextLabel(PumpData[id][e_PUMP_LABEL]);
		PumpData[id][e_PUMP_LABEL] = Text3D:INVALID_STREAMER_ID;
	}
	
	if (IsValidDynamicObject(PumpData[id][e_PUMP_OBJECT]))
	{
		DestroyDynamicObject(PumpData[id][e_PUMP_OBJECT]);
		PumpData[id][e_PUMP_OBJECT] = INVALID_OBJECT_ID;
	}

	// Objeto
	PumpData[id][e_PUMP_OBJECT] = CreateDynamicObject(
		PUMP_OBJECT_MODEL, 
		PumpData[id][e_PUMP_POS][0], 
		PumpData[id][e_PUMP_POS][1], 
		PumpData[id][e_PUMP_POS][2], 
		0.0,
		0.0,
		PumpData[id][e_PUMP_POS][3], 
		PumpData[id][e_PUMP_WORLD],
		PumpData[id][e_PUMP_INTERIOR]
	);

	// Label
	static
		biz, 
		price, 
		text[64 + 1];

	biz = Business_GetRealID(PumpData[id][e_PUMP_BUSINESS]);

	if (biz != -1)
	{
		price = BusinessData[biz][e_BUSINESS_FUEL_PRICE];

		if (price < 1)
		{
			text = "{BBBBBB}Indisponível\n(Nenhum preço definido)";
		}
		else
		{
			format (text, sizeof text, "%s/litro", FormatMoney(price));
		}
	}
	else
	{
		text = "{BBBBBB}Indisponível\n(Empresa inválida)";
	}

	PumpData[id][e_PUMP_LABEL] = CreateDynamic3DTextLabel(
		text, 
		-1, 
		PumpData[id][e_PUMP_POS][0], 
		PumpData[id][e_PUMP_POS][1], 
		PumpData[id][e_PUMP_POS][2], 
		5.0, 
		.worldid = PumpData[id][e_PUMP_WORLD],
		.interiorid = PumpData[id][e_PUMP_INTERIOR]
	);

	return true;
}

Pump_Save(id)
{
	if (!(0 <= id < MAX_GAS_PUMP) || !PumpData[id][e_PUMP_EXISTS])
		return false;

	inline Pump_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline Pump_OnSaved, 
		"UPDATE IGNORE `Bombas` SET \
		`Empresa` = %i,\
		`PosX` = '%f',\
		`PosY` = '%f',\
		`PosZ` = '%f',\
		`Rot` = '%f',\
		`World` = %i,\
		`Interior` = %i \
		WHERE `ID` = %i LIMIT 1;",
		PumpData[id][e_PUMP_BUSINESS],
		PumpData[id][e_PUMP_POS][0],
		PumpData[id][e_PUMP_POS][1],
		PumpData[id][e_PUMP_POS][2],
		PumpData[id][e_PUMP_POS][3],
		PumpData[id][e_PUMP_WORLD],
		PumpData[id][e_PUMP_INTERIOR],
		PumpData[id][e_PUMP_ID]
	);
	return true;
}

Pump_Destroy(id)
{
	if (!(0 <= id < MAX_GAS_PUMP) || !PumpData[id][e_PUMP_EXISTS])
		return false;

	if (IsValidDynamic3DTextLabel(PumpData[id][e_PUMP_LABEL]))
		DestroyDynamic3DTextLabel(PumpData[id][e_PUMP_LABEL]);
	
	if (IsValidDynamicObject(PumpData[id][e_PUMP_OBJECT]))
		DestroyDynamicObject(PumpData[id][e_PUMP_OBJECT]);

	new query[64];
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Bombas` WHERE `ID` = %i LIMIT 1;", PumpData[id][e_PUMP_ID]);
	mysql_tquery (MYSQL_CUR_HANDLE, query);

	PumpData[id] = PumpData[MAX_GAS_PUMP];
	return true;
}

Pump_BusinessRefresh(bizid)
{
	if (!(0 <= bizid < MAX_BUSINESS) || !BusinessData[bizid][e_BUSINESS_EXISTS])
		return false;

	for (new i = 0; i < MAX_GAS_PUMP; i++)
	{
		if (PumpData[i][e_PUMP_EXISTS] && PumpData[i][e_PUMP_BUSINESS] == BusinessData[bizid][e_BUSINESS_ID])
		{
			Pump_Refresh(i);
		}
	}

	return true;
}

Pump_BusinessRemove(bizid)
{
	if (!(0 <= bizid < MAX_BUSINESS) || !BusinessData[bizid][e_BUSINESS_EXISTS])
		return false;

	for (new i = 0; i < MAX_GAS_PUMP; i++)
	{
		if (PumpData[i][e_PUMP_EXISTS] && PumpData[i][e_PUMP_BUSINESS] == BusinessData[bizid][e_BUSINESS_ID])
		{
			Pump_Destroy(i);
		}
	}

	return true;
}

// Comandos
CMD:criarbomba(playerid, params[])
{
    if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
	    return false;

	static
		bizid, id;

	if (sscanf(params, "i", bizid))
		return SendUsageMessage(playerid, "/criarbomba [id da empresa]");

	if (!(0 <= bizid < MAX_BUSINESS) || !BusinessData[bizid][e_BUSINESS_EXISTS])
		return SendErrorMessage(playerid, "Você especificou um ID de empresa inválido.");

	if (BusinessData[bizid][e_BUSINESS_TYPE] != BUSINESS_TYPE_GAS_STATION)
		return SendErrorMessage(playerid, "Esta empresa não é do tipo Posto de Gasolina.");

	id = Pump_Create(playerid, bizid);

	if (id == -1)
		return SendErrorMessage(playerid, "O servidor atingiu o limite de bombas de combustível.");

	s_pEditGasPump[playerid] = id;
	EditDynamicObject(playerid, PumpData[id][e_PUMP_OBJECT]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você criou com sucesso a bomba de combustível ID: %i.", id);
	return true;
}

CMD:destruirbomba(playerid, params[])
{
    if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
	    return false;

	static
		id;

	if (sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/destruirbomba [id]");

	if (!(0 <= id < MAX_BUSINESS) || !PumpData[id][e_PUMP_EXISTS])
		return SendErrorMessage(playerid, "Você especificou um ID de bomba de combustível inválido.");

	Pump_Destroy(id);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você destruiu com sucesso a bomba de combustível ID: %i.", id);
	return true;
}

CMD:editarbomba(playerid, params[])
{
    if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
	    return false;

	static
		id;

	if (sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/editarbomba [id]");

	if (!(0 <= id < MAX_BUSINESS) || !PumpData[id][e_PUMP_EXISTS])
		return SendErrorMessage(playerid, "Você especificou um ID de bomba de combustível inválido.");

	s_pEditGasPump[playerid] = id;
	EditDynamicObject(playerid, PumpData[id][e_PUMP_OBJECT]);
	SendClientMessageEx(playerid, -1, "SERVER: Você está editando a posição da bomba ID: %i.", id);
	return true;
}