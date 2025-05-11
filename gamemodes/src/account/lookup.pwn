/*
	ooooo                            oooo
	`888'                            `888
	 888          .ooooo.   .ooooo.   888  oooo  oooo  oooo  oo.ooooo.
	 888         d88' `88b d88' `88b  888 .8P'   `888  `888   888' `88b
	 888         888   888 888   888  888888.     888   888   888   888
	 888       o 888   888 888   888  888 `88b.   888   888   888   888
	o888ooooood8 `Y8bod8P' `Y8bod8P' o888o o888o  `V88V"V8P'  888bod8P'
	                                                          888
	                                                         o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define HTTP_IP_API_URL	"ip-api.com/csv"
#define HTTP_IP_API_END "?lang=pt-BR&fields=status,continent,country,regionName,city,isp,org,as,proxy,hosting"

// Callbacks
hook OnAccountLoggedIn(playerid)
{
	if (LookupData[playerid][e_LOOKUP_VPN])
	{
		Log_Create("VPN", "[%i] %s - País: %s - IP: %s", AccountData[playerid][e_ACCOUNT_NAME], AccountData[playerid][e_ACCOUNT_NAME], LookupData[playerid][e_LOOKUP_COUNTRY], ReturnPlayerIP(playerid));
		Admin_SendMessage(1, COLOR_LIGHTRED, "[Proxy] %s (%i) está usando Proxy/VPN (%s)", AccountData[playerid][e_ACCOUNT_NAME], playerid, LookupData[playerid][e_LOOKUP_COUNTRY]);
	}

	// Atividade Suspeita
	inline Lookup_Retrieve()
	{
		if (!cache_num_rows())
			return false;

		static 
			text[1024],
			ip[16 + 1], 
			serial[40 + 1], 
			mobile, 
			city[64 + 1], 
			country[64 + 1], 
			region[64 + 1], 
			count
		;

		count = 0;
		text = "";

		cache_get_value_name(0, "IP", ip);
		cache_get_value_name(0, "Serial", serial);
		cache_get_value_name_int(0, "Mobile", mobile);
		cache_get_value_name(0, "Cidade", city);
		cache_get_value_name(0, "País", country);
		cache_get_value_name(0, "Estado", region);

		// IP
		if (strcmp(ip, ReturnPlayerIP(playerid), false))
		{
			strcat (text, "<n><n>{FF6347}Mudança de IP:<n>");
			strcat (text, va_return("<t>{BBBBBB}%s {FFFFFF}-> {BBBBBB}%s %s", ip, ReturnPlayerIP(playerid), LookupData[playerid][e_LOOKUP_VPN] ? ("(VPN)") : ("")));
			count += 1;
		}

		// Serial
		if (strcmp(serial, ReturnPlayerSerial(playerid), false))
		{
			strcat (text, "<n><n>{FF6347}Mudança de Serial:<n>");
			strcat (text, va_return("<t>{BBBBBB}%s {FFFFFF}-> {BBBBBB}%s", serial, ReturnPlayerSerial(playerid)));
			count += 1;
		}

		// Cidade, Estado, País
		if (strcmp(city, LookupData[playerid][e_LOOKUP_CITY], false) && city[0] != '\0' || strcmp(region, LookupData[playerid][e_LOOKUP_STATE], false) && region[0] != '\0' || strcmp(country, LookupData[playerid][e_LOOKUP_COUNTRY], false) && country[0] != '\0')
		{
			strcat (text, "<n><n>{FF6347}Novo Local de Acesso:<n>");
			strcat (text, va_return("<t>{BBBBBB}%s, %s, %s %s", LookupData[playerid][e_LOOKUP_CITY], LookupData[playerid][e_LOOKUP_STATE], LookupData[playerid][e_LOOKUP_COUNTRY], LookupData[playerid][e_LOOKUP_VPN] ? ("(VPN)") : ("")));
			count += 1;
		}

		// Plataforma
		if (mobile != IsPlayerAndroid(playerid))
		{
			strcat (text, "<n><n>{FF6347}Mudança de Plataforma:<n>");
			strcat (text, va_return("<t>{BBBBBB}%s {FFFFFF}-> {BBBBBB}%s", (IsPlayerAndroid(playerid) ? ("Computador") : ("Mobile")), (IsPlayerAndroid(playerid) ? ("Mobile") : ("Computador"))));
			count += 1;
		}

		if (count)
		{
			inline SuspectActivity_Insert()
			{
				if (cache_affected_rows())
				{
					Log_Create("Atividade suspeita", "[%i] %s - %i %s (/checaratividade %i)", AccountData[playerid][e_ACCOUNT_ID], AccountData[playerid][e_ACCOUNT_NAME], count, count > 1 ? ("alterações") : ("alteração"), cache_insert_id());
					Admin_SendMessage(1, COLOR_LIGHTRED, "[Suspeita] Um novo registro de atividade suspeita foi incluído na conta de %s (/checaratividade %i)", AccountData[playerid][e_ACCOUNT_NAME], cache_insert_id());
				}
			}

			MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline SuspectActivity_Insert, "INSERT IGNORE INTO `AtividadeSuspeita` (`Conta`, `Título`, `Texto`) VALUES (%i, '%i %e', '%e');", AccountData[playerid][e_ACCOUNT_ID], count, count > 1 ? ("alterações") : ("alteração"), text);
		}
	}

	MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Lookup_Retrieve, "SELECT `IP`, `Serial`, `Mobile`, `Cidade`, `País`, `Estado` FROM `Contas` WHERE `ID` = %i LIMIT 1;", AccountData[playerid][e_ACCOUNT_ID]);
	
	// Atualizar informações
	inline Lookup_Update() {}

	MySQL_TQueryInline(
		MYSQL_CUR_HANDLE, 
		using inline Lookup_Update, 
		"UPDATE IGNORE `Contas` SET \
		`IP` = '%e',\
		`Serial` = '%e',\
		`Mobile` = %i, \
		`Cidade` = '%e', \
		`Estado` = '%e', \
		`País` = '%e', \
		`VPN` = %i, \
		`Login` = NOW() \
		WHERE `ID` = %i LIMIT 1;",
		ReturnPlayerIP(playerid),
		ReturnPlayerSerial(playerid),
		IsPlayerAndroid(playerid),
		LookupData[playerid][e_LOOKUP_CITY],
		LookupData[playerid][e_LOOKUP_STATE],
		LookupData[playerid][e_LOOKUP_COUNTRY],
		LookupData[playerid][e_LOOKUP_VPN],
		AccountData[playerid][e_ACCOUNT_ID]
	);
	return true;
}

hook OnPlayerConnect(playerid)
{
	static empty[E_LOOKUP_DATA];
	LookupData[playerid] = empty;

	static query[144];
	format (query, sizeof query, "%s/%s%s", HTTP_IP_API_URL, ReturnPlayerIP(playerid), HTTP_IP_API_END);
	HTTP(playerid, HTTP_GET, query, "", "Lookup_OnGetInfo");
	return true;
}

forward Lookup_OnGetInfo(playerid, response_code, data[]);
public Lookup_OnGetInfo(playerid, response_code, data[])
{
	if (response_code == 200)
	{
    	new output[10][64], out[1024];

    	utf8decode(out, data);
    	strexplode(output, out, ",");

    	// Status
		LookupData[playerid][e_LOOKUP_SUCCESS] = true;

		// Get infos
		LookupData[playerid][e_LOOKUP_CONTINENT] = output[1];
		LookupData[playerid][e_LOOKUP_COUNTRY] = output[2];
		LookupData[playerid][e_LOOKUP_STATE] = output[3];
		LookupData[playerid][e_LOOKUP_CITY] = output[4];
		LookupData[playerid][e_LOOKUP_ISP] = output[5];
		LookupData[playerid][e_LOOKUP_ORG] = output[6];
		LookupData[playerid][e_LOOKUP_AS] = output[7];

		if (strcmp(output[8], "false") || strcmp(output[9], "false"))
		{
			LookupData[playerid][e_LOOKUP_VPN] = true;
		}
		else
		{
			LookupData[playerid][e_LOOKUP_VPN] = false;	
		}
	}
	else
	{
		LookupData[playerid][e_LOOKUP_SUCCESS] = false;
	}

	return true;
}