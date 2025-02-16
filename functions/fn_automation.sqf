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
	_hostileRandomDistance = random [40,85,120]; // random distance (higher distances give AI a better chance to shoot down the drone)
	_droneObject setCaptive true; //tricks enemies until it gets closer to the waypoint or else it usually get shot down
	_droneObject lockDriver true;
	_droneObject enableUAVWaypoints false; //try to disable player interference
	_droneMarker1 = createMarker [((str _droneObject) + "DroneSearchArea"), _pos, 1, player];
	_droneMarker1 setMarkerShape "ELLIPSE";
	_droneMarker1 setMarkerSize [200,200];
	_droneMarker1 setMarkerBrush "DiagGrid";
	_droneMarker1 setMarkerColor "ColorRed";
	_droneMarker2 = createMarker [((str _droneObject) + "DroneSearchMarker"), _pos, 1, player];
	_droneMarker2 setMarkerType "mil_objective_noShadow";
	_droneMarker2 setMarkerText "Drone search area (200m radius)";
	_droneMarker2 setMarkerColor "ColorBlack";
	_droneMarker2 setMarkerAlpha 1;
	_waypoint = group(_droneObject) addWaypoint [[_pos select 0,_pos select 1, 35], 1, 1];
	_droneObject flyInHeight 35;
	group(_droneObject) setCombatMode "BLUE";
	group(_droneObject) setCombatBehaviour "CARELESS";
	_waypoint setWaypointBehaviour "CARELESS";
	_waypoint setWaypointCompletionRadius 29;
	_waypoint setWaypointSpeed "FULL";
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointForceBehaviour true;
	waitUntil{sleep 1.5; (((_droneObject distance2D _pos) <= _hostileRandomDistance) || !alive _droneObject)}; //low frequency check, for when a drone is far from its target
	_droneObject setCaptive false; //returns to normal status as a hostile drone to the enemy targets
	waitUntil{sleep 0.4; (((_droneObject distance2D _pos) <= 30) || !alive _droneObject)}; //higher frequency check
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
	_playerside = side player;
	_newList = [];
	//_preferredTargetType = 3; //0-3, not 4- "Air" //userdefineable in game
	_preferredTargetType = (_droneObject getVariable "EXP_targetType"); //0-3, not 4- "Air" //userdefineable in game
	_targetClass = ["Man","CAR","Wheeled_APC_F","Tank"];
	_targetPriorityIndex = []; //highest to lowest priority(userpriority first, greatest to least 3 -> 0)
	_targetCount = 0; //number of unit types found in total targetList sorted by targetPriorityIndex order
	_targetCountIndex = 0; //which unit type was found first based on priority
	_minDistanceIndex = 0; //index of the unit from newlist with the highest priority and closest distance
	_foundTarget = 0; //type 'object'; inialized as 0
	_radius = 200 + 20; //radius of the searchzone + drone waypoint completion distance
	
// Get player's enemies
	if ((side _droneObject getFriend west) < 0.6) then {_enemyList append (units west);};
	if ((side _droneObject getFriend east) < 0.6) then {_enemyList append (units east);};
	if ((side _droneObject getFriend independent) < 0.6) then {_enemyList append (units independent);};

//Get enemies within range and reveal them for nearTargets
	{
		if ((_droneObject distance2D (getPosATL _x)) <= _radius) then //probably change _droneObject to marker pos
		{
			_droneObject reveal _x;
			_droneObject reveal (vehicle _x);
		};
	} foreach (_enemyList);

	//get full list of enemy units 'objects' here
	_targetList = _droneObject nearTargets _radius; //[position (imprecise), targetType, side, subjectivecost, 'object', positionAccuracy] //performance hit 0.02ms
	
//Discard friendly units and air targets here...WORKING
	{
		private _objType = (_x select 4);		
		if ((_x select 2) == (side _droneObject)) then {_targetList deleteat _forEachIndex;};
		if ((_objType isKindOf "Air")) then {_targetList deleteAt _x;};	
	} foreach _targetList;
	
//Sets target priority weighting...	WORKING	
	_targetPriorityIndex set [0, _preferredTargetType];  //[1,3,2,0], [2,3,1,0], [0,3,2,1]
	for "_i" from 3 to 0 step -1 do 
	{	
		//private _index = 3 - _i; //does nothing
		if (_i != _preferredTargetType) then {_targetPriorityIndex pushBack _i;};
		//_index = _index + 1; //does nothing
	};
	
//Sort preferred target first, and then weighted targets next  [car,car,car,TANK,APC,APC,man,man,man,man]... WORKING
	{
		private _xCurTargetIndex = _x; 
		{
			private _objType = (_x select 4);
			if (_objType isKindOf (_targetClass select _xCurTargetIndex)) then 
			{
				//_newList append [_x];
				if ((_xCurTargetIndex == 1) && (_objType isKindOf "Wheeled_APC_F")) exitWith {}; //if car/truck/mrap is selected with higher priority, dont include APCs that are also considered 'cars'
				_newList pushBack _x;
			};
			
		} foreach _targetList;
	} foreach _targetPriorityIndex;
		

