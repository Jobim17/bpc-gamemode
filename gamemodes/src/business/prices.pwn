/*
	ooooooooo.             o8o
	`888   `Y88.           `"'
	 888   .d88' oooo d8b oooo   .ooooo.   .ooooo.   .oooo.o
	 888ooo88P'  `888""8P `888  d88' `"Y8 d88' `88b d88(  "8
	 888          888      888  888       888ooo888 `"Y88b.
	 888          888      888  888   .o8 888    .o o.  )88b
	o888o        d888b    o888o `Y8bod8P' `Y8bod8P' 8""888P'
	
*/

// Vari�veis
static s_pBizEditPrice[MAX_PLAYERS] = {-1, ...};
static s_pBizEditItem[MAX_PLAYERS] = {-1, ...};

// Comandos
CMD:produtos(playerid)
{
	new id = Business_Inside(playerid);

	if (id != -1 && Business_IsOwner(playerid, id))
	{
		Business_PriceMenu(playerid, id);
	}
	else
	{
		SendErrorMessage(playerid, "Voc� n�o est� no interior da sua empresa.");
	}

	return true;
}

// Dialogs
Dialog:DIALOG_BIZ_PRICES(playerid, response, listitem, inputtext[])
{
	if (!response)
		return false;

	new id = s_pBizEditPrice[playerid], itemid;

	if (Business_Inside(playerid) != id || !Business_IsOwner(playerid, id))
		return SendErrorMessage(playerid, "Voc� n�o est� mais no interior desta empresa ou n�o � mais o dono.");

	if (BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_GAS_STATION && (!strcmp(inputtext, "Combust�vel") || !strcmp(inputtext, "Combustivel")))
	{
		Dialog_Show(playerid, DIALOG_BIZ_FUEL_PRICE, DIALOG_STYLE_INPUT, "Editando: Combust�vel", "Digite o pre�o em reais que ser� pago por cada litro de combust�vel:", "Confirmar", "<<");
	}
	else
	{
		itemid = Item_GetIDName(inputtext);

		if (itemid == -1)
		{
			Business_PriceMenu(playerid, id);
			return false;
		}

		s_pBizEditItem[playerid] = itemid;
		Dialog_Show(playerid, DIALOG_BIZ_ITEM_PRICE, DIALOG_STYLE_INPUT, va_return("Editando: %s", Item_GetName(itemid)), "Digite o pre�o em reais que ser� pago pelo produto:", "Confirmar", "<<");
	}

	return true;
}

Dialog:DIALOG_BIZ_FUEL_PRICE(playerid, response, listitem, inputtext[])
{
	new id = s_pBizEditPrice[playerid], price;

	if (Business_Inside(playerid) != id || !Business_IsOwner(playerid, id))
		return SendErrorMessage(playerid, "Voc� n�o est� mais no interior desta empresa ou n�o � mais o dono.");

	if (!response)
		return Business_PriceMenu(playerid, id);

	if (BusinessData[id][e_BUSINESS_TYPE] != BUSINESS_TYPE_GAS_STATION)
	{
		Business_PriceMenu(playerid, id);
		return SendErrorMessage(playerid, "O pre�o do combust�vel n�o � comp�tivel para esta empresa.");
	}

	if (sscanf(inputtext, "i", price) || !(0 <= price <= 20))
	{
		Dialog_Show(playerid, DIALOG_BIZ_FUEL_PRICE, DIALOG_STYLE_INPUT, "Editando: Combust�vel", "Erro: O pre�o deve ser de 0 a 20.\nDigite o pre�o em reais que ser� pago por cada litro de combust�vel:", "Confirmar", "<<");
		return true;
	}

	if (price <= 0)
	{
		SendErrorMessage(playerid, "Voc� desativou a compra de combust�vel no seu posto de combust�vel.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "Seus clientes pagar�o %s pelo litro de combust�vel.", FormatMoney(price));
	}

	BusinessData[id][e_BUSINESS_FUEL_PRICE] = price;
	Business_Save(id);
	Business_PriceMenu(playerid, id);
	Pump_BusinessRefresh(id);
	return true;
}

Dialog:DIALOG_BIZ_ITEM_PRICE(playerid, response, listitem, inputtext[])
{
	new id = s_pBizEditPrice[playerid], item = s_pBizEditItem[playerid], price;

	if (Business_Inside(playerid) != id || !Business_IsOwner(playerid, id))
		return SendErrorMessage(playerid, "Voc� n�o est� mais no interior desta empresa ou n�o � mais o dono.");

	if (Item_GetRealID(item) == -1)
	{
		SendErrorMessage(playerid, "O produto que voc� estava editando n�o � mais v�lido.");
		return Business_PriceMenu(playerid, id);
	}

	if (!response)
		return Business_PriceMenu(playerid, id);

	if (sscanf(inputtext, "i", price) || !(0 <= price <= 3000))
	{
		Dialog_Show(playerid, DIALOG_BIZ_ITEM_PRICE, DIALOG_STYLE_INPUT, va_return("Editando: %s", Item_GetName(item)), "Erro: O pre�o deve ser de 0 a 3000.\nDigite o pre�o em reais que ser� pago pelo produto:", "Confirmar", "<<");
		return true;
	}

	inline BizPrice_Update()
	{
		if (cache_affected_rows())
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Seus clientes pagar�o %s pelo item %s.", FormatMoney(price), Item_GetName(item));
		}
		else
		{
			SendErrorMessage(playerid, "N�o foi poss�vel atualizar o pre�o do item %s.", Item_GetName(item));
		}

		Business_PriceMenu(playerid, id);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline BizPrice_Update, "INSERT IGNORE INTO `EmpresaPre�os` (`Empresa`, `Item`, `Pre�o`) VALUES (%i, %i, %i) ON DUPLICATE KEY UPDATE `Pre�o` = VALUES(`Pre�o`);", BusinessData[id][e_BUSINESS_ID], item, price, price);
	return true;
}

