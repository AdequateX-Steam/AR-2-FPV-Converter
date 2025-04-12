#include "\a3\ui_f\hpp\definedikcodes.inc"
private _droneObject = _this select 0;
private _actionId = _this select 1;
_droneObject setVariable ["EXP_targetType", 3]; //default initialization (3)

///////////////////////////////////////////////////////////////
/////////////////		Functions		///////////////////////
///////////////////////////////////////////////////////////////
// Function to create waypoint for the drones to move to - to search for targets
EXP_fnc_wayPointTraversal = 
{
//INPUTS [_droneObject, _pos]
//_droneObject = player controlled drone to be automated.
//_pos = map location player clicked
	_droneObject = (_this select 0);
	_pos = (_this select 1);
	_target = 0;
	_hostileRandomDist = random [150,190,250]; // random distance (higher distances give AI a better chance to shoot down the drone)
	_droneObject setCaptive true; //tricks enemies until it gets closer to the waypoint or else it usually get shot down
	_droneObject lockDriver true;
	{deleteWaypoint _x;} forEachReversed (waypoints (group _droneObject));
	_droneObject enableUAVWaypoints false; //disable player interference
	_droneMarker1 = createMarker [((str _droneObject) + "DroneSearchArea"), _pos, 1, player];
	_droneMarker1 setMarkerShape "ELLIPSE";
	_droneMarker1 setMarkerSize [250,250];
	_droneMarker1 setMarkerBrush "DiagGrid";
	_droneMarker1 setMarkerColor "ColorRed";
	_droneMarker2 = createMarker [((str _droneObject) + "DroneSearchMarker"), _pos, 1, player];
	_droneMarker2 setMarkerType "mil_objective_noShadow";
	_droneMarker2 setMarkerText "Drone search area (250m radius)";
	_droneMarker2 setMarkerColor "ColorBlack";
	_droneMarker2 setMarkerAlpha 1;
	_waypoint = group(_droneObject) addWaypoint [[_pos select 0,_pos select 1, 65], -1, 1];
	group(_droneObject) setCurrentWaypoint _waypoint;
	_droneObject flyInHeight 65;
	group(_droneObject) setCombatMode "BLUE";
	group(_droneObject) setCombatBehaviour "CARELESS";
	_waypoint setWaypointBehaviour "CARELESS";
	_waypoint setWaypointCompletionRadius 40; //29
	_waypoint setWaypointSpeed "FULL";
	_waypoint setWaypointType "LOITER"; //MOVE
	_waypoint setWaypointForceBehaviour true;
	_waypoint setWaypointLoiterRadius 35;
	waitUntil{sleep 1.5; (((_droneObject distance2D _pos) <= _hostileRandomDist) || !alive _droneObject)}; //low frequency check, for when a drone is far from its target
	_droneObject setCaptive false; //returns to normal status as a hostile drone to the enemy targets
	waitUntil{sleep 0.30; ((((_droneObject distance2D _pos) <= 115) && (((getPosAtl _droneObject) select 2) >= 40)) || !alive _droneObject)}; //higher frequency check
	deleteWaypoint [group(_droneObject), 1];
	if (alive _droneObject) then 
	{
		_target = [_droneObject, (getMarkerPos _droneMarker2)] call Exp_fnc_targetSearch;
		deleteMarker _droneMarker1;
		deleteMarker _droneMarker2;
		if ((typeName _target) == "OBJECT") then 
		{
			[_droneObject, _target] spawn Exp_fnc_targetSeek;
		}
		else 
		{
			[_droneObject] spawn Exp_fnc_returnToPlayer;
		};
	}
	else
	{
		deleteMarker _droneMarker1;
		deleteMarker _droneMarker2;
	};
};

