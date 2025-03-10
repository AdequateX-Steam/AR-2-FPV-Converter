params [["_droneObject", nil, [objNull]]];

_droneObject setMass 275.000;
_droneObject setVariable ["ExpMagazine", ""];
createVehicleCrew _droneObject;
_initAction = _droneObject addAction ["<t color='#1c3f45'>Arm Drone</t>",
	{ 
		params ["_target", "_caller", "_actionId"]; 
		_target removeAction _actionId;
		[_target] call Exp_fnc_showMunitions;     
    }, nil, 6, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == player))", 2, false]; 

_droneObject setVariable ["ExpInitAction", _initAction];

_droneObject addEventHandler ["Disassembled" ,
{	
	params ["_entity", "_primaryBag", "_secondaryBag", "_unit"];
	removeAllActions _entity;
	_entity removeMagazines "FakeMagazine";
	if (count attachedObjects _entity >= 1) then 
	{
		_magazineType = (_entity getVariable "ExpMagazine");
		if (_magazineType != "") then 
		{	
			_droppedMag = "GroundWeaponHolder" createvehicle (getPosATL Player);
			_droppedMag addMagazineCargo [_magazineType, 1];
			_droppedMag setPosATL (getPosATL Player);
		};
		{
			detach _x;
			deleteVehicle _x;	
		} foreach attachedObjects _entity;
	};
	
	_entity removeAllEventHandlers "Hit";
	_entity removeAllEventHandlers "Fired";
	_entity removeAllEventHandlers "Killed";
	_entity removeAllEventHandlers "Disassembled";
	_entity removeAllEventHandlers "Deleted";
	_entity setVariable ["ExpMagazine", ""];
}];

_droneObject addEventHandler ["Deleted" ,
{	
	params ["_entity"];
	removeAllActions _entity;
	_entity removeMagazines "FakeMagazine";
	if (count attachedObjects _entity >= 1) then 
	{
		_magazineType = (_entity getVariable "ExpMagazine");
		if (_magazineType != "") then 
		{	
			_droppedMag = "GroundWeaponHolder" createvehicle (getPosATL Player);
			_droppedMag addMagazineCargo [_magazineType, 1];
			_droppedMag setPosATL (getPosATL Player);
		};
		{
			detach _x;
			deleteVehicle _x;	
		} foreach attachedObjects _entity;
	};
	
	_entity removeAllEventHandlers "Hit";
	_entity removeAllEventHandlers "Fired";
	_entity removeAllEventHandlers "Killed";
	_entity removeAllEventHandlers "Disassembled";
	_entity removeAllEventHandlers "Deleted";
	_entity setVariable ["ExpMagazine", ""];
}];