/*
	ooooooooooooo                           .
	8'   888   `8                         .o8
	     888       .ooooo.  oooo    ooo .o888oo oooo  oooo  oooo d8b  .ooooo.   .oooo.o
	     888      d88' `88b  `88b..8P'    888   `888  `888  `888""8P d88' `88b d88(  "8
	     888      888ooo888    Y888'      888    888   888   888     888ooo888 `"Y88b.
	     888      888    .o  .o8"'88b     888 .  888   888   888     888    .o o.  )88b
	    o888o     `Y8bod8P' o88'   888o   "888"  `V88V"V8P' d888b    `Y8bod8P' 8""888P'
	
*/

// Include
#include <YSI_Coding\y_hooks>

// Constants
#define MAX_LISTED_TEXTURE 50

// Variáveis
static s_pTextureSearchObject[MAX_PLAYERS] = {-1, ...};
static s_pTextureSearchName[MAX_PLAYERS][64];
static s_pTextureSearchTexture[MAX_PLAYERS][64];

static s_pTexturePage[MAX_PLAYERS] = {0, ...};
static s_pListedTexture[MAX_PLAYERS + 1][MAX_LISTED_TEXTURE];

// Dialogs
Dialog:DIALOG_TXT_MENU(playerid, response, listitem, inputtext[])
{	
	new id = FurnitureInv_GetSelected(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureInv_ShowTextures(playerid, id);

	switch (listitem)
	{
		case 0: // ID de Objeto
		{
			Dialog_Show(playerid, DIALOG_TXT_SRCH_MODEL, DIALOG_STYLE_INPUT, "Buscar textura pelo ID de objeto:", "Especifique o ID do objeto que você deseja ver as texturas:", "Buscar", "<<");
		}

		case 1: // ID do Texture
		{
			Dialog_Show(playerid, DIALOG_TXT_SRCH_INDEX, DIALOG_STYLE_INPUT, "Buscar textura pelo ID do Texture Studio:", "Especifique o ID da textura no Texture Studio que você quer usar:", "Buscar", "<<");
		}

		case 2: // Nome do objeto
		{
			Dialog_Show(playerid, DIALOG_TXT_SRCH_NAME, DIALOG_STYLE_INPUT, "Buscar textura pelo nome do objeto:", "Especifique o nome do objeto que você deseja obter a lista de texturas:", "Buscar", "<<");
		} 

		case 3: // Textura
		{
			Dialog_Show(playerid, DIALOG_TXT_SRCH_TEXTURE, DIALOG_STYLE_INPUT, "Buscar textura pelo nome:", "Especifique o nome da textura que você deseja obter:", "Buscar", "<<");
		} 

		default: FurnitureTexture_ShowMenu(playerid);
	}
	return true;
}

Dialog:DIALOG_TXT_SRCH_MODEL(playerid, response, listitem, inputtext[])
{
	new id = FurnitureInv_GetSelected(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureTexture_ShowMenu(playerid);

	if (!IsNumeric(inputtext) || IsNull(inputtext))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_MODEL, DIALOG_STYLE_INPUT, "Buscar textura pelo ID de objeto:", "Erro: Apenas números são aceitos.\nEspecifique o ID do objeto que você deseja ver as texturas:", "Buscar", "<<");		
		return true;
	}

	if (!FurnitureTexture_ShowList(playerid, .object = strval(inputtext)))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_MODEL, DIALOG_STYLE_INPUT, "Buscar textura pelo ID de objeto:", "Erro: Nenhum resultado obtido.\nEspecifique o ID do objeto que você deseja ver as texturas:", "Buscar", "<<");		
	}
	return true;
}

