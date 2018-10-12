//____________________________________________
// LSS_fnc_debug_fps.sqf
// Author: Dodzh
// [] call LSS_fnc_debug_fps;
// nothing fancy, if debug is on will display fps on the last 16 frames to have an idea if the loot is creating lag
//____________________________________________

private["_debug","_cfgLootSettings"];
try
{
	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw "invalid settings";};
	if !(isClass _cfgLootSettings) then {throw "invalid settings";};

	_debug = getNumber (_cfgLootSettings >> "debug");

	if (_debug isEqualTo 1) then
	{
		[] spawn
		{
			while {true} do 
			{
				hintSilent formatText ["FPS: %1", str round diag_fps];
				sleep 0.16;
			};
		};
	};
}
catch
{};