// Include
#include <YSI_Coding\y_hooks>

// Váriáveis
static s_pSearchLog[MAX_PLAYERS][32];
static bool:s_pLogSearching[MAX_PLAYERS] = {false, ...};

// Functions
Log_Show(playerid, const log[] = "\0", const search[] = "\0", bool:bSearch = false)
{
	if (!IsPlayerConnected(playerid)) 
		return false;

	s_pLogSearching[playerid] = bSearch;

	if (IsNull(log))
	{
		inline Log_OnSearchTypes()
		{
			if (!cache_num_rows())
				return SendErrorMessage(playerid, "Nenhum resultado obtido.");

			new dialog[1024], field[32], registros;

			for (new i = 0, j = cache_num_rows(); i < j; i++)
			{
				cache_get_value_name(i, "Tipo", field);
				cache_get_value_name_int(i, "Registros", registros);

				strcat (dialog, field);
				strcat (dialog, "\t[{AFAFAF}");
				strcat (dialog, FormatNumber(registros));
				strcat (dialog, "{FFFFFF}]");
				strcat (dialog, "\n");
			}

			Dialog_Show(playerid, DIALOG_LOG_MENU, DIALOG_STYLE_TABLIST, "Logs", dialog, "Exibir", "Fechar");
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Log_OnSearchTypes, "SELECT `Tipo`, COUNT(*) AS `Registros` FROM `Logs` GROUP BY `Tipo`;");
	}
	else
	{
		if (bSearch && IsNull(search))
		{	
			format (s_pSearchLog[playerid], sizeof s_pSearchLog[], log);
			Dialog_Show(playerid, DIALOG_SEARCH_LOG, DIALOG_STYLE_INPUT, va_return("{FFFFFF}Log: {AFAFAF}%s", log), "{FFFFFF}Digite abaixo o texto a ser buscado:", "Buscar", "Cancelar");
			return true;
		}

		inline Log_OnSearchFound()
		{
			new rows = cache_num_rows();

			if (!rows)
				return SendErrorMessage(playerid, "Nenhum resultado obtido.");

			new dialog[1024 + 2056], data[32 + 1], texto[128];

			format (dialog, sizeof dialog, "{E1E1E1}Exibindo %i registro%s%s:\n", rows, (rows > 1) ? ("s") : (""), (rows > 1) ? (", estão em ordem decrescente de data e hora") : (""));

			for (new i = 0, j = cache_num_rows(); i < j; i++)
			{
				cache_get_value_name(i, "DataFormat", data);
				cache_get_value_name(i, "Texto", texto);

				strcat (dialog, "\n{AFAFAF}");
				strcat (dialog, data);
				strcat (dialog, (i % 2 ? ("{E1E1E1}") : ("{FFFFFF}")));
				strcat (dialog, texto);
			}

			Dialog_Show(playerid, DIALOG_LOG_SHOW, DIALOG_STYLE_MSGBOX, va_return("{FFFFFF}Log: {AFAFAF}%s", log), dialog, "Voltar", "Fechar");
		}

		MySQL_TQueryInline(MYSQL_CUR_HANDLE, using inline Log_OnSearchFound, "SELECT DATE_FORMAT(`Data`, \"[%%d/%%m/%%Y %%H:%%i:%%s] \") AS `DataFormat`, `Texto` FROM `Logs` WHERE `Tipo` = '%e' AND (`Texto` LIKE '%%%e%%' OR '%e' IS NULL) ORDER BY `Data` DESC LIMIT 20;", log, search, search);
	}
	return true;
}

Log_Create(const type[], const text[], va_args<>)
{
	new logQuery[512 + 1], out[512 + 1];
	va_format(out, sizeof out, text, va_start<2>);
	mysql_format(MYSQL_CUR_HANDLE, logQuery, sizeof logQuery, "INSERT INTO `Logs` (`Tipo`, `Texto`) VALUES ('%e', '%e');", type, out);
	mysql_tquery(MYSQL_CUR_HANDLE, logQuery);
	return true;
}

// Dialogs
Dialog:DIALOG_SEARCH_LOG(playerid, response, listitem, inputtext[])
{
	if (!response || IsNull(inputtext))
		return true;

	Log_Show(playerid, s_pSearchLog[playerid], inputtext);
	return true;
}

Dialog:DIALOG_LOG_MENU(playerid, response, listitem, inputtext[])
{
	if (!response)
		return false;

	Log_Show(playerid, inputtext, .bSearch = s_pLogSearching[playerid]);
	return true;
}

Dialog:DIALOG_LOG_SHOW(playerid, response, listitem, inputtext[])
{
	if (!response)
		return false;

	Log_Show(playerid);
	return true;
}