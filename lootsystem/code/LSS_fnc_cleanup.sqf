//____________________________________________
// LSS_fnc_cleanup.sqf
// Author: Dodzh
// [] spawn LSS_fnc_cleanup;
// clean expired loot
//____________________________________________
private["_maxLootTime","_buildingsWithExpiredLoot","_helper","_lootContainerNetIDs","_lootContainer","_cfgLootSettings","_debugHelpersIDs","_debugMarkers"];
try
{
	_cfgLootSettings = missionConfigFile >> "CfgLootSettings";
	if (isNil "_cfgLootSettings") then {throw "invalid settings";};
	if !(isClass _cfgLootSettings) then {throw "invalid settings";};
	
	_debug = getNumber (_cfgLootSettings >> "debug");
	
	_maxLootTime = getNumber (_cfgLootSettings >> "maxLootTime");
	if (_maxLootTime isEqualTo 0) then {throw "invalid settings";};

	_buildingsWithExpiredLoot = buildingColletinglootIDs select {time - (_x select 1) > _maxLootTime};

	{
		_building = _x select 0 call BIS_fnc_objectFromNetId;
		_lootContainerNetIDs = _building getVariable ["lootContainerNetIDs", []];
		{
			_lootContainer = _x call BIS_fnc_objectFromNetId;
			if !(isNull _lootContainer) then 
			{
				deleteVehicle _lootContainer;
				if (_debug isEqualTo 1) then {systemChat str formatText ["Loot Deleted at: %1", str getpos _lootContainer];}
			};
		}
		forEach _lootContainerNetIDs;
		_building setVariable ["lastSpawendLoot", nil];
		_building setVariable ["lootContainerNetIDs", []];
		buildingColletinglootIDs deleteAt (buildingColletinglootIDs find _x);
		sleep 0.1;
	}
	forEach _buildingsWithExpiredLoot;

	if (_debug isEqualTo 1) then 
	{
		_debugHelpersIDs = debugHelpersIDs select {time - (_x select 1) > _maxLootTime};
		{
			_helper = _x select 0 call BIS_fnc_objectFromNetId;
			if !(isNull _helper) then 
			{
				deleteVehicle _helper;
			};
			debugHelpersIDs deleteAt (debugHelpersIDs find _x);
			sleep 0.1;
		}
		forEach _debugHelpersIDs;

		_debugMarkers = debugMarkers select {time - (_x select 1) > _maxLootTime};
		{
			_marker = _x select 0;
			deleteMarker _marker;
			debugMarkers deleteAt (debugMarkers find _x);
			sleep 0.1;
		}
		forEach _debugMarkers;
	};
}
catch
{};