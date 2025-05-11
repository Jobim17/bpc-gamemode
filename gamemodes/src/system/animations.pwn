/*	
    Christyan David
    August 10th, 2016
    Advanced Roleplay | Animações:
*/

#include <YSI_Coding\y_hooks>

static s_pLanguage[MAX_PLAYERS] = {1, ...};

static bool:s_pLoopingAnim[MAX_PLAYERS char] = {false, ...};
static bool:s_pFirstAnimation[MAX_PLAYERS char] = {false, ...};

/*
      .oooooo.             oooo  oooo   .o8                           oooo
     d8P'  `Y8b            `888  `888  "888                           `888
    888           .oooo.    888   888   888oooo.   .oooo.    .ooooo.   888  oooo   .oooo.o
    888          `P  )88b   888   888   d88' `88b `P  )88b  d88' `"Y8  888 .8P'   d88(  "8
    888           .oP"888   888   888   888   888  .oP"888  888        888888.    `"Y88b.
    `88b    ooo  d8(  888   888   888   888   888 d8(  888  888   .o8  888 `88b.  o.  )88b
     `Y8bood8P'  `Y888""8o o888o o888o  `Y8bod8P' `Y888""8o `Y8bod8P' o888o o888o 8""888P'

*/

hook OnPlayerConnect(playerid)
{
    s_pLoopingAnim{playerid} = false;
    s_pFirstAnimation{playerid} = false;
    return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_SPRINT && IsPlayerSpawned(playerid) && s_pLoopingAnim{playerid} && AnimationCheck(playerid))
    {
        ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
        s_pLoopingAnim{playerid} = false;
    }

    return true;
}

/*
    oooooooooo.    o8o            oooo
    `888'   `Y8b   `"'            `888
     888      888 oooo   .oooo.    888   .ooooo.   .oooooooo  .oooo.o
     888      888 `888  `P  )88b   888  d88' `88b 888' `88b  d88(  "8
     888      888  888   .oP"888   888  888   888 888   888  `"Y88b.
     888     d88'  888  d8(  888   888  888   888 `88bod8P'  o.  )88b
    o888bood8P'   o888o `Y888""8o o888o `Y8bod8P' `8oooooo.  8""888P'
                                                  d"     YD
                                                  "Y88888P'
*/
Dialog:AnimListRequest(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
    	{
            case 0: {Control_Options(playerid, listitem); s_pLanguage[playerid]=1;} // Português
        	case 1: {Control_Options(playerid, listitem); s_pLanguage[playerid]=2;} // Inglês
        	case 2: {Control_Options(playerid, listitem); s_pLanguage[playerid]=3;} // Antigas
    	}
    }
    return 1;
}

Dialog:AnimListOptions(playerid, response, listitem, inputtext[])
{
    if(response)
	{
    	if(s_pLanguage[playerid]==1) // Lista de animações em Português
        {
        	switch(listitem)
            {
            	case 0:
                {
                	SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /concordar /mirar /raiva /camera2 /camera3 /cliquecamera /checar");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /salvar /rastejar /chorar /acordo /lavar /empurrar /bandeira");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /consertarcarro /consertarcarrofim /forte /levantarcostas");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /levantarfrente /limpar /dinheiro /cairfrente /desviar");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /levantarcostas /levantarfrente /limpar /dinheiro /chutarporta");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /rir /apontar /ombro /abriresquerda /abrirdireita /animcofre");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /dinheiro2 /cotovelo /largar /rejeitar /atravessarrua /cocarsaco");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /checarombro /graffiti /grafitti2 /jogar /animgritar /lavarmao /nao ");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /animbeber /mortal /parar");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                 	return 1;
                }
                case 1:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /chamar /palmatesta /fodase /fodase2 /provocar");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Confronto]: /tumulto /tumulto2 /tumulto3 /tumulto4 /gritar2 /gritar3 /gritar4");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /provocar2 /provocar3");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
             	case 2:
              	{
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Comer/Beber]: /bar /barpedir /comer /olharbar");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Comer/Beber]: /barservir /barservir2 /animbeber");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 3:
           	    {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Drogas/Ferimentos]: /droga /droga2 /droga3 /droga4 /mortal");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Drogas/Ferimentos]: /cairfrente /baleado /ferido");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                 	return 1;
                }
                case 4:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /taco /taco2 /taco3 /morrendo /exausto /lutar /panico");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Ativo]: /panico2 /parado /olhar /olharvolta /rap1  /rap2");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /rap3 /alongar /alongar2 /cansado");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 5:
             	{
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /reclamar /cruzarbracos /cruzarbracos2 /cruzarbracos3 /cruzarbracos4");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /cruzarbracos5 /trafico /trafico2 /pesames /trafico3");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /trafico4 /deitar /escorar /escorar2 /velho /padre");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /armado /virar /escritoriotedio /escritorio");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /sentar /sentar2 /sentar3 /sentar4");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                 	return 1;
                }
                case 6:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Armas]: /mirarrapido /atirar /atirar2 /recarregar2 /atirar3");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Armas]: /regarregar3 /recarregar /escopeta /srecarregar");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 7:
           	    {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /bloquear /defender /defender2 /driblar /driblar2");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Esportes]: /driblar3 /enterrar /enterrar2 /arremecofake");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /arremecar /pegarbola /roubarbola");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 8:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Dança]: /dancasensual [1-14] /dancar [1-11]");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 9:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /apanhar /animtapa /boxe1 /boxe2 /cortargarganta");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /desviar /cair /cair2 /mortal /chutevoador ");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /golpechao /socado /kungfu /kungfu2 /kungfu3");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /kungfu4 /kungfu5 /treinarboxe /soco /tumulto2");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /tumulto3 /tumulto4 /esfaquear /espada");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 10:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Gangues]: /gestos [1-10] /gestoscriminosos [1-10]"); // Ainda não foi feito (/gsign)
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 11:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /animatm /supino /biceps /biceps2 /relaxar /boquete");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Outros]: /beijomulher1 /beijomulher2 /beijomulher3 /beijohomem1");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /beijohomem2 /beijohomem3 /mijar");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
           		}
       		}
        }
        else if(s_pLanguage[playerid]==2) // Lista de animações em Inglês
       	{
            switch(listitem)
            {
                case 0:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /agree /aim /angry /camera2 /camera3 /camshot1 /checkout");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /cpr /crawl /cry /deal /dishes /downpush /dropflag");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /fixcar /fixcarout /flex /frontfall /getupb /getupf /handoff");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /handoff2 /kickdoor /laugh /lookout2 /lowbump /openleft /openright");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /safeopen /payshop /push /putdown /reject /roadcross /scratchballs");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /shouldercheck /throw /upshout /washhands /no");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 1:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /comeon /facepalm /fuckyou /fuckyou2");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Confronto]: /provoke /riot2 /riot3  /shout2");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /shoutat /shouts /taunt /what");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 2:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Comer/Beber]: /baridle /barorder /eatfood");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Comer/Beber]: /forwardlook /servebottle /serveglass");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 3:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Drogas/Ferimentos]: /crack /crack2 /crack3 /crack4");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Drogas/Ferimentos]: /frontfall /getshot /injured");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 4:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /bat /bat2 /batstance /dying");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Ativo]: /exhausted /fightstance /forwardpanic /forwardwave");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /lookoutp /lookout3 /rap1 /rap2");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Ativo]: /rap3 /stretch /stretch2 /tired");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 5:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /comecross /crossarms /crossarms2 /crossarms3");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /crossarms4 /crosswin /dealerstance /dealerstance2");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /dealerstance3 /dealerstance4 /fallover /lean");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /lean2 /mourn /old /priest");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /rifflestance /uturn /deskbored /desksit");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /seat /sit /sit2 /sit3 /sit4");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 6:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Armas]: /aimshoot /aimshoot2 /creload /crouchshoot");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Armas]: /crouchreload /reload /shottyreload");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 7:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /blockshot /defense /defenser /dribble");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Esportes]: /dribble2 /dribble3 /dunk /dunk2");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /fakeshot /jumpshot /pickupball");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 8:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Dança]: /strip [1-14] /dance [1-11]");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
                case 9:
             	{
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /backhit /bitchslap /boxe1 /boxe2");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /choke /cutthroat /dodge /fallhit");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /fallkick /flykick /kickhimB /kungfu1");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /kungfu2 /kungfu3 /kungfublock /kungfustomp");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /punch /riotpunch /riotpunch2 /shadowbox");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /stab2 /sword /sliced");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 10:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Gangues]: /gsign [1-10]");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                	return 1;
                }
                case 11:
                {
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /animatm /benchpress /weights /weights2 /relaxed");
                    SendClientMessage(playerid, 0xC1D9D9FF, "[Outros]: /blowjob /kissgirl1 /kissgirl2 /kissgirl3 /kissman1");
                    SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /kissman2 /kissman3 /pee");
                    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                    return 1;
                }
			}
   		}
	}
	return 1;
}

/*
      .oooooo.                                                           .o8
     d8P'  `Y8b                                                         "888
    888           .ooooo.  ooo. .oo.  .oo.    .oooo.   ooo. .oo.    .oooo888   .ooooo.   .oooo.o
    888          d88' `88b `888P"Y88bP"Y88b  `P  )88b  `888P"Y88b  d88' `888  d88' `88b d88(  "8
    888          888   888  888   888   888   .oP"888   888   888  888   888  888   888 `"Y88b.
    `88b    ooo  888   888  888   888   888  d8(  888   888   888  888   888  888   888 o.  )88b
     `Y8bood8P'  `Y8bod8P' o888o o888o o888o `Y888""8o o888o o888o `Y8bod88P" `Y8bod8P' 8""888P'

*/

CMD:anim(playerid, params[]) return PC_EmulateCommand(playerid, "/animacoes");
CMD:animacoes(playerid, params[])
{
    // List_Animes");
    new
        stringC[3000];

    format(stringC, sizeof(stringC), "Lista de animações em Português\nLista de animações em Inglês\nAnimações antigas");
    Dialog_Show(playerid, AnimListRequest, DIALOG_STYLE_LIST, "Lista de animações", stringC, "Selecionar", "Cancelar");
    SendClientMessage(playerid, -1, "* Para acesso rapido use /animlist [1-12]");
    SendClientMessage(playerid, -1, "* Caso queira mudar a linguagem da lista de animações use: /anim ou /animes");
    return 1;
}

