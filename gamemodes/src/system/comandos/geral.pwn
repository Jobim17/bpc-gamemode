/*
      .oooooo.                                                           .o8
     d8P'  `Y8b                                                         "888
    888           .ooooo.  ooo. .oo.  .oo.    .oooo.   ooo. .oo.    .oooo888   .ooooo.   .oooo.o
    888          d88' `88b `888P"Y88bP"Y88b  `P  )88b  `888P"Y88b  d88' `888  d88' `88b d88(  "8
    888          888   888  888   888   888   .oP"888   888   888  888   888  888   888 `"Y88b.
    `88b    ooo  888   888  888   888   888  d8(  888   888   888  888   888  888   888 o.  )88b
     `Y8bood8P'  `Y8bod8P' o888o o888o o888o `Y888""8o o888o o888o `Y8bod88P" `Y8bod8P' 8""888P'
*/

// Variáveis
static s_pLastCommand[MAX_PLAYERS];
static s_pCommandCount[MAX_PLAYERS];

// Callbacks
public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if ((GetTickCount() - s_pLastCommand[playerid]) < 600)
    {
        s_pCommandCount[playerid] += 1;
        s_pLastCommand[playerid] = GetTickCount();

        if (s_pCommandCount[playerid] >= 3)
        {
            SendErrorMessage(playerid, "Você precisa aguardar alguns segundos para executar outro comando.");
            return 0;
        }
    }
    else
    {
        s_pCommandCount[playerid] = 0;
    }

    s_pLastCommand[playerid] = GetTickCount();
    return true;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "{ADC3E7}ERRO: {FFFFFF}Desculpe, este comando não existe. {ADC3E7}/ajuda{FFFFFF} ou {ADC3E7}/sos{FFFFFF} se você precisar de assistência.");
        return 0;
    }

    return 1;
}

// Closed Beta
CMD:pegaradmin(playerid)
{
    if (GetGVarInt("CLOSED_BETA") == 0)
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "{ADC3E7}ERRO: {FFFFFF}Desculpe, este comando não existe. {ADC3E7}/ajuda{FFFFFF} ou {ADC3E7}/sos{FFFFFF} se você precisar de assistência.");
    }
    else
    {
        if (AccountData[playerid][e_ACCOUNT_ADMIN])
            return SendErrorMessage(playerid, "Você já é um administrador.");

        AccountData[playerid][e_ACCOUNT_ADMIN] = 4;
        AccountData[playerid][e_ACCOUNT_ADMIN_TEAMS] = 0;
    }

    return true;
}

