/*
	 .oooooo..o     .                                    .
	d8P'    `Y8   .o8                                  .o8
	Y88bo.      .o888oo oooo d8b  .ooooo.   .ooooo.  .o888oo  .oooo.o
	 `"Y8888o.    888   `888""8P d88' `88b d88' `88b   888   d88(  "8
	     `"Y88b   888    888     888ooo888 888ooo888   888   `"Y88b.
	oo     .d8P   888 .  888     888    .o 888    .o   888 . o.  )88b
	8""88888P'    "888" d888b    `Y8bod8P' `Y8bod8P'   "888" 8""888P'
	
*/

// Enumss
enum E_STREET_DATA
{
	e_STREET_NAME[64 char],
	Float:e_STREET_MIN_X,
	Float:e_STREET_MIN_Y,
	Float:e_STREET_MAX_X,
	Float:e_STREET_MAX_Y
}

static StreetData[][E_STREET_DATA] = {
	{!"Avenida Rebouças", 1951.0, -1923.0, 1967.0, -1760.0},
	{!"Avenida Rebouças", 1951.0, -2161.0, 2189.0, -1935.0},
	{!"Rua Mourato Coelho", 1814.0, -2176.0, 2085.0, -2159.0},
	{!"Avenida Rangel Pestana", 1812.0, -2161.0, 1952.0, -2043.0},
	{!"Rua Alba Frota", 1649.0, -2161.0, 1812.0, -2043.0},
	{!"Rua Mourato Coelho", 1649.0, -2177.0, 1815.0, -2161.0},
	{!"Rua Mourato Coelho", 1515.0, -2044.0, 1677.0, -1884.0},
	{!"Rua Mourato Coelho", 1513.0, -2178.0, 1649.0, -2043.0},
	{!"Rua Gunnar Vingren", 1806.0, -1969.0, 1952.0, -1814.0},
	{!"Rua Gunnar Vingren", 1951.0, -1937.0, 2067.0, -1923.0},
	{!"Rua Daniel Berg", 1806.0, -2043.0, 1951.0, -1969.0},
	{!"Unity Station", 1677.0, -2044.5, 1808.0, -1876.5},
	{!"Rua Martin Luther King", 1930.0, -1743.0, 1955.0, -1620.0},
	{!"Avenida Mansur Sadek", 1806.0, -1814.0, 1930.0, -1620.0},
	{!"Avenida Martino Basso", 1930.0, -1762.0, 2188.0, -1743.0},
	{!"Idle Gas", 1930.0, -1815.0, 1951.0, -1760.0},
	{!"Rua da Liberdade", 1807.0, -1619.5, 2075.0, -1527.5},
	{!"Dalerose", 1967.0, -1923.0, 2065.0, -1760.0},
	{!"Rua Eli Coimbra", 1700.0, -1814.0, 1807.0, -1714.0},
	{!"Avenida Barão de Mauá", 1700.0, -1714.0, 1808.0, -1607.0},
	{!"Rua Álvaro do Prado", 1333.0, -1609.5, 1807.0, -1565.5},
	{!"Avenida Presidente Costa e Silva", 1676.0, -1878.5, 1702.0, -1608.5},
	{!"Rua Carmem Miranda", 2220.0, -1721.5, 2420.0, -1639.5},
	{!"Rua Carmem Miranda", 2440.0, -1720.5, 2542.0, -1629.5},
	{!"Avenida Aricanduva", 2420.0, -1721.5, 2440.0, -1445.5},
	{!"Rua Elis Regina", 2220.0, -1755.5, 2543.0, -1720.5},
	{!"Rua Elis Regina", 2220.0, -1854.5, 2407.0, -1755.5},
	{!"Rua Arcádia Paulistana", 2440.0, -1595.5, 2548.0, -1449.5},
	{!"Rua Arcádia Paulistana", 2548.0, -1527.5, 2585.0, -1449.5},
	{!"Rua Conde de Itu", 2420.0, -1449.5, 2635.0, -1429.5},
	{!"Avenida Santo Amaro", 2331.0, -1641.5, 2356.0, -1383.5},
	{!"Rua José Lógulo", 2222.0, -1607.5, 2333.0, -1470.5},
	{!"Avenida Henry Ford", 2124.0, -1607.5, 2224.0, -1470.5},
	{!"Crenshaw", 2100.0, -1470.5, 2331.0, -1392.5},
	{!"Rua Tacomaré", 2100.0, -1392.5, 2331.0, -1370.5},
	{!"Jefferson", 2100.0, -1370.5, 2373.0, -1084.5},
	{!"Rua Cipriano Barata", 1955.0, -1743.0, 2015.0, -1620.0},
	{!"Rua Agostinho Gomes", 2015.0, -1743.0, 2075.0, -1620.0},
	{!"Rua Carmem Miranda", 2075.0, -1606.5, 2124.0, -1527.5},
	{!"Rua Carmem Miranda", 2075.0, -1646.5, 2331.0, -1606.5},
	{!"Crystal Gardens", 2109.0, -1742.5, 2187.0, -1646.5},
	{!"Rua Embuaçu", 2075.0, -1742.5, 2109.0, -1646.5},
	{!"Avenida Barão de Valim", 2065.0, -1937.0, 2088.0, -1761.0},
	{!"Avenida Moreira Guimarães", 2087.0, -1937.0, 2188.0, -1762.0},
	{!"Avenida Moreira Guimarães", 2188.0, -1962.5, 2303.0, -1853.5},
	{!"Rua Ada Negri", 2188.0, -2040.5, 2407.0, -1962.5},
	{!"Fremont", 2303.0, -1963.5, 2407.0, -1853.5},
	{!"Avenida Adolfo Pinheiro", 2407.0, -2040.5, 2423.0, -1755.5},
	{!"Rua Cerqueira César", 2423.0, -2041.5, 2549.0, -1937.5},
	{!"Rua Antônio Fóster", 2423.0, -1938.5, 2721.0, -1919.5},
	{!"Avenida Guido Caloi", 2702.0, -2148.5, 2724.0, -1938.5},
	{!"Rua Andre de Leão", 2613.0, -2041.5, 2703.0, -1938.5},
	{!"Via Dutra", 2188.0, -2059.5, 2703.0, -2040.5},
	{!"Rodovia Anhanguera", 2439.0, -1629.5, 2713.0, -1595.5},
	{!"Esgoto East Beach", 2542.0, -1919.5, 2623.0, -1629.5},
	{!"Rua Elis Regina", 2423.0, -1919.5, 2543.0, -1755.5},
	{!"Esgoto Willowfield", 2379.0, -2148.5, 2703.0, -2059.5},
	{!"Esgoto Willowfield", 2549.0, -2041.5, 2614.0, -1938.5},
	{!"Avenida Coronel Oscar Porto", 2188.0, -1854.5, 2223.0, -1646.5},
	{!"Rua Sampaio Viana", 2355.0, -1640.5, 2420.0, -1383.5},
	{!"Avenida Rebouças", 2085.0, -2212.0, 2205.0, -2113.0},
	{!"Verdant Hill", 1071.0, -2178.0, 1515.0, -1884.0},
	{!"Avenida Santa Maria", 925.0, -2483.5, 1072.0, -1785.5},
	{!"Avenida Santa Maria", 1072.0, -2482.0, 1298.0, -2176.0},
	{!"Avenida Bernadino de Campos", 925.0, -1785.5, 1055.0, -1578.5},
	{!"Rua Treze de Maio", 1055.0, -1722.5, 1295.0, -1700.5},
	{!"Rua Cubatão", 1055.0, -1784.5, 1295.0, -1722.5},
	{!"Rua Jacobi Maris", 1072.0, -1884.5, 1295.0, -1783.5},
	{!"Avenida Corifeu de Azevedo", 1292.0, -1845.5, 1333.0, -1565.5},
	{!"Rua Jacobi Maris", 1295.0, -1884.5, 1677.0, -1844.5},
	{!"Avenida Professor Lineu Prestes", 1333.0, -1845.5, 1488.0, -1744.5},
	{!"Avenida Professssor Luciano Gualberto", 1488.0, -1845.5, 1677.0, -1743.5},
	{!"Rua Professor Almeida Prado", 1700.0, -1879.0, 1807.0, -1814.0},
	{!"Avenida Franz Voegeli", 1055.0, -1702.5, 1293.0, -1578.5},
	{!"Rua Eli Coimbra", 1333.0, -1744.5, 1677.0, -1718.5},
	{!"Avenida Washington Luís", 1333.0, -1719.5, 1677.0, -1609.5},
	{!"Avenida Santa Maria", 380.0, -1972.5, 611.0, -1692.5},
	{!"Avenida Santa Maria", 611.0, -1930.5, 743.0, -1725.5},
	{!"Avenida Santa Maria", 742.0, -2080.5, 926.0, -1760.5},
	{!"Rua Martinésia", 800.0, -1761.5, 905.0, -1593.5},
	{!"Avenida Manoel Pimentel", 904.0, -1761.5, 925.0, -1411.5},
	{!"Avenida Hilário de Souza", 642.0, -1726.5, 743.0, -1593.5},
	{!"Avenida Getúlio Vargas", 742.0, -1761.5, 800.0, -1593.5},
	{!"Rua João Arnus", 642.0, -1593.5, 905.0, -1570.5},
	{!"Avenida Santa Maria", 57.0, -1973.5, 380.0, -1655.5},
	{!"Pier Santa Maria", 335.0, -2097.5, 430.0, -1972.5},
	{!"Avenida Corifeu de Azevedo", 1291.0, -1565.5, 1372.0, -1413.5},
	{!"Avenida Corifeu de Azevedo", 1333.0, -1413.5, 1372.0, -1039.5},
	{!"Avenida Brasil", 642.0, -1413.5, 1334.0, -1384.5},
	{!"Avenida Graciela Flores", 642.0, -1570.5, 905.0, -1413.5},
	{!"Rua Martinésia", 925.0, -1579.5, 1293.0, -1558.5},
	{!"Avenida Bandeirantes", 1183.0, -1558.5, 1292.0, -1413.5},
	{!"Avenida Bernadino de Campos", 1029.0, -1558.5, 1183.0, -1413.5},
	{!"Rua São Mateus", 925.0, -1559.5, 1029.0, -1413.5},
	{!"Rua Frei Gáspar", 610.0, -1725.5, 642.0, -1221.5},
	{!"Avenida Pirambóia", 512.0, -1571.5, 611.0, -1423.5},
	{!"Rua Miguel Barbar", 381.0, -1637.5, 611.0, -1569.5},
	{!"Avenida Santa Maria", 6.0, -1655.5, 245.0, -1517.5},
	{!"Rua Laérte Cearense", 380.0, -1692.5, 611.0, -1636.5},
	{!"Rua Laérte Cearense", 245.0, -1656.5, 381.0, -1569.5},
	{!"Avenida Pirarucu", 420.0, -1570.5, 513.0, -1478.5},
	{!"Avenida Brasil", 245.0, -1569.5, 420.0, -1478.5},
	{!"Avenida Brasil", 337.0, -1478.5, 512.0, -1423.5},
	{!"Avenida Brasil", 467.0, -1423.5, 610.0, -1393.5},
	{!"Rua André Ohl", 1372.0, -1565.5, 1427.0, -1168.5},
	{!"Avenida Washington Luís", 1427.0, -1429.5, 1527.0, -1168.5},
	{!"Avenida Washington Luís", 1427.0, -1565.5, 1807.0, -1457.5},
	{!"Rua Sandra Maria", 1427.0, -1457.5, 2100.0, -1429.5},
	{!"Rua Sandra Maria", 1807.0, -1527.5, 2100.0, -1457.5},
	{!"Rua Faráh Bechara", 1527.0, -1429.5, 1702.0, -1168.5},
	{!"Avenida Cabral", 1702.0, -1430.5, 1837.0, -1168.5},
	{!"Avenida Mansur Sadek", 1837.0, -1430.5, 1862.0, -1168.5},
	{!"Rua Monteprano", 1862.0, -1349.5, 2056.0, -1266.5},
	{!"Rua Doutor Nilo Machado", 1862.0, -1429.5, 2055.0, -1349.5},
	{!"Rua Carmem Miranda", 2100.0, -1527.5, 2124.0, -1470.5},
	{!"Avenida Hildebrando de Lima", 2055.0, -1430.5, 2100.0, -1084.5},
	{!"Rua Alberto Cortez", 1862.0, -1266.5, 2055.0, -1142.5},
	{!"Rua Alberto Cortez", 1856.7421875, -1272.73828125, 2057.7421875, -1250.73828125},
	{!"Rua Doutor Nilo Machado", 1977.74609375, -1455.7421875, 2004.74609375, -1351.7421875},
	{!"Avenida Aristídes Belini", 1868.7421875, -1146.7421875, 2065.7421875, -1124.7421875},
	{!"Rua General Florêncio", 2077.734375, -1390.734375, 2264.734375, -1372.734375},
	{!"Rua Washington Luís", 2080.0, -1307.5, 2264.0, -1289.5},
	{!"Rua Olívio Marçal", 2080.0, -1231.5, 2258.0, -1209.5}
};

