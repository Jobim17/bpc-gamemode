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

// Constants
#define MAX_FURNITURE_INV_LIST 50

static enum
{
	FURNITURE_INV_ORDER_ASC = 0,
	FURNITURE_INV_ORDER_DESC,
	FURNITURE_INV_ORDER_ALPHA,
	MAX_FURNITURE_INV_ORDER,

	FURNITURE_EDIT_TYPE_POS = 0,
	FURNITURE_EDIT_TYPE_DOOR,
	MAX_FURNITURE_EDIT_TYPE
}

// Variáveis
static s_pFurnitureInvPage[MAX_PLAYERS];
static s_pFurnitureInvSearch[MAX_PLAYERS][128];
static s_pFurnitureInvList[MAX_PLAYERS][MAX_FURNITURE_INV_LIST];
static s_pFurnitureInvSelected[MAX_PLAYERS] = {-1, ...};
static s_pFurnitureOrderType[MAX_PLAYERS] = {FURNITURE_INV_ORDER_ASC, ...};
static s_pFurnitureEditingID[MAX_PLAYERS] = {-1, ...};
static s_pFurnitureEditingType[MAX_PLAYERS] = {-1, ...};
static s_pFurnitureEditMatIndex[MAX_PLAYERS] = {-1, ...};

static const s_furnitureOrderStmt[3][12] = {
	"`ID` ASC",
	"`ID` DESC",
	"`Nome` ASC"
};

// Callbacks
hook OnPlayerConnect(playerid)
{
	s_pFurnitureEditingID[playerid] = -1;
	s_pFurnitureInvPage[playerid] = -1;
	s_pFurnitureInvSelected[playerid] = -1;
	s_pFurnitureOrderType[playerid] = -1;
	s_pFurnitureEditingID[playerid] = -1;
	s_pFurnitureEditingType[playerid] = -1;
	s_pFurnitureEditMatIndex[playerid] = -1;
	return true;
}

hook OnPlayerEditDynamicObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new id = s_pFurnitureInvSelected[playerid];

	if (s_pFurnitureEditingID[playerid] != -1 && id != -1 && objectid != FurnitureData[id][e_FURNITURE_OBJECT])
	{
		s_pFurnitureEditingID[playerid] = -1;
		s_pFurnitureInvSelected[playerid] = -1;
		return true;
	}

	if (s_pFurnitureEditingID[playerid] == -1 && id == -1)
		return true;

	// Confirm 
	if (response == EDIT_RESPONSE_FINAL)
	{
		// Posição
		if (s_pFurnitureEditingType[playerid] == FURNITURE_EDIT_TYPE_POS)
		{
			FurnitureData[id][e_FURNITURE_POS][0] = x;
			FurnitureData[id][e_FURNITURE_POS][1] = y;
			FurnitureData[id][e_FURNITURE_POS][2] = z;
			FurnitureData[id][e_FURNITURE_ROT][0] = rx;
			FurnitureData[id][e_FURNITURE_ROT][1] = ry;
			FurnitureData[id][e_FURNITURE_ROT][2] = rz;
			FurnitureData[id][e_FURNITURE_DOOR_POS][0] = x;
			FurnitureData[id][e_FURNITURE_DOOR_POS][1] = y;
			FurnitureData[id][e_FURNITURE_DOOR_POS][2] = z;
			FurnitureData[id][e_FURNITURE_DOOR_ROT][0] = rx;
			FurnitureData[id][e_FURNITURE_DOOR_ROT][1] = ry;
			FurnitureData[id][e_FURNITURE_DOOR_ROT][2] = (90.0 - rz);
			Furniture_Refresh(id);
			Furniture_Save(id);

			SendClientMessageEx(playerid, COLOR_GREEN, "Você editou com sucesso a posição e rotação da mobília \"%s\".", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]));
		}

		// Rotação da Porta
		else if (s_pFurnitureEditingType[playerid] == FURNITURE_EDIT_TYPE_DOOR)
		{
			FurnitureData[id][e_FURNITURE_DOOR_POS][0] = x;
			FurnitureData[id][e_FURNITURE_DOOR_POS][1] = y;
			FurnitureData[id][e_FURNITURE_DOOR_POS][2] = z;
			FurnitureData[id][e_FURNITURE_DOOR_ROT][0] = rx;
			FurnitureData[id][e_FURNITURE_DOOR_ROT][1] = ry;
			FurnitureData[id][e_FURNITURE_DOOR_ROT][2] = rz;
			Furniture_Refresh(id);
			Furniture_Save(id);

			SendClientMessageEx(playerid, COLOR_GREEN, "Você editou com sucesso o movimento da porta-mobília \"%s\".", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]));
		}

		s_pFurnitureEditingID[playerid] = -1;
		s_pFurnitureEditingType[playerid] = -1;
		return true;
	}

	// Cancelar
	if (response == EDIT_RESPONSE_CANCEL)
	{
		Furniture_Refresh(id);
		FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
		SendErrorMessage(playerid, "Você cancelou a edição da mobília \"%s\".", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]));
		s_pFurnitureEditingID[playerid] = -1;
		s_pFurnitureEditingType[playerid] = -1;
		return true;
	}
	return true;
}

