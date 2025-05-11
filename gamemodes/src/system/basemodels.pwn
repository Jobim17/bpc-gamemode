/*
	oooooooooo.                                    ooo        ooooo                 .o8            oooo
	`888'   `Y8b                                   `88.       .888'                "888            `888
	 888     888  .oooo.    .oooo.o  .ooooo.        888b     d'888   .ooooo.   .oooo888   .ooooo.   888   .oooo.o
	 888oooo888' `P  )88b  d88(  "8 d88' `88b       8 Y88. .P  888  d88' `88b d88' `888  d88' `88b  888  d88(  "8
	 888    `88b  .oP"888  `"Y88b.  888ooo888       8  `888'   888  888   888 888   888  888ooo888  888  `"Y88b.
	 888    .88P d8(  888  o.  )88b 888    .o       8    Y     888  888   888 888   888  888    .o  888  o.  )88b
	o888bood8P'  `Y888""8o 8""888P' `Y8bod8P'      o8o        o888o `Y8bod8P' `Y8bod88P" `Y8bod8P' o888o 8""888P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define MAX_CUSTOM_MODEL 1000

// Enum
enum
{
	CUSTOM_MODEL_TYPE_SKIN,
	CUSTOM_MODEL_TYPE_OBJECT
}

enum E_CUSTOM_MODEL_DATA
{
	bool:e_CUSTOM_MODEL_EXISTS,
	e_CUSTOM_MODEL_ID,
	e_CUSTOM_MODEL_BASE,
	e_CUSTOM_MODEL_TYPE
}

new CustomModel[MAX_CUSTOM_MODEL + 1][E_CUSTOM_MODEL_DATA];

// Callbacks
hook OnGameModeInit()
{
	// Reset
	for (new i = 0; i < MAX_CUSTOM_MODEL; i++)
		CustomModel[i] = CustomModel[MAX_CUSTOM_MODEL];

	// File read
	new File:file = f_open("./models/artconfig.txt");

	if (file)
	{	
		new out[128], id, base, loaded = 0;

		while (f_read(file, out))
		{
			if (!sscanf(out, "{'AddSimpleModel('p<,>i}p<,>ii{s[128]}", base, id))
			{
				CustomModel[loaded][e_CUSTOM_MODEL_EXISTS] = true;
				CustomModel[loaded][e_CUSTOM_MODEL_ID] = id;
				CustomModel[loaded][e_CUSTOM_MODEL_BASE] = base;
				CustomModel[loaded][e_CUSTOM_MODEL_TYPE] = CUSTOM_MODEL_TYPE_OBJECT;
				loaded += 1;
			}

			else if (!sscanf(out, "{'AddCharModel('}p<,>ii{s[128]}", base, id))
			{
				CustomModel[loaded][e_CUSTOM_MODEL_EXISTS] = true;
				CustomModel[loaded][e_CUSTOM_MODEL_ID] = id;
				CustomModel[loaded][e_CUSTOM_MODEL_BASE] = base;
				CustomModel[loaded][e_CUSTOM_MODEL_TYPE] = CUSTOM_MODEL_TYPE_SKIN;
				loaded += 1;
			}
		}

		printf("[CustomObjects] Loaded %i models.", loaded);
		f_close(file);
	}

	return true;
}

// RPCs
// ORPC:44(playerid, BitStream:bs)
// {
// 	if (IsPlayerAndroid(playerid))
// 	{
// 		static objectid, model, Float:pos[12], Float:drawdistance, cameracol, attachedobject, attachedvehicle, syncrot;

// 		// Read Values
// 		BS_ReadValue(
// 			bs,
// 			PR_UINT16, objectid,
// 			PR_UINT32, model,
// 			PR_FLOAT, pos[0],
// 			PR_FLOAT, pos[1],
// 			PR_FLOAT, pos[2],
// 			PR_FLOAT, pos[3],
// 			PR_FLOAT, pos[4],
// 			PR_FLOAT, pos[5],
// 			PR_FLOAT, drawdistance,
// 			PR_UINT8, cameracol,
// 			PR_UINT16, attachedobject,
// 			PR_UINT16, attachedvehicle,
// 			PR_FLOAT, pos[6],
// 			PR_FLOAT, pos[7],
// 			PR_FLOAT, pos[8],
// 			PR_FLOAT, pos[9],
// 			PR_FLOAT, pos[10],
// 			PR_FLOAT, pos[11],
// 			PR_UINT8, syncrot
// 		);

// 		// Check if is custom object
// 		if (-30000 <= model <= -1000)
// 		{
// 			static newmodel;
// 			newmodel = -1;

// 			for (new i = 0; i < MAX_CUSTOM_MODEL; i++) 
// 			{
// 				if (!CustomModel[i][e_CUSTOM_MODEL_EXISTS] || CustomModel[i][e_CUSTOM_MODEL_ID] != model || CustomModel[i][e_CUSTOM_MODEL_TYPE] != CUSTOM_MODEL_TYPE_OBJECT)
// 					continue;

// 				newmodel = CustomModel[i][e_CUSTOM_MODEL_BASE];
// 				break;
// 			}

// 			if (newmodel != -1)
// 			{
// 				BS_SetWriteOffset(bs, 0);

// 				BS_WriteValue(
// 					bs,
// 					PR_UINT16, objectid,
// 					PR_UINT32, newmodel,
// 					PR_FLOAT, pos[0],
// 					PR_FLOAT, pos[1],
// 					PR_FLOAT, pos[2],
// 					PR_FLOAT, pos[3],
// 					PR_FLOAT, pos[4],
// 					PR_FLOAT, pos[5],
// 					PR_FLOAT, drawdistance,
// 					PR_UINT8, cameracol,
// 					PR_UINT16, attachedobject,
// 					PR_UINT16, attachedvehicle,
// 					PR_FLOAT, pos[6],
// 					PR_FLOAT, pos[7],
// 					PR_FLOAT, pos[8],
// 					PR_FLOAT, pos[9],
// 					PR_FLOAT, pos[10],
// 					PR_FLOAT, pos[11],
// 					PR_UINT8, syncrot
// 				);
// 			}
// 		}
// 	}

// 	return true;
// }