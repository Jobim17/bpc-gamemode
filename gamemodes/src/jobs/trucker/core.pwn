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

// Variáveis
static s_pCarryCrate[MAX_PLAYERS] = {-1, ...};
static s_pVehicleInspecting[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
static s_vCommodityStorage[MAX_VEHICLES + 1][MAX_COMMODITY];

// Callbacks
hook OnGameModeInit()
{
	for (new i = 0; i < MAX_VEHICLES; i++)
		s_vCommodityStorage[i] = s_vCommodityStorage[MAX_VEHICLES];
	return true;
}

hook OnPlayerConnect(playerid)
{
	Trucker_RemoveCarryCrate(playerid);
	s_pCarryCrate[playerid] = -1;
	s_pVehicleInspecting[playerid] = -1;
}

hook OnVehicleSpawn(vehicleid)
{
	new bool:refresh = false;

	for (new i = 0; i < MAX_COMMODITY; i++)
	{
		if (s_vCommodityStorage[vehicleid][i])
		{
			s_vCommodityStorage[vehicleid][i] = 0;

			if (!refresh) refresh = true;
		}
	}

	if (refresh)
	{
		Trucker_UpdateAttach(vehicleid);
	}

	return true;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if ((newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) && (!IsPlayerFreeHands(playerid) && s_pCarryCrate[playerid] != -1))
	{
		SendClientMessage(playerid, COLOR_WHITE, "Você não pode entrar em veículos com uma caixa na mão.");
		RemovePlayerFromVehicle(playerid);
	}
}

hook OnPlayerEnterDynamicArea(playerid, areaid)
{
	new id;

	// Empresas
	if ((id = Business_Nearest(playerid)) != -1 && CharacterData[playerid][e_CHARACTER_JOB] == JOB_TRUCKER && Business_IsAcceptingCargo(id))
	{
		if (BusinessData[id][e_BUSINESS_REQUEST_CARGO] != g_commodityBusinessAcceptable[BusinessData[id][e_BUSINESS_TYPE]] || BusinessData[id][e_BUSINESS_REQUEST_CARGO] != g_commodityBusinessAcceptable[BusinessData[id][e_BUSINESS_TYPE]] && BusinessData[id][e_BUSINESS_REQUEST_CARGO] == 13 && BusinessData[id][e_BUSINESS_TYPE] != BUSINESS_TYPE_GAS_STATION)
		{
			BusinessData[id][e_BUSINESS_REQUEST_CARGO] = -1;
			BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] = 0;
			BusinessData[id][e_BUSINESS_REQUEST_PRICE] = 0;
			return true;
		}

		SendClientMessage(playerid, -1, "Esta empresa está {C5E66C}procurando estoque{FFFFFF} para comprar.");

		new commodity = BusinessData[id][e_BUSINESS_REQUEST_CARGO];
		SendClientMessageEx(playerid, COLOR_GREY, "(Procura-se: {FFFFFF}%i{AFAFAF} %s de {FFFFFF}%s{AFAFAF}, paga-se {FFFFFF}%s{AFAFAF} em cada %s).", BusinessData[id][e_BUSINESS_REQUEST_QUANTITY], Commodity_GetUnitName(commodity, BusinessData[id][e_BUSINESS_REQUEST_QUANTITY]), Commodity_GetLowerName(commodity), FormatMoney(BusinessData[id][e_BUSINESS_REQUEST_PRICE]), Commodity_GetUnitName(commodity, 1));
	}

	return true;
}

// Dialogs
Dialog:DIALOG_COMMODITY_INSPECT(playerid, response, lisitem, inputtext[])
{	
	if (!response)
		return true;

	if (!IsPlayerNearBoot(playerid, s_pVehicleInspecting[playerid]) && !IsPlayerInVehicle(playerid, s_pVehicleInspecting[playerid]))
		return SendErrorMessage(playerid, "Você não está próximo do veículo.");

	if (!IsVehicleTrunkOpenned(s_pVehicleInspecting[playerid]) && !IsPlayerInVehicle(playerid, s_pVehicleInspecting[playerid]))
		return SendErrorMessage(playerid, "O porta-malas não está aberto.");

	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT && response)
		return SendErrorMessage(playerid, "Você precisa estar a pé para pegar uma caixa.");

	new idx = -1, mobileItem[32];

	for (new i = 0; i < MAX_COMMODITY; i++)
	{
		format (mobileItem, sizeof mobileItem, Commodity_GetName(i));
		Internal_RemoveAccent(mobileItem);

		if (strfind(inputtext, Commodity_GetName(i), true) != -1 && !IsPlayerAndroid(playerid) || strfind(inputtext, mobileItem, true) != -1 && IsPlayerAndroid(playerid))
		{
			idx = i;
			break;
		}
	}

	if (idx == -1)
		return SendErrorMessage(playerid, "Produto inválido.");

	if (g_commodityType[idx] != COMMODITY_TYPE_CRATE && g_commodityType[idx] != COMMODITY_TYPE_METAL)
		return SendErrorMessage(playerid, "Você não pode pegar este tipo de produto nas mãos.");

	if (!IsPlayerFreeHands(playerid) || s_pCarryCrate[playerid] != -1)
		return SendErrorMessage(playerid, "Você não está com as mãos livres.");

	if (!s_vCommodityStorage[s_pVehicleInspecting[playerid]][idx])
		return SendErrorMessage(playerid, "O veículo não tem mais caixas de %s.", Commodity_GetLowerName(idx));

	s_vCommodityStorage[s_pVehicleInspecting[playerid]][idx] -= 1;
	Trucker_UpdateAttach(s_pVehicleInspecting[playerid]);
	Trucker_SetCarryCrate(playerid, idx);
	ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
	SendClientMessageEx(playerid, -1, "SERVER: Você pegou uma caixa de %s do porta-malas do veículo.", Commodity_GetLowerName(idx));
	return true;
}