// Comandos
CMD:entrar(playerid)
{
    if (!Damage_IsAlive(playerid))
        return SendErrorMessage(playerid, "Você não pode usar esse comando estando ferido ou morto.");

    if (!IsPlayerSpawned(playerid))
        return SendErrorMessage(playerid, "Você não pode usar este comando agora.");

    new id;

    if ((id = Entrance_Nearest(playerid)) != -1)
    {
        if (IsPlayerInAnyVehicle(playerid))
            return SendErrorMessage(playerid, "Você precisa sair do veículo primeiro.");

        if (EntranceData[id][e_ENTRANCE_INSIDE_POS][0] == 0.0 && EntranceData[id][e_ENTRANCE_INSIDE_POS][1] == 0.0 && EntranceData[id][e_ENTRANCE_INSIDE_POS][2] == 0.0)
        {
            SendErrorMessage(playerid, "Essa entrada não possui interior definido.");
            return true;
        }

        // Set position
        GameTextForPlayer(playerid, va_return("~w~~h~%s", EntranceData[id][e_ENTRANCE_NAME]), 3000, 1);
        Character_SetPos(playerid, EntranceData[id][e_ENTRANCE_INSIDE_POS][0], EntranceData[id][e_ENTRANCE_INSIDE_POS][1], EntranceData[id][e_ENTRANCE_INSIDE_POS][2], EntranceData[id][e_ENTRANCE_INSIDE_POS][3], EntranceData[id][e_ENTRANCE_INSIDE_WORLD], EntranceData[id][e_ENTRANCE_INSIDE_INTERIOR]);
    }
    else if ((id = Business_Nearest(playerid)) != -1)
    {
        if (IsPlayerInAnyVehicle(playerid))
            return SendErrorMessage(playerid, "Você precisa sair do veículo primeiro.");

        if (BusinessData[id][e_BUSINESS_INSIDE_POS][0] == 0.0 && BusinessData[id][e_BUSINESS_INSIDE_POS][1] == 0.0 && BusinessData[id][e_BUSINESS_INSIDE_POS][2] == 0.0)
            return SendErrorMessage(playerid, "Esta empresa não possui interior.");

        if (BusinessData[id][e_BUSINESS_OWNER] == 0 && BusinessData[id][e_BUSINESS_ENTRANCE_FEE] > 0)
        {
            BusinessData[id][e_BUSINESS_ENTRANCE_FEE] = 0;
            Business_Save(id);
        }

        if (BusinessData[id][e_BUSINESS_LOCKED])
            return SendErrorMessage(playerid, "Esta empresa está fechada pelo dono.");

        if (!Business_IsOwner(playerid, id) && !Faction_IsInDuty(playerid) && BusinessData[id][e_BUSINESS_ENTRANCE_FEE] > 0 && Character_GetMoney(playerid) < BusinessData[id][e_BUSINESS_ENTRANCE_FEE])
            return SendErrorMessage(playerid, "Você não tem %s para entrar na empresa.", FormatMoney(BusinessData[id][e_BUSINESS_ENTRANCE_FEE]));

        if (!Business_IsOwner(playerid, id) && !Faction_IsInDuty(playerid) && BusinessData[id][e_BUSINESS_ENTRANCE_FEE] > 0)
        {
            BusinessData[id][e_BUSINESS_VAULT] += BusinessData[id][e_BUSINESS_ENTRANCE_FEE];
            Character_GiveMoney(playerid, -BusinessData[id][e_BUSINESS_ENTRANCE_FEE]);  
            SendClientMessageEx(playerid, COLOR_GREEN, "Você pagou %s pela entrada.", FormatMoney(BusinessData[id][e_BUSINESS_ENTRANCE_FEE]));   
        }

        Character_SetPos(
            playerid, 
            BusinessData[id][e_BUSINESS_INSIDE_POS][0], 
            BusinessData[id][e_BUSINESS_INSIDE_POS][1], 
            BusinessData[id][e_BUSINESS_INSIDE_POS][2], 
            BusinessData[id][e_BUSINESS_INSIDE_POS][3],
            BusinessData[id][e_BUSINESS_INSIDE_WORLD],
            BusinessData[id][e_BUSINESS_INSIDE_INTERIOR]
        );

        // Business Type
        switch (BusinessData[id][e_BUSINESS_TYPE])
        {
            case BUSINESS_TYPE_247, BUSINESS_TYPE_GUN_STORE, BUSINESS_TYPE_CLOTHES_STORE, BUSINESS_TYPE_VEHICLE_DEALER, BUSINESS_TYPE_GAS_STATION, BUSINESS_TYPE_FURNITURE, BUSINESS_TYPE_TOOL_SHOP, BUSINESS_TYPE_MECHANIC:
            {
                SendClientMessageEx(playerid, -1, "Esta empresa é do tipo {FF6347}%s{FFFFFF}.", g_arrBusinessType[BusinessData[id][e_BUSINESS_TYPE]]);
                SendClientMessage(playerid, -1, "Você pode comprar nesta loja. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_WELL_STACKED:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Pizzaria{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer nesta pizzaria. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_BAR:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Bar{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer neste bar. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_CLUB:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Boate{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer nesta boate. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_BURGUER_SHOT:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Hamburgueria{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer neste fast food. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_CLUCKIN_BELL:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Cluckin Bell{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer neste fast food. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_COFFEE_N_DONUTS:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Cafeteria{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer nesta loja de cafés e rosquinhas. Utilize {FF6347}/comprar{FFFFFF}.");
            }

            case BUSINESS_TYPE_RESTAURANT:
            {
                SendClientMessage(playerid, -1, "Esta empresa é do tipo {FF6347}Restaurante{FFFFFF}.");
                SendClientMessage(playerid, -1, "Você pode comer neste restaurante. Utilize {FF6347}/comprar{FFFFFF}.");    
            }
        }

        // Mensagem
        if (BusinessData[id][e_BUSINESS_MESSAGE][0] != '\0')
            SendClientMessage(playerid, -1, BusinessData[id][e_BUSINESS_MESSAGE]);

        // Rádio
        if (BusinessData[id][e_BUSINESS_RADIO][0] != '\0')
            PlayAudioStreamForPlayer(playerid, BusinessData[id][e_BUSINESS_RADIO]);
    }
    else if ((id = House_Nearest(playerid)) != -1)
    {
        if (IsPlayerInAnyVehicle(playerid))
            return SendErrorMessage(playerid, "Você precisa sair do veículo primeiro.");

        if (HouseData[id][e_HOUSE_LOCKED])
            return SendErrorMessage(playerid, "Você não pode entrar em uma casa trancada.");

        if (HouseData[id][e_HOUSE_INSIDE_POS][0] == 0.0 && HouseData[id][e_HOUSE_INSIDE_POS][1] == 0.0 && HouseData[id][e_HOUSE_INSIDE_POS][2] == 0.0)
            return SendErrorMessage(playerid, "Esta casa não possui interior definido.");

        Character_SetPos(
            playerid, 
            HouseData[id][e_HOUSE_INSIDE_POS][0], 
            HouseData[id][e_HOUSE_INSIDE_POS][1], 
            HouseData[id][e_HOUSE_INSIDE_POS][2], 
            HouseData[id][e_HOUSE_INSIDE_POS][3],
            HouseData[id][e_HOUSE_INSIDE_WORLD], 
            HouseData[id][e_HOUSE_INSIDE_INTERIOR]
        );

        if (HouseData[id][e_HOUSE_RADIO][0] != '\0')
            PlayAudioStreamForPlayer(playerid, HouseData[id][e_HOUSE_RADIO]);
    }
    else
    {
        SendErrorMessage(playerid, "Você não está próximo de uma entrada.");
    }
    return true;
}

