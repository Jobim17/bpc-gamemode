/*
	ooooo                 .                       .o88o.
	`888'               .o8                       888 `"
	 888  ooo. .oo.   .o888oo  .ooooo.  oooo d8b o888oo   .oooo.    .ooooo.   .ooooo.
	 888  `888P"Y88b    888   d88' `88b `888""8P  888    `P  )88b  d88' `"Y8 d88' `88b
	 888   888   888    888   888ooo888  888      888     .oP"888  888       888ooo888
	 888   888   888    888 . 888    .o  888      888    d8(  888  888   .o8 888    .o
	o888o o888o o888o   "888" `Y8bod8P' d888b    o888o   `Y888""8o `Y8bod8P' `Y8bod8P'

*/

// Include
#include <YSI_Coding\y_hooks>

// Variáveis
static PlayerText:s_ptdBody[MAX_PLAYERS][7];
static PlayerText:s_ptdExtra[MAX_PLAYERS][4];

// Callbacks
hook OnPlayerConnect(playerid)
{
	// Create Background
	s_ptdBody[playerid][0] = CreatePlayerTextDraw(playerid, 540.000000, 130.000000, "ld_spac:white");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][0], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][0], 100.000000, 67.500000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][0], 2);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][0], -253326081);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][0], 0);

	s_ptdBody[playerid][1] = CreatePlayerTextDraw(playerid, 540.000000, 130.000000, "ld_spac:white");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][1], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][1], 100.000000, 20.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][1], 2);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][1], -2686721);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][1], 135);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][1], 0);

	s_ptdBody[playerid][2] = CreatePlayerTextDraw(playerid, 540.000000, 181.000000, "ld_spac:white");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][2], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][2], 100.000000, 20.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][2], 2);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][2], -2686721);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][2], 135);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][2], 0);

	s_ptdBody[playerid][3] = CreatePlayerTextDraw(playerid, 592.000000, 135.000000, "ENTRADA");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][3], 3);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][3], 0.300000, 1.200000);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][3], 80.000000, 80.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][3], 2);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][3], 75);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][3], 0);

	s_ptdBody[playerid][4] = CreatePlayerTextDraw(playerid, 639.000000, 142.000000, "");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][4], 0.150000, 0.699998);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][4], 80.000000, 80.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][4], 3);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][4], 75);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][4], 0);

	s_ptdBody[playerid][5] = CreatePlayerTextDraw(playerid, 543.000000, 154.000000, "");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][5], 0.200000, 0.800000);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][5], 640.000000, -100.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][5], 1);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][5], 75);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][5], 0);

	s_ptdBody[playerid][6] = CreatePlayerTextDraw(playerid, 543.000000, 184.000000, "");
	PlayerTextDrawFont(playerid, s_ptdBody[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, s_ptdBody[playerid][6], 0.200000, 0.800000);
	PlayerTextDrawTextSize(playerid, s_ptdBody[playerid][6], 640.000000, -100.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdBody[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdBody[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, s_ptdBody[playerid][6], 1);
	PlayerTextDrawColor(playerid, s_ptdBody[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBody[playerid][6], 75);
	PlayerTextDrawBoxColor(playerid, s_ptdBody[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, s_ptdBody[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, s_ptdBody[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdBody[playerid][6], 0);		

	// Extra
	s_ptdExtra[playerid][0] = CreatePlayerTextDraw(playerid, 540.000000, 203.000000, "ld_spac:white");
	PlayerTextDrawFont(playerid, s_ptdExtra[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, s_ptdExtra[playerid][0], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, s_ptdExtra[playerid][0], 15.000000, 15.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdExtra[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdExtra[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, s_ptdExtra[playerid][0], 2);
	PlayerTextDrawColor(playerid, s_ptdExtra[playerid][0], -13553153);
	PlayerTextDrawBackgroundColor(playerid, s_ptdExtra[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, s_ptdExtra[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, s_ptdExtra[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, s_ptdExtra[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdExtra[playerid][0], 0);

	s_ptdExtra[playerid][1] = CreatePlayerTextDraw(playerid, 556.000000, 203.000000, "ld_spac:white");
	PlayerTextDrawFont(playerid, s_ptdExtra[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, s_ptdExtra[playerid][1], 0.600000, 10.300003);
	PlayerTextDrawTextSize(playerid, s_ptdExtra[playerid][1], 85.000000, 15.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdExtra[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdExtra[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, s_ptdExtra[playerid][1], 2);
	PlayerTextDrawColor(playerid, s_ptdExtra[playerid][1], 572662327);
	PlayerTextDrawBackgroundColor(playerid, s_ptdExtra[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, s_ptdExtra[playerid][1], 135);
	PlayerTextDrawUseBox(playerid, s_ptdExtra[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, s_ptdExtra[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdExtra[playerid][1], 0);

	s_ptdExtra[playerid][2] = CreatePlayerTextDraw(playerid, 547.500000, 204.000000, "FOR~n~SALE");
	PlayerTextDrawFont(playerid, s_ptdExtra[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, s_ptdExtra[playerid][2], 0.150000, 0.699999);
	PlayerTextDrawTextSize(playerid, s_ptdExtra[playerid][2], 640.000000, -100.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdExtra[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdExtra[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, s_ptdExtra[playerid][2], 2);
	PlayerTextDrawColor(playerid, s_ptdExtra[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, s_ptdExtra[playerid][2], 75);
	PlayerTextDrawBoxColor(playerid, s_ptdExtra[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, s_ptdExtra[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, s_ptdExtra[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdExtra[playerid][2], 0);

	s_ptdExtra[playerid][3] = CreatePlayerTextDraw(playerid, 560.000000, 206.000000, "");
	PlayerTextDrawFont(playerid, s_ptdExtra[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, s_ptdExtra[playerid][3], 0.200000, 0.800000);
	PlayerTextDrawTextSize(playerid, s_ptdExtra[playerid][3], 640.000000, -100.000000);
	PlayerTextDrawSetOutline(playerid, s_ptdExtra[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, s_ptdExtra[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, s_ptdExtra[playerid][3], 1);
	PlayerTextDrawColor(playerid, s_ptdExtra[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, s_ptdExtra[playerid][3], 75);
	PlayerTextDrawBoxColor(playerid, s_ptdExtra[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, s_ptdExtra[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, s_ptdExtra[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, s_ptdExtra[playerid][3], 0);
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	for (new i = 0; i < sizeof s_ptdBody[]; i++)
	{
		PlayerTextDrawDestroy(playerid, s_ptdBody[playerid][i]);
	}

	for (new i = 0; i < sizeof s_ptdExtra[]; i++)
	{
		PlayerTextDrawDestroy(playerid, s_ptdExtra[playerid][i]);
	}
	return true;
}

hook OnPlayerEnterDynamicArea(playerid, areaid)
{
	new id;

	for (new i = 0; i < sizeof s_ptdBody[]; i++)
	{
		PlayerTextDrawHide(playerid, s_ptdBody[playerid][i]);
	}

	for (new i = 0; i < sizeof s_ptdExtra[]; i++)
	{
		PlayerTextDrawHide(playerid, s_ptdExtra[playerid][i]);
	}

	// Entrance
	if ((id = Entrance_Nearest(playerid)) != -1 || (id = Entrance_Inside(playerid)) != -1)
	{
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][0], 0x222222FF);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][1], 0x141414FF);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][2], 0x141414FF);
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][3], "Entrada");
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][4], va_return("%i", id));
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][5], EntranceData[id][e_ENTRANCE_NAME]);
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][6], Entrance_Inside(playerid) == -1 ? ("/entrar") : ("/sair"));
	
		for (new i = 0; i < sizeof s_ptdBody[]; i++)
		{
			PlayerTextDrawShow(playerid, s_ptdBody[playerid][i]);
		}
	}

	// Interações
	if ((id = Interact_Nearest(playerid)) != -1)
	{
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][0], 0xf1d87cFF);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][1], 0xffd125FF);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][2], 0xffd125FF);
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][3], "Interação");
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][4], va_return("%i", id));
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][5], Interact_ReturnType(InteractData[id][e_INTERACT_TYPE]));

		new out[32];
		GetDynamic3DTextLabelText(InteractData[id][e_INTERACT_LABEL], out);
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][6], out);
	
		for (new i = 0; i < sizeof s_ptdBody[]; i++)
		{
			PlayerTextDrawShow(playerid, s_ptdBody[playerid][i]);
		}
	}

	// Empresas
	if ((id = Business_Nearest(playerid)) != -1)
	{
		if (BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_VEHICLE_DEALER || BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_ADVERTISE)
			return true;

		PlayerTextDrawColor(playerid, s_ptdBody[playerid][0], -1378294017);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][1], 512819199);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][2], 512819199);
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][3], "Empresa");
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][4], va_return("%i", id));
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][5], BusinessData[id][e_BUSINESS_NAME]);

		new out[48];

		if (BusinessData[id][e_BUSINESS_OWNER] == 0)
		{
			strcat (out, "/comprar");

			PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][2], "FOR~n~SALE");
			PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][3], va_return("~g~~h~~h~%s", FormatMoney(BusinessData[id][e_BUSINESS_PRICE])));

			for (new i = 0; i < sizeof s_ptdExtra[]; i++)
			{
				PlayerTextDrawShow(playerid, s_ptdExtra[playerid][i]);
			}
		}
		else
		{
			if (BusinessData[id][e_BUSINESS_ENTRANCE_FEE] > 0)
			{
				PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][2], "TAX~n~ENT");
				PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][3], va_return("~g~~h~~h~%s", FormatMoney(BusinessData[id][e_BUSINESS_ENTRANCE_FEE])));

				for (new i = 0; i < sizeof s_ptdExtra[]; i++)
				{
					PlayerTextDrawShow(playerid, s_ptdExtra[playerid][i]);
				}
			}
		}

		if (!(BusinessData[id][e_BUSINESS_INSIDE_POS][0] == 0.0 && BusinessData[id][e_BUSINESS_INSIDE_POS][1] == 0.0 && BusinessData[id][e_BUSINESS_INSIDE_POS][2] == 0.0))
		{
			if (BusinessData[id][e_BUSINESS_LOCKED])
			{
				if (IsNull(out))
				{
					strcat (out, "/arrombar");
				}
				else
				{
					strcat (out, ", /arrombar");
				}
			}
			else
			{
				if (IsNull(out))
				{
					strcat (out, "/entrar");
				}
				else
				{
					strcat (out, ", /entrar");
				}
			}
		}

		if (IsNull(out)) format (out, sizeof out, "Sem comandos.");

		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][6], out);
	
		for (new i = 0; i < sizeof s_ptdBody[]; i++)
		{
			PlayerTextDrawShow(playerid, s_ptdBody[playerid][i]);
		}
	}

	// Casas
	if ((id = House_Nearest(playerid)) != -1)
	{
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][0], 0x6EC96CFF);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][1], 0x33AA33FF);
		PlayerTextDrawColor(playerid, s_ptdBody[playerid][2], 0x33AA33FF);
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][3], "Residência");
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][4], va_return("%i", id));
		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][5], va_return("%i %s, ~n~%i %s, ~n~São Paulo", HouseData[id][e_HOUSE_ID], ReturnStreet(HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1], true), ReturnAreaCode(HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1]), ReturnAreaName(HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1])));

		new out[128];
		out = "/campainha";

		if (HouseData[id][e_HOUSE_OWNER] == 0)
		{
			strcat (out, ", /comprar");

			PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][2], "FOR~n~SALE");
			PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][3], va_return("~g~~h~~h~%s", FormatMoney(HouseData[id][e_HOUSE_PRICE])));

			for (new i = 0; i < sizeof s_ptdExtra[]; i++)
			{
				PlayerTextDrawShow(playerid, s_ptdExtra[playerid][i]);
			}
		}
		else
		{
			if (HouseData[id][e_HOUSE_RENT_PRICE] > 0)
			{
				strcat (out, ", /alugar");
				
				PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][2], "FOR~n~RENT");
				PlayerTextDrawSetString(playerid, s_ptdExtra[playerid][3], va_return("~g~~h~~h~%s", FormatMoney(HouseData[id][e_HOUSE_RENT_PRICE])));

				for (new i = 0; i < sizeof s_ptdExtra[]; i++)
				{
					PlayerTextDrawShow(playerid, s_ptdExtra[playerid][i]);
				}
			}
		}

		if (!(HouseData[id][e_HOUSE_INSIDE_POS][0] == 0.0 && HouseData[id][e_HOUSE_INSIDE_POS][1] == 0.0 && HouseData[id][e_HOUSE_INSIDE_POS][2] == 0.0))
		{
			if (HouseData[id][e_HOUSE_LOCKED])
			{
				strcat (out, ", /arrombar");
			}
			else
			{
				strcat (out, ", /entrar");
			}
		}

		if (IsNull(out)) format (out, sizeof out, "Sem comandos.");

		PlayerTextDrawSetString(playerid, s_ptdBody[playerid][6], out);
		
		for (new i = 0; i < sizeof s_ptdBody[]; i++)
		{
			PlayerTextDrawShow(playerid, s_ptdBody[playerid][i]);
		}
	}

	return true;
}

hook OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if (IsPlayerInAnyDynamicArea(playerid))
		return false;

	for (new i = 0; i < sizeof s_ptdBody[]; i++)
	{
		PlayerTextDrawHide(playerid, s_ptdBody[playerid][i]);
	}

	for (new i = 0; i < sizeof s_ptdExtra[]; i++)
	{
		PlayerTextDrawHide(playerid, s_ptdExtra[playerid][i]);
	}
	return true;
}