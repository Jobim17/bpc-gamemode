/*
	ooooo                                                   .
	`888'                                                 .o8
	 888  ooo. .oo.   oooo    ooo  .ooooo.  ooo. .oo.   .o888oo  .ooooo.  oooo d8b oooo    ooo
	 888  `888P"Y88b   `88.  .8'  d88' `88b `888P"Y88b    888   d88' `88b `888""8P  `88.  .8'
	 888   888   888    `88..8'   888ooo888  888   888    888   888   888  888       `88..8'
	 888   888   888     `888'    888    .o  888   888    888 . 888   888  888        `888'
	o888o o888o o888o     `8'     `Y8bod8P' o888o o888o   "888" `Y8bod8P' d888b        .8'
	                                                                               .o..P'
	                                                                               `Y8P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Functions
Inventory_Show(playerid, target)
{
	if (!IsPlayerLogged(playerid) || !IsPlayerLogged(target))
		return false;

	if (!Inventory_Count(target) && target == playerid)
		return SendErrorMessage(playerid, "Você não pode abrir um inventário vazio.");

	new 
		dialog[1024], 
		title[128],
		id
	;

	format (title, sizeof title, "Inventário de %s (%i/%i)", Character_GetName(target), Inventory_Count(target), Inventory_MaxSlots(target));

	if (target != playerid)
	{
		new money = Character_GetMoney(target);

		strcat (dialog, "1212\tDinheiro~n~");

		if (money <= MAX_ROBBERY_MONEY)
		{
			strcat (dialog, va_return("~g~%s\n", FormatMoney(money)));
		}
		else if (money <= 0)
		{
			strcat (dialog, va_return("~r~%s\n", FormatMoney(money)));
		}
		else
		{
			strcat (dialog, va_return("~g~%s\n", FormatMoney(money)));
		}

		strcat (dialog, "\n");
	}

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (!InventoryData[target][i][e_INVENTORY_EXISTS] || !InventoryData[target][i][e_INVENTORY_ITEM_AMOUNT])
			continue;

		id = Item_GetRealID(InventoryData[target][i][e_INVENTORY_ITEM]);

		if (id == -1)
			continue;

		// Model
		strcat (dialog, va_return("%i\t", ItemData[id][e_ITEM_MODEL]));

		// Name
		strcat (dialog, va_return("%.10s", ItemData[id][e_ITEM_NAME]));

		if (strlen(ItemData[id][e_ITEM_NAME]) > 10)
		{
			strcat (dialog, "...");
		}

		// Cigarretes
		if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_DRUGS && ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_PACKAGE && InventoryData[target][i][e_INVENTORY_CIGARRETES] < ItemData[id][e_ITEM_CASE_CIGARRETES])
		{
			strcat(
				dialog, 
				va_return(
					"~n~~n~~n~~n~~n~~y~%i cigarro%s~n~~w~%i", 
					ItemData[id][e_ITEM_CASE_CIGARRETES] - InventoryData[target][i][e_INVENTORY_CIGARRETES],
					(ItemData[id][e_ITEM_CASE_CIGARRETES] - InventoryData[target][i][e_INVENTORY_CIGARRETES]) <= 1 ? ("") : ("s"),
					i
				)
			);
		}

		// Itens gerais
		else
		{
			strcat(
				dialog, 
				va_return(
					"~n~~n~~n~~n~~n~~y~(%i)~n~~w~%d", 
					InventoryData[target][i][e_INVENTORY_ITEM_AMOUNT],
					i
				)
			);
		}

		// Break line
		strcat (dialog, "\n");
	}	

	Dialog_Show(playerid, DIALOG_INVENTORY, DIALOG_STYLE_PREVMODEL, title, dialog, "Selecionar", "Fechar");
	return true;
}

// Comandos
alias:i("inv", "inventario")
CMD:i(playerid)
{
	Inventory_Show(playerid, playerid);
	return true;
}