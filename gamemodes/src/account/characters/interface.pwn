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

// Constants
#define CHARACTER_TD_OFFSET_Y 65.0
#define CHARACTER_TD_HOVER_COLOR 0x0095FFFF

// Variáveis
static enum E_TD_BUTTONS
{
	PlayerText:e_TD_BTN_BUTTON,
	PlayerText:e_TD_BTN_BACKGROUND,
	PlayerText:e_TD_BTN_PREVIEW,
	PlayerText:e_TD_BTN_TEXT,
	PlayerText:e_TD_BTN_CUT
}

static Text:s_tdBackground[2] = {Text:INVALID_TEXT_DRAW, ...};
static Text:s_tdNoCharacters[4] = {Text:INVALID_TEXT_DRAW, ...};

static PlayerText:s_ptdBreadcump[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
static s_ptdButton[MAX_PLAYERS][MAX_ACCOUNT_CHARACTER][E_TD_BUTTONS];

static bool:s_pCharacterSelection[MAX_PLAYERS char] = {false, ...};
static s_pCharacterSelectedIndex[MAX_PLAYERS] = {-1, ...};

static s_pCharacterIds[MAX_PLAYERS][MAX_ACCOUNT_CHARACTER];
static s_pCharacterSkin[MAX_PLAYERS][MAX_ACCOUNT_CHARACTER];
static s_pCharacterName[MAX_PLAYERS][MAX_ACCOUNT_CHARACTER][MAX_PLAYER_NAME];

static s_pCharacterNameObject[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...};
static s_pCharacterSkinActor[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...};

// Callbacks
hook OnGameModeInit()
{
	// Background
	s_tdBackground[0] = TextDrawCreate(0.000, 0.000, "ld_spac:white");
	TextDrawTextSize(s_tdBackground[0], 175.000, 1280.000);
	TextDrawAlignment(s_tdBackground[0], 1);
	TextDrawColor(s_tdBackground[0], 0);
	TextDrawUseBox(s_tdBackground[0], 1);
	TextDrawColor(s_tdBackground[0], 0x181414FF);
	TextDrawSetShadow(s_tdBackground[0], 1);
	TextDrawSetOutline(s_tdBackground[0], 1);
	TextDrawBackgroundColor(s_tdBackground[0], 0);
	TextDrawFont(s_tdBackground[0], 4);
	TextDrawSetProportional(s_tdBackground[0], 1);

	s_tdBackground[1] = TextDrawCreate(0.000, 78.000, "ld_spac:white");
	TextDrawTextSize(s_tdBackground[1], 175.000, 20.000);
	TextDrawAlignment(s_tdBackground[1], 1);
	TextDrawColor(s_tdBackground[1], 0x1474b8FF);
	TextDrawSetShadow(s_tdBackground[1], 0);
	TextDrawSetOutline(s_tdBackground[1], 0);
	TextDrawBackgroundColor(s_tdBackground[1], 255);
	TextDrawFont(s_tdBackground[1], 4);
	TextDrawSetProportional(s_tdBackground[1], 1);

	// No Characters
	s_tdNoCharacters[0] = TextDrawCreate(175.0, -175.000, "ld_spac:white");
	TextDrawTextSize(s_tdNoCharacters[0], 1280.000, 1280.000);
	TextDrawAlignment(s_tdNoCharacters[0], 1);
	TextDrawColor(s_tdNoCharacters[0], 572662527);
	TextDrawSetShadow(s_tdNoCharacters[0], 0);
	TextDrawSetOutline(s_tdNoCharacters[0], 0);
	TextDrawBackgroundColor(s_tdNoCharacters[0], 255);
	TextDrawFont(s_tdNoCharacters[0], 4);
	TextDrawSetProportional(s_tdNoCharacters[0], 1);

	s_tdNoCharacters[1] = TextDrawCreate(223.000, 174.000, "ld_beat:chit");
	TextDrawTextSize(s_tdNoCharacters[1], 50.000, 50.000);
	TextDrawAlignment(s_tdNoCharacters[1], 1);
	TextDrawColor(s_tdNoCharacters[1], -11184641);
	TextDrawSetShadow(s_tdNoCharacters[1], 0);
	TextDrawSetOutline(s_tdNoCharacters[1], 0);
	TextDrawBackgroundColor(s_tdNoCharacters[1], 255);
	TextDrawFont(s_tdNoCharacters[1], 4);
	TextDrawSetProportional(s_tdNoCharacters[1], 1);

	s_tdNoCharacters[2] = TextDrawCreate(241.000, 185.000, ":(");
	TextDrawLetterSize(s_tdNoCharacters[2], 0.559, 2.499);
	TextDrawTextSize(s_tdNoCharacters[2], 29.000, 11.000);
	TextDrawAlignment(s_tdNoCharacters[2], 1);
	TextDrawColor(s_tdNoCharacters[2], 572662527);
	TextDrawSetShadow(s_tdNoCharacters[2], 0);
	TextDrawSetOutline(s_tdNoCharacters[2], 0);
	TextDrawBackgroundColor(s_tdNoCharacters[2], 150);
	TextDrawFont(s_tdNoCharacters[2], 1);
	TextDrawSetProportional(s_tdNoCharacters[2], 1);

	s_tdNoCharacters[3] = TextDrawCreate(273.000, 185.000, "Oh Não! ~n~~w~~h~~h~Você ainda não tem um personagem criado, ~n~Por favor, clique no botão de ~b~~h~~h~criar personagem~w~~h~~h~.");
	TextDrawLetterSize(s_tdNoCharacters[3], 0.200, 0.999);
	TextDrawTextSize(s_tdNoCharacters[3], 1280.000, 1280.000);
	TextDrawAlignment(s_tdNoCharacters[3], 1);
	TextDrawColor(s_tdNoCharacters[3], -11184641);
	TextDrawSetShadow(s_tdNoCharacters[3], 0);
	TextDrawSetOutline(s_tdNoCharacters[3], 0);
	TextDrawBackgroundColor(s_tdNoCharacters[3], 150);
	TextDrawFont(s_tdNoCharacters[3], 1);
	TextDrawSetProportional(s_tdNoCharacters[3], 1);
	return true;
}

hook OnPlayerConnect(playerid)
{
	s_pCharacterSelection{playerid} = false;

	s_ptdBreadcump[playerid] = CreatePlayerTextDraw(playerid, 10.000, 83.000, va_return("Home \\ %s \\ Personagens", ReturnPlayerName(playerid)));
	PlayerTextDrawLetterSize(playerid, s_ptdBreadcump[playerid], 0.200, 1.000);
	PlayerTextDrawTextSize(playerid, s_ptdBreadcump[playerid], 1280.000, 1280.000);
	PlayerTextDrawAlignment(playerid, s_ptdBreadcump[playerid], 1);
	PlayerTextDrawColor(playerid, s_ptdBreadcump[playerid], -1);
	PlayerTextDrawSetShadow(playerid, s_ptdBreadcump[playerid], 0);
	PlayerTextDrawSetOutline(playerid, s_ptdBreadcump[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, s_ptdBreadcump[playerid], 150);
	PlayerTextDrawFont(playerid, s_ptdBreadcump[playerid], 1);
	PlayerTextDrawSetProportional(playerid, s_ptdBreadcump[playerid], 1);

	s_pCharacterNameObject[playerid] = CreateDynamicObject(2714, 1939.787598, -1306.778076, 53.519680, 0.000000, 0.000000, 180.000000, WORLD_PLAYER_LOGIN, 0);
	SetDynamicObjectMaterialText(s_pCharacterNameObject[playerid], 0, " ", 130, "Arial", 45, 1, 0xFFFFFFFF, 0, 1);

	s_pCharacterSkinActor[playerid]	= CreateDynamicActor(264,  1939.8387, -1307.0422, 53.2097, 0.0, 1, 100.0, WORLD_PLAYER_LOGIN, 0);
	SetDynamicActorInvulnerable(s_pCharacterSkinActor[playerid], 1);
	ApplyDynamicActorAnimation(s_pCharacterSkinActor[playerid], "DEALER", "DEALER_idle", 4.1, 1, 0, 0, 1, 0);
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid, s_ptdBreadcump[playerid]);

	if (IsValidDynamicObject(s_pCharacterNameObject[playerid]))
	{
		DestroyDynamicObject(s_pCharacterNameObject[playerid]);
		s_pCharacterNameObject[playerid] = INVALID_STREAMER_ID;
	}

	if (IsValidDynamicActor(s_pCharacterSkinActor[playerid]))
	{
		DestroyDynamicActor(s_pCharacterSkinActor[playerid]);
		s_pCharacterSkinActor[playerid] = INVALID_STREAMER_ID;
	}
	return true;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if (GetPlayerVirtualWorld(playerid) != WORLD_PLAYER_LOGIN || !s_pCharacterSelection{playerid})
		return true;

	new idx = -1;

	for (new i = 0; i < MAX_ACCOUNT_CHARACTER; i++)
	{
		if (playertextid == s_ptdButton[playerid][i][e_TD_BTN_BUTTON])
		{
			idx = i;
			break;
		}
	}

	if (idx != -1)
	{
		// Criar um novo personagem
		if (s_pCharacterIds[playerid][idx] == -1)
		{
			SelectCharacterIndex(playerid, -1);
			HidePlayerCharacters(playerid);

			InterpolateCameraPos(playerid, 1939.8579, -1302.4535, 53.5961, 1939.9484, -1299.2877, 53.6428, 3000, CAMERA_CUT);
			InterpolateCameraLookAt(playerid, 1939.7155, -1307.4503, 53.7015, 1939.8059, -1304.2854, 53.6936, 3000, CAMERA_CUT);

			SetTimerEx("CharacterCreate_OnCameraMoved", 3000, false, "ii", playerid, 1);
			return true;
		}

		if (idx != s_pCharacterSelectedIndex[playerid])
		{
			SelectCharacterIndex(playerid, idx);
		}
		else
		{
			HidePlayerCharacters(playerid);
			Character_Load(playerid, s_pCharacterIds[playerid][idx]);
		}
	}

	return true;
}

// Threads
forward OnCharactersListCreate(playerid);
public OnCharactersListCreate(playerid)
{	
	new rows = cache_num_rows();

	// Show Body
	for (new i = 0; i < sizeof s_tdBackground; i++)
	{
		TextDrawShowForPlayer(playerid, s_tdBackground[i]);
	}

	// Show Breadcump
	PlayerTextDrawShow(playerid, s_ptdBreadcump[playerid]);

	// Delete old textdraws
	for (new i = 0; i < sizeof s_ptdButton[]; i++)
	{
		if (s_ptdButton[playerid][i][e_TD_BTN_BUTTON] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_BUTTON] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON]);
			s_ptdButton[playerid][i][e_TD_BTN_BUTTON] = PlayerText:INVALID_TEXT_DRAW;
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND]);
			s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND] = PlayerText:INVALID_TEXT_DRAW;
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_PREVIEW] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_PREVIEW] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW]);
			s_ptdButton[playerid][i][e_TD_BTN_PREVIEW] = PlayerText:INVALID_TEXT_DRAW;
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_TEXT] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_TEXT] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT]);
			s_ptdButton[playerid][i][e_TD_BTN_TEXT] = PlayerText:INVALID_TEXT_DRAW;
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_CUT] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_CUT] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT]);
			s_ptdButton[playerid][i][e_TD_BTN_CUT] = PlayerText:INVALID_TEXT_DRAW;
		}
	}

	// Create
	new
		name[MAX_PLAYER_NAME + 1],
		level,
		money,
		lastAccess[32 + 1],
		skin,
		faction,
		factionRank[64],
		factionIndex,
		out[128];

	for (new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "ID", s_pCharacterIds[playerid][i]);

		cache_get_value_name(i, "Nome", name);
		format (s_pCharacterName[playerid][i], MAX_PLAYER_NAME + 1, name);

		cache_get_value_name_int(i, "Skin", skin);
		s_pCharacterSkin[playerid][i] = skin;

		cache_get_value_name_int(i, "Nível", level);
		cache_get_value_name_int(i, "Dinheiro", money);
		cache_get_value_name_int(i, "Facção", faction);
		cache_get_value_name(i, "FacçãoRank", factionRank);
		cache_get_value_name(i, "UltimoAcesso", lastAccess);

		factionIndex = Faction_GetRealID(faction);

		if (factionIndex == -1)
		{
			format (factionRank, sizeof factionRank, "~w~~h~Cidadão");
		}
		else
		{
			format (factionRank, sizeof factionRank, ReturnLimitedText(factionRank));

			switch (FactionData[factionIndex][e_FACTION_TYPE])
			{
				case FACTION_TYPE_GOV: strins(factionRank, "~g~~h~~h~~h~", 0);
				case FACTION_TYPE_POLICE: strins(factionRank, "~b~~h~~h~", 0);
				case FACTION_TYPE_MEDIC: strins(factionRank, "~r~~h~~h~~h~", 0);
				case FACTION_TYPE_CRIMINAL: strins(factionRank, "~r~~h~", 0);
			}
		}

		format (out, sizeof out, "%s ~n~~b~~h~~h~Nivel %i ~n~%s ~n~~g~~h~%s ~n~~y~~h~~h~%s", name, level, factionRank, FormatMoney(money), lastAccess);

		// Botão
		s_ptdButton[playerid][i][e_TD_BTN_BUTTON] = CreatePlayerTextDraw(playerid, 10.000, (110.0 + (i * CHARACTER_TD_OFFSET_Y)), "ld_spac:white");
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 159.000, 60.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 0x5f5f5fFF);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 255);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 4);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 1);
		PlayerTextDrawSetSelectable(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], 1);

		// Background
		s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND] = CreatePlayerTextDraw(playerid, 11.000, (111.0 + (i * CHARACTER_TD_OFFSET_Y)), "ld_spac:white");
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 157.000, 58.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 505290495);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 255);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 4);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND], 1);

		// Preview
		s_ptdButton[playerid][i][e_TD_BTN_PREVIEW] = CreatePlayerTextDraw(playerid, -30.000, (99.000 + (i * CHARACTER_TD_OFFSET_Y)), "_");
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 150.000, 150.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], -1);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 0);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 5);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 0);
		PlayerTextDrawSetPreviewModel(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], skin);
		PlayerTextDrawSetPreviewRot(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 0.000, 0.000, 15.000, 1.000);
		PlayerTextDrawSetPreviewVehCol(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW], 0, 0);

		// Cut
		s_ptdButton[playerid][i][e_TD_BTN_CUT] = CreatePlayerTextDraw(playerid, 10.000, (170.0 + (i * CHARACTER_TD_OFFSET_Y)), "ld_spac:white");
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 159.000, 1280.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 0x181414FF);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 255);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 4);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT], 1);

		// Texto
		s_ptdButton[playerid][i][e_TD_BTN_TEXT] = CreatePlayerTextDraw(playerid, 73.000, 117.000 + (i * CHARACTER_TD_OFFSET_Y), out);
		PlayerTextDrawLetterSize(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 0.200, 1.000);
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 1280.000, 1280.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], -505290241);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 150);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 1);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT], 1);
		
		// Show
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON]);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND]);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW]);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT]);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT]);
	}

	// Rows
	if (rows < MAX_ACCOUNT_CHARACTER)
	{
		s_ptdButton[playerid][rows][e_TD_BTN_BUTTON] = CreatePlayerTextDraw(playerid, 10.000, (110.000 + (rows * CHARACTER_TD_OFFSET_Y)), "ld_spac:white");
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 159.000, 22.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 0x0095FFFF);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 255);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 4);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 1);
		PlayerTextDrawSetSelectable(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON], 1);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BUTTON]);

		s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND] = CreatePlayerTextDraw(playerid, 11.000, 111.000 + (rows * CHARACTER_TD_OFFSET_Y), "ld_spac:white");
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 157.000, 20.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 1);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 0x1474b8FF);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 255);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 4);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND], 1);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][rows][e_TD_BTN_BACKGROUND]);

		s_ptdButton[playerid][rows][e_TD_BTN_TEXT] = CreatePlayerTextDraw(playerid, 90.000, 117.000 + (rows * CHARACTER_TD_OFFSET_Y), "Criar Personagem");
		PlayerTextDrawLetterSize(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 0.150, 0.750);
		PlayerTextDrawTextSize(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 1272.000, 1278.000);
		PlayerTextDrawAlignment(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 2);
		PlayerTextDrawColor(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], -1);
		PlayerTextDrawSetShadow(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 0);
		PlayerTextDrawSetOutline(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 0);
		PlayerTextDrawBackgroundColor(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 150);
		PlayerTextDrawFont(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 1);
		PlayerTextDrawSetProportional(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT], 1);
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][rows][e_TD_BTN_TEXT]);
	}

	if (!rows)
	{
		// No Characters
		for (new i = 0; i < sizeof s_tdNoCharacters; i++)
		{
			TextDrawShowForPlayer(playerid, s_tdNoCharacters[i]);
		}

		SelectCharacterIndex(playerid, -1);
	}
	else
	{
		SelectCharacterIndex(playerid, 0);
	}

	// Informations
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, WORLD_PLAYER_LOGIN);

	InterpolateCameraPos(playerid, 1939.9484, -1299.2877, 53.6428, 1939.8579, -1302.4535, 53.5961, 3000, CAMERA_CUT);
	InterpolateCameraLookAt(playerid, 1939.8059, -1304.2854, 53.6936, 1939.7155, -1307.4503, 53.7015, 3000, CAMERA_CUT);

	SelectTextDraw(playerid, CHARACTER_TD_HOVER_COLOR);
	s_pCharacterSelection{playerid} = true;
	return true;
}

