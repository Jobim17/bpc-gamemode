/*
	  .oooooo.   oooo                                 .oooooo..o
	 d8P'  `Y8b  `888                                d8P'    `Y8
	888           888 .oo.    .oooo.   oooo d8b      Y88bo.      oo.ooooo.   .oooo.   oooo oooo    ooo ooo. .oo.
	888           888P"Y88b  `P  )88b  `888""8P       `"Y8888o.   888' `88b `P  )88b   `88. `88.  .8'  `888P"Y88b
	888           888   888   .oP"888   888               `"Y88b  888   888  .oP"888    `88..]88..8'    888   888
	`88b    ooo   888   888  d8(  888   888          oo     .d8P  888   888 d8(  888     `888'`888'     888   888
	 `Y8bood8P'  o888o o888o `Y888""8o d888b         8""88888P'   888bod8P' `Y888""8o     `8'  `8'     o888o o888o
	                                                              888
	                                                             o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Callbacks
public OnCharacterLoaded(playerid)
{
	SendClientMessageEx(playerid, -1, "SERVER: Bem-vindo(a) %s!", Character_GetName(playerid));

	// Admin Message
	if (AccountData[playerid][e_ACCOUNT_ADMIN])
	{
		SendClientMessageEx(playerid, -1, "ADMIN: Você foi autenticado com o nível %i de admin, concedido pela conta \"%s\".", AccountData[playerid][e_ACCOUNT_ADMIN], AccountData[playerid][e_ACCOUNT_NAME]);
	}

	// Premium
	if (AccountData[playerid][e_ACCOUNT_PREMIUM])
	{
		if (gettime() > AccountData[playerid][e_ACCOUNT_PREMIUM_EXPIRES])
		{
			Log_Create("Premium", "[%i] Jogador %s perdeu seu pacote nível %s por estar expirado.", AccountData[playerid][e_ACCOUNT_ID], AccountData[playerid][e_ACCOUNT_NAME], Premium_GetName(AccountData[playerid][e_ACCOUNT_PREMIUM]));
			SendClientMessageEx(playerid, -1, "PREMIUM: Seu pacote nível %s expirou.", Premium_GetName(AccountData[playerid][e_ACCOUNT_PREMIUM]));
		
			AccountData[playerid][e_ACCOUNT_PREMIUM_EXPIRES] = 0;
			AccountData[playerid][e_ACCOUNT_PREMIUM] = 0;
			Account_Save(playerid);
		}
		else
		{
			SendClientMessageEx(playerid, -1, "PREMIUM: Você tem um pacote nível %s ativo.", Premium_GetName(AccountData[playerid][e_ACCOUNT_PREMIUM]));
		}
	}

	// Faction MOTD
	new fac = Character_GetFaction(playerid);

	if (fac != -1)
	{
		new facMOTD[128];
		format (facMOTD, sizeof facMOTD, FactionData[fac][e_FACTION_MOTD]);

		if (facMOTD[0] != '\0')
		{
			SendClientMessageEx(playerid, -1, "FACTION: %.64s", facMOTD);

			if (strlen(facMOTD) > 64)
			{
				SendClientMessageEx(playerid, -1, "...%.64s", facMOTD[64]);
			}
		}
	}

	// Server MOTD
	new serverMOTD[128];
	GetGVarString("SERVER_MOTD", serverMOTD);

	if (serverMOTD[0] != '\0')
	{
		SendClientMessageEx(playerid, -1, "MOTD: %.64s", serverMOTD);

		if (strlen(serverMOTD) > 64)
		{
			SendClientMessageEx(playerid, -1, "...%.64s", serverMOTD[64]);
		}
	}

	// Spawn
	Spawn(playerid);
	return true;
}

public OnPlayerSpawn(playerid)
{
	if (!IsPlayerLogged(playerid) || !CharacterData[playerid][e_CHARACTER_ID])
	{
		Kick(playerid);
		return true;
	}

	new bool:foundSpawn = false;

	// Vai para a última posição
	if (CharacterData[playerid][e_CHARACTER_POS][0] != 0.0 && (CharacterData[playerid][e_CHARACTER_SPAWN_EXPIRES] < (GetGVarInt("SPAWN_TIME") * 60) || CharacterData[playerid][e_CHARACTER_SPAWN_POINT] == SPAWN_POINT_LAST_POS))
	{
		foundSpawn = true;
	}

	// Outros spawns
	else
	{
		// Facção
		if (CharacterData[playerid][e_CHARACTER_SPAWN_POINT] == SPAWN_POINT_FACTION)
		{
			new id = Character_GetFaction(playerid);

			if (id == -1)
			{
				SendErrorMessage(playerid, "Você foi enviado para o spawn padrão por não fazer mais parte de uma facção.");
			}
			else
			{
				for (new i = 0; i < MAX_FACTION_SPAWN; i++)
				{
					if (!FactionSpawnData[id][i][e_FACTION_SPAWN_EXISTS])
						continue;

					if (FactionSpawnData[id][i][e_FACTION_SPAWN_ID] != CharacterData[playerid][e_CHARACTER_SPAWN_ID])
						continue;
					
					CharacterData[playerid][e_CHARACTER_POS][0] = FactionSpawnData[id][i][e_FACTION_SPAWN_POS][0];
					CharacterData[playerid][e_CHARACTER_POS][1] = FactionSpawnData[id][i][e_FACTION_SPAWN_POS][1];
					CharacterData[playerid][e_CHARACTER_POS][2] = FactionSpawnData[id][i][e_FACTION_SPAWN_POS][2];
					CharacterData[playerid][e_CHARACTER_ANGLE] = FactionSpawnData[id][i][e_FACTION_SPAWN_POS][3];
					CharacterData[playerid][e_CHARACTER_WORLD] = FactionSpawnData[id][i][e_FACTION_SPAWN_WORLD];
					CharacterData[playerid][e_CHARACTER_INTERIOR] = FactionSpawnData[id][i][e_FACTION_SPAWN_INTERIOR];
					foundSpawn = true;
					break;
				}

				if (!foundSpawn)
				{
					SendErrorMessage(playerid, "Você foi enviado para o spawn padrão, seu spawn está definido para um slot inválido.");
				}
			}
		}
	}

	if (!foundSpawn)
	{
		CharacterData[playerid][e_CHARACTER_POS][0] = 1714.8267;
		CharacterData[playerid][e_CHARACTER_POS][1] = -1880.2123;
		CharacterData[playerid][e_CHARACTER_POS][2] = 13.5666;
		CharacterData[playerid][e_CHARACTER_ANGLE] = 356.0;
		CharacterData[playerid][e_CHARACTER_WORLD] = 0;
		CharacterData[playerid][e_CHARACTER_INTERIOR] = 0;
	}

	Character_SetPos(
		playerid,
		CharacterData[playerid][e_CHARACTER_POS][0],
		CharacterData[playerid][e_CHARACTER_POS][1],
		CharacterData[playerid][e_CHARACTER_POS][2],
		CharacterData[playerid][e_CHARACTER_ANGLE],
		CharacterData[playerid][e_CHARACTER_WORLD],
		CharacterData[playerid][e_CHARACTER_INTERIOR]
	);

	Inventory_UpdateHeavyItem(playerid);
	return true;
}