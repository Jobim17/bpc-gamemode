/*
	 .oooooo..o     .                          .
	d8P'    `Y8   .o8                        .o8
	Y88bo.      .o888oo  .oooo.   oooo d8b .o888oo oooo  oooo  oo.ooooo.
	 `"Y8888o.    888   `P  )88b  `888""8P   888   `888  `888   888' `88b
	     `"Y88b   888    .oP"888   888       888    888   888   888   888
	oo     .d8P   888 . d8(  888   888       888 .  888   888   888   888
	8""88888P'    "888" `Y888""8o d888b      "888"  `V88V"V8P'  888bod8P'
	                                                            888
	                                                           o888o
*/

// Includes
#include <YSI_Coding\y_hooks>

// Váriaveis
static MySQL:s_MySQLHandle = MYSQL_INVALID_HANDLE;

// Callbacks
hook OnGameModeInit()
{
	s_MySQLHandle = mysql_connect(
		MYSQL_CONNECTION_HOST,
		MYSQL_CONNECTION_USER,
		MYSQL_CONNECTION_PASS,
		MYSQL_CONNECTION_DATABASE
	);

	if (s_MySQLHandle == MYSQL_INVALID_HANDLE || mysql_errno(s_MySQLHandle)) 
	{
		SendRconCommand("password loremipsumdolorsitamet");
		SendRconCommand("hostname "SERVER_HOSTNAME" | Acesso indisponível");
		SetGameModeText("Banco de dados inválido.");
		printf("Não foi possível estabelecer conexão MySQL");
		return Y_HOOKS_BREAK_RETURN_0;
	}

	mysql_set_charset("latin1");
	print("Conexão ao banco de dados estabelecida.");
	return true;	
}

// Functions
MySQL:GetSQLHandle()
{
	return s_MySQLHandle;
}