// Functions
ShowPlayerCharacters(playerid)
{
	if (!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return false;

	for (new i = 0; i < sizeof s_pCharacterIds[]; i++)
		s_pCharacterIds[playerid][i] = -1;

	ClearPlayerMessages(playerid);
	s_pCharacterSelectedIndex[playerid] = -1;

	new query[312];
	mysql_format (MYSQL_CUR_HANDLE, query, sizeof query, "SELECT `ID`, `Nome`, `Nível`, `Dinheiro`, `Skin`, COALESCE(DATE_FORMAT(`Acesso`, '%%d %%b %%Y'), '~r~~h~~h~~h~Nunca acessado') AS `UltimoAcesso`, `Facção`, `FacçãoRank` FROM `Personagens` WHERE `Conta` = %i ORDER BY `ID` ASC LIMIT "#MAX_ACCOUNT_CHARACTER";", AccountData[playerid][e_ACCOUNT_ID]);
	mysql_tquery (MYSQL_CUR_HANDLE, query, "OnCharactersListCreate", "i", playerid);
	return true;
}

HidePlayerCharacters(playerid)
{
	s_pCharacterSelection{playerid} = false;
	CancelSelectTextDraw(playerid);

	for (new i = 0; i < sizeof s_ptdButton[]; i++)
	{
		if (s_ptdButton[playerid][i][e_TD_BTN_BUTTON] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_BUTTON] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawHide(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON]);
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawHide(playerid, s_ptdButton[playerid][i][e_TD_BTN_BACKGROUND]);
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_PREVIEW] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_PREVIEW] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawHide(playerid, s_ptdButton[playerid][i][e_TD_BTN_PREVIEW]);
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_TEXT] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_TEXT] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawHide(playerid, s_ptdButton[playerid][i][e_TD_BTN_TEXT]);
		}

		if (s_ptdButton[playerid][i][e_TD_BTN_CUT] != PlayerText:0 && s_ptdButton[playerid][i][e_TD_BTN_CUT] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawHide(playerid, s_ptdButton[playerid][i][e_TD_BTN_CUT]);
		}
	}

	// Hide No Characters
	for (new i = 0; i < sizeof s_tdNoCharacters; i++)
	{
		TextDrawHideForPlayer(playerid, s_tdNoCharacters[i]);
	}

	// Hide Body
	for (new i = 0; i < sizeof s_tdBackground; i++)
	{
		TextDrawHideForPlayer(playerid, s_tdBackground[i]);
	}

	// Hide Breadcump
	PlayerTextDrawHide(playerid, s_ptdBreadcump[playerid]);

	s_pCharacterSelectedIndex[playerid] = -1;
	return true;
}

