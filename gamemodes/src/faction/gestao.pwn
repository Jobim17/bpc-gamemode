/*
	  .oooooo.                           .
	 d8P'  `Y8b                        .o8
	888            .ooooo.   .oooo.o .o888oo  .oooo.    .ooooo.
	888           d88' `88b d88(  "8   888   `P  )88b  d88' `88b
	888     ooooo 888ooo888 `"Y88b.    888    .oP"888  888   888
	`88.    .88'  888    .o o.  )88b   888 . d8(  888  888   888
	 `Y8bood8P'   `Y8bod8P' 8""888P'   "888" `Y888""8o `Y8bod8P'

*/

// Listing
#define MAX_FACTION_MOD 5
#define MIN_FACTION_MOD 0

#define FACTION_MOD_VIEW_LOG 		1
#define FACTION_MOD_INVITE  		2
#define FACTION_MOD_RESPAWN  		3
#define FACTION_MOD_EDIT_MOTD 		3
#define FACTION_MOD_EDIT_RANKS 		4
#define FACTION_MOD_EDIT_INTERACTS	5
#define FACTION_MOD_EDIT_MODS 		5

#define MAX_MEMBER_BY_PAGE 20
static s_pMemberPage[MAX_PLAYERS] = {0, ...};
static s_pMemberSearch[MAX_PLAYERS][MAX_PLAYER_NAME];

static s_pMemberEdit[MAX_PLAYERS][MAX_PLAYER_NAME];
static s_pMemberEditMod[MAX_PLAYERS];
static s_pMemberEditRank[MAX_PLAYERS][32];

// Dialogs
Dialog:DIALOG_FACTION_MANAGE(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (!response || id == -1)
		return false;

	// INFORMA��ES > MOTD
	if (!strcmp(inputtext, "MOTD", true))
	{
		if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_EDIT_MOTD)
			return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_EDIT_MOTD" na fac��o.");

		Dialog_Show(playerid, DIALOG_FAC_EDIT_MOTD, DIALOG_STYLE_INPUT, va_return("Gerenciar: %s", FactionData[id][e_FACTION_NAME]), "{FFFFFF}MOTD atual: {BBBBBB}%s\n\n{FFFFFF}Abaixo, digite a nova MOTD, deixe em branco para remover:", "Editar", "Voltar", FactionData[id][e_FACTION_MOTD]);
	}

	// CONTROLE DE MEMBROS > Alterar cargo padr�o
	else if (!strcmp(inputtext, "Alterar cargo padr�o", true) || !strcmp(inputtext, "Alterar cargo padrao", true))
	{
		if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_EDIT_RANKS)
			return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_EDIT_RANKS" na fac��o.");

		Dialog_Show(playerid, DIALOG_FAC_EDIT_RANK, DIALOG_STYLE_INPUT, va_return("Gerenciar: %s", FactionData[id][e_FACTION_NAME]), "{FFFFFF}Cargo padr�o atual: {BBBBBB}%s\n\n{FFFFFF}Abaixo, digite o novo cargo padr�o ao entrar na fac��o:", "Editar", "Voltar", FactionData[id][e_FACTION_DEFAULT_RANK]);
	}

	// CONTROLE DE MEMBROS > Lista de membros
	else if (!strcmp(inputtext, "Lista de membros", true))
	{
		FactionManagement_ShowMembers(playerid, 0);
	}

	// CONTROLE DE MEMBROS > Buscar membro pelo nome
	else if (!strcmp(inputtext, "Buscar membro pelo nome", true))
	{
		Dialog_Show(playerid, DIALOG_FAC_FIND_MEMBER, DIALOG_STYLE_INPUT, "Buscar membro", "{FFFFFF}Digite abaixo o nome do membro que deseja buscar:", "Buscar", "Voltar");
	}

	else FactionManagement_ShowMenu(playerid);

	return true;
}

