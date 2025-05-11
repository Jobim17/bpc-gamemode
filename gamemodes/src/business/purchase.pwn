/*
	ooooooooo.                                  oooo
	`888   `Y88.                                `888
	 888   .d88' oooo  oooo  oooo d8b  .ooooo.   888 .oo.    .oooo.    .oooo.o  .ooooo.
	 888ooo88P'  `888  `888  `888""8P d88' `"Y8  888P"Y88b  `P  )88b  d88(  "8 d88' `88b
	 888          888   888   888     888        888   888   .oP"888  `"Y88b.  888ooo888
	 888          888   888   888     888   .o8  888   888  d8(  888  o.  )88b 888    .o
	o888o         `V88V"V8P' d888b    `Y8bod8P' o888o o888o `Y888""8o 8""888P' `Y8bod8P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Dialogs
Dialog:DIALOG_BIZ_BUY(playerid, response, listitem, inputtext[])
{
	if (!response) return true;

	new 
		biz = Business_Inside(playerid), 
		item = Item_GetIDName(inputtext),
		price;

	if (biz == -1)
		return SendErrorMessage(playerid, "Você não está em uma empresa.");

	if (item == -1)
		return SendErrorMessage(playerid, "O item %s não é válido.", inputtext);

	if (!BusinessData[biz][e_BUSINESS_PRODUCTS])
		return SendErrorMessage(playerid, "Esta empresa não tem produtos para atendê-lo.");

	price = Business_GetItemPrice(biz, item);

	if (price <= 0)
		return SendErrorMessage(playerid, "O item está indisponível.");

	if (Character_GetMoney(playerid) < price)
		return SendErrorMessage(playerid, "Você não tem fundos suficiente.");

	if (!Inventory_Add(playerid, item, 1))
		return false;

	BusinessData[biz][e_BUSINESS_PRODUCTS] -= 1;
	BusinessData[biz][e_BUSINESS_VAULT] += price;
	Business_Save(biz);

	Character_GiveMoney(playerid, -price);
	SendNearbyMessage(playerid, COLOR_PURPLE, 30.0, "* %s entrega %s ao balconista e recebe um(a) %s.", Character_GetName(playerid), FormatMoney(price), Item_GetName(item));
	return true;
}

// Functions
Business_PurchaseMenu(playerid, id)
{
	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return false;

	new dialog[1024];
	dialog = "Produto\tPreço ($)";

	inline Business_Products()
	{
		new rows = cache_num_rows(), item, price;

		if (!rows)
			return SendErrorMessage(playerid, "Nenhum produto foi encontrado.");

		if (BusinessData[id][e_BUSINESS_LOCKED])
			return SendErrorMessage(playerid, "Esta empresa está fechada.");

		if (!BusinessData[id][e_BUSINESS_PRODUCTS])
			return SendErrorMessage(playerid, "Esta empresa não possui produtos para atendê-lo.");

		for (new i = 0; i < rows; i++)
		{
			strcat (dialog, "\n");

			cache_get_value_name_int(i, "Item", item);
			cache_get_value_name_int(i, "Preço", price);

			strcat (dialog, Item_GetName(item));
			strcat (dialog, "\t");

			if (price <= 0)
			{
				strcat (dialog, "{BBBBBB}Indisponível");
			}
			else
			{
				strcat (dialog, va_return("{%s}%s", ((price > Character_GetMoney(playerid) || !BusinessData[id][e_BUSINESS_PRODUCTS]) ? ("FF6347") : ("77DC67")), FormatMoney(price)));
			}
		}

		Dialog_Show(playerid, DIALOG_BIZ_BUY, DIALOG_STYLE_TABLIST_HEADERS, BusinessData[id][e_BUSINESS_NAME], dialog, "Comprar", "Fechar");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Business_Products, "SELECT `Item`, COALESCE((SELECT `Preço` FROM `EmpresaPreços` WHERE `Item` = `EmpresaItens`.`Item` AND `Empresa` = %i), 0) AS `Preço` FROM `EmpresaItens` WHERE `Tipo` = %i;", BusinessData[id][e_BUSINESS_ID], BusinessData[id][e_BUSINESS_TYPE]);
	return true;
}