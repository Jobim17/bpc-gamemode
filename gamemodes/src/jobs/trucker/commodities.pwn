/*
	  .oooooo.                                                                 .o8   o8o      .    o8o
	 d8P'  `Y8b                                                               "888   `"'    .o8    `"'
	888           .ooooo.  ooo. .oo.  .oo.   ooo. .oo.  .oo.    .ooooo.   .oooo888  oooo  .o888oo oooo   .ooooo.   .oooo.o
	888          d88' `88b `888P"Y88bP"Y88b  `888P"Y88bP"Y88b  d88' `88b d88' `888  `888    888   `888  d88' `88b d88(  "8
	888          888   888  888   888   888   888   888   888  888   888 888   888   888    888    888  888ooo888 `"Y88b.
	`88b    ooo  888   888  888   888   888   888   888   888  888   888 888   888   888    888 .  888  888    .o o.  )88b
	 `Y8bood8P'  `Y8bod8P' o888o o888o o888o o888o o888o o888o `Y8bod8P' `Y8bod88P" o888o   "888" o888o `Y8bod8P' 8""888P'

*/

// Constantes
enum
{
	COMMODITY_TYPE_LIQUID,
	COMMODITY_TYPE_LOOSE,
	COMMODITY_TYPE_CRATE,
	COMMODITY_TYPE_METAL,
	COMMODITY_TYPE_OTHER
}

enum
{
	COMMODITY_DYES,
	COMMODITY_GUNPOWDER,
	COMMODITY_COINS,
	COMMODITY_SCRAP,
	COMMODITY_WOOD,
	COMMODITY_COTTON,
	COMMODITY_MILK,
	COMMODITY_BEVERAGES,
	COMMODITY_MEAT,
	COMMODITY_CEREAL,
	COMMODITY_EGGS,
	COMMODITY_APPLIANCES,
	COMMODITY_CLOTHES,
	COMMODITY_FUEL,
	COMMODITY_FURNITURE,
	COMMODITY_FRUIT,
	COMMODITY_TRANSFORMER,
	COMMODITY_VEHICLES,
	COMMODITY_AGGREGATE,
	COMMODITY_WEAPONS,
	COMMODITY_STEEL,
	COMMODITY_PAPER,
	COMMODITY_BRICKS,
	COMMODITY_CAR_PARTS,
	COMMODITY_MEAL,
	COMMODITY_MALT,
	
	MAX_COMMODITY
}

static const s_commodityName[MAX_COMMODITY][32] = {
	"corantes",
	"pólvora",
	"moedas",
	"sucata",
	"madeira",
	"algodão",
	"leite",
	"bebidas",
	"carne",
	"cereal",
	"ovos",
	"eletrônicos",
	"roupas",
	"combustível",
	"mobília",
	"frutas",
	"transformador",
	"veículo",
	"agregado",
	"armas",
	"aço",
	"papel",
	"tijolos",
	"autopeças",
	"comida",
	"malte"
};

new const g_commodityBusinessMultiplier[MAX_COMMODITY] = {
	3,		// Corantes
	0,		// Pólvora
	100,	// Moedas
	0,		// Sucata
	0,		// Madeira
	0,		// Algodão
	0,		// Leite
	5,		// Bebidas
	0,		// Carne
	0,		// Cereal
	0,		// Ovos
	5,		// Eletrônicos
	5,		// Roupas
	10,		// Combustível
	10,		// Mobília
	0,		// Frutas
	0,		// Transformador
	3,		// Veículo
	0,		// Agregado
	10,		// Armas
	0,		// Aço
	20,		// Papel
	0, 		// Tijolos
	10,		// Car parts
	5, 		// Comida
	0		// Malte
};

new g_commodityBusinessAcceptable[MAX_BUSINESS_TYPE] = {
	COMMODITY_APPLIANCES,	// 24/7
	COMMODITY_WEAPONS,		// Gun Store
	COMMODITY_CLOTHES,		// Clothes Store 
	COMMODITY_MEAL,			// Well Stacked
	COMMODITY_VEHICLES,		// Vehicle Dealership
	COMMODITY_APPLIANCES,	// Gas Station
	COMMODITY_FURNITURE,	// Furniture Store
	-1,						// Pawn Shop
	-1,						// Joalheria
	COMMODITY_BEVERAGES,	// Bar
	COMMODITY_BEVERAGES, 	// Club
	-1,						// Casino
	-1,						// Tool Shop
	COMMODITY_CAR_PARTS,	// Car Modding
	COMMODITY_MEAL,			// Burguer Shot
	COMMODITY_MEAL,			// Cluckin Bell
	COMMODITY_MEAL,			// Coffe & Donuts
	COMMODITY_MEAL,			// Restaurant
	-1,						// Office
	COMMODITY_PAPER,		// Advertise
	-1,						// Weed Shop
	-1,						// Pharmacy
	-1,						// Library
	COMMODITY_COINS			// Bank
};