Dialog:DIALOG_FAC_EDIT_MOTD(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_EDIT_MOTD)
		return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_EDIT_MOTD" na fac��o.");

	if (!response)
		return FactionManagement_ShowMenu(playerid);

	if (strlen(inputtext) > 128)
		return SendErrorMessage(playerid, "Voc� inseriu uma MOTD muito extensa.");

	format (FactionData[id][e_FACTION_MOTD], 128, inputtext);
	Faction_Save(id);

	SendClientMessageEx(playerid, COLOR_GREEN, "FACTION: MOTD atualizada com sucesso.");
	FactionManagement_ShowMenu(playerid);
	return true;
}

Dialog:DIALOG_FAC_EDIT_RANK(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_EDIT_RANKS)
		return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_EDIT_RANKS" na fac��o.");

	if (!response)
		return FactionManagement_ShowMenu(playerid);

	if (strlen(inputtext) > 32)
		return SendErrorMessage(playerid, "Voc� inseriu um nome de cargo muito extensa.");

	format (FactionData[id][e_FACTION_DEFAULT_RANK], 32, inputtext);
	Faction_Save(id);

	SendClientMessageEx(playerid, COLOR_GREEN, "FACTION: Cargo padr�o atualizado para \"%s\".", inputtext);
	FactionManagement_ShowMenu(playerid);
	return true;
}

Dialog:DIALOG_FAC_FIND_MEMBER(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (!response)
		return FactionManagement_ShowMenu(playerid);

	if (strlen(inputtext) > MAX_PLAYER_NAME)
		return SendErrorMessage(playerid, "Voc� inseriu um nome muito extensa.");

	FactionManagement_ShowMembers(playerid, 0, inputtext);
	return true;
}

Dialog:DIALOG_FACTION_MEMBERS(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (!response)
		return FactionManagement_ShowMenu(playerid);

	if (!strcmp(inputtext, "<< P�gina anterior") || !strcmp(inputtext, "<< Pagina anterior"))
	{
		FactionManagement_ShowMembers(playerid, s_pMemberPage[playerid] - 1, s_pMemberSearch[playerid]);
		return true;
	}

	if (!strcmp(inputtext, "Pr�xima p�gina >>") || !strcmp(inputtext, "Pr�xima p�gina >>"))
	{
		FactionManagement_ShowMembers(playerid, s_pMemberPage[playerid] + 1, s_pMemberSearch[playerid]);
		return true;
	}

	FactionManagement_ShowMember(playerid, inputtext);
	return true;
}

