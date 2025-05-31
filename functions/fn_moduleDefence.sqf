// Detection methods (circle ring detection and (Line of sight from module at 40M height @ distance within 40% of max radius (instant detction)))
//unitaimposition
params [
	["_logic", objNull, [objNull]],		// module logic
	["_units", [], [[]]],				// list of affected units (affected by value selected in the 'class Units' argument))
	["_activated", true, [true]]		// True when activated, false when deactivated
];

/* 
//--- Terminate on client (unless it's curator who created the module)
if (!isserver && {local _x} count (objectcurators _logic) == 0) exitwith {}; 
*/


/* 	
//--- Wait for params to be set (zeus???)
if (_logic call bis_fnc_isCuratorEditable) then {
	waituntil {!isnil {_logic getvariable "vehicle"} || isnull _logic};
};
 */
 
if (isnull _logic) exitwith {};
if (!isserver) exitwith {};
_logic setPosATL [((getPosATL _logic) select 0), ((getPosATL _logic) select 1), 40];

 
 //////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////   Function Calls ////////////////////////////////////////////
 //////////////////////////////////////////////////////////////////////////////////////////////////
EXP_fnc_defenceModDistanceSort = 
{
	//INPUTS [_droneList, target]
	// _droneList = <array> list containing all defensive drones* in the drone swarm. (may not be drones depending on accidental synced objects)
	// _target = <object> selected target to attack
	// Returns: closest drone to target
	
	params 
	[
		["_droneList", [], [[]]],
		["_target", objNull, [objNull]]
	];
	_aliveDrones = [];
	{
		if ((alive _x) && (_x isNil "Seeking") && (_x isKindOf "fpv_Base_F")) then {_aliveDrones pushback _x;};	
	}foreach _droneList;
	
	if ((count _aliveDrones) == 0) exitWith 
	{
		objNull;
	};  //should check for objNull in below routines
	
	//might need to check that a drone is not already targeting either a far/close target including the first drone
	_availibleDrone = (_aliveDrones findIf {_x isNil "Seeking"});
	_minDistanceIndex = _availibleDrone;
	_minDistance = ((getPosATL _Target) distance2D (getPosATL (_aliveDrones select 0))); 
	for "_i" from (_availibleDrone + 1) to ((count _aliveDrones) - 1) step 1 do               //////	for "_i" from 1 to ((count _aliveDrones) - 1) step 1 do 
	{
		if ((_aliveDrones select _i) isNil "Seeking") then 
		{
			if (_minDistance > ((getPosATL _target) distance2D (getPosATL (_aliveDrones select _i)))) then 
			{
				_minDistance = ((getPosATL _target) distance2D (getPosATL (_aliveDrones select _i)));
				_minDistanceIndex = _i;		
			};		
		};
	};
	(_aliveDrones select _minDistanceIndex) setVariable ["Seeking", 1]; //set drone as off-limits for future targetting
	(_aliveDrones select _minDistanceIndex);  //return Value
};



 //////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////////////////////////////////////////////
 ///COPIED FROM fn_AUTOMATION.sqf modified to support logic module and smaller radius
