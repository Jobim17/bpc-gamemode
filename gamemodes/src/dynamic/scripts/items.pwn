/*
	ooooo     .                                     .oooooo..o                          .
	`888'   .o8                                    d8P'    `Y8                        .o8
	 888  .o888oo  .ooooo.  ooo. .oo.  .oo.        Y88bo.      oooo    ooo  .oooo.o .o888oo  .ooooo.  ooo. .oo.  .oo.
	 888    888   d88' `88b `888P"Y88bP"Y88b        `"Y8888o.   `88.  .8'  d88(  "8   888   d88' `88b `888P"Y88bP"Y88b
	 888    888   888ooo888  888   888   888            `"Y88b   `88..8'   `"Y88b.    888   888ooo888  888   888   888
	 888    888 . 888    .o  888   888   888       oo     .d8P    `888'    o.  )88b   888 . 888    .o  888   888   888
	o888o   "888" `Y8bod8P' o888o o888o o888o      8""88888P'      .8'     8""888P'   "888" `Y8bod8P' o888o o888o o888o
	                                                           .o..P'
	                                                           `Y8P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Constant
#define MAX_ITEM_LIST 50

// Variáveis
static s_pItemList[MAX_PLAYERS][MAX_ITEM_LIST];
static s_pItemListPage[MAX_PLAYERS] = {0, ...};

// Functions
Item_Load(extraid = INVALID_PLAYER_ID)
{
	inline Item_OnLoaded()
	{
		new rows = cache_num_rows();

		for (new i = 0; i < MAX_ITEMS; i++)
		{
			if (i >= rows)
			{
				ItemData[i] = ItemData[MAX_ITEMS];
				continue;
			}

			// Get values
			cache_get_value_name_int(i, "ID", ItemData[i][e_ITEM_ID]);
			cache_get_value_name(i, "Nome", ItemData[i][e_ITEM_NAME]);
			cache_get_value_name_int(i, "Modelo", ItemData[i][e_ITEM_MODEL]);
			cache_get_value_name_int(i, "Categoria", ItemData[i][e_ITEM_CATEGORY]);
			cache_get_value_name_int(i, "Sub-categoria", ItemData[i][e_ITEM_SUB_CATEGORY]);
			cache_get_value_name_bool(i, "ItemPesado", ItemData[i][e_ITEM_IS_HEAVY]);

			// Hand off set
			new Float:offSets[9], offSetOut[128];
			cache_get_value_name(i, "OffsetAttach", offSetOut);

			sscanf(offSetOut, va_return("p<|>A<f>(0.0, 0.0)[%i]", sizeof offSets), offSets);
			ItemData[i][e_ITEM_ATTACH_OFFSET] = offSets;

			// Droga
			cache_get_value_name_int(i, "DrogaTipo", ItemData[i][e_ITEM_DRUG_TYPE]);
			cache_get_value_name_float(i, "DrogaDosagem", ItemData[i][e_ITEM_DRUG_DOSAGE]);
			cache_get_value_name_int(i, "DrogaEfeitos", ItemData[i][e_ITEM_DRUG_EFFECTS]);
			cache_get_value_name_int(i, "DrogaTempoEfeito", ItemData[i][e_ITEM_DRUG_EFFECT_TIME]);
			cache_get_value_name_int(i, "DrogaClima", ItemData[i][e_ITEM_DRUG_VISUAL_WEATHER]);
			cache_get_value_name_int(i, "DrogaHora", ItemData[i][e_ITEM_DRUG_VISUAL_TIME]);
			cache_get_value_name_int(i, "DrogaSkin", ItemData[i][e_ITEM_DRUG_VISUAL_SKIN]);
			cache_get_value_name_int(i, "DrogaCorVeículo", ItemData[i][e_ITEM_DRUG_VISUAL_VEH_COLOR]);
			cache_get_value_name_int(i, "DrogaPontosVicio", ItemData[i][e_ITEM_DRUG_ADDICTION_POINTS]);
			cache_get_value_name_bool(i, "DrogaLegal", ItemData[i][e_ITEM_DRUG_LEGAL]);

			// Utensílio, Pacote, Invólucro
			cache_get_value_name_int(i, "CaseCapacidade", ItemData[i][e_ITEM_CASE_CAPACITY]);
			cache_get_value_name_int(i, "CaseCompatível", ItemData[i][e_ITEM_CASE_ACCEPT_TYPES]);
			cache_get_value_name_int(i, "CaseCigarros", ItemData[i][e_ITEM_CASE_CIGARRETES]);

			// Sementes
			cache_get_value_name_int(i, "SementeRequerida", ItemData[i][e_ITEM_SEED_AMOUNT]);
			cache_get_value_name_int(i, "SementeDrogaGerada", ItemData[i][e_ITEM_SEED_DRUG_REWARD]);
			cache_get_value_name_int(i, "SementeQuantidadeGerada", ItemData[i][e_ITEM_SEED_DRUG_REWARD_AMOUNT]);
			cache_get_value_name_int(i, "SementeIngredienteGerado", ItemData[i][e_ITEM_SEED_INGREDIENT]);
			cache_get_value_name_int(i, "SementeIngredientePorcento", ItemData[i][e_ITEM_SEED_INGREDIENT_PERCENT]);
			cache_get_value_name_int(i, "SementeTempoCrescimento", ItemData[i][e_ITEM_SEED_GROWTH_TIME]);
			cache_get_value_name_int(i, "SementeTempoAmadurecimento", ItemData[i][e_ITEM_SEED_MATURING_TIME]);
			cache_get_value_name_int(i, "SementeTempoMorte", ItemData[i][e_ITEM_SEED_DEATH_TIME]);

			// Remédios
			new painkillerDrugs[MAX_PAINKILLER_DRUGS], painkillerOut[128];
			cache_get_value_name(i, "RemédioDrogas", painkillerOut);

			sscanf(painkillerOut, "p<|>A<i>(0, 0)["#MAX_PAINKILLER_DRUGS"]", painkillerDrugs);
			ItemData[i][e_ITEM_PAINKILLER_DRUGS] = painkillerDrugs;

			// Fardo
			cache_get_value_name_int(i, "FardoItem", ItemData[i][e_ITEM_BURDEN_GENERATE]);
			cache_get_value_name_int(i, "FardoMaxItem", ItemData[i][e_ITEM_BURDEN_MAX_GENERATE]);

			// Bebidas
			cache_get_value_name_int(i, "BebidaTeorAlcoólico", ItemData[i][e_ITEM_DRINK_ALCOHOL]);
			cache_get_value_name_int(i, "BebidaSaciez", ItemData[i][e_ITEM_DRINK_INDULGE]);
			cache_get_value_name_int(i, "BebidaItemGerado", ItemData[i][e_ITEM_DRINK_GEN_ITEM]);
			
			// Comidas			
			cache_get_value_name_int(i, "ComidaSaciez", ItemData[i][e_ITEM_FOOD_INDULGE]);
			cache_get_value_name_int(i, "ComidaItemGerado", ItemData[i][e_ITEM_FOOD_GEN_ITEM]);

			ItemData[i][e_ITEM_EXISTS] = true;
		}

		if (extraid == -1)
		{
			if (rows)
			{
				printf("[Items] Loaded %i items.", rows);
			}
			else
			{
				print("[Items] No items to load.");
			}
		}
		else
		{
			if (extraid != INVALID_PLAYER_ID && IsPlayerConnected(extraid) && IsPlayerLogged(extraid))
			{
				Item_ShowList(extraid, 0);
			}
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Item_OnLoaded, "SELECT * FROM `Itens` ORDER BY `Categoria` ASC, `Sub-categoria` ASC, `ID` DESC LIMIT %i;", MAX_ITEMS);
	return true;
}

Item_Save(id)
{
	id = Item_GetRealID(id);

	if (id == -1)
		return false;

	inline Item_OnSaved() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE,
		using inline Item_OnSaved,
		"UPDATE IGNORE `Itens` SET \
		`Nome`='%e',\
		`Modelo`=%i,\
		`Categoria`=%i,\
		`Sub-categoria`=%i,\
		`ItemPesado`=%i,\
		`OffsetAttach`='%.03f|%.03f|%.03f|%.03f|%.03f|%.03f|%.03f|%.03f|%.03f',\
		`DrogaTipo`=%i,\
		`DrogaDosagem`='%.03f',\
		`DrogaEfeitos`=%i,\
		`DrogaTempoEfeito`=%i,\
		`DrogaClima`=%i,\
		`DrogaHora`=%i,\
		`DrogaSkin`=%i,\
		`DrogaCorVeículo`=%i,\
		`DrogaPontosVicio`=%i,\
		`DrogaLegal`=%i,\
		`CaseCapacidade`=%i,\
		`CaseCompatível`=%i,\
		`CaseCigarros`=%i,\
		`SementeRequerida`=%i,\
		`SementeDrogaGerada`=%i,\
		`SementeQuantidadeGerada`=%i,\
		`SementeIngredienteGerado`=%i,\
		`SementeIngredientePorcento`=%i,\
		`SementeTempoCrescimento`=%i,\
		`SementeTempoAmadurecimento`=%i,\
		`SementeTempoMorte`=%i,\
		`RemédioDrogas`='%i|%i|%i|%i|%i',\
		`FardoItem`=%i,\
		`FardoMaxItem`=%i,\
		`BebidaTeorAlcoólico`=%i,\
		`BebidaSaciez`=%i,\
		`BebidaItemGerado`=%i,\
		`ComidaSaciez`=%i,\
		`ComidaItemGerado`=%i \
		WHERE `ID` = %i LIMIT 1;",
		ItemData[id][e_ITEM_NAME],
		ItemData[id][e_ITEM_MODEL],
		ItemData[id][e_ITEM_CATEGORY],
		ItemData[id][e_ITEM_SUB_CATEGORY],
		ItemData[id][e_ITEM_IS_HEAVY],
		ItemData[id][e_ITEM_ATTACH_OFFSET][0],
		ItemData[id][e_ITEM_ATTACH_OFFSET][1],
		ItemData[id][e_ITEM_ATTACH_OFFSET][2],
		ItemData[id][e_ITEM_ATTACH_OFFSET][3],
		ItemData[id][e_ITEM_ATTACH_OFFSET][4],
		ItemData[id][e_ITEM_ATTACH_OFFSET][5],
		ItemData[id][e_ITEM_ATTACH_OFFSET][6],
		ItemData[id][e_ITEM_ATTACH_OFFSET][7],
		ItemData[id][e_ITEM_ATTACH_OFFSET][8],
		ItemData[id][e_ITEM_DRUG_TYPE],
		ItemData[id][e_ITEM_DRUG_DOSAGE],
		ItemData[id][e_ITEM_DRUG_EFFECTS],
		ItemData[id][e_ITEM_DRUG_EFFECT_TIME],
		ItemData[id][e_ITEM_DRUG_VISUAL_WEATHER],
		ItemData[id][e_ITEM_DRUG_VISUAL_TIME],
		ItemData[id][e_ITEM_DRUG_VISUAL_SKIN],
		ItemData[id][e_ITEM_DRUG_VISUAL_VEH_COLOR],
		ItemData[id][e_ITEM_DRUG_ADDICTION_POINTS],
		ItemData[id][e_ITEM_DRUG_LEGAL],
		ItemData[id][e_ITEM_CASE_CAPACITY],
		ItemData[id][e_ITEM_CASE_ACCEPT_TYPES],
		ItemData[id][e_ITEM_CASE_CIGARRETES],
		ItemData[id][e_ITEM_SEED_AMOUNT],
		ItemData[id][e_ITEM_SEED_DRUG_REWARD],
		ItemData[id][e_ITEM_SEED_DRUG_REWARD_AMOUNT],
		ItemData[id][e_ITEM_SEED_INGREDIENT],
		ItemData[id][e_ITEM_SEED_INGREDIENT_PERCENT],
		ItemData[id][e_ITEM_SEED_GROWTH_TIME],
		ItemData[id][e_ITEM_SEED_MATURING_TIME],
		ItemData[id][e_ITEM_SEED_DEATH_TIME],
		ItemData[id][e_ITEM_PAINKILLER_DRUGS][0],
		ItemData[id][e_ITEM_PAINKILLER_DRUGS][1],
		ItemData[id][e_ITEM_PAINKILLER_DRUGS][2],
		ItemData[id][e_ITEM_PAINKILLER_DRUGS][3],
		ItemData[id][e_ITEM_PAINKILLER_DRUGS][4],
		ItemData[id][e_ITEM_BURDEN_GENERATE],
		ItemData[id][e_ITEM_BURDEN_MAX_GENERATE],
		ItemData[id][e_ITEM_DRINK_ALCOHOL],
		ItemData[id][e_ITEM_DRINK_INDULGE],
		ItemData[id][e_ITEM_DRINK_GEN_ITEM],	
		ItemData[id][e_ITEM_FOOD_INDULGE],
		ItemData[id][e_ITEM_FOOD_GEN_ITEM],
		ItemData[id][e_ITEM_ID]
	);

	return true;
}

Item_Delete(id)
{
	if (!(0 <= id < MAX_ITEMS) || !ItemData[id][e_ITEM_EXISTS])
		return false;

	new query[128];
	mysql_format(MYSQL_CUR_HANDLE, query, sizeof query, "DELETE FROM `Itens` WHERE `ID` = %i LIMIT 1;", ItemData[id][e_ITEM_ID]);
	mysql_query(MYSQL_CUR_HANDLE, query);

	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
			continue;

		Inventory_Load(i); // Isso atualiza o inventário do jogador
	}

	ItemData[id] = ItemData[MAX_ITEMS];
	Item_Load();
	return true;
}

Item_GetCategoryName(itemid)
{
	new 
		ret[16 + 1] = "Inválida";

	if (!(0 <= itemid < MAX_ITEMS) || !ItemData[itemid][e_ITEM_EXISTS])
		return ret;

	if ((0 <= ItemData[itemid][e_ITEM_CATEGORY] < MAX_ITEM_CATEGORY))
	{
		format (ret, sizeof ret, g_arrItemCategory[ItemData[itemid][e_ITEM_CATEGORY]]);
	}

	return ret;
}

Item_GetSubCategoryName(itemid)
{
	new 
		ret[16 + 1] = "Inválida";

	if (!(0 <= itemid < MAX_ITEMS) || !ItemData[itemid][e_ITEM_EXISTS])
		return ret;

	if ((0 <= ItemData[itemid][e_ITEM_SUB_CATEGORY] < MAX_ITEM_SUBCATEGORY))
	{
		format (ret, sizeof ret, g_arrItemSubCategory[ItemData[itemid][e_ITEM_SUB_CATEGORY]]);
	}

	return ret;
}

Item_GetDrugTypeName(itemid)
{
	new 
		ret[16 + 1] = "Inválida";

	if (!(0 <= itemid < MAX_ITEMS) || !ItemData[itemid][e_ITEM_EXISTS])
		return ret;

	if ((0 <= ItemData[itemid][e_ITEM_DRUG_TYPE] < MAX_DRUG_TYPE))
	{
		format (ret, sizeof ret, g_arrItemDrugType[ItemData[itemid][e_ITEM_DRUG_TYPE]]);
	}

	return ret;
}

Item_GetDrugEffectCount(itemid)
{
	if (!(0 <= itemid < MAX_ITEMS) || !ItemData[itemid][e_ITEM_EXISTS])
		return 0;

	if (ItemData[itemid][e_ITEM_CATEGORY] != ITEM_CATEGORY_DRUGS || ItemData[itemid][e_ITEM_SUB_CATEGORY] != ITEM_SUBCATEGORY_DRUG)
		return 0;

	static
		count;

	count = 0;

	for (new i = 0; i < sizeof g_arrItemDrugEffects; i++)
	{
		if (ItemData[itemid][e_ITEM_DRUG_EFFECTS] & floatround(floatpower(2.0, float(i + 1))))
			count += 1;
	}

	return count;
}

Item_GetDrugPainkillerCount(itemid)
{
	if (!(0 <= itemid < MAX_ITEMS) || !ItemData[itemid][e_ITEM_EXISTS])
		return 0;

	if (ItemData[itemid][e_ITEM_CATEGORY] != ITEM_CATEGORY_DRUGS || ItemData[itemid][e_ITEM_SUB_CATEGORY] != ITEM_SUBCATEGORY_PAINKILLER)
		return 0;

	static
		count;

	count = 0;

	for (new i = 0; i < MAX_PAINKILLER_DRUGS; i++)
	{
		if (Item_GetRealID(ItemData[itemid][e_ITEM_PAINKILLER_DRUGS][i]) == -1)
			continue;

		count += 1;
	}

	return count;
}

Item_ShowList(playerid, page)
{
	new totalPage = 0, totalItems = 0, offset;

	for (new i = 0; i < MAX_ITEMS; i++)
	{
		if (!ItemData[i][e_ITEM_EXISTS])
			continue;

		totalItems += 1;
	}

	// Set total page
	totalPage = (totalItems + (MAX_ITEM_LIST - 1)) / MAX_ITEM_LIST;

	if (page < 0) page = 0;
	if (page >= totalPage) page = totalPage - 1;

	offset = (page * MAX_ITEM_LIST);

	if (offset < 0) offset = 0;

	// Display
	new dialog[1024 + 1] = "Nome do item\tCategoria", displayedItems = 0;

	for (new i = 0; i < MAX_ITEMS; i++)
	{
		if (!ItemData[i][e_ITEM_EXISTS])
			continue;

		if (offset) 
		{
			offset -= 1;
			continue;
		}

		if (displayedItems >= MAX_ITEM_LIST)
			break;

		strcat (dialog, "\n");
		strcat (dialog, ItemData[i][e_ITEM_NAME]);
		strcat (dialog, "\t");
		strcat (dialog, Item_GetCategoryName(i));	

		s_pItemList[playerid][displayedItems] = ItemData[i][e_ITEM_ID];
		displayedItems += 1;
	}

	if (page > 0)
	{
		strcat(dialog, "\n{BBBBBB}<< Página anterior");
	}

	if (displayedItems == MAX_ITEM_LIST && page < (totalPage - 1))
	{
		strcat(dialog, "\n{BBBBBB}Próxima página >>");
	}

	if (!displayedItems)
		return SendErrorMessage(playerid, "Nenhum item encontrado.");

	s_pItemListPage[playerid] = page;
	Dialog_Show(playerid, DIALOG_ITEM_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Gerenciar itens", dialog, "Selecionar", "<<");
	return true;
}

Item_GetRealID(sqlid)
{
	for (new i = 0; i < MAX_ITEMS; i++)
	{
		if (!ItemData[i][e_ITEM_EXISTS])
			continue;

		if (ItemData[i][e_ITEM_ID] != sqlid)
			continue;

		return i;
	}

	return -1;
}

Item_GetName(id)
{
	new idx = Item_GetRealID(id), name[64] = "Nenhum";

	if (idx != -1 && ItemData[idx][e_ITEM_EXISTS])
	{
		format (name, sizeof name, ItemData[idx][e_ITEM_NAME]);
	}

	return name;
}

Item_GetPlayerPage(playerid)
{
	return s_pItemListPage[playerid];
}

Item_GetIDName(const itemname[])
{
	new mobileitem[64];

	for (new i = 0; i < MAX_ITEMS; i++)
	{
		if (!ItemData[i][e_ITEM_EXISTS])
			continue;

		format (mobileitem, sizeof mobileitem, ItemData[i][e_ITEM_NAME]);
		Internal_RemoveAccent(mobileitem);

		if (strcmp(ItemData[i][e_ITEM_NAME], itemname, false) && strcmp(mobileitem, itemname, false))
			continue;

		return ItemData[i][e_ITEM_ID];
	}

	return -1;
}

// Dialog
Dialog:DIALOG_ITEM_LIST(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		CallRemoteFunction("OnPlayerCancelSelectItem", "i", playerid);
		return true;
	}

	// Página Anterior
	if (!strcmp(inputtext, "<< Página anterior") || !strcmp(inputtext, "<< Pagina anterior"))
	{
		Item_ShowList(playerid, s_pItemListPage[playerid] - 1);
	}

	// Próxima Página
	else if (!strcmp(inputtext, "Próxima página >>") || !strcmp(inputtext, "Proxima pagina >>"))
	{
		Item_ShowList(playerid, s_pItemListPage[playerid] + 1);
	}

	else
	{
		if ((0 <= listitem < MAX_ITEM_LIST))
		{
			CallRemoteFunction("OnPlayerSelectItem", "iis", playerid, s_pItemList[playerid][listitem], inputtext);
		}
	}

	return true;
}