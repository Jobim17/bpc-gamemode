/*
	  .oooooo.
	 d8P'  `Y8b
	888           .ooooo.  oooo d8b  .ooooo.
	888          d88' `88b `888""8P d88' `88b
	888          888   888  888     888ooo888
	`88b    ooo  888   888  888     888    .o
	 `Y8bood8P'  `Y8bod8P' d888b    `Y8bod8P'	
*/

// Includes
#include <YSI_Coding\y_hooks>

// Constants
#define CHARCREATE_TD_HOVER_COLOR 0x0095FFFF

static const s_aMaleSkins[169] = {
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	30, 32, 33, 34, 35, 36, 37, 42, 44, 45, 46, 47, 48, 49, 50, 51, 52, 58, 60,
	61, 62, 66, 68, 72, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 98, 99, 100, 101, 102,
	103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
	121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144,
	147, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170, 171, 173, 174, 175, 176,
	177, 180, 181, 182, 183, 184, 187, 188, 189, 200, 202, 203, 204, 206,
	208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 229, 230, 234, 235, 236, 239, 240,
	241, 242, 247, 248, 249, 250, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289,
	290, 291, 292, 293, 296, 297
};

static const s_aFemaleSkins[70] = {
    9, 10, 11, 12, 13, 31, 38, 39, 40, 53, 54, 55, 56, 63, 64, 65, 69,
    75, 77, 85, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140,
    145, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 195,
    196, 197, 198, 199, 201, 205, 207, 211, 214, 216, 219, 224, 225,
    226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263
};

static const s_aEyeColors[][16] = {
	{"Castanho"},
	{"Castanho Claro"}, 
	{"Âmbar"}, 
	{"Verde"}, 
	{"Azul"}, 
	{"Heterocromia"}
};

static const s_aEtnias[][16] = {
	{"Branco"},
	{"Negro"}, 
	{"Hispânico"}, 
	{"Asiático"}, 
	{"Indígena"}, 
	{"Miscigenado"}
};

static enum E_CHARACTER_CREATE
{
	e_CHAR_NAME[MAX_PLAYER_NAME + 1],
	bool:e_CHAR_IS_FEMALE,
	e_CHAR_SKIN_IDX,
	e_CHAR_BIRTHDATE[10 + 1],
	e_CHAR_ORIGIN[32 + 1],
	e_CHAR_HEIGHT,
	e_CHAR_WEIGHT,
	e_CHAR_EYES,
	e_CHAR_ETNIA
}

static CharacterCreate[MAX_PLAYERS + 1][E_CHARACTER_CREATE];

// Variáveis
static s_pCreatingActor[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...};
static bool:s_pCreatingCharacter[MAX_PLAYERS char] = {false, ...};