// Functions
ReturnStreet(Float:x, Float:y, bool:short = false)
{
	new out[64];

	strunpack(out, !"Desconhecida", 64);

	for (new i = 0; i < sizeof StreetData; i++)
	{
		if (x >= StreetData[i][e_STREET_MIN_X] && y >= StreetData[i][e_STREET_MIN_Y] && x <= StreetData[i][e_STREET_MAX_X] && y <= StreetData[i][e_STREET_MAX_Y])
		{
			strunpack (out, StreetData[i][e_STREET_NAME], 64);
			break;
		}
	}

	if (short)
	{
		strreplace(out, "Avenida", "Av.");
		strreplace(out, "Rua", "R.");
		strreplace(out, "Presidente", "Pres.");
		strreplace(out, "Professor", "Prof.");
		strreplace(out, "Doutor", "Dr.");
	}

	return out;
}

ReturnAreaName(Float:x, Float:y)
{
	new out[64], MapZone:id;

	id = GetMapZoneAtPoint2D(x, y);

	if (id != INVALID_MAP_ZONE_ID)
	{
		GetMapZoneName (id, out);
	}
	else
	{
		format (out, sizeof out, "Desconhecido");
	}

	return out;
}

ReturnCity(Float: x, Float: y)
{
    static city[20];
    format(city, sizeof city, "Desconhecido");

    // Los Santos
    if (x >= 44.6 && y >= -2892.9 && x <= 2997.0 && y <= -768.0)
    {
        format(city, sizeof city, "São Paulo");
    }
    // Las Venturas
    if (x >= 869.40 && y >= -242.90 && x <= 2997.00 && y <= 2993.80)
    {
        format(city, sizeof city, "Las Venturas");
    }
    // Bone County
    if (x >= -480.50 && y >= -242.90 && x <= 869.40 && y <= 2993.80)
    {
        format(city, sizeof city, "Bone County");
    }
    // Tierra Robada (região 1)
    if (x >= -2997.40 && y >= 1659.60 && x <= -480.50 && y <= 2993.80)
    {
        format(city, sizeof city, "Tierra Robada");
    }
    // Tierra Robada (região 2)
    if (x >= -1213.90 && y >= 596.30 && x <= -480.50 && y <= 1659.60)
    {
        format(city, sizeof city, "Tierra Robada");
    }
    // San Fierro
    if (x >= -2997.40 && y >= -1115.50 && x <= -1213.90 && y <= 1659.60)
    {
        format(city, sizeof city, "San Fierro");
    }
    // Red County
    if (x >= -1213.90 && y >= -768.00 && x <= 2997.00 && y <= 596.30)
    {
        format(city, sizeof city, "Red County");
    }
    // Flint County
    if (x >= -1213.90 && y >= -2892.90 && x <= 44.60 && y <= -768.00)
    {
        format(city, sizeof city, "Flint County");
    }
    // Whetstone
    if (x >= -2997.40 && y >= -2892.90 && x <= -1213.90 && y <= -1115.50)
    {
        format(city, sizeof city, "Whetstone");
    }

    return city;
}

