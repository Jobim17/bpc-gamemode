/*
	  .oooooo.                                                           .o8
	 d8P'  `Y8b                                                         "888
	888           .ooooo.  ooo. .oo.  .oo.    .oooo.   ooo. .oo.    .oooo888   .ooooo.   .oooo.o
	888          d88' `88b `888P"Y88bP"Y88b  `P  )88b  `888P"Y88b  d88' `888  d88' `88b d88(  "8
	888          888   888  888   888   888   .oP"888   888   888  888   888  888   888 `"Y88b.
	`88b    ooo  888   888  888   888   888  d8(  888   888   888  888   888  888   888 o.  )88b
	 `Y8bood8P'  `Y8bod8P' o888o o888o o888o `Y888""8o o888o o888o `Y8bod88P" `Y8bod8P' 8""888P'
	
*/

CMD:aa(playerid)
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN))
		return false;

	SendClientMessage(playerid, COLOR_GREEN, "|____________________________________________________________|");

	// Property Team
	if (Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Property Team] /criarentrada, /editarentrada, /destruirentrada, /criarinteracao, /destruirinteracao");
		SendClientMessage(playerid, COLOR_BEGE, "[Property Team] /criarempresa, /editarempresa, /destruirempresa, /criarbomba, /editarboma, /destruirbomba, /criarcasa, /editarcasa");
		SendClientMessage(playerid, COLOR_BEGE, "[Property Team] /criarempresa, /destruircasa");
	}

	// Faction Team
	if (Admin_CheckTeam(playerid, e_ADMIN_TEAM_PROPERTY, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Faction Team] /criarfaccao, /editarfaccao, /destruirfaccao, /setlider");
	}

	// Junior Admin
	if (Admin_CheckPermission(playerid, JUNIOR_ADMIN, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Junior Admin] /aduty, /(a)dmin, /logs, /lerlog, /buscarlog, /ir, /trazer");	
	}

	// Game Admin I
	if (Admin_CheckPermission(playerid, GAME_ADMIN_I, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Game Admin I] /noclip, /ircoord, /setmundo, /setinterior, /reviver");	
	}

	// Game Admin II
	if (Admin_CheckPermission(playerid, GAME_ADMIN_II, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Game Admin II] /setskin, /setcolete, /setvida, /checaratividade");
	}

	// Sênior Admin
	if (Admin_CheckPermission(playerid, SENIOR_ADMIN, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Sênior Admin] /admhide, /dararma");
	}

	// Lead Admin
	if (Admin_CheckPermission(playerid, LEAD_ADMIN, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Lead Admin] /gerenciar, /reloadmaps, /dardinheiro");	
	}

	// Manager
	if (Admin_CheckPermission(playerid, MANAGER, .sendMessage = false))
	{
		SendClientMessage(playerid, COLOR_BEGE, "[Manager] /setadmin");	
	}

	SendClientMessage(playerid, COLOR_GREEN, "|____________________________________________________________|");
	return true;
}

// Level 1 (Junior Admin)
CMD:aduty(playerid)
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN))
		return false;

	AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] = !AccountData[playerid][e_ACCOUNT_ADMIN_DUTY];
	Admin_SendMessage(1, COLOR_YELLOW, "AdmCmd: %s está agora %s serviço administrativo.", AccountData[playerid][e_ACCOUNT_NAME], (AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] ? ("em") : ("fora de")));
	Character_UpdateColor(playerid);
	Nametag_Update(playerid);
	return true;
}

alias:a("admin")
CMD:a(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN))
		return false;

	if (IsNull(params))
		return SendUsageMessage(playerid, "/(a)dmin [Mensagem]");

	Admin_SendMessage(1, COLOR_ADMINCHAT, "[Staff] %s %s (%s): %.48s", Admin_LevelName(AccountData[playerid][e_ACCOUNT_ADMIN]), Character_GetName(playerid, false), AccountData[playerid][e_ACCOUNT_NAME], params);
	
	if (strlen(params) > 48)
	{
		Admin_SendMessage(1, COLOR_ADMINCHAT, "...%s", params[48]);
	}

	return true;
}

