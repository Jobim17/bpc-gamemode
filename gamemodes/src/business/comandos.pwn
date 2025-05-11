/*
	  .oooooo.                                                           .o8
	 d8P'  `Y8b                                                         "888
	888           .ooooo.  ooo. .oo.  .oo.    .oooo.   ooo. .oo.    .oooo888   .ooooo.   .oooo.o
	888          d88' `88b `888P"Y88bP"Y88b  `P  )88b  `888P"Y88b  d88' `888  d88' `88b d88(  "8
	888          888   888  888   888   888   .oP"888   888   888  888   888  888   888 `"Y88b.
	`88b    ooo  888   888  888   888   888  d8(  888   888   888  888   888  888   888 o.  )88b
	 `Y8bood8P'  `Y8bod8P' o888o o888o o888o `Y888""8o o888o o888o `Y8bod88P" `Y8bod8P' 8""888P'

*/


CMD:msgempresa(playerid, params[])
{
	new
		id = -1;

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id))
	{
		if (IsNull(params))
		    return SendUsageMessage(playerid, "/msgempresa [mensagem] - Utilize \"nenhuma\" para desabilitar.");

		if (!strcmp(params, "nenhuma", true))
		{
		    BusinessData[id][e_BUSINESS_MESSAGE][0] = '\0';

			Business_Save(id);
			SendClientMessageEx(playerid, COLOR_GREEN, "Voc� removeu a mensagem de entrada da sua empresa.");
		}
		else
		{
			format(BusinessData[id][e_BUSINESS_MESSAGE], 128, params);

			Business_Save(id);
			SendClientMessageEx(playerid, COLOR_GREEN, "A mensagem da empresa foi alterada para: \"%s\".", params);
		}
	}
	else SendErrorMessage(playerid, "Voc� n�o est� pr�ximo de nenhuma de suas empresas.");
	return 1;
}

CMD:empresaradio(playerid, params[])
{
	new
		id = -1;

    if ((id = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, id))
	{
		if (IsNull(params))
		    return SendUsageMessage(playerid, "/empresaradio [url] (use 'off' para desliga-lo)");

		if (strlen(params) > 255)
		    return SendErrorMessage(playerid, "O URL da r�dio/m�sica n�o pode execeder 255 caracteres.");

		if(!strcmp(params, "off", true) && strlen(params) == 3)
		{
			format(BusinessData[id][e_BUSINESS_RADIO], 255, "");
			Business_Save(id);

			SendClientMessageEx(playerid, COLOR_GREEN, "Voc� desativou o URL do r�dio/m�sica da empresa.", params);
		}
		else
		{
			format(BusinessData[id][e_BUSINESS_RADIO], 255, params);
			Business_Save(id);

			SendClientMessageEx(playerid, COLOR_GREEN, "O URL do r�dio/m�sica da empresa foi alterado para: \"%s\".", params);
		}
		
	}
	else 
		return SendErrorMessage(playerid, "Voc� n�o est� dentro de nenhuma de suas empresas.");

	return 1;
}

CMD:cofre(playerid, params[])
{
    static
	    bizid = -1,
		type[24],
		str[12],
		amount;

	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid))
	{
	    if (sscanf(params, "s[24]S()[12]", type, str))
	    {
	        SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
			SendClientMessageEx(playerid, COLOR_BEGE, "USE: /cofre [op��o] (%s dispon�vel)", FormatMoney(BusinessData[bizid][e_BUSINESS_VAULT]));
	        SendClientMessage(playerid, COLOR_BEGE, "[Op��es]: sacar, depositar, saldo");
	        SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	        return 1;
		}
		if (!strcmp(type, "sacar", true))
		{
		    if (sscanf(str, "d", amount))
		        return SendUsageMessage(playerid, "/cofre [sacar] [quantidade]");

			if (amount < 1 || amount > BusinessData[bizid][e_BUSINESS_VAULT])
			    return SendErrorMessage(playerid, "A quantidade especificada � inv�lida!");

            BusinessData[bizid][e_BUSINESS_VAULT] -= amount;
            Business_Save(bizid);

            Character_GiveMoney(playerid, amount);
            SendNearbyMessage(playerid, COLOR_PURPLE, 30.0, "* %s saca %s do cofre da empresa.", Character_GetName(playerid), FormatMoney(amount));
		}
		else if (!strcmp(type, "depositar", true))
		{
		    if (sscanf(str, "d", amount))
		        return SendUsageMessage(playerid, "/cofre [depositar] [quantidade]");

			if (amount < 1 || amount > Character_GetMoney(playerid))
			    return SendErrorMessage(playerid, "A quantidade especificada � inv�lida!");

            BusinessData[bizid][e_BUSINESS_VAULT] += amount;
            Business_Save(bizid);

            Character_GiveMoney(playerid, -amount);
            SendNearbyMessage(playerid, COLOR_PURPLE, 30.0, "* %s deposita %s no cofre da empresa.", Character_GetName(playerid), FormatMoney(amount));
		}
		else if (!strcmp(type, "saldo", true))
		{
		    SendClientMessageEx(playerid, COLOR_GREEN, "\"%s\" possui no cofre um total de: %s.", BusinessData[bizid][e_BUSINESS_NAME], FormatMoney(BusinessData[bizid][e_BUSINESS_VAULT]));
		}
	}
	else SendErrorMessage(playerid, "Voc� n�o est� no interior da sua empresa.");
	return 1;
}

