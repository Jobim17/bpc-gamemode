/*
	oooooooooo.                                                                    .oooooo..o                          .
	`888'   `Y8b                                                                  d8P'    `Y8                        .o8
	 888      888  .oooo.   ooo. .oo.  .oo.    .oooo.    .oooooooo  .ooooo.       Y88bo.      oooo    ooo  .oooo.o .o888oo  .ooooo.  ooo. .oo.  .oo.
	 888      888 `P  )88b  `888P"Y88bP"Y88b  `P  )88b  888' `88b  d88' `88b       `"Y8888o.   `88.  .8'  d88(  "8   888   d88' `88b `888P"Y88bP"Y88b
	 888      888  .oP"888   888   888   888   .oP"888  888   888  888ooo888           `"Y88b   `88..8'   `"Y88b.    888   888ooo888  888   888   888
	 888     d88' d8(  888   888   888   888  d8(  888  `88bod8P'  888    .o      oo     .d8P    `888'    o.  )88b   888 . 888    .o  888   888   888
	o888bood8P'   `Y888""8o o888o o888o o888o `Y888""8o `8oooooo.  `Y8bod8P'      8""88888P'      .8'     8""888P'   "888" `Y8bod8P' o888o o888o o888o
	                                                    d"     YD                             .o..P'
	                                                    "Y88888P'                             `Y8P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define MAX_PLAYER_DAMAGE  				200
#define BODY_PART_UNKNOWN 				0
#define WEAPON_UNARMED 					0
#define WEAPON_VEHICLE_M4 				19
#define WEAPON_VEHICLE_MINIGUN 			20
#define WEAPON_VEHICLE_ROCKETLAUNCHER 	21
#define WEAPON_PISTOLWHIP 				48
#define WEAPON_HELIBLADES 				50
#define WEAPON_EXPLOSION 				51
#define WEAPON_CARPARK 					52
#define WEAPON_UNKNOWN 					55

static enum
{
	PLAYER_DAMAGE_STATE_ALIVE,
	PLAYER_DAMAGE_STATE_WOUNDED,
	PLAYER_DAMAGE_STATE_DEAD,
	PLAYER_DAMAGE_STATE_RESPAWNING
}

static enum E_PLAYER_DAMAGE_DATA
{
	bool:e_DAMAGE_EXISTS,
	e_DAMAGE_WEAPON,
	e_DAMAGE_AMOUNT,
	e_DAMAGE_BODYPART,
	e_DAMAGE_ISSUER[MAX_PLAYER_NAME + 16],
	bool:e_DAMAGE_KEVLAR
}

static const s_validGiveDamage[] = {
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 
	0, 1, 0, 0, 1, 1, 0, 0, 0, 1
};

static const Float:s_weaponRange[] = {
	1.76, 1.76, 1.76, 1.76, 1.76, 1.76, 1.6, 1.76, 1.76, 1.76,
	1.76, 1.76, 1.76, 1.76, 1.76, 1.76, 40.0, 40.0, 40.0, 90.0,
	75.0, 0.0, 35.0, 35.0, 35.0, 40.0, 35.0, 40.0, 35.0, 45.0,
	70.0, 90.0, 35.0, 100.0, 320.0, 55.0, 55.0, 5.1, 75.0, 40.0,
	25.0, 6.1, 10.1, 100.0, 100.0, 100.0, 1.76
};

static const Float:s_weaponDamage[] = {
	1.0, // 0 - Fist
	1.0, // 1 - Brass knuckles
	1.0, // 2 - Golf club
	1.0, // 3 - Nitestick
	1.0, // 4 - Knife
	1.0, // 5 - Bat
	1.0, // 6 - Shovel
	1.0, // 7 - Pool cue
	1.0, // 8 - Katana
	1.0, // 9 - Chainsaw
	1.0, // 10 - Dildo
	1.0, // 11 - Dildo 2
	1.0, // 12 - Vibrator
	1.0, // 13 - Vibrator 2
	1.0, // 14 - Flowers
	1.0, // 15 - Cane
	82.5, // 16 - Grenade
	0.0, // 17 - Teargas
	1.0, // 18 - Molotov
	16.0, // 19 - Vehicle M4 (custom)
	46.2, // 20 - Vehicle minigun (custom)
	82.5, // 21 - Vehicle rocket (custom)
	12.0, // 22 - Colt 45
	13.2, // 23 - Silenced
	46.2, // 24 - Deagle
	3.9, // 25 - Shotgun
	2.2, // 26 - Sawed-off
	4.95, // 27 - Spas
	13.0, // 28 - UZI
	14.0, // 29 - MP5
	18.0, // 30 - AK47
	16.0, // 31 - M4
	13.0, // 32 - Tec9
	24.75, // 33 - Cuntgun
	250.0, // 34 - Sniper
	82.5, // 35 - Rocket launcher
	82.5, // 36 - Heatseeker
	1.0, // 37 - Flamethrower
	46.2, // 38 - Minigun
	82.5, // 39 - Satchel
	0.0, // 40 - Detonator
	0.33, // 41 - Spraycan
	0.33, // 42 - Fire extinguisher
	0.0, // 43 - Camera
	0.0, // 44 - Night vision
	0.0, // 45 - Infrared
	0.0, // 46 - Parachute
	0.0, // 47 - Fake pistol
	2.64, // 48 - Pistol whip (custom)
	9.9, // 49 - Vehicle
	330.0, // 50 - Helicopter blades
	82.5, // 51 - Explosion
	1.0, // 52 - Car park (custom)
	1.0, // 53 - Drowning
	165.0  // 54 - Splat
};

static const s_damageType[] = {
	0, // 0 - Fist
	0, // 1 - Brass knuckles
	0, // 2 - Golf club
	0, // 3 - Nitestick
	0, // 4 - Knife
	0, // 5 - Bat
	0, // 6 - Shovel
	0, // 7 - Pool cue
	0, // 8 - Katana
	0, // 9 - Chainsaw
	0, // 10 - Dildo
	0, // 11 - Dildo 2
	0, // 12 - Vibrator
	0, // 13 - Vibrator 2
	0, // 14 - Flowers
	0, // 15 - Cane
	0, // 16 - Grenade
	1, // 17 - Teargas
	0, // 18 - Molotov
	1, // 19 - Vehicle M4 (custom)
	1, // 20 - Vehicle minigun (custom)
	0, // 21 - Vehicle rocket (custom)
	1, // 22 - Colt 45
	1, // 23 - Silenced
	1, // 24 - Deagle
	1, // 25 - Shotgun
	1, // 26 - Sawed-off
	1, // 27 - Spas
	1, // 28 - UZI
	1, // 29 - MP5
	1, // 30 - AK47
	1, // 31 - M4
	1, // 32 - Tec9
	1, // 33 - Cuntgun
	1, // 34 - Sniper
	0, // 35 - Rocket launcher
	0, // 36 - Heatseeker
	0, // 37 - Flamethrower
	1, // 38 - Minigun
	0, // 39 - Satchel
	0, // 40 - Detonator
	1, // 41 - Spraycan
	1, // 42 - Fire extinguisher
	0, // 43 - Camera
	0, // 44 - Night vision
	0, // 45 - Infrared
	0, // 46 - Parachute
	0, // 47 - Fake pistol
	1, // 48 - Pistol whip (custom)
	1, // 49 - Vehicle
	1, // 50 - Helicopter blades
	0, // 51 - Explosion
	0, // 52 - Car park (custom)
	0, // 53 - Drowning
	0  // 54 - Splat
};

// Forwards
forward OnPlayerWounded(playerid, issuerid);

// Variáveis
static s_pDamageData[MAX_PLAYERS + 1][MAX_PLAYER_DAMAGE][E_PLAYER_DAMAGE_DATA];
static s_pDamageState[MAX_PLAYERS] = {PLAYER_DAMAGE_STATE_ALIVE, ...};
static Text3D:s_pDamageText3D[MAX_PLAYERS] = {Text3D:INVALID_STREAMER_ID, ...};
static s_pDamageTime[MAX_PLAYERS] = {0, ...};

// Callbacks
hook OnPlayerConnect(playerid)
{
	if (IsValidDynamic3DTextLabel(s_pDamageText3D[playerid]))
	{
		DestroyDynamic3DTextLabel(s_pDamageText3D[playerid]);
	}

	s_pDamageState[playerid] = PLAYER_DAMAGE_STATE_ALIVE;
	s_pDamageTime[playerid] = 0;
	s_pDamageText3D[playerid] = Text3D:INVALID_STREAMER_ID;
	s_pDamageData[playerid] = s_pDamageData[MAX_PLAYERS];
	return true;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_PASSENGER || GetPlayerWeapon(playerid) == 24)
	{
		SetPlayerArmedWeapon(playerid, 0);
	}

	if (newstate == PLAYER_STATE_DRIVER)
	{
		SetPlayerArmedWeapon(playerid, 0);
	}

	return true;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if (_:amount == _:1833.33154296875)
		return false;

	if (weaponid < 0 || weaponid >= sizeof(s_validGiveDamage) || !s_validGiveDamage[weaponid])
		return 0;

	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(damagedid))
		return false;

	if (!IsPlayerSpawned(playerid) || !IsPlayerSpawned(damagedid))
		return false;

	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
		return false;

	if (AccountData[playerid][e_ACCOUNT_ADMIN] && AccountData[playerid][e_ACCOUNT_ADMIN_DUTY] || AccountData[damagedid][e_ACCOUNT_ADMIN] && AccountData[damagedid][e_ACCOUNT_ADMIN_DUTY])
		return false;

	if (!Damage_IsAlive(playerid))
		return false;

	if (!Damage_Process(damagedid, playerid, amount, weaponid, bodypart))
		return false;

	new Float:finalHealth = CharacterData[damagedid][e_CHARACTER_HEALTH], Float:finalArmour = CharacterData[damagedid][e_CHARACTER_ARMOUR];

	// Increase Bodypart Lethal
	switch (bodypart)
	{
		case 9: 
		{
			if (!IsPlayerInAnyVehicle(damagedid)) 
			{
				amount *= 1.5;
			}
		}

		case 5,6: amount *= 0.75;
		case 7,8: amount *= 0.5;
	}

	// Check kevlar
	static bool:isKevlar;
	isKevlar = false;

	if ((bodypart == 3 || (bodypart == 5 || bodypart == 6) && Random(1, 3) == 1) && IsBulletWeapon(weaponid))
	{
		isKevlar = true;
		finalArmour -= amount;

		if (finalArmour < 0.0)
		{
			finalHealth += finalArmour;
			finalArmour = 0.0;
		}
	}
	else 
	{
		isKevlar = false;
		finalHealth -= amount;
	}

	// Process
	switch (s_pDamageState[damagedid])
	{
		case PLAYER_DAMAGE_STATE_ALIVE:
		{
			Damage_Add(damagedid, playerid, weaponid, floatround(amount), bodypart, isKevlar);
			SetHealth(damagedid, finalHealth);
			SetArmour(damagedid, finalArmour);

			if (finalHealth < 1.0)
			{
				Admin_SendOnDutyMessage(1, COLOR_LIGHTRED, "[Damage] %s (%i) deixou %s (%i) com o status de brutalmente ferido.", Character_GetName(playerid, false), playerid, Character_GetName(damagedid, false), damagedid);
				Log_Create("Damage System", "%s (%i) deixou %s (%i) com status de brutalmente ferido", Character_GetName(playerid, false), CharacterData[playerid][e_CHARACTER_ID], Character_GetName(damagedid, false), CharacterData[damagedid][e_CHARACTER_ID]);
			}
		}

		case PLAYER_DAMAGE_STATE_WOUNDED:
		{
			if (!IsPlayerInAnyVehicle(damagedid))
				ApplyAnimation(damagedid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 0, 1);

			SetHealth(damagedid, 25.0);

			if ((gettime() - s_pDamageTime[damagedid]) >= 3)
			{
				Damage_SetDead(damagedid);
				Admin_SendOnDutyMessage(1, COLOR_LIGHTRED, "[Damage] %s (%i) deixou %s (%i) com o status de morto.", Character_GetName(playerid, false), playerid, Character_GetName(damagedid, false), damagedid);
				Log_Create("Damage System", "%s (%i) deixou %s (%i) com status de morto", Character_GetName(playerid, false), CharacterData[playerid][e_CHARACTER_ID], Character_GetName(damagedid, false), CharacterData[damagedid][e_CHARACTER_ID]);
			}
		}

		case PLAYER_DAMAGE_STATE_DEAD:
		{
			if (!IsPlayerInAnyVehicle(damagedid))
				ApplyAnimation(damagedid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 0, 1);

			SetHealth(damagedid, 25.0);
		}
	}

	return true;
}

hook OnPlayerSpawn(playerid)
{
	SetPlayerTeam(playerid, 1);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 0);

	if (!(1 <= CharacterData[playerid][e_CHARACTER_HEALTH] <= 100.0))
	{
		CharacterData[playerid][e_CHARACTER_HEALTH] = 100.0;
	}

	if (CharacterData[playerid][e_CHARACTER_ARMOUR] < 1.0)
	{
		CharacterData[playerid][e_CHARACTER_ARMOUR] = 0.0;
	}

	if (CharacterData[playerid][e_CHARACTER_ARMOUR] > 100.0)
	{
		CharacterData[playerid][e_CHARACTER_ARMOUR] = 100.0;
	}

	if (Damage_IsAlive(playerid))
	{
		SetHealth(playerid, CharacterData[playerid][e_CHARACTER_HEALTH]);
		SetArmour(playerid, CharacterData[playerid][e_CHARACTER_ARMOUR]);
	}
	else
	{
		Character_SetPos(playerid, CharacterData[playerid][e_CHARACTER_POS][0], CharacterData[playerid][e_CHARACTER_POS][1], CharacterData[playerid][e_CHARACTER_POS][2], CharacterData[playerid][e_CHARACTER_ANGLE], CharacterData[playerid][e_CHARACTER_WORLD], CharacterData[playerid][e_CHARACTER_INTERIOR]);
	
		if (s_pDamageState[playerid] == PLAYER_DAMAGE_STATE_WOUNDED)
			Damage_SetWounded(playerid);
		else if (s_pDamageState[playerid] == PLAYER_DAMAGE_STATE_DEAD)
			Damage_SetDead(playerid);

		return Y_HOOKS_BREAK_RETURN_1;
	}

	return true;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if (IsPlayerInAnyVehicle(playerid) && weaponid == 24)
	{
		SetPlayerArmedWeapon(playerid, 0);
		RemovePlayerFromVehicle(playerid);
		SendErrorMessage(playerid, "Você não pode usar esta arma em drive-by.");
	}

	return true;
}

hook Server_OnUpdate()
{
	foreach (new i : Player)
	{
		if (!IsPlayerLogged(i))
			continue;

		SetPlayerTeam(i, 1);

		if (!Damage_IsAlive(i) && IsPlayerSpawned(i))
		{
			// Driver
			if (GetPlayerState(i) == PLAYER_STATE_DRIVER && GetPlayerSpeed(i) >= 1)
			{
				new vehicleid = GetPlayerVehicleID(i);
				SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
				SetEngineStatus(vehicleid, false);
			}

			// Update Animation
			static index;
			index = GetPlayerAnimationIndex(i);

			if (GetPlayerState(i) == PLAYER_STATE_DRIVER || GetPlayerState(i) == PLAYER_STATE_PASSENGER)
			{
				if (index != 1018 && index != 1019)
				{
					ApplyAnimation(i, "PED", (!(GetPlayerVehicleSeat(i) % 2) ? ("CAR_dead_LHS") : ("CAR_dead_RHS")), 4.1, 0, 0, 0, 1, 0, 1);
				}
			}
			else
			{
				if (index != 1701 && index != 1151)
				{
					ApplyAnimation(i, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
				}
			}
		}
	}

	return true;
}

// Functions
Damage_GetPlayerCount(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return 0;

	new count;
	for (new i = 0; i < MAX_PLAYER_DAMAGE; i++)
	{
		if (!s_pDamageData[playerid][i][e_DAMAGE_EXISTS])
			continue;

		count += 1;
	}

	return count;
}

Damage_Add(playerid, issuer, weapon, amount, bodypart, bool:kevlar)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	for (new i = 0; i < MAX_PLAYER_DAMAGE; i++) if (!s_pDamageData[playerid][i][e_DAMAGE_EXISTS])
	{
		s_pDamageData[playerid][i][e_DAMAGE_EXISTS] = true;
		s_pDamageData[playerid][i][e_DAMAGE_WEAPON] = weapon;
		s_pDamageData[playerid][i][e_DAMAGE_AMOUNT] = amount;
		s_pDamageData[playerid][i][e_DAMAGE_BODYPART] = bodypart;
		s_pDamageData[playerid][i][e_DAMAGE_KEVLAR] = kevlar;

		if (IsPlayerConnected(issuer))
		{
			format (s_pDamageData[playerid][i][e_DAMAGE_ISSUER], MAX_PLAYER_NAME + 16, "%s (%i)", Character_GetName(issuer, false), CharacterData[issuer][e_CHARACTER_ID]);
		}
		else
		{
			format (s_pDamageData[playerid][i][e_DAMAGE_ISSUER], MAX_PLAYER_NAME + 16, "Desconhecido (INVALID_PLAYER_ID)");
		}

		return true;
	}

	return false;
}

Damage_Reset(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return 0;

	for (new i = 0; i < MAX_PLAYER_DAMAGE; i++)
	{
		s_pDamageData[playerid][i][e_DAMAGE_EXISTS] = false;
	}
	return true;
}

Damage_IsAlive(playerid)
{
	return (s_pDamageState[playerid] == PLAYER_DAMAGE_STATE_ALIVE);
}

Damage_SetWounded(playerid)
{
	if (!IsPlayerLogged(playerid))
		return false;

	if (IsValidDynamic3DTextLabel(s_pDamageText3D[playerid]))
	{
		DestroyDynamic3DTextLabel(s_pDamageText3D[playerid]);
	}

	s_pDamageState[playerid] = PLAYER_DAMAGE_STATE_WOUNDED;
	s_pDamageTime[playerid] = gettime();

	CharacterData[playerid][e_CHARACTER_HEALTH] = 25.0;

	Character_UpdateSpawn(playerid);
	SetPlayerHealth(playerid, 25.0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	SetPlayerArmedWeapon(playerid, 0);
	CancelEdit(playerid);

	SendClientMessage(playerid, COLOR_LIGHTRED, "Você está brutalmente ferido, agora se um médico ou alguém não lhe ajudar, você irá morrer.");
	SendClientMessage(playerid, COLOR_LIGHTRED, "Para aceitar a morte digite /aceitarmorte.");
	GameTextForPlayer(playerid, "BRUTALMENTE FERIDO", 5000, 4);

	TogglePlayerControllable(playerid, false);

	s_pDamageText3D[playerid] = CreateDynamic3DTextLabel(
		va_return("(( Este jogador foi ferido %i vez%s,\n /ferimentos %i para mais informações ))", Damage_GetPlayerCount(playerid), Damage_GetPlayerCount(playerid) > 1 ? ("es") : (""), playerid),
		COLOR_LIGHTRED, 
		0.0,
		0.0,
		0.4, 
		8.0, 
		playerid
	);


	foreach (new i : Player)
	{
		if (!IsPlayerStreamedIn(playerid, i))
			continue;

		Streamer_Update(i, STREAMER_TYPE_3D_TEXT_LABEL);
	}

	return true;
}

Damage_SetDead(playerid)
{
	if (!IsPlayerLogged(playerid))
		return false;

	s_pDamageState[playerid] = PLAYER_DAMAGE_STATE_DEAD;
	s_pDamageTime[playerid] = gettime();

	CharacterData[playerid][e_CHARACTER_HEALTH] = 25.0;

	Character_UpdateSpawn(playerid);
	SetPlayerHealth(playerid, 25.0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ResetPlayerWeapons(playerid);
	CancelEdit(playerid);

	SendClientMessageEx(playerid, COLOR_YELLOW, "-> Você está morto agora. Você precisa esperar 120 segundos e você poderá utilizar o comando /respawnhosp.");
	TogglePlayerControllable(playerid, false);

	if (IsValidDynamic3DTextLabel(s_pDamageText3D[playerid]))
	{
		UpdateDynamic3DTextLabelText(s_pDamageText3D[playerid], COLOR_LIGHTRED, "(( ESTE JOGADOR ESTÁ MORTO ))");
	}
	else
	{
		s_pDamageText3D[playerid] = CreateDynamic3DTextLabel(
			"(( ESTE JOGADOR ESTÁ MORTO ))",
			COLOR_LIGHTRED, 
			0.0,
			0.0,
			0.4, 
			8.0, 
			playerid
		);
	}

	foreach (new i : Player)
	{
		if (!IsPlayerStreamedIn(playerid, i))
			continue;

		Streamer_Update(i, STREAMER_TYPE_3D_TEXT_LABEL);
	}

	return true;
}

Damage_Revive(playerid)
{
	if (Damage_IsAlive(playerid))
		return false;
	
	if (IsValidDynamic3DTextLabel(s_pDamageText3D[playerid]))
	{
		DestroyDynamic3DTextLabel(s_pDamageText3D[playerid]);
	}

	s_pDamageText3D[playerid] = Text3D:INVALID_STREAMER_ID;
	s_pDamageState[playerid] = PLAYER_DAMAGE_STATE_ALIVE;
	Damage_Reset(playerid);
	
	if (IsPlayerSpawned(playerid))
	{
		ClearAnimations(playerid, 1);
		TogglePlayerControllable(playerid, true);
	}

	return true;
}

SetHealth(playerid, Float:health)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (health < 1.0)
	{
		if (s_pDamageState[playerid] == PLAYER_DAMAGE_STATE_ALIVE)
		{
			Damage_SetWounded(playerid);
		}	
		else if (s_pDamageState[playerid] == PLAYER_DAMAGE_STATE_WOUNDED)
		{
			Damage_SetDead(playerid);
		}
		else
		{
			s_pDamageState[playerid] = PLAYER_DAMAGE_STATE_RESPAWNING;
			SetPlayerHealth(playerid, 0.0);
		}
	}
	else
	{
		if (health > 100.0)
		{
			health = 100.0;
		}

		CharacterData[playerid][e_CHARACTER_HEALTH] = health;
		SetPlayerHealth(playerid, health);
	}

	return true;
}

SetArmour(playerid, Float:armour)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
		return false;

	if (armour < 1.0)
	{
		armour = 0.0;
	}

	if (armour > 100.0)
	{
		armour = 100.0;
	}

	CharacterData[playerid][e_CHARACTER_ARMOUR] = armour;
	return SetPlayerArmour(playerid, armour);
}

IsBulletWeapon(weaponid)
{
	return (WEAPON_COLT45 <= weaponid <= WEAPON_SNIPER) || weaponid == WEAPON_MINIGUN;
}

IsHighRateWeapon(weaponid)
{
	switch (weaponid) 
	{
		case WEAPON_FLAMETHROWER, WEAPON_SPRAYCAN, WEAPON_FIREEXTINGUISHER,
		     WEAPON_CARPARK, WEAPON_DROWN: {
			return true;
		}
	}

	return false;
}

IsMeleeWeapon(weaponid)
{
	return (WEAPON_UNARMED <= weaponid <= WEAPON_CANE) || weaponid == WEAPON_PISTOLWHIP;
}

static Damage_Process(&playerid, &issuerid, &Float:amount, &weaponid, &bodypart)
{
	if (amount < 0.0)
		return false;

	new Float:bullets;

	// Adjust invalid amounts caused by an animation bug
	switch (amount) 
	{
		case 3.63000011444091796875,
		     5.940000057220458984375,
		     5.610000133514404296875: {
			amount = 2.6400001049041748046875;
		}

		case 3.30000019073486328125: 
		{
			if (weaponid != WEAPON_SHOTGUN && weaponid != WEAPON_SAWEDOFF) 
			{
				amount = 2.6400001049041748046875;
			}
		}

		case 4.950000286102294921875: 
		{
			if (IsMeleeWeapon(weaponid)) 
			{
				amount = 2.6400001049041748046875;
			}
		}

		case 6.270000457763671875,
		     6.93000030517578125,
		     7.2600002288818359375,
		     7.9200000762939453125,
		     8.5799999237060546875,
		     9.24000072479248046875,
		     11.88000011444091796875,
		     11.22000026702880859375: {
			amount = 2.6400001049041748046875;
		}

		case 9.90000057220458984375: 
		{
			switch (weaponid) 
			{
				case WEAPON_VEHICLE, WEAPON_VEHICLE_M4, WEAPON_AK47,
				     WEAPON_M4, WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA: {}

				default: 
				{
					amount = 6.6000003814697265625;
				}
			}
		}
	}

	// Car parking
	if (weaponid == WEAPON_HELIBLADES && _:amount != _:330.0) 
	{
		weaponid = WEAPON_CARPARK;
	}

	// Finish processing drown/fire/carpark quickly, since they are sent at very high rates
	if (IsHighRateWeapon(weaponid)) 
	{
		// Apply reasonable bounds
		if (weaponid == WEAPON_DROWN) 
		{
			if (amount > 10.0) amount = 10.0;
		} 
		else if (amount > 1.0) 
		{
			amount = 1.0;
		}

		// Adjust the damage if the multiplier is not 1.0
		if (_:s_weaponDamage[weaponid] != _:1.0) 
		{
			amount *= s_weaponDamage[weaponid];
		}

		// Make sure the distance and issuer is valid; carpark can be self-inflicted so it doesn't require an issuer
		if (weaponid == WEAPON_SPRAYCAN || weaponid == WEAPON_FIREEXTINGUISHER || (weaponid == WEAPON_CARPARK && issuerid != INVALID_PLAYER_ID)) 
		{
			if (issuerid == INVALID_PLAYER_ID) 
			{
				return false;
			}

			new Float:x, Float:y, Float:z, Float:dist;
			GetPlayerPos(issuerid, x, y, z);
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);

			if (weaponid == WEAPON_CARPARK) 
			{
				if (dist > 15.0) 
				{
					return false;
				}
			} 
			else 
			{
				if (dist > s_weaponRange[weaponid] + 2.0) 
				{
					return false;
				}
			}
		}

		return true;
	}

	// Bullet or melee damage must have an issuerid, otherwise something has gone wrong (e.g. sniper bug)
	if (issuerid == INVALID_PLAYER_ID && (IsBulletWeapon(weaponid) || IsMeleeWeapon(weaponid))) 
	{
		return false;
	}

	// Punching with a parachute
	if (weaponid == WEAPON_PARACHUTE) 
	{
		weaponid = WEAPON_UNARMED;
	} 
	else if (weaponid == WEAPON_COLLISION) 
	{
		if (amount > 165.0)
		{
			amount = 1.0;
		} 
		else 
		{
			amount /= 165.0;
		}
	} 
	else if (weaponid == WEAPON_EXPLOSION) 
	{
		// Explosions do at most 82.5 damage. This will later be multipled by the damage value
		amount /= 82.5;

		// Figure out what caused the explosion
		if (issuerid != INVALID_PLAYER_ID)
		{
			if (GetPlayerState(issuerid) == PLAYER_STATE_DRIVER) 
			{
				new modelid = GetVehicleModel(GetPlayerVehicleID(issuerid));

				if (modelid == 425 || modelid == 432 || modelid == 520) 
				{
					weaponid = WEAPON_VEHICLE_ROCKETLAUNCHER;
				}
			} 
		} 
		else if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
		{
			new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));

			if (modelid == 425 || modelid == 432 || modelid == 520) 
			{
				weaponid = WEAPON_VEHICLE_ROCKETLAUNCHER;
			}
		}
	}

	// Check for pistol whip
	switch (weaponid) 
	{
		case WEAPON_COLT45 .. WEAPON_SNIPER,
		     WEAPON_MINIGUN, WEAPON_SPRAYCAN, WEAPON_FIREEXTINGUISHER: {
			// A pistol whip inflicts 2.64 damage
			if (_:amount == _:2.6400001049041748046875) 
			{
				// Save the weapon in the bodypart argument (it's always BODY_PART_TORSO)
				bodypart = weaponid;
				weaponid = WEAPON_PISTOLWHIP;
			}
		}
	}

	new melee = IsMeleeWeapon(weaponid);

	// Can't punch from a vehicle
	if (melee && IsPlayerInAnyVehicle(issuerid)) 
	{
		return false;
	}

	if (weaponid != WEAPON_PISTOLWHIP) 
	{
		switch (amount) 
		{
			case 1.32000005245208740234375,
			     1.650000095367431640625,
			     1.980000019073486328125,
			     2.3100001811981201171875,
			     2.6400001049041748046875,
			     2.9700000286102294921875,
			     3.96000003814697265625,
			     4.28999996185302734375,
			     4.62000036239624023437,
			     5.280000209808349609375: {
				// Damage is most likely from punching and switching weapon quickly
				if (!melee) 
				{
					weaponid = WEAPON_UNARMED;
					melee = true;
				}
			}

			case 6.6000003814697265625: 
			{
				if (!melee) 
				{
					switch (weaponid) 
					{
						case WEAPON_UZI, WEAPON_TEC9,
						     WEAPON_SHOTGUN, WEAPON_SAWEDOFF: {}

						default: 
						{
							weaponid = WEAPON_UNARMED;
							melee = true;
						}
					}
				}
			}

			case 54.12000274658203125: 
			{
				if (!melee) 
				{
					melee = true;
					weaponid = WEAPON_UNARMED;
					amount = 1.32000005245208740234375;
				}

				// Be extra sure about this one
				if (GetPlayerFightingStyle(issuerid) != FIGHT_STYLE_KNEEHEAD) 
				{
					return false;
				}
			}

			// Melee damage has been tampered with
			default: {
				if (melee) 
				{
					return false;
				}
			}
		}
	}

	if (melee) 
	{
		new Float:x, Float:y, Float:z, Float:dist;
		GetPlayerPos(issuerid, x, y, z);
		dist = GetPlayerDistanceFromPoint(playerid, x, y, z);

		if (0 <= weaponid < sizeof(s_weaponRange) && dist > s_weaponRange[weaponid] + 2.0) 
		{
			return false;
		}
	}

	switch (weaponid) 
	{
		// The spas shotguns shoot 8 bullets, each inflicting 4.95 damage
		case WEAPON_SHOTGSPA: 
		{
			bullets = amount / 4.950000286102294921875;

			if (8.0 - bullets < -0.05) 
			{
				return false;
			}
		}

		// Shotguns and sawed-off shotguns shoot 15 bullets, each inflicting 3.3 damage
		case WEAPON_SHOTGUN, WEAPON_SAWEDOFF: 
		{
			bullets = amount / 3.30000019073486328125;

			if (15.0 - bullets < -0.05) 
			{
				return false;
			}
		}
	}

	if (_:bullets) 
	{
		new Float:f = floatfract(bullets);

		// The damage for each bullet has been tampered with
		if (f > 0.01 && f < 0.99) 
		{
			return false;
		}

		// Divide the damage amount by the number of bullets
		amount /= bullets;
	}

	// Check chainsaw damage
	if (weaponid == WEAPON_CHAINSAW) 
	{
		switch (amount) 
		{
			case 6.6000003814697265625,
			     13.5300006866455078125,
			     16.1700000762939453125,
			     26.40000152587890625,
			     27.060001373291015625: {}

			default: 
			{
				return false;
			}
		}
	} 
	else if (weaponid == WEAPON_DEAGLE) 
	{
		// Check deagle damage
		switch (amount) 
		{
			case 46.200000762939453125,
			     23.1000003814697265625: {}

			default: 
			{
				return false;
			}
		}
	}

	// Adjust the damage
	switch (s_damageType[weaponid]) 
	{
		case 0: 
		{
			if (_:s_weaponDamage[weaponid] != _:1.0) 
			{
				amount *= s_weaponDamage[weaponid];
			}
		}

		case 1: 
		{
			if (_:bullets) 
			{
				amount = s_weaponDamage[weaponid] * bullets;
			} 
			else 
			{
				amount = s_weaponDamage[weaponid];
			}
		}
	}

	return true;
}