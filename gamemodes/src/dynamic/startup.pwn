/*
	 .oooooo..o     .                          .
	d8P'    `Y8   .o8                        .o8
	Y88bo.      .o888oo  .oooo.   oooo d8b .o888oo oooo  oooo  oo.ooooo.
	 `"Y8888o.    888   `P  )88b  `888""8P   888   `888  `888   888' `88b
	     `"Y88b   888    .oP"888   888       888    888   888   888   888
	oo     .d8P   888 . d8(  888   888       888 .  888   888   888   888
	8""88888P'    "888" `Y888""8o d888b      "888"  `V88V"V8P'  888bod8P'
	                                                            888
	                                                           o888o
*/

// Include
#include <YSI_Coding\y_hooks>

// Callbacks
hook OnGameModeInit()
{
	Interact_Load();
	Entrance_Load();
	Faction_Load();
	Vehicle_Load();
	Business_Load();
	Item_Load(-1);
	House_Load();
	Pump_Load();
	Furniture_Load();
	return true;
}