CMD:alist(playerid, params[])	return PC_EmulateCommand(playerid, "/animlist");
CMD:animlist(playerid, params[])
{
    if(s_pLanguage[playerid] == 0)
		return PC_EmulateCommand(playerid, "/animacoes");

    if(s_pLanguage[playerid] == 1) // Lista de animações em Português
    {
        new result;

        if(sscanf(params, "d", result))
			return SendUsageMessage(playerid, "/animlist [1-12]");

        switch(result)
        {
            case 1:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /concordar /mirar /raiva /camera2 /camera3 /cliquecamera /checar");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /salvar /rastejar /chorar /acordo /lavar /empurrar /bandeira");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /consertarcarro /consertarcarrofim /forte /levantarcostas");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /levantarfrente /limpar /dinheiro /cairfrente /desviar");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /levantarcostas /levantarfrente /limpar /dinheiro /chutarporta");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /rir /apontar /ombro /abriresquerda /abrirdireita /animcofre");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /dinheiro2 /cotovelo /largar /rejeitar /atravessarrua /cocarsaco");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /checarombro /graffiti /grafitti2 /jogar /animgritar /lavarmao /nao ");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /animbeber /mortal /parar");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 2:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /chamar /palmatesta /fodase /fodase2 /provocar");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Confronto]: /tumulto /tumulto2 /tumulto3 /tumulto4 /gritar2 /gritar3 /gritar4");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /provocar2 /provocar3");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 3:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Comer/Beber]: /bar /barpedir /comer /olharbar");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Comer/Beber]: /barservir /barservir2 /animbeber");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 4:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Drogas/Ferimentos]: /droga /droga2 /droga3 /droga4 /mortal");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Drogas/Ferimentos]: /cairfrente /baleado /ferido");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 5:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /taco /taco2 /taco3 /morrendo /exausto /lutar /panico");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Ativo]: /panico2 /parado /olhar /olharvolta /rap1  /rap2");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /rap3 /alongar /alongar2 /cansado");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 6:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /reclamar /cruzarbracos /cruzarbracos2 /cruzarbracos3 /cruzarbracos4");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /cruzarbracos5 /trafico /trafico2 /pesames /trafico3");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /trafico4 /deitar /escorar /escorar2 /velho /padre");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /armado /virar /escritoriotedio /escritorio");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /sentar /sentar2 /sentar3");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 7:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Armas]: /mirarrapido /atirar /atirar2 /recarregar2 /atirar3");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Armas]: /regarregar3 /recarregar /escopeta /srecarregar");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 8:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /bloquear /defender /defender2 /driblar /driblar2");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Esportes]: /driblar3 /enterrar /enterrar2 /arremecofake");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /arremecar /pegarbola /roubarbola");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 9:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Dança]: /dancasensual [1-14] /dancar [1-11]");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 10:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /apanhar /animtapa /boxe1 /boxe2 /cortargarganta");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /desviar /cair /cair2 /mortal /chutevoador ");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /golpechao /socado /kungfu /kungfu2 /kungfu3");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /kungfu4 /kungfu5 /treinarboxe /soco /tumulto2");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /tumulto3 /tumulto4 /esfaquear /espada");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 11:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Gangues]: /gestos [1-10] /gestoscriminosos [1-10]"); // Ainda não foi feito (/gsign)
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 12:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /animatm /supino /biceps /biceps2 /relaxar /boquete");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Outros]: /beijomulher1 /beijomulher2 /beijomulher3 /beijohomem1");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /beijohomem2 /beijohomem3 /mijar");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
        }
    }
    else if(s_pLanguage[playerid] == 2) // Lista de animações em Inglês
    {
        new result;

        if(sscanf(params, "d", result))
			return SendUsageMessage(playerid, "/animlist [1-12]");

        switch(result)
        {
            case 0:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /agree /aim /angry /camera2 /camera3 /camshot1 /checkout");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /cpr /crawl /cry /deal /dishes /downpush /dropflag");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /fixcar /fixcarout /flex /frontfall /getupb /getupf /handoff");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /handoff2 /kickdoor /laugh /lookout2 /lowbump /openleft /openright");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Ações]: /safeopen /payshop /push /putdown /reject /roadcross /scratchballs");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Ações]: /shouldercheck /throw /upshout /washhands /no");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 1:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /comeon /facepalm /fuckyou /fuckyou2");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Confronto]: /provoke /riot2 /riot3  /shout2");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Confronto]: /shoutat /shouts /taunt /what");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				return 1;
            }
            case 2:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				SendClientMessage(playerid, 0xE2FFFFFF, "[Comer/Beber]: /baridle /barorder /eatfood");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Comer/Beber]: /forwardlook /servebottle /serveglass");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				return 1;
            }
            case 3:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				SendClientMessage(playerid, 0xE2FFFFFF, "[Drogas/Ferimentos]: /crack /crack2 /crack3 /crack4");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Drogas/Ferimentos]: /frontfall /getshot /injured");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				return 1;
            }
            case 4:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /bat /bat2 /batstance /dying");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Ativo]: /exhausted /fightstance /forwardpanic /forwardwave");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Ativo]: /lookoutp /lookout3 /rap1 /rap2");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Ativo]: /rap3 /stretch /stretch2 /tired");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				return 1;
            }
            case 5:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
				SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /comecross /crossarms /crossarms2 /crossarms3");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /crossarms4 /crosswin /dealerstance /dealerstance2");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /dealerstance3 /dealerstance4 /fallover /lean");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /lean2 /mourn /old /priest");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Pos. Passivo]: /rifflestance /uturn /deskbored /desksit");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Pos. Passivo]: /seat /sit /sit2");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 6:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Armas]: /aimshoot /aimshoot2 /creload /crouchshoot");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Armas]: /crouchreload /reload /shottyreload");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 7:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /blockshot /defense /defenser /dribble");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Esportes]: /dribble2 /dribble3 /dunk /dunk2");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Esportes]: /fakeshot /jumpshot /pickupball");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 8:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Dança]: /strip [1-14] /dance [1-11]");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 9:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /backhit /bitchslap /boxe1 /boxe2");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /choke /cutthroat /dodge /fallhit");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /fallkick /flykick /kickhimB /kungfu1");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /kungfu2 /kungfu3 /kungfublock /kungfustomp");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Combate]: /punch /riotpunch /riotpunch2 /shadowbox");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Combate]: /stab2 /sword /sliced");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 10:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Gangues]: /gsign [1-10]");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
            case 11:
            {
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /animatm /benchpress /weights /weights2 /relaxed");
                SendClientMessage(playerid, 0xC1D9D9FF, "[Outros]: /blowjob /kissgirl1 /kissgirl2 /kissgirl3 /kissman1");
                SendClientMessage(playerid, 0xE2FFFFFF, "[Outros]: /kissman2 /kissman3 /pee");
                SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
                return 1;
            }
        }
    }
    else if(s_pLanguage[playerid] == 3) // Animações antigas.
    {
        SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
        SendClientMessage(playerid, 0xE2FFFFFF, "[Anims antigos]: /animped /dancar, /handsup, /taco, /tapinha, /bar, /lavagem, /sit2 ou /sentar2, /exercicio, /boquete, /bomba.");
		SendClientMessage(playerid, 0xC1D9D9FF, "[Anims antigos]: /transportar, /crack, /dormir, /pular, /acordo, /dancando, /comendo, /vomito, /gsign, /chat.");
		SendClientMessage(playerid, 0xE2FFFFFF, "[Anims antigos]: /oculos, /spray, /jogar, /pancada, /escritorio, /beijo, /faca, /cpr, /arranhar, /ponto.");
		SendClientMessage(playerid, 0xC1D9D9FF, "[Anims antigos]: /animo, /onda, /strip, /fumar, /recarregar, /taichi, /wank, /agachar, /skate, /bebado.");
		SendClientMessage(playerid, 0xE2FFFFFF, "[Anims antigos]: /chorar, /cansado, /lean, /rap, /cairfrente, /caircostas, /empunhar, /assutado, /sentar ou /sit, /crossarms, /fucku, /andar, /mijar, /pararanim.");
	    SendClientMessage(playerid, 0xC1D9D9FF, "[Anims antigos]: /riot ou /revolta, /camera, /bracojanela, /taxiE, /taxiD");
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
    }
    return 1;
}

ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 1)
{
    ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);

    s_pLoopingAnim{playerid} = true;

    if(!s_pFirstAnimation{playerid})
    {
        s_pFirstAnimation{playerid} = true;
        SendClientMessage(playerid, -1, "{FFFF00}Info:{FFFFFF} Você pode pressionar espaço para parar a animação ou usar /pararanimacao ou /stopanim.");
    }
    return 1;
}

AnimationCheck(playerid)
{
    return (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && Damage_IsAlive(playerid));
}

Control_Options(playerid, c@v)
{
    new
        stringC[3000];

    switch(c@v)
    {
        case 0:
        {
            format(stringC, sizeof(stringC), "Relacionado a ações especificas\nRelacionado a confronto\nRelacionado a comer e beber\nRelacionado a drogas e ferimentos\nRelacionado a posicionamento ativo\nRelacionado a posicionamento passivo\nRelacionado a armas\nRelacionado a esportes\nRelacionado a dança\nRelacionado a combate\nRelacionadas a gangues\nOutras animações");
            Dialog_Show(playerid, AnimListOptions, DIALOG_STYLE_LIST, "Lista de animações", stringC, "Selecionar", "Cancelar");

        }
        case 1:
        {
            format(stringC, sizeof(stringC), "Relacionado a ações especificas\nRelacionado a confronto\nRelacionado a comer e beber\nRelacionado a drogas e ferimentos\nRelacionado a posicionamento ativo\nRelacionado a posicionamento passivo\nRelacionado a armas\nRelacionado a esportes\nRelacionado a dança\nRelacionado a combate\nRelacionadas a gangues\nOutras animações");
            Dialog_Show(playerid, AnimListOptions, DIALOG_STYLE_LIST, "Animations List", stringC, "Select", "Cancel");

        }
        case 2:
        {
            SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
	        SendClientMessage(playerid, 0xE2FFFFFF, "[Anims antigos]: /animped /dancar, /handsup, /taco, /tapinha, /bar, /lavagem, /sit2 ou /sentar2, /exercicio, /boquete, /bomba.");
			SendClientMessage(playerid, 0xC1D9D9FF, "[Anims antigos]: /transportar, /crack, /dormir, /pular, /acordo, /dancando, /comendo, /vomito, /gsign, /chat.");
			SendClientMessage(playerid, 0xE2FFFFFF, "[Anims antigos]: /oculos, /spray, /jogar, /pancada, /escritorio, /beijo, /faca, /cpr, /arranhar, /ponto.");
			SendClientMessage(playerid, 0xC1D9D9FF, "[Anims antigos]: /animo, /onda, /strip, /fumar, /recarregar, /taichi, /wank, /agachar, /skate, /bebado.");
			SendClientMessage(playerid, 0xE2FFFFFF, "[Anims antigos]: /chorar, /cansado, /lean, /rap, /cairfrente, /caircostas, /empunhar, /assutado, /sentar ou /sit, /crossarms, /fucku, /andar, /mijar, /pararanim.");
		    SendClientMessage(playerid, 0xC1D9D9FF, "[Anims antigos]: /riot ou /revolta, /camera, /bracojanela, /taxiE, /taxiD");
		    SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________________");
        }
    }
    return 1;
}

// Comandos com parametros
CMD:strip(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/strip [1-7]");

		if (type < 1 || type > 7)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.1, 1, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.1, 1, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
			case 6: ApplyAnimationEx(playerid, "STRIP", "strip_F", 4.1, 1, 0, 0, 0, 0, 1);
			case 7: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		new result;
	    if(sscanf(params, "d", result)) return SendUsageMessage(playerid, "/strip [1-14]");

	    switch(result)
    	{
        	case 1: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_A",4.1,1,0,0,0,0,0); return 1;}
	        case 2: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_B",4.1,1,0,0,0,0,0); return 1;}
    	    case 3: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_C",4.1,1,0,0,0,0,0); return 1;}
        	case 4: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_D",4.1,1,0,0,0,0,0); return 1;}
	        case 5: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_E",4.1,1,0,0,0,0,0); return 1;}
    	    case 6: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_F",4.1,1,0,0,0,0,0); return 1;}
        	case 7: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "strip_G",4.1,1,0,0,0,0,0); return 1;}
	        case 8: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_Loop_A",4.1,1,0,0,0,0,0); return 1;}
    	    case 9: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_Loop_B",4.1,1,0,0,0,0,0); return 1;}
        	case 10: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_Loop_C",4.1,1,0,0,0,0,0); return 1;}
	        case 11: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_A2B",4.1,1,0,0,0,0,0); return 1;}
    	    case 12: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_B2C",4.1,1,0,0,0,0,0); return 1;}
        	case 13: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_C1",4.1,1,0,0,0,0,0); return 1;}
	        case 14: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "STRIP", "STR_C2",4.1,1,0,0,0,0,0); return 1;}
    	}
	}
    return 1;
}

CMD:dance(playerid, params[])
{
    new result;
    if(sscanf(params, "d", result)) return SendUsageMessage(playerid, "/dance [1-11]");

    switch(result)
    {
        case 1: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dance_loop",4.1,1,0,0,0,0,0); return 1;}
        case 2: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "bd_clap",4.1,1,0,0,0,0,0); return 1;}
        case 3: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "bd_clap1",4.1,1,0,0,0,0,0); return 1;}
        case 4: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A",4.1,1,0,0,0,0,0); return 1;}
        case 5: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A",4.1,1,0,0,0,0,0); return 1;}
        case 6: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A",4.1,1,0,0,0,0,0); return 1;}
        case 7: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A",4.1,1,0,0,0,0,0); return 1;}
        case 8: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_a",4.1,1,0,0,0,0,0); return 1;}
        case 9: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_c",4.1,1,0,0,0,0,0); return 1;}
        case 10: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_d",4.1,1,0,0,0,0,0); return 1;}
        case 11: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_e",4.1,1,0,0,0,0,0); return 1;}
    }
    return 1;
}

CMD:dancar(playerid, params[])
{
    new result;
    if(sscanf(params, "d", result)) return SendUsageMessage(playerid, "/dancar [1-11]");

    switch(result)
    {
        case 1: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dance_loop",4.1,1,0,0,0,0,0); return 1;}
        case 2: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "bd_clap",4.1,1,0,0,0,0,0); return 1;}
        case 3: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "bd_clap1",4.1,1,0,0,0,0,0); return 1;}
        case 4: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A",4.1,1,0,0,0,0,0); return 1;}
        case 5: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A",4.1,1,0,0,0,0,0); return 1;}
        case 6: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A",4.1,1,0,0,0,0,0); return 1;}
        case 7: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A",4.1,1,0,0,0,0,0); return 1;}
        case 8: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_a",4.1,1,0,0,0,0,0); return 1;}
        case 9: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_c",4.1,1,0,0,0,0,0); return 1;}
        case 10: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_d",4.1,1,0,0,0,0,0); return 1;}
        case 11: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "DANCING", "dnce_M_e",4.1,1,0,0,0,0,0); return 1;}
    }
    return 1;
}

CMD:gsign(playerid, params[]) // Gangs related animations
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/gsign [1-15]");

		if (type < 1 || type > 15)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0, 1);
			case 6: ApplyAnimationEx(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0, 1);
			case 7: ApplyAnimationEx(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0, 1);
			case 8: ApplyAnimationEx(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0, 1);
			case 9: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
			case 10: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
			case 11: ApplyAnimationEx(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0, 1);
			case 12: ApplyAnimationEx(playerid, "GANGS", "Invite_No", 4.1, 0, 0, 0, 0, 0, 1);
			case 13: ApplyAnimationEx(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 0, 0, 1);
			case 14: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkD", 4.1, 0, 0, 0, 0, 0, 1);
			case 15: ApplyAnimationEx(playerid, "GANGS", "smkcig_prtl", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	else
	{
	    new result;
	    if(sscanf(params, "d", result)) return SendUsageMessage(playerid, "/gsign [1-10]");

	    switch(result)
	    {
	        case 1: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign1",4.1,0,0,0,0,0,0); return 1;}
	        case 2: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign1LH",4.1,0,0,0,0,0,0); return 1;}
	        case 3: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign2",4.1,0,0,0,0,0,0); return 1;}
	        case 4: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign2LH",4.1,0,0,0,0,0,0); return 1;}
	        case 5: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign3",4.1,0,0,0,0,0,0); return 1;}
	        case 6: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign3LH",4.1,0,0,0,0,0,0); return 1;}
	        case 7: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign4",4.1,0,0,0,0,0,0); return 1;}
	        case 8: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign4LH",4.1,0,0,0,0,0,0); return 1;}
	        case 9: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign5",4.1,0,0,0,0,0,0); return 1;}
    	    case 10: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign5LH",4.1,0,0,0,0,0,0); return 1;}
    	}
	}
	return 1;
}

