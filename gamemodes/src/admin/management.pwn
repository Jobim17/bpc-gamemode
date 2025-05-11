/*
	ooo        ooooo                                                                                                  .         .oooooo..o                          .
	`88.       .888'                                                                                                .o8        d8P'    `Y8                        .o8
	 888b     d'888   .oooo.   ooo. .oo.    .oooo.    .oooooooo  .ooooo.  ooo. .oo.  .oo.    .ooooo.  ooo. .oo.   .o888oo      Y88bo.      oooo    ooo  .oooo.o .o888oo  .ooooo.  ooo. .oo.  .oo.
	 8 Y88. .P  888  `P  )88b  `888P"Y88b  `P  )88b  888' `88b  d88' `88b `888P"Y88bP"Y88b  d88' `88b `888P"Y88b    888         `"Y8888o.   `88.  .8'  d88(  "8   888   d88' `88b `888P"Y88bP"Y88b
	 8  `888'   888   .oP"888   888   888   .oP"888  888   888  888ooo888  888   888   888  888ooo888  888   888    888             `"Y88b   `88..8'   `"Y88b.    888   888ooo888  888   888   888
	 8    Y     888  d8(  888   888   888  d8(  888  `88bod8P'  888    .o  888   888   888  888    .o  888   888    888 .      oo     .d8P    `888'    o.  )88b   888 . 888    .o  888   888   888
	o8o        o888o `Y888""8o o888o o888o `Y888""8o `8oooooo.  `Y8bod8P' o888o o888o o888o `Y8bod8P' o888o o888o   "888"      8""88888P'      .8'     8""888P'   "888" `Y8bod8P' o888o o888o o888o
	                                                 d"     YD                                                                             .o..P'
	                                                 "Y88888P'                                                                             `Y8P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
enum
{
	ITEM_SELECT_TYPE_MANAGE,
	ITEM_SELECT_TYPE_ADD_BIZ
}

// Variáveis
static s_pItemSelectType[MAX_PLAYERS] = {ITEM_SELECT_TYPE_MANAGE, ...};
static s_pItemSelectID[MAX_PLAYERS] = {-1, ...};
static bool:s_pItemEditingHand[MAX_PLAYERS char] = {false, ...};

static s_pUserClosedSelected[MAX_PLAYERS][MAX_PLAYER_NAME + 1];

static s_pInteriorCategorySelect[MAX_PLAYERS][32 + 1];
static s_pInteriorSelect[MAX_PLAYERS][32 + 1];

static s_pBizTypeSelect[MAX_PLAYERS] = {-1, ...};
static s_pBizItemSelect[MAX_PLAYERS] = {-1, ...};

// Callbacks
hook OnPlayerConnect(playerid)
{
	s_pItemEditingHand{playerid} = false;
	s_pItemSelectID[playerid] = -1;
	s_pItemSelectType[playerid] = -1;
	return true;
}

hook OnPlayerSelectItem(playerid, item_id, item_name[])
{
	// Gerenciar itens
	if (s_pItemSelectType[playerid] == ITEM_SELECT_TYPE_MANAGE)
	{
		if (Item_GetRealID(item_id) != -1)
		{	
			Management_ShowItem(playerid, item_id);
		}	
		else
		{
			Item_ShowList(playerid, Item_GetPlayerPage(playerid));
		}
	}

	// Gerenciar itens disponíveis
	if (s_pItemSelectType[playerid] == ITEM_SELECT_TYPE_ADD_BIZ)
	{
		if (Item_GetRealID(item_id) != -1)
		{	
			inline BizItem_Add()
			{
				if (!cache_affected_rows())
					SendErrorMessage(playerid, "Não foi possível adicionar o item.");

				Management_ShowBizItems(playerid, s_pBizTypeSelect[playerid]);
			}

			MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline BizItem_Add, "INSERT IGNORE INTO `EmpresaItens` (`Tipo`, `Item`) VALUES (%i, %i);", s_pBizTypeSelect[playerid], item_id);
		}
		else
		{
			Item_ShowList(playerid, Item_GetPlayerPage(playerid));
		}
	}

	return true;
}

hook OnPlayerCancelSelectItem(playerid)
{
	if (s_pItemSelectType[playerid] == ITEM_SELECT_TYPE_MANAGE)
	{
		Management_ShowDialogMenu(playerid);
	}

	if (s_pItemSelectType[playerid] == ITEM_SELECT_TYPE_ADD_BIZ)
	{
		Management_ShowBizItems(playerid, s_pBizTypeSelect[playerid]);
	}

	s_pItemSelectType[playerid] = -1;
	return true;
}

hook OnPlayerEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new id = Management_CheckItem(playerid);

	if (id == -1 || !s_pItemEditingHand{playerid})
		return false;

	if (response)
	{
		ItemData[id][e_ITEM_ATTACH_OFFSET][0] = fOffsetX;
		ItemData[id][e_ITEM_ATTACH_OFFSET][1] = fOffsetY;
		ItemData[id][e_ITEM_ATTACH_OFFSET][2] = fOffsetZ;
		ItemData[id][e_ITEM_ATTACH_OFFSET][3] = fRotX;
		ItemData[id][e_ITEM_ATTACH_OFFSET][4] = fRotY;
		ItemData[id][e_ITEM_ATTACH_OFFSET][5] = fRotZ;
		ItemData[id][e_ITEM_ATTACH_OFFSET][6] = fScaleX;
		ItemData[id][e_ITEM_ATTACH_OFFSET][7] = fScaleY;
		ItemData[id][e_ITEM_ATTACH_OFFSET][8] = fScaleZ;
		Item_Save(ItemData[id][e_ITEM_ID]);

		SendClientMessageEx(playerid, -1, "SERVER: O item %s teve sua posição, rotação e escala na mão ajustadas com sucesso.", ItemData[id][e_ITEM_NAME]);
	}
	else
	{
		SendClientMessageEx(playerid, -1, "SERVER: Você cancelou a edição da posição, rotação e escala do item %s na mão.", ItemData[id][e_ITEM_NAME]);
		
	}

	CancelEdit(playerid);
	ResetPlayerHands(playerid);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	s_pItemEditingHand{playerid} = false;
	return true;
}

// Dialogs
Dialog:DIALOG_MANAGE_HOME(playerid, response, listitem, inputtext[])
{
	if (!response) return false;

	// Gerenciar MOTD
	if (!strcmp(inputtext, "Gerenciar MOTD", true))
	{
		static serverMOTD[256];
		GetGVarString("SERVER_MOTD", serverMOTD, sizeof serverMOTD);

		if (IsNull(serverMOTD))
		{
			Dialog_Show(playerid, DIALOG_MNG_ADD_MOTD, DIALOG_STYLE_INPUT, "Gerenciar MOTD", "Defina a mensagem do dia que é exibida após o login:", "Definir", "Cancelar");
		}
		else
		{
			Dialog_Show(playerid, DIALOG_MNG_REM_MOTD, DIALOG_STYLE_MSGBOX, "Gerenciar MOTD", "Você deseja remover a mensagem do dia?", "Sim", "Não");
		}
	}

	// Status 
	else if (!strcmp(inputtext, "Status", true))
	{
		UpdateServerVariableInt("CLOSED_BETA", !GetGVarInt("CLOSED_BETA"));	
		Log_Create("Closed Beta", "%s tornou a closed beta %s no servidor", AccountData[playerid][e_ACCOUNT_NAME], (GetGVarInt("CLOSED_BETA") ? ("ativa") : ("desativada")));
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s tornou a Closed Beta %s no servidor.", AccountData[playerid][e_ACCOUNT_NAME], (GetGVarInt("CLOSED_BETA") ? ("ativa") : ("desativada")));
		SendClientMessageEx(playerid, -1, "SERVER: Você tornou a Closed Beta %s no servidor.", (GetGVarInt("CLOSED_BETA") ? ("ativa") : ("desativada")));
		Management_ShowDialogMenu(playerid);
	}

	// Gerenciar usuários
	else if (!strcmp(inputtext, "Gerenciar usuários", true) || !strcmp(inputtext, "Gerenciar usuarios", true))
	{
		Management_ShowClosedBetaUsers(playerid);
	}

	// Gerenciar itens
	else if (!strcmp(inputtext, "Gerenciar itens", true))
	{
		s_pItemSelectType[playerid] = ITEM_SELECT_TYPE_MANAGE;
		Item_ShowList(playerid, 0);
	}

	// Adicionar item
	else if (!strcmp(inputtext, "Adicionar item", true))
	{
		Dialog_Show(playerid, DIALOG_MANAGE_ADD_ITEM, DIALOG_STYLE_INPUT, "Adicionar item", "Digite o nome do item:", "Prosseguir", "<<");
	}

	// Gerenciar itens disponíveiss
	else if (!strcmp(inputtext, "Gerenciar itens disponíveis") || !strcmp(inputtext, "Gerenciar itens disponiveis"))
	{
		Management_ShowBizTypes(playerid);
	}

	// Gerenciar categorias de interiores
	else if (!strcmp(inputtext, "Gerenciar categorias de interiores", true))
	{
		Management_ShowIntCategories(playerid);
	}

	// Gerenciar interiores
	else if (!strcmp(inputtext, "Gerenciar interiores", true))
	{
		Management_ShowIntCategorySel(playerid);
	}

	else
	{
		Management_ShowDialogMenu(playerid);
	}

	return true;
}

Dialog:DIALOG_MNG_ADD_MOTD(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	if(IsNull(inputtext) || strlen(inputtext) > 144)
	{
		Dialog_Show(playerid, DIALOG_MNG_ADD_MOTD, DIALOG_STYLE_INPUT, "Gerenciar MOTD", "Erro: MOTD inválida.\nDefina a mensagem do dia que é exibida após o login:", "Definir", "Cancelar");
		return true;
	}

	Log_Create("Gerenciamento", "%s atualizou a MOTD do servidor", AccountData[playerid][e_ACCOUNT_NAME]);
	SendClientMessageEx(playerid, -1, "SERVER: Você atualizou a mensagem do dia do servidor.");
	UpdateServerVariableString("SERVER_MOTD", inputtext);
	return true;
}

Dialog:DIALOG_MNG_REM_MOTD(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	Log_Create("Gerenciamento", "%s removeu a MOTD do servidor", AccountData[playerid][e_ACCOUNT_NAME]);
	SendClientMessageEx(playerid, -1, "SERVER: Você removeu a mensagem do dia do servidor.");
	UpdateServerVariableString("SERVER_MOTD", "");
	return true;
}

Dialog:DIALOG_MANAGE_ADD_ITEM(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	static itemName[64 + 1];
	format (itemName, sizeof itemName, inputtext);

	if (IsNull(itemName))
	{
		Dialog_Show(playerid, DIALOG_MANAGE_ADD_ITEM, DIALOG_STYLE_INPUT, "Adicionar item", "Erro: Você especificou um nome grande demais. (Máx: 64 caracteres)\nDigite o nome do item:", "Prosseguir", "<<");
		return true;
	}

	if (strlen(itemName) > 64)
	{
		Dialog_Show(playerid, DIALOG_MANAGE_ADD_ITEM, DIALOG_STYLE_INPUT, "Adicionar item", "Erro: Você especificou um nome grande demais. (Máx: 64 caracteres)\nDigite o nome do item:", "Prosseguir", "<<");
		return true;
	}

	inline Item_OnCreated()
	{
		if (!cache_affected_rows())
		{
			SendErrorMessage(playerid, "Não foi possível adicionar o item %s.", itemName);
			Management_ShowDialogMenu(playerid);
		}
		else
		{
			Log_Create("Gerenciamento", "%s criou o item %s", AccountData[playerid][e_ACCOUNT_NAME], itemName);

			Item_Load();
			SendClientMessageEx(playerid, -1, "SERVER: Item %s adicionado com sucesso. Altere o modelo e categoria gerenciando ele.", itemName);
			Management_ShowDialogMenu(playerid);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Item_OnCreated, "INSERT IGNORE INTO `Itens` (`Nome`, `Modelo`) VALUES ('%e', -1);", itemName);
	return true;
}

Dialog:DIALOG_MNG_ITEM(playerid, response, listitem, inputtext[])
{
	if (!response) return Item_ShowList(playerid, Item_GetPlayerPage(playerid));

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	new title[128], dialog[1024];
	format (title, sizeof title, "Gerenciar: %s", Item_GetName(s_pItemSelectID[playerid]));

	// Renomear nome
	if (!strcmp(inputtext, "Renomear item", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_ITEM_NAME, DIALOG_STYLE_INPUT, title, "Digite o novo nome do item %s. O limite máximo de caracteres é 64.", "Renomear", "<<", Item_GetName(s_pItemSelectID[playerid]));
	}

	// Alterar modelo
	else if (!strcmp(inputtext, "Alterar modelo", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_ITEM_MODEL, DIALOG_STYLE_INPUT, title, "Digite o novo modelo do item %s.", "Alterar", "<<", Item_GetName(s_pItemSelectID[playerid]));
	}

	// Alterar categoria
	else if (!strcmp(inputtext, "Alterar categoria", true))
	{
		for (new i = 1; i < MAX_ITEM_CATEGORY; i++)
		{
			strcat (dialog, i > 0 ? ("\n") : (""));
			strcat (dialog, g_arrItemCategory[i]);
		}

		Dialog_Show(playerid, DIALOG_MNG_ITEM_CAT, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	}

	// Item pesado
	else if (!strcmp(inputtext, "Item pesado", true))
	{
		ItemData[id][e_ITEM_IS_HEAVY] = !ItemData[id][e_ITEM_IS_HEAVY];
		Management_ShowItem(playerid, s_pItemSelectID[playerid]);
		SendClientMessageEx(playerid, -1, "SERVER: Você definiu o item %s como um item %s.", ItemData[id][e_ITEM_NAME], (ItemData[id][e_ITEM_IS_HEAVY] ? ("pesado") : ("não pesado")));
		Log_Create("Gerenciamento", "%s definiu o item %s como item %s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], (ItemData[id][e_ITEM_IS_HEAVY] ? ("pesado") : ("não pesado")));
	
		foreach (new i : Player)
		{
			if (!IsPlayerSpawned(i))
				continue;

			if (!Inventory_HasItem(i, ItemData[id][e_ITEM_NAME]))
				continue;

			if (ItemData[id][e_ITEM_IS_HEAVY])
			{
				Inventory_UpdateHeavyItem(i);
			}
			else
			{
				ResetPlayerHands(i);
			}
		}
	}

	// Posição do item na mão direita
	else if (!strcmp(inputtext, "Posição do item na mão direita", true) || !strcmp(inputtext, "Posicao do item na mao direita", true))
	{
		if (ItemData[id][e_ITEM_MODEL] == -1)
		{
			SendErrorMessage(playerid, "Este item não possui modelo escolhido.");
			Management_ShowItem(playerid, s_pItemSelectID[playerid]);
			return true;
		}

		if (!IsPlayerFreeHands(playerid))
		{
			ResetPlayerHands(playerid);
		}

		// Bandeja
		if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_FOOD && ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_ORDER)
		{
			SendClientMessageEx(playerid, -1, "Esse item é da sub-categoria bandeja, a animação de segurar foi aplicada.");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		}

		SetPlayerAttachedObject(
			playerid, 
			9, 
			ItemData[id][e_ITEM_MODEL], 
			6,
			ItemData[id][e_ITEM_ATTACH_OFFSET][0],
			ItemData[id][e_ITEM_ATTACH_OFFSET][1],
			ItemData[id][e_ITEM_ATTACH_OFFSET][2],
			ItemData[id][e_ITEM_ATTACH_OFFSET][3],
			ItemData[id][e_ITEM_ATTACH_OFFSET][4],
			ItemData[id][e_ITEM_ATTACH_OFFSET][5],
			1.0,
			1.0,
			1.0
		);

		EditAttachedObject(playerid, 9);

		// Edit
		SendClientMessage(playerid, -1, "Segure {FFFF00}ESPAÇO{FFFFFF} para movimentar sua tela, pressione {FFFF00}ESC{FFFFFF} para finalizar a edição.");
		s_pItemEditingHand{playerid} = true;
	}

	// Excluir item
	else if (!strcmp(inputtext, "Excluir item", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_ITEM_DELETE, DIALOG_STYLE_MSGBOX, title, "Você deseja excluir permanentemente o item %s do servidor?\n\nEsta ação removerá este item dos inventários dos jogadores\narmazenamento em casas, dropados e em veículos.", "Confirmar", "<<", ItemData[id][e_ITEM_NAME]);
	}

	// Alterar sub categoria
	else if (!strcmp(inputtext, "Alterar subcategoria", true))
	{
		for (new i = 1; i < MAX_ITEM_SUBCATEGORY; i++)
		{
			strcat (dialog, i > 0 ? ("\n") : (""));
			strcat (dialog, g_arrItemSubCategory[i]);
		}

		Dialog_Show(playerid, DIALOG_MNG_ITEM_SUBCAT, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	}

	// Drogas
	else if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_DRUGS && ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_DRUG)
	{
		// Tipo
		if (!strcmp(inputtext, "Tipo", true))
		{
			for (new i = 1; i < MAX_DRUG_TYPE; i++)
			{
				strcat (dialog, i > 0 ? ("\n") : (""));
				strcat (dialog, g_arrItemDrugType[i]);
			}

			Dialog_Show(playerid, DIALOG_MNG_ITEM_DRUGTYPE, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
		}

		// Status
		else if (!strcmp(inputtext, "Status", true))
		{
			ItemData[id][e_ITEM_DRUG_LEGAL] = !ItemData[id][e_ITEM_DRUG_LEGAL];
			Item_Save(id);

			Management_ShowItem(playerid, s_pItemSelectID[playerid]);
			Log_Create("Gerenciamento", "%s alterou o status da droga %s para %s", AccountData[playerid][e_ACCOUNT_NAME],  ItemData[id][e_ITEM_NAME], (ItemData[id][e_ITEM_DRUG_LEGAL] ? ("legal") : ("ilegal")));
			SendClientMessageEx(playerid, -1, "SERVER: Você alterou o status da droga %s para %s.", ItemData[id][e_ITEM_NAME], (ItemData[id][e_ITEM_DRUG_LEGAL] ? ("legal") : ("ilegal")));
		}		

		// Efeitos
		else if (!strcmp(inputtext, "Efeitos", true))
		{
			Management_ShowItemDrugEffects(playerid);
		}

		// Dosagem
		else if (!strcmp(inputtext, "Dosagem", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_ITEM_DOSAGE, DIALOG_STYLE_INPUT, title, "Digite a quantidade da dosagem minima abaixo:\nExemplo: 0.01 - significa que a dosagem minima é 0.01g.", "Selecionar", "<<");
		}

		// Tempo de Efeito
		else if (!strcmp(inputtext, "Tempo de efeito", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_DRUG_TIME, DIALOG_STYLE_INPUT, title, "Digite a quantidade em segundos da duração do efeito para a dosagem minima:", "Confirmar", "<<");
		}

		// Efeito visual
		else if (!strcmp(inputtext, "Efeito visual", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_DRUG_WEATHER, DIALOG_STYLE_INPUT, title, "Digite o ID do clima que será o efeito visual ao usar a droga:", "Confirmar", "<<");
		}

		// Hora visual
		else if (!strcmp(inputtext, "Hora visual", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_DRUG_VTIME, DIALOG_STYLE_INPUT, title, "Digite a hora que será do efeito visual ao usar a droga:", "Confirmar", "<<");
		}

		// Skin visual
		else if (!strcmp(inputtext, "Skin visual", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_DRUG_SKIN, DIALOG_STYLE_INPUT, title, "Digite a skin que será do efeito visual ao usar a droga:", "Confirmar", "<<");
		}

		// Cor de veículo
		else if (!strcmp(inputtext, "Cor de veículo visual", true) || !strcmp(inputtext, "Cor de veiculo visual", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_DRUG_VEHCOLOR, DIALOG_STYLE_INPUT, title, "Digite a cor de veículo que será do efeito visual ao usar a droga:", "Confirmar", "<<");
		}

		// Pontos de vício
		else if (!strcmp(inputtext, "Pontos de vício", true) || !strcmp(inputtext, "Pontos de vicio", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_DRUG_ADD, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Especifique quantos pontos de vício esta droga irá dar a cada consumo de dosagem mínima:", "Confirmar", "<<");
		}

		else
		{
			Management_ShowItem(playerid, s_pItemSelectID[playerid]);
		}
	}

	// Pacote, Invólucro, Utensílio
	else if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_DRUGS && (ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_PACKAGE || ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_CASE || ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_UTENSIL))
	{
		if (!strcmp(inputtext, "Drogas permitidas", true))
		{
			Management_ShowItemCaseDrugType(playerid);
		}
		else if (!strcmp(inputtext, "Capacidade", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_CASE_CAP, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Digite a quantidade máxima em gramas permitidas no armazenamento deste item:", "Confirmar", "<<");
		}
		else if (!strcmp(inputtext, "Cigarros", true))
		{
			Dialog_Show(playerid, DIALOG_MNG_CASE_CIG, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Digite a quantidade máxima de cigarros gerados a partir deste item:", "Confirmar", "<<");
		}
		else
		{
			Management_ShowItem(playerid, s_pItemSelectID[playerid]);
		}
	}
	else
	{
		Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	}

	return true;
}

Dialog:DIALOG_MNG_ITEM_NAME(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	for (new i = 0; i < MAX_ITEMS; i++)
	{
		if (!ItemData[i][e_ITEM_EXISTS])
			continue;

		if (!strcmp(ItemData[i][e_ITEM_NAME], inputtext, false))
		{
			Dialog_Show(playerid, DIALOG_MNG_ITEM_NAME, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: O nome de item %s não está disponível.\nDigite o novo nome do item %s. O limite máximo de caracteres é 64.", "Renomear", "<<", inputtext, Item_GetName(s_pItemSelectID[playerid]));
			return false;
		}
	}

	if (!(0 <= strlen(inputtext) <= 64))
	{
		Dialog_Show(playerid, DIALOG_MNG_ITEM_NAME, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: O novo nome não atende aos requisitos.\nDigite o novo nome do item %s. O limite máximo de caracteres é 64.", "Renomear", "<<", Item_GetName(s_pItemSelectID[playerid]));
		return false;
	}

	Log_Create("Gerenciamento", "%s renomeou o item %s para %s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], inputtext);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o nome do item %s para %s.", ItemData[id][e_ITEM_NAME], inputtext);	
	format (ItemData[id][e_ITEM_NAME], 64, inputtext);
	Item_Save(s_pItemSelectID[playerid]);	
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_ITEM_MODEL(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id, model;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", model))
	{
		Dialog_Show(playerid, DIALOG_MNG_ITEM_MODEL, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: Insira um modelo.\nDigite o novo modelo do item %s.", "Alterar", "<<", Item_GetName(s_pItemSelectID[playerid]));
		return false;
	}

	Log_Create("Gerenciamento", "%s alterou o modelo do item %s para %i", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], model);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o modelo do item %s para %i.", ItemData[id][e_ITEM_NAME], model);	
	ItemData[id][e_ITEM_MODEL] = model;
	Item_Save(s_pItemSelectID[playerid]);	
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_ITEM_CAT(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if ((0 <= listitem < MAX_ITEM_CATEGORY))
	{
		ItemData[id][e_ITEM_CATEGORY] = (listitem + 1);

		Log_Create("Gerenciamento", "%s alterou a categoria do item %s para %s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], Item_GetCategoryName(id));
		SendClientMessageEx(playerid, -1, "SERVER: Você alterou o categoria do item %s para %s.", ItemData[id][e_ITEM_NAME], Item_GetCategoryName(id));	
		Item_Save(s_pItemSelectID[playerid]);	
		Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	}

	return true;
}

Dialog:DIALOG_MNG_ITEM_DELETE(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (response)
	{
		Log_Create("Gerenciamento", "%s excluiu o item %s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME]);
		SendClientMessageEx(playerid, -1, "SERVER: Você excluiu o item %s do servidor.", ItemData[id][e_ITEM_NAME]);

		Item_Delete(id);
		Item_ShowList(playerid, Item_GetPlayerPage(playerid));
	}

	return false;
}

Dialog:DIALOG_MNG_ITEM_SUBCAT(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if ((0 <= listitem < MAX_ITEM_SUBCATEGORY))
	{
		ItemData[id][e_ITEM_SUB_CATEGORY] = (listitem + 1);

		Log_Create("Gerenciamento", "%s alterou a subcategoria do item %s para %s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], Item_GetSubCategoryName(id));
		SendClientMessageEx(playerid, -1, "SERVER: Você alterou a subcategoria do item %s para %s.", ItemData[id][e_ITEM_NAME], Item_GetSubCategoryName(id));	
		Item_Save(s_pItemSelectID[playerid]);	
		Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	}

	return true;
}

Dialog:DIALOG_MNG_ITEM_DRUGTYPE(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if ((0 <= listitem < MAX_DRUG_TYPE))
	{
		ItemData[id][e_ITEM_DRUG_TYPE] = listitem + 1;

		Log_Create("Gerenciamento", "%s alterou o tipo da droga %s para %s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], g_arrItemDrugType[listitem + 1]);
		SendClientMessageEx(playerid, -1, "SERVER: Você alterou o tipo da droga %s para %s.", ItemData[id][e_ITEM_NAME], g_arrItemDrugType[listitem + 1]);	
		Item_Save(s_pItemSelectID[playerid]);	
		Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	}

	return true;
}

Dialog:DIALOG_MNG_DRUG_EFFECTS(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if ((0 <= listitem < sizeof g_arrItemDrugEffects))
	{
		new flag = floatround(floatpower(2.0, float(listitem + 1)));

		if (ItemData[id][e_ITEM_DRUG_EFFECTS] & flag)
		{
			Log_Create("Gerenciamento", "%s adicionou o efeito ID %i da droga %s", AccountData[playerid][e_ACCOUNT_NAME], listitem, ItemData[id][e_ITEM_NAME]);
			SendClientMessageEx(playerid, -1, "SERVER: Você adicionou o efeito de %s na droga %s.", g_arrItemDrugEffects[listitem], ItemData[id][e_ITEM_NAME]);
			ItemData[id][e_ITEM_DRUG_EFFECTS] = (ItemData[id][e_ITEM_DRUG_EFFECTS] & ~flag);
		}
		else
		{
			Log_Create("Gerenciamento", "%s removeu o efeito ID %i da droga %s", AccountData[playerid][e_ACCOUNT_NAME], listitem, ItemData[id][e_ITEM_NAME]);
			SendClientMessageEx(playerid, -1, "SERVER: Você removeu o efeito de %s na droga %s.", g_arrItemDrugEffects[listitem], ItemData[id][e_ITEM_NAME]);
			ItemData[id][e_ITEM_DRUG_EFFECTS] |= flag;
		}

		Item_Save(s_pItemSelectID[playerid]);
		Management_ShowItemDrugEffects(playerid);
	}

	return true;
}

Dialog:DIALOG_MNG_ITEM_DOSAGE(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id, Float:dosage;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "f", dosage) || dosage < 0.01)
	{
		Dialog_Show(playerid, DIALOG_MNG_ITEM_DOSAGE, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: A dosagem deve ser no mínima 0.01g/ml\nDigite a quantidade da dosagem minima abaixo:\nExemplo: 0.01 - significa que a dosagem minima é 0.01g.", "Selecionar", "<<");
		return true;
	}

	ItemData[id][e_ITEM_DRUG_DOSAGE] = dosage;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	Log_Create("Gerenciamento", "%s alterou a dosagem mínima da droga %s para %.01f%s", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], dosage, (ItemData[id][e_ITEM_DRUG_TYPE] == DRUG_TYPE_INJECTABLE ? ("ml") : ("g")));
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou a dosagem mínima da droga %s para %.01f%s.", ItemData[id][e_ITEM_NAME], dosage, (ItemData[id][e_ITEM_DRUG_TYPE] == DRUG_TYPE_INJECTABLE ? ("ml") : ("g")));
	return true;
}

Dialog:DIALOG_MNG_DRUG_TIME(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	
	new id, secs;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", secs) || secs < 0)
	{
		Dialog_Show(playerid, DIALOG_MNG_DRUG_TIME, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: O tempo mínima é 1 segundo.\nDigite a quantidade em segundos da duração do efeito para a dosagem minima:", "Confirmar", "<<");
		return true;
	}
	
	Log_Create("Gerenciamento", "%s alterou o tempo de efeito da droga %s para %i segundos", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], secs);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o tempo de efeito da droga %s para %i segundos.", ItemData[id][e_ITEM_NAME], secs);

	ItemData[id][e_ITEM_DRUG_EFFECT_TIME] = secs;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_DRUG_WEATHER(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	
	new id, weather;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", weather) || !(-1 <= weather <= 68))
	{
		Dialog_Show(playerid, DIALOG_MNG_DRUG_WEATHER, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: O clima deve ser de 0 a 68.\nDigite o ID do clima que será o efeito visual ao usar a droga:", "Confirmar", "<<");
		return true;
	}
	
	Log_Create("Gerenciamento", "%s alterou o efeito visual de clima da droga %s para %i", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], weather);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o efeito visual de clima da droga %s para %i.", ItemData[id][e_ITEM_NAME], weather);

	ItemData[id][e_ITEM_DRUG_VISUAL_WEATHER] = weather;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_DRUG_VTIME(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	
	new id, time;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", time) || !(-1 <= time <= 23))
	{
		Dialog_Show(playerid, DIALOG_MNG_DRUG_VTIME, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: A hora deve ser de 0 a 23. (Use -1 para desativar)\nDigite a hora que será do efeito visual ao usar a droga:", "Confirmar", "<<");
		return true;
	}
	
	Log_Create("Gerenciamento", "%s alterou o efeito visual de hora da droga %s para %i", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], time);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o efeito visual de hora da droga %s para %i.", ItemData[id][e_ITEM_NAME], time);

	ItemData[id][e_ITEM_DRUG_VISUAL_TIME] = time;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_DRUG_SKIN(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	
	new id, skin;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", skin) || !(-1 <= skin <= 311) || skin == 74)
	{
		Dialog_Show(playerid, DIALOG_MNG_DRUG_SKIN, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: A skin deve ser de 0 a 311. (Use -1 para desativar)\nDigite a skin que será do efeito visual ao usar a droga:", "Confirmar", "<<");
		return true;
	}
	
	Log_Create("Gerenciamento", "%s alterou o efeito visual de skin da droga %s para %i", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], skin);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o efeito visual de skin da droga %s para %i.", ItemData[id][e_ITEM_NAME], skin);

	ItemData[id][e_ITEM_DRUG_VISUAL_SKIN] = skin;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_DRUG_VEHCOLOR(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	
	new id, color;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", color) || !(-1 <= color <= 128))
	{
		Dialog_Show(playerid, DIALOG_MNG_DRUG_VEHCOLOR, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: A cor deve ser de 0 a 128. (Use -1 para desativar)\nDigite a cor de veículo que será do efeito visual ao usar a droga:", "Confirmar", "<<");
		return true;
	}
	
	Log_Create("Gerenciamento", "%s alterou o efeito visual de cor de veículo da droga %s para %i", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], color);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou o efeito visual de cor de veículo da droga %s para %i.", ItemData[id][e_ITEM_NAME], color);

	ItemData[id][e_ITEM_DRUG_VISUAL_VEH_COLOR] = color;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_DRUG_ADD(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	
	new id, points;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", points) || points < 0)
	{
		Dialog_Show(playerid, DIALOG_MNG_DRUG_ADD, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: Ponto negativo não é válido.\nEspecifique quantos pontos de vício esta droga irá dar a cada consumo de dosagem mínima:", "Confirmar", "<<");
		return true;
	}
	
	Log_Create("Gerenciamento", "%s alterou a quantidade de pontos de vício da droga %s para %i", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], points);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou a quantidade de pontos de vício da droga %s para %i.", ItemData[id][e_ITEM_NAME], points);

	ItemData[id][e_ITEM_DRUG_ADDICTION_POINTS] = points;
	Item_Save(s_pItemSelectID[playerid]);
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_CASE_TYPES(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if ((0 <= listitem < sizeof g_arrItemDrugType))
	{
		new flag = floatround(floatpower(2.0, float(listitem + 1)));

		if (ItemData[id][e_ITEM_CASE_ACCEPT_TYPES] & flag)
		{
			Log_Create("Gerenciamento", "%s tornou as drogas do tipo %s permitidas no item %s", AccountData[playerid][e_ACCOUNT_NAME], g_arrItemDrugType[listitem + 1], ItemData[id][e_ITEM_NAME]);
			SendClientMessageEx(playerid, -1, "SERVER: Você permitiu as drogas do tipo %s no item %s.", g_arrItemDrugType[listitem + 1], ItemData[id][e_ITEM_NAME]);
			ItemData[id][e_ITEM_CASE_ACCEPT_TYPES] = (ItemData[id][e_ITEM_CASE_ACCEPT_TYPES] & ~flag);
		}
		else
		{
			Log_Create("Gerenciamento", "%s tornou as drogas do tipo %s proibidas no item %s", AccountData[playerid][e_ACCOUNT_NAME], g_arrItemDrugType[listitem + 1], ItemData[id][e_ITEM_NAME]);
			SendClientMessageEx(playerid, -1, "SERVER: Você proibiu as drogas do tipo %s no item %s.", g_arrItemDrugType[listitem + 1], ItemData[id][e_ITEM_NAME]);
			ItemData[id][e_ITEM_CASE_ACCEPT_TYPES] |= flag;
		}

		Item_Save(s_pItemSelectID[playerid]);
		Management_ShowItemCaseDrugType(playerid);
	}

	return true;
}

Dialog:DIALOG_MNG_CASE_CAP(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id, cap;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", cap) || cap < 1)
	{
		Dialog_Show(playerid, DIALOG_MNG_CASE_CAP, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: Quantidade inválida.\nDigite a quantidade máxima em gramas permitidas no armazenamento deste item:", "Confirmar", "<<");
		return true;
	}

	ItemData[id][e_ITEM_CASE_CAPACITY] = cap;
	Item_Save(ItemData[id][e_ITEM_ID]);

	Log_Create("Gerenciamento", "%s alterou a capacidade do item %s para %ig.", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], cap);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou a capacidade do item %s para %ig.", ItemData[id][e_ITEM_NAME], cap);		
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_CASE_CIG(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new id, cig;

	if ((id = Management_CheckItem(playerid)) == -1)
		return false;

	if (sscanf(inputtext, "i", cig) || cig < 0 || cig > 20)
	{
		Dialog_Show(playerid, DIALOG_MNG_CASE_CIG, DIALOG_STYLE_INPUT, Management_ItemTitle(playerid), "Erro: Cigarros inválido, use de 0 a 20.\nDigite a quantidade máxima de cigarros gerados a partir deste item:", "Confirmar", "<<");
		return true;
	}

	ItemData[id][e_ITEM_CASE_CIGARRETES] = cig;
	Item_Save(ItemData[id][e_ITEM_ID]);

	Log_Create("Gerenciamento", "%s alterou os cigarros do pacote %s para %i.", AccountData[playerid][e_ACCOUNT_NAME], ItemData[id][e_ITEM_NAME], cig);
	SendClientMessageEx(playerid, -1, "SERVER: Você alterou os cigarros do pacote %s para %i.", ItemData[id][e_ITEM_NAME], cig);		
	Management_ShowItem(playerid, s_pItemSelectID[playerid]);
	return true;
}

Dialog:DIALOG_MNG_USERS_CLOSED(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	if (!strcmp(inputtext, "Adicionar um novo usuário", true) || !strcmp(inputtext, "Adicionar um novo usuario", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_ADD_USER_CB, DIALOG_STYLE_INPUT, "Adicionar um novo usuário", "Digite o nome de usuário à ser adicionado na lista branca da Closed Beta:", "Confirmar", "<<");
	}
	else
	{
		format (s_pUserClosedSelected[playerid], MAX_PLAYER_NAME, inputtext);
		Dialog_Show(playerid, DIALOG_MNG_REM_USER_CB, DIALOG_STYLE_MSGBOX, "Remoção de usuário", "Você deseja remover %s da Closed Beta?", "Confirmar", "<<", s_pUserClosedSelected[playerid]);
	}

	return true;
}

Dialog:DIALOG_MNG_ADD_USER_CB(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowClosedBetaUsers(playerid);

	if (!(3 <= strlen(inputtext) <= MAX_PLAYER_NAME) || strfind(inputtext, " ") != -1 || strfind(inputtext, "_") != -1)
	{
		Dialog_Show(playerid, DIALOG_MNG_ADD_USER_CB, DIALOG_STYLE_INPUT, "Adicionar um novo usuário", "Erro: Nome de usuário inválido.\nDigite o nome de usuário à ser adicionado na lista branca da Closed Beta:", "Confirmar", "<<");
		return true;
	}

	static insertName[MAX_PLAYER_NAME + 1];
	format (insertName, sizeof insertName, inputtext);

	inline ClosedBeta_Add()
	{
		if (!cache_affected_rows())
		{
			SendErrorMessage(playerid, "Não foi possível adicionar %s à lista branca da Closed Beta.", insertName);
		}
		else
		{
			Log_Create("Closed Beta", "%s adicionou %s à lista branca", AccountData[playerid][e_ACCOUNT_NAME], insertName);
			SendClientMessageEx(playerid, -1, "SERVER: Você adicionou %s na lista branca da Closed Beta.", insertName);
		}

		Management_ShowClosedBetaUsers(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline ClosedBeta_Add, "INSERT IGNORE INTO `ClosedBeta` (`Nome`, `Admin`) VALUES ('%e', '%e');", insertName, AccountData[playerid][e_ACCOUNT_NAME]);
	return true;
}

Dialog:DIALOG_MNG_REM_USER_CB(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowClosedBetaUsers(playerid);

	inline ClosedBeta_Remove()
	{
		if (!cache_affected_rows())
		{
			SendErrorMessage(playerid, "Não foi possível remover %s da lista branca da Closed Beta.", s_pUserClosedSelected[playerid]);
		}
		else
		{
			Log_Create("Closed Beta", "%s removeu %s da lista branca", AccountData[playerid][e_ACCOUNT_NAME], s_pUserClosedSelected[playerid]);
			SendClientMessageEx(playerid, -1, "SERVER: Você removeu %s da lista branca da Closed Beta.", s_pUserClosedSelected[playerid]);
		}

		Management_ShowClosedBetaUsers(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline ClosedBeta_Remove, "DELETE IGNORE FROM `ClosedBeta` WHERE `Nome` = '%e' LIMIT 1;", s_pUserClosedSelected[playerid]);
	return true;
}

Dialog:DIALOG_MNG_INT_CAT(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	// Adicionar uma nova categoria
	if (!strcmp(inputtext, "Adicionar uma nova categoria", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_INT_ADD_CAT, DIALOG_STYLE_INPUT, "Adicionar uma nova categoria de interior", "Digite o nome da nova categoria de interior:", "Confirmar", "<<");
	}
	else
	{
		format (s_pInteriorCategorySelect[playerid], 32, inputtext);
		Dialog_Show(playerid, DIALOG_MNG_INT_REM_CAT, DIALOG_STYLE_MSGBOX, "Remover categoria de interior", "Você deseja excluir permanentemente a categoria de interior %s?\nEsta ação também irá remover os interiores criados nesta categoria.", "Confirmar", "<<", inputtext);
	}

	return true;
}

Dialog:DIALOG_MNG_INT_ADD_CAT(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowIntCategories(playerid);

	if (!(1 <= strlen(inputtext) <= 32))
	{	
		Dialog_Show(playerid, DIALOG_MNG_INT_ADD_CAT, DIALOG_STYLE_INPUT, "Adicionar uma nova categoria de interior", "Erro: Nome da categoria deve ter de 1 a 32 caracteres.\nDigite o nome da nova categoria de interior:", "Confirmar", "<<");
		return true;
	}

	new insertName[32];
	format (insertName, sizeof insertName, inputtext);

	inline InteriorCategory_Created()
	{
		if (!cache_affected_rows())
		{
			SendErrorMessage(playerid, "Não foi possível adicionar a categoria %s.", insertName);
		}	
		else
		{
			Log_Create("Interiores", "%s adicionou a categoria %s", AccountData[playerid][e_ACCOUNT_NAME], insertName);
			SendClientMessageEx(playerid, -1, "SERVER: Você adicionou a categoria %s com sucesso.", insertName);
		}

		Management_ShowIntCategories(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline InteriorCategory_Created, "INSERT IGNORE INTO `InteriorCategoria` (`Nome`) VALUES ('%e');", insertName);
	return true;
}

Dialog:DIALOG_MNG_INT_REM_CAT(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowIntCategories(playerid);

	inline InteriorCategory_Removed()
	{
		if (!cache_affected_rows())
		{
			SendErrorMessage(playerid, "Não foi possível remover a categoria %s.", s_pInteriorCategorySelect[playerid]);
		}	
		else
		{
			Log_Create("Interiores", "%s removeu a categoria %s", AccountData[playerid][e_ACCOUNT_NAME], s_pInteriorCategorySelect[playerid]);
			SendClientMessageEx(playerid, -1, "SERVER: Você removeu a categoria %s com sucesso.", s_pInteriorCategorySelect[playerid]);
		}

		Management_ShowIntCategories(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline InteriorCategory_Removed, "DELETE IGNORE FROM `InteriorCategoria` WHERE `Nome` = '%e' LIMIT 1;", s_pInteriorCategorySelect[playerid]);
	return true;
}

Dialog:DIALOG_MNG_INT_CAT_SEL(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	format (s_pInteriorCategorySelect[playerid], 32, inputtext);
	Management_ShowInteriors(playerid);
	return true;
}

Dialog:DIALOG_MNG_INT_LIST(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowIntCategorySel(playerid);

	if (!strcmp(inputtext, "Adicionar um novo interior", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_INT_ADD, DIALOG_STYLE_INPUT, "Adicionar um novo interior", "Digita o nome do novo interior para a categoria %s:", "Confirmar", "<<", "");
	}
	else
	{
		format (s_pInteriorSelect[playerid], 32, inputtext);
		Dialog_Show(playerid, DIALOG_MNG_INTERIOR, DIALOG_STYLE_LIST, s_pInteriorSelect[playerid], "Teleportar-se para o interior\nAlterar posição para a atual\nExcluir interior", "Selecionar", "<<");
	}

	return true;
}

Dialog:DIALOG_MNG_INT_ADD(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowInteriors(playerid);

	if (!(1 <= strlen(inputtext) <= 32))
	{
		Dialog_Show(playerid, DIALOG_MNG_INT_ADD, DIALOG_STYLE_INPUT, "Adicionar um novo interior", "Erro: Nome de interior inválido.\nDigita o nome do novo interior para a categoria %s:", "Confirmar", "<<", "");
		return true;
	}

	new Float:x, Float:y, Float:z, int, insertName[32];
	GetPlayerPos(playerid, x, y, z);
	int = GetPlayerInterior(playerid);
	format (insertName, sizeof insertName, inputtext);

	inline Interior_Add()
	{
		if (!cache_affected_rows())
		{
			SendErrorMessage(playerid, "Não foi possível adicionar o interior %s na categoria %s.", insertName, s_pInteriorCategorySelect[playerid]);
		}
		else
		{
			Log_Create("Interiores", "%s adicionou o interior %s na categoria %s", AccountData[playerid][e_ACCOUNT_NAME], insertName, s_pInteriorCategorySelect[playerid]);
			SendClientMessageEx(playerid, -1, "SERVER: Interior %s adicionado na categoria %s com sucesso.", insertName, s_pInteriorCategorySelect[playerid]);
		}

		Management_ShowInteriors(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interior_Add, "INSERT IGNORE INTO `Interior` (`Nome`, `Categoria`, `PosX`, `PosY`, `PosZ`, `Interior`) VALUES ('%e', '%e', '%f', '%f', '%f', %i);", insertName, s_pInteriorCategorySelect[playerid], x, y, z, int);
	return true;
}

Dialog:DIALOG_MNG_INTERIOR(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowInteriors(playerid);

	if (!strcmp(inputtext, "Teleportar-se para o interior", true))
	{
		inline Interior_GetPos()
		{
			if (cache_num_rows())
			{
				new Float:x, Float:y, Float:z, int;
				cache_get_value_name_float(0, "PosX", x);
				cache_get_value_name_float(0, "PosY", y);
				cache_get_value_name_float(0, "PosZ", z);
				cache_get_value_name_int(0, "Interior", int);

				Character_SetPos(playerid, x, y, z, -1.0, GetPlayerVirtualWorld(playerid), int);
				SendClientMessageEx(playerid, -1, "SERVER: Você foi teleportado para o interior %s da categoria %s.", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
			}
			else
			{
				Dialog_Show(playerid, DIALOG_MNG_INTERIOR, DIALOG_STYLE_LIST, s_pInteriorSelect[playerid], "Teleportar-se para o interior\nAlterar posição para a atual\nExcluir interior", "Selecionar", "<<");
			}
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interior_GetPos, "SELECT * FROM `Interior` WHERE `Nome` = '%e' AND `Categoria` = '%e' LIMIT 1;", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
	}
	else if (!strcmp(inputtext, "Alterar posição para a atual", true) || !strcmp(inputtext, "Alterar posicao para a atual", true))
	{
		new Float:x, Float:y, Float:z, int;
		GetPlayerPos(playerid, x, y, z);
		int = GetPlayerInterior(playerid);

		inline Interior_SetPos()
		{
			if (cache_affected_rows())
			{
				Log_Create("Interiores", "%s atualizou a posição do interior %s da categoria %s", AccountData[playerid][e_ACCOUNT_NAME], s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
				SendClientMessageEx(playerid, -1, "SERVER: Você atualizou a posição do interior %s da categoria %s.", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
			}
			else
			{
				SendErrorMessage(playerid, "Não foi possível atualizar a posição do interior %s da categoria %s.", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
			}

			Dialog_Show(playerid, DIALOG_MNG_INTERIOR, DIALOG_STYLE_LIST, s_pInteriorSelect[playerid], "Teleportar-se para o interior\nAlterar posição para a atual\nExcluir interior", "Selecionar", "<<");
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interior_SetPos, "UPDATE IGNORE `Interior` SET `PosX` = '%f', `PosY` = '%f', `PosZ` = '%f', `Interior` = %i WHERE `Nome` = '%e' AND `Categoria` = '%e' LIMIT 1;", x, y, z, int, s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
	}
	else if (!strcmp(inputtext, "Excluir interior", true))
	{
		Dialog_Show(playerid, DIALOG_MNG_INTERIOR_REM, DIALOG_STYLE_MSGBOX, s_pInteriorSelect[playerid], "Você deseja excluir permanentemente o interior %s da categoria %s?", "Sim", "Não", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
	}
	else
	{
		Dialog_Show(playerid, DIALOG_MNG_INTERIOR, DIALOG_STYLE_LIST, s_pInteriorSelect[playerid], "Teleportar-se para o interior\nAlterar posição para a atual\nExcluir interior", "Selecionar", "<<");
	}
	return true;
}

Dialog:DIALOG_MNG_INTERIOR_REM(playerid, response, listitem, inputtext[])
{
	if (!response) return Dialog_Show(playerid, DIALOG_MNG_INTERIOR, DIALOG_STYLE_LIST, s_pInteriorSelect[playerid], "Teleportar-se para o interior\nAlterar posição para a atual\nExcluir interior", "Selecionar", "<<");

	inline Interior_Remove()
	{
		if (cache_affected_rows())
		{
			Log_Create("Interiores", "%s removeu o interior %s da categoria %s", AccountData[playerid][e_ACCOUNT_NAME], s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
			SendClientMessageEx(playerid, -1, "SERVER: Você removeu o interior %s da categoria %s.", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
		}
		else
		{
			SendErrorMessage(playerid, "Não foi possível excluir o interior %s da categoria %s.", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interior_Remove, "DELETE IGNORE FROM `Interior` WHERE `Nome` = '%e' AND `Categoria` = '%e' LIMIT 1;", s_pInteriorSelect[playerid], s_pInteriorCategorySelect[playerid]);
	return true;
}

Dialog:DIALOG_MNG_BIZ_TYPES(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowDialogMenu(playerid);

	if (0 <= listitem < MAX_BUSINESS_TYPE)
	{
		Management_ShowBizItems(playerid, listitem);
	}
	else
	{
		Management_ShowBizTypes(playerid);
	}

	return true;
}

Dialog:DIALOG_MNG_BIZ_ITEMS(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowBizTypes(playerid);

	if (listitem == 0 || !strcmp(inputtext, "Adicionar item"))
	{
		s_pItemSelectType[playerid] = ITEM_SELECT_TYPE_ADD_BIZ;
		Item_ShowList(playerid, 0);
	}
	else
	{
		new id = Item_GetIDName(inputtext);

		if (id == -1)
		{
			Management_ShowBizItems(playerid, s_pBizTypeSelect[playerid]);
			return SendErrorMessage(playerid, "Este item não é mais válido.");
		}

		s_pBizItemSelect[playerid] = id;
		Dialog_Show(playerid, DIALOG_MNG_BIZ_ITEM_REM, DIALOG_STYLE_MSGBOX, "Remover item", "Você deseja remover o item %s das empresas do tipo %s?", "Confirmar", "<<", Item_GetName(id), g_arrBusinessType[s_pBizTypeSelect[playerid]]);
	}
	return true;
}

Dialog:DIALOG_MNG_BIZ_ITEM_REM(playerid, response, listitem, inputtext[])
{
	if (!response) return Management_ShowBizItems(playerid, s_pBizTypeSelect[playerid]);

	inline BizItem_Remove()
	{
		if (!cache_affected_rows())
			return SendErrorMessage(playerid, "Não foi possível remover o item.");

		Management_ShowBizItems(playerid, s_pBizTypeSelect[playerid]);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline BizItem_Remove, "DELETE IGNORE FROM `EmpresaItens` WHERE `Tipo` = %i AND `Item` = %i LIMIT 1;", s_pBizTypeSelect[playerid], s_pBizItemSelect[playerid]);
	return true;
}

// Function
Management_CheckItem(playerid)
{
	new itemid = Item_GetRealID(s_pItemSelectID[playerid]);

	if (itemid == -1)
	{
		SendErrorMessage(playerid, "O item que você estava editando não é mais válido.");
		Item_ShowList(playerid, Item_GetPlayerPage(playerid));
		return -1;
	}	

	return itemid;
}

Management_ItemTitle(playerid)
{
	new out[64 + 12] = "Gerenciar: ";
	strcat (out, Item_GetName(s_pItemSelectID[playerid]));
	return out;
}

Management_ShowDialogMenu(playerid)
{
	/*static s_dialogBody[] = {
		"{AFAFAF}GERAL\n{FFFFFF}Gerenciar MOTD\n \
		\n{AFAFAF}INVENTÁRIO\n{FFFFFF}Gerenciar categorias de itens\nGerenciar itens\nAdicionar item\n \
		\n{AFAFAF}SISTEMA DE DROGAS\n{FFFFFF}Gerenciar receitas\nGerenciar tiers em facções\n \
		\n{AFAFAF}SISTEMA DE DANOS\n{FFFFFF}Gerenciar sistema de danos\n \
		\n{AFAFAF}MOBÍLIAS\n{FFFFFF}Gerenciar mobilias\nAdicionar mobília\n \
		\n{AFAFAF}EMPRESAS\n{FFFFFF}Gerenciar itens em empresas\nGerenciar skins em lojas de roupas\n \
		\n{AFAFAF}INTERAÇÕES\n{FFFFFF}Gerenciar candidatos nas urnas\nGerenciar acessórios no shopping\nGerenciar veículos na concessionária"
	};*/

	new dialog[1024];

	// Geral
	strcat (dialog, "{BBBBBB}GERAL\t\n{FFFFFF}");
	strcat (dialog, "Gerenciar MOTD\t\n");

	// Closed Beta
	strcat (dialog, "\t\n{BBBBBB}CLOSED BETA\t\n{FFFFFF}");
	strcat (dialog, va_return("Status\t{BBBBBB}%s\n", GetGVarInt("CLOSED_BETA") == 1 ? ("Ativada") : ("Desativada")));
	strcat (dialog, "Gerenciar usuários\t\n");

	// Inventário
	strcat (dialog, "\t\n{BBBBBB}INVENTÁRIO\n{FFFFFF}");
	strcat (dialog, "Gerenciar itens\t\n");
	strcat (dialog, "Adicionar item\t\n");

	// Empresas
	strcat (dialog, "\t\n{BBBBBB}EMPRESAS\n{FFFFFF}");
	strcat (dialog, "Gerenciar itens disponíveis\t\n");

	// Interiores
	strcat (dialog, "\t\n{BBBBBB}INTERIORES\n{FFFFFF}");
	strcat (dialog, "Gerenciar categorias de interiores\t\n");
	strcat (dialog, "Gerenciar interiores\t");

	return Dialog_Show(playerid, DIALOG_MANAGE_HOME, DIALOG_STYLE_TABLIST, "Gerenciar Servidor", dialog, "Selecionar", "Fechar");
}