static Text:s_tdBody[26] = {Text:INVALID_TEXT_DRAW, ...};
static PlayerText:s_ptdCreateInfos[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

// Callbacks
hook OnGameModeInit()
{
	CharacterCreate_InitUI();
	return true;
}

hook OnGameModeExit()
{
	for (new i = 0; i < sizeof s_tdBody; i++)
	{
		TextDrawDestroy(s_tdBody[i]);
		s_tdBody[i] = Text:INVALID_TEXT_DRAW;
	}
	return true;
}

hook OnPlayerConnect(playerid)
{
	s_pCreatingActor[playerid] = CreateDynamicActor(0, 1949.3171, -1305.0236, 53.2590, 0.0, 1, 100.0, WORLD_PLAYER_LOGIN, 0);
	
	s_ptdCreateInfos[playerid] = CreatePlayerTextDraw(playerid, 148.000, 210.000, " ");
	PlayerTextDrawLetterSize(playerid, s_ptdCreateInfos[playerid], 0.150, 0.899);
	PlayerTextDrawTextSize(playerid, s_ptdCreateInfos[playerid], 1293.000, 1284.000);
	PlayerTextDrawAlignment(playerid, s_ptdCreateInfos[playerid], 2);
	PlayerTextDrawColor(playerid, s_ptdCreateInfos[playerid], -1);
	PlayerTextDrawSetShadow(playerid, s_ptdCreateInfos[playerid], 0);
	PlayerTextDrawSetOutline(playerid, s_ptdCreateInfos[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, s_ptdCreateInfos[playerid], 150);
	PlayerTextDrawFont(playerid, s_ptdCreateInfos[playerid], 2);
	PlayerTextDrawSetProportional(playerid, s_ptdCreateInfos[playerid], 1);
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (IsValidDynamicActor(s_pCreatingActor[playerid])) 
	{
		DestroyDynamicActor(s_pCreatingActor[playerid]);
	}

	s_pCreatingActor[playerid] = INVALID_STREAMER_ID;

	PlayerTextDrawDestroy(playerid, s_ptdCreateInfos[playerid]);
	s_ptdCreateInfos[playerid] = PlayerText:INVALID_TEXT_DRAW;
	return true;
}

hook OnPlayerClickTD(playerid, Text:clickedid)
{
	if (!s_pCreatingCharacter{playerid} || Dialog_Opened(playerid))
		return true;

	// ESC
	if (clickedid == Text:INVALID_TEXT_DRAW)
	{
		Dialog_Show(playerid, DIALOG_CHARCREATE_CANCEL, DIALOG_STYLE_MSGBOX, "{FF5555}Desistência", "{FFFFFF}Você realmente deseja desistir da criação do personagem {FF5555}%s{FFFFFF}?", "Sim", "Não", CharacterCreate[playerid][e_CHAR_NAME]);
		return true;
	}

	// Gênero
	if (clickedid == s_tdBody[8] || clickedid == s_tdBody[14])
	{
		CharacterCreate[playerid][e_CHAR_IS_FEMALE] = !CharacterCreate[playerid][e_CHAR_IS_FEMALE];

		if (CharacterCreate[playerid][e_CHAR_IS_FEMALE])
		{
			if (!(0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aFemaleSkins))
			{
				CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			}

			Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aFemaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]]);
		}
		else
		{
			if (!(0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aMaleSkins))
			{
				CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			}

			Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aMaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]]);
		}
	}

	// Skin (<<)
	else if (clickedid == s_tdBody[9])
	{
		if (!CharacterCreate[playerid][e_CHAR_SKIN_IDX]) 
			return false;

		CharacterCreate[playerid][e_CHAR_SKIN_IDX] -= 1;

		if (CharacterCreate[playerid][e_CHAR_IS_FEMALE])
		{
			if (!(0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aFemaleSkins))
			{
				CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			}

			Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aFemaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]]);
		}
		else
		{
			if (!(0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aMaleSkins))
			{
				CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			}

			Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aMaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]]);
		}

		Streamer_Update(playerid, STREAMER_TYPE_ACTOR);
	}

	// Altura (<<)
	else if (clickedid == s_tdBody[10])
	{
		if (CharacterCreate[playerid][e_CHAR_HEIGHT] > 130)
		{
			CharacterCreate[playerid][e_CHAR_HEIGHT] -= 10;
		}
	}

	// Peso (<<)
	else if (clickedid == s_tdBody[11])
	{
		if (CharacterCreate[playerid][e_CHAR_WEIGHT] > 50)
		{
			CharacterCreate[playerid][e_CHAR_WEIGHT] -= 10;
		}
	}

	// Olhos (<<)
	else if (clickedid == s_tdBody[12])
	{
		if (CharacterCreate[playerid][e_CHAR_EYES])
		{
			CharacterCreate[playerid][e_CHAR_EYES] -= 1;
		}
	}

	// Etnia (<<)
	else if (clickedid == s_tdBody[13])
	{
		if (CharacterCreate[playerid][e_CHAR_ETNIA])
		{
			CharacterCreate[playerid][e_CHAR_ETNIA] -= 1;
		}
	}

	// Skin (>>)
	else if(clickedid == s_tdBody[15])
	{
		if (CharacterCreate[playerid][e_CHAR_IS_FEMALE] && (CharacterCreate[playerid][e_CHAR_SKIN_IDX] + 1) >= sizeof s_aFemaleSkins) 
			return false;

		if (!CharacterCreate[playerid][e_CHAR_IS_FEMALE] && (CharacterCreate[playerid][e_CHAR_SKIN_IDX] + 1) >= sizeof s_aMaleSkins) 
			return false;

		CharacterCreate[playerid][e_CHAR_SKIN_IDX] += 1;

		if (CharacterCreate[playerid][e_CHAR_IS_FEMALE])
		{
			if (!(0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aFemaleSkins))
			{
				CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			}

			Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aFemaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]]);
		}
		else
		{
			if (!(0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aMaleSkins))
			{
				CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			}

			Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aMaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]]);
		}

		Streamer_Update(playerid, STREAMER_TYPE_ACTOR);
	}

	// Altura
	else if(clickedid == s_tdBody[16])
	{
		if (CharacterCreate[playerid][e_CHAR_HEIGHT] < 200)
		{
			CharacterCreate[playerid][e_CHAR_HEIGHT] += 10;
		}
	} 

	// Peso
	else if(clickedid == s_tdBody[17])
	{
		if (CharacterCreate[playerid][e_CHAR_WEIGHT] < 140)
		{
			CharacterCreate[playerid][e_CHAR_WEIGHT] += 10;
		}
	} 

	// Olhos
	else if(clickedid == s_tdBody[18])
	{
		if ((CharacterCreate[playerid][e_CHAR_EYES] + 1) >= sizeof s_aEyeColors)
			return false;

		CharacterCreate[playerid][e_CHAR_EYES] += 1;
	}

	// Etnia
	else if(clickedid == s_tdBody[19])
	{
		if ((CharacterCreate[playerid][e_CHAR_ETNIA] + 1) >= sizeof s_aEtnias)
			return false;

		CharacterCreate[playerid][e_CHAR_ETNIA] += 1;
	}

	// Data de Nascimento
	else if(clickedid == s_tdBody[20])
	{
		Dialog_Show(playerid, DIALOG_INSERT_BIRTHDATE, DIALOG_STYLE_INPUT, "{FFFFFF}Data de nascimento", "{FFFFFF}Por favor, insira a data de nascimento do seu personagem (DD/MM/AAAA):", "OK", "Cancelar");
		return true;
	}

	// Origem
	else if(clickedid == s_tdBody[21])
	{
		Dialog_Show(playerid, DIALOG_INSERT_ORIGIN, DIALOG_STYLE_INPUT, "{FFFFFF}Cidade natal", "{FFFFFF}Por favor, insira a cidade natal do seu personagem (ex: São Paulo):", "OK", "Cancelar");
		return true;
	}

	// Finalizar
	else if(clickedid == s_tdBody[23])
	{
		inline Character_OnCreated()
		{
			CharacterCreate_HideUI(playerid);

			InterpolateCameraPos(playerid, 1949.2590, -1299.5537, 53.6428, 1939.9484, -1299.2877, 53.6428, 3000, CAMERA_CUT);
			InterpolateCameraLookAt(playerid, 1949.2755, -1304.5535, 53.6891, 1939.8059, -1304.2854, 53.6936, 3000, CAMERA_CUT);
			SetTimerEx("CharacterCreate_OnCameraMoved", 3000, false, "ii", playerid, 3);

			if (cache_affected_rows())
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Personagem %s (%i) foi criado com sucesso.", CharacterCreate[playerid][e_CHAR_NAME], cache_insert_id());
			}
			else
			{
				SendErrorMessage(playerid, "Não foi possível criar o personagem %s.", CharacterCreate[playerid][e_CHAR_NAME]);
			}
		}

		MySQL_TQueryInline(
			MYSQL_CUR_HANDLE, 
			using inline Character_OnCreated, 
			"INSERT IGNORE INTO `Personagens` (`Nome`, `Conta`, `Skin`, `Gênero`, `Olhos`, `Etnia`, `Altura`, `Peso`, `CidadeNatal`, `DataNascimento`) VALUES ('%e', %i, %i, '%e', '%e', '%e', %i, %i, '%e', '%e');",
			CharacterCreate[playerid][e_CHAR_NAME],
			AccountData[playerid][e_ACCOUNT_ID],
			Streamer_GetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID),
			(CharacterCreate[playerid][e_CHAR_IS_FEMALE] ? ("F") : ("M")),
			s_aEyeColors[CharacterCreate[playerid][e_CHAR_EYES]],
			s_aEtnias[CharacterCreate[playerid][e_CHAR_ETNIA]],
			CharacterCreate[playerid][e_CHAR_HEIGHT],
			CharacterCreate[playerid][e_CHAR_WEIGHT],
			CharacterCreate[playerid][e_CHAR_ORIGIN],
			CharacterCreate[playerid][e_CHAR_BIRTHDATE]
		);
		return true;
	}

	CharacterCreate_UpdateUI(playerid);
	return true;
}

