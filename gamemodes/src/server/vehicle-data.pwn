new const Float: s_arrVehicleData[][] =
{
	// MAX HP, ENGINE LIFE, BATTERY LIFE, MAX FUEL, FUEL RATE
	{ 1120.0, 100.0, 100.0, 22.0, 13.0},
	{ 900.0, 75.0, 100.0, 15.0, 9.0},
	{ 910.0, 100.0, 100.0, 19.0, 3.0},
	{ 2000.0, 100.0, 100.0, 100.0, 4.0},
	{ 900.0, 75.0, 100.0, 100.0, 15.0},
	{ 940.0, 100.0, 100.0, 17.0, 8.0},
	{ 2000.0, 100.0, 100.0, 100.0, 4.0},
	{ 1800.0, 100.0, 100.0, 100.0, 11.0},
	{ 2000.0, 100.0, 100.0, 100.0, 3.0},
	{ 1000.0, 100.0, 100.0, 23.0, 11.0},
	{ 900.0, 75.0, 100.0, 14.0, 10.0},
	{ 800.0, 100.0, 100.0, 24.0, 3.0},
	{ 900.0, 75.0, 100.0, 15.0, 6.0},
	{ 1400.0, 100.0, 100.0, 32.0, 20.0},
	{ 1700.0, 100.0, 100.0, 100.0, 17.0},
	{ 800.0, 100.0, 100.0, 23.0, 4.0},
	{ 1300.0, 100.0, 100.0, 65.0, 20.0},
	{ 1300.0, 100.0, 100.0, 100.0, 0.0},
	{ 1000.0, 100.0, 100.0, 26.0, 23.0},
	{ 900.0, 75.0, 100.0, 16.0, 8.0},
	{ 910.0, 100.0, 100.0, 17.0, 14.0},
	{ 940.0, 100.0, 100.0, 16.0, 8.0},
	{ 1200.0, 100.0, 100.0, 25.0, 13.0},
	{ 1400.0, 100.0, 100.0, 35.0, 26.0},
	{ 900.0, 100.0, 100.0, 9.0, 15.0},
	{ 1700.0, 100.0, 100.0, 100.0, 0.0},
	{ 930.0, 100.0, 100.0, 16.0, 8.0},
	{ 1650.0, 100.0, 100.0, 56.0, 15.0},
	{ 1800.0, 100.0, 100.0, 55.0, 10.0},
	{ 800.0, 100.0, 100.0, 23.0, 3.0},
	{ 1200.0, 100.0, 100.0, 80.0, 0.0},
	{ 2000.0, 100.0, 100.0, 100.0, 3.0},
	{ 5000.0, 100.0, 100.0, 100.0, 3.0},
	{ 2200.0, 100.0, 100.0, 100.0, 7.0},
	{ 880.0, 100.0, 100.0, 10.0, 14.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 900.0, 75.0, 100.0, 15.0, 9.0},
	{ 2000.0, 100.0, 100.0, 100.0, 2.0},
	{ 910.0, 100.0, 100.0, 17.0, 13.0},
	{ 930.0, 100.0, 100.0, 17.0, 7.0},
	{ 1400.0, 100.0, 100.0, 34.0, 12.0},
	{ 700.0, 100.0, 100.0, 100.0, 0.0},
	{ 1000.0, 100.0, 100.0, 18.0, 10.0},
	{ 2000.0, 100.0, 100.0, 100.0, 9.0},
	{ 1300.0, 100.0, 100.0, 26.0, 6.0},
	{ 910.0, 100.0, 100.0, 16.0, 8.0},
	{ 850.0, 100.0, 100.0, 75.0, 0.0},
	{ 850.0, 100.0, 100.0, 46.0, 0.0},
	{ 740.0, 50.0, 100.0, 2.0, 49.0},
	{ 1200.0, 100.0, 100.0, 7.0, 12.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 800.0, 100.0, 100.0, 23.0, 3.0},
	{ 850.0, 100.0, 100.0, 68.0, 0.0},
	{ 1250.0, 100.0, 100.0, 100.0, 0.0},
	{ 1250.0, 100.0, 100.0, 100.0, 0.0},
	{ 2000.0, 100.0, 100.0, 100.0, 2.0},
	{ 1700.0, 100.0, 100.0, 100.0, 14.0},
	{ 800.0, 100.0, 100.0, 0.0, 0.0},
	{ 920.0, 100.0, 100.0, 17.0, 12.0},
	{ 1400.0, 100.0, 100.0, 32.0, 24.0},
	{ 850.0, 100.0, 100.0, 100.0, 6.0},
	{ 720.0, 50.0, 100.0, 5.0, 45.0},
	{ 740.0, 50.0, 100.0, 2.0, 49.0},
	{ 740.0, 50.0, 100.0, 5.0, 40.0},
	{ 700.0, 100.0, 100.0, 2.0, 25.0},
	{ 700.0, 100.0, 100.0, 2.0, 25.0},
	{ 900.0, 75.0, 100.0, 14.0, 8.0},
	{ 900.0, 75.0, 100.0, 15.0, 8.0},
	{ 710.0, 50.0, 100.0, 4.0, 45.0},
	{ 1000.0, 100.0, 100.0, 45.0, 10.0},
	{ 1650.0, 100.0, 100.0, 26.0, 10.0},
	{ 700.0, 50.0, 100.0, 4.0, 48.0},
	{ 1250.0, 100.0, 100.0, 100.0, 15.0},
	{ 750.0, 50.0, 100.0, 13.0, 18.0},
	{ 910.0, 75.0, 100.0, 16.0, 8.0},
	{ 900.0, 100.0, 100.0, 17.0, 3.0},
	{ 850.0, 100.0, 100.0, 100.0, 6.0},
	{ 830.0, 100.0, 100.0, 17.0, 3.0},
	{ 1200.0, 100.0, 100.0, 25.0, 25.0},
	{ 910.0, 75.0, 100.0, 17.0, 14.0},
	{ 800.0, 100.0, 100.0, 18.0, 9.0},
	{ 500.0, 50.0, 100.0, 0.0, 0.0},
	{ 1400.0, 100.0, 100.0, 32.0, 12.0},
	{ 1100.0, 100.0, 100.0, 43.0, 12.0},
	{ 750.0, 100.0, 100.0, 100.0, 6.0},
	{ 890.0, 100.0, 100.0, 0.0, 0.0},
	{ 1900.0, 100.0, 100.0, 21.0, 7.0},
	{ 980.0, 100.0, 100.0, 48.0, 6.0},
	{ 900.0, 100.0, 100.0, 48.0, 6.0},
	{ 1110.0, 100.0, 100.0, 23.0, 10.0},
	{ 1430.0, 100.0, 100.0, 28.0, 9.0},
	{ 900.0, 75.0, 100.0, 15.0, 8.0},
	{ 900.0, 75.0, 100.0, 15.0, 8.0},
	{ 850.0, 100.0, 100.0, 70.0, 11.0},
	{ 800.0, 100.0, 100.0, 17.0, 3.0},
	{ 1000.0, 100.0, 100.0, 23.0, 12.0},
	{ 800.0, 100.0, 100.0, 11.0, 4.0},
	{ 1000.0, 100.0, 100.0, 49.0, 6.0},
	{ 1400.0, 100.0, 100.0, 100.0, 6.0},
	{ 1400.0, 100.0, 100.0, 100.0, 17.0},
	{ 920.0, 100.0, 100.0, 19.0, 14.0},
	{ 700.0, 100.0, 100.0, 0.0, 25.0},
	{ 800.0, 100.0, 100.0, 17.0, 3.0},
	{ 800.0, 100.0, 100.0, 17.0, 3.0},
	{ 850.0, 100.0, 100.0, 15.0, 7.0},
	{ 1110.0, 100.0, 100.0, 15.0, 10.0},
	{ 800.0, 100.0, 100.0, 23.0, 3.0},
	{ 850.0, 100.0, 100.0, 20.0, 7.0},
	{ 1200.0, 100.0, 100.0, 76.0, 17.0},
	{ 500.0, 50.0, 100.0, 0.0, 0.0},
	{ 500.0, 50.0, 100.0, 0.0, 0.0},
	{ 850.0, 100.0, 100.0, 100.0, 4.0},
	{ 850.0, 100.0, 100.0, 97.0, 6.0},
	{ 820.0, 100.0, 100.0, 73.0, 6.0},
	{ 2000.0, 100.0, 100.0, 100.0, 4.0},
	{ 2000.0, 100.0, 100.0, 100.0, 3.0},
	{ 900.0, 100.0, 100.0, 18.0, 9.0},
	{ 900.0, 75.0, 100.0, 15.0, 9.0},
	{ 900.0, 75.0, 100.0, 16.0, 8.0},
	{ 1200.0, 100.0, 100.0, 100.0, 3.0},
	{ 1300.0, 100.0, 100.0, 100.0, 4.0},
	{ 710.0, 75.0, 100.0, 5.0, 45.0},
	{ 700.0, 75.0, 100.0, 5.0, 48.0},
	{ 1000.0, 50.0, 100.0, 7.0, 20.0},
	{ 2000.0, 100.0, 100.0, 100.0, 3.0},
	{ 1160.0, 100.0, 100.0, 26.0, 17.0},
	{ 900.0, 100.0, 100.0, 15.0, 8.0},
	{ 900.0, 75.0, 100.0, 15.0, 9.0},
	{ 1000.0, 100.0, 100.0, 29.0, 15.0},
	{ 900.0, 75.0, 100.0, 15.0, 8.0},
	{ 850.0, 100.0, 100.0, 0.0, 0.0},
	{ 800.0, 100.0, 100.0, 18.0, 23.0},
	{ 1900.0, 100.0, 100.0, 25.0, 9.0},
	{ 830.0, 100.0, 100.0, 17.0, 8.0},
	{ 925.0, 100.0, 100.0, 16.0, 6.0},
	{ 940.0, 100.0, 100.0, 23.0, 6.0},
	{ 880.0, 75.0, 100.0, 14.0, 7.0},
	{ 2000.0, 100.0, 100.0, 100.0, 12.0},
	{ 2000.0, 100.0, 100.0, 100.0, 12.0},
	{ 800.0, 100.0, 100.0, 15.0, 12.0},
	{ 900.0, 75.0, 100.0, 16.0, 8.0},
	{ 800.0, 100.0, 100.0, 24.0, 4.0},
	{ 900.0, 75.0, 100.0, 15.0, 8.0},
	{ 1200.0, 100.0, 100.0, 25.0, 13.0},
	{ 1800.0, 100.0, 100.0, 25.0, 11.0},
	{ 880.0, 100.0, 100.0, 14.0, 13.0},
	{ 910.0, 75.0, 100.0, 15.0, 8.0},
	{ 900.0, 75.0, 100.0, 16.0, 8.0},
	{ 1450.0, 100.0, 100.0, 100.0, 2.0},
	{ 900.0, 75.0, 100.0, 14.0, 8.0},
	{ 900.0, 100.0, 100.0, 15.0, 8.0},
	{ 950.0, 100.0, 100.0, 19.0, 8.0},
	{ 1270.0, 100.0, 100.0, 12.0, 20.0},
	{ 1500.0, 100.0, 100.0, 100.0, 2.0},
	{ 1280.0, 100.0, 100.0, 26.0, 9.0},
	{ 820.0, 75.0, 100.0, 15.0, 9.0},
	{ 1300.0, 100.0, 100.0, 26.0, 6.0},
	{ 1300.0, 100.0, 100.0, 26.0, 6.0},
	{ 810.0, 100.0, 100.0, 18.0, 3.0},
	{ 810.0, 100.0, 100.0, 17.0, 3.0},
	{ 880.0, 100.0, 100.0, 16.0, 7.0},
	{ 920.0, 100.0, 100.0, 18.0, 12.0},
	{ 880.0, 100.0, 100.0, 18.0, 9.0},
	{ 1350.0, 100.0, 100.0, 100.0, 4.0},
	{ 700.0, 100.0, 100.0, 2.0, 0.0},
	{ 810.0, 100.0, 100.0, 13.0, 3.0},
	{ 900.0, 75.0, 100.0, 15.0, 6.0},
	{ 905.0, 75.0, 100.0, 15.0, 7.0},
	{ 850.0, 100.0, 100.0, 8.0, 16.0},
	{ 1000.0, 100.0, 100.0, 0.0, 12.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 700.0, 100.0, 100.0, 4.0, 22.0},
	{ 750.0, 100.0, 100.0, 8.0, 18.0},
	{ 1300.0, 100.0, 100.0, 29.0, 4.0},
	{ 750.0, 100.0, 100.0, 8.0, 18.0},
	{ 900.0, 75.0, 100.0, 16.0, 6.0},
	{ 890.0, 75.0, 100.0, 15.0, 6.0},
	{ 1500.0, 100.0, 100.0, 100.0, 1.0},
	{ 1800.0, 100.0, 100.0, 100.0, 12.0},
	{ 1150.0, 100.0, 100.0, 25.0, 10.0},
	{ 970.0, 100.0, 100.0, 22.0, 7.0},
	{ 710.0, 50.0, 100.0, 4.0, 45.0},
	{ 1300.0, 100.0, 100.0, 29.0, 24.0},
	{ 750.0, 100.0, 100.0, 8.0, 18.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 915.0, 100.0, 100.0, 16.0, 8.0},
	{ 740.0, 50.0, 100.0, 7.0, 40.0},
	{ 820.0, 100.0, 100.0, 17.0, 3.0},
	{ 1200.0, 100.0, 100.0, 29.0, 12.0},
	{ 850.0, 100.0, 100.0, 14.0, 3.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 1500.0, 100.0, 100.0, 100.0, 1.0},
	{ 850.0, 100.0, 100.0, 100.0, 6.0},
	{ 700.0, 100.0, 100.0, 2.0, 50.0},
	{ 1250.0, 100.0, 100.0, 100.0, 11.0},
	{ 1110.0, 100.0, 100.0, 17.0, 13.0},
	{ 1110.0, 100.0, 100.0, 17.0, 13.0},
	{ 1110.0, 100.0, 100.0, 17.0, 13.0},
	{ 1220.0, 100.0, 100.0, 25.0, 21.0},
	{ 920.0, 100.0, 100.0, 22.0, 7.0},
	{ 3500.0, 100.0, 100.0, 100.0, 13.0},
	{ 820.0, 100.0, 100.0, 20.0, 3.0},
	{ 950.0, 100.0, 100.0, 19.0, 3.0},
	{ 1000.0, 75.0, 100.0, 14.0, 8.0},
	{ 1200.0, 100.0, 100.0, 25.0, 26.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0},
	{ 1650.0, 100.0, 100.0, 100.0, 12.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0, 0.0},
	{ 1000.0, 100.0, 100.0, 0.0, 0.0, 0.0}
};

