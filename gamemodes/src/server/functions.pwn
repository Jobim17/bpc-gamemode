/*
	oooooooooooo                                       .    o8o
	`888'     `8                                     .o8    `"'
	 888         oooo  oooo  ooo. .oo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o
	 888oooo8    `888  `888  `888P"Y88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8
	 888    "     888   888   888   888  888         888    888  888   888  888   888  `"Y88b.
	 888          888   888   888   888  888   .o8   888 .  888  888   888  888   888  o.  )88b
	o888o         `V88V"V8P' o888o o888o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P'
*/

ReturnPlayerIP(playerid)
{
	new ip[16 + 1];
	GetPlayerIp(playerid, ip, sizeof ip);
	return ip;
}

ReturnPlayerSerial(playerid)
{
	new _gpci[40 + 1];
	gpci(playerid, _gpci, sizeof _gpci);
	return _gpci;
}

FormatMoney(int) 
{
	new out[128];
	strcpy(out, FormatNumber(int, "$", ","));
	return out;
}

FormatNumber(int, prefix[] = "", const del[] = ".")
{
    new var[20];

    valstr(var, int < 0 ? -(int) : int);

    for(new X = strlen(var) - 3; X > 0; X -= 3)
        strins(var, del, X);

    format(var, sizeof(var), "%s%s%s", int < 0 ? ("-") : (""), prefix, var);
    return var;
} 

SendErrorMessage(playerid, const message[], va_args<>)
{
	return SendClientMessageEx(playerid, COLOR_LIGHTRED, message, va_start<2>);
}

SendUsageMessage(playerid, const message[])
{
	return SendClientMessageEx(playerid, COLOR_LIGHTRED, "USE: {FFFFFF}%s", message);
}

SendClientMessageEx(playerid, color, const message[], va_args<>)
{
	new out[144];
	va_format(out, sizeof out, message, va_start<3>);
	return SendClientMessage(playerid, color, out);
}

SendClientMessageToAllEx(color, const message[], va_args<>)
{
	new out[144];
	va_format(out, sizeof out, message, va_start<2>);

	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i) || !CharacterData[i][e_CHARACTER_ID])
			continue;

		SendClientMessage(i, color, out);
	}

	return true;
}


ClearPlayerMessages(playerid)
{
	for (new i = 0; i < 75; i++)
	{
		SendClientMessage(playerid, -1, " ");
	}
	return true;
}

KickPlayer(playerid)
{
	SetTimerEx("KickDelay", 300, false, "i", playerid);
	return true;
}

forward KickDelay(playerid); public KickDelay(playerid) return Kick(playerid);

