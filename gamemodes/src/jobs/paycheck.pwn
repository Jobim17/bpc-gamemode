/*
	ooooooooo.                                   oooo                            oooo
	`888   `Y88.                                 `888                            `888
	 888   .d88'  .oooo.   oooo    ooo  .ooooo.   888 .oo.    .ooooo.   .ooooo.   888  oooo
	 888ooo88P'  `P  )88b   `88.  .8'  d88' `"Y8  888P"Y88b  d88' `88b d88' `"Y8  888 .8P'
	 888          .oP"888    `88..8'   888        888   888  888ooo888 888        888888.
	 888         d8(  888     `888'    888   .o8  888   888  888    .o 888   .o8  888 `88b.
	o888o        `Y888""8o     .8'     `Y8bod8P' o888o o888o `Y8bod8P' `Y8bod8P' o888o o888o
	                       .o..P'
	                       `Y8P'
*/

// Include
#include <YSI_Coding\y_hooks>

// Timers
hook Server_OnUpdate()
{
	foreach (new i : Player)
	{
		if (!CharacterData[i][e_CHARACTER_ID])
			continue;

		CharacterData[i][e_CHARACTER_PAYCHECK] += 1;

		if (CharacterData[i][e_CHARACTER_PAYCHECK] >= (60 * 60)) // 60 minutos
		{
			CharacterData[i][e_CHARACTER_PAYCHECK] = 0;

			new 
				bool:isDouble = (gettime() < GetGVarInt("DOUBLE_PAY")),
				oldBalance = CharacterData[i][e_CHARACTER_BANK_MONEY],
				job = CharacterData[i][e_CHARACTER_JOB],
				salary = 0,
				salaryBonus = 0,
				inssTax = 0;

			// Salary
			if (job != JOB_UNEMPLOYED)
			{
				salary = GetGVarInt("MIN_SALARY");

				// Bonificações
				if (job == JOB_TRUCKER)
				{
					salaryBonus = floatround(salary * (0.01 * CharacterData[i][e_CHARACTER_JOB_HOURS][job]));
				}

				// INSS
				inssTax += floatround((GetGVarFloat("TAX_INSS") * salary));

				// Update
				CharacterData[i][e_CHARACTER_JOB_HOURS][job] += 1;
			}

			// Check Double
			if (isDouble) 
			{	
				salary *= 2;
			}

			// Give
			CharacterData[i][e_CHARACTER_EXP] += isDouble ? 2 : 1;
			CharacterData[i][e_CHARACTER_BANK_MONEY] += isDouble ? (salary * 2) : salary;
			CharacterData[i][e_CHARACTER_BANK_MONEY] += salaryBonus;

			if (CharacterData[i][e_CHARACTER_LEVEL] == 1)
			{
				CharacterData[i][e_CHARACTER_BANK_MONEY] += 800;
			}

			if (CharacterData[i][e_CHARACTER_LEVEL] == 2)
			{
				CharacterData[i][e_CHARACTER_BANK_MONEY] += 600;
			}

			if (inssTax)
			{
				CharacterData[i][e_CHARACTER_BANK_MONEY] -= inssTax;
			}

			// Send Message
			SendClientMessageEx(i, -1, "|_______ EXTRATO ________|");
			SendClientMessageEx(i, COLOR_GREY, "Balanço: %s", FormatMoney(oldBalance));

			if (salary)
			{
				SendClientMessageEx(i, COLOR_GREY, "Salário: +%s", FormatMoney(salary));
			}

			if (salaryBonus)
			{
				SendClientMessageEx(i, COLOR_GREY, "Plano de Carreira: +%s", FormatMoney(salaryBonus));
			}

			if (inssTax)
			{
				SendClientMessageEx(i, COLOR_GREY, "Taxa INSS: -%s", FormatMoney(inssTax));
			}

			SendClientMessage(i, -1, "|_________________________|");
			SendClientMessageEx(i, COLOR_GREY, "Novo Balanço: %s", FormatMoney(CharacterData[i][e_CHARACTER_BANK_MONEY]));
		
			if (CharacterData[i][e_CHARACTER_LEVEL] == 1)
				SendClientMessage(i, -1, "(( Você recebeu ajuda inicial de $800. ))");

			if (CharacterData[i][e_CHARACTER_LEVEL] == 2)
				SendClientMessage(i, -1, "(( Você recebeu ajuda inicial de $600. ))");

			if ((CharacterData[i][e_CHARACTER_LEVEL] < 3 || Premium_GetLevel(i) >= PREMIUM_LEVEL_SILVER) && CharacterData[i][e_CHARACTER_EXP] == GetLevelExperience(CharacterData[i][e_CHARACTER_LEVEL]))
			{
				PC_EmulateCommand(i, "/levelup");

				va_GameTextForPlayer(i, "~r~Paycheck ~n~~g~+%s~n~~n~~y~Level Up!~n~~w~Nivel %i", 6000, 1, FormatMoney(CharacterData[i][e_CHARACTER_BANK_MONEY] - oldBalance), CharacterData[i][e_CHARACTER_LEVEL]);
			}
			else
			{
				va_GameTextForPlayer(i, "~r~Paycheck~n~~g~+%s", 6000, 1, FormatMoney(CharacterData[i][e_CHARACTER_BANK_MONEY] - oldBalance));	
			}
		}
	}

	return true;
}