//Function to find appropriate targets based on target-type (tank, apc, truck, soldier) and distance from the drone
Exp_fnc_targetSearch = 
{
//INPUTS [_droneObject, _marker]
// _droneObject = player controlled drone to be automated.
//_marker = location drone was sent to search for targets
params
[
	["_droneObject", nil, [objnull]],
	["_markerPOS", 0, []] //unused for now, might change the _droneobject reveal distance to markerpos to accurately reflect the map marker 
];
	
	_enemyList =[];
	_newList = [];
	_preferredTargetType = (_droneObject getVariable "EXP_targetType"); //0-3, not 4- "Air" //userdefineable in game
	_targetClass = ["Man","CAR","Wheeled_APC_F","Tank"]; //0, 1, 2, 3
	_targetPriorityIndex = []; //highest to lowest priority(userpriority first, greatest to least 3 -> 0)
	_targetCount = 0; //number of unit types found in total targetList sorted by targetPriorityIndex order
	_targetCountIndex = 0; //which unit type was found first based on priority
	_minDistanceIndex = 0; //index of the unit from newlist with the highest priority and closest distance
	_foundTarget = 0; //type 'object'; inialized as 0
	_radius = 250; //radius of the searchzone
	

////NEW! Nearby Enemy list code (3 - 4.5x faster)
	_enemyList = [];
	_enemyList append (_markerPOS nearEntities ["Man", _radius]);
	_enemyList append (_markerPOS nearEntities ["CAR", _radius]);
	_enemyList append (_markerPOS nearEntities ["Wheeled_APC_F", _radius]);
	_enemyList append (_markerPOS nearEntities ["Tank", _radius]);
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
		(_droneObject) flyInHeight [1, true];
		_foundTarget = (_newList select _minDistanceIndex);
		_foundTarget; //RETURN VARIABLE 
	} 
	else //no found target
	{
		_foundTarget = 0;
		_foundTarget;
	};
};

//Seeker Function to track and intercept target...
Exp_fnc_targetSeek = 
{
	//INPUTS [_droneObject, _enemyTarget]
	//_droneObject = player controlled friendly drone
	//_enemyTarget = highest value target that is the closest
	_droneObject = _this select 0;
	_enemyTarget = _this select 1;
	_interceptDistance = 0.2; //Distance before intercept is considered complete (default value)
	_interceptVelocity = [50, 50, 33]; //Top speed to accelerate to (m/s)
	_targetCOM = getCenterOfMass _enemyTarget; //center of mass of target (only applicable to modelspace, needs to be translated using cos(dir) + sin(dir) for world space)
	_startFrame = diag_frameNo;	//start of eachframeEH to compare against for furture time
	_accelerationRateTime = 3.5; //time to accelerate (non-linear, follows a curve)
	
	if ((_enemyTarget isKindOf "Man") && ((vehicle _enemyTarget) == _enemyTarget)) then 
	{
		if ((typeOf (((attachedObjects _droneObject))select 0)) == "ClaymoreDirectionalMine_Remote_Ammo") then //airburst distance for 'man' type targets 
		{
			_interceptDistance = 24.5; //claymore directional distance
		}
		else
		{
		
			if ((typeOf (((attachedObjects _droneObject))select 0)) isKindOf "DirectionalBombBase") then //airburst distance for 'man' type targets with either claymore types or general explosive types.
			{
				_interceptDistance = 16.5; //general directional mines that arent vanilla claymores. (Mruds, Slams...)
			}
			else
			{
				_interceptDistance = 5;  //general explosives distance
			};
		};
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
		//_startFrame = (_thisArgs select 5);
		//_accelerationRateTime = (_thisArgs select 6);
		
		If (!alive (_thisArgs select 1)) exitWith
		{	
			removeMissionEventHandler ["EachFrame", _thisEventHandler];
			_target = [(_thisArgs select 0), (getPosATL (_thisArgs select 0))] call Exp_fnc_targetSearch;
			(_thisArgs select 0) setvariable ["EXP_accelTime", nil];
			if ((typeName _target) == "OBJECT") then 
			{
				[(_thisArgs select 0), _target] spawn Exp_fnc_targetSeek;	
			}
			else 
			{
				[(_thisArgs select 0)] spawn Exp_fnc_returnToPlayer;
			};		
				
		};
			
		////////////// HIGHER FREQUENCY TARGET POS CHECKS HERE ////////////////
		
		//_dTime = (diag_deltaTime);
		_dronePos = (getPosATL (_thisArgs select 0));
		_targetPos = 
		[
			(((getPosATL (_thisArgs select 1))select 0) + (-(cos (((getDir (_thisArgs select 1)) +90))) * ((_thisArgs select 4) select 1))),  //getPosATLVisual looks visually more correct but getPosAtl is more accurate to simulation position actual
			(((getPosATL (_thisArgs select 1))select 1) + ((sin (((getDir (_thisArgs select 1)) +90))) * ((_thisArgs select 4) select 1))), 
			(((getPosATL (_thisArgs select 1))select 2) + (-((_thisArgs select 4) select 2)))
		];		
		_vectorTargetVelocity = velocity (_thisArgs select 1);
		_futureTargetPos = _targetPos; //vectorAdd (_vectorTargetVelocity vectorMultiply _dTime);
		_distanceToTarget = _dronePos distance _futureTargetPos; //distance between drone and expected future pos of target
		_vectorDiffDistance = (_dronePos vectorDiff _futureTargetPos);
		
		///////////////////////////////////   Target Icon 3D   ///////////////////////////////////////////////
	
	
		//probably check if player is within 1000m, and using isEqualTo
		if (missionnamespace isNil "EXP_TargetICON") then 
		{
			if (((count (lineIntersectsWith [(AGLToASL (positionCameraToWorld [0,0,0])), (ATLToASL _targetPos), Player ,(_thisArgs select 1) , true])) == 0) && {(!(terrainIntersectASL [((AGLToASL (positionCameraToWorld [0,0,0]))),((ATLToASL _targetPos))]))}) then 
			{
				drawIcon3D 
				[
					"\a3\ui_f\data\IGUI\Cfg\Cursors\attack_ca.paa",
					[
					[1,0,0,1],
					[1,0.87,0.55,1]
					],
					_targetPos,
					2,
					2, 
					45, 
					"Target", 
					1, 
					0.05, 
					"PuristaSemiBold"
				]; 	
			};
		}
		else 
		{
			if ((missionnamespace getVariable "EXP_TargetICON")) then 
			{
				if (((count (lineIntersectsWith [(AGLToASL (positionCameraToWorld [0,0,0])), (ATLToASL _targetPos), Player ,(_thisArgs select 1) , true])) == 0) && {(!(terrainIntersectASL [((AGLToASL (positionCameraToWorld [0,0,0]))),((ATLToASL _targetPos))]))}) then 
				{
					drawIcon3D 
					[
						"\a3\ui_f\data\IGUI\Cfg\Cursors\attack_ca.paa",
						[
						[1,0,0,1],
						[1,0.87,0.55,1]
						],
						_targetPos,
						2,
						2, 
						45, 
						"Target", 
						1, 
						0.05, 
						"PuristaSemiBold"
					]; 	
				};				
			};	
		};



		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		if ((_distanceToTarget >= (_thisArgs select 2)) && (alive (_thisArgs select 0))) then
		{
			
			if ((diag_frameNo mod 4) isEqualTo 0) then
			{		
			
				////////////// LOWER FREQUENCY DRONE VELOCITY AND ANGLE UPDATES HERE ////////////////
				_velocityVectorDirNorm = [];
 				if (isNil {((_thisArgs select 0) getVariable "EXP_accelTime")}) then  ////////namespace isNil variableName (faster)
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
				[] spawn Exp_fnc_removeHud;
				(_thisArgs select 0) removeAllEventHandlers "Fired";
				(_thisArgs select 0) removeAllEventHandlers "Hit";
				(_thisArgs select 0) removeAllEventHandlers "Killed";
				(_thisArgs select 0) removeAllEventHandlers "Disassembled";
				(_thisArgs select 0) removeAllEventHandlers "Deleted"; 
				removeMissionEventHandler ["EachFrame", _thisEventHandler];				
		};
		
	},[_droneObject, _enemyTarget, _interceptDistance, _interceptVelocity, _targetCOM, _startFrame, _accelerationRateTime] ];
	waitUntil {sleep 3; (!alive _droneObject)};
	removeMissionEventHandler ["EachFrame", _targetingUpdate]; //failsafe
};