CMD:sair(playerid)
{
    if (!Damage_IsAlive(playerid))
        return SendErrorMessage(playerid, "Você não pode usar esse comando estando ferido ou morto.");

    if (!IsPlayerSpawned(playerid))
        return SendErrorMessage(playerid, "Você não pode usar este comando agora.");

    new id;

    if ((id = Entrance_Inside(playerid)) != -1)
    {
        if (!IsPlayerInRangeOfPoint(playerid, 2.5, EntranceData[id][e_ENTRANCE_INSIDE_POS][0], EntranceData[id][e_ENTRANCE_INSIDE_POS][1], EntranceData[id][e_ENTRANCE_INSIDE_POS][2]))
        {
            SendErrorMessage(playerid, "Você não está próximo da saída.");
            return true;
        }

        // Set position
        Character_SetPos(playerid, EntranceData[id][e_ENTRANCE_POS][0], EntranceData[id][e_ENTRANCE_POS][1], EntranceData[id][e_ENTRANCE_POS][2], -1.0, EntranceData[id][e_ENTRANCE_WORLD], EntranceData[id][e_ENTRANCE_INTERIOR]);
    }
    else if ((id = Business_Inside(playerid)) != -1)
    {
        if (!IsPlayerInRangeOfPoint(playerid, 2.5, BusinessData[id][e_BUSINESS_INSIDE_POS][0], BusinessData[id][e_BUSINESS_INSIDE_POS][1], BusinessData[id][e_BUSINESS_INSIDE_POS][2]))
        {
            SendErrorMessage(playerid, "Você não está próximo da saída.");
            return true;
        }

        if (BusinessData[id][e_BUSINESS_LOCKED])
            return SendErrorMessage(playerid, "A porta está trancada.");

        // Set position
        StopAudioStreamForPlayer(playerid);
        Character_SetPos(playerid, BusinessData[id][e_BUSINESS_POS][0], BusinessData[id][e_BUSINESS_POS][1], BusinessData[id][e_BUSINESS_POS][2], -1.0, BusinessData[id][e_BUSINESS_WORLD], BusinessData[id][e_BUSINESS_INTERIOR]);
    }
    else if ((id = House_Inside(playerid)) != -1)
    {
        if (!IsPlayerInRangeOfPoint(playerid, 2.5, HouseData[id][e_HOUSE_INSIDE_POS][0], HouseData[id][e_HOUSE_INSIDE_POS][1], HouseData[id][e_HOUSE_INSIDE_POS][2]))
        {
            SendErrorMessage(playerid, "Você não está próximo da saída.");
            return true;
        }

        if (HouseData[id][e_HOUSE_LOCKED])
            return SendErrorMessage(playerid, "A porta está trancada.");

        // Set position
        StopAudioStreamForPlayer(playerid);
        Character_SetPos(playerid, HouseData[id][e_HOUSE_POS][0], HouseData[id][e_HOUSE_POS][1], HouseData[id][e_HOUSE_POS][2], -1.0, HouseData[id][e_HOUSE_WORLD], HouseData[id][e_HOUSE_INTERIOR]);
    }
    else
    {
        SendErrorMessage(playerid, "Você não está próximo de uma saída.");
    }
    return true;
}