Dialog:DIALOG_FAC_EDIT_MEMBER(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (!response)
		return FactionManagement_ShowMembers(playerid, s_pMemberPage[playerid], s_pMemberSearch[playerid]);

	if (response && CharacterData[playerid][e_CHARACTER_FACTION_MOD] <= s_pMemberEditMod[playerid] && CharacterData[playerid][e_CHARACTER_FACTION_MOD] < MAX_FACTION_MOD)
	{
		SendErrorMessage(playerid, "Voc� n�o pode executar a��es neste membro.");
		return FactionManagement_ShowMember(playerid, s_pMemberEdit[playerid]);
	}

	// Alterar n�vel de moderador
	if (strfind(inputtext, "Alterar n�vel de moderador", true) != -1 || strfind(inputtext, "Alterar nivel de moderador", true) != -1)
	{
		if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_EDIT_MODS)
			return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_EDIT_MODS" na fac��o.");

		new dialog[128];

		for (new i = MIN_FACTION_MOD; i < MAX_FACTION_MOD; i++)
		{
			if (!i)
				strcat (dialog, "{BBBBBB}Nenhum{FFFFFF}");
			else
				strcat (dialog, va_return("\nModerador %i", i));
		}

		Dialog_Show(playerid, DIALOG_EDIT_MEMBER_MOD, DIALOG_STYLE_LIST, va_return("Gerenciando: %s", s_pMemberEdit[playerid]), dialog, "Selecionar", "Voltar");
		return true;
	}

	// Alterar cargo na fac��o
	else if (strfind(inputtext, "Alterar cargo na fac��o", true) != -1 || strfind(inputtext, "Alterar cargo na faccao", true) != -1)
	{
		if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_EDIT_RANKS)
			return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_EDIT_RANKS" na fac��o.");

		Dialog_Show(playerid, DIALOG_EDIT_MEMBER_RANK, DIALOG_STYLE_INPUT, va_return("Gerenciando: %s", s_pMemberEdit[playerid]), "{FFFFFF}Cargo atual: {BBBBBB}%s{FFFFFF}\n\nPor favor, insira o novo cargo para o membro:", "Selecionar", "Voltar", s_pMemberEditRank[playerid]);
		return true;
	}

	// Expulsar membro da fac��o
	else if (strfind(inputtext, "Expulsar membro da fac��o", true) != -1 || strfind(inputtext, "Expulsar membro da faccao", true) != -1)
	{
		if (CharacterData[playerid][e_CHARACTER_FACTION_MOD] < FACTION_MOD_INVITE)
			return SendErrorMessage(playerid, "Voc� precisa ser n�vel "#FACTION_MOD_INVITE" na fac��o.");

		if (!strcmp(ReturnPlayerName(playerid), s_pMemberEdit[playerid], false))
			return SendErrorMessage(playerid, "Voc� n�o pode se expulsar da fac��o.");

		inline FactionMember_OnUpdated()
		{
			if (cache_affected_rows())
			{
				new character;
				character = GetPlayerId(s_pMemberEdit[playerid]);

				SendFactionMessage(id, COLOR_LIGHTRED, "FACTION: %s %s expulsou %s.", CharacterData[playerid][e_CHARACTER_FACTION_RANK], Character_GetName(playerid), s_pMemberEdit[playerid]);

				if (IsPlayerConnected(character) && IsPlayerLogged(character) && CharacterData[character][e_CHARACTER_ID] > 0)
				{
					CharacterData[character][e_CHARACTER_FACTION] = -1;
					CharacterData[character][e_CHARACTER_FACTION_MOD] = 0;
					format (CharacterData[character][e_CHARACTER_FACTION_RANK], 32, "Membro");

					SendClientMessageEx(character, COLOR_YELLOW, "FACTION: Voc� foi expulso da fac��o por %s.", Character_GetName(playerid));
					Character_Save(character);
				}	

				SendClientMessageEx(playerid, COLOR_GREEN, "Voc� expulsou %s da fac��o.", s_pMemberEdit[playerid]);
				FactionManagement_ShowMember(playerid, s_pMemberEdit[playerid]);
			}
			else
			{
				SendErrorMessage(playerid, "N�o foi poss�vel executar a a��o.");
			}
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline FactionMember_OnUpdated, "UPDATE IGNORE `Personagens` SET `Fac��oMod` = 0, `Fac��oRank` = 'Membro', `Fac��o` = -1 WHERE `Nome` = '%e' AND `Fac��o` = %i LIMIT 1;", s_pMemberEdit[playerid], FactionData[id][e_FACTION_ID]);
		return true;
	}

	return true;
}

Dialog:DIALOG_EDIT_MEMBER_MOD(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (!response)
		return FactionManagement_ShowMember(playerid, s_pMemberEdit[playerid]);

	if (MIN_FACTION_MOD <= listitem < MAX_FACTION_MOD)
	{
		if (!strcmp(s_pMemberEdit[playerid], ReturnPlayerName(playerid), false))
			return SendErrorMessage(playerid, "Voc� n�o pode alterar seu pr�prio n�vel de moderador.");

		inline FactionMember_OnUpdated()
		{
			if (cache_affected_rows())
			{
				new character;
				character = GetPlayerId(s_pMemberEdit[playerid]);

				SendFactionMessage(id, -1, "FACTION: %s alterou o n�vel moderativo de %s para %i.", Character_GetName(playerid), s_pMemberEdit[playerid], listitem);

				if (IsPlayerConnected(character) && IsPlayerLogged(character) && CharacterData[character][e_CHARACTER_ID] > 0)
				{
					CharacterData[character][e_CHARACTER_FACTION_MOD] = listitem;
					SendClientMessageEx(character, -1, "FACTION: %s alterou seu n�vel moderativo para %i.", Character_GetName(playerid), listitem);
					Character_Save(character);
				}	

				SendClientMessageEx(playerid, -1, "FACTION: Voc� alterou o n�vel moderativo de %s para %i.", s_pMemberEdit[playerid], listitem);
				FactionManagement_ShowMember(playerid, s_pMemberEdit[playerid]);
			}
			else
			{
				SendErrorMessage(playerid, "N�o foi poss�vel executar a a��o.");
			}
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline FactionMember_OnUpdated, "UPDATE IGNORE `Personagens` SET `Fac��oMod` = %i WHERE `Nome` = '%e' AND `Fac��o` = %i LIMIT 1;", listitem, s_pMemberEdit[playerid], FactionData[id][e_FACTION_ID]);
	}

	return true;
}