// Functions
Trucker_GetVehicleCapacity(vehicleid)
{
	if (!IsValidVehicle(vehicleid))
		return 0;

	new model = GetVehicleModel(vehicleid);

	switch (model)
	{
		case 600, 543, 605, 443: return 2;
		case 422: return 3;
		case 478: return 4;
		case 554: return 6;
		case 413, 459, 482: return 10;
		case 440, 498: return 12;
		case 499, 428, 455: return 16;
		case 414, 578: return 18;
		case 456: return 24;
		case 435, 591: return 36;
		case 450: return 30;
		case 584: return 40;
	}

	return 0;
}

Trucker_SetCarryCrate(playerid, commodity)
{
	if (!IsPlayerConnected(playerid))
		return false;

	if (!(0 <= commodity < MAX_COMMODITY))
		return false;

	if (g_commodityType[commodity] != COMMODITY_TYPE_CRATE && g_commodityType[commodity] != COMMODITY_TYPE_METAL)
		return false;

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	s_pCarryCrate[playerid] = commodity;

	new desc[64];
	format (desc, sizeof desc, "Segurando uma caixa de %s", Commodity_GetLowerName(commodity));

	if(g_commodityType[commodity] == COMMODITY_TYPE_METAL)
	{
		SetPlayerHand(playerid, 964, desc, 0.000000, 0.000000, -0.178000, -114.299964, 0.000000, -97.500015, 0.309000, 0.213999, 0.186000);
	}
	else
	{
		SetPlayerHand(playerid, 2912, desc, 0.141999, 0.117000, -0.188999, -21.499992, -99.999954, -6.899998, 0.494999, 0.371000, 0.423000);
	}

	return true;
}

Trucker_RemoveCarryCrate(playerid, bool:reset = true)
{
	s_pCarryCrate[playerid] = -1;

	if (reset)
		ResetPlayerHands(playerid);

	return true;
}

Trucker_IsValidCommodity(vehicleid, cargoid)
{
    new model = GetVehicleModel(vehicleid);
 
	switch(model)
	{
		case 435, 591: // Article Trailer 1 & Article Trailer 2
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_CRATE)
				return true;
 
			if (cargoid == COMMODITY_BRICKS)
				return true;
		}
 
		case 584: // Petrol Trailer
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_LIQUID)
				return true;
		}
 
		case 450: // Dump Trailer
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_LOOSE)
				return true;
	    }
 
	    case 443: // Packer
		{
			if(cargoid == COMMODITY_VEHICLES) return true;
		}
 
	    case 578: // DFT
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_OTHER)
				return true;
	    }
 
	    case 428: // Securicar
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_CRATE || g_commodityType[cargoid] == COMMODITY_TYPE_METAL)
				return true; 
	    }
	    case 455: // Flatbed
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_LOOSE)
				return true;
	    }
	    case 456, 499, 414, 554: // Yankee, Benson, Mule, Yosemite
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_CRATE)
				return true;
 
			if (cargoid == COMMODITY_BRICKS)
				return true;
	    }
		case 498, 440, 482, 459, 413, 478, 422, 543, 605, 600:
		{
			if (g_commodityType[cargoid] == COMMODITY_TYPE_CRATE)
				return true;
		}
	}
 
	return false;
}

Trucker_CountVehicleStorage(vehicleid)
{
	if (!IsValidVehicle(vehicleid))
		return 0;

	new count;
 
	for(new i = 0; i < MAX_COMMODITY; i++)
	{
		if(s_vCommodityStorage[vehicleid][i] > 0)
		{
		    count += s_vCommodityStorage[vehicleid][i] * Commodity_GetSlotSize(i);
		}
	}
 
	return count;
}

