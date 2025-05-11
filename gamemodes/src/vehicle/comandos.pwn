/*
	  .oooooo.                                                           .o8
	 d8P'  `Y8b                                                         "888
	888           .ooooo.  ooo. .oo.  .oo.    .oooo.   ooo. .oo.    .oooo888   .ooooo.   .oooo.o
	888          d88' `88b `888P"Y88bP"Y88b  `P  )88b  `888P"Y88b  d88' `888  d88' `88b d88(  "8
	888          888   888  888   888   888   .oP"888   888   888  888   888  888   888 `"Y88b.
	`88b    ooo  888   888  888   888   888  d8(  888   888   888  888   888  888   888 o.  )88b
	 `Y8bood8P'  `Y8bod8P' o888o o888o o888o `Y888""8o o888o o888o `Y8bod88P" `Y8bod8P' 8""888P'
	
*/

CMD:v(playerid, params[])
{
	if (IsNull(params))
	{
		SendClientMessage(playerid, COLOR_YELLOW3, "_____________________________________________");
		SendClientMessage(playerid, COLOR_YELLOW3, "USE: /(v)eiculo [a��o]");
		SendClientMessage(playerid, COLOR_YELLOW3, "[A��es]: comprar, lista, estacionar, stats");
		SendClientMessage(playerid, COLOR_YELLOW3, "[A��es]: trancar, luzes, capo, portamalas");
		SendClientMessage(playerid, COLOR_YELLOW3, "[Deletar]: deletar (n�o recebe nada)");
		SendClientMessage(playerid, COLOR_YELLOW3, "_____________________________________________");
		return true;
	}

	/* Get Vehicle ID */
	static id;

	if (IsPlayerInAnyVehicle(playerid))
	{
		id = GetPlayerVehicleID(playerid);
	}
	else
	{
		id = Vehicle_Nearest(playerid, 5.0);
	}

	// Comprar
	if (!strcmp(params, "comprar", true))
	{	

	}

	// Lista
	else if (!strcmp(params, "lista", true))
	{

	}

	// Estacionar
	else if (!strcmp(params, "estacionar", true))
	{
	}

	// Stats
	else if (!strcmp(params, "stats", true))
	{

	}

	// Trancar
	else if (!strcmp(params, "trancar", true))
	{
		if (id == -1)
			return SendErrorMessage(playerid, "Voc� n�o est� pr�ximo � um ve�culo.");

		if (!Vehicle_CheckKeys(playerid, id))
			return SendErrorMessage(playerid, "Voc� n�o possui a chave do ve�culo.");

		SetLockStatus(id, !GetLockStatus(id));
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid, (GetLockStatus(id) ? ("~r~~h~trancado") : ("~g~~h~destrancado")), 2000, 4);
	}

	// Luzes
	else if (!strcmp(params, "luzes", true))
	{
		if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendErrorMessage(playerid, "Voc� n�o est� no assento de motorista.");

		id = GetPlayerVehicleID(playerid);

		if (!IsEngineVehicle(id))
			return SendErrorMessage(playerid, "Este ve�culo n�o possui motor.");

		if (VehicleData[id][e_VEHICLE_BATTERY_LIFE] < 5.0)
			return SendErrorMessage(playerid, "A bateria do ve�culo est� baixa.");

		SetLightStatus(id, !GetLightStatus(id));
		GameTextForPlayer(playerid, (GetLightStatus(id) ? ("~g~~h~luzes ligadas") : ("~r~~h~luzes desligadas")), 2000, 4);
	}

	// Cap�
	else if (!strcmp(params, "capo", true))
	{
		if (id == -1)
			return SendErrorMessage(playerid, "Voc� n�o est� pr�ximo � um ve�culo.");

		if (!IsDoorVehicle(id))
			return SendErrorMessage(playerid, "Este ve�culo n�o possui cap�.");

		if (!IsPlayerNearHood(playerid, id) && (!IsPlayerInVehicle(playerid, id) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER))
			return SendErrorMessage(playerid, "Voc� precisa estar pr�ximo ao cap� ou ser o motorista.");
	
		if (!GetEngineStatus(id))
			return SendErrorMessage(playerid, "O ve�culo precisa estar ligado.");
		
		SetHoodStatus(id, !GetHoodStatus(id));
		GameTextForPlayer(playerid, (GetHoodStatus(id) ? ("~g~~h~cap� aberto") : ("~r~~h~cap� fechado")), 2000, 4);
	}

	// Porta-malas
	else if (!strcmp(params, "portamalas", true))
	{
		if (id == -1)
			return SendErrorMessage(playerid, "Voc� n�o est� pr�ximo � um ve�culo.");

		if (!IsDoorVehicle(id))
			return SendErrorMessage(playerid, "Este ve�culo n�o possui porta-malas.");

		if (!IsPlayerNearBoot(playerid, id) && (!IsPlayerInVehicle(playerid, id) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER))
			return SendErrorMessage(playerid, "Voc� precisa estar pr�ximo ao porta-malas ou ser o motorista.");

		if(IsVehicleTrunkBroken(id))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "O porta-malas do ve�culo est� danificado, qualquer personagem consegue acessar.");
		    return 1;
		}

		if (!GetEngineStatus(id))
			return SendErrorMessage(playerid, "O ve�culo precisa estar ligado.");
		
		if (GetLockStatus(id))
		    return SendErrorMessage(playerid, "O ve�culo est� trancado.");

		SetTrunkStatus(id, !GetTrunkStatus(id));
	}
	else 
	{
		SendErrorMessage(playerid, "Voc� digitou um par�metro inv�lido.");
	}

	return true;
}

CMD:motor(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Voc� precisa estar no assento de motorista.");

	static vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);

	if(!IsEngineVehicle(vehicleid))
		return SendErrorMessage(playerid, "Este ve�culo n�o possui motor.");

	if(!VehicleData[vehicleid][e_VEHICLE_FUEL])
  		return SendErrorMessage(playerid, "Este ve�culo est� sem combust�vel.");

  	if (!Vehicle_CheckKeys(playerid, vehicleid))
  		return SendErrorMessage(playerid, "Voc� n�o possui a chave deste ve�culo.");

  	SetEngineStatus(vehicleid, !GetEngineStatus(vehicleid));
  	GameTextForPlayer(playerid, (GetEngineStatus(vehicleid) ? ("~g~~h~motor ligado") : ("~r~~h~motor desligado")), 2000, 4);
 	SendNearbyMessage(playerid, COLOR_PURPLE, 20.0, "* %s insere a chave e igni��o e %s o motor.", Character_GetName(playerid), (GetEngineStatus(vehicleid) ? ("liga") : ("desliga")));
	return true;
}