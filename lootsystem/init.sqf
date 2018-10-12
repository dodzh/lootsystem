//____________________________________________
// init.sqf
// Author: Dodzh
// [] execVM "lootsystem\init.sqf"; 
// init loot system;
//____________________________________________
buildingColletinglootIDs = [];
debugHelpersIDs = [];
debugMarkers = [];

try
{
	[] call compileFinal preprocessFileLineNumbers "lootsystem\code\LSS_fnc_compile_code.sqf";
	[] call LSS_fnc_debug_fps;

	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw "invalid settings";};
	if !(isClass _cfgLootSettings) then {throw "invalid settings";};

	_spawnAtStart = getNumber (_cfgLootSettings >> "spawnAtStart");
	_cleanAtStart = getNumber (_cfgLootSettings >> "cleanAtStart");

	if (isServer) then 
	{
		if (_cleanAtStart isEqualTo 1) then {[] call LSS_fnc_cleanup_auto;};
		if (_spawnAtStart isEqualTo 1) then {[] call LSS_fnc_spawn_loot_auto;};
	};
}
catch
{};