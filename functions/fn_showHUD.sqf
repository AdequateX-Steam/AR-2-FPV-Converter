params [["_droneObject", nil, [objNull]]];
player setVariable ["UiEnabled", False];
//useful commands cameraOn, cameraView, focusOn, uavcontrol (select 0,1), getConnectedUAV...
while {sleep 0.80; alive player} do  
{
	while {sleep 0.125; (((getConnectedUAV player) isKindOf "fpv_Base_F") && alive player)} do 
	{
		if ((((UAVControl (getConnectedUAV player)) select 1) == "DRIVER")) then 
		{
			if ((player getVariable "UiEnabled") == False) then
			{
				player setVariable ["UiEnabled", true];	
				_layer1 = ["RscInterlacing"] call BIS_fnc_rscLayer;
				_layer2 = ["RscFpv_HUD"] call BIS_fnc_rscLayer;
				_layer3 = ["RscCBRN_APR"] call BIS_fnc_rscLayer;
				_layer1 cutRsc ["RscInterlacing", "plain", 0, false, true];
				_layer2 cutRsc ["RscFpv_HUD", "plain", 0, false, true];
				_layer3 cutRsc ["RscCBRN_APR", "plain", 0, false, true];
				_grainEffect = ppEffectCreate ["FilmGrain", 2000]; 
				_grainEffect ppEffectAdjust[ 
				0.215,  //intensity
				0.45, 	//sharpness
				2.25, 	//grain size
				0.425, 	//intensity X0
				0.425, 	//intensity x1
				1 		//monochromatic noise color (0 = b/w, 1 = color)
				]; 
				_grainEffect ppEffectEnable true;
				_grainEffect ppEffectCommit 1;

				_resEffect = ppEffectCreate ["Resolution", 0]; 
				_resEffect ppEffectEnable true;
				_resEffect ppEffectAdjust [720];
				_resEffect ppEffectCommit 1;

				_dynEffect = ppEffectCreate ["DynamicBlur", 500];  
				_dynEffect ppEffectEnable true; 
				_dynEffect ppEffectAdjust [0.15]; 
				_dynEffect ppEffectCommit 1;
				player setVariable ["effectsArray",[_grainEffect, _resEffect, _dynEffect]];
				player setVariable ["RscLayerArray", [_layer1, _layer2, _layer3]];

			}
			else
			{
				sleep 0.10; //extra sleep timer for performance if the UI is already activated.
			};
		} 
		else 
		{
				isNil {[] spawn Exp_fnc_removeHud};
		};
		
	};
	if (((getConnectedUAV player) == objNull) || ((cameraon iskindof "fpv_Base_F") == false)) then {isNil {[] spawn Exp_fnc_removeHud}};
};