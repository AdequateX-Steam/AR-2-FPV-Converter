_droneObject = _this select 0;


[
	_droneObject, 
	"<t color='#FFF444'>Convert to FPV drone</t>", 
	"\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa", //idleIcon
	"\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa", //progressIcon
	"(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == _this) && ((_this distance2D _target) <= 3))", //conditionShow
	"((damage _target) != 1)", //conditionProgress
	{	//codeStart
		params ["_target", "_caller", "_actionId", "_arguments"];
		_caller playMove "AinvPknlMstpSnonWnonDr_medic3";
	}, 	
	{	//codeProgress
		params ["_target", "_caller", "_actionId", "_arguments", "_frame", "_maxFrame"];
		if (_frame == 1) then {hint "Increasing drone speed"};
		if (_frame == 4) then {hint "Adjusting IR sensors"};
		if (_frame == 8) then {hint "Attaching carrying harness"};
		if (_frame == 12) then {hint "Adding contact fuse"};
		if (_frame == 16) then {hint "Wiring trigger to aux light"};
		if (_frame == 20) then {hint "Adding new coat of paint"};
		if (_frame == 24) then {hint "FPV Drone Complete, good hunting!"};
	}, 	
	{	//codeCompleted
		params ["_target", "_caller", "_actionId", "_arguments"];
		[_caller,"amovPknlMstpSrasWrflDnon"] remoteExec ["playMoveNow", 0];
		_replacementPOS = getPosATL _target;
		_replacementVectorDir = vectorDir _target;
		_replacementClass = [_target] call Exp_fnc_droneCfg;
		deleteVehicle _target;
		_newFPV = createVehicle [((_replacementClass select [0,1]) + "_FPV_AR2"), [(_replacementPOS select 0),(_replacementPOS select 1),((_replacementPOS select 2)+ 0.15)], [], 0, "CAN_COLLIDE"];
		_newFPV setVectorDir _replacementVectorDir;
		waitUntil {!isNil{_newFPV getVariable "ExpInitAction"}}; // waits until drone registers its default init action that is created upon spawn, so that the duplicate action can be removed
		_actionInit = _newFPV getVariable "ExpInitAction";
		_newFPV removeAction _actionInit;
		player connectTerminalToUAV _newFPV;
		[_newFPV] call Exp_fnc_showMunitions;	//might need to change to spawn, as it wont return a value after being changed.
	
	}, 		
	{	//codeInterrupted
		params ["_target", "_caller", "_actionId", "_arguments"];
		[_caller,"amovPknlMstpSrasWrflDnon"] remoteExec ["playMoveNow", 0];
		hint "Conversion interrupted!";
	}, 	 
	[], 	//arguments
	12, 
	6, 
	true, 
	false, 
	true
] call BIS_fnc_holdActionAdd;