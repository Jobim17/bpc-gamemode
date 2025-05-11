/*
	 .oooooo..o oooo
	d8P'    `Y8 `888
	Y88bo.       888 .oo.    .ooooo.  oo.ooooo.
	 `"Y8888o.   888P"Y88b  d88' `88b  888' `88b
	     `"Y88b  888   888  888   888  888   888
	oo     .d8P  888   888  888   888  888   888
	8""88888P'  o888o o888o `Y8bod8P'  888bod8P'
	                                   888
	                                  o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define MAX_LISTED_FURNITURE 400
#define MAX_SEARCH_FURNITURE 36

// Variáveis
static
	s_pFurnitureCategory[MAX_PLAYERS] = {-1, ...},
	s_pFurnitureSubCategory[MAX_PLAYERS] = {-1, ...},
	s_pFurnitureListed[MAX_PLAYERS][MAX_LISTED_FURNITURE],
	s_pFurnitureSelectedIndex[MAX_PLAYERS] = {-1, ...},
	s_pFurnitureObject[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...};

// Callbacks
hook OnPlayerConnect(playerid)
{
	s_pFurnitureCategory[playerid] = -1;
	s_pFurnitureSubCategory[playerid] = -1;
	s_pFurnitureSelectedIndex[playerid] = -1;

	if (IsValidDynamicObject(s_pFurnitureObject[playerid]))
	{
		DestroyDynamicObject(s_pFurnitureObject[playerid]);
	}

	s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
	return true;
}

hook OnPlayerEditDynamicObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (objectid != s_pFurnitureObject[playerid] || s_pFurnitureSelectedIndex[playerid] == -1)
	{
		s_pFurnitureSelectedIndex[playerid] = -1;
		return true;
	}

	static type, prop, idx, id;
	Furniture_GetPlayerType(playerid, type, idx);

	if (type == -1 || idx == -1)
	{
		DestroyDynamicObject(s_pFurnitureObject[playerid]);
		s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
		return SendErrorMessage(playerid, "Você não está dentro de uma casa, empresa ou garagem.");
	}

	switch (type)
	{
		case FURNITURE_LINK_TYPE_HOUSE: prop = HouseData[idx][e_HOUSE_ID];
		case FURNITURE_LINK_TYPE_BUSINESS: prop = BusinessData[idx][e_BUSINESS_ID];
		default: 
		{
			DestroyDynamicObject(s_pFurnitureObject[playerid]);
			s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
			return SendErrorMessage(playerid, "Não foi possível detectar o seu interior.");
		}
	}

	id = s_pFurnitureSelectedIndex[playerid];

	// Confirm
	if (response == EDIT_RESPONSE_FINAL)
	{
		if (Furniture_GetCount(type, prop) >= Furniture_GetMaxSlots(playerid))
		{
			if (type == FURNITURE_LINK_TYPE_HOUSE) SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta casa.", Furniture_GetMaxSlots(playerid));
			else if (type == FURNITURE_LINK_TYPE_BUSINESS) SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta empresa.", Furniture_GetMaxSlots(playerid));
			else SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta garagem.", Furniture_GetMaxSlots(playerid));

			DestroyDynamicObject(s_pFurnitureObject[playerid]);
			s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
			return false;
		}

		if (Character_GetMoney(playerid) < g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE])
		{
			DestroyDynamicObject(s_pFurnitureObject[playerid]);
			s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
			return SendErrorMessage(playerid, "Você não tem fundos sucficiente para comprar esta mobília.");
		}

		new furniture = Furniture_Create(
			g_aFurnitureShop[id][e_FURNITURE_SHOP_NAME], 
			g_aFurnitureShop[id][e_FURNITURE_SHOP_MODEL], 
			g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE],
			type,
			idx,
			x,
			y,
			z,
			rx,
			ry,
			rz
		);

		if (furniture == -1)
		{
			SendErrorMessage(playerid, "O servidor atingiu o limite de mobílias.");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "A mobília %s foi adquirida com sucesso por %s. Ela foi adicionada a seu inventário de mobílias.", g_aFurnitureShop[id][e_FURNITURE_SHOP_NAME], FormatMoney(g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE]));
			Character_GiveMoney(playerid, -g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE]);
		}

		DestroyDynamicObject(s_pFurnitureObject[playerid]);
		s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
		return true;
	}

	// Cancel
	if (response == EDIT_RESPONSE_CANCEL)
	{
		SendErrorMessage(playerid, "Você cancelou a compra da mobília.");
		DestroyDynamicObject(s_pFurnitureObject[playerid]);
		s_pFurnitureObject[playerid] = INVALID_STREAMER_ID;
		return true;
	}
	return true;
}

// Dialogs
Dialog:DIALOG_FNTR_SHOP_CAT(playerid, response, listitem, inputtext[])
{
	if (!response)
		return PC_EmulateCommand(playerid, "/mobilia");

	if (listitem == 0)
	{
		Dialog_Show(playerid, DIALOG_FNTR_SHOP_FIND, DIALOG_STYLE_INPUT, "Buscar mobilia pelo nome:", "Digite o nome, parte do nome ou modelo da mobília que você deseja pesquisar.\nLembre-se que o sistema irá retornar apenas "#MAX_SEARCH_FURNITURE" resultados compatíveis.", "Buscar", "<<");
		return true;
	}

	if ((0 <= (listitem - 1) <= MAX_FURNITURE_CATEGORY))
	{
		FurnitureShop_ShowSubCategories(playerid, listitem - 1);
	}
	else
	{
		FurnitureShop_ShowCategories(playerid);
	}

	return true;
}

Dialog:DIALOG_FNTR_SHOP_SUBCAT(playerid, response, listitem, inputtext[])
{
	if (!response)
		return FurnitureShop_ShowCategories(playerid);

	new idx = -1, count = 0;

	for (new i = 0; i < MAX_FURNITURE_SUBCAT; i++)
	{
		if (g_aFurnitureSubCategory[i][e_FURNITURE_SC_CATEGORY] != s_pFurnitureCategory[playerid])
			continue;

		if (count == listitem)
		{
			idx = i;
			break;
		}
		else 
			count += 1;
	}

	if (idx != -1)
	{
		FurnitureShop_ShowItems(playerid, idx);
	}
	else
	{
		FurnitureShop_ShowCategories(playerid);
	}
	return true;
}

Dialog:DIALOG_FNTR_SHOP_LIST(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		if (s_pFurnitureCategory[playerid] == -1)
		{
			FurnitureShop_ShowCategories(playerid);
		}
		else
		{
			FurnitureShop_ShowSubCategories(playerid, s_pFurnitureCategory[playerid]);
		}

		return true;
	}

	static type, prop, idx, id;

	if (!Furniture_Check(playerid, -1, false, type, idx))
		return false;

	switch (type)
	{
		case FURNITURE_LINK_TYPE_HOUSE: prop = HouseData[idx][e_HOUSE_ID];
		case FURNITURE_LINK_TYPE_BUSINESS: prop = BusinessData[idx][e_BUSINESS_ID];
		default: return SendErrorMessage(playerid, "Não foi possível detectar o seu interior.");
	}

	if (Furniture_GetCount(type, prop) >= Furniture_GetMaxSlots(playerid))
	{
		if (type == FURNITURE_LINK_TYPE_HOUSE)
			SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta casa.", Furniture_GetMaxSlots(playerid));
		else if (type == FURNITURE_LINK_TYPE_BUSINESS)
			SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta empresa.", Furniture_GetMaxSlots(playerid));
		else
			SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta garagem.", Furniture_GetMaxSlots(playerid));

		return false;
	}

	// Check
	id = s_pFurnitureListed[playerid][listitem];

	if ((0 <= id < sizeof g_aFurnitureShop) && id != -1)
	{
		s_pFurnitureSelectedIndex[playerid] = id;

		// Format dialog
		new dialog[1024];

		format (dialog, sizeof dialog, 
			"{FFFF00}%016s\t\t{FFFFFF}%s\n\
			{FFFF00}%016s\t{FFFFFF}%s\n\
			{FFFF00}%018s\t\t{FFFFFF}%s\n\
			{FFFF00}%018s\t\t{FFFFFF}%s\n\n\
			- Lembre-se que você irá 'provar' a mobília antes de adquiri-la.\n\
			- Se caso você não quiser, basta apenas apertar a tecla ESC ou o botão de cancelar.\n",
			"Categoria:", g_aFurnitureCategory[ g_aFurnitureShop[id][e_FURNITURE_SHOP_CATEGORY] ],
			"Sub-categoria:", g_aFurnitureSubCategory[ g_aFurnitureShop[id][e_FURNITURE_SHOP_SUBCATEGORY] ][e_FURNITURE_SC_NAME],
			"Mobília:", g_aFurnitureShop[id][e_FURNITURE_SHOP_NAME],
			"Preço:", FormatMoney(g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE])
		);

		Dialog_Show(playerid, DIALOG_FNTR_SHOP_CONFIRM, DIALOG_STYLE_MSGBOX, "Você tem certeza?", dialog, "Confirmar", "<<");
	}
	return true;
}

Dialog:DIALOG_FNTR_SHOP_CONFIRM(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		if (s_pFurnitureSubCategory[playerid] == -1)
		{
			FurnitureShop_ShowCategories(playerid);
		}
		else
		{
			FurnitureShop_ShowSubCategories(playerid, s_pFurnitureCategory[playerid]);
		}

		return true;
	}

	static type, prop, idx, id;

	if (!Furniture_Check(playerid, -1, false, type, idx))
		return false;

	switch (type)
	{
		case FURNITURE_LINK_TYPE_HOUSE: prop = HouseData[idx][e_HOUSE_ID];
		case FURNITURE_LINK_TYPE_BUSINESS: prop = BusinessData[idx][e_BUSINESS_ID];
		default: return SendErrorMessage(playerid, "Não foi possível detectar o seu interior.");
	}

	if (Furniture_GetCount(type, prop) >= Furniture_GetMaxSlots(playerid))
	{
		if (type == FURNITURE_LINK_TYPE_HOUSE)
			SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta casa.", Furniture_GetMaxSlots(playerid));
		else if (type == FURNITURE_LINK_TYPE_BUSINESS)
			SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta empresa.", Furniture_GetMaxSlots(playerid));
		else
			SendErrorMessage(playerid, "Você atingiu o limite de %i mobílias nesta garagem.", Furniture_GetMaxSlots(playerid));

		return false;
	}

	id = s_pFurnitureSelectedIndex[playerid];

	if (0 <= id < sizeof g_aFurnitureShop)
	{
		if (Character_GetMoney(playerid) < g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE])
			return SendErrorMessage(playerid, "Você não tem fundos suficiente para comprar esta mobília.");

		ShowPlayerFooter(playerid, FOOTER_STYLE_0, 5000, "~y~Você está prestes a adquirir um(a) ~w~%s ~y~por ~g~%s~y~. ~n~Para finalizar a compra aperte no disquete. Caso queira cancelar aperte ~r~ESC~y~ no seu teclado.", g_aFurnitureShop[id][e_FURNITURE_SHOP_NAME], FormatMoney(g_aFurnitureShop[id][e_FURNITURE_SHOP_PRICE]));
	
		new Float:x, Float:y, Float:z, Float:angle;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		x += (1.0 * floatsin(-angle, degrees));
		y += (1.0 * floatcos(-angle, degrees));

		if (IsValidDynamicObject(s_pFurnitureObject[playerid]))
		{
			DestroyDynamicObject(s_pFurnitureObject[playerid]);
		}

		s_pFurnitureObject[playerid] = CreateDynamicObject(
			g_aFurnitureShop[id][e_FURNITURE_SHOP_MODEL], 
			x,
			y,
			z, 
			0.0,
			0.0,
			0.0, 
			GetPlayerVirtualWorld(playerid), 
			GetPlayerInterior(playerid), 
			playerid
		);

		EditDynamicObject(playerid, s_pFurnitureObject[playerid]);
	}	

	return true;
}

Dialog:DIALOG_FNTR_SHOP_FIND(playerid, response, listitem, inputtext[])
{
	if (!response)
		return FurnitureShop_ShowCategories(playerid);

	if (strlen(inputtext) < 3 && !IsNumeric(inputtext) || strlen(inputtext) < 1 && IsNumeric(inputtext))
		return Dialog_Show(playerid, DIALOG_FNTR_SHOP_FIND, DIALOG_STYLE_INPUT, "Buscar mobilia pelo nome/modelo:", "Erro: Você não pode fazer uma pesquisa em branco, se não for por modelo é necessário 3 caracteres.\nDigite o nome, parte do nome ou modelo da mobília que você deseja pesquisar.\nLembre-se que o sistema irá retornar apenas "#MAX_SEARCH_FURNITURE" resultados compatíveis.", "Buscar", "<<");
	
	FurnitureShop_Search(playerid, inputtext);
	return true;	
}

// Functions
FurnitureShop_ShowCategories(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	new dialog[MAX_FURNITURE_CATEGORY * 16 + 32 + 8 + 1] = "{FFFF00}Buscar mobília pelo nome/modelo{FFFFFF}";

	for (new i = 0; i < MAX_FURNITURE_CATEGORY; i++)
	{
		strcat (dialog, "\n");
		strcat (dialog, g_aFurnitureCategory[i]);
	}

	Dialog_Show(playerid, DIALOG_FNTR_SHOP_CAT, DIALOG_STYLE_LIST, "Selecione uma categoria:", dialog, "Selecionar", "<<");
	return true;
}

FurnitureShop_ShowSubCategories(playerid, category)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!(0 <= category < MAX_FURNITURE_CATEGORY))
		return false;

	new dialog[MAX_FURNITURE_SUBCAT * 32], title[32 + 1];
	format (title, sizeof title, "%s:", g_aFurnitureCategory[category]);

	for (new i = 0; i < MAX_FURNITURE_SUBCAT; i++)
	{
		if (g_aFurnitureSubCategory[i][e_FURNITURE_SC_CATEGORY] != category)
			continue;

		strcat (dialog, i > 0 ? ("\n") : (""));
		strcat (dialog, g_aFurnitureSubCategory[i][e_FURNITURE_SC_NAME]);
	}

	s_pFurnitureCategory[playerid] = category;
	Dialog_Show(playerid, DIALOG_FNTR_SHOP_SUBCAT, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	return true;
}

FurnitureShop_ShowItems(playerid, subcategory)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!(0 <= subcategory < MAX_FURNITURE_SUBCAT))
		return false;

	new dialog[4096], title[32], name[64], count;
	format (title, sizeof title, "%s:", g_aFurnitureSubCategory[subcategory][e_FURNITURE_SC_NAME]);

	for (new i = 0; i < sizeof g_aFurnitureShop; i++)
	{
		if (g_aFurnitureShop[i][e_FURNITURE_SHOP_SUBCATEGORY] != subcategory || g_aFurnitureShop[i][e_FURNITURE_SHOP_CATEGORY] != s_pFurnitureCategory[playerid])
		{
			if (count) break;
			else continue;
		}

		format (name, sizeof name, g_aFurnitureShop[i][e_FURNITURE_SHOP_NAME]);
		strcat(dialog, va_return("\n%i(0.0, 0.0, 180.0)\t~%s~%s (%s)", g_aFurnitureShop[i][e_FURNITURE_SHOP_MODEL], g_aFurnitureShop[i][e_FURNITURE_SHOP_PRICE] < Character_GetMoney(playerid) ? ("g") : ("r"), name, FormatMoney(g_aFurnitureShop[i][e_FURNITURE_SHOP_PRICE])));
		s_pFurnitureListed[playerid][count] = i;
		count += 1;
	}

	if (!count)
	{
		SendErrorMessage(playerid, "Nenhuma mobília encontrada nesta categoria.");
		return FurnitureShop_ShowCategories(playerid);
	}

	s_pFurnitureSubCategory[playerid] = subcategory;
	Dialog_Show(playerid, DIALOG_FNTR_SHOP_LIST, DIALOG_STYLE_PREVMODEL_EDIT, title, dialog, "Selecionar", "<<");
	return true;
}

FurnitureShop_Search(playerid, const search[])
{
	new dialog[1024], name[64], count = 0;

	for (new i = 0; i < sizeof g_aFurnitureShop; i++)
	{
		if (count >= MAX_SEARCH_FURNITURE)
			break;

		if (IsNumeric(search) && g_aFurnitureShop[i][e_FURNITURE_SHOP_MODEL] != strval(search))
			continue;

		format (name, sizeof name, g_aFurnitureShop[i][e_FURNITURE_SHOP_NAME]);

		if (strfind(name, search, true) == -1 && !IsNumeric(search))
			continue;

		strcat(dialog, va_return("\n%i(0.0, 0.0, 180.0)\t~%s~%s (%s)", g_aFurnitureShop[i][e_FURNITURE_SHOP_MODEL], g_aFurnitureShop[i][e_FURNITURE_SHOP_PRICE] < Character_GetMoney(playerid) ? ("g") : ("r"), name, FormatMoney(g_aFurnitureShop[i][e_FURNITURE_SHOP_PRICE])));
		s_pFurnitureListed[playerid][count] = i;
		count += 1;
	}

	if (!count)
	{
		SendErrorMessage(playerid, "Nenhuma categoria encontrada com os critérios.");
		return FurnitureShop_ShowCategories(playerid);
	}

	s_pFurnitureCategory[playerid] = -1;
	s_pFurnitureSubCategory[playerid] = -1;
	Dialog_Show(playerid, DIALOG_FNTR_SHOP_LIST, DIALOG_STYLE_PREVMODEL_EDIT, "Mobílias encontradas:", dialog, "Selecionar", "<<");
	return true;
}