Management_ShowItem(playerid, idx)
{
	new id = Item_GetRealID(idx);

	if (!(0 <= id < MAX_ITEMS) || !ItemData[id][e_ITEM_EXISTS])
		return false;

	if (id == -1)
		return false;

	s_pItemSelectID[playerid] = ItemData[id][e_ITEM_ID];

	new title[12 + 64], body[1024];

	format (title, sizeof title, "Gerenciar: %s", ItemData[id][e_ITEM_NAME]);
	
	format (body, sizeof body, "Opção\t\n");
	strcat (body, va_return("Renomear item\t{BBBBBB}%s\n", ItemData[id][e_ITEM_NAME]));
	strcat (body, va_return("Alterar modelo\t{BBBBBB}%i\n", ItemData[id][e_ITEM_MODEL]));
	strcat (body, va_return("Alterar categoria\t{BBBBBB}%s\n", Item_GetCategoryName(id)));
	strcat (body, va_return("Item pesado\t{BBBBBB}%s\n", ItemData[id][e_ITEM_IS_HEAVY] ? ("Sim") : ("Não")));
	
	if (ItemData[id][e_ITEM_IS_HEAVY])
	{
		strcat (body, "Posição do item na mão direita\n");
	}

	strcat (body, "Excluir item\n");

	// Opção de alterar subcategoria
	if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_DRUGS || ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_BEVERAGES || ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_FOOD)
	{
		strcat (body, va_return("\n\t\nAlterar subcategoria\t{BBBBBB}%s\n", Item_GetSubCategoryName(id)));
	}

	// Sistema de Drogas
	if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_DRUGS)
	{
		switch (ItemData[id][e_ITEM_SUB_CATEGORY])
		{
			// Droga
			case ITEM_SUBCATEGORY_DRUG:
			{
				strcat (body, va_return("Tipo\t{BBBBBB}%s\n", Item_GetDrugTypeName(id)));
				strcat (body, va_return("Status\t{BBBBBB}%s\n", ItemData[id][e_ITEM_DRUG_LEGAL] ? ("Legal") : ("Ilegal")));

				new effects = Item_GetDrugEffectCount(id);
				strcat (body, va_return("Efeitos\t{BBBBBB}%i efeito%s\n", effects, effects < 2 ? ("") : ("s")));

				strcat (body, va_return("Dosagem\t{BBBBBB}%.01f%s\n", ItemData[id][e_ITEM_DRUG_DOSAGE], ItemData[id][e_ITEM_DRUG_TYPE] == DRUG_TYPE_INJECTABLE ? ("ml") : ("g")));
				strcat (body, va_return("Tempo de efeito\t{BBBBBB}%i segundos\n", ItemData[id][e_ITEM_DRUG_EFFECT_TIME]));

				if (ItemData[id][e_ITEM_DRUG_EFFECTS] & DRUG_EFFECT_VISUAL)
				{
					if (ItemData[id][e_ITEM_DRUG_VISUAL_WEATHER] == -1)
					{
						strcat (body, "Efeito visual\t{BBBBBB}Desativado\n");
					}
					else
					{
						strcat (body, va_return("Efeito visual\t{BBBBBB}Clima %i\n", ItemData[id][e_ITEM_DRUG_VISUAL_WEATHER]));
					}

					if (ItemData[id][e_ITEM_DRUG_VISUAL_TIME] == -1)
					{
						strcat (body, "Hora visual\t{BBBBBB}Desativado\n");
					}
					else
					{
						strcat (body, va_return("Hora visual\t{BBBBBB}%02i:00\n", ItemData[id][e_ITEM_DRUG_VISUAL_TIME]));
					}

					if (ItemData[id][e_ITEM_DRUG_VISUAL_SKIN] == -1)
					{
						strcat (body, "Skin visual\t{BBBBBB}Desativado\n");
					}
					else
					{
						strcat (body, va_return("Skin visual\t{BBBBBB}%s %i\n", ReturnSkinName(ItemData[id][e_ITEM_DRUG_VISUAL_SKIN]), ItemData[id][e_ITEM_DRUG_VISUAL_SKIN]));
					}

					if (ItemData[id][e_ITEM_DRUG_VISUAL_VEH_COLOR] == -1)
					{
						strcat (body, "Cor de veículo visual\t{BBBBBB}Desativado\n");
					}
					else
					{
						strcat (body, va_return("Cor de veículo visual\t{BBBBBB}%i\n", ItemData[id][e_ITEM_DRUG_VISUAL_VEH_COLOR]));
					}
				}

				if (ItemData[id][e_ITEM_DRUG_EFFECTS] & DRUG_EFFECT_ADDICTION)
				{
					strcat (body, va_return("Pontos de vício\t{BBBBBB}%i ponto%s", ItemData[id][e_ITEM_DRUG_ADDICTION_POINTS], ItemData[id][e_ITEM_DRUG_ADDICTION_POINTS] < 2 ? ("") : ("s")));
				}
			}

			// Pacote, Utensílio, Invólucro
			case ITEM_SUBCATEGORY_UTENSIL, ITEM_SUBCATEGORY_CASE, ITEM_SUBCATEGORY_PACKAGE:
			{
				strcat (body, "Drogas permitidas\t\n");
				strcat (body, va_return("Capacidade\t{BBBBBB}%i%s\n", ItemData[id][e_ITEM_CASE_CAPACITY], ItemData[id][e_ITEM_CASE_ACCEPT_TYPES] & DRUG_CASE_INJECTABLE ? ("ml") : ("g")));
			
				if (ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_PACKAGE)
				{
					strcat (body, va_return("Cigarros\t{BBBBBB}%i unidade%s\n", ItemData[id][e_ITEM_CASE_CIGARRETES], ItemData[id][e_ITEM_CASE_CIGARRETES] > 1 ? ("s") : ("")));
				}
			}

			// Sementes
			case ITEM_SUBCATEGORY_SEED:
			{
				strcat (body, va_return("Quantidade de sementes\t{BBBBBB}%i\n", ItemData[id][e_ITEM_SEED_AMOUNT]));
				strcat (body, "Tempo de crescimento\t\n");
				strcat (body, va_return("Droga\t{BBBBBB}%s\n", Item_GetName(ItemData[id][e_ITEM_SEED_DRUG_REWARD])));
				strcat (body, va_return("Quantidade de droga\t{BBBBBB}%i\n", ItemData[id][e_ITEM_SEED_DRUG_REWARD_AMOUNT]));
				strcat (body, va_return("Ingrediente colhido\t{BBBBBB}%s\n", Item_GetName(ItemData[id][e_ITEM_SEED_INGREDIENT])));
				strcat (body, va_return("Porcentagem de ingrediente\t{BBBBBB}%i%%\n", ItemData[id][e_ITEM_SEED_INGREDIENT_PERCENT]));
			}

			// Remédio
			case ITEM_SUBCATEGORY_PAINKILLER:
			{
				strcat (body, va_return("Dosagem\t{BBBBBB}%.0f pílula%s\n", ItemData[id][e_ITEM_DRUG_DOSAGE], ItemData[id][e_ITEM_DRUG_DOSAGE] < 2 ? ("") : ("s")));

				new painkillerDrugCount = Item_GetDrugPainkillerCount(id);

				if (!painkillerDrugCount)
				{
					strcat (body, "Poder de cura\t{BBBBBB}Nenhuma droga\n");
				}
				else
				{
					strcat (body, va_return("Poder de cura\t{BBBBBB}%i droga%s\n", painkillerDrugCount, painkillerDrugCount < 2 ? ("") : ("s")));
				}
			}
		}
	}

	// Bebidas
	else if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_BEVERAGES)
	{
		switch (ItemData[id][e_ITEM_SUB_CATEGORY])
		{
			case ITEM_SUBCATEGORY_DRINK:
			{
				strcat (body, va_return("Teor alcoólico\t{BBBBBB}%s\n", GetAlcoholTeor(ItemData[id][e_ITEM_DRINK_ALCOHOL])));
				strcat (body, va_return("Item gerado após consumo\t{BBBBBB}%s\n", Item_GetName(ItemData[id][e_ITEM_DRINK_GEN_ITEM])));
				strcat (body, va_return("Pontos de saciedade\t{BBBBBB}%i ponto%s\n", ItemData[id][e_ITEM_DRINK_INDULGE], ItemData[id][e_ITEM_DRINK_INDULGE] < 2 ? ("") : ("s")));
			}

			case ITEM_SUBCATEGORY_BURDEN:
			{
				strcat (body, va_return("Item gerado\t{BBBBBB}%s\n", Item_GetName(ItemData[id][e_ITEM_BURDEN_GENERATE])));

				if (Item_GetRealID(ItemData[id][e_ITEM_BURDEN_GENERATE]) == -1)
				{
					strcat (body, "Quantidade máxima gerada\t{BBBBBB}Nenhuma\n");
				}
				else
				{
					strcat (body, va_return("Quantidade máxima gerada\t{BBBBBB}%i de %s\n", ItemData[id][e_ITEM_BURDEN_MAX_GENERATE], Item_GetName(ItemData[id][e_ITEM_BURDEN_GENERATE])));
				}
			}
		}
	}

	// Comidas
	else if (ItemData[id][e_ITEM_CATEGORY] == ITEM_CATEGORY_FOOD)
	{
		switch (ItemData[id][e_ITEM_SUB_CATEGORY])
		{
			case ITEM_SUBCATEGORY_FOOD:
			{
				strcat (body, va_return("Item gerado após consumo\t{BBBBBB}%s\n", Item_GetName(ItemData[id][e_ITEM_FOOD_GEN_ITEM])));
				strcat (body, va_return("Pontos de saciedade\t{BBBBBB}%i ponto%s\n", ItemData[id][e_ITEM_FOOD_INDULGE], ItemData[id][e_ITEM_FOOD_INDULGE] < 2 ? ("") : ("s")));
			}

			case ITEM_SUBCATEGORY_BURDEN:
			{
				strcat (body, va_return("Item gerado\t{BBBBBB}%s\n", Item_GetName(ItemData[id][e_ITEM_BURDEN_GENERATE])));

				if (Item_GetRealID(ItemData[id][e_ITEM_BURDEN_GENERATE]) == -1)
				{
					strcat (body, "Quantidade máxima gerada\t{BBBBBB}Nenhuma\n");
				}
				else
				{
					strcat (body, va_return("Quantidade máxima gerada\t{BBBBBB}%i de %s\n", ItemData[id][e_ITEM_BURDEN_MAX_GENERATE], Item_GetName(ItemData[id][e_ITEM_BURDEN_GENERATE])));
				}
			}
		}
	}

	Dialog_Show(playerid, DIALOG_MNG_ITEM, DIALOG_STYLE_TABLIST_HEADERS, title, body, "Selecionar", "<<");
	return true;
}

