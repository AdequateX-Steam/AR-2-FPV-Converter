//**useful commands** disableCollisionWith
//_drone -> _droneObject
params[
	["_Warhead", "", [""]],
	["_droneObject", nil, [objnull]],
	["_dropped", false, [False]]
	];
_originalWarhead = _Warhead; //prepares a copy for replacement timetoLive bypass hack.
_droneObject addMagazineTurret ["FakeMagazine", [-1], 1];


if ((_Warhead isKindOf "MissileBase") || (_Warhead isKindOf "RocketBase")) then
{
	_Warhead = "fpvAmmo"; //creates a special CfgAmmo type with a higher 'timetoLive' value to bypass auto detonation limits.
	_warheadLocation = getPosATL _droneObject;
	_warheadLocation set [2, +3]; //spawn it above ground, incase of it being spawned inside of the ground
	_payload = _Warhead createVehicle _warheadLocation;
	_payload enableSimulationGlobal false; //disable simulation to disable physics as sometimes the warhead interferes with the drone 'hit' EH not taking damage
	_attachOffset = [_Warhead] call Exp_fnc_attachPoint;
	_payload setVariable ["altWarhead", _originalWarhead];
	_payload setVariable ["altOffset", [_originalWarhead] call Exp_fnc_attachPoint]; 
	_payload attachTo [_droneObject, [_attachOffset select 0,_attachOffset select 1, _attachOffset select 2]];

};

if ((_Warhead isKindOf "Grenade") || (_Warhead isKindOf "G_40mm_HE") || (_Warhead isKindOf "G_40mm_Smoke") || (_Warhead isKindOf "F_40mm_White") || (_Warhead isKindOf "BulletBase")) then
{
	_Warhead = "fpvGrenade"; //creates a special CfgAmmo type with a higher 'timetoLive' value to bypass auto detonation limits.
	_warheadLocation = getPosATL _droneObject;
	_warheadLocation set [2, +3]; //spawn it above ground, incase of it being spawned inside of the ground
	_payload = _Warhead createVehicle _warheadLocation;
	_attachOffset = [_Warhead] call Exp_fnc_attachPoint;
	_payload setVariable ["altWarhead", _originalWarhead];
	_payload setVariable ["altOffset", [_originalWarhead] call Exp_fnc_attachPoint]; 
	_payload attachTo [_droneObject, [_attachOffset select 0,_attachOffset select 1, _attachOffset select 2]];

}
else
{
	_warheadLocation = getPosATL _droneObject;
	_warheadLocation set [2 , +3]; //spawn it above ground, incase of it being spawned inside of the ground
	_payload = _Warhead createVehicle _warheadLocation;
	_attachOffset = [_Warhead] call Exp_fnc_attachPoint;
	_payload attachTo [_droneObject, [_attachOffset select 0,_attachOffset select 1, _attachOffset select 2]];

};



													// XXXXXXXXXX Manual Event Handlers XXXXXXXXXXX
