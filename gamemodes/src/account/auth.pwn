/*
	      .o.                       .   oooo                                  .    o8o                          .    o8o
	     .888.                    .o8   `888                                .o8    `"'                        .o8    `"'
	    .8"888.     oooo  oooo  .o888oo  888 .oo.    .ooooo.  ooo. .oo.   .o888oo oooo   .ooooo.   .oooo.   .o888oo oooo   .ooooo.  ooo. .oo.
	   .8' `888.    `888  `888    888    888P"Y88b  d88' `88b `888P"Y88b    888   `888  d88' `"Y8 `P  )88b    888   `888  d88' `88b `888P"Y88b
	  .88ooo8888.    888   888    888    888   888  888ooo888  888   888    888    888  888        .oP"888    888    888  888   888  888   888
	 .8'     `888.   888   888    888 .  888   888  888    .o  888   888    888 .  888  888   .o8 d8(  888    888 .  888  888   888  888   888
	o88o     o8888o  `V88V"V8P'   "888" o888o o888o `Y8bod8P' o888o o888o   "888" o888o `Y8bod8P' `Y888""8o   "888" o888o `Y8bod8P' o888o o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define MAX_LOGIN_ATTEMP 5
#define MAX_LOGIN_TIME 	 120

#define MAX_PASS_LEN 20
#define MIN_PASS_LEN 4

// Forwards
forward OnAccountCreated(playerid);
forward OnAccountLoggedIn(playerid);
forward OnAccountLoggedOut(playerid, reason);
forward OnCharacterLoaded(playerid);
forward OnCharacterSaved(playerid);

// Variáveis
static bool:s_pIsLogged[MAX_PLAYERS char] = {false, ...};
static s_pLoginAttemps[MAX_PLAYERS] = {0, ...};

// Callbacks
hook OnPlayerConnect(playerid)
{
	AccountData[playerid] = AccountData[MAX_PLAYERS];

	s_pIsLogged{playerid} = false;
	s_pLoginAttemps[playerid] = 0;
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (IsPlayerLogged(playerid))
	{
		Account_Save(playerid);
		CallRemoteFunction("OnAccountLoggedOut", "ii", playerid, reason);
	}

	return true;
}

hook OnPlayerText(playerid, text[])
{
	if (GetPlayerVirtualWorld(playerid) == WORLD_PLAYER_LOGIN)
		return Y_HOOKS_CONTINUE_RETURN_0;

	return true;
}

hook OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if (GetPlayerVirtualWorld(playerid) == WORLD_PLAYER_LOGIN)
		return Y_HOOKS_CONTINUE_RETURN_0;

	return true;
}

public OnPlayerRequestLogin(playerid, accountid)
{	
	AccountData[playerid][e_ACCOUNT_ID] = accountid;

	if (strfind(ReturnPlayerName(playerid), "_") != -1)
	{
		KickPlayer(playerid);
		Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Seu nome de usuário não pode conter underline.", "Fechar", "");
		return true;
	}

	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, WORLD_PLAYER_LOGIN);
	TogglePlayerSpectating(playerid, true);
	Auth_SetPlayerCamera(playerid);
	ClearPlayerMessages(playerid);
	
	if (GetGVarInt("CLOSED_BETA") == 1)
	{
		inline ClosedBeta_Check()
		{
			if (!cache_num_rows())
			{
				KickPlayer(playerid);
				Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Seu nome não foi encontrado na lista branca da Closed Beta.", "Fechar", "");
				return true;
			}
			else
			{
				Auth_ShowDialog(playerid);
			}
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline ClosedBeta_Check, "SELECT `Nome` FROM `ClosedBeta` WHERE `Nome` = '%e' LIMIT 1;", ReturnPlayerName(playerid));
	}	
	else
	{
		Auth_ShowDialog(playerid);
	}

	return true;
}

hook Server_OnUpdate()
{
	if (!(gettime() % 60 * 5))
	{
		foreach (new i : Player)
		{
			if (IsPlayerLogged(i) && CharacterData[i][e_CHARACTER_ID] && CharacterData[i][e_CHARACTER_NAME][0] != '\0')
			{
				Account_Save(i);
			}
		}
	}

	foreach (new i : Player)
	{
		if (IsPlayerLogged(i)) continue;
		if (NetStats_GetConnectedTime(i) < (MAX_LOGIN_TIME * 1000)) continue;

		KickPlayer(i);
		Dialog_Show(i, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "Você atingiu o limite de "#MAX_LOGIN_TIME" segundos para autenticação.", "Fechar", "");
	}
	return true;
}

hook OnAccountLoggedIn(playerid)
{
	foreach (new i : Player)
	{
		if (IsPlayerLogged(i) && AccountData[i][e_ACCOUNT_ID] == AccountData[playerid][e_ACCOUNT_ID] && i != playerid)
		{
			KickPlayer(playerid);
			Dialog_Show(i, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Alguém está conectado nesta conta.", "Fechar", "");
			return false;
		}
	}

	return true;
}

hook OnAccountCreated(playerid)
{
	CallRemoteFunction("OnAccountLoggedIn", "i", playerid);
	return true;
}

// Dialogs
Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Você optou por não realizar a autenticação.", "Fechar", "");
		KickPlayer(playerid);
		return false;
	}

	if (!IsValidPassword(inputtext))
	{
		Auth_ShowDialog(playerid, "Você inseriu uma senha inválida.");
		return true;
	}

	inline Account_OnFound()
	{
		if (!cache_num_rows())
		{
			if (++s_pLoginAttemps[playerid] >= MAX_LOGIN_ATTEMP)
			{
				Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Você atingiu o limite de "#MAX_LOGIN_ATTEMP" tentativas de autenticação.", "Fechar", "");
				KickPlayer(playerid);
				return false;
			}

			Auth_ShowDialog(playerid, "Você inseriu uma senha incorreta, tente novamente.");
			return false;
		}

		s_pIsLogged{playerid} = true;
		Account_Load(playerid);
		CallRemoteFunction("OnAccountLoggedIn", "i", playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Account_OnFound, "SELECT * FROM `Contas` WHERE `ID` = %i AND `Senha` = MD5('%e') LIMIT 1;", AccountData[playerid][e_ACCOUNT_ID], inputtext);
	return true;
}

Dialog:DIALOG_REGISTRO(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "{FF5555}Desconectado", "{FFFFFF}Você optou por não realizar o registro.", "Fechar", "");
		KickPlayer(playerid);
		return false;
	}

	if (!IsValidPassword(inputtext))
	{
		Auth_ShowDialog(playerid, "Você inseriu uma senha inválida.");
		return true;
	}

	s_pIsLogged{playerid} = true;
	Account_Create(playerid, inputtext);
	return true;
}

// Functions
Auth_ShowDialog(playerid, const err[] = "")
{
	if (!IsPlayerConnected(playerid))
		return false;

	new dialog[2256];

	if (!IsNull(err))
	{
		dialog = "{FF5555}";
		strcat (dialog, err);
		strcat (dialog, "\n\n");
	}

	strcat (dialog, "{FFFFFF}Bem-vindo(a) ao {0096FF}Brasil Project City{FFFFFF}!\n\n");
	
	strcat (
		dialog, 
		va_return(
			AccountData[playerid][e_ACCOUNT_ID] == -1 ? 
			("Você está inserindo a senha para registrar sua conta ({AFAFAF}%s{FFFFFF})") : 
			("Você está inserindo a senha para autenticar sua conta ({AFAFAF}%s{FFFFFF})"), 
			ReturnPlayerName(playerid)
		)
	);

	strcat (dialog, ", nós da equipe administrativa\n");

	strcat (
		dialog, 
		va_return(
			"ficamos felizes em vê-lo(a) %s em nosso servidor! Prezamos por um ambiente\n",
			AccountData[playerid][e_ACCOUNT_ID] == -1 ? 
			("pela primeira vez") : 
			("novamente")
		)
	);

	strcat (dialog, "limpo e organizado para proporcionar infinitas interpretações, divirta-se!\n\n");

	strcat (dialog, "Sua senha deve seguir os seguintes requisitos:\n");
	strcat (dialog, "{AFAFAF}-\tDeve conter de "#MIN_PASS_LEN" a "#MAX_PASS_LEN" caracteres.\n");
	strcat (dialog, "-\tDeve conter apenas caracteres alfa númericos (a-Z, 0-9, etc.)\n\n{FFFFFF}");

	strcat (dialog, "Enfrentando problemas?\n");
	strcat (dialog, "{AFAFAF}-\tContate um membro da equipe de desenvolvimento; ou\n");
	strcat (dialog, "-\tReporte no canal {0095FF}#bug-report{AFAFAF} em nosso Discord: {0095FF}"SERVER_WEBURL"");

	if (AccountData[playerid][e_ACCOUNT_ID] != -1)
	{
		strcat (dialog, va_return("\n\n{FFFFFF}* Você tem {AFAFAF}%i{FFFFFF} tentativa(s) de autenticação.", MAX_LOGIN_ATTEMP - s_pLoginAttemps[playerid]));
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FFFFFF}Login", dialog, "Login", "Sair");
	}
	else
	{
		Dialog_Show(playerid, DIALOG_REGISTRO, DIALOG_STYLE_INPUT, "{FFFFFF}Registro", dialog, "Registro", "Sair");
	}

	return true;
}

Auth_SetPlayerCamera(playerid)
{
	switch (random(6))
	{	
        // Alhambra
        case 0: {
            InterpolateCameraPos(playerid, 1400.400878, -1737.014526, 92.646148, 1771.815063, -1741.581420, 70.703231, 9000);
            InterpolateCameraLookAt(playerid, 1405.239013, -1736.679199, 91.429573, 1775.731933, -1739.247680, 68.650878, 9000);
        }

        // Glen Park
        case 1: {
            InterpolateCameraPos(playerid, 2067.357421, -1914.845458, 77.126457, 2162.559814, -1563.017700, 63.680793, 7000);
            InterpolateCameraLookAt(playerid, 2068.106201, -1909.954223, 76.408630, 2162.281738, -1558.047241, 63.214595, 7000);
        }

        // Idlewood
        case 2: {
            InterpolateCameraPos(playerid, 1840.053344, -1733.400756, 60.931621, 1963.133422, -1763.364624, 77.835762, 7000);
            InterpolateCameraLookAt(playerid, 1844.712890, -1733.955444, 59.204956, 1967.605834, -1763.862426, 75.656295, 7000);
        }

        // Mulholand
        case 3: {
            InterpolateCameraPos(playerid, 1406.090942, -890.649230, 95.371109, 1543.376586, -897.526977, 104.968841, 7000);
            InterpolateCameraLookAt(playerid, 1406.484863, -885.718322, 94.642463, 1546.230346, -901.473266, 103.836219, 7000);
        }

        // Pershing Square
        case 4: {
            InterpolateCameraPos(playerid, 1766.647705, -1799.999511, 83.710655, 1555.844116, -1599.263793, 101.893363, 9000);
            InterpolateCameraLookAt(playerid, 1762.219238, -1797.717407, 83.286163, 1552.842041, -1601.462524, 98.553779, 9000);
        }

        // Vinewood
        case 5: {
            InterpolateCameraPos(playerid, 1109.423706, -956.851989, 89.084526, 1323.938842, -903.115905, 113.600677, 9000);
            InterpolateCameraLookAt(playerid, 1104.463378, -957.352600, 88.703643, 1327.557739, -899.820861, 112.577796, 9000);
        }
	}

	return true;
}

IsValidPassword(const pass[])
{
	if (!(MIN_PASS_LEN <= strlen(pass) <= MAX_PASS_LEN))
		return false;

	if (strfind(pass, " ") != -1)
		return false;

	return true;
}

IsPlayerLogged(playerid)
{
	if (!IsPlayerConnected(playerid))
		return false;

	return s_pIsLogged{playerid};
}