//____________________________________________
// LSS_fnc_cleanup_auto.sqf
// Author: Dodzh
// [] call LSS_fnc_cleanup_auto;
// starts the cleanup process
//____________________________________________
private["_cleanupInterval","_cleanAtStart","_cfgLootSettings"];
try
{
	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw "invalid settings";};
	if !(isClass _cfgLootSettings) then {throw "invalid settings";};
	
	_cleanupInterval = getNumber (_cfgLootSettings >> "cleanupInterval");
	if (_cleanupInterval isEqualTo 0) then {throw "invalid settings";};

	[_cleanupInterval] spawn
	{
		_cleanupInterval = _this select 0;
		while {true} do 
		{
			[] spawn LSS_fnc_cleanup;
			sleep _cleanupInterval;
		};
	};
}
catch
{};