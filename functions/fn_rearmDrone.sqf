//_droneObject = (_this select 0);
(_this select 0) addAction ["<t color='#1c3f45'>Arm Drone</t>",  
    { 
		params ["_target", "_caller", "_actionId"]; 
		_target removeAction _actionId;   
		[_target] call Exp_fnc_showMunitions;      
    }, nil, 6, true, true, "", "(((damage _target) != 1) && ((side _target) == (side player)) && (cameraOn == player))", 2, false, "",""];