ReturnSkinName(skin_id) 
{
	static const
	    s_aszSkinNames[][41 char] = {
	        !"Carl \'CJ\' Johnson",
	        !"The Truth",
	        !"Maccer",
	        !"Andre",
	        !"Barry \'Big Bear\' Thorne",
	        !"Barry \'Big Bear\' Thorne",
	        !"Emmet",
	        !"Taxi Driver",
	        !"Janitor",
	        !"Normal Ped",
	        !"Old Woman",
	        !"Casino Croupier",
	        !"Normal Ped",
	        !"Street Girl",
	        !"Normal Ped",
	        !"Mr.Whittaker",
	        !"Airport Ground Worker",
	        !"Office worker",
	        !"Beach Visitor",
	        !"DJ",
	        !"Rich Guy",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Bmxer",
	        !"Madd Dogg\'s Bodyguard",
	        !"Madd Dogg\'s Bodyguard",
	        !"Backpacker",
	        !"Construction Work",
	        !"Drug Dealer",
	        !"Drug Dealer",
	        !"Drug Dealer",
	        !"Farm Town Inhabitant",
	        !"Farm Town Inhabitant",
	        !"Farm Town Inhabitant",
	        !"Farm Town Inhabitant",
	        !"Gardener",
	        !"Golfer",
	        !"Golfer",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Jethro",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Beach Visitor",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Snakehead (Da Nang)",
	        !"Mechanic",
	        !"Mountain Biker",
	        !"Unknown",
	        !"Street Girl",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Feds",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Pilot",
	        !"Colonel Fuhrberger",
	        !"Prostitute",
	        !"Prostitute",
	        !"Kendl Johnson",
	        !"Pool Player",
	        !"Pool Player",
	        !"Priest/Preacher",
	        !"Normal Ped",
	        !"Doktor",
	        !"Security Guard",
	        !"Hippy",
	        !"Hippy",
	        !"Invalid skin",
	        !"Prostitute",
	        !"Normal Ped",
	        !"Homeless",
	        !"Homeless",
	        !"Homeless",
	        !"Boxer",
	        !"Boxer",
	        !"Black Elvis",
	        !"White Elvis",
	        !"Blue Elvis",
	        !"Prostitute",
	        !"Ryder With Robbery Mask",
	        !"Stripper",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Jogger",
	        !"Rich Woman",
	        !"Rollerskater",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Jogger",
	        !"Lifeguard",
	        !"Normal Ped",
	        !"Homeless",
	        !"Biker",
	        !"Normal Ped",
	        !"Balla",
	        !"Balla",
	        !"Balla",
	        !"Grove Street Families",
	        !"Grove Street Families",
	        !"Grove Street Families",
	        !"Los Santos Vagos",
	        !"Los Santos Vagos",
	        !"Los Santos Vagos",
	        !"The Russian Mafia",
	        !"The Russian Mafia",
	        !"The Russian Mafia",
	        !"Varios Los Aztecas",
	        !"Varios Los Aztecas",
	        !"Varios Los Aztecas",
	        !"Triad",
	        !"Triad",
	        !"Johhny Sindacco",
	        !"Triad Boss",
	        !"Da Nang Boy",
	        !"Da Nang Boy",
	        !"Da Nang Boy",
	        !"Mafia",
	        !"Mafia",
	        !"Mafia",
	        !"Mafia",
	        !"Farm Inhabitant",
	        !"Farm Inhabitant",
	        !"Farm Inhabitant",
	        !"Farm Inhabitant",
	        !"Farm Inhabitant",
	        !"Farm Inhabitant",
	        !"Homeless",
	        !"Homeless",
	        !"Homeless",
	        !"Homeless",
	        !"Beach Visitor",
	        !"Beach Visitor",
	        !"Beach Visitor",
	        !"Office worker",
	        !"Taxi Driver",
	        !"Crack Maker",
	        !"Crack Maker",
	        !"Crack Maker",
	        !"Normal Ped",
	        !"Office worker",
	        !"Office worker",
	        !"Big Smoke Armored",
	        !"Office worker",
	        !"Normal Ped",
	        !"Prostitute",
	        !"Construction Worker",
	        !"Beach Visitor",
	        !"Well Stacked Pizza Worker",
	        !"Barber",
	        !"Hillbilly",
	        !"Farmer",
	        !"Hillbilly",
	        !"Hillbilly",
	        !"Farmer",
	        !"Hillbilly",
	        !"Black Bouncer",
	        !"White Bouncer",
	        !"White MIB Agent",
	        !"Black MIB Agent",
	        !"Cluckin\' Bell Worker",
	        !"Hotdog/Chilli Dog Vendor",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Blackjack Dealer",
	        !"Casino Croupier",
	        !"San Fierro Rifa",
	        !"San Fierro Rifa",
	        !"San Fierro Rifa",
	        !"Barber",
	        !"Barber",
	        !"Whore",
	        !"Ammunation Salesman",
	        !"Tattoo Artist",
	        !"Punker",
	        !"Cab Driver",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Office worker",
	        !"Normal Ped",
	        !"Valet",
	        !"Barbara Schternvart",
	        !"Helena Wankstein",
	        !"Michelle Cannes",
	        !"Katie Zhan",
	        !"Millie Perkins",
	        !"Denise Robinson",
	        !"Farm Town Inhabitant",
	        !"Hillbilly",
	        !"Farm Town Inhabitant",
	        !"Farm Town Inhabitant",
	        !"Hillbilly",
	        !"Farmer",
	        !"Farmer",
	        !"Karate Teacher",
	        !"Karate Teacher",
	        !"Burger Shot Cashier",
	        !"Cab Driver",
	        !"Prostitute",
	        !"Su Xi Mu (Suzie)",
	        !"Noodle Stand Vendor",
	        !"Boater",
	        !"Female Staff",
	        !"Homeless",
	        !"Weird Old Man",
	        !"Waitress",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Male Staff",
	        !"Normal Ped",
	        !"Rich Woman",
	        !"Cab Driver",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Hillbilly",
	        !"Normal Ped",
	        !"Office worker",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Homeless",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Cab Driver",
	        !"Normal Ped",
	        !"Normal Ped",
	        !"Prostitute",
	        !"Prostitute",
	        !"Homeless",
	        !"The D.A",
	        !"Afro American",
	        !"Mexican",
	        !"Prostitute",
	        !"Stripper",
	        !"Prostitute",
	        !"Stripper",
	        !"Biker",
	        !"Biker",
	        !"Pimp",
	        !"Normal Ped",
	        !"Lifeguard",
	        !"Naked Valet",
	        !"Bus Driver",
	        !"Biker Drug Dealer",
	        !"Chauffeur (Limo Driver)",
	        !"Stripper",
	        !"Stripper",
	        !"Heckler",
	        !"Heckler",
	        !"Construction Worker",
	        !"Cab Driver",
	        !"Cab Driver",
	        !"Normal Ped",
	        !"Clown",
	        !"Frank Tenpenny",
	        !"Eddie Pulaski",
	        !"Jimmy Hernandez",
	        !"Dwayne",
	        !"Melvin \'Big Smoke\' Harris",
	        !"Sean \'Sweet\' Johnson",
	        !"Lance \'Ryder\' Wilson",
	        !"Mafia Boss",
	        !"T-Bone Mendez",
	        !"Paramedic",
	        !"Paramedic",
	        !"Paramedic",
	        !"Firefighter",
	        !"Firefighter",
	        !"Firefighter",
	        !"Male LS Police",
	        !"Male SF Police",
	        !"Male LV Police",
	        !"County Sheriff",
	        !"Motorbike Cop",
	        !"S.W.A.T Agent",
	        !"Federal Agent",
	        !"San Andreas Army",
	        !"Desert Sheriff",
	        !"Zero",
	        !"Ken Rosenberg",
	        !"Kent Paul",
	        !"Cesar Vialpando",
	        !"Jeffery \'OG Loc\'",
	        !"Wu Zi Mu (Woozie)",
	        !"Michael Toreno",
	        !"Jizzy B",
	        !"Madd Dogg",
	        !"Catalina",
	        !"Claude Speed",
	        !"Male LS Police",
	        !"Male SF Police",
	        !"Male LV Police",
	        !"Detective",
	        !"Detective",
	        !"Detective",
	        !"Female LS Police",
	        !"Female SF Police",
	        !"Female Paramedic",
	        !"Female LV Police",
	        !"County Sheriff",
	        !"Desert Sheriff"
	    }
	;

    static
        s_szName[41]
    ;

    if (0 <= skin_id <= 311)
    {
    	strunpack(s_szName, s_aszSkinNames[skin_id]);
    }
    else if (20001 <= skin_id <= 30000)
    {
    	strunpack(s_szName, !"Custom DL");
    }
    else
    {
    	strunpack(s_szName, !"Inválida");
    }

    return s_szName;
}

