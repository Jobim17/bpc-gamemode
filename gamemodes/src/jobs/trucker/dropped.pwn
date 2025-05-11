/*
	  .oooooo.                                                         oooooooooo.                                                 .o8
	 d8P'  `Y8b                                                        `888'   `Y8b                                               "888
	888           .oooo.   oooo d8b  .oooooooo  .oooo.    .oooo.o       888      888 oooo d8b  .ooooo.  oo.ooooo.   .oooo.    .oooo888   .oooo.    .oooo.o
	888          `P  )88b  `888""8P 888' `88b  `P  )88b  d88(  "8       888      888 `888""8P d88' `88b  888' `88b `P  )88b  d88' `888  `P  )88b  d88(  "8
	888           .oP"888   888     888   888   .oP"888  `"Y88b.        888      888  888     888   888  888   888  .oP"888  888   888   .oP"888  `"Y88b.
	`88b    ooo  d8(  888   888     `88bod8P'  d8(  888  o.  )88b       888     d88'  888     888   888  888   888 d8(  888  888   888  d8(  888  o.  )88b
	 `Y8bood8P'  `Y888""8o d888b    `8oooooo.  `Y888""8o 8""888P'      o888bood8P'   d888b    `Y8bod8P'  888bod8P' `Y888""8o `Y8bod88P" `Y888""8o 8""888P'
	                                d"     YD                                                            888
	                                "Y88888P'                                                           o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define MAX_DROPPED_CRATES 50

// Variáveis
enum E_DROPPED_CRATE_DATA
{
	bool:e_DROPPED_CRATE_EXISTS,
	e_DROPPED_CRATE_OBJECT,
	Text3D:e_DROPPED_CRATE_LABEL,

	e_DROPPED_CRATE_COMMODITY,
	Float:e_DROPPED_CRATE_POS[3],
	e_DROPPED_CRATE_WORLD,
	e_DROPPED_CRATE_INTERIOR,
	e_DROPPED_CRATE_TIME
}

new DroppedCrateData[MAX_DROPPED_CRATES + 1][E_DROPPED_CRATE_DATA];

// Callbacks
hook OnGameModeInit()
{
	for (new i = 0; i < MAX_DROPPED_CRATES; i++)
		DroppedCrateData[i] = DroppedCrateData[MAX_DROPPED_CRATES];

	return true;
}

hook Server_OnUpdate()
{
	for (new i = 0; i < MAX_DROPPED_CRATES; i++)
	{
		if (!DroppedCrateData[i][e_DROPPED_CRATE_EXISTS])
			continue;

		if (DroppedCrateData[i][e_DROPPED_CRATE_TIME] > gettime())
			continue;

		DroppedCrate_Destroy(i);
	}
}

// Functions
DroppedCrate_FreeIndex()
{
	for (new i = 0; i < MAX_DROPPED_CRATES; i++)
	{
		if (DroppedCrateData[i][e_DROPPED_CRATE_EXISTS])
			continue;

		return i;
	}

	return -1;
}

DroppedCrate_Create(playerid, commodity)
{
	if (!(0 <= commodity < MAX_COMMODITY)) return -1;

	new id = DroppedCrate_FreeIndex();

	if (id != -1)
	{
		DroppedCrateData[id][e_DROPPED_CRATE_EXISTS] = true;
		DroppedCrateData[id][e_DROPPED_CRATE_COMMODITY] = commodity;

		GetPlayerPos(playerid, DroppedCrateData[id][e_DROPPED_CRATE_POS][0], DroppedCrateData[id][e_DROPPED_CRATE_POS][1], DroppedCrateData[id][e_DROPPED_CRATE_POS][2]);
		GetXYInFrontOfPlayer(playerid, DroppedCrateData[id][e_DROPPED_CRATE_POS][0], DroppedCrateData[id][e_DROPPED_CRATE_POS][1], 1.5);

		DroppedCrateData[id][e_DROPPED_CRATE_WORLD] = GetPlayerVirtualWorld(playerid);
		DroppedCrateData[id][e_DROPPED_CRATE_INTERIOR] = GetPlayerInterior(playerid);
	
		DroppedCrateData[id][e_DROPPED_CRATE_TIME] = gettime() + (60 * 60);
	
		DroppedCrate_Refresh(id);
	}

	return id;
}

DroppedCrate_Refresh(id)
{
	if (!(0 <= id < MAX_DROPPED_CRATES) || !DroppedCrateData[id][e_DROPPED_CRATE_EXISTS])
		return false;

	if (IsValidDynamicObject(DroppedCrateData[id][e_DROPPED_CRATE_OBJECT]))
		DestroyDynamicObject(DroppedCrateData[id][e_DROPPED_CRATE_OBJECT]);

	if (IsValidDynamic3DTextLabel(DroppedCrateData[id][e_DROPPED_CRATE_LABEL]))
		DestroyDynamic3DTextLabel(DroppedCrateData[id][e_DROPPED_CRATE_LABEL]);

	DroppedCrateData[id][e_DROPPED_CRATE_OBJECT] = CreateDynamicObject(
		(g_commodityType[DroppedCrateData[id][e_DROPPED_CRATE_COMMODITY]] == COMMODITY_TYPE_CRATE ? 2912 : 964),
		DroppedCrateData[id][e_DROPPED_CRATE_POS][0], 
		DroppedCrateData[id][e_DROPPED_CRATE_POS][1], 
		DroppedCrateData[id][e_DROPPED_CRATE_POS][2] - 1.0,
		0.0, 
		0.0, 
		0.0, 
		DroppedCrateData[id][e_DROPPED_CRATE_WORLD],
		DroppedCrateData[id][e_DROPPED_CRATE_INTERIOR]
	);

	DroppedCrateData[id][e_DROPPED_CRATE_LABEL] = CreateDynamic3DTextLabel(
		va_return("[ {E5FF00}%s{FFFFFF} ]", Commodity_GetLowerName(DroppedCrateData[id][e_DROPPED_CRATE_COMMODITY])), 
		-1, 
		DroppedCrateData[id][e_DROPPED_CRATE_POS][0], 
		DroppedCrateData[id][e_DROPPED_CRATE_POS][1], 
		DroppedCrateData[id][e_DROPPED_CRATE_POS][2], 
		8.0,  
		.worldid = DroppedCrateData[id][e_DROPPED_CRATE_WORLD],
		.interiorid = DroppedCrateData[id][e_DROPPED_CRATE_INTERIOR]
	);

	return true;
}

DroppedCrate_Nearest(playerid, Float:radius=2.5)
{
	new idx = -1;

	for (new i = 0; i < MAX_DROPPED_CRATES; i++)
	{
		if (!DroppedCrateData[i][e_DROPPED_CRATE_EXISTS])
			continue;

		if (GetPlayerInterior(playerid) != DroppedCrateData[i][e_DROPPED_CRATE_INTERIOR])
			continue;

		if (GetPlayerVirtualWorld(playerid) != DroppedCrateData[i][e_DROPPED_CRATE_WORLD])
			continue;

		if (GetPlayerDistanceFromPoint(playerid, DroppedCrateData[i][e_DROPPED_CRATE_POS][0], DroppedCrateData[i][e_DROPPED_CRATE_POS][1], DroppedCrateData[i][e_DROPPED_CRATE_POS][2]) < radius)
		{
			idx = i;
			radius = GetPlayerDistanceFromPoint(playerid, DroppedCrateData[i][e_DROPPED_CRATE_POS][0], DroppedCrateData[i][e_DROPPED_CRATE_POS][1], DroppedCrateData[i][e_DROPPED_CRATE_POS][2]);
		}
	}

	return idx;
}

DroppedCrate_Destroy(id)
{
	if (!(0 <= id < MAX_DROPPED_CRATES) || !DroppedCrateData[id][e_DROPPED_CRATE_EXISTS])
		return false;

	if (IsValidDynamicObject(DroppedCrateData[id][e_DROPPED_CRATE_OBJECT]))
		DestroyDynamicObject(DroppedCrateData[id][e_DROPPED_CRATE_OBJECT]);

	if (IsValidDynamic3DTextLabel(DroppedCrateData[id][e_DROPPED_CRATE_LABEL]))
		DestroyDynamic3DTextLabel(DroppedCrateData[id][e_DROPPED_CRATE_LABEL]);

	DroppedCrateData[id] = DroppedCrateData[MAX_DROPPED_CRATES];
	return true;
}