Float: GetVehicleMaxHealth(vehicleid)
{
	static model;

	if (!IsValidVehicle(vehicleid))
		return 0.0;

	model = GetVehicleModel(vehicleid);

	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][0];
}

Float: GetVehicleMaxEngineLife(vehicleid)
{
	static model;

	if (!IsValidVehicle(vehicleid))
		return 0.0;

	model = GetVehicleModel(vehicleid);

	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][1];
}

Float: GetVehicleMaxBatteryLife(vehicleid)
{
	static model;

	if (!IsValidVehicle(vehicleid))
		return 0.0;

	model = GetVehicleModel(vehicleid);

	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][2];
}

Float: GetVehicleMaxFuel(vehicleid)
{
	static model;

	if (!IsValidVehicle(vehicleid))
		return 0.0;

	model = GetVehicleModel(vehicleid);

	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][3];
}

Float: GetVehicleFuelRate(vehicleid)
{
	static model;

	if (!IsValidVehicle(vehicleid))
		return 0.0;

	model = GetVehicleModel(vehicleid);

	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][4];
}

Float: GetVehicleConsumptionPerSecond(vehicleid, Float: speed)
{
	return (speed / 3600.0) / (20.0 * GetVehicleFuelRate(vehicleid));
}

Float: GetVehicleModelMaxHealth(model)
{
	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][0];
}

