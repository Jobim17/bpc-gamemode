/*
	ooooo   ooooo                             .o8
	`888'   `888'                            "888
	 888     888   .oooo.   ooo. .oo.    .oooo888   .oooo.o
	 888ooooo888  `P  )88b  `888P"Y88b  d88' `888  d88(  "8
	 888     888   .oP"888   888   888  888   888  `"Y88b.
	 888     888  d8(  888   888   888  888   888  o.  )88b
	o888o   o888o `Y888""8o o888o o888o `Y8bod88P" 8""888P'

*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define ATTACH_INDEX_HAND 9

// Variáveis
static s_pHandItem[MAX_PLAYERS][64 char];
static s_pHandItemModel[MAX_PLAYERS] = {-1, ...};

// Callbacks
hook OnPlayerConnect(playerid)
{
	ResetPlayerHands(playerid);
	return true;
}

// Functions
IsPlayerFreeHands(playerid)
{
	if (!IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_INDEX_HAND) && s_pHandItemModel[playerid] == -1)
		return true;
	else
		return false;
}

SetPlayerHand(playerid, modelid, const desc[], Float:x=0.0, Float:y=0.0, Float:z=0.0, Float:rX=0.0, Float:rY=0.0, Float:rZ=0.0, Float:scaleX=1.0, Float:scaleY=1.0, Float:scaleZ=1.0)
{
	if (!CharacterData[playerid][e_CHARACTER_ID])
		return false;

	strpack (s_pHandItem[playerid], desc);
	s_pHandItemModel[playerid] = modelid;

	SetPlayerAttachedObject(playerid, ATTACH_INDEX_HAND, modelid, 6, x, y, z, rX, rY, rZ, scaleX, scaleY, scaleZ);
	return true;
}

GetPlayerHandDesc(playerid)
{
	new ret[120] = "Mãos desocupadas";
	
	if (s_pHandItemModel[playerid] != -1)
	{
		strunpack(ret, s_pHandItem[playerid]);
	}

	return ret;
}

GetPlayerHandItemModel(playerid)
{
	return s_pHandItemModel[playerid];
}

ResetPlayerHands(playerid)
{
	s_pHandItemModel[playerid] = -1;
	RemovePlayerAttachedObject(playerid, ATTACH_INDEX_HAND);
	strpack(s_pHandItem[playerid], "\0");

	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}

	Trucker_RemoveCarryCrate(playerid, false);
	return true;
}