CMD:logs(playerid)
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN))
		return false;

	Log_Show(playerid, .bSearch = false);
	return true;
}

CMD:lerlog(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN))
		return false;

	Log_Show(playerid, params, .bSearch = false);
	return true;
}

CMD:buscarlog(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN))
		return false;

	Log_Show(playerid, params, .bSearch = true);
	return true;
}

CMD:ir(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, JUNIOR_ADMIN, true))
		return false;

	static target, type[24], string[64];

	if (sscanf(params, "u", target))
	{
		SendClientMessage(playerid, COLOR_BEGE, "USE: /ir [id/player/ppção]");
		SendClientMessage(playerid, COLOR_BEGE, "[Opções]: spawn, entrada, interação, empresa, estoque, casa");
		return true;
	}

	if (target == INVALID_PLAYER_ID)
	{
	    if (sscanf(params, "s[24]S()[64]", type, string))
		{
			SendClientMessage(playerid, COLOR_BEGE, "USE: /ir [id/player/ppção]");
			SendClientMessage(playerid, COLOR_BEGE, "[Opções]: spawn, entrada, interação, empresa, estoque, casa");
			return 1;
	    }

	    if (!strcmp(type, "spawn", true))
	    {
	    	SetPlayerPos(playerid, 1714.8267, -1880.2123, 13.5666);
	    	SetPlayerFacingAngle(playerid, 356.0);
	    	SetPlayerInterior(playerid, 0);
	    	SetPlayerVirtualWorld(playerid, 0);
	    	SetCameraBehindPlayer(playerid);

	    	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi para o spawn padrão do servidor.", AccountData[playerid][e_ACCOUNT_NAME]);
	    	SendClientMessage(playerid, -1, "Você foi teleportado para o spawn padrão do servidor.");
	    }
	    else if(!strcmp(type, "entrada", true))
	    {
		    if (sscanf(string, "d", target))
		        return SendUsageMessage(playerid, "/ir entrada [EntradaID]");

			if ((target < 0 || target >= MAX_ENTRANCES) || !EntranceData[target][e_ENTRANCE_EXISTS])
			    return SendErrorMessage(playerid, "Você especificou um ID de entrada inválido.");

			SetPlayerPos(playerid, EntranceData[target][e_ENTRANCE_POS][0], EntranceData[target][e_ENTRANCE_POS][1], EntranceData[target][e_ENTRANCE_POS][2]);
			SetPlayerInterior(playerid, EntranceData[target][e_ENTRANCE_INTERIOR]);
			SetPlayerVirtualWorld(playerid, EntranceData[target][e_ENTRANCE_WORLD]);

	    	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi para a entrada ID %i.", AccountData[playerid][e_ACCOUNT_NAME], target);
	    	SendClientMessageEx(playerid, COLOR_GREEN, "Você foi teleportado para a entrada ID %i.", target);
	    }
	    else if (!strcmp(type, "interação", true) || !strcmp(type, "interacao", true) || !strcmp(type, "interaçao", true) || !strcmp(type, "interacão", true))
	    {
	    	if (sscanf(string, "d", target))
		        return SendUsageMessage(playerid, "/ir entrada [EntradaID]");

			if ((target < 0 || target >= MAX_INTERACTS) || !InteractData[target][e_INTERACT_EXISTS])
			    return SendErrorMessage(playerid, "Você especificou um ID de entrada inválido.");

			SetPlayerPos(playerid, InteractData[target][e_INTERACT_POS][0], InteractData[target][e_INTERACT_POS][1], InteractData[target][e_INTERACT_POS][2]);
			SetPlayerInterior(playerid, InteractData[target][e_INTERACT_INTERIOR]);
			SetPlayerVirtualWorld(playerid, InteractData[target][e_INTERACT_WORLD]);

	    	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi para a interação ID %i.", AccountData[playerid][e_ACCOUNT_NAME], target);
	    	SendClientMessageEx(playerid, COLOR_GREEN, "Você foi teleportado para a interação ID %i.", target);
	    }
	    else if (!strcmp(type, "empresa", true))
	    {
	    	if (sscanf(string, "d", target))
		        return SendUsageMessage(playerid, "/ir empresa [EmpresaID]");

			if ((target < 0 || target >= MAX_BUSINESS) || !BusinessData[target][e_BUSINESS_EXISTS])
			    return SendErrorMessage(playerid, "Você especificou um ID de entrada inválido.");

			Character_SetPos(playerid, BusinessData[target][e_BUSINESS_POS][0], BusinessData[target][e_BUSINESS_POS][1], BusinessData[target][e_BUSINESS_POS][2], -1.0, BusinessData[target][e_BUSINESS_WORLD], BusinessData[target][e_BUSINESS_INTERIOR]);

	    	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi para a empresa ID %i.", AccountData[playerid][e_ACCOUNT_NAME], target);
	    	SendClientMessageEx(playerid, COLOR_GREEN, "Você foi teleportado para a empresa ID %i.", target);
	    }
	    else if (!strcmp(type, "estoque", true))
	    {
	    	if (sscanf(string, "d", target))
		        return SendUsageMessage(playerid, "/ir estoque [EstoqueID]");

			if ((target < 0 || target >= MAX_INDUSTRY_STORAGE) || !IndustryStorageData[target][e_INDUSTRY_STORAGE_EXISTS])
			    return SendErrorMessage(playerid, "Você especificou um ID de estoque inválido.");

			Character_SetPos(playerid, IndustryStorageData[target][e_INDUSTRY_STORAGE_POS][0], IndustryStorageData[target][e_INDUSTRY_STORAGE_POS][1], IndustryStorageData[target][e_INDUSTRY_STORAGE_POS][2], -1.0, IndustryStorageData[target][e_INDUSTRY_STORAGE_WORLD], IndustryStorageData[target][e_INDUSTRY_STORAGE_INTERIOR]);

	    	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi para o estoque ID %i.", AccountData[playerid][e_ACCOUNT_NAME], target);
	    	SendClientMessageEx(playerid, COLOR_GREEN, "Você foi teleportado para o estoque ID %i.", target);
	    }
	    else if (!strcmp(type, "casa", true))
	    {
	    	if (sscanf(string, "d", target))
		        return SendUsageMessage(playerid, "/ir casa [casa id]");

			if ((target < 0 || target >= MAX_HOUSES) || !HouseData[target][e_HOUSE_EXISTS])
			    return SendErrorMessage(playerid, "Você especificou um ID de casa inválido.");

			Character_SetPos(playerid, HouseData[target][e_HOUSE_POS][0], HouseData[target][e_HOUSE_POS][1], HouseData[target][e_HOUSE_POS][2], -1.0, HouseData[target][e_HOUSE_WORLD], HouseData[target][e_HOUSE_INTERIOR]);

	    	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi para a casa ID %i.", AccountData[playerid][e_ACCOUNT_NAME], target);
	    	SendClientMessageEx(playerid, COLOR_GREEN, "Você foi teleportado para a casa ID %i.", target);
	    }
	    else
	    {
	    	SendErrorMessage(playerid, "Você especificou uma opção inválida.");
	    }
	}
	else
	{
		if (!CheckTargetId(playerid, target, .self = false))
			return false;

		if (!CharacterData[target][e_CHARACTER_ID])
			return SendErrorMessage(playerid, "Jogador não está autenticado.");

		if (GetPlayerState(target) == PLAYER_STATE_SPECTATING)
			return SendErrorMessage(playerid, "Jogador está em modo espectador.");

		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
			return SendErrorMessage(playerid, "Você está em modo espectador.");
	
		new Float:x, Float:y, Float:z;
		GetPlayerPos(target, x, y, z);

		x += 1.5;
		y += 1.5;
		z += 0.5;

		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);

			SetVehiclePos(vehicleid, x, y, z);
			SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(target));
			LinkVehicleToInterior(vehicleid, GetPlayerInterior(target));

			foreach (new i : Player)
			{
				if (!IsPlayerInVehicle(i, vehicleid)) continue;

				SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(target));
				SetPlayerInterior(i, GetPlayerInterior(target));
			}
		}
		else
		{
			SetPlayerPos(playerid, x, y, z);
			SetPlayerInterior(playerid, GetPlayerInterior(target));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(target));
		}

		Log_Create("Admin CMD", "[IR] %s foi até a posição de %s", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target));
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s foi até a posição de %s.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target));
		SendClientMessageEx(playerid, COLOR_GREEN, "Você foi até a posição de %s.", Character_GetName(target));

		if (!AccountData[playerid][e_ACCOUNT_ADMIN_HIDE])
		{
			SendClientMessageEx(target, COLOR_GREEN, "Administrador %s foi até a sua posição.", AccountData[playerid][e_ACCOUNT_NAME]);
		}
	}

	return true;
}