Exp_fnc_defenceModSearch = 
{
//INPUTS [_droneObject, _marker]
// _droneObject = player controlled drone to be automated.
// _marker = location drone was sent to search for targets
// _logic = logic modules that the drone is synchroized to
params
[
	["_droneObject", objNull, [objnull]],
	["_markerPOS", 0, []], //unused for now, might change the _droneobject reveal distance to markerpos to accurately reflect the map marker 
	["_logic", objNull, [objNull]]
];
	
	_enemyList =[];
	_newList = [];
	_targetClass = ["Man","CAR","Wheeled_APC_F","Tank"]; //0, 1, 2, 3
	_preferredTargetType =  (_targetClass find (_logic getVariable ["PrimaryTarget", "Tank"])); //0-3, not 4- "Air" //userdefineable in game
	_targetPriorityIndex = []; //highest to lowest priority(userpriority first, greatest to least 3 -> 0)
	_targetCount = 0; //number of unit types found in total targetList sorted by targetPriorityIndex order
	_targetCountIndex = 0; //which unit type was found first based on priority
	_minDistanceIndex = 0; //index of the unit from newlist with the highest priority and closest distance
	_foundTarget = 0; //type 'object'; inialized as 0
	_radius = (((_logic getVariable ["SearchRadius", 150]) ^ (1/3)) * 12); //radius of the searchzone
	
	_enemyList append (_markerPOS nearEntities [["Man", "CAR", "Wheeled_APC_F", "Tank"], _radius]);
////NEW! Nearby Enemy list code (3 - 4.5x faster)
	_enemyList = [];
	_enemyList append (_markerPOS nearEntities [["Man", "CAR", "Wheeled_APC_F", "Tank"], _radius]);
	_removeIndexes = [];
	{
		if ((side _x isEqualTo side _droneObject) || ((side _droneObject getFriend side _x) > 0.6) || ((typename _x) isNotEqualTo (typename objNull))) then {_removeIndexes append [_foreachindex];};
	}foreach _enemyList;	
	if ((count _removeIndexes) > 0) then {_enemyList deleteat _removeIndexes;};

	
//Sets target priority weighting...	WORKING	
	_targetPriorityIndex set [0, _preferredTargetType];  //[1,3,2,0], [2,3,1,0], [0,3,2,1]
	for "_i" from 3 to 0 step -1 do 
	{	
		if (_i != _preferredTargetType) then {_targetPriorityIndex pushBack _i;};
	};
	
//Sort preferred target first, and then weighted targets next  [car,car,car,TANK,APC,APC,man,man,man,man]...
	{
		private _xCurTargetIndex = _x; 
		{
			//private _objType = (_x select 4); //// this needs to match the object to the correct config inheritance base class
			if (_x isKindOf (_targetClass select _xCurTargetIndex)) then 
			{
				if ((_xCurTargetIndex == 1) && {(_x isKindOf "Wheeled_APC_F")}) exitWith {}; //if car/truck/mrap is selected with higher priority, dont include APCs that are also considered 'cars'
				if ((_xCurTargetIndex == 0) && {(_preferredTargetType == 0) && {(vehicle _x)!= _x}}) exitWith {};
				_newList pushBack _x;
			};	
		} foreach _enemyList;
	} foreach _targetPriorityIndex;
		
//Find highest preferred targets if they exist and sort by distance (2nd half); else return to player... 
	{	
		private _xForeach = _x;
		_targetCount = ({_x isKindOf (_targetClass select _xForeach)} count _newList);
		if (_targetCount >= 1) exitWith {_targetCountIndex = _forEachIndex;};	//set which unit type was found first based on priority ordering [man, car, tank, apc...]
	} foreach _targetPriorityIndex;
	
	if (_targetCount >= 1) then 
	{
		_minDistance = (_markerPOS distance2D (getPosATL (_newList select 0))); 

		for "_i" from 1 to (_targetCount - 1) step 1 do 
		{
			if (_minDistance > (_markerPOS distance2D (getPosATL (_newList select _i)))) then 
			{
				_minDistance = (_markerPOS distance2D (getPosATL (_newList select _i)));
				_minDistanceIndex = _i;		
			};	
		};
		
		//Adjust flight height and return the found target...
		//(_droneObject) flyInHeight [1, true];
		_foundTarget = (_newList select _minDistanceIndex);
		_foundTarget; //RETURN VARIABLE 
	} 
	else //no found target
	{
		_foundTarget = 0;
		_foundTarget;
	};
};

 //////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////////////////////////////////////////////