// This functions adds a waypoint to return the drone to the player and land 
Exp_fnc_returnToPlayer = 
{
//INPUTS [_droneObject]
// _droneObject = player controlled drone to be automated.
	_droneObject = (_this select 0);
	_pos = getPosATL player;
	{deleteWaypoint _x;} forEachReversed (waypoints (group _droneObject));
	hint "Drone is returning to current player's 'static' position (no target found)";
	_waypoint = group(_droneObject) addWaypoint [[(_pos select 0), (_pos select 1), 0], 12, -1];
	group(_droneObject) setCurrentWaypoint _waypoint;
	_droneObject flyInHeight [30, false];
	group(_droneObject) setCombatMode "BLUE";
	group(_droneObject) setCombatBehaviour "CARELESS";
	_waypoint setWaypointBehaviour "CARELESS";
	_waypoint setWaypointCompletionRadius 10;
	_waypoint setWaypointSpeed "FULL";
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointForceBehaviour true;
	waitUntil {sleep 1; (((_droneObject distance2D _pos ) <= 32) || (!alive _droneObject))};
	_droneObject flyInHeight [0, false];
	[_droneObject, false] remoteExec ["lockDriver"];
	_droneObject enableUAVWaypoints true;
	if (alive _droneObject) then {hint "Drone controls unlocked";};
	waitUntil {sleep 0.66; ((((getPosATL _droneObject) select 2) < 3) || (!alive _droneObject))};
	_droneObject engineOn false;
	_droneObject addAction ["<t color='#bf6d02'>Auto-target acquistion</t>",  
	{ 
		params ["_target", "_caller", "_actionId"];
		[_target, _actionId] spawn Exp_fnc_automation;
	}, nil, 6, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == player))", 2, false, "",""];

};


