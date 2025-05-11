/*
	ooooooooooooo ooooooooo.   oooooooooo.         .o.
	8'   888   `8 `888   `Y88. `888'   `Y8b       .888.
	     888       888   .d88'  888      888     .8"888.
	     888       888ooo88P'   888      888    .8' `888.
	     888       888          888      888   .88ooo8888.
	     888       888          888     d88'  .8'     `888.
	    o888o     o888o        o888bood8P'   o88o     o8888o
*/

static s_pNavigatingIndustry[MAX_PLAYERS];

// Dialogs
Dialog:DIALOG_TPDA_MAIN(playerid, response, listitem, inputtext[])
{
	if (!response)
		return true;

	switch (listitem)
	{	
		case 0: Trucker_ShowAllIndustries(playerid);
		case 1: Trucker_ShowCargoShip(playerid);
		case 2: Trucker_ShowBusiness(playerid, 0);
		default: Trucker_ShowPDAHome(playerid);
	}

	return true;
}

Dialog:DIALOG_TPDA_ALL(playerid, response, listitem, inputtext[])
{
	if (!response)
		return Trucker_ShowPDAHome(playerid);

	if ((0 <= listitem < MAX_INDUSTRY) && IndustryData[listitem][e_INDUSTRY_EXISTS])
	{
		Trucker_ShowIndustry(playerid, listitem + 1);
	}
	else
	{
		Trucker_ShowAllIndustries(playerid);
	}

	return true;
}

Dialog:DIALOG_TPDA_SHIP(playerid, response, listitem, inputtext[])
{
	if (!response)
		return Trucker_ShowPDAHome(playerid);

	return true;
}

Dialog:DIALOG_TPDA_INDUSTRY(playerid, response, listitem, inputtext[])
{
	if (!response)
		return Trucker_ShowAllIndustries(playerid);

	Trucker_ShowStorages(playerid, s_pNavigatingIndustry[playerid]);
	return true;
}

Dialog:DIALOG_TPDA_STORAGES(playerid, response, listitem, inputtext[])
{
	if (!response)
		return Trucker_ShowIndustry(playerid, s_pNavigatingIndustry[playerid]);

	new count = 0;

	foreach (new i : IndustryStorages)
	{
		if (IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN] != IndustryData[s_pNavigatingIndustry[playerid]][e_INDUSTRY_ID])
			continue;

		if (count == listitem)
		{
			SendClientMessageEx(playerid, COLOR_PINK, "Indústria '%s' marcada em seu mapa. Por favor, siga o checkpoint vermelho.", IndustryData[s_pNavigatingIndustry[playerid]][e_INDUSTRY_NAME]);
			break;
		}

		count += 1;
	}
	return true;
}

// Funções
Trucker_ShowPDAHome(playerid)
{
	Dialog_Show(playerid, DIALOG_TPDA_MAIN, DIALOG_STYLE_LIST, "PDA", "{B4B5B7}Exibir {FFFFFF}Todas as Indústrias\n{B4B5B7}Exibir {FFFFFF}Informações do Navio\n{B4B5B7}Exibir {FFFFFF}Empresas Aceitando Carga", "Selecionar", "Fechar");
	return true;
}

Trucker_ShowAllIndustries(playerid)
{
	new dialog[1024 + 1024 + 1024] = "", count = 0;

	foreach (new i : Industries)
	{
		if (!IndustryData[i][e_INDUSTRY_EXISTS]) 
			continue;

		if (IndustryData[i][e_INDUSTRY_TYPE] == 0)
			continue;

		strcat (dialog, va_return("%s{FFFFFF}%s ({B4B5B7}%s{FFFFFF}, {%s}%s{FFFFFF})", (!count ? ("") : ("\n")), IndustryData[i][e_INDUSTRY_NAME], Industry_ReturnType(IndustryData[i][e_INDUSTRY_TYPE]), IndustryData[i][e_INDUSTRY_LOCKED] ? ("CD324D") : ("A4D247"), IndustryData[i][e_INDUSTRY_LOCKED] ? ("fechada") : ("aberta")));
		count += 1;
	}

	Dialog_Show(playerid, DIALOG_TPDA_ALL, DIALOG_STYLE_LIST, "PDA - Todas as Indústrias", dialog, "Selecionar", "Fechar");
	return true;
}