// Functions
GetLevelExperience(level)
{
	return (8 + (4 * (level - 1)));
}

// Comandos
CMD:levelup(playerid)
{
	static
		require;

	require = GetLevelExperience(CharacterData[playerid][e_CHARACTER_LEVEL]);

	if (require > CharacterData[playerid][e_CHARACTER_EXP])
		return SendErrorMessage(playerid, "Faltam %i pontos de experiência para ir para o level %i.", require, CharacterData[playerid][e_CHARACTER_LEVEL] + 1);

	CharacterData[playerid][e_CHARACTER_LEVEL] += 1;
	SetPlayerScore(playerid, CharacterData[playerid][e_CHARACTER_LEVEL]);

	new string[32 + 1];
	format(string, sizeof(string), "~y~Level Up!~n~~w~Nivel %i", CharacterData[playerid][e_CHARACTER_LEVEL]);
	GameTextForPlayer(playerid, string, 6000, 1);

	if (Premium_GetLevel(playerid) == PREMIUM_LEVEL_NONE)
	{
		CharacterData[playerid][e_CHARACTER_EXP] = 0;
	}
	else
	{
		SendClientMessageEx(playerid, -1, "Somente %i pontos de experiência foram descontados por você ser premium.", require);
		CharacterData[playerid][e_CHARACTER_EXP] -= require;
	}
	
	Character_Save(playerid);
	return true;
}

CMD:horas(playerid)
{
	static string[128], month[12], date[6];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	switch (date[1])
	{
	    case 1: month = "Janeiro";
	    case 2: month = "Fevereiro";
	    case 3: month = "Marœo";
	    case 4: month = "Abril";
	    case 5: month = "Maio";
	    case 6: month = "Junho";
	    case 7: month = "Julho";
	    case 8: month = "Agosto";
	    case 9: month = "Setembro";
	    case 10: month = "Outubro";
	    case 11: month = "Novembro";
	    case 12: month = "Dezembro";
	}

	SendClientMessageEx(playerid, COLOR_GREEN, "%i/60 minutos para o pagamento.", CharacterData[playerid][e_CHARACTER_PAYCHECK] / 60);
	
	format(string, sizeof(string), "~w~%02d %s %d~n~~w~%02d:%02d:%02d", date[0], month, date[2], date[3], date[4], date[5]);
	GameTextForPlayer(playerid, string, 6000, 1);
	return true;
}