Float: GetVehicleModelMaxEngineLife(model)
{
	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][1];
}

Float: GetVehicleModelMaxBatteryLife(model)
{
	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][2];
}

Float: GetVehicleModelMaxFuel(model)
{
	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][3];
}

Float: GetVehicleModelFuelRate(model)
{
	if (!(400 <= model <= 611))
		return 0.0;

	return s_arrVehicleData[model - 400][4];
}

IsVehicleTrunkOpenned(vehicleid)
{
	// Quebrado
	new damage1, damage2, damage3, damage4;
 
  	GetVehicleDamageStatus(vehicleid, damage1, damage2, damage3, damage4);
 
  	if ((damage2 >>> 8 & 15) >= 4)
  		return true;
 
  	// Aberto
	new unused, boot;
	GetVehicleParamsEx(vehicleid, unused, unused, unused, unused, unused, boot, unused);
 
	if (Vehicle_GetCategory(vehicleid) != CATEGORY_TRAILER && boot == 1)
		return true; 
 
	// Trailer
	if (Vehicle_GetCategory(vehicleid) == CATEGORY_TRAILER && !IsVehicleLocked(vehicleid))
		return true;
 
	return false;
}

IsVehicleLocked(vehicleid)
{
	new unused, doors;
	GetVehicleParamsEx(vehicleid, unused, unused, unused, doors, unused, unused, unused);
	return doors;
}
 
