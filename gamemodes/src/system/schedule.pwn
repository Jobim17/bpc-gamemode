/*
	 .oooooo..o                                                         .oooooo..o           oooo                        .o8              oooo
	d8P'    `Y8                                                        d8P'    `Y8           `888                       "888              `888
	Y88bo.       .ooooo.  oooo d8b oooo    ooo  .ooooo.  oooo d8b      Y88bo.       .ooooo.   888 .oo.    .ooooo.   .oooo888  oooo  oooo   888   .ooooo.
	 `"Y8888o.  d88' `88b `888""8P  `88.  .8'  d88' `88b `888""8P       `"Y8888o.  d88' `"Y8  888P"Y88b  d88' `88b d88' `888  `888  `888   888  d88' `88b
	     `"Y88b 888ooo888  888       `88..8'   888ooo888  888               `"Y88b 888        888   888  888ooo888 888   888   888   888   888  888ooo888
	oo     .d8P 888    .o  888        `888'    888    .o  888          oo     .d8P 888   .o8  888   888  888    .o 888   888   888   888   888  888    .o
	8""88888P'  `Y8bod8P' d888b        `8'     `Y8bod8P' d888b         8""88888P'  `Y8bod8P' o888o o888o `Y8bod8P' `Y8bod88P"  `V88V"V8P' o888o `Y8bod8P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Variáveis
static bool:s_lockedServer = false;

// Callbacks
hook OnGameModeInit()
{
	s_lockedServer = false;
	SendRconCommand("password testbpcnew");
	SendRconCommand("unloadfs objects");
	SendRconCommand("loadfs objects");
	return true;
}

hook Server_OnUpdate()
{
	new hour, minute;
	gettime(hour, minute);

	if (hour == 4 && minute == 50 && !s_lockedServer)
	{
		Log_Create("Schedule", "Schedule state #1");

		for (new i = 0; i < 20; i++)
			SendClientMessageToAllEx(-1, "	");

		s_lockedServer = true;
		SendRconCommand("password restartingjobim176");
		SendRconCommand("hostname "SERVER_HOSTNAME" | Reiniciando...");
		SendClientMessageToAllEx(COLOR_LIGHTRED, "SERVER: O servidor será reiniciado automaticamente em 10 minutos.");
		SendClientMessageToAllEx(COLOR_LIGHTRED, "SERVER: Finalize o que está fazendo e desconecte-se.");
		SendClientMessageToAllEx(COLOR_LIGHTRED, "SERVER: Você será automaticamente desconectado em 5 minutos.");

		foreach (new i : Player)
		{
			if (IsPlayerLogged(i))
			{
				Account_Save(i);
			}

			if (CharacterData[i][e_CHARACTER_ID])
			{
				Character_Save(i);
			}

			if (!IsPlayerLogged(i) && CharacterData[i][e_CHARACTER_ID])
			{
				SendClientMessageEx(i, COLOR_LIGHTRED, "SERVER: O servidor será reiniciado, você foi automaticamente desconectado.");
				KickPlayer(i);
			}
		}
	}

	if (hour == 4 && minute == 55 && s_lockedServer && Iter_Count(Player))
	{
		Log_Create("Schedule", "Schedule state #2");

		for (new i = 0; i < 20; i++)
			SendClientMessageToAllEx(-1, "	");

		SendClientMessageToAllEx(COLOR_LIGHTRED, "SERVER: O servidor será reiniciado em 5 minutos, você foi desconectado.");

		foreach (new i : Player)
		{
			if (IsPlayerLogged(i))
			{
				Account_Save(i);
			}

			if (CharacterData[i][e_CHARACTER_ID])
			{
				Character_Save(i);
			}

			KickPlayer(i);
		}
	}

	if (hour == 5 && s_lockedServer)
	{
		Log_Create("Schedule", "Schedule state #3");
		s_lockedServer = false;
		SendRconCommand("gmx");
	}

	return true;
}