Management_ShowItemDrugEffects(playerid)
{
	new id = Management_CheckItem(playerid);

	if (id == -1)
		return false;

	if (ItemData[id][e_ITEM_CATEGORY] != ITEM_CATEGORY_DRUGS && ItemData[id][e_ITEM_SUB_CATEGORY] != ITEM_SUBCATEGORY_DRUG)
		return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new body[4096];

	for (new i = 0; i < sizeof g_arrItemDrugEffects; i++)
	{
		strcat (body, i > 0 ? ("\n") : (""));

		if (ItemData[id][e_ITEM_DRUG_EFFECTS] & floatround(floatpower(2.0, float(i + 1))))
		{
			strcat(body, " {BBBBBB}[Ativo] ");
		}

		strcat (body, g_arrItemDrugEffects[i]);
	}

	Dialog_Show(playerid, DIALOG_MNG_DRUG_EFFECTS, DIALOG_STYLE_LIST, Management_ItemTitle(playerid), body, "Selecionar", "<<");
	return true;
}

Management_ShowItemCaseDrugType(playerid)
{
	new id = Management_CheckItem(playerid);

	if (id == -1)
		return false;

	if (ItemData[id][e_ITEM_CATEGORY] != ITEM_CATEGORY_DRUGS && ItemData[id][e_ITEM_SUB_CATEGORY] != ITEM_SUBCATEGORY_UTENSIL && ItemData[id][e_ITEM_SUB_CATEGORY] != ITEM_SUBCATEGORY_PACKAGE && ItemData[id][e_ITEM_SUB_CATEGORY] == ITEM_SUBCATEGORY_CASE)
		return Management_ShowItem(playerid, s_pItemSelectID[playerid]);

	new body[256 + 128];

	for (new i = 1; i < sizeof g_arrItemDrugType; i++)
	{
		strcat (body, i > 0 ? ("\n") : (""));

		if (ItemData[id][e_ITEM_CASE_ACCEPT_TYPES] & floatround(floatpower(2.0, float(i))))
		{
			strcat(body, "{BBBBBB}[Permitido] {FFFFFF}");
		}

		strcat (body, g_arrItemDrugType[i]);
	}

	Dialog_Show(playerid, DIALOG_MNG_CASE_TYPES, DIALOG_STYLE_LIST, Management_ItemTitle(playerid), body, "Selecionar", "<<");
	return true;
}