SelectCharacterIndex(playerid, index)
{
	if (!IsPlayerConnected(playerid))
		return false;

	if (!(-1 <= index < MAX_ACCOUNT_CHARACTER))
		return false;

	if (index != -1 && s_pCharacterIds[playerid][index] == -1)
		return false;

	for (new i = 0; i < MAX_ACCOUNT_CHARACTER; i++)
	{
		if (s_ptdButton[playerid][i][e_TD_BTN_BUTTON] == PlayerText:INVALID_TEXT_DRAW)
			continue;

		if (s_pCharacterIds[playerid][i] == -1)
			continue;

		PlayerTextDrawColor(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON], ((index != -1 && i == index) ? 0x0095FFFF : 0x5f5f5fFF));
		PlayerTextDrawShow(playerid, s_ptdButton[playerid][i][e_TD_BTN_BUTTON]);
	}

	if (index == -1)
	{
		Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCharacterSkinActor[playerid], E_STREAMER_INTERIOR_ID, 1);
		SetDynamicObjectMaterialText(s_pCharacterNameObject[playerid], 0, "Carregando...", 130, "Arial", 45, 1, 0xFFFFFFFF, 0, 1);
	}
	else
	{
		Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCharacterSkinActor[playerid], E_STREAMER_MODEL_ID, s_pCharacterSkin[playerid][index]);
		Streamer_SetIntData(STREAMER_TYPE_ACTOR, s_pCharacterSkinActor[playerid], E_STREAMER_INTERIOR_ID, 0);
		SetDynamicObjectMaterialText(s_pCharacterNameObject[playerid], 0, s_pCharacterName[playerid][index], 130, "Arial", 45, 1, 0xFFFFFFFF, 0, 1);
	}

	Streamer_Update(playerid, -1);
	s_pCharacterSelectedIndex[playerid] = index;
	return true;
}