CMD:gestos(playerid, params[]) // Gangs related animations
{
    new result;
    if(sscanf(params, "d", result)) return SendUsageMessage(playerid, "/gestos [1-10]");

    switch(result)
    {
        case 1: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign1",4.1,0,0,0,0,0,0); return 1;}
        case 2: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign1LH",4.1,0,0,0,0,0,0); return 1;}
        case 3: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign2",4.1,0,0,0,0,0,0); return 1;}
        case 4: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign2LH",4.1,0,0,0,0,0,0); return 1;}
        case 5: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign3",4.1,0,0,0,0,0,0); return 1;}
        case 6: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign3LH",4.1,0,0,0,0,0,0); return 1;}
        case 7: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign4",4.1,0,0,0,0,0,0); return 1;}
        case 8: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign4LH",4.1,0,0,0,0,0,0); return 1;}
        case 9: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign5",4.1,0,0,0,0,0,0); return 1;}
        case 10: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign5LH",4.1,0,0,0,0,0,0); return 1;}
    }
    return 1;
}

CMD:gestoscriminosos(playerid, params[]) // Gangs related animations
{
    new result;
    if(sscanf(params, "d", result)) return SendUsageMessage(playerid, "/gestoscriminosos [1-10]");

    switch(result)
    {
        case 1: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign1",4.1,0,0,0,0,0,0); return 1;}
        case 2: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign1LH",4.1,0,0,0,0,0,0); return 1;}
        case 3: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign2",4.1,0,0,0,0,0,0); return 1;}
        case 4: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign2LH",4.1,0,0,0,0,0,0); return 1;}
        case 5: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign3",4.1,0,0,0,0,0,0); return 1;}
        case 6: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign3LH",4.1,0,0,0,0,0,0); return 1;}
        case 7: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign4",4.1,0,0,0,0,0,0); return 1;}
        case 8: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign4LH",4.1,0,0,0,0,0,0); return 1;}
        case 9: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign5",4.1,0,0,0,0,0,0); return 1;}
        case 10: {if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ghands", "gsign5LH",4.1,0,0,0,0,0,0); return 1;}
    }
    return 1;
}

// Comandos separados/sem parametros.

// • Specific action related animations
CMD:agree(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "gangs", "invite_yes",4.1,0,0,0,0,0,0); return 1;}
CMD:aim(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "gang_gunstand",4.1,1,0,0,0,0,0); return 1;}
CMD:angry(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_react_miss",4.1,1,0,0,0,1,0); return 1;}
CMD:camera2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "camera", "camstnd_cmon",4.1,1,0,0,0,1,0); return 1;}
CMD:camera3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "camera", "camcrch_idleloop",4.1,1,0,0,0,1,0); return 1;}
CMD:camshot1(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "camera", "piccrch_in",4.1,1,0,0,0,1,0); return 1;}
CMD:checkout(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "graffiti", "graffiti_Chkout",4.1,0,0,0,0,0,0); return 1;}
CMD:cpr(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);

	}
	else
	{
		if(!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "medic", "cpr",4.1,0,0,0,0,0,0);
	}
	return 1;
}
CMD:crawl(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "CAR_crawloutRHS",4.1,0,0,0,0,0,0); return 1;}
CMD:cry(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "graveyard", "mrnF_loop",4.1,1,0,0,0,0,0); return 1;}
CMD:deal(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "DEALER_DEAL",4.1,1,0,0,0,1,0); return 1;}
CMD:dishes(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "int_house", "wash_up",4.1,1,0,0,0,1,0); return 1;}
CMD:downpush(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "gangs", "shake_cara",4.1,0,0,0,0,0,0); return 1;}
CMD:dropflag(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "car", "flag_drop",4.1,0,0,0,0,0,0); return 1;}
CMD:fixcar(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "car", "Fixn_Car_Loop",4.1,1,0,0,0,0,0); return 1;}
CMD:fixcarout(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "car", "Fixn_Car_Out",4.1,0,0,0,0,0,0); return 1;}
CMD:flex(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "freeweights", "gym_free_celebrate",4.1,0,0,0,0,0,0); return 1;}
CMD:frontfall(playerid, params[]){ApplyAnimationEx(playerid, "ped", "FLOOR_hit_f",4.1,0,0,0,1,0,0); return 1;}
CMD:getupb(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "getup",4.1,0,0,0,0,0,0); return 1;}
CMD:getupf(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "getup_front",4.1,0,0,0,0,0,0); return 1;}
CMD:handoff(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "DRUGS_BUY",4.1,0,0,0,0,0,0); return 1;}
CMD:handoff2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "shop_pay",4.1,0,0,0,0,0,0); return 1;}
CMD:kickdoor(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "police", "Door_Kick",4.1,0,0,0,0,0,0); return 1;}
CMD:laugh(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "rapping", "Laugh_01",4.1,0,0,0,0,0,0); return 1;}
CMD:lookout2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "on_lookers", "panic_point",4.1,0,0,0,0,0,0); return 1;}
CMD:lowbump(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "gangs", "shake_carSH",4.1,0,0,0,0,0,0); return 1;}
CMD:openleft(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "van", "VAN_open_back_LHS",4.1,0,0,0,0,0,0); return 1;}
CMD:openright(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "van", "VAN_open_back_RHS",4.1,0,0,0,0,0,0); return 1;}
CMD:safeopen(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "rob_bank", "CAT_Safe_Open",4.1,0,0,0,0,1,0); return 1;}
CMD:payshop(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "int_shop", "shop_pay",4.1,0,0,0,0,0,0); return 1;}
CMD:push(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "GUN_BUTT",4.1,0,0,0,0,0,0); return 1;}
CMD:putdown(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "misc", "Case_pickup",4.1,0,0,0,0,0,0); return 1;}
CMD:reject(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "gangs", "invite_no",4.1,0,0,0,0,0,0); return 1;}
CMD:roadcross(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "roadcross",4.1,1,0,0,0,0,0); return 1;}
CMD:scratchballs(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "misc", "Scratchballs_01",4.1,0,0,0,0,0,0); return 1;}
CMD:shouldercheck(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bd_fire", "BD_Panic_04",4.1,0,0,0,0,0,0); return 1;}
CMD:spray(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
	}
	else
	{
		if(!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "sraycan", "spraycan_fire",4.1,0,0,0,0,0,0);
	}
	return 1;
}
CMD:spray2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "sraycan", "spraycan_full",4.1,0,0,0,0,0,0); return 1;}
CMD:throw(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_react_score",4.1,0,0,0,0,0,0); return 1;}
CMD:upshout(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "on_lookers", "lkup_loop",4.1,0,0,0,0,0,0); return 1;}
CMD:washhands(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bd_fire", "wash_up",4.1,0,0,0,0,0,0); return 1;}
CMD:no(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "endchat_02",4.1,0,0,0,0,0,0); return 1;}

// Adicionado na lista [13/08/16] [Não adicionado na documentação]
CMD:handsup(playerid, params[])
{
	if(!AnimationCheck(playerid))
		return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	SetPlayerSpecialAction(playerid, 10);
	return 1;
}
CMD:sipdrink(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "gangs", "drnkbr_prtl",4.1,0,0,0,0,0,0); return 1;}
CMD:flip(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "KD_right",4.1,0,0,0,0,0,0); return 1;}
CMD:stop(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "police", "CopTraf_Stop",4.1,0,0,0,0,0,0); return 1;}


// • Encounter related animations

CMD:comeon(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "misc", "BMX_comeon",4.1,0,0,0,0,0,0); return 1;}
CMD:facepalm(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "misc", "plyr_shkhead",4.1,0,0,0,0,0,0); return 1;}
CMD:fuckyou(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "fucku",4.1,0,0,0,0,0,0); return 1;}
CMD:fuckyou2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "riot_fuku",4.1,0,0,0,0,0,0); return 1;}
CMD:provoke(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_challenge",4.1,0,0,0,0,0,0); return 1;}
CMD:riot2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_chant",4.1,1,0,0,0,0,0); return 1;}
CMD:riot3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_PUNCHES",4.1,1,0,0,0,0,0); return 1;}
CMD:shout2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "on_lookers", "shout_loop",4.1,0,0,0,0,0,0); return 1;}
CMD:shoutat(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "on_lookers", "shout_01",4.1,0,0,0,0,0,0); return 1;}
CMD:shouts(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_shout",4.1,0,0,0,0,0,0); return 1;}
CMD:taunt(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "misc", "KAT_Throw_K",4.1,0,0,0,0,0,0); return 1;}
CMD:what(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_ANGRY",4.1,0,0,0,0,0,0); return 1;}

// • Drinking & eating related animations

CMD:baridle(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bar", "BARman_idle",4.1,0,0,0,0,1,0); return 1;}
CMD:barorder(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bar", "Barcustom_loop",4.1,0,0,0,0,0,0); return 1;}
CMD:eatfood(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "gum_eat",4.1,0,0,0,0,0,0); return 1;}
CMD:forwardlook(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bd_fire", "BD_Panic_02",4.1,0,0,0,0,0,0); return 1;}
CMD:servebottle(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bar", "Barserve_bottle",4.1,0,0,0,0,0,0); return 1;}
CMD:serveglass(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bar", "Barserve_glass",4.1,0,0,0,0,0,0); return 1;}

// • Drugged & wounded related animations

CMD:crack(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/crack [1-6]");

		if (type < 1 || type > 6)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
			case 2: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
			case 4: ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
			case 5: ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
			case 6: ApplyAnimationEx(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
		}
	}
	else
	{
		if(!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "crack", "crckdeth2",4.1,1,0,0,0,0,0);
	}
	return 1;
}
CMD:crack2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "crack", "crckidle1",4.1,0,0,0,0,0,0); return 1;}
CMD:crack3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "crack", "crckdeth3",4.1,0,0,0,1,0,0); return 1;}
CMD:crack4(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "crack", "crckdeth1",4.1,0,0,0,1,0,0); return 1;}
CMD:getshot(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "KO_shot_stom",4.1,0,0,0,1,0,0); return 1;}
CMD:injured(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "sweet", "Sweet_injuredloop",4.1,1,0,0,0,0,0); return 1;}

// • Active stance animations

CMD:bat(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "crack", "BBALBAT_IDLE_01",4.1,0,0,0,1,0,0); return 1;}
CMD:bat2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "crack", "BBALBAT_IDLE_02",4.1,0,0,0,1,0,0); return 1;}
CMD:batstance(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "baseball", "Bat_IDLE",4.1,1,0,0,0,0,0); return 1;}
CMD:dying(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "wuzi", "CS_Dead_Guy",4.1,1,0,0,0,0,0); return 1;}
CMD:exhausted(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "IDLE_tired",4.1,1,0,0,0,0,0); return 1;}
CMD:fightstance(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "FightIdle",4.1,1,0,0,0,0,0); return 1;}
CMD:forwardpanic(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bd_fire", "BD_Panic_03",4.1,0,0,0,0,0,0); return 1;}
CMD:forwardwave(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bd_fire", "BD_Panic_01",4.1,0,0,0,0,0,0); return 1;}
CMD:lookout(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "on_lookers", "lkaround_loop",4.1,0,0,0,0,0,0); return 1;}
CMD:lookout3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "XPRESSscratch",4.1,1,0,0,0,0,0); return 1;}
CMD:rap1(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "lowrider", "RAP_A_Loop",4.1,1,0,0,0,0,0); return 1;}
CMD:rap2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "lowrider", "RAP_b_Loop",4.1,1,0,0,0,0,0); return 1;}
CMD:rap3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "lowrider", "RAP_c_Loop",4.1,1,0,0,0,0,0); return 1;}
CMD:stretch(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "benchpress", "gym_bp_celebrate",4.1,0,0,0,0,0,0); return 1;}
CMD:stretch2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "PLAYIDLES", "STRETCH",4.1,0,0,0,0,0,0); return 1;}
CMD:tired(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fat", "IDLE_tired",4.1,1,0,0,0,0,0); return 1;}

// • Passive stance animations

CMD:comecross(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "otb", "wtchrace_cmon",4.1,0,0,0,1,0,0); return 1;}
CMD:crossarms(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/crossarms [1-4]");

		if (type < 1 || type > 4)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
			case 2: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
		}
	}
	else
	{
		if(!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");
		ApplyAnimationEx(playerid, "COP_AMBIENT", "COPLOOK_IN",4.1,0,0,0,1,0,0);
	}
	return 1;
}
CMD:crossarms2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "COP_AMBIENT", "COPLOOK_NOD",4.1,0,0,0,1,0,0); return 1;}
CMD:crossarms3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "COP_AMBIENT", "COPLOOK_THINK",4.1,0,0,0,1,0,0); return 1;}
CMD:crossarms4(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "otb", "wtchrace_in",4.1,0,0,0,1,0,0); return 1;}
CMD:crosswin(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "otb", "wtchrace_win",4.1,0,0,0,1,0,0); return 1;}
CMD:dealerstance(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "DEALER_IDLE",4.1,1,0,0,0,0,0); return 1;}
CMD:dealerstance2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "DEALER_IDLE_01",4.1,1,0,0,0,0,0); return 1;}
CMD:dealerstance3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "DEALER_IDLE_02",4.1,1,0,0,0,0,0); return 1;}
CMD:dealerstance4(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dealer", "DEALER_IDLE_03",4.1,1,0,0,0,0,0); return 1;}
CMD:fallover(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "parachute", "FALL_SKYDIVE_DIE",4.1,0,0,0,1,0,0); return 1;}
CMD:lean(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;
		if(sscanf(params,"d",type))
			return SendUsageMessage(playerid, "/lean [1-3]");

		switch(type)
		{
			case 1: ApplyAnimationEx(playerid,"GANGS","leanIDLE",4.0,0,1,1,1,0);
			case 2: ApplyAnimationEx(playerid,"MISC","Plyrlean_loop",4.0,1,1,1,1,0);
			case 3: ApplyAnimationEx(playerid,"BAR","BARman_idle",3.0,1,1,1,1,0);
		}
	}
	else
	{
		if(!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "gangs", "leanIDLE",4.1,0,1,1,1,0,0);
	}
	return 1;
}
CMD:lean2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "misc", "PLYRLEAN_LOOP",4.1,0,0,0,1,0,0); return 1;}
CMD:mourn(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "graveyard", "mrnM_loop",4.1,0,0,0,1,0,0); return 1;}
CMD:old(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "idlestance_old",4.1,1,0,0,0,0,0); return 1;}
CMD:priest(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "graveyard", "prst_loopa",4.1,0,0,0,1,0,0); return 1;}
CMD:rifflestance(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "IDLE_armed",4.1,0,0,0,1,0,0); return 1;}
CMD:uturn(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "turn_180",4.1,0,0,0,1,0,0); return 1;}
CMD:deskbored(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "int_office", "OFF_Sit_Bored_Loop",4.1,0,0,0,1,0,0); return 1;}
CMD:desksit(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "int_office", "OFF_Sit_Idle_Loop",4.1,0,0,0,1,0,0); return 1;}
CMD:seat(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "SEAT_down",4.1,0,0,0,1,0,0); return 1;}
CMD:sit(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/sit [1-6]");

		if (type < 1 || type > 6)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0);
			case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0);
			case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0);
			case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
			case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);
			case 6: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
		}
	}
	else
	{
		if(!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "beach", "ParkSit_M_loop",4.1,0,0,0,1,0,0);
	}
	return 1;
}