Dialog:DIALOG_TXT_SRCH_INDEX(playerid, response, listitem, inputtext[])
{
	new id = FurnitureInv_GetSelected(playerid), index = FurnitureInv_GetMaterialIndex(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response || !(0 <= index < MAX_FURNITURE_TEXTURE))
		return FurnitureTexture_ShowMenu(playerid);

	if (!IsNumeric(inputtext) || IsNull(inputtext))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_INDEX, DIALOG_STYLE_INPUT, "Buscar textura pelo ID do Texture Studio:", "Erro: Apenas números são aceitos.\nEspecifique o ID da textura no Texture Studio que você quer usar:", "Buscar", "<<");
		return true;
	}

	if (!(1 <= strval(inputtext) <= 9064))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_INDEX, DIALOG_STYLE_INPUT, "Buscar textura pelo ID do Texture Studio:", "Erro: O ID da textura deve ser de 1 a 9064.\nEspecifique o ID da textura no Texture Studio que você quer usar:", "Buscar", "<<");
		return true;
	}

	FurnitureData[id][e_FURNITURE_TEXTURE][index] = strval(inputtext);
	Furniture_Refresh(id);
	Furniture_Save(id);
	FurnitureInv_ShowTextures(playerid, id);
	return true;
}

Dialog:DIALOG_TXT_SRCH_NAME(playerid, response, listitem, inputtext[])
{
	new id = FurnitureInv_GetSelected(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureTexture_ShowMenu(playerid);

	if (IsNull(inputtext))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_NAME, DIALOG_STYLE_INPUT, "Buscar textura pelo nome do objeto:", "Erro: Este campo não pode estar vazio.\nEspecifique o nome do objeto que você deseja obter a lista de texturas:", "Buscar", "<<");
		return true;
	}

	if (!FurnitureTexture_ShowList(playerid, .name = inputtext))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_NAME, DIALOG_STYLE_INPUT, "Buscar textura pelo nome do objeto:", "Erro: Nenhum resultado obtido.\nEspecifique o nome do objeto que você deseja obter a lista de texturas:", "Buscar", "<<");
	}
	return true;
}

Dialog:DIALOG_TXT_SRCH_TEXTURE(playerid, response, listitem, inputtext[])
{
	new id = FurnitureInv_GetSelected(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response)
		return FurnitureTexture_ShowMenu(playerid);

	if (IsNull(inputtext))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_TEXTURE, DIALOG_STYLE_INPUT, "Buscar textura pelo nome:", "Erro: Este campo não pode estar vazio.\nEspecifique o nome da textura que você deseja obter:", "Buscar", "<<");
		return true;
	}

	if (!FurnitureTexture_ShowList(playerid, .texture = inputtext))
	{
		Dialog_Show(playerid, DIALOG_TXT_SRCH_TEXTURE, DIALOG_STYLE_INPUT, "Buscar textura pelo nome:", "Erro: Nenhum resultado obtido.\nEspecifique o nome da textura que você deseja obter:", "Buscar", "<<");
	}
	return true;
}