EXP_fnc_defenceModWaypoints =
{
	params 
	[
		["_drone", objNull, [objNull]],
		["_logic", objNull, [objNull]]
	];
//	private _logicPos = getPosATL _logic;
	private _logicPosASL = getPosASL _logic;
	private _defenceZoneArea = _logic getVariable ["SearchRadius", 150];
	
	if (!(_drone isKindOf "fpv_Base_F")) exitWith {};
	
	//detect if uav is too close to _logic pos (125m) and set initial Waypoint to fly away
	if (((getPosASL _drone) distance2d _logicPosASL ) < 125) then 
	{
		_random150 = [-150,150];
		_waypoint = group(_drone) addWaypoint [[((_logicPosASL select 0) + (selectRandom _random150)), ((_logicPosASL select 1) + (selectRandom _random150)), ((_logicPosASL select 2) + 50)], 2, 1];
		_waypoint setWaypointForceBehaviour true;
		group(_drone) setCombatMode "BLUE";
		group(_drone) setCombatBehaviour "CARELESS";
		_waypoint setWaypointBehaviour "CARELESS";
		_waypoint setWaypointSpeed "FULL";
		_waypoint setWaypointType "MOVE"; 			
		_waypoint setWaypointCompletionRadius 10;
		group(_drone) setCurrentWaypoint _waypoint;
		_waypoint2 = group(_drone) addWaypoint [[_logicPosASL select 0, _logicPosASL select 1, ((_logicPosASL select 2) + 50)], 2, 2];
		_waypoint2 setWaypointForceBehaviour true;
		_waypoint2 setWaypointBehaviour "CARELESS";
		_waypoint2 setWaypointSpeed "LIMITED";
		_waypoint2 setWaypointType "LOITER"; 			
		_waypoint2 setWaypointLoiterRadius (round (random [(_defenceZoneArea * 0.725), _defenceZoneArea, (_defenceZoneArea * 1.125)])); 
		_waypoint2 setWaypointLoiterType (selectRandom ["CIRCLE", "CIRCLE_L"]);
		_waypoint2 setWaypointLoiterAltitude (round (random [50, 60, 70]));
		_drone limitspeed (round (random [25, 35, 45]));
	}
	else 
	{
		_waypoint = group(_drone) addWaypoint [[_logicPosASL select 0, _logicPosASL select 1, ((_logicPosASL select 2) + 50)], 2, 2];
		_waypoint setWaypointForceBehaviour true;
		group(_drone) setCombatMode "BLUE";
		group(_drone) setCombatBehaviour "CARELESS";
		_waypoint setWaypointBehaviour "CARELESS";
		_waypoint setWaypointSpeed "LIMITED";
		_waypoint setWaypointType "LOITER"; 			
		_waypoint setWaypointLoiterRadius (round (random [(_defenceZoneArea * 0.725), _defenceZoneArea, (_defenceZoneArea * 1.125)])); 
		_waypoint setWaypointLoiterType (selectRandom ["CIRCLE", "CIRCLE_L"]);
		_waypoint setWaypointLoiterAltitude (round (random [50, 60, 70]));
		group(_drone) setCurrentWaypoint _waypoint;
		_drone limitspeed (round (random [30, 45, 60]));			
	};
};
 
 

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
///COPIED FROM fn_AUTOMATION.sqf WITHOUT ICON3D SUPPORT & Altered new target search function
Exp_fnc_defenceModtargetSeek = 
{
	//INPUTS [_droneObject, _enemyTarget]
	//_droneObject = player controlled friendly drone
	//_enemyTarget = highest value target that is the closest
	//_logic = logic module
	
	
	params 
	[
		["_droneObject", objNull, [objNull]],
		["_enemyTarget", objNull, [objNull]],
		["_logic", objNull, [objNull]]
	];
	
	
	_interceptDistance = 0.2; //Distance before intercept is considered complete (default value)
	_interceptVelocity = [30, 30, 20]; //Top speed to accelerate to (m/s)
	_targetCOM = getCenterOfMass _enemyTarget; //center of mass of target (only applicable to modelspace,(modeltoworld))
	_RndMemoryPOS = selectRandom ["usti hlavne2", "driverview", "commanderview", "commander_turret", "gunnerview2", "osa_poklop_gunner", "engine_smoke1", "engine_smoke2"]; //memory positions typically of armored vehicles
	_accelerationRateTime = 3.5; //time to accelerate (non-linear, follows a curve)
	
	if ((_enemyTarget isKindOf "Man") && ((vehicle _enemyTarget) == _enemyTarget)) then 
	{
		if ((typeOf (((attachedObjects _droneObject))select 0)) == "ClaymoreDirectionalMine_Remote_Ammo") then //airburst distance for 'man' type targets 
		{
			_interceptDistance = 18.5; //claymore directional distance
		}
		else
		{
		
			if ((typeOf (((attachedObjects _droneObject))select 0)) isKindOf "DirectionalBombBase") then //airburst distance for 'man' type targets with either claymore types or general explosive types.
			{
				_interceptDistance = 10.5; //general directional mines that arent vanilla claymores. (Mruds, Slams...)
			}
			else
			{
				_interceptDistance = 3;  //general explosives distance
			};
		};
	};
	
	
	/////////////////////  Waypoint to target ////////////////////////////////////
	if (((getPosATL _droneObject) distance2D (getPosATL _enemyTarget)) >= 125) then 
	{
		{deleteWaypoint _x;} forEachReversed (waypoints (group _droneObject));
		_waypoint = group(_droneObject) addWaypoint [(getPosATL _enemyTarget), 2, 1];
		_waypoint setWaypointForceBehaviour true;
		group(_droneObject) setCombatMode "BLUE";
		group(_droneObject) setCombatBehaviour "CARELESS";
		_waypoint setWaypointBehaviour "CARELESS";
		_waypoint setWaypointSpeed "FULL";
		_waypoint setWaypointType "MOVE"; 			
		_waypoint setWaypointCompletionRadius 65;
		group(_droneObject) setCurrentWaypoint _waypoint;
		_droneObject limitspeed 120;
		waitUntil {sleep 2.0; (((getposatl _droneObject) distance2D (getPosATL _enemyTarget)) < 110)};		
	};

	
	////////////////// SEEKER SCRIPT ///////////////////////
	_targetingUpdate = addMissionEventHandler ["EachFrame", 
	{
		//////_THISARGS REFERENCES//////
		//_droneObject = (_thisArgs select 0);
		//_enemyTarget = (_thisArgs select 1);
		//_interceptDistance = (_thisArgs select 2);
		//_interceptVelocity = (_thisArgs select 3);
		//_targetCOM = (_thisArgs select 4);
		//_RndMemoryPOS = (_thisArgs select 5);
		//_accelerationRateTime = (_thisArgs select 6);
		//_logic = (_thisArgs select 7);
		
		If (!alive (_thisArgs select 1)) exitWith
		{	
			removeMissionEventHandler ["EachFrame", _thisEventHandler];
			_target = [(_thisArgs select 0), (getPosATL (_thisArgs select 0))] call Exp_fnc_defenceModSearch;
			(_thisArgs select 0) setvariable ["EXP_accelTime", nil];
			if ((typeName _target) == "OBJECT") then 
			{
				[(_thisArgs select 0), _target, (_thisArgs select 7)] spawn Exp_fnc_defenceModtargetSeek;	
			}
			else 
			{
				(_thisArgs select 0) setVariable ["Seeking", nil];
				[(_thisArgs select 0), (_thisArgs select 7)] spawn EXP_fnc_defenceModWaypoints;
			};
		};
			
		////////////// HIGHER FREQUENCY TARGET POS CHECKS HERE ////////////////
		//_dTime = (diag_deltaTime);
		_dronePos = (getPosATL (_thisArgs select 0));
		_targetPos = unitAimPosition (_thisArgs select 1);
		switch ((objectParent (_thisArgs select 1)) isKindOf "Man") do
		{
			case True: 
			{
					_targetPos =  (unitAimPosition (_thisArgs select 1));
		
			};
			case False: 
			{
				if (((_thisArgs select 1) selectionPosition (_thisArgs select 5)) isNotEqualTo [0,0,0]) then 	
				{			
					_targetPos = ((_thisArgs select 1) modelToWorld ((_thisArgs select 1) selectionPosition (_thisArgs select 5)));				
				}
				else 
				{
					_targetPos = unitAimPosition (_thisArgs select 1);
				};
			};
		};
		_vectorTargetVelocity = velocity (_thisArgs select 1);
		_futureTargetPos = _targetPos; //vectorAdd (_vectorTargetVelocity vectorMultiply _dTime);
		_distanceToTarget = _dronePos distance _futureTargetPos; //distance between drone and expected future pos of target
		_vectorDiffDistance = (_dronePos vectorDiff _futureTargetPos);
		
		
		if ((_distanceToTarget >= (_thisArgs select 2)) && (alive (_thisArgs select 0))) then
		{
			
			if ((diag_frameNo mod 4) isEqualTo 0) then
			{		
			
				////////////// LOWER FREQUENCY DRONE VELOCITY AND ANGLE UPDATES HERE ////////////////
				_velocityVectorDirNorm = [];
 				if ((_thisArgs select 0) isNil "EXP_accelTime") then  ////////namespace isNil variableName (faster) ////// isNil {((_thisArgs select 0) getVariable "EXP_accelTime")}
				{
					(_thisArgs select 0) setvariable ["EXP_accelTime", ((_thisArgs select 6) - ((diag_deltaTime) * 4))];
				}
				else
				{
					(_thisArgs select 0) setvariable ["EXP_accelTime", (((_thisArgs select 0) getVariable "EXP_accelTime") - ((diag_deltaTime) * 4))];
				};
				_accelTime = ((_thisArgs select 0) getVariable "EXP_accelTime");
				if (_accelTime < 0) then {_accelTime = 0;};
				_accelerationFactor = ((1 - (1.625 ^ (_accelTime * (_accelTime - 3.5)))) ^ (0.5 * (_accelTime ^ 1.75)));				
				_incVelocity = ((_thisArgs select 3) vectorMultiply _accelerationFactor);						
				_vectorDirNorm = _dronePos vectorFromTo _futureTargetPos;
				_minVector = selectMin _vectorDirNorm;
				if (_minVector < 0) then {_minVector = -(_minVector);};
				_maxVector = selectmax _vectorDirNorm;
				if (_maxVector < 0) then {_maxVector = -(_maxVector);};
				_extremeVector = _minVector max _maxVector;
				{
					_velocityVectorDirNorm set [_forEachIndex, (linearConversion [0, _extremeVector, _x, 0, 1])];
				}forEach _vectorDirNorm;
				_incVelocity = (_incVelocity vectorMultiply _velocityVectorDirNorm);
				_attackAngle = ((-(_incVelocity select 2)) / (((vectorMagnitude _incVelocity)) + 0.0001)); // 0.0001 is to prevent 0 divisor error
				(_thisArgs select 0) setVectorDir _vectorDirNorm;	
				(_thisArgs select 0) setVectorUp 
				[
					((-cos (getDir (_thisArgs select 0) + 90)) * _attackAngle), 
					((sin (getDir (_thisArgs select 0) + 90)) * _attackAngle),
					(1 - _attackAngle)
				]; 
				(_thisArgs select 0) setvelocity _incVelocity;
				
			};		
		
		}
		else
		{	
				{
					if ("fpvAmmo" == (typeOf _x)) then 
					{
						_replacement = _x getVariable "altWarhead";
						_ModelPosition = _x worldToModel (getPosATL (_thisArgs select 0));
						deleteVehicle _x;
						_WorldPos =  (_thisArgs select 0) modelToWorld _ModelPosition;
						_newWarhead = _replacement createVehicle (_WorldPos);
						_newWarhead setVectorDirAndUp [vectorDir (_thisArgs select 0), vectorUp (_thisArgs select 0)];
						triggerAmmo _newWarhead; 
					}							
					else 
					{
						triggerAmmo _x;
					}; 
								
				} forEach attachedObjects (_thisArgs select 0);
				(_thisArgs select 0) removeAllEventHandlers "Fired";
				(_thisArgs select 0) removeAllEventHandlers "Hit";
				(_thisArgs select 0) removeAllEventHandlers "Killed";
				(_thisArgs select 0) removeAllEventHandlers "Disassembled";
				(_thisArgs select 0) removeAllEventHandlers "Deleted"; 
				removeMissionEventHandler ["EachFrame", _thisEventHandler];				
		};
		
	},[_droneObject, _enemyTarget, _interceptDistance, _interceptVelocity, _targetCOM, _RndMemoryPOS, _accelerationRateTime, _logic] ];
	waitUntil {sleep 6; (!alive _droneObject)};
	deleteVehicle _droneObject;
	removeMissionEventHandler ["EachFrame", _targetingUpdate]; //failsafe
};