// Functions
Business_GetItemPrice(id, itemid)
{
	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return 0;

	if (Item_GetRealID(itemid) == -1)
		return 0;

	new query[128], price = 0;
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "SELECT `Pre�o` FROM `EmpresaPre�os` WHERE `Empresa` = %i AND `Item` = %i LIMIT 1;", BusinessData[id][e_BUSINESS_ID], itemid);
	mysql_query (MYSQL_CUR_HANDLE, query);

	if (cache_num_rows())
	{
		cache_get_value_name_int(0, "Pre�o", price);
	}

	return price;
}

Business_PriceMenu(playerid, bizid)
{
	if (!(0 <= bizid < MAX_BUSINESS) || !BusinessData[bizid][e_BUSINESS_EXISTS])
		return 0;

	// Vari�veis
	new dialog[1024], title[128];

	format (dialog, sizeof dialog, "Produto\tPre�o ($)");
	format (title, sizeof title, "Editar cat�logo: %s", BusinessData[bizid][e_BUSINESS_NAME]);

	// Posto de Gasolina
	if (BusinessData[bizid][e_BUSINESS_TYPE] == BUSINESS_TYPE_GAS_STATION)
	{
		if (BusinessData[bizid][e_BUSINESS_FUEL_PRICE] <= 0)
		{
			strcat (dialog, "\nCombust�vel\t{BBBBBB}Indefinido");
		}
		else
		{
			strcat (dialog, va_return("\nCombust�vel\t{77DC67}%s {BBBBBB}por litro", FormatMoney(BusinessData[bizid][e_BUSINESS_FUEL_PRICE])));
		}
	}

	// Demais itens
	inline BizPrices_Display()
	{
		new rows = cache_num_rows(), itemid, price;

		for (new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "Item", itemid);
			cache_get_value_name_int(i, "Pre�o", price);

			if ((itemid = Item_GetRealID(itemid)) != -1)
			{
				strcat (dialog, "\n");
				strcat (dialog, ItemData[itemid][e_ITEM_NAME]);
				strcat (dialog, "\t");

				if (price < 1)
				{
					strcat (dialog, "{BBBBBB}Indefinido");
				}
				else
				{
					strcat (dialog, "{77DC67}");
					strcat (dialog, FormatMoney(price));
				}
			}
		}

		if (strlen(dialog) == 18)
			return SendErrorMessage(playerid, "Nenhum item encontrado no cat�logo.");

		s_pBizEditPrice[playerid] = bizid;
		Dialog_Show(playerid, DIALOG_BIZ_PRICES, DIALOG_STYLE_TABLIST_HEADERS, title, dialog, "Editar", "Fechar");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline BizPrices_Display, "SELECT `Item`, COALESCE((SELECT `Pre�o` FROM `EmpresaPre�os` WHERE `Item` = `EmpresaItens`.`Item` AND `Empresa` = %i), 0) AS `Pre�o` FROM `EmpresaItens` WHERE `Tipo` = %i;", BusinessData[bizid][e_BUSINESS_ID], BusinessData[bizid][e_BUSINESS_TYPE]);
	return true;
}