// Dialogs
Dialog:DIALOG_FNTR_INV_LIST(playerid, response, listitem, inputtext[])
{
	if (!response)
		return Furniture_ShowMenu(playerid);

	// Next page
	if (!strcmp(inputtext, "Próxima página >>", false) || !strcmp(inputtext, "Proxima pagina >>", false))
	{
		FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid] + 1, s_pFurnitureInvSearch[playerid]);
		return true;
	}

	// Back Page
	if (!strcmp(inputtext, "<< Página anterior", false) || !strcmp(inputtext, "<< Pagina anterior", false))
	{
		FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid] - 1, s_pFurnitureInvSearch[playerid]);
		return true;
	}

	// Order
	if (listitem == 1)
	{
		switch (s_pFurnitureOrderType[playerid])
		{
			case FURNITURE_INV_ORDER_ASC: s_pFurnitureOrderType[playerid] = FURNITURE_INV_ORDER_DESC;
			case FURNITURE_INV_ORDER_DESC: s_pFurnitureOrderType[playerid] = FURNITURE_INV_ORDER_ALPHA;
			case FURNITURE_INV_ORDER_ALPHA: s_pFurnitureOrderType[playerid] = FURNITURE_INV_ORDER_ASC;
			default: s_pFurnitureOrderType[playerid] = FURNITURE_INV_ORDER_ASC;
		}

		FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid]);
		return true;
	}

	// Search by name
	if (listitem == 2)
	{
		Dialog_Show(playerid, DIALOG_FNTR_INV_SEARCH, DIALOG_STYLE_INPUT, "Buscar mobília no inventário pelo nome:", "Digite o nome ou parte do nome de uma mobília que esteja presente na lista de mobílias desta propriedade.\nQuanto mais preciso for o nome especificado melhor será o resultado.", "Buscar", "<<");
		return true;
	}

	// Select
	new index;

	if (!sscanf(inputtext, "p<.>i{s[*]}", index) && (0 <= (index - 1) < MAX_FURNITURE_INV_LIST) && s_pFurnitureInvList[playerid][index - 1] != -1)
	{
		FurnitureInv_ManageFurniture(playerid, s_pFurnitureInvList[playerid][index - 1]);
		return true;
	}

	FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid], s_pFurnitureInvSearch[playerid]);
	return true;
}

