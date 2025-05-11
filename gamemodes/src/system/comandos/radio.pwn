/*
	ooooooooo.                   .o8   o8o
	`888   `Y88.                "888   `"'
	 888   .d88'  .oooo.    .oooo888  oooo   .ooooo.
	 888ooo88P'  `P  )88b  d88' `888  `888  d88' `88b
	 888`88b.     .oP"888  888   888   888  888   888
	 888  `88b.  d8(  888  888   888   888  888   888
	o888o  o888o `Y888""8o `Y8bod88P" o888o `Y8bod8P'
	
*/

// Functions
Radio_SendMessage(channel, const msg[], va_args<>)
{
	new out[256], size;
	va_format(out, sizeof out, msg, va_start<2>);
	size = strlen(out);

	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
			continue;

		if (!Inventory_HasItem(i, "Rádio") || !Radio_CheckChannel(i, channel))
			continue;

		// Main Channel
		if (CharacterData[i][e_CHARACTER_RADIO_CHANNELS][0] == channel)
		{
			SendClientMessageEx(i, COLOR_RADIO, "** [CH: %i S: 1] %.64s", channel, out);
			
			if (size > 64)
			{
				SendClientMessageEx(i, COLOR_RADIO, "...%s", out[64]);
			}
			
			continue;
		}

		// Other Slots
		for (new j = 1; j < MAX_RADIO_SLOTS; j++)
		{
			if (CharacterData[i][e_CHARACTER_RADIO_CHANNELS][j] == channel)
			{
				SendClientMessageEx(i, COLOR_RADIOEX, "** [CH: %i S: %i] %.64s", channel, j + 1, out);
				
				if (size > 64)
				{
					SendClientMessageEx(i, COLOR_RADIOEX, "...%s", out[64]);
				}
				
				continue;
			}
		}
	}

	return true;
}

Radio_CheckChannel(playerid, channel)
{
	new type = Faction_GetPlayerType(playerid);

	if ((channel == 190 || channel == 197) && type != FACTION_TYPE_POLICE)
		return false;

	if (channel == 193 && type != FACTION_TYPE_MEDIC)
		return false;

	return true;
}

Radio_Process(playerid, slot, bool:isLow, const text[])
{
	if(!CharacterData[playerid][e_CHARACTER_RADIO_ON])
		return SendErrorMessage(playerid, "Seu rádio está desligado.");

    if (!Inventory_HasItem(playerid, "Rádio"))
	    return SendErrorMessage(playerid, "Você precisa de um rádio portatil.");

	if (CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][slot] < 1)
	{
	    return SendErrorMessage(playerid, "Seu rádio está sem canal. (/radio canal %i)", slot + 1);
	}

	static out[256], vehicleid;

	if (isLow)
	{
		format (out, sizeof out, "(rádio) [baixo] %s: %s", Character_GetName(playerid), text);
	}
	else
	{
		format (out, sizeof out, "(rádio) %s: %s", Character_GetName(playerid), text);
	}

	vehicleid = GetPlayerVehicleID(playerid);

	Radio_SendMessage(CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][slot], "%s%s: %s", isLow ? ("[baixo] ") : (""), Character_GetName(playerid), text);

	if (IsPlayerInAnyVehicle(playerid) && IsValidVehicle(vehicleid) && IsWindowedVehicle(vehicleid) && IsWindowClosed(vehicleid))
	{
		SendVehicleMessage(vehicleid, COLOR_FADE1, "[Janelas Fechadas] %s", out);
	}
	else
	{
		SendProxMessage(isLow ? 5.0 : 15.0, playerid, "%.64s", out);

		if (strlen(out) > 64)
		{
			SendProxMessage(isLow ? 5.0 : 15.0, playerid, "...%s", out[64]);
		}	
	}

	return true;
}