CMD:infoempresa(playerid, params[])
{
    new
		id = -1;

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id)) {
        if(BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_GAS_STATION)
     		SendClientMessageEx(playerid, COLOR_GREEN, "ID: %d | Empresa: %s | Produtos: %d | Gal�es de Combust�vel: %i | Cofre: %s", id, BusinessData[id][e_BUSINESS_NAME], BusinessData[id][e_BUSINESS_PRODUCTS], BusinessData[id][e_BUSINESS_FUEL], FormatMoney(BusinessData[id][e_BUSINESS_VAULT]));
        else
     		SendClientMessageEx(playerid, COLOR_GREEN, "ID: %d | Empresa: %s | Produtos: %d | Cofre: %s", id, BusinessData[id][e_BUSINESS_NAME], BusinessData[id][e_BUSINESS_PRODUCTS], FormatMoney(BusinessData[id][e_BUSINESS_VAULT]));
	}
	else SendErrorMessage(playerid, "Voc� n�o est� pr�ximo a sua empresa.");
	return 1;
}

CMD:taxaempresa(playerid, params[])
{
	new
		id = -1, tax;

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id))
	{
		if(sscanf(params, "d", tax))
			return SendUsageMessage(playerid, "/taxaempresa [valor]");

		if (tax < 0 || tax > 10000)
		    return SendErrorMessage(playerid, "O valor deve ser acima de $0 e menor que $10,000.");

		BusinessData[id][e_BUSINESS_ENTRANCE_FEE] = tax;

		SendClientMessageEx(playerid, COLOR_GREEN, "O valor de entrada de sua empresa foi alterado para: %s.", FormatMoney(tax));

		Business_Save(id);
	}
	else SendErrorMessage(playerid, "Voc� n�o est� pr�ximo de nenhuma de suas empresas.");
	return 1;
}

CMD:abrirempresa(playerid, params[])
{
	new bizid = Business_Inside(playerid);

	if(bizid == -1)
		return SendErrorMessage(playerid, "Voc� n�o est� em uma empresa.");

	if(!Business_IsOwner(playerid, bizid))
		return SendErrorMessage(playerid, "Voc� n�o � dono desta empresa.");

	if(BusinessData[bizid][e_BUSINESS_OPEN])
		return SendErrorMessage(playerid, "Sua empresa j� est� aberta e encontra-se na lista de estabelecimentos abertos do aplicativo Locais.");

	BusinessData[bizid][e_BUSINESS_OPEN] = true;
	SendClientMessageEx(playerid, COLOR_GREEN, "Voc� abriu sua empresa, ela encontra-se na lista de estabelecimentos abertos no aplicativo Locais.");

	if(BusinessData[bizid][e_BUSINESS_LOCKED])
		SendClientMessage(playerid, 0xFF00FFFF, "Info: Esta a��o n�o destranca sua empresa. Pra destranca-la use o comando /trancar.");
	return 1;
}