IsPlayerNearBoot(playerid, vehicleid)
{
	new
		Float:fX,
		Float:fY,
		Float:fZ;
 
	GetVehicleBoot(vehicleid, fX, fY, fZ);
 
	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 1.5, fX, fY, fZ);
}

GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if(!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;
 
	new
	    Float:e_Pos[7]
	;
 
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, e_Pos[0], e_Pos[1], e_Pos[2]);
	GetVehiclePos(vehicleid, e_Pos[3], e_Pos[4], e_Pos[5]);
	GetVehicleZAngle(vehicleid, e_Pos[6]);
 
	x = e_Pos[3] - (floatsqroot(e_Pos[1] + e_Pos[1]) * floatsin(-e_Pos[6], degrees));
	y = e_Pos[4] - (floatsqroot(e_Pos[1] + e_Pos[1]) * floatcos(-e_Pos[6], degrees));
 	z = e_Pos[5];
	return true;
}

IsEngineVehicle(vehicleid)
{
	static const g_aEngineStatus[] =
	{
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};

    new modelid = GetVehicleModel(vehicleid);

    if(modelid < 400 || modelid > 611)
        return 0;

    return (g_aEngineStatus[modelid - 400]);
}

SetLockStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, status, bonnet, boot, objective);
}

GetLockStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(doors != 1)
		return 0;

	return true;
}

GetLightStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(lights != 1)
		return 0;

	return true;
}

SetLightStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, status, alarm, doors, bonnet, boot, objective);
}

GetEngineStatus(vehicleid) 
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(engine != 1)
		return 0;

	return true;
}

SetEngineStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
}

GetHoodStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(bonnet != 1)
		return 0;

	return true;
}

SetHoodStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, status, boot, objective);
}

GetTrunkStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot != 1)
		return 0;

	return true;
}

SetTrunkStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, status, objective);
}

IsDoorVehicle(vehicleid)
{
	switch (GetVehicleModel(vehicleid))
	{
		case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475:
		    return 1;

		case 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536:
		    return 1;

		case 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609:
			return true;
	}
	return 0;
}


IsPlayerNearDriverDoor(playerid, vehicleid)
{
	new
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleDriverDoor(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 2.0, fX, fY, fZ);
}

GetVehicleDriverDoor(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if(!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	switch(GetVehicleModel(vehicleid))
	{
	    case 431, 407, 408, 437:
	    {
		 	x = pos[3] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[1]))) * floatsin(-pos[6]+315.0+floatsqroot(pos[1] + pos[1]), degrees));
			y = pos[4] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[1]))) * floatcos(-pos[6]+315.0+floatsqroot(pos[1] + pos[1]), degrees));
	    }
	    default:
	    {
			x = pos[3] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[0]))) * floatsin(-pos[6]+300.0+floatsqroot(pos[1] + pos[1]), degrees));
			y = pos[4] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[0]))) * floatcos(-pos[6]+300.0+floatsqroot(pos[1] + pos[1]), degrees));
	    }
	}

	z = pos[5];
	return true;
}

