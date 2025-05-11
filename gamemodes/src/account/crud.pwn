// Include
#include <YSI_Coding\y_hooks>

// Functions
Account_Create(playerid, const pass[])
{
	if (!IsPlayerConnected(playerid) || IsNull(pass))
		return false;

	inline Account_OnCreated()
	{
		if (!cache_affected_rows())
		{
			Auth_ShowDialog(playerid, "Não foi possível criar sua conta, tente novamente.");
			return true;
		}

		AccountData[playerid][e_ACCOUNT_ID] = cache_insert_id();
		Account_Load(playerid);
		
		CallRemoteFunction("OnAccountCreated", "i", playerid);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Account_OnCreated, "INSERT IGNORE INTO `Contas` (`Nome`, `Senha`, `IP`, `Serial`, `Mobile`) VALUES ('%e', MD5('%e'), '%e', '%e', %i);", ReturnPlayerName(playerid), pass, ReturnPlayerIP(playerid), ReturnPlayerSerial(playerid), IsPlayerAndroid(playerid));
	return true;
}

Account_Load(playerid)
{
	if (!(0 <= playerid < MAX_PLAYERS) || AccountData[playerid][e_ACCOUNT_ID] < 1)
		return false;

	inline Account_OnLoaded()
	{
		if (!cache_num_rows())
		{
			return true;
		}

		cache_get_value_name_int(0, "ID", AccountData[playerid][e_ACCOUNT_ID]);
		cache_get_value_name(0, "Nome", AccountData[playerid][e_ACCOUNT_NAME]);
		cache_get_value_name_int(0, "Admin", AccountData[playerid][e_ACCOUNT_ADMIN]);
		cache_get_value_name_bool(0, "AdminHide", AccountData[playerid][e_ACCOUNT_ADMIN_HIDE]);
		cache_get_value_name_bool(0, "AdminViewChats", AccountData[playerid][e_ACCOUNT_ADMIN_VIEW_CHATS]);
		cache_get_value_name_int(0, "AdminAvaliations", AccountData[playerid][e_ACCOUNT_ADMIN_AVALIATIONS]);
		cache_get_value_name_int(0, "AdminStars", AccountData[playerid][e_ACCOUNT_ADMIN_STARS]);
		cache_get_value_name_int(0, "AdminTeams", AccountData[playerid][e_ACCOUNT_ADMIN_TEAMS]);
		cache_get_value_name_int(0, "Premium", AccountData[playerid][e_ACCOUNT_PREMIUM]);
		cache_get_value_name_int(0, "PremiumExpires", AccountData[playerid][e_ACCOUNT_PREMIUM_EXPIRES]);
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Account_OnLoaded, "SELECT * FROM `Contas` WHERE `ID` = %i LIMIT 1;", AccountData[playerid][e_ACCOUNT_ID]);
	return true;
}

Account_Save(playerid)
{
	if (!(0 <= playerid < MAX_PLAYERS) || AccountData[playerid][e_ACCOUNT_ID] < 1)
		return false;

	if (!IsPlayerLogged(playerid))
		return false;

	if (AccountData[playerid][e_ACCOUNT_ADMIN_TEMP])
	{
		AccountData[playerid][e_ACCOUNT_ADMIN] = 0;
		AccountData[playerid][e_ACCOUNT_ADMIN_TEMP] = false;
	}

	inline Account_OnSaved() {}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Account_OnSaved, 
		"UPDATE `Contas` SET \
		`Admin` = %i, \
		`AdminHide` = %i, \
		`AdminViewChats` = %i, \
		`AdminAvaliations` = %i, \
		`AdminStars` = %i, \
		`AdminTeams` = %i, \
		`Premium` = %i, \
		`PremiumExpires` = %i \
		WHERE `ID` = %i LIMIT 1;",
		AccountData[playerid][e_ACCOUNT_ADMIN],
		AccountData[playerid][e_ACCOUNT_ADMIN_HIDE],
		AccountData[playerid][e_ACCOUNT_ADMIN_VIEW_CHATS],
		AccountData[playerid][e_ACCOUNT_ADMIN_AVALIATIONS],
		AccountData[playerid][e_ACCOUNT_ADMIN_STARS],
		AccountData[playerid][e_ACCOUNT_ADMIN_TEAMS],
		AccountData[playerid][e_ACCOUNT_PREMIUM],
		AccountData[playerid][e_ACCOUNT_PREMIUM_EXPIRES],
		AccountData[playerid][e_ACCOUNT_ID]
	);

	return true;
}