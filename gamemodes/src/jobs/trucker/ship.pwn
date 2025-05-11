/*
	 .oooooo..o oooo         o8o
	d8P'    `Y8 `888         `"'
	Y88bo.       888 .oo.   oooo  oo.ooooo.
	 `"Y8888o.   888P"Y88b  `888   888' `88b
	     `"Y88b  888   888   888   888   888
	oo     .d8P  888   888   888   888   888
	8""88888P'  o888o o888o o888o  888bod8P'
	                               888
	                              o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Constante
#define MAX_SHIP_OBJECT 10

// Forwards
forward OnCargoShipDocked();
public OnCargoShipUndocked();

// Data
static s_shipNames[][16] = {
	"Santos Dumont",
	"São Jorge",
	"Salvador",
	"Porto Belo",
	"Caramuru",
	"São Mateus",
	"Niemeyer",
	"Maracanaú",
	"Santa Cruz",
	"São Lucas",
	"Ayrton Senna",
	"Strapazzon",
	"Batista",
	"Atlas",
	"FatCl Express",
	"Pagnussat",
	"Domenico DeSaa", 
	"Bela Vista", 
	"Lírio-Aranha", 
	"Almeida", 
	"Santo Amaro",
	"Roosevelt", 
	"Potiguar"
};

static const Float:s_shipPosition[] = {	2829.95313, -2479.57031, 5.26563,   0.00000, 0.00000, -90.00000}; 

static Float: s_shipAttachOffset[MAX_SHIP_OBJECT][6] = {
	{0.000000,		0.000000,	0.000000,	0.000000,	0.000000,	0.000000},
	{0.000000,		0.000000,	0.000000,	0.000000,	0.000000,	0.000000},
	{-107.499977,	8.080001,	2.000000,	0.000000,	0.000000,	0.000000},
	{-55.660057,	8.040000,	5.699993,	0.000000,	0.000000,	0.049999},
	{53.039920,		8.200004,	11.849996,	0.000000,	0.000000,	0.000000},
	{0.000000,		0.000000,	0.000000,	0.000000,	0.000000,	0.000000},
	{5.000000,		10.000000,	24.000000,	0.000000,	0.000000,	-180.000000},
	{-32.000000,	8.000000,	10.000000,	0.000000,	0.000000,	0.000000},
	{-74.000000,	8.560012,	24.000000,	0.000000,	0.000000,	0.000000},
	{-126.000000,	8.000000,	15.000000,	0.000000,	0.000000,	0.000000}
};

static const s_shipModels[MAX_SHIP_OBJECT] = {5160, 5166, 5167, 5156, 5157, 5165, 3724, 5154, 3724, 5155};

static s_shipObjects[MAX_SHIP_OBJECT] = {INVALID_STREAMER_ID, ...};
static s_shipTextObject[2] = {INVALID_STREAMER_ID, ...};
static s_shipRamps[4] = {INVALID_STREAMER_ID, ...};

static bool:s_shipIsDocked;
new s_shipDockedTime;
new s_shipDepartureTime;
new s_shipNextTime;
static s_shipCurrentName;
static s_shipCurrentState;

// Callbacks
hook OnGameModeInit()
{	
	new tmpobjid;

	// Marfrig
	tmpobjid = CreateDynamicObject(8041, 995.864807, 2133.251220, 15.400308, 0.000000, 0.000000, 0.200000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19479, 997.315856, 2137.508789, 17.751874, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_cshurch_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{000000}Bem-vindo(a) a Marfrig Alimentos!", 110, "Quartz MS", 20, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(3578, 974.946960, 2095.111572, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 973.968322, 2109.591552, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 974.076110, 2114.475341, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 974.144531, 2119.343261, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 977.495666, 2178.326171, 9.040304, 0.000000, 0.000000, -93.599899, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 973.901550, 2104.757324, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 973.219665, 2139.755859, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19844, "metalpanels", "metalpanel1", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 982.275878, 2178.006347, 9.040304, 0.000000, 0.000000, -93.599899, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 987.016357, 2177.778808, 9.040304, 0.000000, 0.000000, -92.699913, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 972.739196, 2178.558105, 9.040304, 0.000000, 0.000000, -93.599899, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 974.990844, 2090.372802, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18787, "matramps", "floormetal1", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 974.986938, 2099.305908, 9.770317, 0.000000, 0.000000, -0.699999, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18787, "matramps", "floormetal1", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 966.358032, 2110.173095, 13.270339, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "greenbackgroundsign", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 966.383972, 2110.857666, 12.790322, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF}Carregamento", 40, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 966.383972, 2110.857666, 12.790322, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF}Carregamento", 40, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 966.383972, 2110.857666, 12.790322, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF}Carregamento", 40, "Ariel", 20, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19482, 970.568847, 2095.053222, 16.580343, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "greenbackgroundsign", 0x00000000);
	tmpobjid = CreateDynamicObject(19482, 970.583374, 2095.449414, 15.932720, 0.300000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{FFFFFF}Descarregamento", 40, "Ariel", 18, 1, 0x00000000, 0x00000000, 0);
	tmpobjid = CreateDynamicObject(19087, 970.572570, 2092.509765, 20.351575, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "metal013", 0x00000000);
	tmpobjid = CreateDynamicObject(19087, 970.572570, 2092.509765, 21.831605, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "metal013", 0x00000000);
	tmpobjid = CreateDynamicObject(19087, 970.572570, 2097.674316, 20.351575, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "metal013", 0x00000000);
	tmpobjid = CreateDynamicObject(19087, 970.572570, 2097.674316, 21.721588, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "metal013", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 991.801391, 2177.550048, 9.040304, 0.000000, 0.000000, -92.699913, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 973.211242, 2134.838623, 9.770317, 0.000000, 0.000000, -0.800000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19844, "metalpanels", "metalpanel1", 0x00000000);
	tmpobjid = CreateDynamicObject(19467, 968.805603, 2107.244628, 9.810351, -179.100067, 0.000000, -90.999969, -1, 0);
	tmpobjid = CreateDynamicObject(19467, 968.891845, 2112.117431, 9.810351, -179.100067, 0.000000, -90.999969, -1, 0);
	tmpobjid = CreateDynamicObject(19467, 968.977172, 2116.981201, 9.810351, -179.100067, 0.000000, -90.999969, -1, 0);
	tmpobjid = CreateDynamicObject(19467, 969.900878, 2097.222656, 9.830295, -179.100067, 0.000000, -90.999969, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 979.222595, 2104.646484, 10.380316, 0.000000, 0.000000, 5.499999, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 979.270446, 2109.504394, 10.380316, 0.000000, 0.000000, 1.899999, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 979.381774, 2114.251220, 10.380315, 0.000000, 0.000000, 1.899999, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 979.487426, 2119.210205, 10.380315, 0.000000, 0.000000, 1.899999, -1, 0);
	tmpobjid = CreateDynamicObject(19467, 969.822692, 2092.771484, 9.830295, -179.100067, 0.000000, -90.999969, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 980.290100, 2095.022949, 10.390316, 0.000000, 0.000000, 5.499999, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 980.321655, 2090.270996, 10.390316, 0.000000, 0.000000, -1.699998, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 980.377258, 2099.217041, 10.390316, 0.000000, 0.000000, -1.699998, -1, 0);
	tmpobjid = CreateDynamicObject(19983, 1012.831115, 2081.484130, 9.671875, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(19983, 1001.920471, 2168.773437, 9.749663, 0.000000, 0.000000, 179.900039, -1, 0);
	tmpobjid = CreateDynamicObject(19950, 995.875793, 2124.490966, 8.541867, 0.000000, 0.000000, 90.199989, -1, 0);
	tmpobjid = CreateDynamicObject(19950, 995.029968, 2142.005126, 8.750303, 0.000000, 0.000000, -89.699996, -1, 0);
	tmpobjid = CreateDynamicObject(19957, 995.915039, 2142.051269, 8.581869, 0.000000, 0.000000, 91.599945, -1, 0);
	tmpobjid = CreateDynamicObject(19957, 994.955566, 2124.569335, 8.550298, 0.000000, 0.000000, -90.000007, -1, 0);
	tmpobjid = CreateDynamicObject(8843, 987.338867, 2128.775146, 9.819378, 0.099999, 0.000000, -90.700088, -1, 0);
	tmpobjid = CreateDynamicObject(8843, 987.355957, 2138.218505, 9.812056, -0.200000, 0.000000, 88.899955, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 997.171386, 2136.062988, 9.801863, 0.000000, 0.000000, 90.500022, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 997.137634, 2140.073974, 9.821865, 0.000000, 0.000000, 90.500022, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 997.139831, 2130.654296, 9.821865, 0.000000, 0.000000, 90.500022, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 997.144042, 2126.652343, 9.821865, 0.000000, 0.000000, 90.500022, -1, 0);
	tmpobjid = CreateDynamicObject(997, 977.913757, 2104.361572, 9.750308, 0.000000, 0.000000, -89.100067, -1, 0);
	tmpobjid = CreateDynamicObject(997, 966.660705, 2091.264892, 9.837004, 0.000000, 0.000000, -13.600000, -1, 0);
	tmpobjid = CreateDynamicObject(997, 964.488830, 2119.356201, 9.820311, 0.000000, 0.000000, 1.699998, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 1009.914184, 2157.661132, 9.661863, 0.000000, 0.000000, -179.000061, -1, 0);
	tmpobjid = CreateDynamicObject(19467, 968.053039, 2137.409912, 9.790254, -179.100067, 0.000000, -89.999984, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 1004.912292, 2112.954101, 9.671862, 0.000000, 0.000000, 178.799880, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 1005.106384, 2168.362060, 9.681864, 0.000000, 0.000000, -179.000061, -1, 0);
	tmpobjid = CreateDynamicObject(19425, 1009.823669, 2105.572021, 9.671862, 0.000000, 0.000000, 179.499908, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 978.520629, 2134.796875, 10.380315, 0.000000, 0.000000, 1.899999, -1, 0);
	tmpobjid = CreateDynamicObject(1215, 978.520874, 2139.628906, 10.380315, 0.000000, 0.000000, 1.899999, -1, 0);

	// Docas
	CreateDynamicObject(19980, 2810.29053, -2445.09619, 11.91935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19980, 2810.29053, -2381.55933, 11.91930,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19980,2810.395,-2445.070,11.918,0.000,0.000,90.000);
	CreateDynamicObject(19980,2810.395,-2381.559,11.918,0.000,0.000,90.000);
	tmpobjid = CreateDynamicObject(1378, 2802.691650, -2498.723876, 36.918598, 0.000000, 0.000000, -89.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(1378, 2802.691650, -2453.223876, 36.918598, 0.000000, 0.000000, -89.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(1378, 2802.691650, -2408.723876, 36.918598, 0.000000, 0.000000, -89.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3474, 2737.416015, -2476.806884, 19.227100, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(3474, 2737.416015, -2430.803955, 19.227100, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2742.016113, -2479.323730, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2741.994873, -2486.679443, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2742.014648, -2469.749511, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2742.014648, -2460.195556, 11.027600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2733.101074, -2486.711181, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2733.040527, -2478.001220, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2733.039550, -2468.390625, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2742.013183, -2439.730712, 11.029600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2742.012695, -2430.163085, 11.027600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2742.013183, -2421.924316, 11.025600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2733.076171, -2439.827392, 11.027600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2733.074951, -2430.286621, 11.027600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(19449, 2733.076904, -2422.346191, 11.027600, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	tmpobjid = CreateDynamicObject(2611, 2729.463378, -2416.776367, 14.353899, 0.000000, 0.000000, -90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "cj_sheetmetal2", 0x00000000);
	tmpobjid = CreateDynamicObject(19975, 2727.341308, -2419.112548, 11.532400, 0.000000, 0.000000, 180.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 19165, "gtamap", "gtasamapbit4", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 3, 19165, "gtamap", "gtasamapbit4", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2771.974121, -2432.314697, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2771.974121, -2448.610595, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2771.974121, -2465.488769, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2771.974121, -2482.366699, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2764.065673, -2378.498046, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2759.885253, -2370.732910, 13.413599, 0.000000, 0.000000, 178.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2722.678710, -2473.032470, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2722.678710, -2473.032470, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(3578, 2722.087402, -2432.401367, 13.413599, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10839, "aircarpkbarier_sfse", "chevron_red_64HVa", 0x00000000);
	tmpobjid = CreateDynamicObject(1386, 2736.383544, -2435.552001, 27.097200, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(967, 2721.817382, -2497.707519, 12.504199, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	tmpobjid = CreateDynamicObject(967, 2719.140136, -2510.037597, 12.504199, 0.000000, 0.000000, 179.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	tmpobjid = CreateDynamicObject(967, 2719.184814, -2411.537597, 12.504199, 0.000000, 0.000000, 179.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	tmpobjid = CreateDynamicObject(967, 2721.270751, -2399.390869, 12.504199, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 15041, "bigsfsave", "AH_grepaper2", 0x00000000);
	tmpobjid = CreateDynamicObject(3565, 2736.369873, -2434.360107, 19.092500, 0.000000, 0.000000, 90.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10850, "bakerybit2_sfse", "frate64_red", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10850, "bakerybit2_sfse", "frate_doors128red", 0x00000000);
	tmpobjid = CreateDynamicObject(1386, 2796.948486, -2410.151855, 46.027599, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(1386, 2826.359863, -2454.060791, 46.027599, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(1386, 2812.726318, -2499.916992, 46.027599, 0.000000, 0.000000, 0.000000, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 19278, "skydiveplatforms", "hazardtile19-2", 0x00000000);
	tmpobjid = CreateDynamicObject(19805, 2719.997802, -2398.345458, 14.053000, 0.000000, 0.000000, -89.200019, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10891, "bakery_sfse", "ws_RShaul_dirt", 0x00000000);
	tmpobjid = CreateDynamicObject(19805, 2719.961181, -2496.810302, 14.053000, 0.000000, 0.000000, -89.600044, -1, 0);
	SetDynamicObjectMaterial(tmpobjid, 0, 10891, "bakery_sfse", "ws_RShaul_dirt", 0x00000000);
	tmpobjid = CreateDynamicObject(19980, 2810.290527, -2445.096191, 11.919349, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(19980, 2810.290527, -2381.559326, 11.919300, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(8883, 2795.673828, -2495.968505, 15.988100, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(7317, 2789.694580, -2529.932617, 18.377199, 0.000000, 0.000000, -91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(8335, 2777.680664, -2525.895996, 16.491899, 0.000000, 0.000000, 89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(8335, 2737.182617, -2454.291503, 16.354700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(7621, 2711.591552, -2459.798339, 18.531900, 0.000000, 0.000000, 91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(8076, 2713.500732, -2430.056396, 16.516399, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(3626, 2725.219482, -2416.981933, 13.862700, 0.000000, 0.000000, -180.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2720.393554, -2377.402832, 12.307999, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2720.393310, -2389.373291, 12.314000, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2720.268066, -2409.651367, 12.369999, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2720.196777, -2421.657226, 12.369999, 0.000000, 0.000000, -180.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1432, 2724.068359, -2413.768554, 12.625200, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(2132, 2729.031005, -2416.005371, 12.644900, 0.000000, 0.000000, -91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1302, 2729.224121, -2418.361572, 12.569499, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(2173, 2724.805908, -2417.179443, 12.635100, 0.000000, 0.000000, 177.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1721, 2724.656005, -2416.175048, 12.644300, 0.000000, 0.000000, -186.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1721, 2724.670654, -2418.339355, 12.644300, 0.000000, 0.000000, -354.000000, -1, 0);
	tmpobjid = CreateDynamicObject(2002, 2721.415283, -2418.238037, 12.635399, 0.000000, 0.000000, 88.000000, -1, 0);
	tmpobjid = CreateDynamicObject(2610, 2721.130859, -2416.302001, 13.440400, 0.000000, 0.000000, 91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(2610, 2721.123779, -2415.824951, 13.440400, 0.000000, 0.000000, 91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1518, 2721.047607, -2416.143798, 14.517000, 0.000000, 0.000000, 90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(19893, 2724.685058, -2417.378173, 13.434599, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(2074, 2724.885009, -2417.236572, 14.858499, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(19807, 2723.713378, -2417.014648, 13.466199, 0.000000, 0.000000, 185.000000, -1, 0);
	tmpobjid = CreateDynamicObject(11743, 2729.240966, -2415.766113, 13.686300, 0.000000, 0.000000, -92.000000, -1, 0);
	tmpobjid = CreateDynamicObject(19160, 2729.190917, -2416.085937, 13.696999, 0.000000, -91.000000, 84.000000, -1, 0);
	tmpobjid = CreateDynamicObject(3620, 2793.029052, -2357.993896, 25.585300, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(7516, 2793.413085, -2369.388183, 16.494100, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(11245, 2757.117187, -2383.152099, 21.767900, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2675.405029, -2332.689453, 12.307999, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2675.395996, -2344.684082, 12.307999, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(3576, 2745.692626, -2452.845947, 14.079700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2720.429687, -2487.006347, 12.369999, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(987, 2720.327392, -2508.389404, 12.369999, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(3577, 2724.060058, -2420.798828, 13.356900, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(966, 2720.230957, -2507.578369, 12.485799, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(968, 2720.217285, -2507.549560, 13.229000, 0.000000, 0.000000, -91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(966, 2720.166992, -2408.774658, 12.485799, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(968, 2720.165039, -2408.713623, 13.229000, 0.000000, 0.000000, -91.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1376, 2825.017333, -2452.801757, 32.387401, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1376, 2811.345703, -2498.580078, 32.387401, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(1376, 2795.621826, -2408.877685, 32.387401, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(3643, 2756.000244, -2522.375244, 17.361299, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(3643, 2756.454833, -2542.679687, 17.361299, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(11081, 2759.383789, -2358.954101, 19.176900, 0.000000, 0.000000, 89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.651611, -2343.137451, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.648437, -2368.738037, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.6511, -2407.7344, 13.3027, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.635742, -2418.6345, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.630859, -2457.0046, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.633544, -2471.156005, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.621582, -2496.847900, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.612304, -2522.463378, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.622802, -2548.076660, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2810.624267, -2552.882080, 13.302700, 0.000000, 0.000000, 0.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2797.847412, -2330.608398, 13.302700, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2772.250732, -2331.043457, 13.302700, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2746.660156, -2331.494628, 13.302700, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2741.889160, -2331.585693, 13.302700, 0.000000, 0.000000, -89.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2797.822509, -2565.675537, 13.302700, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(982, 2788.223388, -2565.686767, 13.302700, 0.000000, 0.000000, -90.000000, -1, 0);
	tmpobjid = CreateDynamicObject(10183, 2783.644531, -2334.602294, 12.660200, 0.000000, 0.000000, 46.000000, -1, 0);
	tmpobjid = CreateDynamicObject(10183, 2757.049804, -2558.422851, 12.665599, 0.000000, 0.000000, -135.000000, -1, 0);
	tmpobjid = CreateDynamicObject(19353,2810.345,-2381.553,14.508,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "RESTRITA ENTRADA\nDE VEÍCULOS\n\nÁREA DE EMBARQUE\nE DESEMBARQUE", 140, "Ariel", 25, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19353,2810.355,-2381.544,14.598,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "___________", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19353,2810.345,-2445.085,14.508,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "RESTRITA ENTRADA\nDE VEÍCULOS\n\nÁREA DE EMBARQUE\nE DESEMBARQUE", 140, "Ariel", 25, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19353,2810.345,-2445.075,14.598,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "___________", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);

	s_shipRamps[0] = CreateDynamicObject(3069, 2810.72095, -2441.03833, 12.68020,   -14.00000, 0.00000, -90.00000, -1, 0);
	s_shipRamps[1] = CreateDynamicObject(3069, 2810.71338, -2435.04272, 12.68020,   -14.00000, 0.00000, -90.00000, -1, 0);
	s_shipRamps[2] = CreateDynamicObject(3069, 2810.69873, -2391.52710, 12.68020,   -14.00000, 0.00000, -90.00000, -1, 0);
	s_shipRamps[3] = CreateDynamicObject(3069, 2810.71411, -2385.54736, 12.68020,   -14.00000, 0.00000, -90.00000, -1, 0);

    tmpobjid = CreateDynamicObject(19353,2810.125,-2397.535,15.428,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "_____________________", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19353,2810.125,-2397.535,13.808,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "_____________________", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19353,2810.125,-2429.665,15.428,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "_____________________", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19353,2810.125,-2429.666,13.808,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "_____________________", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);

	CreateDynamicObject(3077, 2810.07861, -2397.60254, 12.53260,   0.00000, 0.00000, 90.00000, -1, 0);
	CreateDynamicObject(3077, 2810.20874, -2429.70410, 12.53260,   0.00000, 0.00000, 90.00000, -1, 0);

	s_shipTextObject[0] = CreateDynamicObject(19353,2810.125,-2397.575,14.518,0.000,0.000,0.000);
	SetDynamicObjectMaterialText(s_shipTextObject[0], 0, " ", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	
	s_shipTextObject[1] = CreateDynamicObject(19353,2810.125,-2429.676,14.518,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(s_shipTextObject[1], 0, " ", 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);

	CargoShip_Create();
	return true;
}

hook OnPlayerConnect(playerid)
{
	//Remoção das Docas
    RemoveBuildingForPlayer(playerid, 3707, 2716.2344, -2452.5938, 20.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3710, 2788.1563, -2417.7891, 16.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3710, 2788.1563, -2455.8828, 16.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3710, 2788.1563, -2493.9844, 16.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3708, 2716.2344, -2452.5938, 20.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2771.0703, -2372.4453, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2789.2109, -2377.6250, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2774.7969, -2386.8516, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2771.0703, -2520.5469, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2774.7969, -2534.9531, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3746, 2814.2656, -2356.5703, 25.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3746, 2814.2656, -2521.4922, 25.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3770, 2795.8281, -2394.2422, 14.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 3770, 2746.4063, -2453.4844, 14.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 1635, 2704.3672, -2487.8672, 20.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, 2742.2656, -2481.5156, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2774.7969, -2534.9531, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2771.0703, -2520.5469, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2501.8359, 14.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3624, 2788.1563, -2493.9844, 16.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2486.9609, 14.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2747.0078, -2480.2422, 13.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2463.8203, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3624, 2788.1563, -2455.8828, 16.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3626, 2746.4063, -2453.4844, 14.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2448.4766, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2744.5703, -2436.1875, 13.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2744.5703, -2427.3203, 13.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2425.3516, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2774.7969, -2386.8516, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2771.0703, -2372.4453, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2410.2109, 14.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3624, 2788.1563, -2417.7891, 16.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2789.2109, -2377.6250, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2501.8359, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2797.5156, -2486.8281, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2486.9609, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2463.8203, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2797.5156, -2448.3438, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2448.4766, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2425.3516, 14.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2410.2109, 14.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2797.5156, -2410.0781, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3626, 2795.8281, -2394.2422, 14.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 3620, 2814.2656, -2521.4922, 25.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3620, 2814.2656, -2356.5703, 25.5156, 0.25);
	
	//Remoção do Navio
	RemoveBuildingForPlayer(playerid, 5156, 2838.0391, -2423.8828, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 5159, 2838.0313, -2371.9531, 7.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5160, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5161, 2838.0234, -2358.4766, 21.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5162, 2838.0391, -2423.8828, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 5163, 2838.0391, -2532.7734, 17.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5164, 2838.1406, -2447.8438, 15.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 5165, 2838.0313, -2520.1875, 18.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 5166, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5167, 2838.0313, -2371.9531, 7.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5335, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5336, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5352, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5157, 2838.0391, -2532.7734, 17.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5154, 2838.1406, -2447.8438, 15.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5155, 2838.0234, -2358.4766, 21.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2407.1406, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5158, 2837.7734, -2334.4766, 11.9922, 0.25);
	return true;
}

hook Server_OnUpdate()
{
	new now;
	now = gettime();

	// Preparando Desancoragem
	if ((s_shipDepartureTime - now) < 20 && !IsDynamicObjectMoving(s_shipObjects[0]) && s_shipCurrentState == 0)
	{
		CallRemoteFunction("OnCargoShipUndocked", "");
		s_shipCurrentState = 1;
	}

	// Mover
	else if (now > s_shipDepartureTime && !IsDynamicObjectMoving(s_shipObjects[0]) && s_shipCurrentState == 1)
	{
		CargoShip_Move(-800.0);
		s_shipCurrentState = 2;
	}

	// Voltar
	else if (now > s_shipNextTime && !IsDynamicObjectMoving(s_shipObjects[0]) && s_shipCurrentState == 2)
	{
		CargoShip_Move(800.0);
		s_shipCurrentState = 3;
	}

	return true;
}

hook OnDynamicObjectMoved(objectid)
{
	if (objectid != s_shipObjects[0] || s_shipCurrentState != 3)
		return false;

	new Float:pos[3];
	GetDynamicObjectPos(objectid, pos[0], pos[1], pos[2]);

	if (pos[0] == s_shipPosition[0] && pos[1] == s_shipPosition[1] && pos[2] == s_shipPosition[2])
	{
		CallRemoteFunction("OnCargoShipDocked", "");
	}

	return true;
}

public OnCargoShipDocked()
{
	s_shipIsDocked = true;
	s_shipDockedTime = gettime();
	s_shipDepartureTime = gettime() + (20 * 60);
	s_shipNextTime = gettime() + (30 * 60);
	s_shipCurrentState = 0;

	CargoShip_UpdateRamps();
	CargoShip_UpdatePanel();
	return true;
}

public OnCargoShipUndocked()
{
	s_shipIsDocked = false;
	
	if (++ s_shipCurrentName >= sizeof s_shipNames)
		s_shipCurrentName = 0; 

	CargoShip_UpdateRamps();
	CargoShip_UpdatePanel();
	return true;
}

// Functions
CargoShip_Create()
{
	s_shipIsDocked = true;

	new Float:pos[6];

	for (new i = 0; i < MAX_SHIP_OBJECT; i++)
	{
		pos[0] = s_shipPosition[0] + (s_shipAttachOffset[i][0] * floatcos(s_shipPosition[5], degrees)) - (s_shipAttachOffset[i][1] * floatsin(s_shipPosition[5], degrees));
		pos[1] = s_shipPosition[1] + (s_shipAttachOffset[i][0] * floatsin(s_shipPosition[5], degrees)) + (s_shipAttachOffset[i][1] * floatcos(s_shipPosition[5], degrees));
		pos[2] = s_shipPosition[2] + s_shipAttachOffset[i][2];
		pos[3] = s_shipPosition[3] + s_shipAttachOffset[i][3];
		pos[4] = s_shipPosition[4] + s_shipAttachOffset[i][4];
		pos[5] = s_shipPosition[5] + s_shipAttachOffset[i][5];

		s_shipObjects[i] = CreateDynamicObject(s_shipModels[i], pos[0], pos[1], pos[2], pos[3], pos[4], pos[5], -1, 0);
	}

	CallRemoteFunction("OnCargoShipDocked", "");
	return true;
}

CargoShip_UpdatePanel()
{
	new text[144];

	format (text, sizeof text, "NAVIO %s\n%s\n\n", s_shipNames[s_shipCurrentName], TimestampFormat(gettime(), "%d/%m/%Y"));
	StrToUpper(text);

	if (!s_shipIsDocked)
	{
		strcat (text, "PRÓXIMO NAVIO CHEGA: ");
		strcat (text, TimestampFormat(s_shipNextTime));
	
		strcat (text, "\nNAVIO ANTERIOR PARTIU: ");
		strcat (text, TimestampFormat(s_shipDepartureTime));
	}	
	else
	{
		strcat (text, "O NAVIO CHEGOU: ");
		strcat (text, TimestampFormat(s_shipDockedTime));

		strcat (text, "\nO NAVIO PARTE: ");
		strcat (text, TimestampFormat(s_shipDepartureTime));
	}

	SetDynamicObjectMaterialText(s_shipTextObject[0], 0, text, 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	SetDynamicObjectMaterialText(s_shipTextObject[1], 0, text, 140, "Ariel", 30, 1, 0xFFFFFFFF, 0x00000000, 1);
	return true;
}

CargoShip_UpdateRamps()
{
	for (new i = 0; i < sizeof s_shipRamps; i++)
	{
		SetDynamicObjectRot(s_shipRamps[i], (s_shipIsDocked ? -14.0 : 20.0), 0.0, -90.0);
	}

	return true;
}

CargoShip_Move(Float:offset)
{
	new Float:pos[3];

	for (new i = 0; i < sizeof s_shipObjects; i++)
	{
		GetDynamicObjectPos(s_shipObjects[i], pos[0], pos[1], pos[2]);
		pos[1] += offset;

		MoveDynamicObject(s_shipObjects[i], pos[0], pos[1], pos[2], 20.0);
	}

	return true;
}

CargoShip_GetName()
{
	new ret[32];
	format (ret, sizeof ret, s_shipNames[s_shipCurrentName]);
	return ret;
}

CargoShip_IsDocked()
{
	return s_shipIsDocked;
}