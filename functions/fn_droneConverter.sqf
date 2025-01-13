_droneClass = _this select 0;
_droneObject = _this select 1;
private _droneArray =[_droneObject, _droneClass];
_state = (Player getVariable "ExpState");


_droneObject addEventHandler ["Disassembled" ,{
	params ["_entity", "_primaryBag", "_secondaryBag", "_unit"];
	Player setVariable ["ExpState", false];
}];
	
_droneObject addAction ["<t color='#FFF444'>Convert to FPV drone</t>",  
	{ 
		params ["_target", "_caller", "_actionId", "_droneArray"];
		_target removeAction _actionId;	
		(_this select 3 select 0) removeWeaponTurret ["Laserdesignator_mounted", [0]];	
		(_this select 3 select 0) addWeaponTurret ["fpvRocket", [-1]];
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		sleep 13;  //waits until anim complete
		_replacementPOS = getPosATL (_droneArray select 0);
		_replacementVectorDir = vectorDir (_droneArray select 0);
		deleteVehicle (_droneArray select 0);
		_newFPV = createVehicle [(((_droneArray select 1) select [0,1]) + "_FPV_AR2"), [(_replacementPOS select 0),(_replacementPOS select 1),0], [], 0, "CAN_COLLIDE"];
		_newFPV setVectorDir _replacementVectorDir;
		player connectTerminalToUAV _newFPV;
		waitUntil {!isNil{_newFPV getVariable "ExpInitAction"}}; // waits until drone registers its default init action that is created upon spawn, so that the duplicate action can be removed
		_actionInit = _newFPV getVariable "ExpInitAction";
		_newFPV removeAction _actionInit;	
		[_newFPV] call Exp_fnc_showMunitions;	//might need to change to spawn, as it wont return a value after being changed.
	}, _droneArray, 1.5, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == _this))", 2, false, "",""]; //lazy evaluation if (a && { b && { c } }) then {};  // && (((UAVControl _target) select 1) != ""DRIVER"")