// Level 2 (Game Admin I)
CMD:noclip(playerid)
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_I, true))
		return false;

	if (IsPlayerInNoClip(playerid))
	{
		SetPlayerCamera(playerid, 0);
		SendClientMessage(playerid, COLOR_GREEN, "Modo no-clip desativado.");
	}
	else
	{	
		Character_UpdateSpawn(playerid);
		SetPlayerCamera(playerid, 1);
		
		Log_Create("Admin CMD", "[NOCLIP] %s entrou em modo no-clip.", AccountData[playerid][e_ACCOUNT_NAME]);
		Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s está agora em modo no-clip.", AccountData[playerid][e_ACCOUNT_NAME]);
		SendClientMessage(playerid, COLOR_GREEN, "Modo no-clip ativado com sucesso.");
	}
	return true;
}

CMD:ircoord(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_I, true))
		return false;

	new Float:x, Float:y, Float:z;

	if (sscanf(params, "P<,>fff", x, y, z))
		return SendUsageMessage(playerid, "/ircoord [x, y, z] OU /ircoord [x] [y] [z]");

	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s teleportou-se para a posição %.01f, %.01f, %.01f", AccountData[playerid][e_ACCOUNT_NAME], x, y, z);
	Log_Create("Admin CMD", "[IRCOORD] %s foi para a posição %.01f, %.01f, %.01f", AccountData[playerid][e_ACCOUNT_NAME], x, y, z);
	SetPlayerPos(playerid, x, y, z);
	Streamer_UpdateEx(playerid, x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, -1, 1);
	SendClientMessageEx(playerid, -1, "Você foi teleportado para %f, %f, %f", x, y, z);
	return true;
}