GetVehicleBootInside(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if(!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (floatsqroot(pos[1] + pos[1] - ((pos[1]+pos[1])/2.3)) * floatsin(-pos[6], degrees));
	y = pos[4] - (floatsqroot(pos[1] + pos[1] - ((pos[1]+pos[1])/2.3)) * floatcos(-pos[6], degrees));
 	z = pos[5];
	return true;
}

GetVehicleInside(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if(!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (-0.25 * floatsin(-pos[6], degrees));
	y = pos[4] - (-0.25 * floatcos(-pos[6], degrees));
 	z = pos[5];
	return true;
}

IsVehicleTrunkBroken(vehicleid)
{
	new damage1, damage2, damage3, damage4;
  	GetVehicleDamageStatus(vehicleid, damage1, damage2, damage3, damage4);
	return (damage2 >>> 8 & 15) >= 4 ? true:false;
}

IsPlayerNearHood(playerid, vehicleid)
{
	new
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleHood(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 1.5, fX, fY, fZ);
}

GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if(!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];
	return true;
}

IsWindowedVehicle(vehicleid)
{
	static const g_aWindowStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1,
	    1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
	new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aWindowStatus[modelid - 400]);
}

IsWindowClosed(vehicleid)
{
	if (!IsValidVehicle(vehicleid))
		return false;

	new fL, fR, rL, rR;
	GetVehicleParamsCarWindows(vehicleid, fL, fR, rL, rR);

	return ((fL == -1 || fL == 1) && (fR == -1 || fR == 1) && (rL == -1 || rL == 1) && (rR == -1 || rR == 1));
}

GetVehicleMaxSpeed(vehicleid)
{
	if (!IsValidVehicle(vehicleid))
		return 0;

	static const vehicleTopSpeed[212] = {
		143, 133, 169, 100, 121, 149, 100, 134, 91, 144, 117, 201, 153, 100, 95, 174, 140, 245, 104, 135, 132, 140, 127, 
		90, 123, 245, 157, 150, 143, 183, 173, 118, 85, 100, 152, 0, 135, 144, 129, 153, 124, 132, 126, 114, 100, 149, 245, 
		245, 101, 0, 0, 175, 245, 55, 123, 143, 96, 86, 143, 124, 245, 145, 101, 129, 132, 132, 134, 127, 131, 245, 143, 100, 
		173, 173, 135, 157, 245, 169, 106, 127, 167, 66, 142, 111, 173, 90, 58, 245, 245, 126, 143, 135, 127, 245, 194, 160, 
		147, 245, 98, 112, 127, 132, 196, 196, 157, 127, 163, 151, 98, 72, 92, 245, 245, 245, 109, 129, 143, 143, 149, 245, 
		245, 145, 160, 137, 118, 145, 144, 135, 160, 135, 55, 64, 100, 152, 153, 144, 157, 0, 0, 245, 135, 184, 149, 137, 
		136, 134, 135, 129, 245, 139, 132, 143, 110, 245, 131, 144, 103, 103, 142, 162, 154, 140, 162, 245, 132, 150, 145, 
		157, 133, 0, 0, 84, 55, 100, 55, 144, 144, 245, 118, 144, 139, 137, 124, 77, 0, 139, 129, 150, 98, 147, 0, 0, 245, 
		245, 118, 173, 159, 159, 159, 144, 137, 100, 154, 155, 134, 138, 0, 0, 0, 98, 0, 0
	};

	new model = (GetVehicleModel(vehicleid)) - 400;

	if (!(0 <= model < sizeof vehicleTopSpeed))
		return 0;

	return vehicleTopSpeed[model];
}