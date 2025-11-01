params [["_droneObject", objNull, [objNull]]];
//playerTargetLock
if (!(_droneObject isNil "ExpMagazine")) exitWith {};  //conflicts with zeusArmDrone (uncessary?)
if (_droneObject iskindof "fpv_Base_F") then { _droneObject setMass 275.000; };
_droneObject setVariable ["ExpMagazine", ""];
createVehicleCrew _droneObject;
_initAction = _droneObject addAction ["<t color='#1c3f45'>Arm Drone</t>",
	{ 
		params ["_target", "_caller", "_actionId"]; 
		_target removeAction _actionId;
		[_target] call Exp_fnc_showMunitions;     
    }, nil, 6, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == player))", 2, false]; 

_droneObject setVariable ["ExpInitAction", _initAction];

_droneObject addAction ["<t color='#c7f08f'>Turbo Mode toggle</t>",  
{ 
	params ["_target", "_caller", "_actionId", "_arguments"];
	if (_target isNil "EXP_turbo") then 
	{
		hint "Turbo mode activated! Drone will accelerate when above 35 Km/h";
		_turboIndex = addMissionEventHandler ["EachFrame", 
		{	
			if (cameraOn != (_thisArgs select 0)) then 
			{
				hint "Turbo mode deactivated! Player not controlling drone";
				removeMissionEventHandler ["EachFrame", _thisEventHandler];
				(_thisArgs select 0) setvariable ["EXP_turbo", nil];
			};
			
			if (((diag_frameNo mod 2) isEqualTo 0) && {(speed (_thisArgs select 0) > 35) && {(speed (_thisArgs select 0) < 190)}}) then 
			{
				//_velX = (-cos (getDir (_thisArgs select 0) + 90));
				//_velY = ((sin (getDir (_thisArgs select 0) + 90)));
				//(_thisargs select 0) addForce [[(_velX * 75), (_velY * 75), 0], [0, 0, 0], false];
				(_thisargs select 0) addForce [(_thisargs select 0) vectorModelToWorld [0,42,0], [0, 0, 0], false];				
			};
		
		},[_target]];
		_target setvariable ["EXP_turbo", _turboIndex];
	}
	else
	{
		hint "Turbo mode deactivated!";
		removeMissionEventHandler ["EachFrame", (_target getVariable "EXP_turbo")];
		_target setvariable ["EXP_turbo", nil];
	};
}, nil, 6, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == _target))", 2, false, "",""];



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