hook OnAccountLoggedIn(playerid)
{
	ShowPlayerCharacters(playerid);
	return true;
}

forward CharacterCreate_OnCameraMoved(playerid, id);
public CharacterCreate_OnCameraMoved(playerid, id)
{
	if (!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return false;

	switch (id)
	{
		case 1: // MOVE BACK
		{
			CharacterCreate_Reset(playerid);

			InterpolateCameraPos(playerid, 1939.9484, -1299.2877, 53.6428, 1949.2590, -1299.5537, 53.6428, 3000, CAMERA_CUT);
			InterpolateCameraLookAt(playerid, 1939.8059, -1304.2854, 53.6936, 1949.2755, -1304.5535, 53.6891, 3000, CAMERA_CUT);
			SetTimerEx("CharacterCreate_OnCameraMoved", 3000, false, "ii", playerid, 2);
		}

		case 2: // MOVE LEFT
		{
			CharacterCreate_ShowNameDialog(playerid);
			CharacterCreate_ShowUI(playerid);
		}

		case 3: // MOVE RIGHT
		{
			ShowPlayerCharacters(playerid);
		}
	}
	return true;
}

// Dialogs
Dialog:DIALOG_CHARCREATE_NAME(playerid, response, listitem, inputtext[])
{
	if (!IsValidCharacterName(inputtext))
	{
		CharacterCreate_ShowNameDialog(playerid, "Você inseriu um nome de personagem inválido.\n\n");
		return true;
	}

	new name[MAX_PLAYER_NAME];
	format (name, sizeof name, inputtext);

	inline CharacterExists()
	{
		if (cache_num_rows())
		{
			CharacterCreate_ShowNameDialog(playerid, "O nome de personagem está em uso.\n\n");
			return true;
		}

		format (CharacterCreate[playerid][e_CHAR_NAME], MAX_PLAYER_NAME, name);
		SendClientMessageEx(playerid, -1, "* O nome do seu personagem será {%06x}%s", COLOR_GREEN >>> 8, name);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline CharacterExists, "SELECT `ID` FROM `Personagens` WHERE `Nome` = '%e' LIMIT 1;", name);
	return true;
}

Dialog:DIALOG_INSERT_BIRTHDATE(playerid, response, listitem, inputtext[])
{
	if (!response) return true;

	new dia, mes, ano;
	if (sscanf(inputtext, "p</>iii", dia, mes, ano))
		return SendErrorMessage(playerid, "A data de nascimento do personagem deve estar no formato DD/MM/AAAA");

	static const
	    arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

	if (ano < 1900 || ano > 2005) 
	{
		SendErrorMessage(playerid, "O ano do nascimento deve estar entre 1900 e 2005.");
		return true;
	}
	
	if (mes < 1 || mes > 12) 
	{
		SendErrorMessage(playerid, "O mês do nascimento deve estar entre 1 e 12.");
		return true;
	}
	
	if (dia < 1 || dia > arrMonthDays[mes - 1]) 
	{
		SendErrorMessage(playerid, "O dia do nascimento deve estar entre 1 e %i.", arrMonthDays[mes - 1]);
		return true;
	}

	format (CharacterCreate[playerid][e_CHAR_BIRTHDATE], 10 + 1, "%02i/%02i/%04i", dia, mes, ano);
	CharacterCreate_UpdateUI(playerid);
	return true;
}

Dialog:DIALOG_INSERT_ORIGIN(playerid, response, listitem, inputtext[])
{
	if (!response) return true;

	if (IsNull(inputtext))
	{
		SendErrorMessage(playerid, "A cidade natal não pode estar nula.");
		return true;
	}

	if (!(5 <= strlen(inputtext) <= 32))
	{
		SendErrorMessage(playerid, "A cidade natal deve ter de 5 a 32 caracteres.");
		return true;
	}

	format (CharacterCreate[playerid][e_CHAR_ORIGIN], 32 + 1, inputtext);
	CharacterCreate_UpdateUI(playerid);
	return true;
}

Dialog:DIALOG_CHARCREATE_CANCEL(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		SelectTextDraw(playerid, CHARCREATE_TD_HOVER_COLOR);
		return true;
	}

	CharacterCreate_HideUI(playerid);
	SendErrorMessage(playerid, "Você desistiu da criação do personagem %s.", CharacterCreate[playerid][e_CHAR_NAME]);

	InterpolateCameraPos(playerid, 1949.2590, -1299.5537, 53.6428, 1939.9484, -1299.2877, 53.6428, 3000, CAMERA_CUT);
	InterpolateCameraLookAt(playerid, 1949.2755, -1304.5535, 53.6891, 1939.8059, -1304.2854, 53.6936, 3000, CAMERA_CUT);
	SetTimerEx("CharacterCreate_OnCameraMoved", 3000, false, "ii", playerid, 3);
	return true;
}