// Comandos
CMD:radio(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Rádio"))
	    return SendErrorMessage(playerid, "Você não possui um rádio.");

	new type[16], string[64];

	if (sscanf(params, "s[16]S()[64]", type, string))
 	{
 	    SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		SendClientMessage(playerid, COLOR_BEGE, "USE: /radio [opção]");
		SendClientMessage(playerid, COLOR_BEGE, "[Opções]: status, canal, meuscanais");
		SendClientMessage(playerid, COLOR_BEGE, "[Informação]: Use a opção 'canal' para definir a frequência do seu rádio nos canais disponíveis.");
		SendClientMessage(playerid, COLOR_BEGE, "[Informação]: Para ativar ou desativar a transmissão do rádio use a opção 'status'.");
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		return 1;
	}
	else if(!strcmp(type, "status", true))
	{
		CharacterData[playerid][e_CHARACTER_RADIO_ON] = !CharacterData[playerid][e_CHARACTER_RADIO_ON];
		SendClientMessage(playerid, -1, CharacterData[playerid][e_CHARACTER_RADIO_ON] ? ("Você ligou seu rádio.") : ("Você desligou seu rádio."));
	}
	else if(!strcmp(type, "canal", true))
	{
		new channel, slot;

		if (sscanf(string, "ii", slot, channel))
		 	return SendClientMessage(playerid, COLOR_BEGE, "USE: /radio canal [slot] [frequência (use 0 para desativar)]");

		if (!(1 <= slot <= MAX_RADIO_SLOTS))
			return SendErrorMessage(playerid, "O slot do canal deve estar entre 1 e "#MAX_RADIO_SLOTS".");

		if (channel == 0)
		{
			CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][slot - 1] = 0;
			SendClientMessageEx(playerid, -1, "Você desativou as transmissões do slot %i.", slot);
			return 1;
		}

		if (channel < 0 || channel > 9999999)
	    	return SendErrorMessage(playerid, "A frequência de rádio deve estar entre 0 e 9999999.");

		if (!(1 <= slot <= MAX_RADIO_SLOTS))
			return SendErrorMessage(playerid, "O slot do canal deve estar entre 1 e "#MAX_RADIO_SLOTS".");

		for (new i = 0; i < MAX_RADIO_SLOTS; i++)
		{
			if (CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][i] == channel)
			{
				SendErrorMessage(playerid, "Você não pode sintonizar na mesma frequência utilizado em outros canais.");
				return true;
			}
		}

		if (!Radio_CheckChannel(playerid, slot))
			return SendErrorMessage(playerid, "Você não está autorizado a usar esta frequência.");


		CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][slot - 1] = channel;

		if (slot == 1)
		{
			SendClientMessageEx(playerid, -1, "Você mudou a frequência do canal %i para %i (\"/r [texto]\" para falar nesta frequência).", slot, channel);
		}
		else
		{
			SendClientMessageEx(playerid, -1, "Você mudou a frequência do canal %i para %i (\"/r%i [texto]\" para falar nesta frequência).", slot, channel, slot);
		}
	}
	else if(!strcmp(type, "meuscanais", true))
	{
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
		SendClientMessageEx(playerid, COLOR_BEGE, "CH-1: %i", CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][0]);
		SendClientMessageEx(playerid, COLOR_BEGE, "CH-2: %i", CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][1]);
		SendClientMessageEx(playerid, COLOR_BEGE, "CH-3: %i", CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][2]);
		SendClientMessageEx(playerid, COLOR_BEGE, "CH-4: %i", CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][3]);
		SendClientMessageEx(playerid, COLOR_BEGE, "CH-5: %i", CharacterData[playerid][e_CHARACTER_RADIO_CHANNELS][4]);
		SendClientMessage(playerid, COLOR_BEGE, "_____________________________________________");
	}
	return 1;
}

CMD:r(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r [texto a ser enviado no rádio]");

	Radio_Process(playerid, 0, false, params);
	return 1;
}

CMD:r2(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r2 [texto a ser enviado no rádio]");

	Radio_Process(playerid, 1, false, params);
	return 1;
}

CMD:r3(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r3 [texto a ser enviado no rádio]");

	Radio_Process(playerid, 2, false, params);
	return 1;
}

CMD:r4(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r4 [texto a ser enviado no rádio]");

	Radio_Process(playerid, 3, false, params);
	return 1;
}

CMD:r5(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r5 [texto a ser enviado no rádio]");

	Radio_Process(playerid, 4, false, params);
	return 1;
}

CMD:rbaixo(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/rbaixo [texto a ser enviado no rádio]");

	Radio_Process(playerid, 0, true, params);
	return 1;
}

CMD:r2baixo(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r2baixo [texto a ser enviado no rádio]");

	Radio_Process(playerid, 1, true, params);
	return 1;
}

CMD:r3baixo(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r3baixo [texto a ser enviado no rádio]");

	Radio_Process(playerid, 2, true, params);
	return 1;
}

CMD:r4baixo(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r4baixo [texto a ser enviado no rádio]");

	Radio_Process(playerid, 3, true, params);
	return 1;
}

CMD:r5baixo(playerid, params[])
{
	if (IsNull(params))
	    return SendUsageMessage(playerid, "/r5baixo [texto a ser enviado no rádio]");

	Radio_Process(playerid, 4, true, params);
	return 1;
}