//Find highest preferred targets if they exist and sort by distance (2nd half); else return to player. ... WORKING
	{	
		private _xForeach = _x;
		_targetCount = ({(_x select 4) isKindOf (_targetClass select _xForeach)} count _targetList);
		if (_targetCount >= 1) exitWith {_targetCountIndex = _forEachIndex;};	
	} foreach _targetPriorityIndex;
	
	if (_targetCount >= 1) then 
	{
		_minDistance = ((getPosATL _droneObject) distance2D (getPosATL ((_newList select 0) select 4))); 

		for "_i" from 1 to (_targetCount - 1) step 1 do 
		{
			if (_minDistance > ((getPosATL _droneObject) distance2D (getPosATL ((_newList select _i) select 4)))) then 
			{
				_minDistance = ((getPosATL _droneObject) distance2D (getPosATL ((_newList select _i) select 4)));
				_minDistanceIndex = _i;		
			};	
		};
		//hint str [_droneObject, typeOf ((_newList select _minDistanceIndex) select 4)];
		
		
		//Adjust flight height and return the found target...WORKING
		(_droneObject) flyInHeight [0.5, true];
		_foundTarget = ((_newList select _minDistanceIndex) select 4);
		_foundTarget; //RETURN VARIABLE 
	} 
	else //no found target
	{
		_foundTarget = 0;
		_foundTarget;
	};
};

//Seeker Function to track and intercept target .... WORKING
Exp_fnc_targetSeek = 
{
	//INPUTS [_droneObject, _enemyTarget]
	//_droneObject = player controlled friendly drone
	//_enemyTarget = highest value target that is the closest
	_droneObject = _this select 0;
	_enemyTarget = _this select 1;
	_interceptDistance = 0.125; //Distance before intercept is considered complete
	_interceptVelocityXYZ = [42, 42, 30]; //Top speed to accelerate to (m/s)
	_targetCOM = getCenterOfMass _enemyTarget; //center of mass of target
	_startTime = diag_tickTime;	//start of eachframeEH to compare against for furture time
	
	
	_targetingUpdate = addMissionEventHandler ["EachFrame", 
	{
		//////_THISARGS REFERENCES//////
		//_droneObject = (_thisArgs select 0);
		//_enemyTarget = (_thisArgs select 1);
		//_interceptDistance = (_thisArgs select 2);
		//_interceptVelocityXYZ = (_thisArgs select 3);
		//_targetCOM = (_thisArgs select 4);
		//_startTime = (_thisArgs select 5);
		_dTime = (diag_deltaTime);
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

		If (!alive (_thisArgs select 1)) exitWith
		{	
			removeMissionEventHandler ["EachFrame", _thisEventHandler];
			_target = [(_thisArgs select 0), (getPosATL (_thisArgs select 0))] call Exp_fnc_targetSearch;
			[(_thisArgs select 0), _target] spawn Exp_fnc_targetSeek;		
		};
		
		///////////////////////////////////   TEST POS ICON3D   ///////////////////////////////////////////////
/* 		
		drawIcon3D [
		"\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", 
		[1,0,0,1],
		_targetPos,
		1,
		1, 
		45, 
		"Target", 
		1, 
		0.05, 
		"TahomaB"]; 
*/
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		if ((_distanceToTarget >= (_thisArgs select 2)) && (alive (_thisArgs select 0))) then
		{
			
			if ((diag_frameNo mod 4) == 0) then 
			{			
				
				_incVelocity = ([12.92, 12.92, 9.23] vectorMultiply (diag_tickTime - (_thisArgs select 5)));
				if ((_incVelocity select 0) > 42) then {_incVelocity = (_thisArgs select 3);};
				
				_vectorDirNorm = _dronePos vectorFromTo _futureTargetPos;
				(_thisArgs select 0) setVectorDir _vectorDirNorm;	
				(_thisArgs select 0) setVectorUp 
				[
				((-cos (getDir (_thisArgs select 0) +90))*0.715),  //need to get Z height normalized between drone and target as a ratio of 0-1 and add it to the pitch and bank (maybe not arma 3 vehicles dont like damage from RHS weapons...)
				((sin (getDir (_thisArgs select 0) + 90))* 0.715), //0.715 flattens the trajectory a bit, avoids steep angles (acceptable range from 0.5-0.825)
				1
				]; 
				(_thisArgs select 0) setvelocity (_incVelocity vectorMultiply _vectorDirNorm);
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
				removeMissionEventHandler ["EachFrame", _thisEventHandler];				
		};
		

	},[_droneObject, _enemyTarget, _interceptDistance, _interceptVelocityXYZ, _targetCOM, _startTime] ];
	waitUntil {sleep 2; (!alive _droneObject)};
	removeMissionEventHandler ["EachFrame", _targetingUpdate];
};

// This functions adds a waypoint to return the drone to the player and land 
Exp_fnc_returnToPlayer = 
{
//INPUTS [_droneObject]
// _droneObject = player controlled drone to be automated.
	_droneObject = (_this select 0);
	_pos = getPosATL player;
	hint "Drone is returning to current player's 'static' position (no target found)";
	_waypoint = group(_droneObject) addWaypoint [[(_pos select 0), (_pos select 1), 0], 1, -1];
	group(_droneObject) setCurrentWaypoint _waypoint;
	_droneObject flyInHeight 35;
	group(_droneObject) setCombatMode "BLUE";
	group(_droneObject) setCombatBehaviour "CARELESS";
	_waypoint setWaypointBehaviour "CARELESS";
	_waypoint setWaypointCompletionRadius 10;
	_waypoint setWaypointSpeed "FULL";
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointForceBehaviour true;
	waitUntil {sleep 1.5; ((_droneObject distance2D _pos ) <= 12)};
	_droneObject flyInHeight [0, true];
	waitUntil {sleep 1; ((getPosATL _droneObject) select 2) < 1};
	_droneObject lockDriver false;
	_droneObject engineOn false;
	_droneObject enableUAVWaypoints true;
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
	if ((_pos distance2D player) < 35) then 
	{
		hint format ["Minimum required distance from player: 35 meters; Current distance: %1 meters",(_pos distance2D player)];
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
			hint "Select the search area (200m radius)";
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



//openMap [true, false];
//hint "Select the search area (200m radius)";



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