Dialog:DIALOG_EDIT_MEMBER_RANK(playerid, response, listitem, inputtext[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	if (!(1 <= strlen(inputtext) <= 32))
		return SendErrorMessage(playerid, "O cargo deve ter de 1 a 32 caracteres.");

	format (s_pMemberEditRank[playerid], 32, inputtext);

	inline FactionMember_OnUpdated()
	{
		if (cache_affected_rows())
		{
			new character;
			character = GetPlayerId(s_pMemberEdit[playerid]);

			SendFactionMessage(id, COLOR_YELLOW, "FACTION: %s definiu o cargo de %s para \"%s\".", Character_GetName(playerid), s_pMemberEdit[playerid], s_pMemberEditRank[playerid]);

			if (IsPlayerConnected(character) && IsPlayerLogged(character) && CharacterData[character][e_CHARACTER_ID] > 0)
			{
				format (CharacterData[character][e_CHARACTER_FACTION_RANK], 32, s_pMemberEditRank[playerid]);
				SendClientMessageEx(character, COLOR_YELLOW, "%s definiu seu cargo na fac��o para \"%s\".", Character_GetName(playerid), s_pMemberEditRank[playerid]);
				Character_Save(character);
			}	

			SendClientMessageEx(playerid, COLOR_GREEN, "Voc� definiu o cargo na fac��o de %s para \"%s\".", s_pMemberEdit[playerid], s_pMemberEditRank[playerid]);
			FactionManagement_ShowMember(playerid, s_pMemberEdit[playerid]);
		}
		else
		{
			SendErrorMessage(playerid, "N�o foi poss�vel executar a a��o.");
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline FactionMember_OnUpdated, "UPDATE IGNORE `Personagens` SET `Fac��oRank` = '%e' WHERE `Nome` = '%e' AND `Fac��o` = %i LIMIT 1;", s_pMemberEditRank[playerid], s_pMemberEdit[playerid], FactionData[id][e_FACTION_ID]);
	return true;
}

// Functions
FactionManagement_ShowMenu(playerid)
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	new dialog[1024];

	format (dialog, sizeof dialog, 
		"{BBBBBB}INFORMA��ES\t\n{FFFFFF}Nome\t{BBBBBB}%s\n{FFFFFF}Abrevia��o\t{BBBBBB}%s\n{FFFFFF}Categoria\t{BBBBBB}%s\n{FFFFFF}Cofre\t{BBBBBB}%s\n{FFFFFF}Cor hexadecimal\t{%06x}%06x\n{FFFFFF}MOTD\t{BBBBBB}%.16s\n\t\n{BBBBBB}CONTROLE DE MEMBROS\t\n{FFFFFF}Alterar cargo padr�o\t{BBBBBB}%s\n{FFFFFF}Lista de membros\t\nBuscar membro pelo nome\t\nExibir painel de logs\t\nExibir permiss�es por n�vel\t", 
		FactionData[id][e_FACTION_NAME], FactionData[id][e_FACTION_ABBREV], g_arrayFactionTypes[FactionData[id][e_FACTION_TYPE]], FormatMoney(FactionData[id][e_FACTION_VAULT]), FactionData[id][e_FACTION_COLOR] >>> 8, FactionData[id][e_FACTION_COLOR] >>> 8, FactionData[id][e_FACTION_MOTD], FactionData[id][e_FACTION_DEFAULT_RANK]
	);

	// Fac��o n�o criminosa
	if (FactionData[id][e_FACTION_TYPE] != FACTION_TYPE_CRIMINAL)
	{
		strcat (dialog, "\nGerenciar sal�rio por cargo\t\n\t");
		strcat (dialog, "\n{BBBBBB}INTERA��ES\t\n{FFFFFF}Gerenciar spawns\t\nGerenciar arm�rios\t\nGerenciar arsenais\t");
	}
	else
	{
		strcat (dialog, "\t\n\t\n{BBBBBB}MERCADO DA FAC��O\n{FFFFFF}Tier atual\t{BBBBBB}");

		if (FactionData[id][e_FACTION_TIER] == -1)
		{
			strcat (dialog, "N�o escolhido");
		}
		else if (!FactionData[id][e_FACTION_TIER_ACTIVE])
		{
			strcat (dialog, "Desativado");
		}
		else
		{
			new nextUpdate;
			nextUpdate = FactionData[id][e_FACTION_TIER_UPDATE] + (60 * 60 * 24 * GetGVarInt("TIER_INTERVAL"));

			strcat (dialog, va_return("Tier %i (ativo)", FactionData[id][e_FACTION_TIER]));
			strcat (dialog, va_return("\n{FFFFFF}Saldo dispon�vel\t{BBBBBB}%s\n", FormatMoney(FactionData[id][e_FACTION_TIER_BALANCE])));
			strcat (dialog, va_return("\n{FFFFFF}Abastecimento\t{BBBBBB}%s\n", nextUpdate < gettime() ? ("{33AA33}Dispon�vel") : (TimestampFormat(nextUpdate, "%d/%m/%Y - %H:%i"))));
			strcat (dialog, va_return("\n{FFFFFF}Pontos\t{BBBBBB}%i (+%i)\n", FactionData[id][e_FACTION_TIER_POINTS], GetGVarInt("TIER_ADD_POINTS")));
			strcat (dialog, va_return("\n{FFFFFF}Propriedade\t{BBBBBB}Nenhuma\n"));
		}
	}

	Dialog_Show(playerid, DIALOG_FACTION_MANAGE, DIALOG_STYLE_TABLIST, va_return("Gerenciar: %s", FactionData[id][e_FACTION_NAME]), dialog, "Selecionar", "Fechar");
	return true;
}

FactionManagement_ShowMembers(playerid, page, const search[] = "")
{
	new dialog[1024], totalMember = 0, totalPage = 0, offSet, id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	format (s_pMemberSearch[playerid], MAX_PLAYER_NAME, search);

	inline FactionMNG_DisplayMembers()
	{
		static rows, nome[MAX_PLAYER_NAME + 1], cargo[32 + 1], mod, login[20 + 1];
		rows = cache_num_rows();

		if (!rows)
			return SendErrorMessage(playerid, "Nenhum resultado encontrado para \"%s\".", s_pMemberSearch[playerid]);

		dialog = "{FFFFFF}Nome\t{FFFFFF}Cargo\t{FFFFFF}Moderador\t{FFFFFF}�ltima atividade";

		for (new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "Nome", nome);
			cache_get_value_name(i, "Fac��oRank", cargo);
			cache_get_value_name(i, "Login", login);
			cache_get_value_name_int(i, "Fac��oMod", mod);

			strcat (dialog, va_return("\n{FFFFFF}%s", nome));
			strcat (dialog, va_return("\t{FFFFFF}%s", cargo));

			if (mod) strcat (dialog, va_return("\tN�vel %i", mod));
			else strcat (dialog, "\t{BBBBBB}N�o");

			strcat (dialog, va_return("\t{FFFFFF}%s", login));
		}

		if (page > 0)
		{
			strcat (dialog, "\n{BBBBBB}<< P�gina anterior");
		}

		if (rows == MAX_MEMBER_BY_PAGE && page < (totalPage - 1))
		{
			strcat (dialog, "\n{BBBBBB}Pr�xima p�gina >>");	
		}

		s_pMemberPage[playerid] = page;

		Dialog_Show(playerid, DIALOG_FACTION_MEMBERS, DIALOG_STYLE_TABLIST_HEADERS, va_return("%s - P�gina %i", FactionData[id][e_FACTION_NAME], page + 1), dialog, "Selecionar", "Voltar");
	}

	inline FactionMNG_OnGetMemberTotal()
	{
    	cache_get_value_name_int (0, "TotalMembro", totalMember);
        totalPage = (totalMember + MAX_MEMBER_BY_PAGE - 1) / MAX_MEMBER_BY_PAGE;

        if (page < 0) page = 0;
        if(page >= totalPage) page = totalPage - 1;

        offSet = (page * MAX_MEMBER_BY_PAGE);
        if (offSet < 0) offSet = 0;

        MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline FactionMNG_DisplayMembers, "SELECT `Nome`, `Fac��oRank`, `Fac��oMod`, DATE_FORMAT(`Acesso`, '%%d/%%m/%%Y, %%H:%%i') AS `Login` FROM `Personagens` WHERE `Fac��o` = %i AND `Nome` LIKE '%%%e%%' ORDER BY `Fac��oMod` DESC LIMIT %i OFFSET %i;", FactionData[id][e_FACTION_ID], s_pMemberSearch[playerid], MAX_MEMBER_BY_PAGE, offSet);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline FactionMNG_OnGetMemberTotal, "SELECT COUNT(*) AS `TotalMembro` FROM `Personagens` WHERE `Fac��o` = %i AND `Nome` LIKE '%%%s%%';", FactionData[id][e_FACTION_ID], s_pMemberSearch[playerid]);
    return true;
}