Dialog:DIALOG_FNTR_INV_EDIT(playerid, response, listitem, inputtext[])
{
	if (!response)
		return FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid], s_pFurnitureInvSearch[playerid]);

	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	// Informação
	if (listitem == 0 || !strcmp(inputtext, "Informação", false))
	{
		FurnitureInv_ShowFurnitureInfo(playerid, id);
	}

	// Posição
	else if (listitem == 1 || !strcmp(inputtext, "Posição", false))
	{
		if (!IsPlayerInRangeOfPoint(playerid, 20.0, FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]) )
		{
			SendErrorMessage(playerid, "Você não está próximo desta mobília.");
			return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
		}

		SendClientMessageEx(playerid, COLOR_GREEN, "Você está agora editando a posição da mobília \"%s\".", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]));
		SendClientMessage(playerid, -1, "Segure {FFFF00}ESPAÇO{FFFFFF} para movimentar sua tela, pressione {FFFF00}ESC{FFFFFF} para cancelar a edição");
		SendClientMessage(playerid, -1, "...ou aperte no disquete para salvar a edição.");

		s_pFurnitureEditingID[playerid] = id;
		s_pFurnitureEditingType[playerid] = FURNITURE_EDIT_TYPE_POS;
		EditDynamicObject(playerid, FurnitureData[id][e_FURNITURE_OBJECT]);
	}

	// Posição (texto)
	else if (listitem == 2 || !strcmp(inputtext, "Posição (texto)", false))
	{
		if (!IsPlayerInRangeOfPoint(playerid, 20.0, FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]) )
		{
			SendErrorMessage(playerid, "Você não está próximo desta mobília.");
			return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
		}

		FurnitureInv_EditPosDialog(playerid, id);
	}

	// Editar materiais
	else if (listitem == 3 || !strcmp(inputtext, "Editar Material", false))
	{
		FurnitureInv_ShowMaterialMenu(playerid);
	}

	// Vender
	else if (listitem == 4 || !strcmp(inputtext, "Vender", false))
	{
		Dialog_Show(playerid, DIALOG_FNTR_SELL, DIALOG_STYLE_MSGBOX, "Vender mobília para loja:", "{FFFFFF}Você deseja realmente vender a mobília %s\npor {36A717}%s{FFFFFF}?", "Sim", "Não", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]), FormatMoney(FurnitureData[id][e_FURNITURE_PRICE]));
	}

	// Clonar
	else if (listitem == 5 || !strcmp(inputtext, "Clonar", false))
	{
		Dialog_Show(playerid, DIALOG_FNTR_CLONE, DIALOG_STYLE_MSGBOX, "Clonar mobília:", "{FFFFFF}Você deseja clonar a mobília %s\npor {36A717}%s{FFFFFF}?\nAdicional: Ao clonar a mobília clonada será comprada automaticamente na loja\ne terá posição, textura e cor duplicados.", "Sim", "Não", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]), FormatMoney(FurnitureData[id][e_FURNITURE_PRICE]));
	}

	// Renomear
	else if (listitem == 6 || !strcmp(inputtext, "Renomear"))
	{
		Dialog_Show(playerid, DIALOG_FNTR_NAME, DIALOG_STYLE_INPUT, "Renomear mobília:", "{FFFFFF}Digite o novo nome da mobília:", "Renomear", "<<");
	}

	// Editar movimento da porta
	else if (!strcmp(inputtext, "Editar movimento da porta", false) && Furniture_IsDoor(FurnitureData[id][e_FURNITURE_MODEL]))
	{
		if (!IsPlayerInRangeOfPoint(playerid, 20.0, FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]) )
		{
			SendErrorMessage(playerid, "Você não está próximo desta mobília.");
			return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
		}

		SendClientMessageEx(playerid, COLOR_GREEN, "Você está agora editando o movimento da porta-mobília \"%s\".", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]));
		SendClientMessage(playerid, -1, "Segure {FFFF00}ESPAÇO{FFFFFF} para movimentar sua tela, pressione {FFFF00}ESC{FFFFFF} para cancelar a edição");
		SendClientMessage(playerid, -1, "...ou aperte no disquete para salvar a edição.");

		s_pFurnitureEditingID[playerid] = id;
		s_pFurnitureEditingType[playerid] = FURNITURE_EDIT_TYPE_DOOR;
		EditDynamicObject(playerid, FurnitureData[id][e_FURNITURE_OBJECT]);
	}

	else FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
	return true;
}

Dialog:DIALOG_FNTR_INV_INFO(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (0 <= id < MAX_FURNITURE && FurnitureData[id][e_FURNITURE_EXISTS])
	{
		FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
	}
	else
	{
		FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid], s_pFurnitureInvSearch[playerid]);
	}
	return true;
}