Dialog:DIALOG_TXT_FOUND(playerid, response, listitem, inputtext[])
{
	new id = FurnitureInv_GetSelected(playerid), index = FurnitureInv_GetMaterialIndex(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	if (!response || !(0 <= index < MAX_FURNITURE_TEXTURE))
		return FurnitureTexture_ShowMenu(playerid);

	// Página anterior
	if (!strcmp(inputtext, "<< Página anterior") || !strcmp(inputtext, "<< Pagina anterior"))
	{
		FurnitureTexture_ShowList(playerid, s_pTexturePage[playerid] - 1, s_pTextureSearchObject[playerid], s_pTextureSearchName[playerid], s_pTextureSearchTexture[playerid]);
	}

	// Próxima página
	else if (!strcmp(inputtext, "Próxima página >>") || !strcmp(inputtext, "Proxima pagina >>"))
	{
		FurnitureTexture_ShowList(playerid, s_pTexturePage[playerid] + 1, s_pTextureSearchObject[playerid], s_pTextureSearchName[playerid], s_pTextureSearchTexture[playerid]);
	}

	else if ((0 <= listitem < MAX_LISTED_TEXTURE))
	{
		FurnitureData[id][e_FURNITURE_TEXTURE][index] = s_pListedTexture[playerid][listitem];
		Furniture_Refresh(id);
		Furniture_Save(id);
		FurnitureInv_ShowTextures(playerid, id);
	}

	else
	{
		FurnitureInv_ShowTextures(playerid, id);
	}
	return true;
}

// Functions
FurnitureTexture_ShowMenu(playerid)
{
	new id = FurnitureInv_GetSelected(playerid);

	if (!Furniture_Check(playerid, id, true))
		return false;

	Dialog_Show(playerid, DIALOG_TXT_MENU, DIALOG_STYLE_LIST, "Buscar textura:", "Buscar texturas pelo ID do objeto\nBuscar textura pelo ID do Texture Studio\nBuscar texturas pelo nome do objeto\nBuscar texturas pelo nome da textura", "Selecionar", "<<");
	return true;
}

FurnitureTexture_ShowList(playerid, page = 0, object = -1, const name[] = "", const texture[] = "")
{
	new totalPage = 0, totalFound = 0, offset;
	s_pListedTexture[playerid] = s_pListedTexture[MAX_PLAYERS];

	// Count total textures
	for (new i = 1; i < sizeof g_aTextures; i++)
	{
		// Search Objects
		if (object != -1 && g_aTextures[i][e_TEXTURE_OBJECT] != object)
			continue;

		// Search Object Name
		if (!IsNull(name) && strfind(g_aTextures[i][e_TEXTURE_LIB], name, true) == -1)
			continue;

		// Search Texture Name
		if (!IsNull(texture) && strfind(Furniture_GetTextureName(i), texture, true) == -1)
			continue;

		totalFound += 1;
	}

	if (!totalFound)
		return SendErrorMessage(playerid, "Nenhuma textura encontrada."), 0;

	totalPage = (totalFound + MAX_LISTED_TEXTURE - 1) / MAX_LISTED_TEXTURE;

	if (page < 0) page = 0;
	if (page > totalPage) page = (totalPage - 1);

	offset = (page * MAX_LISTED_TEXTURE);

	// List
	new listed = 0, dialog[4096] = "{FFFFFF}", title[32];
	format (title, sizeof title, "Texturas (página %i/%i)", page + 1, totalPage);

	for (new i = 1; i < sizeof g_aTextures; i++)
	{
		// Search Objects
		if (object != -1 && g_aTextures[i][e_TEXTURE_OBJECT] != object)
			continue;

		// Search Object Name
		if (!IsNull(name) && strfind(g_aTextures[i][e_TEXTURE_LIB], name, true) == -1)
			continue;

		// Search Texture Name
		if (!IsNull(texture) && strfind(Furniture_GetTextureName(i), texture, true) == -1)
			continue;

		// Limit per page
		if (listed >= MAX_LISTED_TEXTURE)
			break;

		// Offset check
		if (offset) 
		{
			offset -= 1;
			continue;
		}

		// List
		if (listed) strcat(dialog, "\n");
		strcat (dialog, Furniture_GetTextureName(i));

		s_pListedTexture[playerid][listed] = i;
		listed += 1;
	}

	// Pagination
	if (page > 0)
	{
		strcat(dialog, "\n{BBBBBB}<< Página anterior");
	}

	if (listed == MAX_LISTED_TEXTURE && page < (totalPage - 1))
	{
		strcat(dialog, "\n{BBBBBB}Próxima página >>");
	}

	s_pTexturePage[playerid] = page;
	s_pTextureSearchObject[playerid] = object;
	format (s_pTextureSearchName[playerid], 64, name);
	format (s_pTextureSearchTexture[playerid], 64, texture);
	Dialog_Show(playerid, DIALOG_TXT_FOUND, DIALOG_STYLE_LIST, title, dialog, "Selecionar", "<<");
	return listed;	
}