Management_ShowClosedBetaUsers(playerid)
{
	new dialog[2056];

	dialog = "Usuário\tAdministrador\tData\n{BBBBBB}Adicionar um novo usuário\t\t";

	inline ClosedBeta_FetchUsers()
	{
		new rows = cache_num_rows();

		if (rows)
		{
			new user[MAX_PLAYER_NAME + 1], admin[MAX_PLAYER_NAME + 1], date[16 + 1];

			for (new i = 0; i < rows; i++)
			{
				cache_get_value_name(i, "Nome", user);
				cache_get_value_name(i, "Admin", admin);
				cache_get_value_name(i, "Data", date);

				strcat (dialog, "\n");
				strcat (dialog, user);

				strcat (dialog, "\t");
				strcat (dialog, admin);

				strcat (dialog, "\t");
				strcat (dialog, date);
			}
		}
		
		Dialog_Show(playerid, DIALOG_MNG_USERS_CLOSED, DIALOG_STYLE_TABLIST_HEADERS, "Gerenciar usuários", dialog, "Selecionar", "<<");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline ClosedBeta_FetchUsers, "SELECT `Nome`, `Admin`, DATE_FORMAT(`Data`, '%%d/%%m/%%Y') AS `Data` FROM `ClosedBeta` ORDER BY `Nome` ASC, `Data` ASC;");
	return true;
}

