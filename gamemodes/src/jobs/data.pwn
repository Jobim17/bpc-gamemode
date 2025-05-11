/*
	oooooooooo.                 .
	`888'   `Y8b              .o8
	 888      888  .oooo.   .o888oo  .oooo.
	 888      888 `P  )88b    888   `P  )88b
	 888      888  .oP"888    888    .oP"888
	 888     d88' d8(  888    888 . d8(  888
	o888bood8P'   `Y888""8o   "888" `Y888""8o

*/

enum 
{
	JOB_UNEMPLOYED = -1,
	JOB_TRUCKER,
	JOB_FRENTISTA,
	JOB_BUTCHER,
	JOB_TAXI,
	MAX_JOB
}

new g_aJobNames[MAX_JOB][16 + 1] = {
	"Caminhoneiro",
	"Frentista",
	"Açougueiro",
	"Taxista"
};

/*
	ooooo                   .o8                           .             o8o
	`888'                  "888                         .o8             `"'
	 888  ooo. .oo.    .oooo888  oooo  oooo   .oooo.o .o888oo oooo d8b oooo   .ooooo.   .oooo.o
	 888  `888P"Y88b  d88' `888  `888  `888  d88(  "8   888   `888""8P `888  d88' `88b d88(  "8
	 888   888   888  888   888   888   888  `"Y88b.    888    888      888  888ooo888 `"Y88b.
	 888   888   888  888   888   888   888  o.  )88b   888 .  888      888  888    .o o.  )88b
	o888o o888o o888o `Y8bod88P"  `V88V"V8P' 8""888P'   "888" d888b    o888o `Y8bod8P' 8""888P'
	
*/

// Constants
#define MAX_INDUSTRY 35
#define MAX_INDUSTRY_STORAGE 100

// Data
enum E_INDUSTRY_DATA
{
	bool:e_INDUSTRY_EXISTS,

	e_INDUSTRY_ID,
	e_INDUSTRY_NAME[32],
	e_INDUSTRY_TYPE,
	bool:e_INDUSTRY_LOCKED
}

new IndustryData[MAX_INDUSTRY + 1][E_INDUSTRY_DATA];
new Iterator:Industries<MAX_INDUSTRY>;

enum E_INDUSTRY_STORAGE_DATA
{
	bool:e_INDUSTRY_STORAGE_EXISTS,
	e_INDUSTRY_STORAGE_ICON,
	Text3D:e_INDUSTRY_STORAGE_LABEL,

	e_INDUSTRY_STORAGE_ID,
	e_INDUSTRY_STORAGE_PATTERN,
	Float:e_INDUSTRY_STORAGE_POS[3],
	e_INDUSTRY_STORAGE_INTERIOR,
	e_INDUSTRY_STORAGE_WORLD,
	e_INDUSTRY_STORAGE_STOCK,
	e_INDUSTRY_STORAGE_STOCK_SIZE,
	e_INDUSTRY_STORAGE_CONSUMPTION,
	e_INDUSTRY_STORAGE_COMMODITY,
	e_INDUSTRY_STORAGE_PRICE,
	bool:e_INDUSTRY_STORAGE_SELLING
}

new IndustryStorageData[MAX_INDUSTRY_STORAGE + 1][E_INDUSTRY_STORAGE_DATA];
new Iterator:IndustryStorages<MAX_INDUSTRY_STORAGE>;