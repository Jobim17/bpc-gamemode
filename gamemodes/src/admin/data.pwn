/*
	      .o.             .o8                     o8o                   oooooooooo.                 .
	     .888.           "888                     `"'                   `888'   `Y8b              .o8
	    .8"888.      .oooo888  ooo. .oo.  .oo.   oooo  ooo. .oo.         888      888  .oooo.   .o888oo  .oooo.
	   .8' `888.    d88' `888  `888P"Y88bP"Y88b  `888  `888P"Y88b        888      888 `P  )88b    888   `P  )88b
	  .88ooo8888.   888   888   888   888   888   888   888   888        888      888  .oP"888    888    .oP"888
	 .8'     `888.  888   888   888   888   888   888   888   888        888     d88' d8(  888    888 . d8(  888
	o88o     o8888o `Y8bod88P" o888o o888o o888o o888o o888o o888o      o888bood8P'   `Y888""8o   "888" `Y888""8o

*/

enum (<<=1)
{
	e_ADMIN_NO_TEAMS,
	e_ADMIN_TEAM_PROPERTY,
	e_ADMIN_TEAM_FACTION,
	e_ADMIN_TEAM_REFUND,
	e_ADMIN_TEAM_EVENT
}

new g_arrAdminTeamName[][16] = {
	{"Nenhuma"},
	{"Property Team"},
	{"Faction Team"},
	{"Refund Team"},
	{"Event Team"}
};

enum
{
	NO_ADMIN = 0,
	JUNIOR_ADMIN,
	GAME_ADMIN_I,
	GAME_ADMIN_II,
	SENIOR_ADMIN,
	LEAD_ADMIN,
	MANAGER,
	MAX_ADMIN_LEVEL
}

new g_arrAdminLevelName[][16] = {
	{"Nenhum"},
	{"Junior Admin"},
	{"Game Admin I"},
	{"Game Admin II"},
	{"Sênior Admin"},
	{"Lead Admin"},
	{"Manager"}
};