new const g_commodityType[MAX_COMMODITY] = {
	COMMODITY_TYPE_LIQUID,		// Corantes
	COMMODITY_TYPE_CRATE,		// Pólvora
	COMMODITY_TYPE_METAL,		// Moedas
	COMMODITY_TYPE_LOOSE,		// Sucata
	COMMODITY_TYPE_OTHER,		// Madeira
	COMMODITY_TYPE_CRATE,		// Algodão
	COMMODITY_TYPE_LIQUID,		// Leite
	COMMODITY_TYPE_CRATE,		// Bebidas
	COMMODITY_TYPE_CRATE,		// Carne
	COMMODITY_TYPE_LOOSE,		// Cereal
	COMMODITY_TYPE_CRATE,		// Ovos
	COMMODITY_TYPE_CRATE,		// Eletrônicos
	COMMODITY_TYPE_CRATE,		// Roupas
	COMMODITY_TYPE_LIQUID,		// Combustível
	COMMODITY_TYPE_CRATE,		// Mobília
	COMMODITY_TYPE_CRATE,		// Frutas
	COMMODITY_TYPE_OTHER,		// Transformador
	COMMODITY_TYPE_OTHER,		// Veículo
	COMMODITY_TYPE_LOOSE,		// Agregado
	COMMODITY_TYPE_METAL,		// Armas
	COMMODITY_TYPE_CRATE,		// Aço
	COMMODITY_TYPE_CRATE,		// Papel
	COMMODITY_TYPE_OTHER, 		// Tijolos
	COMMODITY_TYPE_CRATE,		// Car parts
	COMMODITY_TYPE_CRATE, 		// Comida
	COMMODITY_TYPE_LOOSE		// Malte
};

// Functions
IsValidCommodity(id)
{
	return (0 <= id < MAX_COMMODITY);
}

Commodity_GetName(id)
{
	new ret[32] = "N/A";

	if (IsValidCommodity(id))
	{
		format (ret, sizeof ret, s_commodityName[id]);
		ret[0] = toupper(ret[0]);
	}

	return ret;
}

Commodity_GetLowerName(id)
{
	new ret[32] = "N/A";

	if (IsValidCommodity(id))
	{
		format (ret, sizeof ret, s_commodityName[id]);
	}

	return ret;
}

Commodity_GetUnitName(commodity, value)
{
	new name[22 + 1];

	if ((0 <= commodity < MAX_COMMODITY))
	{
		switch (g_commodityType[commodity])
		{
			case COMMODITY_TYPE_LIQUID: format(name, sizeof name, value <= 1 ? ("litro") : ("litros"));
			case COMMODITY_TYPE_CRATE: 	format(name, sizeof name, value <= 1 ? ("caixa") : ("caixas"));
			case COMMODITY_TYPE_METAL:	format(name, sizeof name, value <= 1 ? ("caixa metálica") : ("caixas metálicas"));
			case COMMODITY_TYPE_LOOSE: 	format(name, sizeof name, value <= 1 ? ("tonelada") : ("toneladas"));
			case COMMODITY_TYPE_OTHER:
			{
				if (commodity == COMMODITY_WOOD) 
				{
					format(name, sizeof name, "troncos");
				}
				else if (commodity == COMMODITY_TRANSFORMER)
				{
					format(name, sizeof name, value <= 1 ? ("transformador") : ("transformadores"));
				}
				else if (commodity == COMMODITY_VEHICLES)
				{
					format(name, sizeof name, value <= 1 ? ("veículo") : ("veículos"));
				}
				else if (commodity == COMMODITY_BRICKS)
				{
					format(name, sizeof name, value <= 1 ? ("pallet") : ("pallets"));
				}
			}
			default: name = "N/A";
		}
	}

	return name;
}

Commodity_GetSlotSize(commodity)
{
	if (0 <= commodity < MAX_COMMODITY)
	{
		switch (commodity)
		{
			case 22: return 6;
			case 4, 16: return 18;
			default: return 1;
		}
	}

	return 0;
}

Business_IsAcceptingCargo(id)
{
	if (!(0 <= id < MAX_BUSINESS) || !BusinessData[id][e_BUSINESS_EXISTS])
		return false;

	new type = BusinessData[id][e_BUSINESS_TYPE];

	if (g_commodityBusinessAcceptable[type] == -1 || BusinessData[id][e_BUSINESS_REQUEST_CARGO] == -1 || BusinessData[id][e_BUSINESS_REQUEST_PRICE] < 1 || BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] < 1)
		return false;

	if (g_commodityBusinessAcceptable[type] != BusinessData[id][e_BUSINESS_REQUEST_CARGO] && type != BUSINESS_TYPE_GAS_STATION && BusinessData[id][e_BUSINESS_REQUEST_CARGO] != 13)
	{
		BusinessData[id][e_BUSINESS_REQUEST_CARGO] = -1;
		BusinessData[id][e_BUSINESS_REQUEST_PRICE] = 0;
		BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] = 0;
		Business_Save(id);
		return false;
	}

	if (BusinessData[id][e_BUSINESS_REQUEST_QUANTITY] > 0 && BusinessData[id][e_BUSINESS_REQUEST_PRICE] > 0 && (BusinessData[id][e_BUSINESS_REQUEST_CARGO] == g_commodityBusinessAcceptable[type] || type == BUSINESS_TYPE_GAS_STATION && BusinessData[id][e_BUSINESS_REQUEST_CARGO] == 13))
	{
		return true;
	}

	return false;
}