Trucker_ShowIndustry(playerid, id)
{
	if (!(0 <= id < MAX_INDUSTRY) || !IndustryData[id][e_INDUSTRY_EXISTS])
		return Trucker_ShowAllIndustries(playerid);

	new dialog[1024];

	format (dialog, sizeof dialog, "{FFFFFF}Bem-vindo à {A4D247}%s{FFFFFF}!\n\nA indústria está atualmente {%s}%s{FFFFFF}.", IndustryData[id][e_INDUSTRY_NAME], (IndustryData[id][e_INDUSTRY_LOCKED] ? ("CD324D") : ("A4D247")), (IndustryData[id][e_INDUSTRY_LOCKED] ? ("fechada") : ("aberta")));

	strcat (dialog, "\n\n{A4D247}À venda:\n{B4B5B7}");

	if (IndustryData[id][e_INDUSTRY_TYPE] == 3)
	{
		strcat (dialog, "Esta é uma indústria terciária e não vende produtos.");
	}	
	else
	{
		strcat (dialog, va_return("%019s\t%019s\t%019s\t%019s", "Produto", "Preço", "Produção/Hora", "Estoque (máximo)"));
	
		foreach (new i : IndustryStorages)
		{
			if (IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN] != IndustryData[id][e_INDUSTRY_ID])
				continue;

			if (!IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING])
				continue;

			strcat (dialog, va_return("\n{FFFFFF}%018s%s\t%019s\t%019s\t%019s", Commodity_GetName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY]), (strlen(Commodity_GetName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY])) < 8 ? ("\t") : ("")), FormatMoney(IndustryStorageData[i][e_INDUSTRY_STORAGE_PRICE]), va_return("+%i %s", IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION], IndustryData[id][e_INDUSTRY_TYPE] == 2 ? ("por recurso") : ("\t")), va_return("%i %s {B4B5B7}(%i)", IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK], Commodity_GetUnitName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY], IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK]), IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE])));
		}
	}

	strcat (dialog, "\n\n{A4D247}Procura-se:\n{B4B5B7}");

	if (IndustryData[id][e_INDUSTRY_TYPE] == 1)
	{
		strcat (dialog, "Esta é uma indústria primária e não compra produtos.");
	}	
	else
	{
		strcat (dialog, va_return("%021s\t%019s\t%019s\t%019s", "Produto", "Preço", "Consumo/Hora", "Estoque (máximo)"));
	
		foreach (new i : IndustryStorages)
		{
			if (IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN] != IndustryData[id][e_INDUSTRY_ID])
				continue;

			if (IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING])
				continue;

			strcat (dialog, va_return("\n{FFFFFF}%018s%s\t%019s\t%019s\t%019s", Commodity_GetName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY]), (strlen(Commodity_GetName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY])) < 8 ? ("\t") : ("")), FormatMoney(IndustryStorageData[i][e_INDUSTRY_STORAGE_PRICE]), va_return("-%i %s", IndustryStorageData[i][e_INDUSTRY_STORAGE_CONSUMPTION], IndustryStorageData[id][e_INDUSTRY_STORAGE_CONSUMPTION] == 1 ? ("unidade") : ("unidades")), va_return("%i %s {B4B5B7}(%i)", IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK], Commodity_GetUnitName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY], IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK]), IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE])));
		}
	}
	
	s_pNavigatingIndustry[playerid] = id;
	Dialog_Show(playerid, DIALOG_TPDA_INDUSTRY, DIALOG_STYLE_MSGBOX, IndustryData[id][e_INDUSTRY_NAME], dialog, "Ver mais", "Voltar");
	return true;
}

Trucker_ShowStorages(playerid, id)
{
	if (!(0 <= id < MAX_INDUSTRY) || !IndustryData[id][e_INDUSTRY_EXISTS])
		return Trucker_ShowAllIndustries(playerid);

	new dialog[1024] = "{FFFFFF}Produto\t{FFFFFF}Preço\t{FFFFFF}Estoque";

	foreach (new i : IndustryStorages)
	{
		if (IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN] != IndustryData[id][e_INDUSTRY_ID])
			continue;

		strcat (dialog, va_return("\n{FFFFFF}%s: {A4D247}%s\t{33AA33}%s\t{FFFFFF}%i {B4B5B7}(%i)", (IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING] ? ("vende-se") : ("procura-se")), Commodity_GetLowerName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY]), FormatMoney(IndustryStorageData[i][e_INDUSTRY_STORAGE_PRICE]), IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK], IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE]));
	}

	Dialog_Show(playerid, DIALOG_TPDA_STORAGES, DIALOG_STYLE_TABLIST_HEADERS, IndustryData[id][e_INDUSTRY_NAME], dialog, "Localizar", "Voltar");
	return true;
}