///////////////////////////////////////////////////////////////
//////////////		Event Handlers		///////////////////////
///////////////////////////////////////////////////////////////
_clickEHID = addMissionEventHandler ["MapSingleClick", 
{
	params ["_units", "_pos", "_alt", "_shift"];
	//need to set a maximum waypoint distance
	if ((_pos distance2D player) < 20) then 
	{
		hint format ["Minimum required distance from player: 20 meters; Current distance: %1 meters",(_pos distance2D player)];
	}
	else
	{
		(_thisArgs select 0) removeAction (_thisArgs select 1);
		[(_thisArgs select 0), _pos] spawn EXP_fnc_wayPointTraversal;
		openMap [false, false];
		hint "WARNING: Drone control has been disabled, control will be re-enabled after returning to the player if no target is found!"
	};
}, [_droneObject, _actionId]];

_mapEHID = addMissionEventHandler ["Map", 
{
	params ["_mapIsOpened", "_mapIsForced"];
	if (_mapIsOpened == false) then 
	{
		removeMissionEventHandler ["MapSingleClick" ,(_thisArgs select 0)];
		removeMissionEventHandler ["Map" ,_thisEventHandler];		
	};
}, [_clickEHID, _droneObject]];


///////////////////////////////////////////////////////////////
////////////////		Main Script		///////////////////////
///////////////////////////////////////////////////////////////
if ((!(missionNamespace isNil "EXP_Automation")) && (!(missionNamespace getVariable "EXP_Automation"))) exitWith {hint "Drone automatic targeting mode is disabled"};
createDialog "target_Override";
waitUntil {!isNull (findDisplay 1116)};
(findDisplay 1116) setVariable ["ExP_droneOBJ", _droneObject];
(findDisplay 1116 displayCtrl 1101) lbSetCurSel 3;


//'Esc' / 'Escape' key handler
(findDisplay 1116) displayAddEventHandler ["KeyDown",
{
	params ["", "_key"];
	if ((_this select 1) == 1) then 
	{
		closeDialog 0;
	};
}];

// Cancel button
((findDisplay 1116) displayCtrl 1102) ctrlAddEventHandler ["ButtonClick", 
{
	params ["_control"];
	closeDialog 0;
}];	


// Confirm button, might need to add a check for when a drone is destroyed during munition GUI 
((findDisplay 1116) displayCtrl 1101) ctrlAddEventHandler ["ButtonClick", 
	{
		params ["_control"];
		_droneObject = ((findDisplay 1116) getVariable "ExP_droneOBJ");
		if ((lbCurSel ((findDisplay 1116) displayCtrl 1100)) != -1) then 
		{
			_cursorSel = lbCurSel (findDisplay 1116 displayCtrl 1100);
			_selection = ((findDisplay 1116 displayCtrl 1100) lbValue _cursorSel);
			_droneObject setVariable ["EXP_targetType", _selection];
			openMap [true, false];
			hint "Select the search area (250m radius)";
			closeDialog 1;
		}
		else 
		{
			hint "No target type selected (default = Tanks / IFVs)";
		};
	}];

waitUntil {sleep 0.5; isNull (findDisplay 1116)};	
findDisplay 1116 displayCtrl 1101 ctrlRemoveAllEventHandlers "ButtonClick";
findDisplay 1116 displayCtrl 1102 ctrlRemoveAllEventHandlers "ButtonClick";
findDisplay 1116 displayRemoveAllEventHandlers "KeyDown";


//////////////////////////////////////////////////////////////////////////////////////////////
///////////////////USEFUL MARKER FOR DEBUGGING TARGET POSITION:///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/*

addMissionEventHandler ["Draw3D", {
	drawIcon3D [
	"\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", 
	[1,0,0,1],
	[
	(((getPosATLVisual (cursorObject))select 0) + (-(cos (((getDir (cursorObject)) +90))) * ((getCenterOfMass cursorObject) select 1))),
	(((getPosATLVisual (cursorObject))select 1) + ((sin (((getDir (cursorObject)) +90))) * ((getCenterOfMass cursorObject) select 1))),
	(((getPosATLVisual ((cursorObject))select 2)) + (-((getCenterOfMass cursorObject) select 2)))
	],
	1,
	1, 
	45, 
	"Target0", 
	1, 
	0.05, 
	"TahomaB"
	];
}];

 */