Trucker_GetLoadedCargo(vehicleid)
{
	for(new i = 0; i < MAX_COMMODITY; ++i)
	{
		if (g_commodityType[i] == COMMODITY_TYPE_CRATE || g_commodityType[i] == COMMODITY_TYPE_METAL)
			continue;
 
		if(s_vCommodityStorage[vehicleid][i])
		{
			return i;
		}
	}
 
	return -1;
}

Trucker_UpdateAttach(vehicleid)
{
	if (!IsValidVehicle(vehicleid))
		return false;

	new model = GetVehicleModel(vehicleid), count = Trucker_CountVehicleStorage(vehicleid);
 	RemoveVehicleAllAttachedObject(vehicleid);

 	if (!count) return false;

	switch(model)
	{
	    case 422:
		{
			for(new i = 0; i < count; ++i)
			{
				switch (i)
				{
					case 0: SetVehicleAttachedObject(2912, 0, vehicleid, -0.31250, -0.80650, -0.31710, 0.000000, 0.000000, 0.000000);
					case 1: SetVehicleAttachedObject(2912, 1, vehicleid, 0.42700, -0.80650, -0.31710, 0.000000, 0.000000, 0.000000);
					case 2: SetVehicleAttachedObject(2912, 2, vehicleid, 0.04260, -1.84000, -0.31710, 0.0, 0.000000, 0.000000);
				}
			}
	    }
	    case 543, 605:
		{
			for(new i = 0; i < count; ++i)
			{
				switch (i)
				{
					case 0: SetVehicleAttachedObject(2912, 0, vehicleid, -0.344999, -0.769999, -0.294999, 0.000000, 0.000000, 0.000000);
					case 1: SetVehicleAttachedObject(2912, 1, vehicleid, -0.344999, -0.769999, -0.294999, 0.000000, 0.000000, 0.000000);
				}
			}
	    }
		case 600:
		{
			for(new i = 0; i < count; ++i)
			{
				switch (i)
				{
					case 0: SetVehicleAttachedObject(2912, 0, vehicleid, -0.344999, -0.92, -0.294999, 0.000000, 0.000000, 0.000000);
					case 1: SetVehicleAttachedObject(2912, 1, vehicleid, 0.364999, -0.92, -0.299999, 0.000000, 0.000000, 0.000000);
				}
			}
		}
		case 530:
		{
			for(new i = 0; i < count; ++i)
			{
				switch (i)
				{
					case 0: SetVehicleAttachedObject(2912, 0, vehicleid, 0.354999, 0.489999, -0.059999, 0.000000, 0.000000, 0.000000);
					case 1: SetVehicleAttachedObject(2912, 1, vehicleid, -0.344999, 0.489999, -0.059999, 0.000000, 0.000000, 0.000000);
					case 2: SetVehicleAttachedObject(2912, 2, vehicleid, 0.009999, 0.484999, 0.634999, 0.000000, 0.000000, 0.000000);
				}
			}
		}
		case 478:
		{
			for(new i = 0; i < count; ++i)
			{
				switch (i)
				{
					case 0: SetVehicleAttachedObject(2912, 0, vehicleid, -0.354999, -0.949999, 0.000000, 0.000000, 0.000000, 0.000000);
					case 1: SetVehicleAttachedObject(2912, 1, vehicleid, 0.354999, -0.949999, 0.000000, 0.000000, 0.000000, 0.000000);
					case 2: SetVehicleAttachedObject(2912, 2, vehicleid, -0.354999, -1.664998, 0.000000, 0.000000, 0.000000, 0.000000);
					case 3: SetVehicleAttachedObject(2912, 3, vehicleid, 0.354999, -1.664998, 0.000000, 0.000000, 0.000000, 0.000000);
				}
			}
		}
		case 554:
		{
            if(s_vCommodityStorage[vehicleid][COMMODITY_BRICKS])
            {
            	SetVehicleAttachedObject(1685, 0, vehicleid, 0.000000, -1.754998, 0.859999, 0.000000, 0.000000, 0.000000);
            }
            else
			{
				for(new i = 0; i < count; ++i)
				{
					switch (i)
					{
						case 0: SetVehicleAttachedObject(2912, 0, vehicleid, -0.31250, -1.00700, -0.23710, 0.000000, 0.000000, 0.000000);
						case 1: SetVehicleAttachedObject(2912, 1, vehicleid, 0.42700, -1.00650, -0.23710, 0.000000, 0.000000, 0.000000);
						case 2: SetVehicleAttachedObject(2912, 2, vehicleid, 0.06740, -1.70740, -0.23710, 0.000000, 0.000000, 0.000000);
						case 3: SetVehicleAttachedObject(2912, 3, vehicleid, 0.06560, -2.40020, -0.23710, 0.000000, 0.000000, 0.000000);
						case 4: SetVehicleAttachedObject(2912, 4, vehicleid, 0.06553, -0.99522, 0.46057, 0.000000, 0.000000, 0.000000);
						case 5: SetVehicleAttachedObject(2912, 5, vehicleid, 0.07971, -1.69164, 0.46057, 0.0, 0.0, 0.0);
					}
				}
			}
		}
		case 578: // DFT-30
		{
            if(s_vCommodityStorage[vehicleid][COMMODITY_WOOD])
			{
				SetVehicleAttachedObject(18609, 0, vehicleid, 0.205000, -5.895015, 0.839999, 0.000000, 0.000000, 3.900000);
            }
			else if(s_vCommodityStorage[vehicleid][COMMODITY_BRICKS]) // bricks
			{
				for (new i = 0; i < count; ++i)
				{
					switch (i)
					{
						case 0: SetVehicleAttachedObject(1685, 0, vehicleid, 0.000000, -0.269999, 0.459999, 0.000000, 0.000000, 0.000000);
						case 1: SetVehicleAttachedObject(1685, 1, vehicleid, 0.000000, -2.044999, 0.459999, 0.000000, 0.000000, 0.000000);
						case 2: SetVehicleAttachedObject(1685, 2, vehicleid, 0.000000, -3.820039, 0.459999, 0.000000, 0.000000, 0.000000);
					}
				}
            }
			else if(s_vCommodityStorage[vehicleid][COMMODITY_TRANSFORMER])
			{
				SetVehicleAttachedObject(3273, 0, vehicleid, -0.000000, -0.404999, 0.799999, 0.000000, 90.449951, -90.449951);
			}
		}
		case 443:
		{
            if(s_vCommodityStorage[vehicleid][COMMODITY_VEHICLES] == 1)
			{
				SetVehicleAttachedObject(3593, 0, vehicleid, 0.205000, -5.895015, 0.839999, 0.000000, 0.000000, 3.900000);
			}
			else
			{
				SetVehicleAttachedObject(3593, 0, vehicleid, 0.000000, 0.344999, 1.819998, 15.074999, 0.000000, 0.000000);
				SetVehicleAttachedObject(3593, 1, vehicleid, -0.005000, -6.455012, 0.024998, 15.074999, 0.000000, 0.000000);
			}
		}
	}
 
	foreach (new i : Player)
	{
		if (!IsVehicleStreamedIn(vehicleid, i))
			continue;
 
		Streamer_Update(i, STREAMER_TYPE_OBJECT);
	}
	return true;
}