CMD:setmundo(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_I, true))
		return false;

	static target, world;

	if (sscanf(params, "ui", target, world))
		return SendUsageMessage(playerid, "/setmundo [Nome/ParteDoNome/Id] [MundoId]");

	if (!(0 <= world < cellmax))
		return SendErrorMessage(playerid, "Use mundo de 0 a %s.", FormatNumber(cellmax - 1));

	if (!CheckTargetId(playerid, target, .adminCmd = true))
		return false;

	Log_Create("Admin CMD", "[SETMUNDO] %s usou no personagem %s (%s) - Mundo: %i", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], world);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s alterou o mundo virtual de %s para %i.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), world);
	SendClientMessageEx(playerid, -1, "Você alterou o mundo virutal de %s (%s) para %i.", Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], world);
	SendClientMessageEx(target, -1, "Administrador %s alterou seu mundo virtual para %i.", AccountData[playerid][e_ACCOUNT_NAME], world);
	SetPlayerVirtualWorld(target, world);
	return true;
}

CMD:setinterior(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_I, true))
		return false;

	static target, interior;

	if (sscanf(params, "ui", target, interior))
		return SendUsageMessage(playerid, "/setinterior [Nome/ParteDoNome/Id] [InteriorId]");

	if (!(0 <= interior < 255))
		return SendErrorMessage(playerid, "Use interior de 0 a 254.");

	if (!CheckTargetId(playerid, target, .adminCmd = true))
		return false;

	Log_Create("Admin CMD", "[SETINTERIOR] %s usou no personagem %s (%s) - Interior: %i", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], interior);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s alterou o interior de %s para %i.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), interior);
	SendClientMessageEx(playerid, -1, "Você alterou o interior de %s (%s) para %i.", Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], interior);
	SendClientMessageEx(target, -1, "Administrador %s alterou seu interior para %i.", AccountData[playerid][e_ACCOUNT_NAME], interior);
	SetPlayerInterior(target, interior);
	return true;
}

