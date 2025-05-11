/*
	oooooooooo.                        o8o
	`888'   `Y8b                       `"'
	 888     888 oooo  oooo   .oooo.o oooo  ooo. .oo.    .ooooo.   .oooo.o  .oooo.o
	 888oooo888' `888  `888  d88(  "8 `888  `888P"Y88b  d88' `88b d88(  "8 d88(  "8
	 888    `88b  888   888  `"Y88b.   888   888   888  888ooo888 `"Y88b.  `"Y88b.
	 888    .88P  888   888  o.  )88b  888   888   888  888    .o o.  )88b o.  )88b
	o888bood8P'   `V88V"V8P' 8""888P' o888o o888o o888o `Y8bod8P' 8""888P' 8""888P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Functions
Business_Load()
{
	inline Business_OnLoaded()
	{
		new rows = cache_num_rows();

		for (new i; i < MAX_BUSINESS; i++)
		{
			if (i >= rows)
			{
				BusinessData[i] = BusinessData[MAX_BUSINESS];
				continue;
			}

			// Get values
			cache_get_value_name_int(i, "ID", BusinessData[i][e_BUSINESS_ID]);
			cache_get_value_name_int(i, "Dono", BusinessData[i][e_BUSINESS_OWNER]);
			cache_get_value_name(i, "Nome", BusinessData[i][e_BUSINESS_NAME], 32);
			cache_get_value_name(i, "Mensagem", BusinessData[i][e_BUSINESS_MESSAGE], 128);
			cache_get_value_name(i, "Rádio", BusinessData[i][e_BUSINESS_MESSAGE], 255);
			cache_get_value_name_int(i, "TaxaEntrada", BusinessData[i][e_BUSINESS_ENTRANCE_FEE]);
			cache_get_value_name_int(i, "Preço", BusinessData[i][e_BUSINESS_PRICE]);
			cache_get_value_name_int(i, "Tipo", BusinessData[i][e_BUSINESS_TYPE]);
			cache_get_value_name_int(i, "Cofre", BusinessData[i][e_BUSINESS_VAULT]);
			cache_get_value_name_float(i, "PosX", BusinessData[i][e_BUSINESS_POS][0]);
			cache_get_value_name_float(i, "PosY", BusinessData[i][e_BUSINESS_POS][1]);
			cache_get_value_name_float(i, "PosZ", BusinessData[i][e_BUSINESS_POS][2]);
			cache_get_value_name_int(i, "World", BusinessData[i][e_BUSINESS_WORLD]);
			cache_get_value_name_int(i, "Interior", BusinessData[i][e_BUSINESS_INTERIOR]);
			cache_get_value_name_float(i, "InsidePosX", BusinessData[i][e_BUSINESS_INSIDE_POS][0]);
			cache_get_value_name_float(i, "InsidePosY", BusinessData[i][e_BUSINESS_INSIDE_POS][1]);
			cache_get_value_name_float(i, "InsidePosZ", BusinessData[i][e_BUSINESS_INSIDE_POS][2]);
			cache_get_value_name_float(i, "InsideAngle", BusinessData[i][e_BUSINESS_INSIDE_POS][3]);
			cache_get_value_name_int(i, "InsideInterior", BusinessData[i][e_BUSINESS_INSIDE_INTERIOR]);
			cache_get_value_name_bool(i, "Trancada", BusinessData[i][e_BUSINESS_LOCKED]);
			cache_get_value_name_bool(i, "Aberta", BusinessData[i][e_BUSINESS_OPEN]);
			cache_get_value_name_int(i, "Combustível", BusinessData[i][e_BUSINESS_FUEL]);
			cache_get_value_name_int(i, "PreçoCombustível", BusinessData[i][e_BUSINESS_FUEL_PRICE]);
			cache_get_value_name_int(i, "Produtos", BusinessData[i][e_BUSINESS_PRODUCTS]);
			cache_get_value_name_int(i, "LimiteProdutos", BusinessData[i][e_BUSINESS_PRODUCT_LIMIT]);
			cache_get_value_name_int(i, "PedidoQuantidade", BusinessData[i][e_BUSINESS_REQUEST_QUANTITY]);
			cache_get_value_name_int(i, "PedidoCarga", BusinessData[i][e_BUSINESS_REQUEST_CARGO]);
			cache_get_value_name_int(i, "PedidoPreço", BusinessData[i][e_BUSINESS_REQUEST_PRICE]);
			
			BusinessData[i][e_BUSINESS_INSIDE_WORLD] = WORLD_BUSINESS + i;
			BusinessData[i][e_BUSINESS_EXISTS] = true;
			Iter_Add(Business, i);
			Business_Refresh(i);
		}

		if (rows)
		{
			printf("[Business] Loaded %i business.", rows);
		}
		else
		{
			print("[Business] No business to load.");
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Business_OnLoaded, "SELECT * FROM `Empresas` LIMIT "#MAX_BUSINESS";");
	return true;
}

Business_Create(playerid, type, price)
{
	new idx = Iter_Free(Business);

	if (idx != ITER_NONE)
	{
		inline Business_OnCreated()
		{
			if (cache_affected_rows())
			{
				BusinessData[idx][e_BUSINESS_ID] = cache_insert_id();
				Business_Save(idx);
			}
		}

		BusinessData[idx] = BusinessData[MAX_BUSINESS];

		format (BusinessData[idx][e_BUSINESS_NAME], 32, g_arrBusinessType[type]);
		BusinessData[idx][e_BUSINESS_EXISTS] = true;
		BusinessData[idx][e_BUSINESS_TYPE] = type;
		BusinessData[idx][e_BUSINESS_PRICE] = price;
		BusinessData[idx][e_BUSINESS_PRODUCT_LIMIT] = 500;

		GetPlayerPos(
			playerid, 
			BusinessData[idx][e_BUSINESS_POS][0], 
			BusinessData[idx][e_BUSINESS_POS][1], 
			BusinessData[idx][e_BUSINESS_POS][2] 
		);

		BusinessData[idx][e_BUSINESS_WORLD] = GetPlayerVirtualWorld(playerid);
		BusinessData[idx][e_BUSINESS_INTERIOR] = GetPlayerInterior(playerid);
		BusinessData[idx][e_BUSINESS_INSIDE_WORLD] = (WORLD_BUSINESS + idx);
		Business_Refresh(idx);
		Iter_Add(Business, idx);

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Business_OnCreated, "INSERT IGNORE INTO `Empresas` (`Dono`) VALUES (0);");
	}

	return idx;
}

Business_Refresh(id)
{
	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return false;

	if (IsValidDynamicPickup(BusinessData[id][e_BUSINESS_ICON]))
		DestroyDynamicPickup(BusinessData[id][e_BUSINESS_ICON]);

	if (IsValidDynamic3DTextLabel(BusinessData[id][e_BUSINESS_LABEL]))
		DestroyDynamic3DTextLabel(BusinessData[id][e_BUSINESS_LABEL]);

	if (IsValidDynamicArea(BusinessData[id][e_BUSINESS_AREA]))
		DestroyDynamicArea(BusinessData[id][e_BUSINESS_AREA]);

	static icon, label[64];

	icon = 1239;
	label = "";

	switch (BusinessData[id][e_BUSINESS_TYPE])
	{
		case BUSINESS_TYPE_ADVERTISE: 
		{
			icon = 1239;
			format (label, sizeof label, "Central de Anúncios\n/an, /anemp ou /flyer.");
		}

		case BUSINESS_TYPE_VEHICLE_DEALER:
		{
			icon = 1239;
			format (label, sizeof label, "Concessionária\n/v comprar ou /v upgrade.");
		}

		default:
		{
			if (BusinessData[id][e_BUSINESS_OWNER] == 0) // À venda
			{
				icon = 1272;
				label = "";
			}
		}
	}

	// Icon
	BusinessData[id][e_BUSINESS_ICON] = CreateDynamicPickup(
		icon, 
		23, 
		BusinessData[id][e_BUSINESS_POS][0], 
		BusinessData[id][e_BUSINESS_POS][1], 
		BusinessData[id][e_BUSINESS_POS][2],
		BusinessData[id][e_BUSINESS_WORLD],
		BusinessData[id][e_BUSINESS_INTERIOR]
	);

	// Label
	if (IsNull(label))
	{
		BusinessData[id][e_BUSINESS_LABEL] = Text3D:INVALID_STREAMER_ID;
	}
	else
	{
		BusinessData[id][e_BUSINESS_LABEL] = CreateDynamic3DTextLabel(
			label, 
			-1,
			BusinessData[id][e_BUSINESS_POS][0], 
			BusinessData[id][e_BUSINESS_POS][1], 
			BusinessData[id][e_BUSINESS_POS][2],
			10.0,
			.worldid = BusinessData[id][e_BUSINESS_WORLD],
			.interiorid = BusinessData[id][e_BUSINESS_INTERIOR]
		);
	}

	// Area
	BusinessData[id][e_BUSINESS_AREA] = CreateDynamicSphere(
		BusinessData[id][e_BUSINESS_POS][0], 
		BusinessData[id][e_BUSINESS_POS][1], 
		BusinessData[id][e_BUSINESS_POS][2],
		2.5,
		BusinessData[id][e_BUSINESS_WORLD],
		BusinessData[id][e_BUSINESS_INTERIOR]
	);

	return true;
}

Business_Destroy(id)
{
	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return false;

	if (IsValidDynamicPickup(BusinessData[id][e_BUSINESS_ICON]))
		DestroyDynamicPickup(BusinessData[id][e_BUSINESS_ICON]);

	if (IsValidDynamic3DTextLabel(BusinessData[id][e_BUSINESS_LABEL]))
		DestroyDynamic3DTextLabel(BusinessData[id][e_BUSINESS_LABEL]);

	Pump_BusinessRemove(id);

	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
			continue;

		if (Business_Inside(i) != id)
			continue;

		Character_SetPos(
			i, 
			BusinessData[id][e_BUSINESS_POS][0],
			BusinessData[id][e_BUSINESS_POS][1],
			BusinessData[id][e_BUSINESS_POS][2],
			-1.0,
			BusinessData[id][e_BUSINESS_WORLD],
			BusinessData[id][e_BUSINESS_INTERIOR]
		);

		SendClientMessage(i, -1, "SERVER: A empresa que você estava foi destruida.");
	}

	Iter_Remove(Business, id);
	BusinessData[id] = BusinessData[MAX_BUSINESS];

	new query[64];
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Empresas` WHERE `ID` = %i;", BusinessData[id][e_BUSINESS_ID]);
	mysql_tquery (MYSQL_CUR_HANDLE, query);
	return true;
}

Business_Save(id)
{
	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return false;

	inline Business_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline Business_OnSaved,
		"UPDATE IGNORE `Empresas` SET \
		`Dono`=%i,\
		`Nome`='%e',\
		`Mensagem`='%e',\
		`Rádio`='%e',\
		`TaxaEntrada`=%i,\
		`Preço`=%i,\
		`Tipo`=%i,\
		`Cofre`=%i,\
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
		`Trancada`=%i,\
		`Aberta`=%i,\
		`Combustível`=%i,\
		`PreçoCombustível`=%i,\
		`Produtos`=%i,\
		`LimiteProdutos`=%i,\
		`PedidoQuantidade`=%i,\
		`PedidoCarga`=%i,\
		`PedidoPreço`=%i \
		WHERE `ID` = %i LIMIT 1;",
		BusinessData[id][e_BUSINESS_OWNER],
		BusinessData[id][e_BUSINESS_NAME],
		BusinessData[id][e_BUSINESS_MESSAGE],
		BusinessData[id][e_BUSINESS_RADIO],
		BusinessData[id][e_BUSINESS_ENTRANCE_FEE],
		BusinessData[id][e_BUSINESS_PRICE],
		BusinessData[id][e_BUSINESS_TYPE],
		BusinessData[id][e_BUSINESS_VAULT],
		BusinessData[id][e_BUSINESS_POS][0],
		BusinessData[id][e_BUSINESS_POS][1],
		BusinessData[id][e_BUSINESS_POS][2],
		BusinessData[id][e_BUSINESS_WORLD],
		BusinessData[id][e_BUSINESS_INTERIOR],
		BusinessData[id][e_BUSINESS_INSIDE_POS][0],
		BusinessData[id][e_BUSINESS_INSIDE_POS][1],
		BusinessData[id][e_BUSINESS_INSIDE_POS][2],
		BusinessData[id][e_BUSINESS_INSIDE_POS][3],
		BusinessData[id][e_BUSINESS_INSIDE_INTERIOR],
		BusinessData[id][e_BUSINESS_LOCKED],
		BusinessData[id][e_BUSINESS_OPEN],
		BusinessData[id][e_BUSINESS_FUEL],
		BusinessData[id][e_BUSINESS_FUEL_PRICE],
		BusinessData[id][e_BUSINESS_PRODUCTS],
		BusinessData[id][e_BUSINESS_PRODUCT_LIMIT],
		BusinessData[id][e_BUSINESS_REQUEST_QUANTITY],
		BusinessData[id][e_BUSINESS_REQUEST_CARGO],
		BusinessData[id][e_BUSINESS_REQUEST_PRICE],
		BusinessData[id][e_BUSINESS_ID]
	);

	return true;
}

Business_Inside(playerid)
{
	foreach (new i : Business)
	{
		if (BusinessData[i][e_BUSINESS_EXISTS] && GetPlayerVirtualWorld(playerid) == BusinessData[i][e_BUSINESS_INSIDE_WORLD] && GetPlayerInterior(playerid) == BusinessData[i][e_BUSINESS_INSIDE_INTERIOR])
		{
			return i;
		}
	}

	return -1;
}

Business_Nearest(playerid, Float:radius=2.5)
{
	new idx = -1;

	foreach (new i : Business)
	{
		if (GetPlayerInterior(playerid) != BusinessData[i][e_BUSINESS_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != BusinessData[i][e_BUSINESS_WORLD])
			continue;

		if (GetPlayerDistanceFromPoint(playerid, BusinessData[i][e_BUSINESS_POS][0], BusinessData[i][e_BUSINESS_POS][1], BusinessData[i][e_BUSINESS_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, BusinessData[i][e_BUSINESS_POS][0], BusinessData[i][e_BUSINESS_POS][1], BusinessData[i][e_BUSINESS_POS][2]);
		}
	}

	return idx;
}

Business_IsOwner(playerid, id)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return false;

	// Property Team em trabalho
	if (Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY, .sendMessage = false) && AccountData[playerid][e_ACCOUNT_ADMIN_DUTY])
		return true;

	// General
	if (BusinessData[id][e_BUSINESS_OWNER] == CharacterData[playerid][e_CHARACTER_ID])
		return true;

	return false;
}

Business_GetCount(ownerid)
{
	new count = 0;

	foreach (new i : Business)
	{
		if (!BusinessData[i][e_BUSINESS_EXISTS])
			continue;

		if (BusinessData[i][e_BUSINESS_OWNER] != ownerid)
			continue;

		count += 1;
	}

	return count;
}

Business_GetRealID(sqlid)
{
	foreach (new i : Business)
	{
		if (!BusinessData[i][e_BUSINESS_EXISTS])
			continue;

		if (BusinessData[i][e_BUSINESS_ID] != sqlid)
			continue;

		return i;
	}	

	return -1;
}

// Comandos
CMD:criarempresa(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

    static
		type,
	    price,
	    id;

	if (sscanf(params, "ii", type, price))
 	{
      	SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
   	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /criarempresa [tipo] [preço]");
      	
		new idx = 0, str[128] = "[Tipos]: ";

		for (new i = 0; i < MAX_BUSINESS_TYPE; i++)
		{
			strcat (str, va_return("%s%i. %s ", (!idx ? ("") : ("| ")), i, g_arrBusinessType[i]));

			idx += 1;

			if (!(idx % 5) || (i == (MAX_BUSINESS_TYPE - 1)))
			{
				SendClientMessage(playerid, COLOR_BEGE, str);

				str = "[Tipos]: ";
				idx = 0;
			}
		}

      	SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
    	return 1;
	}

	if (!(0 <= type < MAX_BUSINESS_TYPE))
	    return SendErrorMessage(playerid, "O tipo especificado é inválido. Os tipos são de 1 até 23.");

	id = Business_Create(playerid, type, price);

	if (id == -1)
	    return SendErrorMessage(playerid, "O servidor chegou ao limite máximo de empresas.");

	SendClientMessageEx(playerid, -1, "SERVER: Você criou com sucesso a empresa ID: %i.", id);
	return 1;
}

CMD:editarempresa(playerid, params[])//Game Admin + Property Team
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
	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /editarempresa [id] [opção]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opções]: localizacao, interior, nome, preco, estoque");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opções]: tipo, combustivel");
	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return 1;
	}

	if ((id < 0 || id >= MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de empresa inválido.");

	if (!strcmp(type, "localizacao", true))
	{
 		GetPlayerPos(playerid, BusinessData[id][e_BUSINESS_POS][0], BusinessData[id][e_BUSINESS_POS][1], BusinessData[id][e_BUSINESS_POS][2]);

		BusinessData[id][e_BUSINESS_INTERIOR] = GetPlayerInterior(playerid);
		BusinessData[id][e_BUSINESS_WORLD] = GetPlayerVirtualWorld(playerid);

		Business_Refresh(id);
		Business_Save(id);

       	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou a localização da empresa: %i.", AccountData[playerid][e_ACCOUNT_NAME], id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, BusinessData[id][e_BUSINESS_INSIDE_POS][0], BusinessData[id][e_BUSINESS_INSIDE_POS][1], BusinessData[id][e_BUSINESS_INSIDE_POS][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][e_BUSINESS_INSIDE_POS][3]);
		BusinessData[id][e_BUSINESS_INSIDE_INTERIOR] = GetPlayerInterior(playerid);

        foreach (new i : Player)
		{
			if (Business_Inside(i) == id && i != playerid)
			{
				Character_SetPos(
					i, 
					BusinessData[id][e_BUSINESS_INSIDE_POS][0], 
					BusinessData[id][e_BUSINESS_INSIDE_POS][1], 
					BusinessData[id][e_BUSINESS_INSIDE_POS][2], 
					BusinessData[id][e_BUSINESS_INSIDE_POS][3], 
					BusinessData[id][e_BUSINESS_WORLD], 
					BusinessData[id][e_BUSINESS_INTERIOR]
				);
			}
		}

		Business_Save(id);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o interior da empresa: %i.", AccountData[playerid][e_ACCOUNT_NAME], id);
	}
	else if (!strcmp(type, "preco", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	        return SendUsageMessage(playerid, "/editarempresa [id] [preço] [novo preço]");

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o preço da empresa: %i de %s para %s.", AccountData[playerid][e_ACCOUNT_NAME], id, FormatMoney(BusinessData[id][e_BUSINESS_PRICE]), FormatMoney(price));
	
	    BusinessData[id][e_BUSINESS_PRICE] = price;

	    Business_Refresh(id);
	    Business_Save(id);
	}
	else if (!strcmp(type, "estoque", true))
	{
	    new amount;

	    if (sscanf(string, "d", amount))
	        return SendUsageMessage(playerid, "/editarempresa [id] [estoque] [quantidade de produtos]");

	    if (amount < 0)
	    	return SendErrorMessage(playerid, "Não use números negativos.");

	    if (amount > BusinessData[id][e_BUSINESS_PRODUCT_LIMIT])
	    	return SendErrorMessage(playerid, "O estoque máximo é %i.", BusinessData[id][e_BUSINESS_PRODUCT_LIMIT]);

	    BusinessData[id][e_BUSINESS_PRODUCTS] = amount;

	    Business_Refresh(id);
	    Business_Save(id);

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o estoque da empresa: %i para %i produtos.", AccountData[playerid][e_ACCOUNT_NAME], id, amount);
	}
	else if (!strcmp(type, "nome", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendUsageMessage(playerid, "/editarempresa [id] [nome] [novo nome]");

	    format(BusinessData[id][e_BUSINESS_NAME], 32, name);

	    Business_Refresh(id);
	    Business_Save(id);

		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o nome da empresa: %i para \"%s\".", AccountData[playerid][e_ACCOUNT_NAME], id, name);
	}
	else if (!strcmp(type, "tipo", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	    {
	      	SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	   	 	SendClientMessage(playerid, COLOR_BEGE, "USE: /criarempresa [tipo] [preço]");
	      	
			new idx = 0, str[128] = "[Tipos]: ";

			for (new i = 0; i < MAX_BUSINESS_TYPE; i++)
			{
				strcat (str, va_return("%s%i. %s ", (!idx ? ("") : ("| ")), i, g_arrBusinessType[i]));

				idx += 1;

				if (!(idx % 5) || (i == (MAX_BUSINESS_TYPE - 1)))
				{
					SendClientMessage(playerid, COLOR_BEGE, str);

					str = "[Tipos]: ";
					idx = 0;
				}
			}

	      	SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	    	return 1;
		}

		if (!(0 <= typeint < MAX_BUSINESS_TYPE))
			return SendErrorMessage(playerid, "O tipo especificado deve estar entre 0 e "#MAX_BUSINESS_TYPE".");

        BusinessData[id][e_BUSINESS_TYPE] = typeint;

		Business_Refresh(id);
	    Business_Save(id);

	  	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s ajustou o tipo da empresa: %i para %i.", AccountData[playerid][e_ACCOUNT_NAME], id, typeint);
	}
	return 1;
}

CMD:destruirempresa(playerid, params[])
{
	if (!Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY))
		return false;

	static
	    id = 0;

	if (sscanf(params, "i", id))
	    return SendUsageMessage(playerid, "/destruirempresa [id da empresa]");

	if ((id < 0 || id >= MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
	    return SendErrorMessage(playerid, "Você especificou um ID de empresa inválido.");

	Business_Destroy(id);
	SendClientMessageEx(playerid, -1, "Você destruiu com sucesso a empresa ID: %i.", id);
	return 1;
}