Trucker_ShowCargoList(playerid, vehicleid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	if (!IsValidVehicle(vehicleid))
		return false;

	if (!Trucker_CountVehicleStorage(vehicleid))
		return SendErrorMessage(playerid, "Não há nenhuma carga neste veículo..");

	if (IsPlayerInAnyVehicle(playerid) && (vehicleid != GetVehicleTrailer(GetPlayerVehicleID(playerid))))
		return SendErrorMessage(playerid, "Você deve sair do veículo primeiro.");

	if (!IsVehicleTrunkOpenned(vehicleid))
		return SendErrorMessage(playerid, "O porta-malas deste veículo está trancado.");

	new dialog[1024];

	for (new i = 0; i < MAX_COMMODITY; i++)
	{
		if (!s_vCommodityStorage[vehicleid][i]) continue;

		strcat (dialog, va_return("\n{FFFFFF}%s\t{B4B5B7}%i %s", Commodity_GetName(i), s_vCommodityStorage[vehicleid][i], Commodity_GetUnitName(i, s_vCommodityStorage[vehicleid][i])));
	}

	s_pVehicleInspecting[playerid] = vehicleid;
	Dialog_Show(playerid, DIALOG_COMMODITY_INSPECT, DIALOG_STYLE_TABLIST, VehicleData[vehicleid][e_VEHICLE_NAME], dialog, "Pegar", "Fechar");
	return true;
}