FactionManagement_ShowMember(playerid, const name[])
{
	new id = Character_GetFaction(playerid);

	if (id == -1)
		return false;

	inline FactionMember_GetData()
	{
		if (!cache_num_rows())
			return FactionManagement_ShowMembers(playerid, s_pMemberPage[playerid], s_pMemberSearch[playerid]);

		static nome[MAX_PLAYER_NAME + 1], mod, cargo[32 + 1], atividade[20 + 1], dialog[612];

		cache_get_value_name(0, "Nome", nome);
		cache_get_value_name_int(0, "Fac��oMod", mod);
		cache_get_value_name(0, "Fac��oRank", cargo);
		cache_get_value_name(0, "Atividade", atividade);

		format(s_pMemberEdit[playerid], MAX_PLAYER_NAME, nome);
		format(s_pMemberEditRank[playerid], 32, cargo);
		s_pMemberEditMod[playerid] = mod;

		format (dialog, sizeof dialog, "{FFFFFF}Alterar n�vel de moderador\t{BBBBBB}");

		if (mod > 0)
		{
			format (dialog, sizeof dialog, "%sN�vel %i", dialog, mod);
		}
		else
		{
			strcat (dialog, "Nenhum");
		}

		format (dialog, sizeof dialog, "%s\n{FFFFFF}Alterar cargo na fac��o\t{BBBBBB}%s\n{FFFFFF}�ltima atividade\t{BBBBBB}%s\n{FF5555}Expulsar membro da fac��o", dialog, cargo, atividade);

		Dialog_Show(playerid, DIALOG_FAC_EDIT_MEMBER, DIALOG_STYLE_TABLIST, va_return("Gerenciar: %s", s_pMemberEdit[playerid]), dialog, "Selecionar", "Voltar");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline FactionMember_GetData, "SELECT `Nome`, `Fac��oMod`, `Fac��oRank`, DATE_FORMAT(`Acesso`, '%%d/%%m/%%Y, %%H:%%i') AS `Atividade` FROM `Personagens` WHERE `Nome` = '%e' AND `Fac��o` = %i LIMIT 1;", name, FactionData[id][e_FACTION_ID]);
	return true;
}

// Comandos
CMD:faccao(playerid)
{
	if (Character_GetFaction(playerid) == -1)
		return SendErrorMessage(playerid, "Voc� n�o faz parte de uma fac��o.");

	FactionManagement_ShowMenu(playerid);
	return true;
}