CMD:fecharempresa(playerid, params[])
{
	new bizid = Business_Inside(playerid);

	if(bizid == -1)
		return SendErrorMessage(playerid, "Voc� n�o est� em uma empresa.");

	if(!Business_IsOwner(playerid, bizid))
		return SendErrorMessage(playerid, "Voc� n�o � dono desta empresa.");
	
	if(!BusinessData[bizid][e_BUSINESS_OPEN])
		return SendErrorMessage(playerid, "Sua empresa n�o est� aberta.");

	BusinessData[bizid][e_BUSINESS_OPEN] = false;
	SendClientMessageEx(playerid, COLOR_GREEN, "Voc� fechou sua empresa, ela n�o ser� vis�vel no aplicativo Locais.");
	
	if(!BusinessData[bizid][e_BUSINESS_LOCKED])
		SendClientMessage(playerid, 0xFF00FFFF, "Info: Esta a��o n�o tranca sua empresa. Pra tranca-la use o comando /trancar.");
	
	return 1;
}

CMD:precocarga(playerid, params[])
{
	new id, price, type, qtd, cargo;
	id = Business_Inside(playerid);

    if (id == -1)
 		return SendErrorMessage(playerid, "Voc� n�o est� dentro de uma empresa!");

 	if (Business_IsOwner(playerid, id))
	{
		if (g_commodityBusinessAcceptable[BusinessData[id][e_BUSINESS_TYPE]] == -1)
			return SendErrorMessage(playerid, "Esta empresa n�o aceita nenhum tipo de carga.");

		if (BusinessData[id][e_BUSINESS_PRODUCTS] >= BusinessData[id][e_BUSINESS_PRODUCT_LIMIT])
			return SendErrorMessage(playerid, "Esta empresa est� com o estoque cheio.");

		if (sscanf(params, "iI(0)I(-1)", price, qtd, type) || BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_GAS_STATION && type == -1 && price > 0)
		{
			SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");

	      	if (BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_GAS_STATION)
	      	{
	      		SendClientMessage(playerid, COLOR_BEGE, "USE: /precocarga [pre�o] [quantidade de caixas/gal�es] [tipo]");
	      		SendClientMessage(playerid, COLOR_BEGE, "[Informa��o]: Se voc� quiser desligar o pedido de carga digite '/precocarga 0'.");
	      		SendClientMessage(playerid, COLOR_BEGE, "[Informa��o]: Esta empresa � do tipo Posto de Gasolina, use o tipo 1 para Combust�vel e 0 para Caixa.");
	      	}
	      	else
	      	{
	      		SendClientMessage(playerid, COLOR_BEGE, "USE: /precocarga [pre�o] [quantidade de caixas]");
	      		SendClientMessage(playerid, COLOR_BEGE, "[Informa��o]: Se voc� quiser desligar o pedido de carga digite '/precocarga 0'.");
	      	}

	      	SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
			return 1;
		}

		if (price == 0 && qtd == 0)
		{
			BusinessData[id][e_BUSINESS_REQUEST_CARGO] = -1;
			BusinessData[id][e_BUSINESS_REQUEST_PRICE] = 0;
			BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] = 0;
			Business_Save(id);

			SendClientMessageEx(playerid, -1, "Sua empresa n�o est� mais aceitando cargas.");
			return true;
		}

		if (qtd < 0)
			return SendErrorMessage(playerid, "Voc� n�o pode inserir quantidade negativa.");

		if (!(1 <= price <= 9999))
			return SendErrorMessage(playerid, "O limite m�ximo a ser pago por uma carga � de $9,999.");

		if (BusinessData[id][e_BUSINESS_TYPE] == BUSINESS_TYPE_GAS_STATION && type == 1)
			cargo = COMMODITY_FUEL;
		else
			cargo = g_commodityBusinessAcceptable[BusinessData[id][e_BUSINESS_TYPE]];

		// Send message
		BusinessData[id][e_BUSINESS_REQUEST_CARGO] = cargo;
		BusinessData[id][e_BUSINESS_REQUEST_PRICE] = price;
		BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] = qtd;
		Business_Save(id);

		SendClientMessageEx(playerid, COLOR_GREY, "Voc� alterou o pre�o de carga da sua empresa para {FFFFFF}%s{AFAFAF} com {FFFFFF}%i {AFAFAF}%s.", FormatMoney(price), qtd, Commodity_GetUnitName(cargo, qtd));
	}
	else
	{
	    SendErrorMessage(playerid, "Voc� precisa ser o dono da empresa.");
	}
	return 1;
}