CMD:comprar(playerid)
{
    static id;
    id = -1;

    if ((id = Business_Nearest(playerid)) != -1)
    {
        if (Business_GetCount(CharacterData[playerid][e_CHARACTER_ID]) >= MAX_OWNABLE_BUSINESS)
            return SendErrorMessage(playerid, "Você só pode ter %i empresas ao mesmo tempo.", MAX_OWNABLE_BUSINESS);

        if (BusinessData[id][e_BUSINESS_OWNER] != 0)
            return SendErrorMessage(playerid, "Esta empresa já possui um dono.");

        if (BusinessData[id][e_BUSINESS_PRICE] > Character_GetMoney(playerid))
            return SendErrorMessage(playerid, "Você não possui fundos suficientes para realizar a compra.");

        BusinessData[id][e_BUSINESS_OWNER] = CharacterData[playerid][e_CHARACTER_ID];
        BusinessData[id][e_BUSINESS_VAULT] = 0;
        BusinessData[id][e_BUSINESS_PRODUCTS] = 0;

        Business_Refresh(id);
        Business_Save(id);

        Character_GiveMoney(playerid, -BusinessData[id][e_BUSINESS_PRICE]);
        SendClientMessageEx(playerid, COLOR_GREEN, "Você comprou a empresa \"%s\" por %s!", BusinessData[id][e_BUSINESS_NAME], FormatMoney(BusinessData[id][e_BUSINESS_PRICE]));

        Log_Create("Propriedades", "%s (%i) comprou a empresa %s (%i) por %s", Character_GetName(playerid), CharacterData[playerid][e_CHARACTER_ID], BusinessData[id][e_BUSINESS_NAME], BusinessData[id][e_BUSINESS_ID], FormatMoney(BusinessData[id][e_BUSINESS_PRICE]));
        GameTextForPlayer(playerid, "Empresa Comprada", 2400, 4);
    }
    else if ((id = House_Nearest(playerid)) != -1)
    {
        if (House_GetCount(CharacterData[playerid][e_CHARACTER_ID]) >= MAX_OWNABLE_HOUSES)
            return SendErrorMessage(playerid, "Você só pode ter %i casas ao mesmo tempo.", MAX_OWNABLE_HOUSES);

        if (HouseData[id][e_HOUSE_PRICE] > Character_GetMoney(playerid))
            return SendErrorMessage(playerid, "Você não possui fundos suficientes para realizar a compra.");

        HouseData[id][e_HOUSE_OWNER] = CharacterData[playerid][e_CHARACTER_ID];
        House_Refresh(id);
        House_Save(id);

        Character_GiveMoney(playerid, -HouseData[id][e_HOUSE_PRICE]);
        SendClientMessageEx(playerid, COLOR_GREEN, "Você comprou a casa \"%s\" por %s!", House_GetAddress(id), FormatMoney(HouseData[id][e_HOUSE_PRICE]));

        Log_Create("Propriedades", "%s (%i) comprou a casa %s (%i) por %s", Character_GetName(playerid), CharacterData[playerid][e_CHARACTER_ID], House_GetAddress(id), HouseData[id][e_HOUSE_ID], FormatMoney(HouseData[id][e_HOUSE_PRICE]));
        GameTextForPlayer(playerid, "Casa Comprada", 2400, 4);
    }
    else if ((id = Business_Inside(playerid)) != -1)
    {
        Business_PurchaseMenu(playerid, id);
    }

    return true;
}

CMD:abandonar(playerid, params[])
{
    static
        id = -1;

    if (!IsPlayerInAnyVehicle(playerid) && (id = Business_Nearest(playerid)) != -1 && Business_IsOwner(playerid, id))
    {
        if (isnull(params) || (!isnull(params) && strcmp(params, "confirmar", true) != 0))
        {
            SendUsageMessage(playerid, "/abandonar [confirmar]");
            SendClientMessage(playerid, COLOR_LIGHTRED, "[AVISO]: Você está prestes a abandonar sua empresa, lembre-se que você não será reembolsado.");
        }
        else if (!strcmp(params, "confirmar", true))
        {
            BusinessData[id][e_BUSINESS_OWNER] = 0;
            Business_Refresh(id);
            Business_Save(id);

            SendClientMessageEx(playerid, COLOR_GREEN, "Você abandonou a empresa: %s.", BusinessData[id][e_BUSINESS_NAME]);
        }
    }
    else if (!IsPlayerInAnyVehicle(playerid) && (id = House_Nearest(playerid)) != -1 && House_IsOwner(playerid, id))
    {
        if (isnull(params) || (!isnull(params) && strcmp(params, "confirmar", true) != 0))
        {
            SendUsageMessage(playerid, "/abandonar [confirmar]");
            SendClientMessage(playerid, COLOR_LIGHTRED, "[AVISO]: Você está prestes a abandonar sua casa, lembre-se que você não será reembolsado.");
        }
        else if (!strcmp(params, "confirmar", true))
        {
            HouseData[id][e_HOUSE_OWNER] = 0;
            House_Refresh(id);
            House_Save(id);

            SendClientMessageEx(playerid, COLOR_GREEN, "Você abandonou a casa: %s.", House_GetAddress(id));
        }
    }
    else SendErrorMessage(playerid, "Você não está próximo de nada que você possa abandonar.");
    return 1;
}

