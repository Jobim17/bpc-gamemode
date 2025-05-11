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

// Callbacks
hook OnPlayerConnect(playerid)
{
	InventoryData[playerid] = InventoryData[MAX_INVENTORY_ITEM];
	return true;
}

hook OnCharacterLoaded(playerid)
{
	Inventory_Load(playerid);
	return true;
}

// Functions
Inventory_Load(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	inline Inventory_OnLoaded()
	{
		new rows = cache_num_rows(), loadedItems = 0, out[128], outDrugs[MAX_INVENTORY_DRUG], Float:outDrugQtd[MAX_INVENTORY_DRUG];

		InventoryData[playerid] = InventoryData[MAX_PLAYERS];

		for (new i = 0; i < rows; i++)
		{
			if (loadedItems >= Inventory_MaxSlots(playerid))
				break;

			cache_get_value_name_int(i, "ID", InventoryData[playerid][loadedItems][e_INVENTORY_ID]);
			cache_get_value_name_int(i, "Item", InventoryData[playerid][loadedItems][e_INVENTORY_ITEM]);
			cache_get_value_name_int(i, "Quantidade", InventoryData[playerid][loadedItems][e_INVENTORY_ITEM_AMOUNT]);
			cache_get_value_name_int(i, "Cigarros", InventoryData[playerid][loadedItems][e_INVENTORY_CIGARRETES]);

			// Drugs
			cache_get_value_name(i, "Drogas", out);
			sscanf(out, va_return("p<|>A<i>(0, 0)["#MAX_INVENTORY_DRUG"]"), outDrugs);
			InventoryData[playerid][loadedItems][e_INVENTORY_DRUG_ID] = outDrugs;

			// Drugs Amount
			cache_get_value_name(i, "DrogaQuantidade", out);
			sscanf(out, va_return("p<|>A<f>(0.0, 0.0)["#MAX_INVENTORY_DRUG"]"), outDrugQtd);
			InventoryData[playerid][loadedItems][e_INVENTORY_DRUG_AMOUNT] = outDrugQtd;

			// Check validity
			if (Item_GetRealID(InventoryData[playerid][loadedItems][e_INVENTORY_ITEM]) == -1)
			{
				Inventory_Remove(playerid, InventoryData[playerid][loadedItems][e_INVENTORY_ITEM]);
				continue;
			}

			// Heavy Item
			InventoryData[playerid][loadedItems][e_INVENTORY_EXISTS] = true;
			loadedItems += 1;
		}

		Inventory_UpdateHeavyItem(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Inventory_OnLoaded, "SELECT * FROM `Inventário` WHERE `Personagem` = %i LIMIT %i;", CharacterData[playerid][e_CHARACTER_ID], MAX_INVENTORY_ITEM);
	return true;
}

Inventory_Remove(playerid, itemid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return -1;

	static idx, id;
	idx = Inventory_GetItemIndex(playerid, itemid);
	id = Item_GetRealID(itemid);

	if (idx == -1)
		return -1;

	inline Item_OnRemoved()
	{
		if (!cache_affected_rows())
			return SendErrorMessage(playerid, "Não foi possível remover o item do seu inventário.");

		if (ItemData[id][e_ITEM_IS_HEAVY] && !IsPlayerFreeHands(playerid) && GetPlayerHandItemModel(playerid) == ItemData[id][e_ITEM_MODEL])
		{
			ResetPlayerHands(playerid);
		}

		InventoryData[playerid][idx] = InventoryData[MAX_PLAYERS][0];
		Inventory_Load(playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Item_OnRemoved, "DELETE IGNORE FROM `Inventário` WHERE `ID` = %i AND `Personagem` = %i LIMIT 1;", itemid, CharacterData[playerid][e_CHARACTER_ID]);
	return true;
}

Inventory_Add(playerid, itemid, quantity)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return -1;

	if (!Damage_IsAlive(playerid))
	{
		SendErrorMessage(playerid, "Você não pode receber itens agora.");
		return -1;
	}

	static
		id,
		inv;

	// Item inválido
	if ((id = Item_GetRealID(itemid)) == -1)
	{
		SendErrorMessage(playerid, "O item ID %i não é válido.", itemid);
		return false;
	}

	// Inventário cheio
	if (Inventory_Count(playerid) >= Inventory_MaxSlots(playerid))
	{
		SendErrorMessage(playerid, "Não foi possível receber o item \"%s\", seu invário está cheio.", ItemData[id][e_ITEM_NAME]);
		return false;
	}

	// Item Pesado
	if (ItemData[id][e_ITEM_IS_HEAVY])
	{
		if (Inventory_CountItem(playerid, itemid))
		{
			SendErrorMessage(playerid, "Você já tem um(a) %s no seu inventário.", ItemData[id][e_ITEM_NAME]);
			return false;
		}

		if (!IsPlayerFreeHands(playerid))
		{
			SendErrorMessage(playerid, "Você não está com as mãos livres para pegar este item.");
			return false;
		}
	}

	// Inventário
	inv = Inventory_GetItemIndex(playerid, itemid);

	if (inv == -1)
	{
		static freeid;

		freeid = Inventory_GetFreeIndex(playerid);

		if (freeid == -1)
		{
			SendErrorMessage(playerid, "Não foi possível receber o item \"%s\", seu invário está cheio.", ItemData[id][e_ITEM_NAME]);
			return false;
		}

		inline Inventory_ItemAdd()
		{
			if (!cache_affected_rows())
				return SendErrorMessage(playerid, "Não foi possível adicionar o item a seu inventário.");

			InventoryData[playerid][freeid] = InventoryData[MAX_PLAYERS][0];
			InventoryData[playerid][freeid][e_INVENTORY_ID] = cache_insert_id();
			InventoryData[playerid][freeid][e_INVENTORY_EXISTS] = true;
			InventoryData[playerid][freeid][e_INVENTORY_ITEM] = itemid;
			InventoryData[playerid][freeid][e_INVENTORY_ITEM_AMOUNT] = quantity;
			Inventory_UpdateHeavyItem(playerid);
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Inventory_ItemAdd, "INSERT IGNORE INTO `Inventário` (`Personagem`, `Item`, `Quantidade`) VALUES (%i, %i, %i);", CharacterData[playerid][e_CHARACTER_ID], itemid, quantity);
	}	
	else
	{
		inline Inventory_ItemUpdate()
		{
			if (!cache_affected_rows())
				return SendErrorMessage(playerid, "Não foi possível atualizar o item a seu inventário.");

			InventoryData[playerid][inv][e_INVENTORY_ITEM_AMOUNT] += quantity;
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Inventory_ItemUpdate, "UPDATE IGNORE `Inventário` SET `Quantidade` = `Quantidade` + %i WHERE `ID` = %i AND `Personagem` = %i LIMIT 1;", quantity, InventoryData[playerid][inv][e_INVENTORY_ID], CharacterData[playerid][e_CHARACTER_ID]);
	}

	return true;
}

Inventory_MaxSlots(playerid)
{
	switch (Premium_GetLevel(playerid))
	{
		case PREMIUM_LEVEL_GOLD: return MAX_INVENTORY_ITEM;
		case PREMIUM_LEVEL_SILVER: return 30;
		case PREMIUM_LEVEL_BRONZE: return 24;
	}

	return 18;
}

Inventory_Count(playerid)
{
	new count = 0;

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (!InventoryData[playerid][i][e_INVENTORY_EXISTS] || Item_GetRealID(InventoryData[playerid][i][e_INVENTORY_ITEM]) == -1)
			continue;

		count += 1;
	}

	return count;
}

Inventory_CountItem(playerid, itemid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return 0;

	if (!Inventory_Count(playerid))
		return 0;

	new count = 0;

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (!InventoryData[playerid][i][e_INVENTORY_EXISTS] || Item_GetRealID(InventoryData[playerid][i][e_INVENTORY_ITEM]) == -1)
			continue;

		if (InventoryData[playerid][i][e_INVENTORY_ITEM] == itemid && InventoryData[playerid][i][e_INVENTORY_ITEM_AMOUNT] > 0)
		{
			count += 1;
		}
	}

	return count;
}

Inventory_GetItemIndex(playerid, itemid)
{
	if (!Inventory_CountItem(playerid, itemid))
		return -1;

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (!InventoryData[playerid][i][e_INVENTORY_EXISTS] || Item_GetRealID(InventoryData[playerid][i][e_INVENTORY_ITEM]) == -1)
			continue;

		if (InventoryData[playerid][i][e_INVENTORY_ITEM] == itemid && InventoryData[playerid][i][e_INVENTORY_ITEM_AMOUNT] > 0)
		{
			return i;
		}
	}

	return -1;
}

Inventory_GetFreeIndex(playerid)
{
	if (Inventory_Count(playerid) >= Inventory_MaxSlots(playerid))
		return -1;

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (InventoryData[playerid][i][e_INVENTORY_EXISTS] || Item_GetRealID(InventoryData[playerid][i][e_INVENTORY_ITEM]) != -1)
			continue;

		return i;
	}

	return -1;
}

Inventory_HasItem(playerid, const itemname[])
{
	static id;
	id = Item_GetIDName(itemname);

	if (id == -1)
		return SendErrorMessage(playerid, "O item \"%s\" não é válido.", itemname), false;

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (!InventoryData[playerid][i][e_INVENTORY_EXISTS])
			continue;

		if (InventoryData[playerid][i][e_INVENTORY_ITEM] != id || !InventoryData[playerid][i][e_INVENTORY_ITEM_AMOUNT])
			continue;

		return true;
	}

	return false;
}