CMD:sit2(playerid, params[])
{
    if(s_pLanguage[playerid] == 3)
    {
        new type;

        if (!AnimationCheck(playerid))
            return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

        if (sscanf(params, "d", type))
            return SendUsageMessage(playerid, "/sit2 [1-5]");

        if (type < 1 || type > 5)
            return SendErrorMessage(playerid, "Opção invalida.");

        switch (type) {
            case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
            case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
            case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
            case 4: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
            case 5: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
        }
    }
    else
    {
        if(!AnimationCheck(playerid))
            return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

        ApplyAnimationEx(playerid, "beach", "SitnWait_loop_W",4.1,0,0,0,1,0,0);
    }
    return 1;
}

CMD:sit3(playerid, params[])
{
    if(!AnimationCheck(playerid))
        return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

    ApplyAnimationEx(playerid, "FOOD", "FF_Sit_In",4.1,0,0,0,1,0,0);
    return 1;
}

CMD:sit4(playerid, params[])
{
    if(!AnimationCheck(playerid))
        return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

    ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_In",4.1,0,0,0,1,0,0);
    return 1;
}

// • Shooting related animations

CMD:aimshoot(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "python", "python_fire",4.1,0,0,0,0,0,0); return 1;}
CMD:aimshoot2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "python", "python_fire_poor",4.1,0,0,0,0,0,0); return 1;}
CMD:creload(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "colt45", "colt45_crouchreload",4.1,0,0,0,0,0,0); return 1;}
CMD:crouchshoot(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "python", "python_crouchfire",4.1,0,0,0,0,0,0); return 1;}
CMD:crouchreload(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "python", "python_crouchreload",4.1,0,0,0,0,0,0); return 1;}
CMD:reload(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "colt45", "colt45_reload",4.1,0,0,0,0,0,0); return 1;}
CMD:shottyreload(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "colt45", "sawnoff_reload",4.1,0,0,0,0,0,0); return 1;}

// • Basketball related animations

CMD:blockshot(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_def_jump_shot",4.1,0,0,0,0,0,0); return 1;}
CMD:defense(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_def_loop",4.1,1,0,0,0,0,0); return 1;}
CMD:defenser(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_def_StepR",4.1,0,0,0,0,0,0); return 1;}
CMD:dribble(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_idle",4.1,0,0,0,0,0,0); return 1;}
CMD:dribble2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_walk",4.1,0,0,0,0,0,0); return 1;}
CMD:dribble3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_run",4.1,0,0,0,0,0,0); return 1;}
CMD:dunk(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_Dnk",4.1,0,0,0,0,0,0); return 1;}
CMD:dunk2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_Dnk_gli",4.1,0,0,0,0,0,0); return 1;}
CMD:fakeshot(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_Jump_Cancel",4.1,0,0,0,0,0,0); return 1;}
CMD:jumpshot(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_Jump_Shot",4.1,0,0,0,0,0,0); return 1;}
CMD:pickupball(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "bsktball", "BBALL_pickup",4.1,0,0,0,0,0,0); return 1;}

// • Fighting related animations

CMD:backhit(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_b", "HitB_1",4.1,0,0,0,0,0,0); return 1;}
CMD:bitchslap(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "baseball", "BAT_PART",4.1,0,0,0,0,0,0); return 1;}
CMD:boxe1(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_b", "FightB_1",4.1,0,0,0,0,0,0); return 1;}
CMD:boxe2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_b", "FightB_2",4.1,0,0,0,0,0,0); return 1;}
CMD:choke(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "knife", "KILL_Knife_Player",4.1,0,0,0,0,0,0); return 1;}
CMD:cutthroat(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "knife", "KILL_Knife_Ped_Die",4.1,0,0,0,1,0,0); return 1;}
CMD:dodge(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "baseball", "Bat_Hit_1",4.1,0,0,0,0,0,0); return 1;}
CMD:fallhit(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_c", "HitC_3",4.1,0,0,0,1,0,0); return 1;}
CMD:fallkick(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Fight_E", "Hit_fightkick",4.1,0,0,0,0,0,0); return 1;}
CMD:flykick(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_c", "FightC_M",4.1,0,0,0,0,0,0); return 1;}
CMD:groundhit(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "dildo", "dildo_g",4.1,0,0,0,0,0,0); return 1;}
CMD:kickhim(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Fight_E", "FightKick_B",4.1,0,0,0,0,0,0); return 1;}
CMD:kungfu1(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Fight_C", "FightC_1",4.1,0,0,0,0,0,0); return 1;}
CMD:kungfu2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Fight_C", "FightC_2",4.1,0,0,0,0,0,0); return 1;}
CMD:kungfu3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Fight_C", "FightC_3",4.1,0,0,0,0,0,0); return 1;}
CMD:kungfublock(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_c", "FightC_idle",4.1,1,0,0,0,0,0); return 1;}
CMD:kungfustomp(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "fight_c", "FightC_G",4.1,0,0,0,0,0,0); return 1;}
CMD:punch(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "knife", "knife_1",4.1,0,0,0,0,0,0); return 1;}
CMD:riotpunch(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_ANGRY_B",4.1,1,0,0,0,0,0); return 1;}
CMD:riotpunch2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "riot", "RIOT_PUNCHES",4.1,0,0,0,0,0,0); return 1;}
CMD:shadowbox(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "gymnasium", "GYMshadowbox",4.1,1,0,0,0,0,0); return 1;}
CMD:sliced(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "knife", "knife_hit_1",4.1,0,0,0,0,0,0); return 1;}
CMD:stab2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "knife", "Knife_G",4.1,0,0,0,0,0,0); return 1;}
CMD:sword(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "sword", "sword_IDLE",4.1,1,0,0,0,0,0); return 1;}

// • Outros anims

CMD:animatm(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "ped", "atm",4.1,0,0,0,0,0,0); return 1;}
CMD:benchpress(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_A",4.1,0,0,0,1,0,0); return 1;}
CMD:weights(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "freeweights", "gym_barbell",4.1,1,0,0,0,0,0); return 1;}
CMD:weights2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "freeweights", "gym_free_A",4.1,1,0,0,0,0,0); return 1;}
CMD:relaxed(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "blowjobz", "BJ_Couch_loop_P",4.1,1,0,0,0,0,0); return 1;}
CMD:blowjob(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "blowjobz", "BJ_Couch_Start_w",4.1,0,0,0,1,0,0); return 1;}
CMD:kissgirl1(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Kissing", "Grlfrd_Kiss_01",4.1,0,0,0,0,0,0); return 1;}
CMD:kissgirl2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Kissing", "Grlfrd_Kiss_02",4.1,0,0,0,0,0,0); return 1;}
CMD:kissgirl3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Kissing", "Grlfrd_Kiss_03",4.1,0,0,0,0,0,0); return 1;}
CMD:kissman1(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Kissing", "Playa_Kiss_01",4.1,0,0,0,0,0,0); return 1;}
CMD:kissman2(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Kissing", "Playa_Kiss_02",4.1,0,0,0,0,0,0); return 1;}
CMD:kissman3(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "Kissing", "Playa_Kiss_03",4.1,0,0,0,0,0,0); return 1;}
CMD:pee(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "PAULNMAC", "Piss_loop",4.1,0,0,0,1,0,0); return 1;}
CMD:crifle(playerid, params[]){if(!AnimationCheck(playerid)) return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");ApplyAnimationEx(playerid, "RIFLE", "RIFLE_load",4.1,0,0,0,0,0,0); return 1;}

// Lista de animações em português (Redirecionamento ForT).

//• Relacionado a Ações Especificas
CMD:concordar(playerid, params[]) return PC_EmulateCommand(playerid, "/agree");
CMD:mirar(playerid) return PC_EmulateCommand(playerid, "/aim");
CMD:raiva(playerid) return PC_EmulateCommand(playerid, "/angry");
CMD:cliquecamera(playerid) return PC_EmulateCommand(playerid, "/camshot1");
CMD:checar(playerid) return PC_EmulateCommand(playerid, "/checkout");
CMD:salvar(playerid) return PC_EmulateCommand(playerid, "/cpr");
CMD:rastejar(playerid) return PC_EmulateCommand(playerid, "/crawl");
CMD:chorar(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	else
	{
	    PC_EmulateCommand(playerid, "/cry");
	}
	return 1;
}
CMD:acordo(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/acordo [1-6]");

		if (type < 1 || type > 6)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
			case 6: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/deal");
	}
	return 1;
}
CMD:lavar(playerid) return PC_EmulateCommand(playerid, "/dishes");
CMD:empurrar(playerid) return PC_EmulateCommand(playerid, "/downpush");
CMD:bandeira(playerid) return PC_EmulateCommand(playerid, "/dropflag");
CMD:consertarcarro(playerid) return PC_EmulateCommand(playerid, "/fixcar");
CMD:consertarcarrofim(playerid) return PC_EmulateCommand(playerid, "/fixcarout");
CMD:forte(playerid) return PC_EmulateCommand(playerid, "/flex");
CMD:levantarcostas(playerid) return PC_EmulateCommand(playerid, "/getupb");
CMD:levantarfrente(playerid) return PC_EmulateCommand(playerid, "/getupf");
CMD:limpar(playerid) return PC_EmulateCommand(playerid, "/handoff");
CMD:dinheiro(playerid) return PC_EmulateCommand(playerid, "/handoff2");
CMD:chutarporta(playerid) return PC_EmulateCommand(playerid, "/kickdoor");
CMD:rir(playerid) return PC_EmulateCommand(playerid, "/laugh");
CMD:apontar(playerid) return PC_EmulateCommand(playerid, "/lookout2");
CMD:ombro(playerid) return PC_EmulateCommand(playerid, "/lowbump");
CMD:abriresquerda(playerid) return PC_EmulateCommand(playerid, "/openleft");
CMD:abrirdireita(playerid) return PC_EmulateCommand(playerid, "/openright");
CMD:animcofre(playerid) return PC_EmulateCommand(playerid, "/safeopen");
CMD:dinheiro2(playerid) return PC_EmulateCommand(playerid, "/payshop");
CMD:cotovelo(playerid) return PC_EmulateCommand(playerid, "/push");
CMD:largar(playerid) return PC_EmulateCommand(playerid, "/putdown");
CMD:rejeitar(playerid) return PC_EmulateCommand(playerid, "/reject");
CMD:atravessarrua(playerid) return PC_EmulateCommand(playerid, "/roadcross");
CMD:cocarsaco(playerid) return PC_EmulateCommand(playerid, "/scratchballs");
CMD:checarombro(playerid) return PC_EmulateCommand(playerid, "/shouldercheck");
CMD:grafitti(playerid) return PC_EmulateCommand(playerid, "/spray");
CMD:grafitti2(playerid) return PC_EmulateCommand(playerid, "/spray2");
CMD:jogar(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		ApplyAnimationEx(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	}
	else
	{
		PC_EmulateCommand(playerid, "/throw");
	}
	return 1;
}
CMD:animgritar(playerid) return PC_EmulateCommand(playerid, "/upshout");//aq
CMD:lavarmao(playerid) return PC_EmulateCommand(playerid, "/washhands");
CMD:parar(playerid) return PC_EmulateCommand(playerid, "/stop");
CMD:nao(playerid) return PC_EmulateCommand(playerid, "/no");


//• Relacionado a Confronto
CMD:chamar(playerid) return PC_EmulateCommand(playerid, "/comeon");
CMD:palmatesta(playerid) return PC_EmulateCommand(playerid, "/facepalm");
CMD:fodase(playerid) return PC_EmulateCommand(playerid, "/fuckyou");
CMD:fodase2(playerid) return PC_EmulateCommand(playerid, "/fuckyou2");
CMD:provocar(playerid) return PC_EmulateCommand(playerid, "/provoke");
CMD:tumulto(playerid) return PC_EmulateCommand(playerid, "/riot2");
CMD:tumulto2(playerid) return PC_EmulateCommand(playerid, "/riot3");
CMD:gritar2(playerid) return PC_EmulateCommand(playerid, "/shout2");
CMD:gritar3(playerid) return PC_EmulateCommand(playerid, "/shoutat ");
CMD:gritar4(playerid) return PC_EmulateCommand(playerid, "/shouts");
CMD:provocar2(playerid) return PC_EmulateCommand(playerid, "/taunt");
CMD:provocar3(playerid) return PC_EmulateCommand(playerid, "/what");

//• Relacionado a Comer e Beber
CMD:bar(playerid, params[])
{
    if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/bar [1-8]");

		if (type < 1 || type > 8)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "BAR", "Barserve_bottle", 4.1, 0, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "BAR", "Barserve_glass", 4.1, 0, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "BAR", "Barserve_in", 4.1, 0, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "BAR", "Barserve_order", 4.1, 0, 0, 0, 0, 0, 1);
			case 6: ApplyAnimationEx(playerid, "BAR", "BARman_idle", 4.1, 1, 0, 0, 0, 0, 1);
			case 7: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
			case 8: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	else
	{
	 	PC_EmulateCommand(playerid, "/baridle");
	}
	return 1;
}
CMD:barpedir(playerid) return PC_EmulateCommand(playerid, "/barorder");
CMD:comer(playerid) return PC_EmulateCommand(playerid, "/eatfood");
CMD:olharbar(playerid) return PC_EmulateCommand(playerid, "/forwardlook");
CMD:barservir(playerid) return PC_EmulateCommand(playerid, "/servebottle");
CMD:barservir2(playerid) return PC_EmulateCommand(playerid, "/serveglass");
CMD:animbeber(playerid) return PC_EmulateCommand(playerid, "/sipdrink");

