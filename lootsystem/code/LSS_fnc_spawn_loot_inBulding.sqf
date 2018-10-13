//____________________________________________
// LSS_fnc_spawn_loot_inBulding.sqf
// Author: Dodzh
// [buildingobject] call LSS_fnc_spawn_loot_inBulding;
// LootTable = "Military","Civilian", etc taken from CfgLootTables config 
// creates item
//____________________________________________

private [
		"_building","_result","_debug","_useModelPositions","_fillBackPacks","_ratios","_itemSpawnType","_lootContainer","_time",
		"_maxLootPositions","_maxLootPercentile","_maxLootPositionsUsable",
		"_minLootPerSpot","_maxLootPerSpot","_minMagazinesPerWeapon","_maxMagazinesPerWeapon",
		"_lootPosition","_lootPositions","_positionsCount","_lootPositionsUsable","_lootContainerNetIDs","_lootTable",
		"_backpack","_backpack_type","_weapon","_mag","_mags",
		"_cfgLootSettings","_cfgBuildings","_tableConfig"
		];

_building = _this select 0;
_result = objNull;

try 
{
	if (!isServer) exitWith {};

	if (isNil "_building") then {throw objNull;};
	
	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw objNull;};
	if !(isClass _cfgLootSettings) then {throw objNull;};

	_useModelPositions = getNumber (_cfgLootSettings >> "useModelPositions");
	_maxLootPositions = getNumber (_cfgLootSettings >> "maxLootPositions");
	_maxLootPercentile = getNumber (_cfgLootSettings >> "maxLootPercentile");
	_fillBackPacks = getNumber (_cfgLootSettings >> "fillBackPacks");
	_minLootPerSpot = getNumber (_cfgLootSettings >> "minLootPerSpot");
	_maxLootPerSpot = getNumber (_cfgLootSettings >> "maxLootPerSpot");
	_minMagazinesPerWeapon = getNumber (_cfgLootSettings >> "minMagazinesPerWeapon");
	_maxMagazinesPerWeapon = getNumber (_cfgLootSettings >> "maxMagazinesPerWeapon");
	_debug = getNumber (_cfgLootSettings >> "debug");
	_lootPositions = [];
	_lootPositionsUsable = [];
	_lootContainerNetIDs = [];
	_lootTable = "defaults";
	_time = time;  
	
	_cfgBuildings = missionConfigFile >> "CfgBuildings" >> typeOf _building;
	if (isClass _cfgBuildings) then
	{
		_lootTable = getText (_cfgBuildings >> "table");
		_lootPositions = getArray (_cfgBuildings >> "positions");
		{
			_lootPosition = _building modelToWorld _x;
			_x set [0, _lootPosition select 0];
			_x set [1, _lootPosition select 1];
			_x set [2, _lootPosition select 2];
		} forEach _lootPositions;
	} 
	else
	{
		if (_useModelPositions isEqualTo 1) then
		{
			_lootPositions = [_building] call BIS_fnc_buildingPositions;
		};
	};

	_positionsCount = count _lootPositions;
	if !(_positionsCount > 0) then {throw objNull;};

	_maxLootPositionsUsable = 1 max ((_positionsCount * _maxLootPercentile) min _maxLootPositions);
	_lootPositions = _lootPositions call BIS_fnc_arrayShuffle;
	_lootPositionsUsable = _lootPositions select [0, _maxLootPositionsUsable];

	if (_debug isEqualTo 1) then
	{
		{
			[_x,false] call LSS_fnc_debug_markers;
		} forEach _lootPositions - _lootPositionsUsable;
	};

	_tableConfig = missionConfigFile >> "CfgLootTables" >> _lootTable;
	if !(isClass _tableConfig) then {throw objNull;};

	{
		_lootPosition = _x;
		if (_lootPosition select 2 < 0.5) then {_lootPosition set [2, 0.5];};
		
		_ratios = getArray (_tableConfig >> "ratio");
		if (count _ratios isEqualTo 0) then {throw objNull;};

		_itemSpawnType = _ratios call BIS_fnc_selectRandomWeighted;
		if (isNil "_itemSpawnType") then {throw objNull;};
		if !(_itemSpawnType in _ratios) then {throw objNull;};
		
		_lootContainer = createVehicle ["GroundWeaponHolder", _lootPosition, [], 0, "CAN_COLLIDE"];
		_lootContainer setDir (random 360);
		_lootContainer setPosATL _lootPosition;
		_lootContainer setVariable ["lastSpawendLoot", _time];
		_lootContainerNetIDs pushBack (_lootContainer call BIS_fnc_netId);

		_maxLootPerSpot = _minLootPerSpot max round(random _maxLootPerSpot) min _maxLootPerSpot;
		_maxMagazinesPerWeapon = _minMagazinesPerWeapon max round(random _maxMagazinesPerWeapon) min _maxMagazinesPerWeapon;
		switch (_itemSpawnType) do {
			case "backpacks" : 
			{
				_backpack_type = getArray (_tableConfig >> "backpacks") call BIS_fnc_selectRandomWeighted;
				_lootContainer addBackpackCargoGlobal [_backpack_type,1];
				if (_fillBackPacks isEqualTo 1) then 
				{
					_backpack = firstBackpack _lootContainer;
					for "_i" from 0 to round(random _maxLootPerSpot) do {
						_backpack addItemCargoGlobal [getArray (_tableConfig >> "items") call BIS_fnc_selectRandomWeighted,1];
					};
				};
			};
			case "uniforms" : 
			{
				_lootContainer addItemCargoGlobal [getArray (_tableConfig >> "uniforms") call BIS_fnc_selectRandomWeighted,1];
			};
			case "items" : 
			{
				for "_i" from 0 to round(random _maxLootPerSpot) do {
					_lootContainer addItemCargoGlobal [getArray (_tableConfig >> "items") call BIS_fnc_selectRandomWeighted,1];
				};
			};
			default 
			{
				_weapon = getArray (_tableConfig >> "weapons") call BIS_fnc_selectRandomWeighted;
				_lootContainer addWeaponCargoGlobal [_weapon,1];
				_mags = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
				_mag = _mags select (floor (random (count _mags)));
				_lootContainer addMagazineCargoGlobal [_mag,_maxMagazinesPerWeapon];
			};
		};
		_result = _lootContainer;
		if (_debug isEqualTo 1) then {[_x,true] call LSS_fnc_debug_markers;};
	} forEach _lootPositionsUsable;

	_building setVariable ["lastSpawendLoot", _time, true];
	_building setVariable ["lootContainerNetIDs", _lootContainerNetIDs];
	buildingColletinglootIDs pushBack [_building call BIS_fnc_netId,_time];
}
catch
{
	_result = objNull;
};
_result