Dialog:DIALOG_FNTR_EDIT_POS(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);

	new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;

	if (sscanf(inputtext, "fffF(-1337.0)F(-1337.0)F(-1337.0)", x, y, z, rx, ry, rz) && sscanf(inputtext, "p<,>fffF(-1337.0)F(-1337.0)F(-1337.0)", x, y, z, rx, ry, rz))
	{
		SendErrorMessage(playerid, "Você especificou um formato inválido.");
		return FurnitureInv_EditPosDialog(playerid, id);
	}

	new Float:dist = VectorSize(
		x - FurnitureData[id][e_FURNITURE_POS][0],
		y - FurnitureData[id][e_FURNITURE_POS][1],
		z - FurnitureData[id][e_FURNITURE_POS][2]
	);

	if (dist > 20.0)
	{
		SendErrorMessage(playerid, "A nova posição da mobília deve estar próxima de 20 metros da atual.");
		return FurnitureInv_EditPosDialog(playerid, id);
	}

	FurnitureData[id][e_FURNITURE_POS][0] = x;
	FurnitureData[id][e_FURNITURE_POS][1] = y;
	FurnitureData[id][e_FURNITURE_POS][2] = z;
	FurnitureData[id][e_FURNITURE_DOOR_POS][0] = x;
	FurnitureData[id][e_FURNITURE_DOOR_POS][1] = y;
	FurnitureData[id][e_FURNITURE_DOOR_POS][2] = z;

	if (rx != -1337.0)
	{
		FurnitureData[id][e_FURNITURE_ROT][0] = rx;
		FurnitureData[id][e_FURNITURE_ROT][1] = ry;
		FurnitureData[id][e_FURNITURE_ROT][2] = rz;
		FurnitureData[id][e_FURNITURE_DOOR_ROT][0] = rx;
		FurnitureData[id][e_FURNITURE_DOOR_ROT][1] = ry;
		FurnitureData[id][e_FURNITURE_DOOR_ROT][2] = (90.0 - rz);
	}

	Furniture_Refresh(id);
	Furniture_Save(id);
	FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você editou com sucesso a posição da mobília \"%s\".", ReturnLimitedText(FurnitureData[id][e_FURNITURE_NAME]));
	return true;
}

Dialog:DIALOG_FNTR_INV_MTMENU(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);

	switch (listitem)
	{
		case 0: // Editar cores
		{
			FurnitureInv_ShowColors(playerid, id);
		}	

		case 1: // Editar texturas
		{
			FurnitureInv_ShowTextures(playerid, id);
		}

		case 2: // Remover material
		{
			for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
			{
				FurnitureData[id][e_FURNITURE_TEXTURE][i] = -1;
				FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] = -1;
			}

			Furniture_Refresh(id);
			Furniture_Save(id);
			FurnitureInv_ShowMaterialMenu(playerid);
			SendClientMessageEx(playerid, COLOR_GREEN, "Você removeu todos os materiais da mobília \"%s\".", FurnitureData[id][e_FURNITURE_NAME]);
		}

		default: FurnitureInv_ShowMaterialMenu(playerid);
	}

	return true;
}

Dialog:DIALOG_FNTR_COLORS(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ShowMaterialMenu(playerid);

	if (!strcmp(inputtext, "Remover todas as cores", false))
	{
		for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
			FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] = -1;

		Furniture_Save(id);
		Furniture_Refresh(id);
		FurnitureInv_ShowColors(playerid, id);
		SendClientMessageEx(playerid, COLOR_GREEN, "Todas as cores da mobília foram removidas com sucesso.");	
	}
	else if ((0 <= listitem < MAX_FURNITURE_TEXTURE))
	{
		new dialog[128 + 64] = "{BBBBBB}Remover cor";

		for (new i = 0; i < sizeof g_aColors; i++)
		{
			strcat (dialog, "\n");
			strcat (dialog, va_return("{%06x}%s", (g_aColors[i][e_COLOR_ARGB] & 0x00FFFFFF), g_aColors[i][e_COLOR_NAME]));
		}

		s_pFurnitureEditMatIndex[playerid] = listitem;
		Dialog_Show(playerid, DIALOG_FNTR_EDIT_COLOR, DIALOG_STYLE_LIST, "Cores:", dialog, "Selecionar", "<<");
	}
	else
	{
		FurnitureInv_ShowColors(playerid, id);
	}
	return true;
}