//• Relacionado a Drogas e Ferimentos
CMD:droga(playerid) return PC_EmulateCommand(playerid, "/crack");
CMD:droga2(playerid) return PC_EmulateCommand(playerid, "/crack2");
CMD:droga3(playerid) return PC_EmulateCommand(playerid, "/crack3");
CMD:droga4(playerid) return PC_EmulateCommand(playerid, "/crack4");
CMD:mortal(playerid) return PC_EmulateCommand(playerid, "/flip");
CMD:cairfrente(playerid) return PC_EmulateCommand(playerid, "/frontfall");
CMD:baleado(playerid) return PC_EmulateCommand(playerid, "/getshot");
CMD:ferido(playerid) return PC_EmulateCommand(playerid, "/injured");

//• Relacionado a Posicionamento Ativo
CMD:taco2(playerid) return PC_EmulateCommand(playerid, "/bat");
CMD:taco3(playerid) return PC_EmulateCommand(playerid, "/bat2");
CMD:taco(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;
		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/taco [1-5]");

		if (type < 1 || type > 5)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "BASEBALL", "Bat_1", 4.1, 0, 1, 1, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "BASEBALL", "Bat_2", 4.1, 0, 1, 1, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "BASEBALL", "Bat_3", 4.1, 0, 1, 1, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
		}

	}
	else
	{
	 	PC_EmulateCommand(playerid, "/batstance");
	}
	return 1;
}
CMD:morrendo(playerid) return PC_EmulateCommand(playerid, "/dying");
CMD:exausto(playerid) return PC_EmulateCommand(playerid, "/exhausted");
CMD:lutar(playerid) return PC_EmulateCommand(playerid, "/fightstance");
CMD:panico(playerid) return PC_EmulateCommand(playerid, "/forwardpanic");
CMD:panico2(playerid) return PC_EmulateCommand(playerid, "/forwardwave");
CMD:olhar(playerid) return PC_EmulateCommand(playerid, "/lookout");
CMD:olharvolta(playerid) return PC_EmulateCommand(playerid, "/lookout3");
CMD:alongar(playerid) return PC_EmulateCommand(playerid, "/stretch");
CMD:alongar2(playerid) return PC_EmulateCommand(playerid, "/stretch2");
CMD:cansado(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/cansado [1-2]");

		if (type < 1 || type > 2)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/tired");
	}
	return 1;
}


 //• Relacionado a Posicionamento Passivo
CMD:reclamar(playerid) return PC_EmulateCommand(playerid, "/comecross");
CMD:cruzarbracos(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/cruzarbracos [1-4]");

		if (type < 1 || type > 4)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
			case 2: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/crossarms");
	}
	return 1;
}
CMD:cruzarbracos2(playerid) return PC_EmulateCommand(playerid, "/crossarms2");
CMD:cruzarbracos3(playerid) return PC_EmulateCommand(playerid, "/crossarms3");
CMD:cruzarbracos4(playerid) return PC_EmulateCommand(playerid, "/crossarms4");
CMD:cruzarbracos5(playerid) return PC_EmulateCommand(playerid, "/crosswin");
CMD:trafico(playerid) return PC_EmulateCommand(playerid, "/dealerstance");
CMD:trafico2(playerid) return PC_EmulateCommand(playerid, "/dealerstance2");
CMD:trafico3(playerid) return PC_EmulateCommand(playerid, "/dealerstance3");
CMD:trafico4(playerid) return PC_EmulateCommand(playerid, "/dealerstance4");
CMD:deitar(playerid) return PC_EmulateCommand(playerid, "/fallover");
CMD:escorar(playerid) return PC_EmulateCommand(playerid, "/lean2");
CMD:escorar2(playerid) return PC_EmulateCommand(playerid, "/lean2");
CMD:pesames(playerid) return PC_EmulateCommand(playerid, "/mourn");
CMD:velho(playerid) return PC_EmulateCommand(playerid, "/old");
CMD:padre(playerid) return PC_EmulateCommand(playerid, "/priest");
CMD:armado(playerid) return PC_EmulateCommand(playerid, "/rifflestance");
CMD:virar(playerid) return PC_EmulateCommand(playerid, "/uturn");
CMD:escritoriotedio(playerid) return PC_EmulateCommand(playerid, "/deskbored");
CMD:escritorio(playerid, params[])
{
    if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/escritorio [1-6]");

		if (type < 1 || type > 6)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Drink", 4.1, 1, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 6: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Watch", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/desksit");
	}
	return 1;
}
CMD:sentar(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/sentar [1-6]");

		if (type < 1 || type > 6)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0);
			case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0);
			case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0);
			case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
			case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);
			case 6: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/seat");
	}
	return 1;
}
CMD:sentar2(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/sentar2 [1-5]");

		if (type < 1 || type > 5)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
			case 5: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/sit");
	}
	return 1;
}
CMD:sentar3(playerid) return PC_EmulateCommand(playerid, "/sit2");
CMD:sentar4(playerid) return PC_EmulateCommand(playerid, "/sit3");
CMD:sentar5(playerid) return PC_EmulateCommand(playerid, "/sit4");

//• Relacionado a Armas
CMD:atirar(playerid) return PC_EmulateCommand(playerid, "/aimshoot");
CMD:atirar2(playerid) return PC_EmulateCommand(playerid, "/aimshoot2");
CMD:recarregar2(playerid) return PC_EmulateCommand(playerid, "/creload");
CMD:atirar3(playerid) return PC_EmulateCommand(playerid, "/crouchshoot");
CMD:recarregar3(playerid) return PC_EmulateCommand(playerid, "/crouchreload");
CMD:recarregar(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/recarregar [1-4]");

		if (type < 1 || type > 4)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "RIFLE", "rifle_load", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/reload");
	}
	return 1;
}
CMD:srecarregar(playerid) return PC_EmulateCommand(playerid, "/shottyreload");

//• Relacionado a Esportes
CMD:bloquear(playerid) return PC_EmulateCommand(playerid, "/blockshot");
CMD:defender(playerid) return PC_EmulateCommand(playerid, "/defense");
CMD:defender2(playerid) return PC_EmulateCommand(playerid, "/defenser");
CMD:driblar(playerid) return PC_EmulateCommand(playerid, "/dribble");
CMD:driblar2(playerid) return PC_EmulateCommand(playerid, "/dribble2");
CMD:driblar3(playerid) return PC_EmulateCommand(playerid, "/dribble3");
CMD:enterrar(playerid) return PC_EmulateCommand(playerid, "/dunk");
CMD:enterrar2(playerid) return PC_EmulateCommand(playerid, "/dunk2");
CMD:arremessofake(playerid) return PC_EmulateCommand(playerid, "/fakeshot");
CMD:arremessar(playerid) return PC_EmulateCommand(playerid, "/jumpshot");
CMD:pegarbola(playerid) return PC_EmulateCommand(playerid, "/pickupball");

//• Relacionado a Dança
CMD:dancasensual(playerid) return PC_EmulateCommand(playerid, "/strip");

//• Relacionado a Combate
CMD:apanhar(playerid) return PC_EmulateCommand(playerid, "/backhit");
CMD:animtapa(playerid) return PC_EmulateCommand(playerid, "/bitchslap");
CMD:gargantacortada(playerid) return PC_EmulateCommand(playerid, "/cutthroat");
CMD:desviar(playerid) return PC_EmulateCommand(playerid, "/dodge");
CMD:cair2(playerid) return PC_EmulateCommand(playerid, "/fallhit");
CMD:cair(playerid) return PC_EmulateCommand(playerid, "/fallkick");
CMD:chutevoador(playerid) return PC_EmulateCommand(playerid, "/flykick");
CMD:golpechao(playerid) return PC_EmulateCommand(playerid, "/groundhit ");
CMD:chutar(playerid) return PC_EmulateCommand(playerid, "/kickhim");
CMD:kungfu(playerid) return PC_EmulateCommand(playerid, "/kungfublock");
CMD:kungfu5(playerid) return PC_EmulateCommand(playerid, "/kungfustomp");
CMD:soco(playerid) return PC_EmulateCommand(playerid, "/punch");
CMD:tumulto3(playerid) return PC_EmulateCommand(playerid, "/riotpunch");
CMD:tumulto4(playerid) return PC_EmulateCommand(playerid, "/riotpunch2");//aq
CMD:treinarboxe(playerid) return PC_EmulateCommand(playerid, "/shadowbox");
CMD:esfaquear(playerid) return PC_EmulateCommand(playerid, "/sliced");
CMD:esfaquear2(playerid) return PC_EmulateCommand(playerid, "/stab2");
CMD:espada(playerid) return PC_EmulateCommand(playerid, "/sword");

// • Outros animes
CMD:supino(playerid) return PC_EmulateCommand(playerid, "/benchpress");
CMD:biceps(playerid) return PC_EmulateCommand(playerid, "/weights");
CMD:biceps2(playerid) return PC_EmulateCommand(playerid, "/weights2");
CMD:relaxar(playerid) return PC_EmulateCommand(playerid, "/relaxed");
CMD:boquete(playerid, params[])
{
	if(s_pLanguage[playerid] == 3)
	{
		new type;

		if (!AnimationCheck(playerid))
			return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

		if (sscanf(params, "d", type))
			return SendUsageMessage(playerid, "/boquete [1-4]");

		if (type < 1 || type > 4)
			return SendErrorMessage(playerid, "Opção invalida.");

		switch (type) {
			case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
			case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
			case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
			case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
		}
	}
	else
	{
		PC_EmulateCommand(playerid, "/blowjob");
	}
	return 1;
}
CMD:beijomulher1(playerid) return PC_EmulateCommand(playerid, "/kissgirl1");
CMD:beijomulher2(playerid) return PC_EmulateCommand(playerid, "/kissgirl2");
CMD:beijomulher3(playerid) return PC_EmulateCommand(playerid, "/kissgirl3");
CMD:beijohomem1(playerid) return PC_EmulateCommand(playerid, "/kissman1");
CMD:beijohomem2(playerid) return PC_EmulateCommand(playerid, "/kissman2");
CMD:beijohomem3(playerid) return PC_EmulateCommand(playerid, "/kissman3");
CMD:mijar(playerid) return PC_EmulateCommand(playerid, "/pee");

