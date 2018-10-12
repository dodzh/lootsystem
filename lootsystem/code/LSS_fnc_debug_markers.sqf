//____________________________________________
// LSS_fnc_debug_markers.sqf
// Author: Dodzh
// [<pos>,(true or false)] call LSS_fnc_debug_markers
// generates markers and helpers for debug
//____________________________________________
private ["_pos","_isloot","_marker","_helper","_markername"];

_pos = _this select 0;
_isloot = _this select 1;

try
{
	_markername = str _pos splitString "[.,]: " joinString "";  
	_markername = _markername splitString " " joinString "";
	_markername = "lootMkr" + _markername;

	_marker = createMarker [_markername,_pos];

	if (_isloot) then 
	{
		_helper = "Sign_Arrow_Green_F" createVehicle [0,0,0];
		_marker setMarkerColor "ColorGreen";
		systemChat str formatText ["Loot Created at: %1", str _pos];
	}
	else
	{
		_helper = "Sign_Arrow_F" createVehicle [0,0,0];
		_marker setMarkerColor "ColorRed";
	};

	_marker setMarkerShape "ICON";
	_marker setMarkerType "hd_dot";
	_helper setPos _pos;

	debugMarkers pushBack [_markername,time];
	debugHelpersIDs pushBack [_helper call BIS_fnc_netId,time];
} 
catch
{};