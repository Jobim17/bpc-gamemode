/*
	      .o.                                                   o8o
	     .888.                                                  `"'
	    .8"888.      .oooooooo  .ooooo.  ooo. .oo.    .ooooo.  oooo   .oooo.
	   .8' `888.    888' `88b  d88' `88b `888P"Y88b  d88' `"Y8 `888  `P  )88b
	  .88ooo8888.   888   888  888ooo888  888   888  888        888   .oP"888
	 .8'     `888.  `88bod8P'  888    .o  888   888  888   .o8  888  d8(  888
	o88o     o8888o `8oooooo.  `Y8bod8P' o888o o888o `Y8bod8P' o888o `Y888""8o
	                d"     YD
	                "Y88888P'

*/

// Dialogs
Dialog:DIALOG_AGENCIA(playerid, response, listitem, inputtext[])
{
	if (!response || !(0 <= listitem < MAX_JOB)) return true;

	if (CharacterData[playerid][e_CHARACTER_JOB] == listitem)
		return SendErrorMessage(playerid, "Você está nesse emprego atualmente.");

	if (CharacterData[playerid][e_CHARACTER_JOB] != -1 && CharacterData[playerid][e_CHARACTER_JOB_HOURS][CharacterData[playerid][e_CHARACTER_JOB]] < 3)
		return SendErrorMessage(playerid, "Você precisa ter pelo menos 3 horas trabalhadas para trocar de emprego.");
		
	CharacterData[playerid][e_CHARACTER_JOB] = listitem;
	SendClientMessageEx(playerid, COLOR_GREEN, "Você agora é um %s.", g_aJobNames[listitem]);
	Character_Save(playerid);
	return true;
}

// Functions
ShowPlayerJobList(playerid)
{
	new dialog[1024] = "{FFFFFF}Emprego";

	for (new i = 0; i < MAX_JOB; i++)
	{
		strcat (dialog, "\n{FFFFFF}");
		strcat (dialog, g_aJobNames[i]);
	}

	Dialog_Show(playerid, DIALOG_AGENCIA, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Agência de Empregos", dialog, "Pegar", "Fechar");
	return true;
}

// Comandos
CMD:agencia(playerid)
{
	new id;

	id = Interact_Nearest(playerid);

	if (id == -1 || InteractData[id][e_INTERACT_TYPE] != INTERACT_TYPE_AGENCIA_EMPREGOS)
		return SendErrorMessage(playerid, "Você não está em uma agência de empregos.");

	ShowPlayerJobList(playerid);
	return true;
}