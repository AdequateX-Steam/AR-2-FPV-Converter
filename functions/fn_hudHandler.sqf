//player setVariable ["UiEnabled", False]; //needs to be set in player init


if (cameraon == player) exitWith  //exception handler for CBA setting change
{
	{ppEffectDestroy _x} foreach (player getVariable "effectsArray"); //effectsArray ppeffectenable enable (alternative)
	{_x cutText ["", "PLAIN"]} foreach (player getVariable "RscLayerArray");
	player setVariable ["UiEnabled", False];
};


if ((missionNamespace isnil "EXP_Hud")) then {	
	if (((player getVariable "UiEnabled") == False)) then 
	{
		player setVariable ["UiEnabled", true];	
		//_layer1 = ["RscInterlacing"] call BIS_fnc_rscLayer; //0.13ms 	//|
		_layer2 = ["RscFpv_HUD"] call BIS_fnc_rscLayer;					//|
		//_layer3 = ["RscCBRN_APR"] call BIS_fnc_rscLayer; // 0.13 ms     //| 0.32Ms total		
		//_layer1 cutRsc ["RscInterlacing", "plain", 0, false, true];		//|
		_layer2 cutRsc ["RscFpv_HUD", "plain", 0, false, true];			//|
		//_layer3 cutRsc ["RscCBRN_APR", "plain", 0, false, true];		//|
		_grainEffect = ppEffectCreate ["FilmGrain", 2000]; 
		_grainEffect ppEffectAdjust[ 
		0.215,  //intensity
		0.45, 	//sharpness
		2.25, 	//grain size
		0.425, 	//intensity X0
		0.425, 	//intensity x1
		0 		//monochromatic noise color (0 = b/w, 1 = color)
		]; 
		_grainEffect ppEffectEnable true;
		_grainEffect ppEffectCommit 1;

		_resEffect = ppEffectCreate ["Resolution", 0]; 
		_resEffect ppEffectEnable true;
		_resEffect ppEffectAdjust [720];
		_resEffect ppEffectCommit 1;

	/* 				_dynEffect = ppEffectCreate ["DynamicBlur", 500];  
		_dynEffect ppEffectEnable true; 
		_dynEffect ppEffectAdjust [0.15]; 
		_dynEffect ppEffectCommit 1; */
		player setVariable ["effectsArray",[_grainEffect, _resEffect]]; //_dynEffect
		player setVariable ["RscLayerArray", [ _layer2]]; //_layer1, _layer3
	}
	else
	{
		{ppEffectDestroy _x} foreach (player getVariable "effectsArray"); //effectsArray ppeffectenable enable (alternative)
		{_x cutText ["", "PLAIN"]} foreach (player getVariable "RscLayerArray");
		player setVariable ["UiEnabled", False];
	};

}
else 
{
	if (((missionNamespace getVariable "EXP_Hud") == true) && ((player getVariable "UiEnabled") == False)) then 
	{
		player setVariable ["UiEnabled", true];	
		//_layer1 = ["RscInterlacing"] call BIS_fnc_rscLayer; //0.13ms 	//|
		_layer2 = ["RscFpv_HUD"] call BIS_fnc_rscLayer;					//|
		//_layer3 = ["RscCBRN_APR"] call BIS_fnc_rscLayer; // 0.13 ms     //| 0.32Ms total		
		//_layer1 cutRsc ["RscInterlacing", "plain", 0, false, true];		//|
		_layer2 cutRsc ["RscFpv_HUD", "plain", 0, false, true];			//|
		//_layer3 cutRsc ["RscCBRN_APR", "plain", 0, false, true];		//|
		_grainEffect = ppEffectCreate ["FilmGrain", 2000]; 
		_grainEffect ppEffectAdjust[ 
		0.215,  //intensity
		0.45, 	//sharpness
		2.25, 	//grain size
		0.425, 	//intensity X0
		0.425, 	//intensity x1
		0 		//monochromatic noise color (0 = b/w, 1 = color)
		]; 
		_grainEffect ppEffectEnable true;
		_grainEffect ppEffectCommit 1;

		_resEffect = ppEffectCreate ["Resolution", 0]; 
		_resEffect ppEffectEnable true;
		_resEffect ppEffectAdjust [720];
		_resEffect ppEffectCommit 1;

	/* 				_dynEffect = ppEffectCreate ["DynamicBlur", 500];  
		_dynEffect ppEffectEnable true; 
		_dynEffect ppEffectAdjust [0.15]; 
		_dynEffect ppEffectCommit 1; */
		player setVariable ["effectsArray",[_grainEffect, _resEffect]]; //_dynEffect
		player setVariable ["RscLayerArray", [ _layer2]]; //_layer1, _layer3
	}
	else 
	{
		{ppEffectDestroy _x} foreach (player getVariable "effectsArray"); //effectsArray ppeffectenable enable (alternative)
		{_x cutText ["", "PLAIN"]} foreach (player getVariable "RscLayerArray");
		player setVariable ["UiEnabled", False];
	};

};