// Functions
CharacterCreate_ShowNameDialog(playerid, const err[] = "")
{
	Dialog_Show(playerid, DIALOG_CHARCREATE_NAME, DIALOG_STYLE_INPUT, "{FFFFFF}Nome do personagem", "{FF5555}%s{FFFFFF}Por favor, insira o nome do seu novo personagem.\nLembre-se que o formato para nomes deve seguir o modelo: {FFFF00}Nome_Sobrenome", "OK", "", err);
	return true;
}

CharacterCreate_Reset(playerid)
{
	CharacterCreate[playerid] = CharacterCreate[MAX_PLAYERS];

	CharacterCreate[playerid][e_CHAR_HEIGHT] = 160;
	CharacterCreate[playerid][e_CHAR_WEIGHT] = 70;
	format (CharacterCreate[playerid][e_CHAR_ORIGIN], 32, "São Paulo");
	format (CharacterCreate[playerid][e_CHAR_BIRTHDATE], 11, "01/01/1970");

	Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCreatingActor[playerid], E_STREAMER_MODEL_ID, s_aMaleSkins[0]);
	return true;
}

CharacterCreate_ShowUI(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	for (new i = 0; i < sizeof s_tdBody; i++)
	{
		if (s_tdBody[i] == Text:INVALID_TEXT_DRAW)
			continue;

		TextDrawShowForPlayer(playerid, s_tdBody[i]);
	}

	CharacterCreate_UpdateUI(playerid);
	PlayerTextDrawShow(playerid, s_ptdCreateInfos[playerid]);

	s_pCreatingCharacter{playerid} = true;
	SelectTextDraw(playerid, CHARCREATE_TD_HOVER_COLOR);
	return true;
}