Management_ShowIntCategories(playerid)
{
	new dialog[1024];

	dialog = "{BBBBBB}Adicionar uma nova categoria";

	inline Category_List()
	{
		new rows = cache_num_rows();

		if (rows)
		{
			static value[32 + 1];

			for (new i = 0; i < rows; i++)
			{
				cache_get_value_name(i, "Nome", value);
				strcat(dialog, "\n");
				strcat(dialog, value);
			}
		}
		
		Dialog_Show(playerid, DIALOG_MNG_INT_CAT, DIALOG_STYLE_LIST, "Gerenciar categorias de interiores", dialog, "Selecionar", "<<");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Category_List, "SELECT `Nome` FROM `InteriorCategoria` ORDER BY `Nome` ASC;");
	return true;
}

Management_ShowIntCategorySel(playerid)
{
	new dialog[1024];

	inline Category_List()
	{
		new rows = cache_num_rows();

		if (rows)
		{
			static value[32 + 1];

			for (new i = 0; i < rows; i++)
			{
				cache_get_value_name(i, "Nome", value);
				
				strcat(dialog, i > 0 ? ("\n") : (""));
				strcat(dialog, value);
			}
		}
		else
		{
			SendErrorMessage(playerid, "Nenhuma categoria de interior criada.");
			Management_ShowDialogMenu(playerid);
			return true;
		}
		
		Dialog_Show(playerid, DIALOG_MNG_INT_CAT_SEL, DIALOG_STYLE_LIST, "Gerenciar interiores", dialog, "Selecionar", "<<");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Category_List, "SELECT `Nome` FROM `InteriorCategoria` ORDER BY `Nome` ASC;");
	return true;
}