CMD:trancar(playerid, params[])
{
    static
        id = -1;

    if (IsPlayerInAnyVehicle(playerid))
        return SendErrorMessage(playerid, "Você não pode fazer isso no momento.");

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1)
    {
        if (Business_IsOwner(playerid, id))
        {
            BusinessData[id][e_BUSINESS_LOCKED] = !BusinessData[id][e_BUSINESS_LOCKED];
            Business_Refresh(id);
            Business_Save(id);

            GameTextForPlayer(playerid, BusinessData[id][e_BUSINESS_LOCKED] ? ("~w~EMPRESA ~r~TRANCADA") : ("~w~EMPRESA ~g~DESTRANCADA"), 2400, 6);
            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
        }
        else
        {
            return SendErrorMessage(playerid, "Você não é dono ou não possui as chaves desta empresa.");
        }
    }

    else if ((id = (House_Inside(playerid) == -1) ? (House_Nearest(playerid)) : (House_Inside(playerid))) != -1)
    {
        if (HouseData[id][e_HOUSE_OWNER] == 0 || House_IsOwner(playerid, id))
        {
            HouseData[id][e_HOUSE_LOCKED] = !HouseData[id][e_HOUSE_LOCKED];
            House_Refresh(id);
            House_Save(id);

            GameTextForPlayer(playerid, HouseData[id][e_HOUSE_LOCKED] ? ("~w~CASA ~r~TRANCADA") : ("~w~CASA ~g~DESTRANCADA"), 2400, 6);
            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
        }
        else
        {
            return SendErrorMessage(playerid, "Você não tem as chaves desta residência.");
        }
    } 
    
    return 1;
}

CMD:mudarsaida(playerid, params[])
{
    static id;

    if((id = Business_Inside(playerid)) != -1)
    {
        if(!Business_IsOwner(playerid, id))
            return SendErrorMessage(playerid, "Você não é o proprietário desta empresa.");

        GetPlayerPos(playerid, BusinessData[id][e_BUSINESS_INSIDE_POS][0], BusinessData[id][e_BUSINESS_INSIDE_POS][1], BusinessData[id][e_BUSINESS_INSIDE_POS][2]);
        GetPlayerFacingAngle(playerid, BusinessData[id][e_BUSINESS_INSIDE_POS][3]);
        BusinessData[id][e_BUSINESS_INSIDE_INTERIOR] = GetPlayerInterior(playerid);

        SendClientMessage(playerid, COLOR_GREEN, "Você editou a saída do interior da empresa com sucesso.");
    }
    else if((id = House_Inside(playerid)) != -1)
    {
        if(!House_IsOwner(playerid, id))
            return SendErrorMessage(playerid, "Você não é o proprietário desta casa.");

        GetPlayerPos(playerid, HouseData[id][e_HOUSE_INSIDE_POS][0], HouseData[id][e_HOUSE_INSIDE_POS][1], HouseData[id][e_HOUSE_INSIDE_POS][2]);
        GetPlayerFacingAngle(playerid, HouseData[id][e_HOUSE_INSIDE_POS][3]);
        HouseData[id][e_HOUSE_INSIDE_INTERIOR] = GetPlayerInterior(playerid);

        SendClientMessage(playerid, COLOR_GREEN, "Você editou a saída do interior da casa com sucesso.");
    }
    else
        SendErrorMessage(playerid, "Você não está dentro de uma casa/empresa.");

    return 1;
}

