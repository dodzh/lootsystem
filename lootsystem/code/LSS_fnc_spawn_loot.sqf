//____________________________________________
// LSS_fnc_spawn_loot.sqf
// Author: Dodzh
// [<pos>,<range>] spawn LSS_fnc_spawn_loot;
// Spawn given a position and a radius
// generates random loot in buildings
//____________________________________________

private ["_pos","_range","_doneStatus","_cfgLootSettings","_maxLootTime","_buildings"];
_pos = _this select 0;
_range = _this select 1;
try
{
	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw "invalid settings";};
	if !(isClass _cfgLootSettings) then {throw "invalid settings";};
	_maxLootTime = getNumber (_cfgLootSettings >> "maxLootTime");
	_buildings = _pos nearObjects ["building", _range];
	_buildings = _buildings select {(time - (_x getVariable["lastSpawendLoot", -(_maxLootTime)]) >= _maxLootTime) && !(isObjectHidden _x)};
	{
		[_x] call LSS_fnc_spawn_loot_inBulding;
		sleep 0.1;
	} forEach _buildings;
} 
catch
{
	_exception;
};