CMD:reviver(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_I, true))
		return false;

	static target;

	if (sscanf(params, "u", target))
		return SendUsageMessage(playerid, "/reviver [Nome/ParteDoNome/Id]");

	if (!CheckTargetId(playerid, target))
		return false;

	if (playerid == target && !Admin_CheckPermission(playerid, LEAD_ADMIN, .sendMessage = false))
		return SendErrorMessage(playerid, "Você não pode usar este comando em si mesmo.");

	if (Damage_IsAlive(target))
		return SendErrorMessage(playerid, "Este jogador não está morto ou brutalmente ferido.");

	Log_Create("Admin CMD", "[REVIVER] %s usou no personagem %s (%s)", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME]);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s reviveu o personagem %s.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false));
	SendClientMessageEx(playerid, -1, "Você reviveu o personagem %s.", Character_GetName(target, false));
	SendClientMessageEx(target, -1, "Administrador %s reviveu o seu personagem.", AccountData[playerid][e_ACCOUNT_NAME]);
	Damage_Revive(target);
	return true;
}

// Level 3 (Game Admin II)
CMD:setskin(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_II, true))
		return false;

	static target, skin;

	if (sscanf(params, "ui", target, skin))
		return SendUsageMessage(playerid, "/setskin [Nome/ParteDoNome/Id] [SkinId]");

	if (skin < 0 || skin == 74 || skin > 311 && skin < 20001 || skin > 30000)
		return SendErrorMessage(playerid, "Use skin ID de 0 a 311 ou de 20001 a 30000.");

	if (!CheckTargetId(playerid, target, .adminCmd = true))
		return false;

	Log_Create("Admin CMD", "[SETSKIN] %s usou no personagem %s (%s) - Skin: %i", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], skin);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s alterou a skin de %s para %i.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), skin);
	SendClientMessageEx(playerid, -1, "Você alterou a skin de %s (%s) para %i.", Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], skin);
	SendClientMessageEx(target, -1, "Administrador %s alterou sua skin para %i.", AccountData[playerid][e_ACCOUNT_NAME], skin);
	SetPlayerSkin(target, skin);
	CharacterData[target][e_CHARACTER_SKIN] = skin;
	Character_Save(target);
	return true;
}

CMD:setvida(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_II, true))
		return false;

	static target, Float:health;

	if (sscanf(params, "uf", target, health))
		return SendUsageMessage(playerid, "/setvida [Nome/ParteDoNome/Id] [Vida]");

	if (!(0.0 <= health <= 100.0))
		return SendErrorMessage(playerid, "Use vida de 0.0 a 100.0");

	if (!CheckTargetId(playerid, target, .adminCmd = true))
		return false;

	Log_Create("Admin CMD", "[SETVIDA] %s usou no personagem %s (%s) - Valor: %.1f", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], health);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s alterou a vida de %s para %.0f.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), health);
	SendClientMessageEx(playerid, -1, "Você alterou a vida de %s para %.0f.", Character_GetName(target, false), health);
	SetHealth(target, health);
	return true;
}