Management_ShowInteriors(playerid)
{
	new dialog[1024];

	dialog = "{BBBBBB}Adicionar um novo interior";

	inline Interior_List()
	{
		new rows = cache_num_rows();

		if (rows)
		{
			static value[32 + 1];

			for (new i = 0; i < rows; i++)
			{
				cache_get_value_name(i, "Nome", value);

				strcat(dialog, "\n");
				strcat(dialog, value);
			}
		}
		
		Dialog_Show(playerid, DIALOG_MNG_INT_LIST, DIALOG_STYLE_LIST, s_pInteriorCategorySelect[playerid], dialog, "Selecionar", "<<");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Interior_List, "SELECT `Nome` FROM `Interior` WHERE `Categoria` = '%e' ORDER BY `Nome` ASC;", s_pInteriorCategorySelect[playerid]);
	return true;
}

Management_ShowBizTypes(playerid)
{
	new dialog[1024];

	for (new i = 0; i < MAX_BUSINESS_TYPE; i++)
	{
		strcat (dialog, i > 0 ? ("\n") : (""));
		strcat (dialog, g_arrBusinessType[i]);
	}

	Dialog_Show(playerid, DIALOG_MNG_BIZ_TYPES, DIALOG_STYLE_LIST, "Gerenciar itens disponíveis", dialog, "Selecionar", "<<");
	return true;
}

Management_ShowBizItems(playerid, type)
{
	if (!(0 <= type < MAX_BUSINESS_TYPE))
		return Management_ShowBizTypes(playerid);

	new dialog[1024], title[32];

	format (title, sizeof title, "Itens: %s", g_arrBusinessType[type]);
	format (dialog, sizeof dialog, "{BBBBBB}Adicionar item");

	inline BizItems_Fetch()
	{
		new rows = cache_num_rows(), item;

		for (new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "Item", item);

			strcat (dialog, "\n");
			strcat (dialog, Item_GetName(item));
		}

		Dialog_Show(playerid, DIALOG_MNG_BIZ_ITEMS, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	}

	s_pBizTypeSelect[playerid] = type;
	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline BizItems_Fetch, "SELECT `Item` FROM `EmpresaItens` WHERE `Tipo` = %i;", type);
	return true;
}