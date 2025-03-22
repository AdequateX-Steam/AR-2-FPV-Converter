if ((activatedAddons find "cba_common") != -1) then 
{
	[
		"EXP_Hud", 
		"CHECKBOX", 
		["Hud Toggle ", "On (checked) / Off (unchecked)"], 
		"FPV Drone Settings", 
		true,
		nil,
		{
			params ["_value"];
			missionNamespace setVariable ["EXP_HudEnabled", _value];
			[] spawn Exp_fnc_hudHandler;
		}
	] call CBA_fnc_addSetting;


/* 	
[
		"EXP_Mass", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
		"SLIDER", // setting type
		"Max warhead weight", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
		"FPV Drone Settings", // Pretty name of the category where the setting can be found. Can be stringtable entry.
		[20, 300, 300, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
		nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
		{  
			params ["_value"];
			player setVariable ["EXP_maxMass", _value];
		} // function that will be executed once on mission start and every time the setting is changed.
	] call CBA_fnc_addSetting;
*/
}; 