///////////////////////////////////////////////// END OF FUNCTIONS ///////////////////////////////////////////////////////////



// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then
{
	// Attribute values are saved in module's object space under their class names
	private _warheadClass = _logic getVariable ["Warhead", 2]; 
	private _defenceZoneArea = _logic getVariable ["SearchRadius", 150];
	private _DetectionPercent = _logic getVariable ["DetectionChance", 2.5];
	private _PrimaryTarget = _logic getVariable ["PrimaryTarget", "Tank"]; //not functional yet
	private _DroneSideSelection = _logic getVariable ["DroneSide", 0];
	
	
	_logic setVariable ["TargetLOS", 0];
	private _chance = 0;
	private _droneside = [WEST, EAST, INDEPENDENT] select _DroneSideSelection;
	private _logicPos = getPosATL _logic;
	private _logicPosASL = ATLToASL _logicPos;
	private _warhead = "";
	private _preferredTargetType =  (["Man","CAR","Wheeled_APC_F","Tank"] find (_logic getVariable ["PrimaryTarget", "Tank"])); //0-3, not 4- "Air"
	private _targetPriorityIndex = [];
	//_allsides deleteAt _DroneSideSelection;
	
// START AMMO INITIALIZATION:	(unintended ammo types are getting in (eg rifles...))
	_ATconfig = 
		"
		(		
			(getText (_x >> 'muzzleEffect')) == 'BIS_fnc_effectFiredRocket'
			&& 
			{((getText (_x >> 'submunitionAmmo')) find 'penetrator') > 0}	
		)
		||
		(
			(configName _x) isKindOf 'SatchelCharge_Remote_Ammo'
		)
		" 
		configClasses (configFile >> "CfgAmmo");
	
	_APconfig = 
		"
		(
			(getText (_x >> 'muzzleEffect')) == 'BIS_fnc_effectFiredRocket' 
			&& 
			{(getText (_x >> 'warheadName')) == 'HE'}
		)
		||
		(
			(getText (_x >> 'explosionEffects')) != 'ExplosionEffects'
			&&
			{
				(configName _x) isKindOf 'DirectionalBombBase'
				||
				(configName _x) isKindOf 'PipeBombBase'
			}
		)
		" 
		configClasses (configFile >> "CfgAmmo");	
		
	_RandomConfig = _APconfig + _ATconfig;	
// END AMMO INITIALIZATION
	
	_defenceMarker = createMarker [("_defenceMarker"), _logicPos, 1, objNull];	
	_defenceMarker setMarkerShape "ELLIPSE";
	_defenceMarker setMarkerSize [_defenceZoneArea, _defenceZoneArea];
	_defenceMarker setMarkerBrush "DiagGrid";
	_defenceMarker setMarkerColor "ColorBlue";
	_defenceMarker2 = createMarker [("_defenceMarker2"), _logicPos, 1, objNull];	
	_defenceMarker2 setMarkerType "MinefieldAP";
	_defenceMarker2 setMarkerText ("Drone search area: "  + (str _defenceZoneArea) + " meters");
	_defenceMarker2 setMarkerColor "ColorRed";
	_defenceMarker2 setMarkerSize [1.5, 1.5];
	
	{
		if (_x isKindOf "fpv_Base_F") then 
		{
			
			switch (_warheadClass) do
			{
				case 0 : {_warhead = configName (selectRandom _ATconfig)};
				case 1 : {_warhead = configName (selectRandom _APconfig)};
				case 2 : {_warhead = configName (selectRandom _RandomConfig)};
				default {_warhead = configName (selectRandom _RandomConfig)};
			};
			[_warhead, _x, false] call Exp_fnc_finalStage;
			removeAllActions _x;
			_x lockDriver true;
			_x enableUAVWaypoints false; //disable player interference
			{deleteWaypoint _x;} forEachReversed (waypoints (group _x));
			sleep (random 0.35); //makes the uavs starting feel less fake

			[_x, _logic] spawn EXP_fnc_defenceModWaypoints;
		};
	} foreach _units;
	sleep 20; //let uavs get to altitude and begin their loitering first
	
	//Sets target priority weighting...	WORKING	
	_targetPriorityIndex set [0, _preferredTargetType];  //[1,3,2,0], [2,3,1,0], [0,3,2,1]
	for "_i" from 3 to 0 step -1 do 
	{	
		if (_i != _preferredTargetType) then {_targetPriorityIndex pushBack _i;};
	};

	while {sleep 1; (({alive _x} count _units) > 0)} do 
	{	
		private _enemyList = [];
		private _closeTargets = [];
		private _farTargets = [];
		private _xTargetClose = objNull;
		private _xTargetFar = objNull;
		private _unitCountDetectionBoost = 0;
		
		//auto refuel drones
		if ((fuel (selectRandom _units)) <= 0.6) then {{(vehicle _x) setFuel 1.0;} foreach _units;};  
		
		_enemyList append (_logicPos nearEntities [["Man", "CAR", "Wheeled_APC_F", "Tank"], _defenceZoneArea]);
		_removeIndexes = [];
		{
			if ((side _x isEqualTo _droneside) || ((_droneside getFriend side _x) > 0.6) || ((typename _x) isNotEqualTo (typename objNull))) then {_removeIndexes append [_foreachindex];};
		}foreach _enemyList;	
		if ((count _removeIndexes) > 0) then {_enemyList deleteat _removeIndexes;};
		
		
		//Line of sight detection @ 40% max distance
		{
			if (((getPosATL _logic) distance2d (getPosATL _x)) <= (_defenceZoneArea * 0.40)) then 
			{_closeTargets pushBack _x;}
			else 
			{_farTargets pushBack _x;};
		} foreach _enemyList;
		
			//Sort _closeTargets & _farTargets by targetType
				//Sort preferred target first, and then weighted targets next  [car,car,car,TANK,APC,APC,man,man,man,man]...		
				{	
					private _xTargets = _x;
					private _xForeachIndex = _forEachIndex;
					private _templist = [];
					{
						private _xCurTargetIndex = _x;
						{
							if (_x isKindOf (["Man","CAR","Wheeled_APC_F","Tank"] select _xCurTargetIndex)) then 
							{
								if ((_xCurTargetIndex == 1) && {(_x isKindOf "Wheeled_APC_F")}) exitWith {}; //if car/truck/mrap is selected with higher priority, dont include APCs that are also considered 'cars'
								if ((_xCurTargetIndex == 0) && {(_preferredTargetType == 0) && {(vehicle _x)!= _x}}) exitWith {};
								_templist pushBack _x;
							};	
						} foreach _xTargets;
						if (_xForeachIndex == 0) then {_closeTargets = _templist;} else {_farTargets = _templist;};
					} foreach _targetPriorityIndex;
				} foreach [_closeTargets, _farTargets];
				

			
		//LOS Target Detection
		if ((count _closeTargets) > 0) then 
		{_xTargetClose = (_closeTargets select 0);} //This shouldnt be random it should be psuedo-random for the preferred target first //selectRandom 
		else
		{_xTargetClose = objNull;};


		if ((((_logic getVariable "TargetLOS") == 0) && {(_xTargetClose isNotEqualTo objNull)})) then 
		{
			_logic setVariable ["TargetLOS", 1];
			//consider doing "targerLOS" on the target instead and keep selectrandom targets that do not have "targerLOS" so that the logic can spawn multiple attack drones on multiple targets
			[_xTargetClose, _logic, _units] spawn
			{
				params 
				[
					["_targetClose", objNull, [objNull]],
					["_logic", objNull, [objNull]],
					["_units", [], [[]]]
				];
				
				_startTime = (round diag_tickTime);
				_spottedIndex = 0;
				_searchRate = 1; //seconds between counted visibility checks (10x to attack target)
				_selectedDrone = objnull;
				while {(([(vehicle _TargetClose), "VIEW", objnull] checkVisibility [(eyepos _logic), (eyepos (_targetClose))] >= 0.65) && (alive _targetClose)) && {(_spottedIndex <= 10)}} do
				{
					if ((_startTime) <= (floor diag_tickTime)) then 
					{
						if (((round diag_tickTime) mod _searchRate) <= 0) then 
						{
							_spottedIndex = _spottedIndex + 1;
						};	
						_startTime = ((round diag_tickTime) + 1);	
					};

				};
				if (_spottedIndex >= 10) then 
				{	
					 _selectedDrone = [_units, _TargetClose] call EXP_fnc_defenceModDistanceSort;
					if (_selectedDrone isNotEqualTo objNull) then 
					{
						[_selectedDrone, _targetClose, _logic] spawn Exp_fnc_defenceModtargetSeek;
					};
				};
				_logic setVariable ["TargetLOS", 0];
			};
		}; 
		
		//Circle Detection 		
		if ((count _farTargets) > 0) then 
		{
			_xTargetFar = (_farTargets select 0);   //This shouldnt be random it should be psuedo-random for the preferred target first selectRandom
			_eyePosTarget = eyePos (_xTargetFar);
			if (([(vehicle _xTargetFar), "VIEW", objNull] checkVisibility [_eyePosTarget, [(_eyePosTarget select 0), (_eyePosTarget select 1), ((_eyePosTarget select 2) + 60)]]) > 0.65) then 
			{
				_unitCountDetectionBoost = (1 + (floor ((count _farTargets) / 8)));
				if (_DetectionPercent == 0) then 
				{
				 _chance = 1; //instant detection
				}
				else
				{
					_chance = ((round (random 100.00)) / (_DetectionPercent * _unitCountDetectionBoost));
				};
				
				//prevent Drone from changing targets using setvariable
				if (_chance <= 1) then 
				{
					 _selectedDrone = [_units, _xTargetFar] call EXP_fnc_defenceModDistanceSort;
					if (_selectedDrone isNotEqualTo objNull) then 
					{
						[_selectedDrone, _xTargetFar, _logic] spawn Exp_fnc_defenceModtargetSeek;
					};
				};		
			};	
		};	
	};	
};
true;
/* 	((((getText (_x >> 'warheadName')) == 'HEAT')) || (((getText (_x >> 'explosionEffects')) == 'TandemHEAT')))
	(((getText (_x >> 'explosionEffects')) == 'ATMissileExplosion'))
	(((getText (_x >> 'explosionEffects')) == 'ATRocketExplosion')) */