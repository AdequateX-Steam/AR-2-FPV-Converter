if ((player getVariable "UiEnabled") == True) then 
{
	{ppEffectDestroy _x} foreach (player getVariable "effectsArray");
	{_x cutText ["", "PLAIN"]} foreach (player getVariable "RscLayerArray");
	player setVariable ["UiEnabled", False];
};