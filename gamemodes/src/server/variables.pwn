/*
	 .oooooo..o                                                        oooooo     oooo                     o8o             .o8       oooo
	d8P'    `Y8                                                         `888.     .8'                      `"'            "888       `888
	Y88bo.       .ooooo.  oooo d8b oooo    ooo  .ooooo.  oooo d8b        `888.   .8'    .oooo.   oooo d8b oooo   .oooo.    888oooo.   888   .ooooo.   .oooo.o
	 `"Y8888o.  d88' `88b `888""8P  `88.  .8'  d88' `88b `888""8P         `888. .8'    `P  )88b  `888""8P `888  `P  )88b   d88' `88b  888  d88' `88b d88(  "8
	     `"Y88b 888ooo888  888       `88..8'   888ooo888  888              `888.8'      .oP"888   888      888   .oP"888   888   888  888  888ooo888 `"Y88b.
	oo     .d8P 888    .o  888        `888'    888    .o  888               `888'      d8(  888   888      888  d8(  888   888   888  888  888    .o o.  )88b
	8""88888P'  `Y8bod8P' d888b        `8'     `Y8bod8P' d888b               `8'       `Y888""8o d888b    o888o `Y888""8o  `Y8bod8P' o888o `Y8bod8P' 8""888P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Callback
hook OnGameModeInit() 
{
	// Add Variables
	AddServerVariable("DOUBLE_PAY", "0", GLOBAL_VARTYPE_INT);
	AddServerVariable("CLOSED_BETA", "0", GLOBAL_VARTYPE_INT);

	AddServerVariable("MIN_SALARY", "1518", GLOBAL_VARTYPE_INT);
	AddServerVariable("TAX_INSS", "7.0", GLOBAL_VARTYPE_FLOAT);

	AddServerVariable("SERVER_MOTD", "", GLOBAL_VARTYPE_STRING);
	AddServerVariable("SPAWN_TIME", "30", GLOBAL_VARTYPE_INT);

	AddServerVariable("TIER_INTERVAL", "15", GLOBAL_VARTYPE_INT);
	AddServerVariable("TIER_BASE_BALANCE", "25000", GLOBAL_VARTYPE_INT);
	AddServerVariable("TIER_ADD_POINTS", "1", GLOBAL_VARTYPE_INT);
	AddServerVariable("TIER_ADD_BALANCE", "5000", GLOBAL_VARTYPE_INT);

	// Load Variables
	inline Variables_OnLoaded()
	{
		new rows = cache_num_rows();

		if (!rows)
			return print("[Variables] No variables to load.");

		new name[64], stringValue[256], intValue, Float:floatValue, type;

		for (new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "Nome", name);
			cache_get_value_name_int(i, "Tipo", type);

			switch (type)
			{
				case GLOBAL_VARTYPE_INT: 
				{
					cache_get_value_name_int(i, "Int", intValue);
					SetGVarInt(name, intValue);
				}

				case GLOBAL_VARTYPE_FLOAT: 
				{
					cache_get_value_name_float(i, "Float", floatValue);
					SetGVarFloat(name, floatValue);
				}

				case GLOBAL_VARTYPE_STRING:
				{
					cache_get_value_name(i, "String", stringValue);
					SetGVarString(name, stringValue);
				}
			}
		}

		printf("[Variables] Loaded %i variables.", rows);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Variables_OnLoaded, "SELECT * FROM `Variáveis`;");
	return 1;
}

// Functions
UpdateServerVariable(name[], intval = 0, Float:floatval = 0.0, stringval[] = '\0', type = GLOBAL_VARTYPE_NONE)
{
	static query[256];

	switch (type)
	{
		case GLOBAL_VARTYPE_INT: 
		{
			mysql_format(MYSQL_CUR_HANDLE, query, sizeof (query), "UPDATE `Variáveis` SET `Int`=%d WHERE `Nome`='%e'", intval, name);
			SetGVarInt(name, intval);
		}
		case GLOBAL_VARTYPE_STRING: 
		{
			mysql_format(MYSQL_CUR_HANDLE, query, sizeof (query), "UPDATE `Variáveis` SET `String`='%e' WHERE `Nome`='%e'", stringval, name);
			SetGVarString(name, stringval);
		}
		case GLOBAL_VARTYPE_FLOAT: 
		{
			mysql_format(MYSQL_CUR_HANDLE, query, sizeof (query), "UPDATE `Variáveis` SET `Float`=%f WHERE `Nome`='%e'", floatval, name);
			SetGVarFloat(name, floatval);
		}
		default:
		{
			return false; // prevent a query from being fired
		}
	}

	mysql_query(MYSQL_CUR_HANDLE, query);
	return true;
}

AddServerVariable(const name[], const value[], type)
{
	static query[300];

	switch (type)
	{
		case GLOBAL_VARTYPE_INT: 
		{
			mysql_format( MYSQL_CUR_HANDLE, query, sizeof (query), "INSERT IGNORE INTO `Variáveis`(`Nome`,`Int`,`Tipo`) VALUES ('%e',%d,%d)", name, strval(value), type);
		}
		case GLOBAL_VARTYPE_STRING: 
		{
			mysql_format( MYSQL_CUR_HANDLE, query, sizeof (query), "INSERT IGNORE INTO `Variáveis`(`Nome`,`String`,`Tipo`) VALUES ('%e','%e',%d)", name, value, type);
		}
		case GLOBAL_VARTYPE_FLOAT: 
		{
			mysql_format( MYSQL_CUR_HANDLE, query, sizeof (query), "INSERT IGNORE INTO `Variáveis`(`Nome`,`Float`,`Tipo`) VALUES ('%e',%f,%d)", name, floatstr(value), type);
		}
		default: 
		{
			return false; // prevent a query from being fired
		}
	}
	
	mysql_query(MYSQL_CUR_HANDLE, query);
	return true;
}

//_______________________________________________________________________________________

UpdateServerVariableString(variable[], value[])
{
	return UpdateServerVariable(variable, .stringval = (value), .type = GLOBAL_VARTYPE_STRING);
}

UpdateServerVariableInt(variable[], value)
{
	return UpdateServerVariable(variable, .intval = (value), .type = GLOBAL_VARTYPE_INT);
}

UpdateServerVariableFloat(variable[], Float: value)
{
	return UpdateServerVariable(variable, .floatval = (value), .type = GLOBAL_VARTYPE_FLOAT);
}