isupper(c) {
    return ('A' <= c <= 'Z');
}

islower(c) {
    return ('a' <= c <= 'z');
}

Spawn(playerid)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		TogglePlayerSpectating(playerid, false);
	}
	else
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_WASTED)
		{
			SpawnPlayer(playerid);
		}
	}

	return true;
}

CheckTargetId(playerid, targetid, bool:self = true, bool:adminCmd = false)
{
	if (!IsPlayerConnected(targetid))
		return SendErrorMessage(playerid, "Você especificou um ID inválido."), false;

	if (!IsPlayerLogged(targetid) || !CharacterData[targetid][e_CHARACTER_ID])
		return SendErrorMessage(playerid, "Jogador não está autenticado."), false;

	if (!self && playerid == targetid)
		return SendErrorMessage(playerid, "Jogador é você mesmo."), false;

	if (adminCmd && targetid != playerid && AccountData[targetid][e_ACCOUNT_ADMIN] >= AccountData[playerid][e_ACCOUNT_ADMIN] && !IsPlayerAdmin(playerid))
		return SendErrorMessage(playerid, "Jogador é um administrador igual ou superior a você."), false;

	return true;
}

ReturnWeaponName(weaponid)
{
	new ret[32] = "N/A";

	if ((0 <= weaponid <= 46))
	{
		GetWeaponName(weaponid, ret, 32);
	}

	return ret;
}