Dialog:DIALOG_FNTR_TEXTURES(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ShowMaterialMenu(playerid);

	if (!strcmp(inputtext, "Remover todas as texturas", false))
	{
		for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
			FurnitureData[id][e_FURNITURE_TEXTURE][i] = -1;

		Furniture_Save(id);
		Furniture_Refresh(id);
		FurnitureInv_ShowTextures(playerid, id);
		SendClientMessageEx(playerid, COLOR_GREEN, "Todas as texturas da mobília foram removidas com sucesso.");	
	}
	else if ((0 <= listitem < MAX_FURNITURE_TEXTURE))
	{
		new dialog[1024 + 64] = "{BBBBBB}Remover textura\n{FFFF00}Pesquisar textura{FFFFFF}";

		for (new i = 9065; i < (9065 + 50); i++)
		{
			strcat (dialog, "\n");
			strcat (dialog, Furniture_GetTextureName(i));
		}

		s_pFurnitureEditMatIndex[playerid] = listitem;
		Dialog_Show(playerid, DIALOG_FNTR_EDIT_TEXTURE, DIALOG_STYLE_LIST, "Texturas:", dialog, "Selecionar", "<<");
	}
	else
	{
		FurnitureInv_ShowTextures(playerid, id);
	}
	return true;
}

Dialog:DIALOG_FNTR_EDIT_COLOR(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid], index = s_pFurnitureEditMatIndex[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response || !(0 <= index < MAX_FURNITURE_TEXTURE))
		return FurnitureInv_ShowColors(playerid, id);

	if (listitem == 0)
	{
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][index] = -1;
		SendErrorMessage(playerid, "Você removeu a cor de material do slot %i da mobília.", index + 1);
	}
	else
	{
		FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][index] = (listitem - 1);
		SendClientMessageEx(playerid, COLOR_GREEN, "Você atualizou a cor de material do slot %i da mobília com sucesso.", index + 1);
	}

	Furniture_Save(id);
	Furniture_Refresh(id);
	FurnitureInv_ShowColors(playerid, id);
	return true;
}

Dialog:DIALOG_FNTR_EDIT_TEXTURE(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid], index = s_pFurnitureEditMatIndex[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response || !(0 <= index < MAX_FURNITURE_TEXTURE))
		return FurnitureInv_ShowTextures(playerid, id);

	if (listitem == 0) // Remover textura
	{
		FurnitureData[id][e_FURNITURE_TEXTURE][index] = -1;
		SendErrorMessage(playerid, "Você removeu a textura do slot %i da mobília.", index + 1);
	}

	else if (listitem == 1) // Outras texturas
	{
		FurnitureTexture_ShowMenu(playerid);
		return true;
	}

	else
	{
		FurnitureData[id][e_FURNITURE_TEXTURE][index] = (listitem + 9065) - 2;
		SendClientMessageEx(playerid, COLOR_GREEN, "Você atualizou a textura do slot %i para \"%s\".", index + 1, Furniture_GetTextureName(FurnitureData[id][e_FURNITURE_TEXTURE][index]));
	}

	Furniture_Refresh(id);
	Furniture_Save(id);
	FurnitureInv_ShowTextures(playerid, id);
	return true;
}

Dialog:DIALOG_FNTR_SELL(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);

	Character_GiveMoney(playerid, FurnitureData[id][e_FURNITURE_PRICE]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você vendeu com sucesso a mobília %s por %s.", FurnitureData[id][e_FURNITURE_NAME], FormatMoney(FurnitureData[id][e_FURNITURE_PRICE]));
	Furniture_Delete(id);
	FurnitureInv_ShowList(playerid, s_pFurnitureOrderType[playerid], s_pFurnitureInvPage[playerid], s_pFurnitureInvSearch[playerid]);
	return true;
}

