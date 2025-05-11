/*
	  .oooooo.
	 d8P'  `Y8b
	888           .ooooo.  oooo d8b  .ooooo.
	888          d88' `88b `888""8P d88' `88b
	888          888   888  888     888ooo888
	`88b    ooo  888   888  888     888    .o
	 `Y8bood8P'  `Y8bod8P' d888b    `Y8bod8P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Dialogs
Dialog:DIALOG_FNTR_MAIN(playerid, response, listitem, inputtext[])
{
	if (!response)
		return false;

	switch (listitem)
	{
		case 0: // Comprar Mob�lia
		{
			FurnitureShop_ShowCategories(playerid);
		}

		case 1: // Invent�rio de mob�lias
		{
			FurnitureInv_ShowList(playerid);
		}

		case 2: // Informa��es
		{
			Furniture_ShowInformations(playerid);
		}

		default: PC_EmulateCommand(playerid, "/mobilia");
	}

	return true;
}

Dialog:DIALOG_FNTR_INFO(playerid, response, listitem, inputtext[])
{
	PC_EmulateCommand(playerid, "/mobilia");
	return true;
}

// Functions
Furniture_GetPlayerType(playerid, &type, &id)
{
	static retId;

	if ((retId = House_Inside(playerid)) != -1)
	{
		id = retId;
		type = FURNITURE_LINK_TYPE_HOUSE;
	}
	else if ((retId = Business_Inside(playerid)) != -1)
	{
		id = retId;
		type = FURNITURE_LINK_TYPE_BUSINESS;
	}
	else
	{
		id = -1;
		type = -1;
 	}

	return true;
}

Furniture_ShowMenu(playerid)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return true;

	static type, id;
	Furniture_GetPlayerType(playerid, type, id);

	if (type == -1 || id == -1)
		return SendErrorMessage(playerid, "Voc� n�o est� dentro de uma casa, empresa ou garagem.");

	if (type == FURNITURE_LINK_TYPE_HOUSE && !House_IsOwner(playerid, id))
		return SendErrorMessage(playerid, "Voc� n�o possui permiss�o para mobiliar esta casa.");

	if (type == FURNITURE_LINK_TYPE_BUSINESS && !Business_IsOwner(playerid, id))
		return SendErrorMessage(playerid, "Voc� n�o possui permiss�o para mobiliar esta empresa.");

	Dialog_Show(playerid, DIALOG_FNTR_MAIN, DIALOG_STYLE_LIST, "Mob�lia", "Comprar mob�lia\nInvent�rio de mob�lias\nInforma��es", "Selecionar", "Cancelar");
	return true;
}

Furniture_ShowInformations(playerid)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return true;

	static type, id, idx, count;
	Furniture_GetPlayerType(playerid, type, idx);

	if (type == -1 || idx == -1)
		return SendErrorMessage(playerid, "Voc� n�o est� dentro de uma casa, empresa ou garagem.");

	switch (type)
	{
		case FURNITURE_LINK_TYPE_HOUSE: id = HouseData[idx][e_HOUSE_ID];
		case FURNITURE_LINK_TYPE_BUSINESS: id = BusinessData[idx][e_BUSINESS_ID];
		default: return SendErrorMessage(playerid, "N�o foi poss�vel detectar o seu interior.");
	}

	count = Furniture_GetCount(type, id);

	new dialog[1024];
	dialog = "{BBBBBB}Informa��es:\n{FFFFFF}";

	// Type
	if (type == FURNITURE_LINK_TYPE_HOUSE)
	{
		strcat (dialog, "{BBBBBB}[Casa] {FFFFFF}");
		strcat (dialog, House_GetAddress(idx));
	}
	else if (type == FURNITURE_LINK_TYPE_BUSINESS)
	{
		strcat (dialog, "{BBBBBB}[Empresa] {FFFFFF}");
		strcat (dialog, BusinessData[idx][e_BUSINESS_NAME]);
	}

	// Slots
	strcat(dialog, va_return("\nMob�lia: %i / %i", count, Furniture_GetMaxSlots(playerid)));

	if (count >= Furniture_GetMaxSlots(playerid))
	{
		strcat (dialog, "\n{FF5555}Limite atingido, compra bloqueada at� regulariza��o.");
	}

	// Permissions
	strcat (dialog, "\n\n{BBBBBB}Permiss�es:\n{FFFFFF}Nenhum personagem autorizado.");
	Dialog_Show(playerid, DIALOG_FNTR_INFO, DIALOG_STYLE_MSGBOX, "Mob�lia: Informa��es", dialog, "<<", "");
	return true;
}

Furniture_Check(playerid, id = -1, bool:checkid = true, &type=-1, &idx=-1)
{
	Furniture_GetPlayerType(playerid, type, idx);

	if (type == -1 || idx == -1)
	{
		SendErrorMessage(playerid, "Voc� n�o est� no interior de uma casa, empresa ou garagem.");
		return false;
	}

	if (type == FURNITURE_LINK_TYPE_HOUSE && !House_IsOwner(playerid, idx))
	{
		SendErrorMessage(playerid, "Voc� n�o tem permiss�o para mobiliar esta casa.");
		return false;
	}

	if (type == FURNITURE_LINK_TYPE_BUSINESS && !Business_IsOwner(playerid, idx))
	{
		SendErrorMessage(playerid, "Voc� n�o tem permiss�o para mobiliar esta empresa.");
		return false;
	}

	if (checkid && (id == -1 || !IsValidDynamicObject(FurnitureData[id][e_FURNITURE_OBJECT]) || !FurnitureData[id][e_FURNITURE_EXISTS] || GetPlayerVirtualWorld(playerid) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, FurnitureData[id][e_FURNITURE_OBJECT], E_STREAMER_WORLD_ID) || GetPlayerInterior(playerid) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, FurnitureData[id][e_FURNITURE_OBJECT], E_STREAMER_INTERIOR_ID)))
	{
		SendErrorMessage(playerid, "Esta mob�lia n�o � mais v�lida.");
		return false;
	}

	return true;
}

// Comandos
CMD:mobilia(playerid)
{
	Furniture_ShowMenu(playerid);
	return true;
}