// Comandos
CMD:carga(playerid, params[])
{
	if(CharacterData[playerid][e_CHARACTER_JOB] != JOB_TRUCKER)
		return SendErrorMessage(playerid, "Você precisa ser um caminhoneiro para usar este comando.");
 
	static
		option[16],
		amount,
		id, commodity;

	if (sscanf(params, "s[16]I(0)", option, amount))
	{
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	    SendClientMessage(playerid, COLOR_BEGE, "USE: /carga [opção]");
	    SendClientMessage(playerid, COLOR_BEGE, "[Opção]: pegar, colocar, dropar, vender");
		SendClientMessage(playerid, COLOR_BEGE, "[Opção]: preco, lista");
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return true;
	}

	id = IndustryStorage_Nearest(playerid);

	if (!strcmp(option, "lista", true))
	{
		new vehicleid;

		if (IsPlayerInAnyVehicle(playerid))
		{
			vehicleid = GetPlayerVehicleID(playerid);

			if (GetVehicleTrailer(vehicleid))
			{
				vehicleid = GetVehicleTrailer(vehicleid);
			}
		}
		else
		{
			vehicleid = Vehicle_Nearest(playerid, 5.0);
		}

		if (vehicleid == -1)
		{
			return SendErrorMessage(playerid, "Você não está próximo de um veículo.");
		}

		Trucker_ShowCargoList(playerid, vehicleid);
	}
	else if (!strcmp(option, "colocar", true))
	{
		new vehicleid = Vehicle_Nearest(playerid, 5.0);

		if (vehicleid == -1)
			return SendErrorMessage(playerid, "Você não está próximo de um veículo.");

		if (!IsVehicleTrunkOpenned(vehicleid))
			return SendErrorMessage(playerid, "O porta-malas não está aberto.");

		if (IsPlayerFreeHands(playerid) || s_pCarryCrate[playerid] == -1)
			return SendErrorMessage(playerid, "Você não tem uma caixa em mãos.");

		if (Trucker_CountVehicleStorage(vehicleid) >= Trucker_GetVehicleCapacity(vehicleid))
			return SendErrorMessage(playerid, "O veículo não tem espaço disponível.");

		if (!Trucker_IsValidCommodity(vehicleid, s_pCarryCrate[playerid]))
			return SendErrorMessage(playerid, "Esse veículo não aceita este tipo de carga.");

		SendClientMessageEx(playerid, -1, "SERVER: Você colocou uma caixa de %s no porta-malas do veículo.", Commodity_GetLowerName(s_pCarryCrate[playerid]));
		s_vCommodityStorage[vehicleid][s_pCarryCrate[playerid]] += 1;
		Trucker_RemoveCarryCrate(playerid);
		ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
		Trucker_UpdateAttach(vehicleid);
	}
	else if (!strcmp(option, "dropar", true))
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendErrorMessage(playerid, "Você precisa estar a pé.");

		if (s_pCarryCrate[playerid] == -1 || IsPlayerFreeHands(playerid))
			return SendErrorMessage(playerid, "Você não tem uma caixa em mãos.");

		static crate;
		crate = DroppedCrate_Create(playerid, s_pCarryCrate[playerid]);

		if (crate == -1)
			return SendErrorMessage(playerid, "Não foi possível dropar a caixa que está em suas mãos.");

		ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
		SendClientMessageEx(playerid, -1, "SERVER: Você dropou uma caixa de %s.", Commodity_GetLowerName(s_pCarryCrate[playerid]));
		Trucker_RemoveCarryCrate(playerid);
	}
	else if (!strcmp(option, "pegar", true))
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return SendErrorMessage(playerid, "Você precisa estar a pé.");

		if (s_pCarryCrate[playerid] != -1 || !IsPlayerFreeHands(playerid))
			return SendErrorMessage(playerid, "Você está com suas mãos ocupadas.");

		new crate;
		crate = DroppedCrate_Nearest(playerid);

		if (crate == -1)
			return SendErrorMessage(playerid, "Você não está próximo de uma caixa.");

		Trucker_SetCarryCrate(playerid, DroppedCrateData[crate][e_DROPPED_CRATE_COMMODITY]);
		SendClientMessageEx(playerid, -1, "SERVER: Você pegou uma caixa de %s do chão.", Commodity_GetLowerName(DroppedCrateData[crate][e_DROPPED_CRATE_COMMODITY]));
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
		DroppedCrate_Destroy(crate);
	}
	else if (!strcmp(option, "comprar", true))
	{
		if (id == -1)
		{
			if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				id = IndustryStorage_Nearest(playerid, 10.0);

			if (id == -1)
				return SendErrorMessage(playerid, "Você não está próximo de um estoque de indústria.");
		}

		commodity = IndustryStorageData[id][e_INDUSTRY_STORAGE_COMMODITY];

		if (IndustryData[Industry_GetId(IndustryStorageData[id][e_INDUSTRY_STORAGE_PATTERN])][e_INDUSTRY_LOCKED])
			return SendErrorMessage(playerid, "Essa indústria está fechada, volte mais tarde.");

		if (!IndustryStorageData[id][e_INDUSTRY_STORAGE_SELLING])
			return SendErrorMessage(playerid, "A indústria procura por esse produto e não vende.");

		if (!IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK])
			return SendErrorMessage(playerid, "Esse estoque está vazio.");

		if (g_commodityType[commodity] == COMMODITY_TYPE_CRATE || g_commodityType[commodity] == COMMODITY_TYPE_METAL)
		{
			if (IsPlayerInAnyVehicle(playerid))
				return SendErrorMessage(playerid, "Você não pode comprar dentro de veículos.");

			if (!IsPlayerFreeHands(playerid))
				return SendErrorMessage(playerid, "Você não está com as mãos desocupadas.");

			if (Character_GetMoney(playerid) < IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE])
				return SendErrorMessage(playerid, "Você não tem dinheiro suficiente.");

			IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] -= 1;
			IndustryStorage_Refresh(id);
			IndustryStorage_Save(id);

			Character_GiveMoney(playerid, -IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]);
			ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
			Trucker_SetCarryCrate(playerid, commodity);

			SendClientMessageEx(playerid, COLOR_GREEN, "Você comprou uma caixa de %s por %s.", Commodity_GetLowerName(commodity), FormatMoney(IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
		}
		else
		{
			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				return SendErrorMessage(playerid, "Você precisa ser o motorista para comprar este tipo de carga.");

			if (amount < 1)
			{
				switch(g_commodityType[commodity])
				{
				    case COMMODITY_TYPE_LOOSE: // Loose
				    {
						SendClientMessage(playerid, -1, "Capacidade do Dump Trailer: {E5FF00}30 toneladas");
						SendClientMessage(playerid, -1, "Capacidade do Flatbed: {E5FF00}16 toneladas");
						SendClientMessage(playerid, -1, "Use {E5FF00}/carga comprar [toneladas]");
						return false;
				    }
				
				    case COMMODITY_TYPE_LIQUID: // Liquids
				    {
						SendClientMessage(playerid, -1, "Capacidade do Petrol Trailer: {E5FF00}40 litros");
						SendClientMessage(playerid, -1, "Use {E5FF00}/carga comprar [litros]");
						return false;
				    }

				    case COMMODITY_TYPE_OTHER: amount = 1;
				}
			}

			static vehicleid, trailerid;
			vehicleid = GetPlayerVehicleID(playerid);
			trailerid = GetVehicleTrailer(vehicleid);

			if (trailerid) vehicleid = trailerid;

			if (!Trucker_IsValidCommodity(vehicleid, commodity))
				return SendErrorMessage(playerid, "Esse veículo não aceita este tipo de carga.");

			if (!IsVehicleTrunkOpenned(vehicleid))
				return SendErrorMessage(playerid, "O porta-malas não está aberto ou o trailer está trancado.");

			if ((Trucker_CountVehicleStorage(vehicleid) + (Commodity_GetSlotSize(commodity) * amount)) > Trucker_GetVehicleCapacity(vehicleid))
				return SendErrorMessage(playerid, "Não há espaço suficiente no veículo.");

			if (IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] < amount)
				return SendErrorMessage(playerid, "A indústria não tem unidade suficiente.");

			if (Character_GetMoney(playerid) < (IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE] * amount))
				return SendErrorMessage(playerid, "Você não tem dinheiro suficiente.");

			if (Trucker_GetLoadedCargo(vehicleid) != -1 && Trucker_GetLoadedCargo(vehicleid) != commodity)
				return SendErrorMessage(playerid, "Seu veículo está carregado com outro produto.");

			if (g_commodityType[commodity] == COMMODITY_TYPE_OTHER)
			{
				s_vCommodityStorage[vehicleid][commodity] += 1;
				Character_GiveMoney(playerid, -IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]);
			}
			else
			{
				Character_GiveMoney(playerid, -(amount * IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
				s_vCommodityStorage[vehicleid][commodity] += amount;
			}

			SendClientMessageEx(playerid, COLOR_GREEN, "Você comprou %i %s de %s por %s.", amount, Commodity_GetUnitName(commodity, amount), Commodity_GetLowerName(commodity), FormatMoney(amount * IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
			Trucker_UpdateAttach(vehicleid);

			IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] -= amount;
			IndustryStorage_Refresh(id);
			IndustryStorage_Save(id);
		}
	}
	else if (!strcmp(option, "vender", true))
	{
		if ((id = IndustryStorage_Nearest(playerid, (IsPlayerInAnyVehicle(playerid) ? 10.0 : 2.5))) != -1)
		{
			commodity = IndustryStorageData[id][e_INDUSTRY_STORAGE_COMMODITY];

			if (IndustryData[Industry_GetId(IndustryStorageData[id][e_INDUSTRY_STORAGE_PATTERN])][e_INDUSTRY_LOCKED])
				return SendErrorMessage(playerid, "Essa indústria está fechada, volte mais tarde.");

			if (IndustryStorageData[id][e_INDUSTRY_STORAGE_SELLING])
				return SendErrorMessage(playerid, "A indústria vende esse produto e não compra.");

			if (IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] >= IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK_SIZE])
				return SendErrorMessage(playerid, "Esse estoque está cheio.");

			if (g_commodityType[commodity] == COMMODITY_TYPE_CRATE || g_commodityType[commodity] == COMMODITY_TYPE_METAL)
			{
				if (IsPlayerInAnyVehicle(playerid))
					return SendErrorMessage(playerid, "Você não pode vender uma caixa de dentro de um veículo.");

				if (s_pCarryCrate[playerid] == -1 || IsPlayerFreeHands(playerid))
					return SendErrorMessage(playerid, "Você não tem uma caixa em mãos.");

				if (IndustryStorageData[id][e_INDUSTRY_STORAGE_COMMODITY] != s_pCarryCrate[playerid])
					return SendErrorMessage(playerid, "Você não pode vender este produto aqui.");

				IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] += 1;
				IndustryStorage_Refresh(id);
				IndustryStorage_Save(id);

				Character_GiveMoney(playerid, IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]);
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
				Trucker_RemoveCarryCrate(playerid);

				SendClientMessageEx(playerid, COLOR_GREEN, "Você vendeu uma caixa de %s por %s.", Commodity_GetLowerName(commodity), FormatMoney(IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
			}
			else
			{
				if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
					return SendErrorMessage(playerid, "Você precisa ser o motorista para vender este tipo de carga.");

				if (!amount)
				{
					switch(g_commodityType[commodity])
					{
					    case COMMODITY_TYPE_LOOSE: // Loose
					    {
							SendClientMessage(playerid, -1, "Use {E5FF00}/carga vender [toneladas]");
					    }
					
					    case COMMODITY_TYPE_LIQUID: // Liquids
					    {
							SendClientMessage(playerid, -1, "Use {E5FF00}/carga vender [litros]");
					    }

					    case COMMODITY_TYPE_OTHER: amount = 1;
					}
				}

				static vehicleid, trailerid;
				vehicleid = GetPlayerVehicleID(playerid);
				trailerid = GetVehicleTrailer(vehicleid);

				if (trailerid) vehicleid = trailerid;

				if (!IsVehicleTrunkOpenned(vehicleid))
					return SendErrorMessage(playerid, "O porta-malas não está aberto ou o trailer está trancado.");

				if ((IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] + amount) > IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK_SIZE])
					return SendErrorMessage(playerid, "Não há espaço suficiente no estoque.");

				if (Trucker_GetLoadedCargo(vehicleid) != commodity)
					return SendErrorMessage(playerid, "Seu veículo não está carregado com este produto.");

				if (amount > s_vCommodityStorage[vehicleid][commodity])
					return SendErrorMessage(playerid, "Seu veículo não tem essa quantidade de produto.");

				if (g_commodityType[commodity] == COMMODITY_TYPE_OTHER)
				{
					SendClientMessageEx(playerid, COLOR_GREEN, "Você vendeu %i %s por %s.", amount, Commodity_GetUnitName(commodity, amount), FormatMoney(amount * IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
					s_vCommodityStorage[vehicleid][commodity] -= 1;
					Character_GiveMoney(playerid, IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREEN, "Você vendeu %i %s de %s por %s.", amount, Commodity_GetUnitName(commodity, amount), Commodity_GetLowerName(commodity), FormatMoney(amount * IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
					Character_GiveMoney(playerid, (amount * IndustryStorageData[id][e_INDUSTRY_STORAGE_PRICE]));
					s_vCommodityStorage[vehicleid][commodity] -= amount;
				}

				Trucker_UpdateAttach(vehicleid);

				IndustryStorageData[id][e_INDUSTRY_STORAGE_STOCK] += amount;
				IndustryStorage_Refresh(id);
				IndustryStorage_Save(id);
			}
		}
		else if ((id = Business_Nearest(playerid)) != -1)
		{
			if (g_commodityBusinessAcceptable[BusinessData[id][e_BUSINESS_TYPE]] == -1)
				return SendErrorMessage(playerid, "Esta empresa não compra carga.");

			if (!BusinessData[id][e_BUSINESS_REQUEST_QUANTITY])
				return SendErrorMessage(playerid, "Esta empresa não está procurando estoque.");

			commodity = BusinessData[id][e_BUSINESS_REQUEST_CARGO];

			if (g_commodityType[commodity] == COMMODITY_TYPE_CRATE || g_commodityType[commodity] == COMMODITY_TYPE_METAL)
			{
				if (IsPlayerInAnyVehicle(playerid))
					return SendErrorMessage(playerid, "Você precisa descer do veículo primeiro.");

				if (IsPlayerFreeHands(playerid))
					return SendErrorMessage(playerid, "Você não tem uma caixa em mãos.");

				if (s_pCarryCrate[playerid] == -1 || IsPlayerFreeHands(playerid))
					return SendErrorMessage(playerid, "Você não tem uma caixa em mãos.");

				if (s_pCarryCrate[playerid] != commodity)
					return SendErrorMessage(playerid, "A empresa não procura por esse produto.");

				if (BusinessData[id][e_BUSINESS_PRODUCTS] >= BusinessData[id][e_BUSINESS_PRODUCT_LIMIT])
					return SendErrorMessage(playerid, "O estoque da empresa está cheio.");

				if (BusinessData[id][e_BUSINESS_VAULT] < BusinessData[id][e_BUSINESS_REQUEST_PRICE] && BusinessData[id][e_BUSINESS_OWNER] != -1)
					return SendErrorMessage(playerid, "A empresa não tem dinheiro suficiente.");

				BusinessData[id][e_BUSINESS_PRODUCTS] += g_commodityBusinessMultiplier[commodity];
				BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] -= 1;
				BusinessData[id][e_BUSINESS_VAULT] -= BusinessData[id][e_BUSINESS_REQUEST_PRICE];

				if (BusinessData[id][e_BUSINESS_PRODUCTS] >= BusinessData[id][e_BUSINESS_PRODUCT_LIMIT])
				{
					BusinessData[id][e_BUSINESS_PRODUCTS] = BusinessData[id][e_BUSINESS_PRODUCT_LIMIT];
				}

				Character_GiveMoney(playerid, BusinessData[id][e_BUSINESS_REQUEST_PRICE]);
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
				Trucker_RemoveCarryCrate(playerid);

				if (!BusinessData[id][e_BUSINESS_REQUEST_QUANTITY])
				{
					BusinessData[id][e_BUSINESS_REQUEST_CARGO] = -1;
					BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] = 0;
					BusinessData[id][e_BUSINESS_REQUEST_PRICE] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "Você entregou a última caixa solicitada pela empresa.");
				}

				Business_Save(id);
			}
		}
		else SendErrorMessage(playerid, "Você não está próximo de uma indústria ou empresa.");
	}
	else SendErrorMessage(playerid, "Você especificou uma opção inválida.");

	return true;
}

