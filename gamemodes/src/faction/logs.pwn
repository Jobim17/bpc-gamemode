/*
	oooooooooooo                         .    o8o                             ooooo
	`888'     `8                       .o8    `"'                             `888'
	 888          .oooo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.         888          .ooooo.   .oooooooo  .oooo.o
	 888oooo8    `P  )88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b        888         d88' `88b 888' `88b  d88(  "8
	 888    "     .oP"888  888         888    888  888   888  888   888        888         888   888 888   888  `"Y88b.
	 888         d8(  888  888   .o8   888 .  888  888   888  888   888        888       o 888   888 `88bod8P'  o.  )88b
	o888o        `Y888""8o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o      o888ooooood8 `Y8bod8P' `8oooooo.  8""888P'
	                                                                                                 d"     YD
	                                                                                                 "Y88888P'
*/

// Functions
FactionLog_Create(facid, userid, const action[], const log[], va_args<>)
{
	if (!(0 <= facid < MAX_FACTIONS) || !FactionData[facid][e_FACTION_EXISTS])
		return false;

	if (!IsPlayerLogged(userid) || !CharacterData[id][e_CHARACTER_ID])
		return false;

	inline FactionLog_Created() {	}

	

	return true;
}