CMD:setcolete(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_II, true))
		return false;

	static target, Float:armour;

	if (sscanf(params, "uf", target, armour))
		return SendUsageMessage(playerid, "/setcolete [Nome/ParteDoNome/Id] [Colete]");

	if (!(0.0 <= armour <= 100.0))
		return SendErrorMessage(playerid, "Use colete de 0.0 a 100.0");

	if (!CheckTargetId(playerid, target, .adminCmd = true))
		return false;

	Log_Create("Admin CMD", "[SETCOLETE] %s usou no personagem %s (%s) - Valor: %.1f", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], armour);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s alterou o colete de %s para %.0f.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), armour);
	SendClientMessageEx(playerid, -1, "Você alterou o colete de %s para %.0f.", Character_GetName(target, false), armour);
	SetArmour(target, armour);
	return true;
}

CMD:checaratividade(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, GAME_ADMIN_II, true))
		return false;

	static id;

	if (sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/checaratividade [id]");

	inline SuspectActivity()
	{
		if (!cache_num_rows())
			return SendErrorMessage(playerid, "Atividade suspeita não encontrada.");

		new user[MAX_PLAYER_NAME], text[1024], title[128], date[32];

		cache_get_value_name(0, "Usuário", user);
		cache_get_value_name(0, "Texto", text);
		cache_get_value_name(0, "Título", title);
		cache_get_value_name(0, "Data", date);

		strreplace(text, "<n>", "\n");
		strreplace(text, "<t>", "\t");

		strins(text, va_return("{BBBBBB}Atividade suspeita de {FFFFFF}%s{BBBBBB} em {FFFFFF}%s{BBBBBB}", user, date), 0);
		Dialog_Show(playerid, DIALOG_SHOW_ONLY, DIALOG_STYLE_MSGBOX, "Atividade suspeita:", text, "Fechar", "");
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline SuspectActivity, "SELECT `Texto`, `Título`, DATE_FORMAT(`Data`, '%%d/%%m/%%Y %%H:%%i:%%s') AS `Data`, (SELECT `Nome` FROM `Contas` WHERE `ID` = `AtividadeSuspeita`.`Conta`) AS `Usuário` FROM `AtividadeSuspeita` WHERE `ID` = %i LIMIT 1;", id);
	return true;
}

// Level 4 (Senior Admin)
CMD:admhide(playerid)
{
	if (!Admin_CheckPermission(playerid, SENIOR_ADMIN))
		return false;

	AccountData[playerid][e_ACCOUNT_ADMIN_HIDE] = !AccountData[playerid][e_ACCOUNT_ADMIN_HIDE];

	if (AccountData[playerid][e_ACCOUNT_ADMIN_HIDE])
	{
		Admin_SendMessage(SENIOR_ADMIN, COLOR_YELLOW, "AdmCmd: %s está em modo administrador oculto.", AccountData[playerid][e_ACCOUNT_NAME]);
		SendClientMessage(playerid, COLOR_GREEN, "Você é um administrador oculto agora.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREEN, "Você não é mais um administrador oculto.");
	}

	Character_UpdateColor(playerid);
	Nametag_Update(playerid);
	return true;
}

CMD:dararma(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, SENIOR_ADMIN, true))
		return false;

	static target, weapon, ammo;

	if (sscanf(params, "uk<weapon>I(300)", target, weapon, ammo))
		return SendUsageMessage(playerid, "/dararma [Nome/ParteDoNome/Id] [ArmaId] [opcional: Munição]");

	if (!(0 <= weapon < 46))
		return SendErrorMessage(playerid, "Use arma de 0 a 46.");

	if (!CheckTargetId(playerid, target))
		return false;

	Log_Create("Admin CMD", "[DARARMA] %s usou em %s (%s) - Arma: %s (munição: %i)", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], ReturnWeaponName(weapon), ammo);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s deu a arma %s com %i munições para %s.", AccountData[playerid][e_ACCOUNT_NAME], ReturnWeaponName(weapon), ammo, Character_GetName(target, false));
	SendClientMessageEx(playerid, COLOR_GREEN, "Você deu uma %s com %i munições para %s.", ReturnWeaponName(weapon), ammo, Character_GetName(target, false));
	SendClientMessageEx(target, COLOR_GREEN, "Administrador %s lhe deu uma %s com %i munições.", AccountData[playerid][e_ACCOUNT_NAME], ReturnWeaponName(weapon), ammo);
	GivePlayerWeapon(target, weapon, ammo);
	return true;
}