CMD:trailer(playerid, params[])
{
	if(CharacterData[playerid][e_CHARACTER_JOB] != JOB_TRUCKER)
		return SendErrorMessage(playerid, "Você precisa ser um caminhoneiro para usar este comando.");
 
	new 
		option[12], 
		vehicleid, 
		trailerid
	;
 
	if(sscanf(params, "s[12]", option))
	{
	    SendClientMessage(playerid, COLOR_BEGE, "/trailer trancar {FFFFFF}- tranca / destranca o trailer engatado ao seu veiculo.");
	    SendClientMessage(playerid, COLOR_BEGE, "/trailer engatar {FFFFFF}- engata um trailer ao seu veiculo.");
	    SendClientMessage(playerid, COLOR_BEGE, "/trailer desengatar {FFFFFF}- desengata o trailer do seu veiculo.");
        SendClientMessage(playerid, COLOR_BEGE, "/trailer luzes {FFFFFF}- liga / desliga as luzes do trailer engatado.");
        SendClientMessage(playerid, COLOR_BEGE, "/trailer carga {FFFFFF}- exibe as cargas carregadas no trailer.");
        return 1;
	}
 
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "Você precisa ser o motorista do veículo.");
 
	vehicleid = GetPlayerVehicleID(playerid);
	trailerid = GetVehicleTrailer(vehicleid);
 
	if (!trailerid)
		return SendErrorMessage(playerid, "Nenhum trailer engatado.");
 
	// Trancar
	if (!strcmp(option, "trancar", true))
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(trailerid, engine, lights, alarm, doors, bonnet, boot, objective);
 
		doors = !doors;
 
		SetVehicleParamsEx(trailerid, engine, lights, alarm, doors, bonnet, boot, objective);
 
		GameTextForPlayer(playerid, (doors ?  ("~r~Trailer Trancado") : ("~g~Trailer Destrancado")), 3000, 4);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		return true;
	}
 
	// Desengatar
	else if (!strcmp(option, "desengatar", true))
	{
		DetachTrailerFromVehicle(vehicleid);
	}
 
	// Luzes
	else if (!strcmp(option, "luzes", true))
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(trailerid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(trailerid, engine, !lights, alarm, doors, bonnet, boot, objective);
	}
 
	// Carga
	else if (!strcmp(option, "carga", true))
	{
		if (!IsVehicleTrunkOpenned(trailerid))
			return SendErrorMessage(playerid, "O trailer está trancado.");
 
		if (!Trucker_CountVehicleStorage(trailerid))
			return SendErrorMessage(playerid, "O trailer está vazio.");
 
		Trucker_ShowCargoList(playerid, trailerid);
	}
 
	else SendClientMessage(playerid, COLOR_LIGHTRED, "Você digitou um parâmetro inválido.");
 
	return true;
}