ReturnAreaCode(Float: x, Float: y)
{
    static MapZone: zoneID;
    zoneID = GetMapZoneAtPoint2D(x, y);

    if (zoneID != INVALID_MAP_ZONE_ID)
    {
        switch (zoneID)
        {
            case ZONE_LOS_SANTOS_INTERNATIONAL, ZONE_OCEAN_DOCKS, ZONE_SANTA_MARIA_BEACH: 
                return 218;

            case ZONE_VERONA_BEACH, ZONE_MARINA: 
                return 313;

            case ZONE_RODEO:
                return 802;

            case ZONE_TEMPLE, ZONE_MARKET:
                return 343;

            case ZONE_DOWNTOWN, ZONE_PERSHING_SQUARE, ZONE_CONFERENCE_CENTER:
                return 206;

            case ZONE_GLEN_PARK:
                return 826;

            case ZONE_VERDANT_BLUFFS:
                return 216;

            case ZONE_IDLEWOOD:
                return 415;

            case ZONE_GANTON, ZONE_EL_CORONA, ZONE_WILLOWFIELD, ZONE_PLAYA_DEL_SEVILLE:
                return 516;

            case ZONE_EAST_BEACH:
                return 616;

            case ZONE_JEFFERSON, ZONE_EAST_LOS_SANTOS:
                return 424;

            case ZONE_VINEWOOD, ZONE_RICHMAN:
                return 806;

            case ZONE_MULHOLLAND:
                return 343;

            case ZONE_NORTH_ROCK:
                return 828;

            case ZONE_PALOMINO_CREEK:
                return 835;

            case ZONE_MONTGOMERY:
                return 824;

            case ZONE_DILLIMORE:
                return 808;

            case ZONE_BLUEBERRY, ZONE_BLUEBERRY_ACRES, ZONE_THE_PANOPTICON, ZONE_FALLEN_TREE:
                return 890;

            case ZONE_EASTER_BAY_CHEMICALS, ZONE_THE_FARM:
                return 843;

            case ZONE_FLINT_COUNTY:
                return 856;

            case ZONE_ANGEL_PINE:
                return 856;

            case ZONE_FORT_CARSON:
                return 855;

            case ZONE_LITTLE_MEXICO:
                return 310;
        }
    }

    return 999;
}

// Comandos
alias:rua("bairro", "loc", "localizacao")
CMD:rua(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if (strcmp(ReturnStreet(x, y), "Desconhecida", false))
	{
		SendClientMessage(playerid, COLOR_GREEN, "Sua localização:");
		SendClientMessageEx(playerid, -1, "%s, %s %i, São Paulo", ReturnStreet(x, y), ReturnAreaName(x, y), ReturnAreaCode(x, y));
	}
	else
		SendErrorMessage(playerid, "Nossos satélites não puderam localizar onde você está.");

	return true;
}