Trucker_ShowCargoShip(playerid)
{
	new dialog[1024];

	format (dialog, sizeof dialog, "{FFFFFF}Bem-vindo ao {A4D247}Navio{FFFFFF}!\n\nO navio {A4D247}%s{FFFFFF} está atualmente {%s}%s{FFFFFF}.", CargoShip_GetName(), (CargoShip_IsDocked() ? ("A4D247") : ("CD324D")), (CargoShip_IsDocked() ? ("ancorado") : ("desancorado")));

	strcat (dialog, "\n\n{A4D247}Horários aproximados:\n{FFFFFF}");

	if (CargoShip_IsDocked())
	{
		strcat (dialog, va_return("O navio chegou às %s\nO navio parte às %s\nPróximo navio chega às %s", TimestampFormat(s_shipDockedTime), TimestampFormat(s_shipDepartureTime), TimestampFormat(s_shipNextTime)));
	}
	else
	{
		strcat (dialog, va_return("O navio anterior partiu às %s\nO próximo navio chega às %s", TimestampFormat(s_shipDepartureTime), TimestampFormat(s_shipNextTime)));
	}

	strcat (dialog, "\n\n{A4D247}À venda:\n{B4B5B7}O navio não vende nada. Ele apenas compra cargas de São Paulo.");


	strcat (dialog, "\n\n{A4D247}Procura-se:\n{B4B5B7}");
	strcat (dialog, va_return("%019s\t%019s\t%019s", "Produto", "Preço", "Estoque (máximo)"));
	
	foreach (new i : IndustryStorages)
	{
		if (IndustryStorageData[i][e_INDUSTRY_STORAGE_PATTERN] != 1)
			continue;

		if (IndustryStorageData[i][e_INDUSTRY_STORAGE_SELLING])
			continue;

		strcat (dialog, va_return("\n{FFFFFF}%018s%s\t%019s\t%019s", Commodity_GetName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY]), (strlen(Commodity_GetName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY])) < 8 ? ("\t") : ("")), FormatMoney(IndustryStorageData[i][e_INDUSTRY_STORAGE_PRICE]), va_return("%i %s {B4B5B7}(%i)", IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK], Commodity_GetUnitName(IndustryStorageData[i][e_INDUSTRY_STORAGE_COMMODITY], IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK]), IndustryStorageData[i][e_INDUSTRY_STORAGE_STOCK_SIZE])));
	}
	
	Dialog_Show(playerid, DIALOG_TPDA_SHIP, DIALOG_STYLE_MSGBOX, "PDA - Informações do Navio", dialog, "Fechar", "Voltar");
	return true;
}

Trucker_ShowBusiness(playerid, page)
{
	new totalPage = 0, totalBusiness = 0, businessList[MAX_BUSINESS], offset, rows = 0;

	for (new i = 0; i < MAX_BUSINESS; i++)
	{
		businessList[i] = -1;

		if (BusinessData[i][e_BUSINESS_EXISTS] && Business_IsAcceptingCargo(i))
		{
			businessList[totalBusiness] = i;
			totalBusiness += 1;
		}
	}

	// Set total page
	totalPage = (totalBusiness + (10 - 1)) / 10;

	if (page < 0) page = 0;
	if (page >= totalPage) page = totalPage -1;

	offset = (page * 10);

	if (offset < 0) offset = 0;

	// Display
	new dialog[1024 + 1];

	if (page > 0)
	{
		strcat(dialog, va_return("{C5E66C}« Página %i\n", page - 1));
	}

	for (new i = offset; i < (offset + 10); i++)
	{
		new idx = businessList[i];

		if (idx == -1 || idx >= MAX_BUSINESS)
			break;

		strcat (dialog, va_return("{FFFFFF}%016s\t%s / unidade\t\tprocura-se: %i %016s\t%s\n", Commodity_GetLowerName(BusinessData[idx][e_BUSINESS_REQUEST_CARGO]), FormatMoney(BusinessData[idx][e_BUSINESS_REQUEST_PRICE]), BusinessData[idx][e_BUSINESS_REQUEST_QUANTITY], Commodity_GetUnitName(BusinessData[idx][e_BUSINESS_REQUEST_CARGO], BusinessData[idx][e_BUSINESS_REQUEST_QUANTITY]), BusinessData[idx][e_BUSINESS_NAME]));
		rows += 1;
	}

	if (rows == 10 && page < (totalPage - 1))
	{
		strcat(dialog, va_return("{C5E66C}Página %i »", page + 1));
	}

	if (!rows)
		return SendErrorMessage(playerid, "Nenhuma empresa aceitando carga foi encontrada.");

	Dialog_Show(playerid, DIALOG_TPDA_BUSINESS, DIALOG_STYLE_LIST, va_return("PDA do Caminhoneiro - Empresas Aceitando Carga {BBBBBB}[página %i]", page + 1), dialog, "Selecionar", "Voltar");
	return true;
}

// Comandos
CMD:pda(playerid)
{
	if (CharacterData[playerid][e_CHARACTER_JOB] != JOB_TRUCKER)
		return SendErrorMessage(playerid, "Você precisa ser um caminhoneiro para usar este comando.");

	Trucker_ShowPDAHome(playerid);
	return true;
}