// Level 5 (Lead Admin)
CMD:gerenciar(playerid)
{
	if (!Admin_CheckPermission(playerid, LEAD_ADMIN))
		return false;

	Management_ShowDialogMenu(playerid);
	return true;
}

CMD:reloadmaps(playerid)
{
	if (!Admin_CheckPermission(playerid, LEAD_ADMIN))
		return false;

	SendRconCommand("unloadfs objects");
	SendRconCommand("loadfs objects");

	Log_Create("Admin CMD", "[RELOADMAPS] %s recarregou os mapas do servidor - %s objetos", AccountData[playerid][e_ACCOUNT_NAME], FormatNumber(Streamer_GetUpperBound(STREAMER_TYPE_OBJECT)));
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s recarregou os mapas do servidor.", AccountData[playerid][e_ACCOUNT_NAME]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Aproximadamente %s objetos foram recarregados.", FormatNumber(Streamer_GetUpperBound(STREAMER_TYPE_OBJECT)));
	return true;
}

CMD:dardinheiro(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, LEAD_ADMIN, true))
		return false;

	static target, amount;

	if (sscanf(params, "ui", target, amount))
		return SendUsageMessage(playerid, "/dardinheiro [Nome/ParteDoNome/Id] [Valor]");

	if (amount < 1)
		return SendErrorMessage(playerid, "O valor mínimo é $1.");

	if (!CheckTargetId(playerid, target, .adminCmd = true))
		return false;

	Log_Create("Admin CMD", "[DARDINHEIRO] %s usou no personagem %s (%s) - Valor: %s", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], FormatMoney(amount));
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s deu %s para o personagem %s.", AccountData[playerid][e_ACCOUNT_NAME], FormatMoney(amount), Character_GetName(target, false));
	SendClientMessageEx(playerid, -1, "Você deu %s para %s (%s).", FormatMoney(amount), Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME]);
	SendClientMessageEx(target, -1, "Administrador %s lhe deu %s.", AccountData[playerid][e_ACCOUNT_NAME], FormatMoney(amount));
	Character_GiveMoney(target, amount);
	return true;
}

// Level 6 (Manager)
CMD:setadmin(playerid, params[])
{
	if (!Admin_CheckPermission(playerid, MANAGER))
		return false;

	static
		target,
		level;

	if (sscanf(params, "ui", target, level))
		return SendUsageMessage(playerid, "/setadmin [Nome/ParteDoNome/Id] [NívelAdmin]");

	if (!CheckTargetId(playerid, target))
		return false;

	if (!(0 <= level < MAX_ADMIN_LEVEL))
		return SendErrorMessage(playerid, "Use nível admin de 0 a %i.", MAX_ADMIN_LEVEL - 1);

	if (AccountData[target][e_ACCOUNT_ADMIN] == level)
		return SendErrorMessage(playerid, "Jogador já está neste nível admin.");

	Log_Create("Admin set", "%s mudou o nível de %s (%i -> %i)", AccountData[playerid][e_ACCOUNT_NAME], AccountData[target][e_ACCOUNT_NAME], AccountData[target][e_ACCOUNT_ADMIN], level);
	Admin_SendMessage(1, COLOR_LIGHTRED, "AdmCmd: %s definiu o nível admin de %s (%s) para %s.", AccountData[playerid][e_ACCOUNT_NAME], Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], g_arrAdminLevelName[level]);
	SendClientMessageEx(playerid, COLOR_GREEN, "Você definiu o nível admin de %s (%s) para %i.", Character_GetName(target, false), AccountData[target][e_ACCOUNT_NAME], level);
	SendClientMessageEx(target, COLOR_GREEN, "Administrador %s definiu seu nível admin para %i.", AccountData[playerid][e_ACCOUNT_NAME], level);

	AccountData[target][e_ACCOUNT_ADMIN] = level;
	Account_Save(target);
	return true;
}