CMD:ajuda(playerid, params[])
{
    if (IsNull(params))
    {
        SendClientMessage(playerid, COLOR_GREEN, "____________________________________________________");
        SendClientMessage(playerid, COLOR_FADE1, "[CONTA] /alterarsenha /ultimologin /personagens /stats /levelup /upgrade /propriedades /mudarspawn");
        SendClientMessage(playerid, COLOR_FADE2, "[GERAL] /admins /testers /sos /pm /acessorios /limparmeuchat /aceitar /guia /vender /beber /banco /cozinhar /update  /creditos");
        SendClientMessage(playerid, COLOR_FADE1, "[GERAL] /id /dropar /usargalao /abrir /animlist /removercp /pararanim /licencamotorista /licencaarma /comprar /armac");
        SendClientMessage(playerid, COLOR_FADE2, "[GERAL] /cumprimentar /revistar /procurar /hud /trava /xmradio /premium /alugarquarto /desalugarquarto");
        SendClientMessage(playerid, COLOR_FADE1, "[ITENS] /dropar (/inv)entario /pegar /colocar /cheirar /gps /boombox /radio /entregararma /abastecergalao /rotulo");
        SendClientMessage(playerid, COLOR_FADE2, "[CHAT] /gritar (/g) /ooc /me /do /ame /ado /sussurrar (/s) /b /radio");
        SendClientMessage(playerid, COLOR_FADE1, "[DINHEIRO] /pagar /doar /banco");
        SendClientMessage(playerid, COLOR_FADE2, "[SCREEN] /telapreta /telacinza /telaverde /telalaranja");
        SendClientMessage(playerid, COLOR_GREEN, "____________________________________________________");
        SendClientMessage(playerid, COLOR_FADE1, "Se tiver dúvida na utilização de algum comando envie um /sos e fale com um admin.");
    }

    return 1;
}

CMD:creditos(playerid, params[])
{
    SendClientMessage(playerid, COLOR_BEGE, "____________________________________________________");
    SendClientMessage(playerid, COLOR_BEGE, "Jobim pela criação do gamemode ao gênero roleplay.");
    SendClientMessage(playerid, COLOR_BEGE, "Carlos Victor por confiar e transferir o legado para a atual administração.");
    SendClientMessage(playerid, COLOR_BEGE, "Todos os players do Brasil Project City pelo apoio.");
    SendClientMessage(playerid, COLOR_BEGE, "____________________________________________________");
    return 1;
}

CMD:update(playerid, params[])
{
    SendClientMessage(playerid, COLOR_BEGE, "____________________________________________________");
    SendClientMessage(playerid, COLOR_BEGE, "Atualização v"SERVER_VERSION"");
    SendClientMessage(playerid, COLOR_BEGE, "- Confira no discord o que foi atualizado.");
    SendClientMessage(playerid, COLOR_BEGE, "____________________________________________________");
    return 1;
}

CMD:stats(playerid, params[])
{
    new target;
    if (!Admin_CheckPermission(playerid, 1, .sendMessage = false) || sscanf(params, "u", target))
    {
        DisplayStats(playerid, playerid);
        return true;
    }

    if (!CheckTargetId(playerid, target))
        return true;
    
    DisplayStats(target, playerid);
    return true;
}

alias:props("propriedades")
CMD:props(playerid)
{   
    SendClientMessage(playerid, COLOR_GREEN, "Suas propriedades:");

    new bool:found = false;

    // Casas
    foreach (new i : Houses)
    {
        if (!HouseData[i][e_HOUSE_EXISTS] || HouseData[i][e_HOUSE_OWNER] != CharacterData[playerid][e_CHARACTER_ID])
            continue;

        if (!found)
            found = true;

        SendClientMessageEx(playerid, COLOR_GREY, "[Casa] %s (ID: %i)", House_GetAddress(i), i);
    }

    // Empresas
    foreach (new i : Business)
    {
        if (!BusinessData[i][e_BUSINESS_EXISTS] || BusinessData[i][e_BUSINESS_OWNER] != CharacterData[playerid][e_CHARACTER_ID])
            continue;

        if (!found)
            found = true;

        SendClientMessageEx(playerid, COLOR_GREY, "[Empresa] %s (ID: %i) | Localização: %s", BusinessData[i][e_BUSINESS_NAME], i, ReturnAreaName(BusinessData[i][e_BUSINESS_POS][0], BusinessData[i][e_BUSINESS_POS][1]));
    }

    if (!found)
        SendErrorMessage(playerid, "Você não possui nenhuma propriedade.");

    return true;
}

alias:limparmeuchat("lmc", "cc")
CMD:limparmeuchat(playerid)
{
    ClearPlayerMessages(playerid);
    return true;
}