Dialog:DIALOG_FNTR_CLONE(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid], type, idx, prop;

	if (!Furniture_Check(playerid, id, true, type, idx))
		return false;

	if (!response)
		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);

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

		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
	}

	if (Character_GetMoney(playerid) < FurnitureData[id][e_FURNITURE_PRICE])
	{
		SendErrorMessage(playerid, "Você não tem fundos suficiente para clonar esta mobília.");
		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
	}

	new count, name[64];
	foreach (new i : Furnitures)
	{
		if (!FurnitureData[i][e_FURNITURE_EXISTS] || FurnitureData[i][e_FURNITURE_MODEL] != FurnitureData[id][e_FURNITURE_MODEL] || FurnitureData[i][e_FURNITURE_LINK_TYPE] != type || FurnitureData[i][e_FURNITURE_LINK_ID] != prop || strcmp(FurnitureData[i][e_FURNITURE_NAME], FurnitureData[id][e_FURNITURE_NAME], false))
			continue;
	
		if (strcmp(FurnitureData[i][e_FURNITURE_NAME], FurnitureData[id][e_FURNITURE_NAME], false))
			continue;

		count += 1;
	}

	if (count > 0)
	{
		format (name, sizeof name, "%.60s (%i)", FurnitureData[id][e_FURNITURE_NAME], count);
	}	
	else
	{
		format (name, sizeof name, FurnitureData[id][e_FURNITURE_NAME]);
	}

	new fntr = Furniture_Clone(id, name);

	if (fntr == -1)
	{
		SendErrorMessage(playerid, "O servidor atingiu o limite de mobílias.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "A mobília %s foi adicionada ao seu inventário de mobílias por %s.", name, FormatMoney(FurnitureData[id][e_FURNITURE_PRICE]));
		Character_GiveMoney(playerid, -FurnitureData[id][e_FURNITURE_PRICE]);

		s_pFurnitureEditingID[playerid] = fntr;
		s_pFurnitureInvSelected[playerid] = fntr;
		s_pFurnitureEditingType[playerid] = FURNITURE_EDIT_TYPE_POS;
		EditDynamicObject(playerid, FurnitureData[fntr][e_FURNITURE_OBJECT]);
	}

	return true;
}

Dialog:DIALOG_FNTR_NAME(playerid, response, listitem, inputtext[])
{
	new id = s_pFurnitureInvSelected[playerid];

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);

	if (!(3 <= strlen(inputtext) <= 25))
	{
		Dialog_Show(playerid, DIALOG_FNTR_NAME, DIALOG_STYLE_INPUT, "Renomear mobília:", "{FFFFFF}Erro: O limite de caracteres é 25 e o minímo é 3.\nDigite o novo nome da mobília:", "Renomear", "<<");
		return true;
	}

	format(FurnitureData[id][e_FURNITURE_NAME], 64, inputtext);
	Furniture_Save(id);
	FurnitureInv_ManageFurniture(playerid, FurnitureData[id][e_FURNITURE_ID]);
	return true;
}