SendNearbyMessage(playerid, color, Float:radius, const msg[], va_args<>)
{
	if (!IsPlayerConnected(playerid))
		return false;

	new Float:x, Float:y, Float:z, int, world, out[144];

	GetPlayerPos(playerid, x, y, z);
	int = GetPlayerInterior(playerid);
	world = GetPlayerVirtualWorld(playerid);
	va_format(out, sizeof out, msg, va_start<4>);

	foreach (new i : Player)
	{
		if (!IsPlayerInRangeOfPoint(i, radius, x, y, z))
			continue;

		if (GetPlayerInterior(i) != int)
			continue;

		if (GetPlayerVirtualWorld(i) != world)
			continue;

		SendClientMessage(i, color, out);
	}

	return true;
}

TimestampFormat(time, const format[] = "%H:%i")
{
	new ret[32], query[128];

	mysql_format(MYSQL_CUR_HANDLE, query, sizeof query, "SELECT DATE_FORMAT(FROM_UNIXTIME(%i), '%s') AS `Return`;", time, format);
	mysql_query(MYSQL_CUR_HANDLE, query);

	cache_get_value_name(0, "Return", ret);
	return ret;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

GetPlayerId(const name[], bool:ignore=false)
{
	foreach (new i : Player)
	{
		if (strcmp(name, ReturnPlayerName(i), ignore))
			continue;

		return i;
	}

	return INVALID_PLAYER_ID;
}

IsPlayerSpawned(playerid)
{
	if (playerid < 0 || playerid >= MAX_PLAYERS)
	    return 0;

	return (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && GetPlayerState(playerid) != PLAYER_STATE_NONE && GetPlayerState(playerid) != PLAYER_STATE_WASTED);
}

SendProxMessage(Float:radius, playerid, const msg[], va_args<>)
{
	if (!IsPlayerConnected(playerid))
		return false;

	static Float:x, Float:y, Float:z, message[144 + 1];
	GetPlayerPos(playerid, x, y, z);
	va_format(message, sizeof message, msg, va_start<3>);

	foreach (new i : Player)
	{
		if (GetPlayerInterior(i) != GetPlayerInterior(playerid))
			continue;

		if (GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
			continue;

		if (i == playerid)
			continue;

		static Float:tX, Float:tY, Float:tZ, Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(i, pX, pY, pZ);

		tX = (x - pX);
		tY = (y - pY);
		tZ = (z - pZ);

		if (((tX < radius/16.0) && (tX > -radius/16.0)) && ((tY < radius/16.0) && (tY > -radius/16.0)) && ((tZ < radius/16.0) && (tZ > -radius/16.0)))
		{
			SendClientMessage(i, COLOR_FADE1, message);
		}
		else if (((tX < radius/8.0) && (tX > -radius/8.0)) && ((tY < radius/8.0) && (tY > -radius/8.0)) && ((tZ < radius/8.0) && (tZ > -radius/8.0)))
		{
			SendClientMessage(i, COLOR_FADE2, message);
		}
		else if (((tX < radius/4.0) && (tX > -radius/4.0)) && ((tY < radius/4.0) && (tY > -radius/4.0)) && ((tZ < radius/4.0) && (tZ > -radius/4.0)))
		{
			SendClientMessage(i, COLOR_FADE3, message);
		}
		else if (((tX < radius/2.0) && (tX > -radius/2.0)) && ((tY < radius/2.0) && (tY > -radius/2.0)) && ((tZ < radius/2.0) && (tZ > -radius/2.0)))
		{
			SendClientMessage(i, COLOR_FADE4, message);
		}
		else if (((tX < radius) && (tX > -radius)) && ((tY < radius) && (tY > -radius)) && ((tZ < radius) && (tZ > -radius)))
		{
			SendClientMessage(i, COLOR_FADE5, message);
		}
	}

	SendClientMessage(playerid, COLOR_FADE1, message);
	return true;
}

GetPlayerSpeed(playerid)
{
	new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
	rtn = floatsqroot(Vx*Vx + Vy*Vy + Vz*Vz);
	return floatround(rtn * 100 * 1.63);
}

GetAlcoholTeor(level)
{
	new out[16], finalInt = 0;

	if (level < 1)
	{
		finalInt = 0;
	}
	else
	{
		finalInt = 10 + (level * 5);
	}

	format (out, sizeof out, "%ig/100ml", finalInt);
	return out;
}

DisplayStats(playerid, forplayer)
{
	new factionName[32] = "Nenhuma", factionRank[64] = "Nenhum", factionId;
	factionId = Character_GetFaction(playerid);

	if (factionId != -1)
	{
		format (factionName, sizeof factionName, FactionData[factionId][e_FACTION_NAME]);
		format (factionRank, sizeof factionRank, CharacterData[playerid][e_CHARACTER_FACTION_RANK]);
	}

	SendClientMessage(forplayer, COLOR_BEGE, "|________________________________________________  STATS  ____________________________________________________|");
	SendClientMessageEx(forplayer, COLOR_BEGE, "[GERAL] Nome: %s (#%i) | Conta: %s (%i)", Character_GetName(playerid, false), CharacterData[playerid][e_CHARACTER_ID], AccountData[playerid][e_ACCOUNT_NAME], AccountData[playerid][e_ACCOUNT_ID]);
	SendClientMessageEx(forplayer, COLOR_BEGE, "[PERSONAGEM] Nascimento: %s | Origem: %s | Etnia: %s", CharacterData[playerid][e_CHARACTER_BIRTHDATE], CharacterData[playerid][e_CHARACTER_ORIGIN], CharacterData[playerid][e_CHARACTER_ETNIA]);
	SendClientMessageEx(forplayer, COLOR_BEGE, "[FINANÇAS] Dinheiro: %s | Banco: %s", FormatMoney(CharacterData[playerid][e_CHARACTER_MONEY]), FormatMoney(CharacterData[playerid][e_CHARACTER_BANK_MONEY]));
	SendClientMessageEx(forplayer, COLOR_BEGE, "[ESTATÍSTICAS] Level: %i | Experiência: %i/%i | Paycheck: %i/60", CharacterData[playerid][e_CHARACTER_LEVEL], CharacterData[playerid][e_CHARACTER_EXP], GetLevelExperience(CharacterData[playerid][e_CHARACTER_LEVEL]), CharacterData[playerid][e_CHARACTER_PAYCHECK] / 60);
	SendClientMessageEx(forplayer, COLOR_BEGE, "[INVENTÁRIO] Slots: %i/%i | Rádio: %s | Celular: %s", Inventory_Count(playerid), Inventory_MaxSlots(playerid), Inventory_HasItem(playerid, "Rádio") ? ("Sim") : ("Não"), Inventory_HasItem(playerid, "Celular") ? ("Sim") : ("Não"));
	SendClientMessageEx(forplayer, COLOR_BEGE, "[FACÇÃO] %s (%i) | Cargo: %s", factionName, factionId, factionRank);
	SendClientMessageEx(forplayer, COLOR_BEGE, "[MÃOS] %s", GetPlayerHandDesc(playerid));
	SendClientMessageEx(forplayer, COLOR_BEGE, "[PREMIUM] Pacote: %s", Premium_GetName(Premium_GetLevel(playerid)));

	if (Admin_CheckPermission(forplayer, 1, .sendMessage = false, .working = true))
	{
		SendClientMessageEx(forplayer, COLOR_BEGE, "[ADMIN] Cargo: %s (%i) | Escondido: %s | Trabalhando: %s | Avaliação: %i/5 (%i)", Admin_LevelName(AccountData[playerid][e_ACCOUNT_ADMIN]), AccountData[playerid][e_ACCOUNT_ADMIN], AccountData[playerid][e_ACCOUNT_ADMIN_HIDE] ? ("Sim") : ("Não"), AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] ? ("Sim") : ("Não"), Admin_GetStars(playerid), AccountData[playerid][e_ACCOUNT_ADMIN_AVALIATIONS]);
		SendClientMessageEx(forplayer, COLOR_BEGE, "[ADMIN] Plataforma: %s | Entrada: %i | Empresa: %i | Casa: %i", IsPlayerAndroid(playerid) ? ("Mobile") : ("Computador"), Entrance_Inside(playerid), Business_Inside(playerid), House_Inside(playerid));
	}

	if (Admin_CheckPermission(forplayer, 3, .sendMessage = false, .working = true) && AccountData[playerid][e_ACCOUNT_ADMIN] <= AccountData[forplayer][e_ACCOUNT_ADMIN])
	{
		SendClientMessageEx(forplayer, COLOR_BEGE, "[LOOKUP] Localização: %s, %s, %s | IP: %s | VPN: %s", LookupData[playerid][e_LOOKUP_CITY], LookupData[playerid][e_LOOKUP_STATE], LookupData[playerid][e_LOOKUP_COUNTRY], ReturnPlayerIP(playerid), LookupData[playerid][e_LOOKUP_VPN] ? ("Sim") : ("Não"));
		SendClientMessageEx(forplayer, COLOR_BEGE, "[LOOKUP] ISP: %s | ORG: %s", LookupData[playerid][e_LOOKUP_ISP], LookupData[playerid][e_LOOKUP_ORG]);
	}
	return true;
}

ReturnLimitedText(const text[])
{
	new out[64], size = strlen(text);

	if (size > 48)
	{
		format (out, sizeof out, "%.48s...", text);
	}
	else
	{
		format (out, sizeof out, text);		
	}

	return out;
}

SendVehicleMessage(vehicleid, color, const msg[], va_args<>)
{
	if (!IsValidVehicle(vehicleid))
		return false;

	new out[256], size;
	va_format(out, sizeof out, msg, va_start<3>);
	size = strlen(out);

	foreach (new i : Player)
	{
		if (!IsPlayerInVehicle(i, vehicleid))
			continue;

		if (size > 64)
		{
			SendClientMessageEx(i, color, "%.64s", out);
			SendClientMessageEx(i, color, "...%s", out[64]);
		}
		else SendClientMessage(i, color, out);
	}

	return true;
}

GetVehicleFromBehind(vehicleid)
{
	static
	    Float:fCoords[7];

	GetVehiclePos(vehicleid, fCoords[0], fCoords[1], fCoords[2]);
	GetVehicleZAngle(vehicleid, fCoords[3]);

	for (new i = 1; i != GetVehiclePoolSize()+1; i ++) if (i != vehicleid && GetVehiclePos(i, fCoords[4], fCoords[5], fCoords[6]))
	{
		if (floatabs(fCoords[0] - fCoords[4]) < 6 && floatabs(fCoords[1] - fCoords[5]) < 6 && floatabs(fCoords[2] - fCoords[6]) < 6)
			return i;
	}
	return INVALID_VEHICLE_ID;
}