Inventory_UpdateHeavyItem(playerid)
{
	if (!IsPlayerLogged(playerid) || !IsPlayerSpawned(playerid))
		return false;

	static id;

	for (new i = 0; i < MAX_INVENTORY_ITEM; i++)
	{
		if (!InventoryData[playerid][i][e_INVENTORY_EXISTS] || (id = Item_GetRealID(InventoryData[playerid][i][e_INVENTORY_ITEM])) == -1)
			continue;

		if (!ItemData[id][e_ITEM_IS_HEAVY])
			continue;

		SetPlayerHand(
			playerid, 
			ItemData[id][e_ITEM_MODEL],
			va_return("Segurando um(a) %s", ItemData[id][e_ITEM_NAME]),
			ItemData[id][e_ITEM_ATTACH_OFFSET][0],
			ItemData[id][e_ITEM_ATTACH_OFFSET][1],
			ItemData[id][e_ITEM_ATTACH_OFFSET][2],
			ItemData[id][e_ITEM_ATTACH_OFFSET][3],
			ItemData[id][e_ITEM_ATTACH_OFFSET][4],
			ItemData[id][e_ITEM_ATTACH_OFFSET][5],
			ItemData[id][e_ITEM_ATTACH_OFFSET][6],
			ItemData[id][e_ITEM_ATTACH_OFFSET][7],
			ItemData[id][e_ITEM_ATTACH_OFFSET][8]
		);

		break;
	}

	return true;
}