// Functions
FurnitureInv_ShowList(playerid, order = FURNITURE_INV_ORDER_ASC, page = 0, const search[] = "")
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	new type, idx, id;

	if (!Furniture_Check(playerid, -1, false, type, idx))
		return false;

	switch (type)
	{
		case FURNITURE_LINK_TYPE_HOUSE: id = HouseData[idx][e_HOUSE_ID];
		case FURNITURE_LINK_TYPE_BUSINESS: id = BusinessData[idx][e_BUSINESS_ID];
	}

	// Variables
	new dialog[2056], totalFurniture, totalPage, offset;

	inline Furniture_Display()
	{
		new rows = cache_num_rows();

		if (!rows)
		{
			if (IsNull(search))
			{
				SendErrorMessage(playerid, "Nenhuma mobília encontrada no inventário.");
			}
			else
			{
				SendErrorMessage(playerid, "Nenhuma mobília encontrada com a busca \"%s\".", search);
			}
			

			return true;
		}

		// Header
		format (dialog, sizeof dialog, "{BBBBBB}OPÇÕES DE LISTA{FFFFFF}\t\n");

		switch (order)
		{
			case FURNITURE_INV_ORDER_ASC: strcat (dialog, "Exibição (ordem crescente)\t\n");
			case FURNITURE_INV_ORDER_DESC: strcat (dialog, "Exibição (ordem decrescente)\t\n");
			case FURNITURE_INV_ORDER_ALPHA: strcat (dialog, "Exibição (ordem alfabética)\t\n");
		}

		strcat (dialog, "Buscar mobília no inventário pelo nome\t\n");

		// Title
		if (totalPage > 1)
		{
			strcat (dialog, va_return("\t\n{BBBBBB}MOBÍLIAS (exibindo a página %i de %i){FFFFFF}\t\n", page + 1, totalPage));
		}
		else
		{
			strcat (dialog, "\t\n{BBBBBB}MOBÍLIAS{FFFFFF}\t\n");
		}

		// Buttons
		if (rows == MAX_FURNITURE_INV_LIST && page < (totalPage - 1))
		{
			strcat(dialog, "{BBBBBB}Próxima página >>\t\n");
		}

		if (page > 0)
		{
			strcat(dialog, "{BBBBBB}<< Página anterior\t\n");
		}

		// Furnitures
		for (new i = 0; i < rows; i++)
		{
			new name[64], sqlid;
			cache_get_value_name_int(i, "ID", sqlid);
			cache_get_value_name(i, "Nome", name);

			s_pFurnitureInvList[playerid][i] = sqlid;
			strcat (dialog, va_return("%i. %s\t\n", i + 1, ReturnLimitedText(name)));
		}

		s_pFurnitureInvPage[playerid] = page;
		Dialog_Show(playerid, DIALOG_FNTR_INV_LIST, DIALOG_STYLE_TABLIST, "Mobília: Inventário", dialog, "Selecionar", "<<");
	}

	inline Furniture_FetchPage()
	{
		cache_get_value_name_int(0, "Total", totalFurniture);

		totalPage = (totalFurniture + MAX_FURNITURE_INV_LIST - 1) / MAX_FURNITURE_INV_LIST;

		if (page < 0) page = 0;
		else if (page > totalPage) page = totalPage - 1;

		offset = (page * MAX_FURNITURE_INV_LIST);

		for (new i = 0; i < MAX_FURNITURE_INV_LIST; i++)
		{
			s_pFurnitureInvList[playerid][i] = -1;
		}

		s_pFurnitureOrderType[playerid] = order;
		format (s_pFurnitureInvSearch[playerid], 128, search);
		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Furniture_Display, "SELECT `Nome`, `ID` FROM `Mobílias` WHERE `Tipo` = %i AND `Propriedade` = %i AND `Nome` LIKE '%%%s%%' ORDER BY %s LIMIT %i OFFSET %i;", type, id, search, s_furnitureOrderStmt[order], MAX_FURNITURE_INV_LIST, offset);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Furniture_FetchPage, "SELECT COUNT(*) AS `Total` FROM `Mobílias` WHERE `Tipo` = %i AND `Propriedade` = %i AND `Nome` LIKE '%%%s%%';", type, id, search);
	return true;
}

FurnitureInv_ManageFurniture(playerid, fntrid)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	new id = Furniture_GetRealID(fntrid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	new title[64], dialog[256] = "";
	format (title, sizeof title, "Mobília: %s", FurnitureData[id][e_FURNITURE_NAME]);

	strcat (dialog, "Informação\n");

	if (IsPlayerInRangeOfPoint(playerid, 20.0, FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]) )
	{
		strcat (dialog, "Posição\nPosição (texto)\n");
	}
	else
	{
		strcat (dialog, "{BBBBBB}Posição\nPosição (texto)\n{FFFFFF}");
	}

	strcat (dialog, "Editar Material\nVender\nClonar\nRenomear\nCopiar rotação");

	if (Furniture_IsDoor(FurnitureData[id][e_FURNITURE_MODEL]))
	{
		strcat (dialog, "\nEditar movimento da porta");
	}

	s_pFurnitureInvSelected[playerid] = id;
	Dialog_Show(playerid, DIALOG_FNTR_INV_EDIT, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	return true;
}

FurnitureInv_ShowFurnitureInfo(playerid, id)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!Furniture_Check(playerid, id, true))
		return false;

	new title[64], dialog[256] = "{FFFFFF}";
	format (title, sizeof title, "Mobília: %s", FurnitureData[id][e_FURNITURE_NAME]);

	strcat (dialog, va_return("Nome: %s\n", FurnitureData[id][e_FURNITURE_NAME]));

	for (new i = 0; i < sizeof g_aFurnitureShop; i++)
	{
		if (g_aFurnitureShop[i][e_FURNITURE_SHOP_MODEL] != FurnitureData[id][e_FURNITURE_MODEL])
			continue;

		strcat (dialog, va_return("Nome original: %s\n", g_aFurnitureShop[i][e_FURNITURE_SHOP_NAME]));
		break;
	}

	strcat (dialog, va_return("Preço de venda: {36A717}%s{FFFFFF}\n", FormatMoney(FurnitureData[id][e_FURNITURE_PRICE])));
	strcat (dialog, va_return("Posições:\n\tX: %.3f\tY: %.3f\tZ: %.3f\n", FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]));
	strcat (dialog, va_return("Rotações:\n\tRX: %.3f\tRY: %.3f\tRZ: %.3f\n", FurnitureData[id][e_FURNITURE_ROT][0], FurnitureData[id][e_FURNITURE_ROT][1], FurnitureData[id][e_FURNITURE_ROT][2]));

	Dialog_Show(playerid, DIALOG_FNTR_INV_INFO, DIALOG_STYLE_MSGBOX, title, dialog, "<<", "");
	return true;
}

