/*
	oooooooooo.                 .                  ooooooooo.                                         o8o
	`888'   `Y8b              .o8                  `888   `Y88.                                       `"'
	 888      888  .oooo.   .o888oo  .oooo.         888   .d88' oooo d8b  .ooooo.  ooo. .oo.  .oo.   oooo  oooo  oooo  ooo. .oo.  .oo.
	 888      888 `P  )88b    888   `P  )88b        888ooo88P'  `888""8P d88' `88b `888P"Y88bP"Y88b  `888  `888  `888  `888P"Y88bP"Y88b
	 888      888  .oP"888    888    .oP"888        888          888     888ooo888  888   888   888   888   888   888   888   888   888
	 888     d88' d8(  888    888 . d8(  888        888          888     888    .o  888   888   888   888   888   888   888   888   888
	o888bood8P'   `Y888""8o   "888" `Y888""8o      o888o        d888b    `Y8bod8P' o888o o888o o888o o888o  `V88V"V8P' o888o o888o o888o
	
*/

// Constants
enum 
{
	PREMIUM_LEVEL_NONE = 0,
	PREMIUM_LEVEL_BRONZE,
	PREMIUM_LEVEL_SILVER,
	PREMIUM_LEVEL_GOLD,
	MAX_PREMIUM_LEVEL
}

static s_arrayPremiumNames[MAX_PREMIUM_LEVEL][16] = {
	{"Nenhum"},
	{"Bronze"},
	{"Prata"},
	{"Ouro"}
};

static s_arrayPremiumColors[MAX_PREMIUM_LEVEL] = {
	0xFFFFFFFF,
	0xcd7f32FF,
	0xc0c0c0FF,
	0xffbf00FF
};

// Get
Premium_GetLevel(playerid)
{
	if (AccountData[playerid][e_ACCOUNT_PREMIUM_EXPIRES] > gettime())
		return false;

	return AccountData[playerid][e_ACCOUNT_PREMIUM];
}

Premium_GetName(level)
{
	new ret[16] = "Nenhum";

	if ((PREMIUM_LEVEL_BRONZE <= level < MAX_PREMIUM_LEVEL))
	{
		format (ret, sizeof ret, s_arrayPremiumNames[level]);
	}

	return ret;
}