if (_dropped == false) then 
{
	_droneObject addEventHandler ["Hit", 
		{	
			params ["_unit", "_source", "_damage", "_instigator"]; //(damage 0.35 testing for automation)
			if (_damage > .35) then 
			{
				{					
					if ("fpvAmmo" == (typeOf _x)) then 
					{
						_replacement = _x getVariable "altWarhead";
						_ModelPosition = _x worldToModel (getPosATL _unit);
						deleteVehicle _x;
						_WorldPos =  _unit modelToWorld _ModelPosition;
						_newWarhead = _replacement createVehicle (_WorldPos);
						_newWarhead setVectorDirAndUp [vectorDir _unit, vectorUp _unit];
						triggerAmmo _newWarhead; 


					}							
					else 
					{
						triggerAmmo _x;
					}; 
								
				} forEach attachedObjects _unit;
				[] spawn Exp_fnc_removeHud;
				_unit removeAllEventHandlers "Fired";
				_unit removeAllEventHandlers "Hit";
				{deleteMarker _x;} foreach (_unit getVariable "ExpDroneMarkers"); //from Exp_fnc_automation
			};
		}];
		
	_droneObject addEventHandler ["Fired",					
		{	
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			{
						
				if ("fpvAmmo" == (typeOf _x)) then 
				{
					_replacement = _x getVariable "altWarhead";
					_ModelPosition = _x worldToModel (getPosATL _unit);
					deleteVehicle _x;
					_WorldPos =  _unit modelToWorld _ModelPosition;
					_newWarhead = _replacement createVehicle (_WorldPos);
					_newWarhead setVectorDirAndUp [vectorDir _unit, vectorUp _unit];
					triggerAmmo _newWarhead; 				
				}
				else 
				{
					triggerAmmo _x;
				}; 
								
			} forEach attachedObjects _unit;
			[] spawn Exp_fnc_removeHud;
			_unit removeAllEventHandlers "Fired";
			_unit removeAllEventHandlers "Hit";
			{deleteMarker _x;} foreach (_unit getVariable "ExpDroneMarkers"); //from Exp_fnc_automation
		}];
}
else  														// XXXXXXXX Dropped Event Handlers XXXXXXXXXX
{
	_droneObject addEventHandler ["Hit", 
		{				
			params ["_unit", "_source", "_damage", "_instigator"];
			
			if (_damage > .35) then 
				{
					{
						triggerAmmo _x;
					} forEach attachedObjects _unit;
					[] spawn Exp_fnc_removeHud;
					_unit removeAllEventHandlers "Fired";
					_unit removeAllEventHandlers "Hit";
				}
		}];
	_droneObject addEventHandler ["Fired",					
		{		
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			_magazineType = (_unit getVariable "ExpMagazine");
			_mass = ((getNumber(configFile >> "CfgMagazines" >> _magazineType >> "mass")) / 10);
			if ("fpvGrenade" == (typeOf ((attachedObjects _unit) select 0))) then 
			{
				
				_fakeGrenade = ((attachedObjects _unit) select 0);
				_replacement = _fakeGrenade getVariable "altWarhead"; 
				_offset = _fakeGrenade getVariable "altOffset";
				if ((_replacement isKindOf "G_40mm_HE") || (_replacement isKindOf "G_40mm_Smoke")  || (_replacement isKindOf "F_40mm_White") || (_replacement isKindOf "BulletBase")) then 
				{
					_newPOS = (getPosATL _unit);
					_newPOS set [2, ((_newPOS select 2) - 0.30)];
					_droppable = createVehicle [_replacement, _newPOS, [], 0, "CAN_COLLIDE"];
					//_droppable disableCollisionWith _unit;
					deleteVehicle _fakeGrenade;
					
					[_droppable, _magazineType] spawn 
					{	
						_bomb = _this select 0;					 	
						_gAccel = -9.81; // (m/s)2
						_startTime = Time;
						_curTime = 0;
						_dTime = 0;
						_zVelocity = 0; //m/s
						_dragForce = 0; // newtons
						_csArea = (pi * (((sizeOf (typeOf _bomb)) / 2) ^ 2)); //sqMeters
						_mass = ((getNumber(configFile >> "CfgMagazines" >> (_this select 1) >> "mass")) / 7); //Kilogram-ish (light objects dont scale as well (lower divisor))
						_densityAir = 1.293; //km-m3
						_DragCoef = 0.40;
						_gForce = 0; //newtons
						_changeAccel = 0; //(m/s)2

						while {(((getPosATL _bomb)select 2) > 0.15) && (_bomb != objnull)} do 
						{
							sleep 0.02;
							_dTime = _curTime;
							_curTime = Time - _startTime;
							_dTime = _curTime - _dTime; 
							_dragForce = (0.5 * _densityAir * ((- _zVelocity) ^ 2) * _DragCoef * _csArea);
							_gForce = _mass * _gAccel;
							_changeAccel = (_gForce + _dragForce) / _mass;
							_zVelocity = (_zVelocity + (_changeAccel * _dTime));	// SWAP CURTIME AND DTIME
							_bomb setVelocity [0, 0, _zVelocity];
							//hint str [_zVelocity, "\n", ((getPosATL _bomb) select 2), "\n", _curTime, "\n", _dTime, "\n", _dragForce, "\n", _gForce, "\n", (_gForce + _dragForce), "\n", _csArea];	
						};			
					};					
				}
				else 
				{
					_newPOS = (getPosATL _unit);
					_newPOS set [2, ((_newPOS select 2) - 0.30)];
					_droppable = createVehicle [_replacement, _newPOS, [], 0, "CAN_COLLIDE"];
					_droppable disableCollisionWith _unit;
					deleteVehicle _fakeGrenade;
				};
				
				[_unit] spawn Exp_fnc_rearmDrone;			
			}
			else 
			{
				
				_droppable = ((attachedObjects _unit) select 0);
				//_droppable disableCollisionWith _unit;
				detach _droppable;
				[_unit] spawn Exp_fnc_rearmDrone;
				
				[_droppable, _magazineType] spawn  
				{  
					_bomb = _this select 0; 	
					_descend = getPosATL _bomb;
					_Z = ((_descend select 2) - 0.5); 
					_gAccel = -9.81; // (m/s)2
					_startTime = Time;
					_curTime = 0;
					_dTime = 0;
					_velocity = 0; //m/s
					_dragForce = 0; // newtons
					_csArea = (pi * (((sizeOf (typeOf _bomb)) / 2) ^ 2)); //sqMeters
					_mass = ((getNumber(configFile >> "CfgMagazines" >> (_this select 1) >> "mass")) / 10); //Kilogram-ish
					_densityAir = 1.293; //km-m3
					_DragCoef = 1.1;
					_gForce = 0; //newtons
					_changeAccel = 0; //(m/s)2
				 
					while {(((getPosATL _bomb)select 2) > 0.15) && (_bomb != objnull)} do //Set Z to slightly above 0 to prevent issue with explosives hitbox being below terrain level -> preventing any explosive damage. 
					{ 
						sleep 0.02;
						_dTime = _curTime;
						_curTime = Time - _startTime;
						_dTime = _curTime - _dTime; 
						_dragForce = 0.5 * _densityAir * (-(_velocity / _dTime) ^ 2) * _DragCoef * _csArea;
						_gForce = _mass * _gAccel;
						_changeAccel = (_gForce + _dragForce) / _mass;
						_velocity = (_velocity + (_changeAccel * _dTime));		// SWAP CURTIME AND DTIME
						_Z = (_Z + _velocity);
						if (_Z <= 0.10) then {_Z = 0.1};
						_bomb setPos [(_descend select 0), (_descend select 1), (_Z)];
						//hint str [_Z, "\n" , (_velocity / _dTime), "\n", _curTime, "\n", _dTime, "\n", _dragForce, "\n", _gForce, "\n", (_gForce + _dragForce), "\n", _csArea];
					};			
					triggerAmmo _bomb; 
				};		
			};
				_unit removeAllEventHandlers "Fired";
				_unit removeAllEventHandlers "Hit";
		}];
};
/////////////////Automation//////////////////
if (_dropped == False) then {

	_droneObject addAction ["<t color='#bf6d02'>Auto-target acquistion</t>",  
	{ 
		params ["_target", "_caller", "_actionId"];
		[_target, _actionId] spawn Exp_fnc_automation;
	}, nil, 6, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == player))", 2, false, "",""];


}; 

//return value
true;			

////old code

/* 						_replacement = _x getVariable "altWarhead";
						_offset = _x getVariable "altOffset";				
						_newWarhead = _replacement createVehicle (getPosATL (_unit));
						deleteVehicle _x;
						_newWarhead attachto [(_unit), _offset];
						triggerAmmo _newWarhead;	 
*/