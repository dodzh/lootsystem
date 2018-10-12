-Lootsystem Script:

	This script creates random loot on buildings based on predefined settings

-Installation:
	Add the following line to your init.sqf: 

	// init lootsystem
	[] execVM "lootsystem\init.sqf";

	Add the following line to your description.ext: 

	//lootsystem config
	#include "lootsystem\config.cpp"

	Move the lootsystem folder to your mission folder

-Customization:
	Edit the config file:
	lootsystem\config.cpp
	
-Functions:
	
	LSS_fnc_cleanup
	
		Usage:
		[] spawn LSS_fnc_cleanup;
		
		Notes:
		Manually cleans expired generated loot
		
	LSS_fnc_cleanup_auto
	
		Usage:
		[] call LSS_fnc_cleanup_auto;
		
		Notes:
		Starts a thread and does cleanup based on config.cpp

	LSS_fnc_spawn_loot
	
		Usage:
		[<pos>,<range>] spawn LSS_fnc_spawn_loot;
		example:
		[getpos player,80] spawn LSS_fnc_spawn_loot;
		
		Notes:
		Generates loot based on a given position and radius

	LSS_fnc_spawn_loot_auto
	
		Usage:
		[] call LSS_fnc_spawn_loot_auto;

		Notes:
		Generates loot based on a given position and radius

	LSS_fnc_spawn_loot_inBulding
	
		Usage:
		[<building_object>] call LSS_fnc_spawn_loot_inBulding;

		Returns:
		the building object where the loot was created

		Notes:
		Generates loot based on a given building object			

		
	
	