//Old anims
CMD:animped(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "i", type))
	    return SendUsageMessage(playerid, "/animped [1-295]");
	if (type < 1 || type > 295)
		return SendErrorMessage(playerid, "Opção invalida.");
	switch(type)
	{
		case 1: ApplyAnimationEx(playerid, "PED", "abseil", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "PED", "ATM", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "PED", "BIKE_elbowL", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "PED", "BIKE_elbowR", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "PED", "BIKE_pickupL", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimationEx(playerid, "PED", "BIKE_pickupR", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimationEx(playerid, "PED", "BIKE_pullupL", 4.1, 0, 1, 1, 1, 1, 1);
		case 11: ApplyAnimationEx(playerid, "PED", "BIKE_pullupR", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimationEx(playerid, "PED", "bomber", 4.1, 0, 1, 1, 1, 1, 1);
		case 13: ApplyAnimationEx(playerid, "PED", "CAR_alignHI_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 14: ApplyAnimationEx(playerid, "PED", "CAR_alignHI_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 15: ApplyAnimationEx(playerid, "PED", "CAR_align_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 16: ApplyAnimationEx(playerid, "PED", "CAR_align_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 17: ApplyAnimationEx(playerid, "PED", "CAR_closedoorL_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 18: ApplyAnimationEx(playerid, "PED", "CAR_closedoorL_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 19: ApplyAnimationEx(playerid, "PED", "CAR_closedoor_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 20: ApplyAnimationEx(playerid, "PED", "CAR_closedoor_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 21: ApplyAnimationEx(playerid, "PED", "CAR_close_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 22: ApplyAnimationEx(playerid, "PED", "CAR_close_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 23: ApplyAnimationEx(playerid, "PED", "CAR_crawloutRHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 24: ApplyAnimationEx(playerid, "PED", "CAR_dead_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 25: ApplyAnimationEx(playerid, "PED", "CAR_dead_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 26: ApplyAnimationEx(playerid, "PED", "CAR_doorlocked_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 27: ApplyAnimationEx(playerid, "PED", "CAR_doorlocked_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 28: ApplyAnimationEx(playerid, "PED", "CAR_fallout_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 29: ApplyAnimationEx(playerid, "PED", "CAR_fallout_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 30: ApplyAnimationEx(playerid, "PED", "CAR_getinL_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 31: ApplyAnimationEx(playerid, "PED", "CAR_getinL_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 32: ApplyAnimationEx(playerid, "PED", "CAR_getin_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 33: ApplyAnimationEx(playerid, "PED", "CAR_getin_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 34: ApplyAnimationEx(playerid, "PED", "CAR_getoutL_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 35: ApplyAnimationEx(playerid, "PED", "CAR_getoutL_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 36: ApplyAnimationEx(playerid, "PED", "CAR_getout_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 37: ApplyAnimationEx(playerid, "PED", "CAR_getout_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 38: ApplyAnimationEx(playerid, "PED", "car_hookertalk", 4.1, 0, 1, 1, 1, 1, 1);
		case 39: ApplyAnimationEx(playerid, "PED", "CAR_jackedLHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 40: ApplyAnimationEx(playerid, "PED", "CAR_jackedRHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 41: ApplyAnimationEx(playerid, "PED", "CAR_jumpin_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 42: ApplyAnimationEx(playerid, "PED", "CAR_LB", 4.1, 0, 1, 1, 1, 1, 1);
		case 43: ApplyAnimationEx(playerid, "PED", "CAR_LB_pro", 4.1, 0, 1, 1, 1, 1, 1);
		case 44: ApplyAnimationEx(playerid, "PED", "CAR_LB_weak", 4.1, 0, 1, 1, 1, 1, 1);
		case 45: ApplyAnimationEx(playerid, "PED", "CAR_LjackedLHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 46: ApplyAnimationEx(playerid, "PED", "CAR_LjackedRHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 47: ApplyAnimationEx(playerid, "PED", "CAR_Lshuffle_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 48: ApplyAnimationEx(playerid, "PED", "CAR_Lsit", 4.1, 0, 1, 1, 1, 1, 1);
		case 49: ApplyAnimationEx(playerid, "PED", "CAR_open_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 50: ApplyAnimationEx(playerid, "PED", "CAR_open_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 51: ApplyAnimationEx(playerid, "PED", "CAR_pulloutL_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 52: ApplyAnimationEx(playerid, "PED", "CAR_pulloutL_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 53: ApplyAnimationEx(playerid, "PED", "CAR_pullout_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 54: ApplyAnimationEx(playerid, "PED", "CAR_pullout_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 55: ApplyAnimationEx(playerid, "PED", "CAR_Qjacked", 4.1, 0, 1, 1, 1, 1, 1);
		case 56: ApplyAnimationEx(playerid, "PED", "CAR_rolldoor", 4.1, 0, 1, 1, 1, 1, 1);
		case 57: ApplyAnimationEx(playerid, "PED", "CAR_rolldoorLO", 4.1, 0, 1, 1, 1, 1, 1);
		case 58: ApplyAnimationEx(playerid, "PED", "CAR_rollout_LHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 59: ApplyAnimationEx(playerid, "PED", "CAR_rollout_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 60: ApplyAnimationEx(playerid, "PED", "CAR_shuffle_RHS", 4.1, 0, 1, 1, 1, 1, 1);
		case 61: ApplyAnimationEx(playerid, "PED", "CAR_sit", 4.1, 0, 1, 1, 1, 1, 1);
		case 62: ApplyAnimationEx(playerid, "PED", "CAR_sitp", 4.1, 0, 1, 1, 1, 1, 1);
		case 63: ApplyAnimationEx(playerid, "PED", "CAR_sitpLO", 4.1, 0, 1, 1, 1, 1, 1);
		case 64: ApplyAnimationEx(playerid, "PED", "CAR_sit_pro", 4.1, 0, 1, 1, 1, 1, 1);
		case 65: ApplyAnimationEx(playerid, "PED", "CAR_sit_weak", 4.1, 0, 1, 1, 1, 1, 1);
		case 66: ApplyAnimationEx(playerid, "PED", "CAR_tune_radio", 4.1, 0, 1, 1, 1, 1, 1);
		case 67: ApplyAnimationEx(playerid, "PED", "CLIMB_idle", 4.1, 0, 1, 1, 1, 1, 1);
		case 68: ApplyAnimationEx(playerid, "PED", "CLIMB_jump", 4.1, 0, 1, 1, 1, 1, 1);
		case 69: ApplyAnimationEx(playerid, "PED", "CLIMB_jump2fall", 4.1, 0, 1, 1, 1, 1, 1);
		case 70: ApplyAnimationEx(playerid, "PED", "CLIMB_jump_B", 4.1, 0, 1, 1, 1, 1, 1);
		case 71: ApplyAnimationEx(playerid, "PED", "CLIMB_Pull", 4.1, 0, 1, 1, 1, 1, 1);
		case 72: ApplyAnimationEx(playerid, "PED", "CLIMB_Stand", 4.1, 0, 1, 1, 1, 1, 1);
		case 73: ApplyAnimationEx(playerid, "PED", "CLIMB_Stand_finish", 4.1, 0, 1, 1, 1, 1, 1);
		case 74: ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 1, 1, 1, 1, 1);
		case 75: ApplyAnimationEx(playerid, "PED", "Crouch_Roll_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 76: ApplyAnimationEx(playerid, "PED", "Crouch_Roll_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 77: ApplyAnimationEx(playerid, "PED", "DAM_armL_frmBK", 4.1, 0, 1, 1, 1, 1, 1);
		case 78: ApplyAnimationEx(playerid, "PED", "DAM_armL_frmFT", 4.1, 0, 1, 1, 1, 1, 1);
		case 79: ApplyAnimationEx(playerid, "PED", "DAM_armL_frmLT", 4.1, 0, 1, 1, 1, 1, 1);
		case 80: ApplyAnimationEx(playerid, "PED", "DAM_armR_frmBK", 4.1, 0, 1, 1, 1, 1, 1);
		case 81: ApplyAnimationEx(playerid, "PED", "DAM_armR_frmFT", 4.1, 0, 1, 1, 1, 1, 1);
		case 82: ApplyAnimationEx(playerid, "PED", "DAM_armR_frmRT", 4.1, 0, 1, 1, 1, 1, 1);
		case 83: ApplyAnimationEx(playerid, "PED", "DAM_LegL_frmBK", 4.1, 0, 1, 1, 1, 1, 1);
		case 84: ApplyAnimationEx(playerid, "PED", "DAM_LegL_frmFT", 4.1, 0, 1, 1, 1, 1, 1);
		case 85: ApplyAnimationEx(playerid, "PED", "DAM_LegL_frmLT", 4.1, 0, 1, 1, 1, 1, 1);
		case 86: ApplyAnimationEx(playerid, "PED", "DAM_LegR_frmBK", 4.1, 0, 1, 1, 1, 1, 1);
		case 87: ApplyAnimationEx(playerid, "PED", "DAM_LegR_frmFT", 4.1, 0, 1, 1, 1, 1, 1);
		case 88: ApplyAnimationEx(playerid, "PED", "DAM_LegR_frmRT", 4.1, 0, 1, 1, 1, 1, 1);
		case 89: ApplyAnimationEx(playerid, "PED", "DAM_stomach_frmBK", 4.1, 0, 1, 1, 1, 1, 1);
		case 90: ApplyAnimationEx(playerid, "PED", "DAM_stomach_frmFT", 4.1, 0, 1, 1, 1, 1, 1);
		case 91: ApplyAnimationEx(playerid, "PED", "DAM_stomach_frmLT", 4.1, 0, 1, 1, 1, 1, 1);
		case 92: ApplyAnimationEx(playerid, "PED", "DAM_stomach_frmRT", 4.1, 0, 1, 1, 1, 1, 1);
		case 93: ApplyAnimationEx(playerid, "PED", "DOOR_LHinge_O", 4.1, 0, 1, 1, 1, 1, 1);
		case 94: ApplyAnimationEx(playerid, "PED", "DOOR_RHinge_O", 4.1, 0, 1, 1, 1, 1, 1);
		case 95: ApplyAnimationEx(playerid, "PED", "DrivebyL_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 96: ApplyAnimationEx(playerid, "PED", "DrivebyL_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 97: ApplyAnimationEx(playerid, "PED", "Driveby_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 98: ApplyAnimationEx(playerid, "PED", "Driveby_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 99: ApplyAnimationEx(playerid, "PED", "DRIVE_BOAT", 4.1, 0, 1, 1, 1, 1, 1);
		case 100: ApplyAnimationEx(playerid, "PED", "DRIVE_BOAT_back", 4.1, 0, 1, 1, 1, 1, 1);
		case 101: ApplyAnimationEx(playerid, "PED", "DRIVE_BOAT_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 102: ApplyAnimationEx(playerid, "PED", "DRIVE_BOAT_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 103: ApplyAnimationEx(playerid, "PED", "Drive_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 104: ApplyAnimationEx(playerid, "PED", "Drive_LO_l", 4.1, 0, 1, 1, 1, 1, 1);
		case 105: ApplyAnimationEx(playerid, "PED", "Drive_LO_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 106: ApplyAnimationEx(playerid, "PED", "Drive_L_pro", 4.1, 0, 1, 1, 1, 1, 1);
		case 107: ApplyAnimationEx(playerid, "PED", "Drive_L_pro_slow", 4.1, 0, 1, 1, 1, 1, 1);
		case 108: ApplyAnimationEx(playerid, "PED", "Drive_L_slow", 4.1, 0, 1, 1, 1, 1, 1);
		case 109: ApplyAnimationEx(playerid, "PED", "Drive_L_weak", 4.1, 0, 1, 1, 1, 1, 1);
		case 110: ApplyAnimationEx(playerid, "PED", "Drive_L_weak_slow", 4.1, 0, 1, 1, 1, 1, 1);
		case 111: ApplyAnimationEx(playerid, "PED", "Drive_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 112: ApplyAnimationEx(playerid, "PED", "Drive_R_pro", 4.1, 0, 1, 1, 1, 1, 1);
		case 113: ApplyAnimationEx(playerid, "PED", "Drive_R_pro_slow", 4.1, 0, 1, 1, 1, 1, 1);
		case 114: ApplyAnimationEx(playerid, "PED", "Drive_R_slow", 4.1, 0, 1, 1, 1, 1, 1);
		case 115: ApplyAnimationEx(playerid, "PED", "Drive_R_weak", 4.1, 0, 1, 1, 1, 1, 1);
		case 116: ApplyAnimationEx(playerid, "PED", "Drive_R_weak_slow", 4.1, 0, 1, 1, 1, 1, 1);
		case 117: ApplyAnimationEx(playerid, "PED", "Drive_truck", 4.1, 0, 1, 1, 1, 1, 1);
		case 118: ApplyAnimationEx(playerid, "PED", "DRIVE_truck_back", 4.1, 0, 1, 1, 1, 1, 1);
		case 119: ApplyAnimationEx(playerid, "PED", "DRIVE_truck_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 120: ApplyAnimationEx(playerid, "PED", "DRIVE_truck_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 121: ApplyAnimationEx(playerid, "PED", "Drown", 4.1, 0, 1, 1, 1, 1, 1);
		case 122: ApplyAnimationEx(playerid, "PED", "DUCK_cower", 4.1, 0, 1, 1, 1, 1, 1);
		case 123: ApplyAnimationEx(playerid, "PED", "endchat_01", 4.1, 0, 1, 1, 1, 1, 1);
		case 124: ApplyAnimationEx(playerid, "PED", "endchat_02", 4.1, 0, 1, 1, 1, 1, 1);
		case 125: ApplyAnimationEx(playerid, "PED", "endchat_03", 4.1, 0, 1, 1, 1, 1, 1);
		case 126: ApplyAnimationEx(playerid, "PED", "EV_dive", 4.1, 0, 1, 1, 1, 1, 1);
		case 127: ApplyAnimationEx(playerid, "PED", "EV_step", 4.1, 0, 1, 1, 1, 1, 1);
		case 128: ApplyAnimationEx(playerid, "PED", "facanger", 4.1, 0, 1, 1, 1, 1, 1);
		case 129: ApplyAnimationEx(playerid, "PED", "facanger", 4.1, 0, 1, 1, 1, 1, 1);
		case 130: ApplyAnimationEx(playerid, "PED", "facgum", 4.1, 0, 1, 1, 1, 1, 1);
		case 131: ApplyAnimationEx(playerid, "PED", "facsurp", 4.1, 0, 1, 1, 1, 1, 1);
		case 132: ApplyAnimationEx(playerid, "PED", "facsurpm", 4.1, 0, 1, 1, 1, 1, 1);
		case 133: ApplyAnimationEx(playerid, "PED", "factalk", 4.1, 0, 1, 1, 1, 1, 1);
		case 134: ApplyAnimationEx(playerid, "PED", "facurios", 4.1, 0, 1, 1, 1, 1, 1);
		case 135: ApplyAnimationEx(playerid, "PED", "FALL_back", 4.1, 0, 1, 1, 1, 1, 1);
		case 136: ApplyAnimationEx(playerid, "PED", "FALL_collapse", 4.1, 0, 1, 1, 1, 1, 1);
		case 137: ApplyAnimationEx(playerid, "PED", "FALL_fall", 4.1, 0, 1, 1, 1, 1, 1);
		case 138: ApplyAnimationEx(playerid, "PED", "FALL_front", 4.1, 0, 1, 1, 1, 1, 1);
		case 139: ApplyAnimationEx(playerid, "PED", "FALL_glide", 4.1, 0, 1, 1, 1, 1, 1);
		case 140: ApplyAnimationEx(playerid, "PED", "FALL_land", 4.1, 0, 1, 1, 1, 1, 1);
		case 141: ApplyAnimationEx(playerid, "PED", "FALL_skyDive", 4.1, 0, 1, 1, 1, 1, 1);
		case 142: ApplyAnimationEx(playerid, "PED", "Fight2Idle", 4.1, 0, 1, 1, 1, 1, 1);
		case 143: ApplyAnimationEx(playerid, "PED", "FightA_1", 4.1, 0, 1, 1, 1, 1, 1);
		case 144: ApplyAnimationEx(playerid, "PED", "FightA_2", 4.1, 0, 1, 1, 1, 1, 1);
		case 145: ApplyAnimationEx(playerid, "PED", "FightA_3", 4.1, 0, 1, 1, 1, 1, 1);
		case 146: ApplyAnimationEx(playerid, "PED", "FightA_block", 4.1, 0, 1, 1, 1, 1, 1);
		case 147: ApplyAnimationEx(playerid, "PED", "FightA_G", 4.1, 0, 1, 1, 1, 1, 1);
		case 148: ApplyAnimationEx(playerid, "PED", "FightA_M", 4.1, 0, 1, 1, 1, 1, 1);
		case 149: ApplyAnimationEx(playerid, "PED", "FIGHTIDLE", 4.1, 0, 1, 1, 1, 1, 1);
		case 150: ApplyAnimationEx(playerid, "PED", "FightShB", 4.1, 0, 1, 1, 1, 1, 1);
		case 151: ApplyAnimationEx(playerid, "PED", "FightShF", 4.1, 0, 1, 1, 1, 1, 1);
		case 152: ApplyAnimationEx(playerid, "PED", "FightSh_BWD", 4.1, 0, 1, 1, 1, 1, 1);
		case 153: ApplyAnimationEx(playerid, "PED", "FightSh_FWD", 4.1, 0, 1, 1, 1, 1, 1);
		case 154: ApplyAnimationEx(playerid, "PED", "FightSh_Left", 4.1, 0, 1, 1, 1, 1, 1);
		case 155: ApplyAnimationEx(playerid, "PED", "FightSh_Right", 4.1, 0, 1, 1, 1, 1, 1);
		case 156: ApplyAnimationEx(playerid, "PED", "flee_lkaround_01", 4.1, 0, 1, 1, 1, 1, 1);
		case 157: ApplyAnimationEx(playerid, "PED", "FLOOR_hit", 4.1, 0, 1, 1, 1, 1, 1);
		case 158: ApplyAnimationEx(playerid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 1, 1);
		case 159: ApplyAnimationEx(playerid, "PED", "fucku", 4.1, 0, 1, 1, 1, 1, 1);
		case 160: ApplyAnimationEx(playerid, "PED", "gang_gunstand", 4.1, 0, 1, 1, 1, 1, 1);
		case 161: ApplyAnimationEx(playerid, "PED", "gas_cwr", 4.1, 0, 1, 1, 1, 1, 1);
		case 162: ApplyAnimationEx(playerid, "PED", "getup", 4.1, 0, 1, 1, 1, 1, 1);
		case 163: ApplyAnimationEx(playerid, "PED", "getup_front", 4.1, 0, 1, 1, 1, 1, 1);
		case 164: ApplyAnimationEx(playerid, "PED", "gum_eat", 4.1, 0, 1, 1, 1, 1, 1);
		case 165: ApplyAnimationEx(playerid, "PED", "GunCrouchBwd", 4.1, 0, 1, 1, 1, 1, 1);
		case 166: ApplyAnimationEx(playerid, "PED", "GunCrouchFwd", 4.1, 0, 1, 1, 1, 1, 1);
		case 167: ApplyAnimationEx(playerid, "PED", "GunMove_BWD", 4.1, 0, 1, 1, 1, 1, 1);
		case 168: ApplyAnimationEx(playerid, "PED", "GunMove_FWD", 4.1, 0, 1, 1, 1, 1, 1);
		case 169: ApplyAnimationEx(playerid, "PED", "GunMove_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 170: ApplyAnimationEx(playerid, "PED", "GunMove_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 171: ApplyAnimationEx(playerid, "PED", "Gun_2_IDLE", 4.1, 0, 1, 1, 1, 1, 1);
		case 172: ApplyAnimationEx(playerid, "PED", "GUN_BUTT", 4.1, 0, 1, 1, 1, 1, 1);
		case 173: ApplyAnimationEx(playerid, "PED", "GUN_BUTT_crouch", 4.1, 0, 1, 1, 1, 1, 1);
		case 174: ApplyAnimationEx(playerid, "PED", "Gun_stand", 4.1, 0, 1, 1, 1, 1, 1);
		case 175: ApplyAnimationEx(playerid, "PED", "handscower", 4.1, 0, 1, 1, 1, 1, 1);
		case 176: ApplyAnimationEx(playerid, "PED", "handsup", 4.1, 0, 1, 1, 1, 1, 1);
		case 177: ApplyAnimationEx(playerid, "PED", "HitA_1", 4.1, 0, 1, 1, 1, 1, 1);
		case 178: ApplyAnimationEx(playerid, "PED", "HitA_2", 4.1, 0, 1, 1, 1, 1, 1);
		case 179: ApplyAnimationEx(playerid, "PED", "HitA_3", 4.1, 0, 1, 1, 1, 1, 1);
		case 180: ApplyAnimationEx(playerid, "PED", "HIT_back", 4.1, 0, 1, 1, 1, 1, 1);
		case 181: ApplyAnimationEx(playerid, "PED", "HIT_behind", 4.1, 0, 1, 1, 1, 1, 1);
		case 182: ApplyAnimationEx(playerid, "PED", "HIT_front", 4.1, 0, 1, 1, 1, 1, 1);
		case 183: ApplyAnimationEx(playerid, "PED", "HIT_GUN_BUTT", 4.1, 0, 1, 1, 1, 1, 1);
		case 184: ApplyAnimationEx(playerid, "PED", "HIT_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 185: ApplyAnimationEx(playerid, "PED", "HIT_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 186: ApplyAnimationEx(playerid, "PED", "HIT_walk", 4.1, 0, 1, 1, 1, 1, 1);
		case 187: ApplyAnimationEx(playerid, "PED", "HIT_wall", 4.1, 0, 1, 1, 1, 1, 1);
		case 188: ApplyAnimationEx(playerid, "PED", "Idlestance_fat", 4.1, 0, 1, 1, 1, 1, 1);
		case 189: ApplyAnimationEx(playerid, "PED", "idlestance_old", 4.1, 0, 1, 1, 1, 1, 1);
		case 190: ApplyAnimationEx(playerid, "PED", "IDLE_armed", 4.1, 0, 1, 1, 1, 1, 1);
		case 191: ApplyAnimationEx(playerid, "PED", "IDLE_chat", 4.1, 0, 1, 1, 1, 1, 1);
		case 192: ApplyAnimationEx(playerid, "PED", "IDLE_csaw", 4.1, 0, 1, 1, 1, 1, 1);
		case 193: ApplyAnimationEx(playerid, "PED", "Idle_Gang1", 4.1, 0, 1, 1, 1, 1, 1);
		case 194: ApplyAnimationEx(playerid, "PED", "IDLE_HBHB", 4.1, 0, 1, 1, 1, 1, 1);
		case 195: ApplyAnimationEx(playerid, "PED", "IDLE_ROCKET", 4.1, 0, 1, 1, 1, 1, 1);
		case 196: ApplyAnimationEx(playerid, "PED", "IDLE_stance", 4.1, 0, 1, 1, 1, 1, 1);
		case 197: ApplyAnimationEx(playerid, "PED", "IDLE_taxi", 4.1, 0, 1, 1, 1, 1, 1);
		case 198: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 0, 1, 1, 1, 1, 1);
		case 199: ApplyAnimationEx(playerid, "PED", "Jetpack_Idle", 4.1, 0, 1, 1, 1, 1, 1);
		case 200: ApplyAnimationEx(playerid, "PED", "JOG_femaleA", 4.1, 0, 1, 1, 1, 1, 1);
		case 201: ApplyAnimationEx(playerid, "PED", "JOG_maleA", 4.1, 0, 1, 1, 1, 1, 1);
		case 202: ApplyAnimationEx(playerid, "PED", "JUMP_glide", 4.1, 0, 1, 1, 1, 1, 1);
		case 203: ApplyAnimationEx(playerid, "PED", "JUMP_land", 4.1, 0, 1, 1, 1, 1, 1);
		case 204: ApplyAnimationEx(playerid, "PED", "JUMP_launch", 4.1, 0, 1, 1, 1, 1, 1);
		case 205: ApplyAnimationEx(playerid, "PED", "JUMP_launch_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 206: ApplyAnimationEx(playerid, "PED", "KART_drive", 4.1, 0, 1, 1, 1, 1, 1);
		case 207: ApplyAnimationEx(playerid, "PED", "KART_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 208: ApplyAnimationEx(playerid, "PED", "KART_LB", 4.1, 0, 1, 1, 1, 1, 1);
		case 209: ApplyAnimationEx(playerid, "PED", "KART_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 210: ApplyAnimationEx(playerid, "PED", "KD_left", 4.1, 0, 1, 1, 1, 1, 1);
		case 211: ApplyAnimationEx(playerid, "PED", "KD_right", 4.1, 0, 1, 1, 1, 1, 1);
		case 212: ApplyAnimationEx(playerid, "PED", "KO_shot_face", 4.1, 0, 1, 1, 1, 1, 1);
		case 213: ApplyAnimationEx(playerid, "PED", "KO_shot_front", 4.1, 0, 1, 1, 1, 1, 1);
		case 214: ApplyAnimationEx(playerid, "PED", "KO_shot_stom", 4.1, 0, 1, 1, 1, 1, 1);
		case 215: ApplyAnimationEx(playerid, "PED", "KO_skid_back", 4.1, 0, 1, 1, 1, 1, 1);
		case 216: ApplyAnimationEx(playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 1, 1, 1);
		case 217: ApplyAnimationEx(playerid, "PED", "KO_spin_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 218: ApplyAnimationEx(playerid, "PED", "KO_spin_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 219: ApplyAnimationEx(playerid, "PED", "pass_Smoke_in_car", 4.1, 0, 1, 1, 1, 1, 1);
		case 220: ApplyAnimationEx(playerid, "PED", "phone_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 221: ApplyAnimationEx(playerid, "PED", "phone_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 222: ApplyAnimationEx(playerid, "PED", "phone_talk", 4.1, 0, 1, 1, 1, 1, 1);
		case 223: ApplyAnimationEx(playerid, "PED", "Player_Sneak", 4.1, 0, 1, 1, 1, 1, 1);
		case 224: ApplyAnimationEx(playerid, "PED", "Player_Sneak_walkstart", 4.1, 0, 1, 1, 1, 1, 1);
		case 225: ApplyAnimationEx(playerid, "PED", "roadcross", 4.1, 0, 1, 1, 1, 1, 1);
		case 226: ApplyAnimationEx(playerid, "PED", "roadcross_female", 4.1, 0, 1, 1, 1, 1, 1);
		case 227: ApplyAnimationEx(playerid, "PED", "roadcross_gang", 4.1, 0, 1, 1, 1, 1, 1);
		case 228: ApplyAnimationEx(playerid, "PED", "roadcross_old", 4.1, 0, 1, 1, 1, 1, 1);
		case 229: ApplyAnimationEx(playerid, "PED", "run_1armed", 4.1, 0, 1, 1, 1, 1, 1);
		case 230: ApplyAnimationEx(playerid, "PED", "run_armed", 4.1, 0, 1, 1, 1, 1, 1);
		case 231: ApplyAnimationEx(playerid, "PED", "run_civi", 4.1, 0, 1, 1, 1, 1, 1);
		case 232: ApplyAnimationEx(playerid, "PED", "run_csaw", 4.1, 0, 1, 1, 1, 1, 1);
		case 233: ApplyAnimationEx(playerid, "PED", "run_fat", 4.1, 0, 1, 1, 1, 1, 1);
		case 234: ApplyAnimationEx(playerid, "PED", "run_fatold", 4.1, 0, 1, 1, 1, 1, 1);
		case 235: ApplyAnimationEx(playerid, "PED", "run_gang1", 4.1, 0, 1, 1, 1, 1, 1);
		case 236: ApplyAnimationEx(playerid, "PED", "run_left", 4.1, 0, 1, 1, 1, 1, 1);
		case 237: ApplyAnimationEx(playerid, "PED", "run_old", 4.1, 0, 1, 1, 1, 1, 1);
		case 238: ApplyAnimationEx(playerid, "PED", "run_player", 4.1, 0, 1, 1, 1, 1, 1);
		case 239: ApplyAnimationEx(playerid, "PED", "run_right", 4.1, 0, 1, 1, 1, 1, 1);
		case 240: ApplyAnimationEx(playerid, "PED", "run_rocket", 4.1, 0, 1, 1, 1, 1, 1);
		case 241: ApplyAnimationEx(playerid, "PED", "Run_stop", 4.1, 0, 1, 1, 1, 1, 1);
		case 242: ApplyAnimationEx(playerid, "PED", "Run_stopR", 4.1, 0, 1, 1, 1, 1, 1);
		case 243: ApplyAnimationEx(playerid, "PED", "Run_Wuzi", 4.1, 0, 1, 1, 1, 1, 1);
		case 244: ApplyAnimationEx(playerid, "PED", "SEAT_down", 4.1, 0, 1, 1, 1, 1, 1);
		case 245: ApplyAnimationEx(playerid, "PED", "SEAT_idle", 4.1, 0, 1, 1, 1, 1, 1);
		case 246: ApplyAnimationEx(playerid, "PED", "SEAT_up", 4.1, 0, 1, 1, 1, 1, 1);
		case 247: ApplyAnimationEx(playerid, "PED", "SHOT_leftP", 4.1, 0, 1, 1, 1, 1, 1);
		case 248: ApplyAnimationEx(playerid, "PED", "SHOT_partial", 4.1, 0, 1, 1, 1, 1, 1);
		case 249: ApplyAnimationEx(playerid, "PED", "SHOT_partial_B", 4.1, 0, 1, 1, 1, 1, 1);
		case 250: ApplyAnimationEx(playerid, "PED", "SHOT_rightP", 4.1, 0, 1, 1, 1, 1, 1);
		case 251: ApplyAnimationEx(playerid, "PED", "Shove_Partial", 4.1, 0, 1, 1, 1, 1, 1);
		case 252: ApplyAnimationEx(playerid, "PED", "Smoke_in_car", 4.1, 0, 1, 1, 1, 1, 1);
		case 253: ApplyAnimationEx(playerid, "PED", "sprint_civi", 4.1, 0, 1, 1, 1, 1, 1);
		case 254: ApplyAnimationEx(playerid, "PED", "sprint_panic", 4.1, 0, 1, 1, 1, 1, 1);
		case 255: ApplyAnimationEx(playerid, "PED", "Sprint_Wuzi", 4.1, 0, 1, 1, 1, 1, 1);
		case 256: ApplyAnimationEx(playerid, "PED", "swat_run", 4.1, 0, 1, 1, 1, 1, 1);
		case 257: ApplyAnimationEx(playerid, "PED", "Swim_Tread", 4.1, 0, 1, 1, 1, 1, 1);
		case 258: ApplyAnimationEx(playerid, "PED", "Tap_hand", 4.1, 0, 1, 1, 1, 1, 1);
		case 259: ApplyAnimationEx(playerid, "PED", "Tap_handP", 4.1, 0, 1, 1, 1, 1, 1);
		case 260: ApplyAnimationEx(playerid, "PED", "turn_180", 4.1, 0, 1, 1, 1, 1, 1);
		case 261: ApplyAnimationEx(playerid, "PED", "Turn_L", 4.1, 0, 1, 1, 1, 1, 1);
		case 262: ApplyAnimationEx(playerid, "PED", "Turn_R", 4.1, 0, 1, 1, 1, 1, 1);
		case 263: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 0, 1, 1, 1, 1, 1);
		case 264: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 0, 1, 1, 1, 1, 1);
		case 265: ApplyAnimationEx(playerid, "PED", "WALK_csaw", 4.1, 0, 1, 1, 1, 1, 1);
		case 266: ApplyAnimationEx(playerid, "PED", "Walk_DoorPartial", 4.1, 0, 1, 1, 1, 1, 1);
		case 267: ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 0, 1, 1, 1, 1, 1);
		case 268: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 0, 1, 1, 1, 1, 1);
		case 269: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 0, 1, 1, 1, 1, 1);
		case 270: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 0, 1, 1, 1, 1, 1);
		case 271: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 0, 1, 1, 1, 1, 1);
		case 272: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 0, 1, 1, 1, 1, 1);
		case 273: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 0, 1, 1, 1, 1, 1);
		case 274: ApplyAnimationEx(playerid, "PED", "WALK_rocket", 4.1, 0, 1, 1, 1, 1, 1);
		case 275: ApplyAnimationEx(playerid, "PED", "WALK_shuffle", 4.1, 0, 1, 1, 1, 1, 1);
		case 276: ApplyAnimationEx(playerid, "PED", "WALK_start", 4.1, 0, 1, 1, 1, 1, 1);
		case 277: ApplyAnimationEx(playerid, "PED", "WALK_start_armed", 4.1, 0, 1, 1, 1, 1, 1);
		case 278: ApplyAnimationEx(playerid, "PED", "WALK_start_csaw", 4.1, 0, 1, 1, 1, 1, 1);
		case 279: ApplyAnimationEx(playerid, "PED", "WALK_start_rocket", 4.1, 0, 1, 1, 1, 1, 1);
		case 280: ApplyAnimationEx(playerid, "PED", "Walk_Wuzi", 4.1, 0, 1, 1, 1, 1, 1);
		case 281: ApplyAnimationEx(playerid, "PED", "WEAPON_crouch", 4.1, 0, 1, 1, 1, 1, 1);
		case 282: ApplyAnimationEx(playerid, "PED", "woman_idlestance", 4.1, 0, 1, 1, 1, 1, 1);
		case 283: ApplyAnimationEx(playerid, "PED", "woman_run", 4.1, 0, 1, 1, 1, 1, 1);
		case 284: ApplyAnimationEx(playerid, "PED", "WOMAN_runbusy", 4.1, 0, 1, 1, 1, 1, 1);
		case 285: ApplyAnimationEx(playerid, "PED", "WOMAN_runfatold", 4.1, 0, 1, 1, 1, 1, 1);
		case 286: ApplyAnimationEx(playerid, "PED", "woman_runpanic", 4.1, 0, 1, 1, 1, 1, 1);
		case 287: ApplyAnimationEx(playerid, "PED", "WOMAN_runsexy", 4.1, 0, 1, 1, 1, 1, 1);
		case 288: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 0, 1, 1, 1, 1, 1);
		case 289: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 0, 1, 1, 1, 1, 1);
		case 290: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 0, 1, 1, 1, 1, 1);
		case 291: ApplyAnimationEx(playerid, "PED", "WOMAN_walkold", 4.1, 0, 1, 1, 1, 1, 1);
		case 292: ApplyAnimationEx(playerid, "PED", "WOMAN_walkpro", 4.1, 0, 1, 1, 1, 1, 1);
		case 293: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 0, 1, 1, 1, 1, 1);
		case 294: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 0, 1, 1, 1, 1, 1);
		case 295: ApplyAnimationEx(playerid, "PED", "XPRESSscratch", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}


CMD:tapinha(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "BASEBALL", "Bat_M", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:lavagem(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:exercicio(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/exercicio [1-7]");

	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_A", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_B", 4.1, 0, 0, 0, 1, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:bomba(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:transportar(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/transportar [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "CARRY", "putdwn05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:dormir(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/dormir [1-2]");

	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}

CMD:pular(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}

CMD:dancando(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/dancando [1-10]");

	if (type < 1 || type > 10)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
	    case 9: ApplyAnimationEx(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
	    case 10: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:comendo(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/comendo [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:vomito(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:chat(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/chat [1-7]");

	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "PED", "IDLE_CHAT", 4.1, 0, 0, 1, 1, 0, 1);
	}
	return 1;
}

CMD:oculos(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:pancada(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:beijo(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/beijo [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:faca(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/faca [1-8]");

	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "KNIFE", "knife_1", 4.1, 0, 1, 1, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "KNIFE", "knife_2", 4.1, 0, 1, 1, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "KNIFE", "knife_4", 4.1, 0, 1, 1, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "KNIFE", "WEAPON_knifeidle", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Player", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Ped_Damage", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:arranhar(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/arranhar [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
    	case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:ponto(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/ponto [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
    	case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:animo(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/animo [1-8]");

	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:riot(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/riot [1-7]");

	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "RIOT", "RIOG_challenge", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "RIOT", "RIOT_FUKU", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "RIOT", "RIOT_PUNCHES", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimationEx(playerid, "RIOT", "RIOT_shout", 4.1, 1, 0, 0, 0, 0, 1);

	}
	return 1;
}

CMD:revolta(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/revolta [1-7]");

	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "RIOT", "RIOG_challenge", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "RIOT", "RIOT_FUKU", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "RIOT", "RIOT_PUNCHES", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimationEx(playerid, "RIOT", "RIOT_shout", 4.1, 1, 0, 0, 0, 0, 1);

	}
	return 1;
}

CMD:camera(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/camera [1-14]");

	if (type < 1 || type > 14)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "CAMERA", "camcrch_cmon", 4.1, 1, 0, 0, 0, 0, 1);
        case 2: ApplyAnimationEx(playerid, "CAMERA", "camcrch_idleloop", 4.1, 1, 0, 0, 0, 0, 1);
        case 3: ApplyAnimationEx(playerid, "CAMERA", "camcrch_stay", 4.1, 1, 0, 0, 0, 0, 1);
        case 4: ApplyAnimationEx(playerid, "CAMERA", "camcrch_to_camstnd", 4.1, 1, 0, 0, 0, 0, 1);
        case 5: ApplyAnimationEx(playerid, "CAMERA", "camstnd_cmon", 4.1, 1, 0, 0, 0, 0, 1);
        case 6: ApplyAnimationEx(playerid, "CAMERA", "camstnd_idleloop", 4.1, 1, 0, 0, 0, 0, 1);
        case 7: ApplyAnimationEx(playerid, "CAMERA", "camstnd_lkabt", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 1, 0, 0, 0, 0, 1);
        case 9: ApplyAnimationEx(playerid, "CAMERA", "piccrch_in", 4.1, 1, 0, 0, 0, 0, 1);
        case 10: ApplyAnimationEx(playerid, "CAMERA", "piccrch_out", 4.1, 1, 0, 0, 0, 0, 1);
        case 11: ApplyAnimationEx(playerid, "CAMERA", "piccrch_take", 4.1, 1, 0, 0, 0, 0, 1);
        case 12: ApplyAnimationEx(playerid, "CAMERA", "picstnd_in", 4.1, 1, 0, 0, 0, 0, 1);
        case 13: ApplyAnimationEx(playerid, "CAMERA", "picstnd_out", 4.1, 1, 0, 0, 0, 0, 1);
        case 14: ApplyAnimationEx(playerid, "CAMERA", "picstnd_take", 4.1, 1, 0, 0, 0, 0, 1);

	}
	return 1;
}

CMD:onda(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/onda [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:fumar(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/fumar [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:taichi(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:wank(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/wank [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:agachar(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}

CMD:skate(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/skate [1-2]");

	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:bebado(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:rap(playerid, params[])
{
	new type;
	if(sscanf(params,"d",type)) return SendUsageMessage(playerid, "/rap [1-3]");
    switch(type)
    {
		case 1: ApplyAnimationEx(playerid,"LOWRIDER","RAP_A_Loop",4.1, 1, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid,"LOWRIDER","RAP_B_Loop", 4.1, 1, 0, 0, 0, 0);
		case 3: ApplyAnimationEx(playerid,"LOWRIDER","RAP_C_Loop",4.1, 1, 0, 0, 0, 0);
		default: SendUsageMessage(playerid, "/rap [1-3]");
    }
    return 1;
}

CMD:empunhar(playerid, params[])
{
    ApplyAnimationEx(playerid, "PED", "IDLE_armed", 4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:assustado(playerid, params[])
{
    ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:caircostas(playerid, params[])
{
    ApplyAnimationEx(playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}


CMD:bracojanela(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !IsDoorVehicle(vehicleid))
		return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimation(playerid, "CAR", "Sit_relaxed", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:taxid(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "MISC","hiker_pose", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:taxie(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "MISC","hiker_pose_l", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:fucku(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	ApplyAnimationEx(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}

CMD:andar(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Você não pode utilizar animação agora.");

	if (sscanf(params, "d", type))
	    return SendUsageMessage(playerid, "/andar [1-16]");

	if (type < 1 || type > 17)
	    return SendErrorMessage(playerid, "Opção invalida.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "FAT", "FatWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 2: ApplyAnimationEx(playerid, "MUSCULAR", "MuscleWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
	    case 9: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
	    case 10: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
	    case 11: ApplyAnimationEx(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}

alias:stopanim("stop", "pararanim", "pararanimacao", "pa")
CMD:stopanim(playerid)
{
    if (IsPlayerSpawned(playerid) && s_pLoopingAnim{playerid} && AnimationCheck(playerid))
    {
        ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
        s_pLoopingAnim{playerid} = false;
    }
    else
    {
        SendErrorMessage(playerid, "Você não pode usar este comando agora.");
    }
    return true;
}