FurnitureInv_ShowMaterialMenu(playerid)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!Furniture_Check(playerid, -1, false))
		return false;

	Dialog_Show(playerid, DIALOG_FNTR_INV_MTMENU, DIALOG_STYLE_LIST, "Editar Materiais:", "Editar cores\nEditar texturas\nRemover materiais", "Selecionar", "Fechar");
	return true;
}

FurnitureInv_ShowColors(playerid, id)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!Furniture_Check(playerid, id, true))
		return false;

	new title[128], dialog[128 + 64] = "";
	format (title, sizeof title, "Cores: %s", FurnitureData[id][e_FURNITURE_NAME]);

	for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
	{
		strcat (dialog, i > 0 ? ("\n") : (""));
		strcat (dialog, va_return("Cor Slot %i", i + 1));

		if (FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] != -1)
		{
			strcat (dialog, va_return(" {BBBBBB}(%s){FFFFFF}", g_aColors[ FurnitureData[id][e_FURNITURE_TEXTURE_COLOR][i] ][e_COLOR_NAME]));
		}
	}

	strcat (dialog, "\nRemover todas as cores");
	Dialog_Show(playerid, DIALOG_FNTR_COLORS, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	return true;
}

FurnitureInv_ShowTextures(playerid, id)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!Furniture_Check(playerid, id, true))
		return false;

	new title[128], dialog[512] = "";
	format (title, sizeof title, "Texturas: %s", FurnitureData[id][e_FURNITURE_NAME]);

	for (new i = 0; i < MAX_FURNITURE_TEXTURE; i++)
	{
		strcat (dialog, i > 0 ? ("\n") : (""));
		strcat (dialog, va_return("Textura Slot %i", i + 1));

		if (FurnitureData[id][e_FURNITURE_TEXTURE][i] != -1)
		{
			strcat (dialog, va_return(" {BBBBBB}(%s){FFFFFF}", Furniture_GetTextureName(FurnitureData[id][e_FURNITURE_TEXTURE][i])));
		}
	}

	strcat (dialog, "\nRemover todas as texturas");
	Dialog_Show(playerid, DIALOG_FNTR_TEXTURES, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	return true;
}

FurnitureInv_EditPosDialog(playerid, id)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (!Furniture_Check(playerid, id, true))
		return false;

	new dialog[256 + 128] = "", title[128];
	format (title, sizeof title, "Mobília: %s", FurnitureData[id][e_FURNITURE_NAME]);

	strcat (dialog, va_return("Você está editando a posição da mobília %s\n\n", FurnitureData[id][e_FURNITURE_NAME]));
	strcat (dialog, va_return("Posições atuais:\n\tX: %.3f\tY: %.3f\tZ: %.3f\n", FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]));
	strcat (dialog, va_return("Rotações atuais:\n\tRX: %.3f\tRY: %.3f\tRZ: %.3f\n", FurnitureData[id][e_FURNITURE_ROT][0], FurnitureData[id][e_FURNITURE_ROT][1], FurnitureData[id][e_FURNITURE_ROT][2]));
	strcat (dialog, "\nDigite a nova posição e rotação no seguinte formato:\n\tx, y, z, rx, ry, rz (rotações opcionais)");

	Dialog_Show(playerid, DIALOG_FNTR_EDIT_POS, DIALOG_STYLE_INPUT, title, dialog, "Confirmar", "<<");
	return true;
}

FurnitureInv_GetSelected(playerid)
{
	return s_pFurnitureInvSelected[playerid];
}

FurnitureInv_GetMaterialIndex(playerid)
{
	return s_pFurnitureEditMatIndex[playerid];
}