CharacterCreate_HideUI(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	s_pCreatingCharacter{playerid} = false;
	CancelSelectTextDraw(playerid);

	for (new i = 0; i < sizeof s_tdBody; i++)
	{
		if (s_tdBody[i] == Text:INVALID_TEXT_DRAW)
			continue;

		TextDrawHideForPlayer(playerid, s_tdBody[i]);
	}

	PlayerTextDrawHide(playerid, s_ptdCreateInfos[playerid]);
	return true;
}

CharacterCreate_UpdateUI(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	new out[128], skin;

	if (CharacterCreate[playerid][e_CHAR_IS_FEMALE])
	{
		if ((0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aFemaleSkins))
		{
			skin = s_aFemaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]];
		}
		else
		{
			CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			skin = s_aFemaleSkins[0];
		}
	}
	else
	{
		if ((0 <= CharacterCreate[playerid][e_CHAR_SKIN_IDX] < sizeof s_aMaleSkins))
		{
			skin = s_aMaleSkins[CharacterCreate[playerid][e_CHAR_SKIN_IDX]];
		}
		else
		{
			CharacterCreate[playerid][e_CHAR_SKIN_IDX] = 0;
			skin = s_aMaleSkins[0];
		}
	}

	format (out, sizeof out,
		"%s ~n~%.16s %i ~n~%s ~n~%.16s ~n~%i cm ~n~%i kg ~n~%.16s ~n~%.16s",
		(CharacterCreate[playerid][e_CHAR_IS_FEMALE] ? ("Feminino") : ("Masculino")),
		ReturnSkinName(skin), skin,
		CharacterCreate[playerid][e_CHAR_BIRTHDATE],
		CharacterCreate[playerid][e_CHAR_ORIGIN],
		CharacterCreate[playerid][e_CHAR_HEIGHT],
		CharacterCreate[playerid][e_CHAR_WEIGHT],
		s_aEyeColors[CharacterCreate[playerid][e_CHAR_EYES]],
		s_aEtnias[CharacterCreate[playerid][e_CHAR_ETNIA]]
	);

	PlayerTextDrawSetString(playerid, s_ptdCreateInfos[playerid], out);
	return true;
}

