params 
[
	["_warheadType","",[""]]
];

Exp_fnc_modAttach =
{
	params 
	[
		["_Ammo","",[""]]
	];
	_returnPOS = [0,0.17,-0.185];
 	if (_Ammo isKindOf "MineBase") then {_returnPOS = [0,.25,.135]};
	if (_Ammo isKindOf "PipeBombBase") then {_returnPOS = [0.0175,0.025,0.13]};
	if (_Ammo isKindOf "APERSMine_Range_Ammo") then {_returnPOS = [0,.3,.06]};
	if (_Ammo isKindOf "APERSBoundingMine_Range_Ammo") then {_returnPOS = [0,.3,.1]};
	if (_Ammo isKindOf "DirectionalBombBase") then {_returnPOS = [0.0,0.375,0.0]};
	_returnPOS;
};
_posArray = [0,0,0];
switch (_warheadType) do 
{
	case "fpvAmmo":{_posArray = [0,0,-0.1175]};
	case "fpvGrenade":{_posArray = [0,.325,0.07]};
	case "R_MRAAWS_HEAT_F":{_posArray = [0,.05,-0.11]};
	case "R_MRAAWS_HE_F":{_posArray = [0,.175,-0.13]};
	case "R_MRAAWS_HEAT55_F":{_posArray = [0,.15,-0.13]};
	case "M_NLAW_AT_F":{_posArray = [0,.075,-0.155]};
	case "R_PG32V_F":{_posArray = [0,-.075,-0.155]};
	case "R_TBG32V_F":{_posArray = [0,.1,-0.155]};
	case "R_PG7_F":{_posArray = [0,-.065,-0.13]};
	case "M_Vorona_HEAT":{_posArray = [0,-.5,-0.17]};
	case "M_Vorona_HE":{_posArray = [0,-.5,-0.17]};
	case "SatchelCharge_Remote_Ammo":{_posArray = [0.0175,0.025,0.13]};
	case "ClaymoreDirectionalMine_Remote_Ammo":{_posArray = [0.0,0.375,0.0]};
	case "SLAMDirectionalMine_Wire_Ammo":{_posArray = [0.0,0.36,0.05]};
	case "DemoCharge_Remote_Ammo":{_posArray = [0.0175,0.025,0.13]};
	case "APERSMineDispenser_Ammo":{_posArray = [0,-.3,0]};
	case "APERSMine_Range_Ammo":{_posArray = [0,.3,.06]};
	case "APERSBoundingMine_Range_Ammo":{_posArray = [0,.3,.1]};
	case "IEDUrbanBig_Remote_Ammo": {_posArray = [0,0,-0.1175]};
	case "IEDLandBig_Remote_Ammo": {_posArray = [0,0,-0.1175]};
	case "IEDUrbanSmall_Remote_Ammo": {_posArray = [0,0,-0.1175]};
	case "IEDLandSmall_Remote_Ammo": {_posArray = [0,0,-0.1175]};
	case "APERSTripMine_Wire_Ammo":{_posArray = []};
	case "ATMine_Range_Ammo":{_posArray = [0,.25,.135]};
	case "M_Titan_AA":{_posArray = [0,-.6,-0.17]};
	case "M_Titan_AP":{_posArray = [0,-.3,-0.17]};
	case "M_Titan_AT":{_posArray = [0,-.35,-0.17]};
};
if (_posArray isEqualto [0,0,0]) then {_posArray = [_warheadType] call Exp_fnc_modAttach;};
 _posArray;
 
 
// debug console for test ammo positions
// {detach _x; triggerAmmo _x}foreach attachedObjects cursorObject;_ammo = "M_Titan_AT" createvehicle getposATL cursorObject; _ammo attachto [cursorObject, [0,-.35,-0.17]];
//{_x getvariable "altWarhead"}foreach attachedobjects cursorObject
//_droppable = createVehicle ["rhsusf_40mm_HEDP",cursorObject, [], 0, "CAN_COLLIDE"]; _droppable setVelocity [0, 0, -8.829];   rhsusf_m1165a1_gmv_mk19_m240_socom_d