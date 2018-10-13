//____________________________________________
// LSS_fnc_spawn_loot_auto.sqf
// Author: Dodzh
// [] call LSS_fnc_spawn_loot_auto;
// creates a task to spawn loot around every player based on lootInterval
//____________________________________________
private["_lootInterval","_spawnAtStart","_spawnRange","_maxPleyerSpeed","_cfgLootSettings"];

try
{
	if (!isServer) exitWith {};

	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw "invalid settings";};
	if !(isClass _cfgLootSettings) then {throw "invalid settings";};
	
	_lootInterval = getNumber (_cfgLootSettings >> "lootInterval");
	if (_lootInterval isEqualTo 0) then {throw "invalid settings";};

	_spawnRange = getNumber (_cfgLootSettings >> "spawnRange");
	if (_spawnRange isEqualTo 0) then {throw "invalid settings";};

	_maxPleyerSpeed = getNumber (_cfgLootSettings >> "maxPleyerSpeed");
	
	[_lootInterval,_spawnRange,_maxPleyerSpeed] spawn
	{
		private["_lootInterval","_spawnRange","_allPlayers","_lsp","_maxPleyerSpeed"];
		_lootInterval = _this select 0;
		_spawnRange = _this select 1;
		_maxPleyerSpeed = _this select 2;
		_allPlayers = [];
		while {true} do 
		{ 
			_allPlayers = (allPlayers - (entities "HeadlessClient_F"))select {(alive _x) && ((speed _x) <= _maxPleyerSpeed)};
			{
				_lsp = [getPos _x,_spawnRange] spawn LSS_fnc_spawn_loot;
				waitUntil {scriptDone _lsp};
				sleep 0.1;
			}
			forEach _allPlayers;
			sleep _lootInterval;
		};
	};
}
catch
{};