CharacterCreate_InitUI()
{
	s_tdBody[0] = TextDrawCreate(40.000, 190.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[0], 155.000, 120.000);
	TextDrawAlignment(s_tdBody[0], 1);
	TextDrawColor(s_tdBody[0], 572662527);
	TextDrawSetShadow(s_tdBody[0], 0);
	TextDrawSetOutline(s_tdBody[0], 0);
	TextDrawBackgroundColor(s_tdBody[0], 255);
	TextDrawFont(s_tdBody[0], 4);
	TextDrawSetProportional(s_tdBody[0], 1);

	s_tdBody[1] = TextDrawCreate(38.000, 192.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[1], 159.000, 115.000);
	TextDrawAlignment(s_tdBody[1], 1);
	TextDrawColor(s_tdBody[1], 572662527);
	TextDrawSetShadow(s_tdBody[1], 0);
	TextDrawSetOutline(s_tdBody[1], 0);
	TextDrawBackgroundColor(s_tdBody[1], 255);
	TextDrawFont(s_tdBody[1], 4);
	TextDrawSetProportional(s_tdBody[1], 1);

	s_tdBody[2] = TextDrawCreate(36.500, 188.000, "ld_beat:chit");
	TextDrawTextSize(s_tdBody[2], 12.000, 11.000);
	TextDrawAlignment(s_tdBody[2], 1);
	TextDrawColor(s_tdBody[2], 572662527);
	TextDrawSetShadow(s_tdBody[2], 0);
	TextDrawSetOutline(s_tdBody[2], 0);
	TextDrawBackgroundColor(s_tdBody[2], 255);
	TextDrawFont(s_tdBody[2], 4);
	TextDrawSetProportional(s_tdBody[2], 1);

	s_tdBody[3] = TextDrawCreate(187.000, 188.000, "ld_beat:chit");
	TextDrawTextSize(s_tdBody[3], 12.000, 11.000);
	TextDrawAlignment(s_tdBody[3], 1);
	TextDrawColor(s_tdBody[3], 572662527);
	TextDrawSetShadow(s_tdBody[3], 0);
	TextDrawSetOutline(s_tdBody[3], 0);
	TextDrawBackgroundColor(s_tdBody[3], 255);
	TextDrawFont(s_tdBody[3], 4);
	TextDrawSetProportional(s_tdBody[3], 1);

	s_tdBody[4] = TextDrawCreate(36.500, 301.000, "ld_beat:chit");
	TextDrawTextSize(s_tdBody[4], 12.000, 11.000);
	TextDrawAlignment(s_tdBody[4], 1);
	TextDrawColor(s_tdBody[4], 572662527);
	TextDrawSetShadow(s_tdBody[4], 0);
	TextDrawSetOutline(s_tdBody[4], 0);
	TextDrawBackgroundColor(s_tdBody[4], 255);
	TextDrawFont(s_tdBody[4], 4);
	TextDrawSetProportional(s_tdBody[4], 1);

	s_tdBody[5] = TextDrawCreate(187.000, 301.000, "ld_beat:chit");
	TextDrawTextSize(s_tdBody[5], 12.000, 11.000);
	TextDrawAlignment(s_tdBody[5], 1);
	TextDrawColor(s_tdBody[5], 572662527);
	TextDrawSetShadow(s_tdBody[5], 0);
	TextDrawSetOutline(s_tdBody[5], 0);
	TextDrawBackgroundColor(s_tdBody[5], 255);
	TextDrawFont(s_tdBody[5], 4);
	TextDrawSetProportional(s_tdBody[5], 1);

	s_tdBody[6] = TextDrawCreate(118.000, 195.000, "Criação de Personagem");
	TextDrawLetterSize(s_tdBody[6], 0.180, 0.799);
	TextDrawTextSize(s_tdBody[6], 1293.000, 1284.000);
	TextDrawAlignment(s_tdBody[6], 2);
	TextDrawColor(s_tdBody[6], -1);
	TextDrawSetShadow(s_tdBody[6], 0);
	TextDrawSetOutline(s_tdBody[6], 0);
	TextDrawBackgroundColor(s_tdBody[6], 150);
	TextDrawFont(s_tdBody[6], 1);
	TextDrawSetProportional(s_tdBody[6], 1);

	s_tdBody[7] = TextDrawCreate(47.000, 210.000, "Gênero ~n~Roupa ~n~Data de nasc. ~n~Cidade Natal ~n~Altura ~n~Peso ~n~Olhos ~n~Etnia");
	TextDrawLetterSize(s_tdBody[7], 0.150, 0.899);
	TextDrawTextSize(s_tdBody[7], 1293.000, 1284.000);
	TextDrawAlignment(s_tdBody[7], 1);
	TextDrawColor(s_tdBody[7], -104);
	TextDrawSetShadow(s_tdBody[7], 0);
	TextDrawSetOutline(s_tdBody[7], 0);
	TextDrawBackgroundColor(s_tdBody[7], 150);
	TextDrawFont(s_tdBody[7], 2);
	TextDrawSetProportional(s_tdBody[7], 1);

	s_tdBody[8] = TextDrawCreate(103.500, 210.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[8], 8.000, 8.000);
	TextDrawAlignment(s_tdBody[8], 1);
	TextDrawColor(s_tdBody[8], 336860415);
	TextDrawSetShadow(s_tdBody[8], 0);
	TextDrawSetOutline(s_tdBody[8], 0);
	TextDrawBackgroundColor(s_tdBody[8], 255);
	TextDrawFont(s_tdBody[8], 4);
	TextDrawSetProportional(s_tdBody[8], 1);
	TextDrawSetSelectable(s_tdBody[8], 1);

	s_tdBody[9] = TextDrawCreate(103.500, 219.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[9], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[9], 1);
	TextDrawColor(s_tdBody[9], 336860415);
	TextDrawSetShadow(s_tdBody[9], 0);
	TextDrawSetOutline(s_tdBody[9], 0);
	TextDrawBackgroundColor(s_tdBody[9], 255);
	TextDrawFont(s_tdBody[9], 4);
	TextDrawSetProportional(s_tdBody[9], 1);
	TextDrawSetSelectable(s_tdBody[9], 1);

	s_tdBody[10] = TextDrawCreate(103.500, 243.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[10], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[10], 1);
	TextDrawColor(s_tdBody[10], 336860415);
	TextDrawSetShadow(s_tdBody[10], 0);
	TextDrawSetOutline(s_tdBody[10], 0);
	TextDrawBackgroundColor(s_tdBody[10], 255);
	TextDrawFont(s_tdBody[10], 4);
	TextDrawSetProportional(s_tdBody[10], 1);
	TextDrawSetSelectable(s_tdBody[10], 1);

	s_tdBody[11] = TextDrawCreate(103.500, 251.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[11], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[11], 1);
	TextDrawColor(s_tdBody[11], 336860415);
	TextDrawSetShadow(s_tdBody[11], 0);
	TextDrawSetOutline(s_tdBody[11], 0);
	TextDrawBackgroundColor(s_tdBody[11], 255);
	TextDrawFont(s_tdBody[11], 4);
	TextDrawSetProportional(s_tdBody[11], 1);
	TextDrawSetSelectable(s_tdBody[11], 1);

	s_tdBody[12] = TextDrawCreate(103.500, 259.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[12], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[12], 1);
	TextDrawColor(s_tdBody[12], 336860415);
	TextDrawSetShadow(s_tdBody[12], 0);
	TextDrawSetOutline(s_tdBody[12], 0);
	TextDrawBackgroundColor(s_tdBody[12], 255);
	TextDrawFont(s_tdBody[12], 4);
	TextDrawSetProportional(s_tdBody[12], 1);
	TextDrawSetSelectable(s_tdBody[12], 1);

	s_tdBody[13] = TextDrawCreate(103.500, 267.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[13], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[13], 1);
	TextDrawColor(s_tdBody[13], 336860415);
	TextDrawSetShadow(s_tdBody[13], 0);
	TextDrawSetOutline(s_tdBody[13], 0);
	TextDrawBackgroundColor(s_tdBody[13], 255);
	TextDrawFont(s_tdBody[13], 4);
	TextDrawSetProportional(s_tdBody[13], 1);
	TextDrawSetSelectable(s_tdBody[13], 1);

	s_tdBody[14] = TextDrawCreate(180.500, 210.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[14], 8.000, 8.000);
	TextDrawAlignment(s_tdBody[14], 1);
	TextDrawColor(s_tdBody[14], 336860415);
	TextDrawSetShadow(s_tdBody[14], 0);
	TextDrawSetOutline(s_tdBody[14], 0);
	TextDrawBackgroundColor(s_tdBody[14], 255);
	TextDrawFont(s_tdBody[14], 4);
	TextDrawSetProportional(s_tdBody[14], 1);
	TextDrawSetSelectable(s_tdBody[14], 1);

	s_tdBody[15] = TextDrawCreate(180.500, 219.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[15], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[15], 1);
	TextDrawColor(s_tdBody[15], 336860415);
	TextDrawSetShadow(s_tdBody[15], 0);
	TextDrawSetOutline(s_tdBody[15], 0);
	TextDrawBackgroundColor(s_tdBody[15], 255);
	TextDrawFont(s_tdBody[15], 4);
	TextDrawSetProportional(s_tdBody[15], 1);
	TextDrawSetSelectable(s_tdBody[15], 1);

	s_tdBody[16] = TextDrawCreate(180.500, 243.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[16], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[16], 1);
	TextDrawColor(s_tdBody[16], 336860415);
	TextDrawSetShadow(s_tdBody[16], 0);
	TextDrawSetOutline(s_tdBody[16], 0);
	TextDrawBackgroundColor(s_tdBody[16], 255);
	TextDrawFont(s_tdBody[16], 4);
	TextDrawSetProportional(s_tdBody[16], 1);
	TextDrawSetSelectable(s_tdBody[16], 1);

	s_tdBody[17] = TextDrawCreate(180.500, 251.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[17], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[17], 1);
	TextDrawColor(s_tdBody[17], 336860415);
	TextDrawSetShadow(s_tdBody[17], 0);
	TextDrawSetOutline(s_tdBody[17], 0);
	TextDrawBackgroundColor(s_tdBody[17], 255);
	TextDrawFont(s_tdBody[17], 4);
	TextDrawSetProportional(s_tdBody[17], 1);
	TextDrawSetSelectable(s_tdBody[17], 1);

	s_tdBody[18] = TextDrawCreate(180.500, 259.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[18], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[18], 1);
	TextDrawColor(s_tdBody[18], 336860415);
	TextDrawSetShadow(s_tdBody[18], 0);
	TextDrawSetOutline(s_tdBody[18], 0);
	TextDrawBackgroundColor(s_tdBody[18], 255);
	TextDrawFont(s_tdBody[18], 4);
	TextDrawSetProportional(s_tdBody[18], 1);
	TextDrawSetSelectable(s_tdBody[18], 1);

	s_tdBody[19] = TextDrawCreate(180.500, 267.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[19], 8.000, 7.500);
	TextDrawAlignment(s_tdBody[19], 1);
	TextDrawColor(s_tdBody[19], 336860415);
	TextDrawSetShadow(s_tdBody[19], 0);
	TextDrawSetOutline(s_tdBody[19], 0);
	TextDrawBackgroundColor(s_tdBody[19], 255);
	TextDrawFont(s_tdBody[19], 4);
	TextDrawSetProportional(s_tdBody[19], 1);
	TextDrawSetSelectable(s_tdBody[19], 1);

	s_tdBody[20] = TextDrawCreate(103.500, 227.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[20], 85.000, 7.500);
	TextDrawAlignment(s_tdBody[20], 1);
	TextDrawColor(s_tdBody[20], 336860415);
	TextDrawSetShadow(s_tdBody[20], 0);
	TextDrawSetOutline(s_tdBody[20], 0);
	TextDrawBackgroundColor(s_tdBody[20], 255);
	TextDrawFont(s_tdBody[20], 4);
	TextDrawSetProportional(s_tdBody[20], 1);
	TextDrawSetSelectable(s_tdBody[20], 1);

	s_tdBody[21] = TextDrawCreate(103.500, 235.500, "ld_spac:white");
	TextDrawTextSize(s_tdBody[21], 85.000, 7.000);
	TextDrawAlignment(s_tdBody[21], 1);
	TextDrawColor(s_tdBody[21], 336860415);
	TextDrawSetShadow(s_tdBody[21], 0);
	TextDrawSetOutline(s_tdBody[21], 0);
	TextDrawBackgroundColor(s_tdBody[21], 255);
	TextDrawFont(s_tdBody[21], 4);
	TextDrawSetProportional(s_tdBody[21], 1);
	TextDrawSetSelectable(s_tdBody[21], 1);

	s_tdBody[22] = TextDrawCreate(117.000, 289.000, "Finalizar");
	TextDrawLetterSize(s_tdBody[22], 0.180, 0.799);
	TextDrawTextSize(s_tdBody[22], 1293.000, 1284.000);
	TextDrawAlignment(s_tdBody[22], 2);
	TextDrawColor(s_tdBody[22], -1);
	TextDrawSetShadow(s_tdBody[22], 0);
	TextDrawSetOutline(s_tdBody[22], 0);
	TextDrawBackgroundColor(s_tdBody[22], 150);
	TextDrawFont(s_tdBody[22], 1);
	TextDrawSetProportional(s_tdBody[22], 1);

	s_tdBody[23] = TextDrawCreate(92.000, 286.000, "ld_spac:white");
	TextDrawTextSize(s_tdBody[23], 50.000, 15.000);
	TextDrawAlignment(s_tdBody[23], 1);
	TextDrawColor(s_tdBody[23], 343193855);
	TextDrawSetShadow(s_tdBody[23], 0);
	TextDrawSetOutline(s_tdBody[23], 0);
	TextDrawBackgroundColor(s_tdBody[23], 255);
	TextDrawFont(s_tdBody[23], 4);
	TextDrawSetProportional(s_tdBody[23], 1);
	TextDrawSetSelectable(s_tdBody[23], 1);

	s_tdBody[24] = TextDrawCreate(105.000, 210.000, "< ~n~< ~n~ ~n~ ~n~< ~n~< ~n~< ~n~<");
	TextDrawLetterSize(s_tdBody[24], 0.150, 0.899);
	TextDrawTextSize(s_tdBody[24], 1293.000, 1284.000);
	TextDrawAlignment(s_tdBody[24], 1);
	TextDrawColor(s_tdBody[24], -104);
	TextDrawSetShadow(s_tdBody[24], 0);
	TextDrawSetOutline(s_tdBody[24], 0);
	TextDrawBackgroundColor(s_tdBody[24], 150);
	TextDrawFont(s_tdBody[24], 2);
	TextDrawSetProportional(s_tdBody[24], 1);

	s_tdBody[25] = TextDrawCreate(183.000, 210.000, "> ~n~> ~n~ ~n~ ~n~> ~n~> ~n~> ~n~>");
	TextDrawLetterSize(s_tdBody[25], 0.150, 0.899);
	TextDrawTextSize(s_tdBody[25], 1293.000, 1284.000);
	TextDrawAlignment(s_tdBody[25], 1);
	TextDrawColor(s_tdBody[25], -104);
	TextDrawSetShadow(s_tdBody[25], 0);
	TextDrawSetOutline(s_tdBody[25], 0);
	TextDrawBackgroundColor(s_tdBody[25], 150);
	TextDrawFont(s_tdBody[25], 2);
	TextDrawSetProportional(s_tdBody[25], 1);
	return true;
}

IsValidCharacterName(const name[])
{
	if (!(3 <= strlen(name) < MAX_PLAYER_NAME))
		return false;

	new firstName[MAX_PLAYER_NAME], lastName[MAX_PLAYER_NAME];

	if (sscanf(name, "p<_>s[25]s[25]", firstName, lastName))
		return false;

	if (!isupper(firstName[0]) || !isupper(lastName[0]))
		return false;

	for (new i = 0, j = strlen(name); i < j; i++)
	{
		switch (name[i])
		{
			case 'a'..'z', 'A'..'Z', '_': continue;
			default: return false;
		}
	}

	return true;
}