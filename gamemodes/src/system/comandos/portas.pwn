/*
	ooooooooo.                          .
	`888   `Y88.                      .o8
	 888   .d88'  .ooooo.  oooo d8b .o888oo  .oooo.    .oooo.o
	 888ooo88P'  d88' `88b `888""8P   888   `P  )88b  d88(  "8
	 888         888   888  888       888    .oP"888  `"Y88b.
	 888         888   888  888       888 . d8(  888  o.  )88b
	o888o        `Y8bod8P' d888b      "888" `Y888""8o 8""888P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Callbacks
hook OnPlayerShootDynamicObj(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
	if (!IsValidDynamicObject(objectid) || !(25 <= weaponid <= 27) || !Furniture_IsDoor(Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID)))
		return true;

	new chance = 0, Float:dist;

	foreach (new i : Furnitures)
	{
		if (objectid != FurnitureData[i][e_FURNITURE_OBJECT])
			continue;

		if (!FurnitureData[i][e_FURNITURE_EXISTS])
			continue;
	
		if (GetPlayerVirtualWorld(playerid) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_WORLD_ID))
			continue;

		if (GetPlayerInterior(playerid) != Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_INTERIOR_ID))
			continue;

		if (!FurnitureData[i][e_FURNITURE_DOOR_OPENNED])
		{
			dist = GetPlayerDistanceFromPoint(playerid, FurnitureData[i][e_FURNITURE_POS][0], FurnitureData[i][e_FURNITURE_POS][1], FurnitureData[i][e_FURNITURE_POS][2]);
			
			if (dist <= 1.0) chance = Random(1, 2);
			else if (dist <= 2.0) chance = Random(1, 4);
			else if (dist <= 5.0) chance = Random(1, 10);
			else chance = Random(2, 100);

			if (chance == 1)
			{
				FurnitureData[i][e_FURNITURE_DOOR_OPENNED] = true;
				FurnitureData[i][e_FURNITURE_DOOR_LOCKED] = false;
				Furniture_Refresh(i);
				Furniture_Save(i);

				GameTextForPlayer(playerid, "~y~porta arrombada", 2400, 4);
			}
		}

		break;
	}

	return true;
}

// Comandos
CMD:porta(playerid)
{
	static id;

	if ((id = Furniture_NearestDoor(playerid)) != -1)
	{
		if (FurnitureData[id][e_FURNITURE_DOOR_LOCKED])
			return SendErrorMessage(playerid, "A porta está trancada.");

		FurnitureData[id][e_FURNITURE_DOOR_OPENNED] = !FurnitureData[id][e_FURNITURE_DOOR_OPENNED];
		Furniture_Save(id);

		if (FurnitureData[id][e_FURNITURE_DOOR_OPENNED])
		{
			SetDynamicObjectPos(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_DOOR_POS][0], FurnitureData[id][e_FURNITURE_DOOR_POS][1], FurnitureData[id][e_FURNITURE_DOOR_POS][2]);
			SetDynamicObjectRot(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_DOOR_ROT][0], FurnitureData[id][e_FURNITURE_DOOR_ROT][1], FurnitureData[id][e_FURNITURE_DOOR_ROT][2]);
		}	
		else
		{
			SetDynamicObjectPos(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_POS][0], FurnitureData[id][e_FURNITURE_POS][1], FurnitureData[id][e_FURNITURE_POS][2]);
			SetDynamicObjectRot(FurnitureData[id][e_FURNITURE_OBJECT], FurnitureData[id][e_FURNITURE_ROT][0], FurnitureData[id][e_FURNITURE_ROT][1], FurnitureData[id][e_FURNITURE_ROT][2]);
		}
	}
	else
	{
		SendErrorMessage(playerid, "Você não está próximo de uma porta.");
	}

	return true;
}

alias:tporta("trancarporta")
CMD:tporta(playerid)
{
	static id, type, prop;

	if ((id = Furniture_NearestDoor(playerid)) != -1)
	{
		Furniture_GetPlayerType(playerid, type, prop);

		if (type == -1 || prop == -1)
			return SendErrorMessage(playerid, "Você não está próximo de uma porta.");

		if (type == FURNITURE_LINK_TYPE_HOUSE && !House_IsOwner(playerid, prop))
			return SendErrorMessage(playerid, "Você não possui as chaves desta porta.");

		if (type == FURNITURE_LINK_TYPE_BUSINESS && !Business_IsOwner(playerid, prop))
			return SendErrorMessage(playerid, "Você não possui as chaves desta porta.");


		FurnitureData[id][e_FURNITURE_DOOR_LOCKED] = !FurnitureData[id][e_FURNITURE_DOOR_LOCKED];
		GameTextForPlayer(playerid, FurnitureData[id][e_FURNITURE_DOOR_LOCKED] ? ("~r~Porta trancada") : ("~g~Porta destrancada"), 2400, 4);
		Furniture_Save(id);

	}
	else
	{
		SendErrorMessage(playerid, "Você não está próximo de uma porta.");
	}


	return true;
}