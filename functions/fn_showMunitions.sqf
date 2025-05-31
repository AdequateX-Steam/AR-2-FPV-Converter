#include "\a3\ui_f\hpp\definedikcodes.inc"
disableSerialization;
params [["_droneObject", nil, [objNull]]];

																//XXXXXXXXX Initialize the screen + get player inventory XXXXXXXXXXX		
// performance new code:0.63-0.64ms, old code:0.8051-0.81
createDialog "munition_Selector";
waitUntil {!isNull (findDisplay 1115)};
(findDisplay 1115) setVariable ["ExP_droneOBJ", _droneObject];
_ctrl = (findDisplay 1115) displayCtrl 1500; // listbox
_ctrlCB = (findDisplay 1115) displayCtrl 2800; // checkbox
lbClear _ctrl;
_ctrl lbSetCurSel -1; //sets cursor to unselected row
_allowedMunitionsList = [];
_index = 0;
_initDisplayList = 
[
	["CA_LauncherMagazine", configFile >> "CfgMagazines"],  
	["ATMine_Range_Mag", configFile >> "CfgMagazines"],  
	["SatchelCharge_Remote_Mag", configFile >> "CfgMagazines"],  
	["ClaymoreDirectionalMine_Remote_Mag", configFile >> "CfgMagazines"],  
	["rhssaf_tm100_mag", configFile >> "CfgMagazines"],
	["rhs_rpg26_mag", configFile >> "CfgMagazines"],
	["rhs_rpg75_mag", configFile >> "CfgMagazines"]
]; //list to initialize the display with and as contact detonation mode

_dropModeDislayList = 
[
	["HandGrenade", configFile >> "CfgMagazines"],
	["1Rnd_HE_Grenade_shell", configFile >> "CfgMagazines"], 
	["ATMine_Range_Mag", configFile >> "CfgMagazines"],  
	["SatchelCharge_Remote_Mag", configFile >> "CfgMagazines"],  
	["ClaymoreDirectionalMine_Remote_Mag", configFile >> "CfgMagazines"],  
	["rhssaf_tm100_mag", configFile >> "CfgMagazines"]
]; //explosives to choose from for dropped mode

_CfgList = 
[
	["HandGrenade", configFile >> "CfgMagazines"],
	["1Rnd_HE_Grenade_shell", configFile >> "CfgMagazines"],    
	["CA_LauncherMagazine", configFile >> "CfgMagazines"],  
	["ATMine_Range_Mag", configFile >> "CfgMagazines"],  
	["SatchelCharge_Remote_Mag", configFile >> "CfgMagazines"],  
	["ClaymoreDirectionalMine_Remote_Mag", configFile >> "CfgMagazines"],
	["MiniGrenade", configFile >> "CfgMagazines"],	
	["rhssaf_tm100_mag", configFile >> "CfgMagazines"],
	["rhs_rpg26_mag", configFile >> "CfgMagazines"],
	["rhs_rpg75_mag", configFile >> "CfgMagazines"]
];  //all parent-class types of common explosives
 _munitionsIndex = 0;
{ //issue here with zero diviser?
	_curMag = _x; 
	
	{ 	
		if (_curMag isKindOf _x) exitwith {
			
			if ((([getText(configFile >> "CfgMagazines" >>  _curMag >> "ammo")] call Exp_fnc_blackList) select 1) == False) then 
			{
				
				_allowedMunitionsList append [_curMag];
				{
					if (_curMag isKindOf _x) exitWith
					{
						_ctrl lbAdd (getText(configFile >> "CfgMagazines" >> _curMag >> "displayName"));
						_ctrl lbSetValue [_index, _munitionsIndex];
						_ctrl lbSetPicture [_index, getText(configFile >> "CfgMagazines" >> _curMag >> "picture")];
						_index = _index + 1;
					};
				} foreach _initDisplayList;
				_munitionsIndex = _munitionsIndex + 1;
				
			};	
		};
	} foreach _CfgList; 
} foreach Magazines player;
findDisplay 1115 setVariable ["ExP_munitionsList", _allowedMunitionsList]; // a list of all allowed explosives in player's inventory
findDisplay 1115 setVariable ["ExP_defaultModeList", _initDisplayList]; // a list of contact mode explosives
findDisplay 1115 setVariable ["ExP_dropModeList", _dropModeDislayList]; // a list of drop mode explosives


														//XXXXXXXXXX EVENT HANDLERS XXXXXXXXXX
//'Esc' / 'Escape' key handler
(findDisplay 1115) displayAddEventHandler ["KeyDown",
{
	params ["", "_key"];
	if ((_this select 1) == 1) then 
	{
		_droneObjectX = (findDisplay 1115 getVariable "ExP_droneOBJ");
		[_droneObjectX] spawn Exp_fnc_rearmDrone;
		closeDialog 0;
	};
}];
// Listbox selection change 
findDisplay 1115 displayCtrl 1500 ctrlAddEventHandler ["LBSelChanged", 
	{
		params ["_control", "_lbCurSel", "_lbSelection"];
		_progressBar = (findDisplay 1115 displayCtrl 3000);
		_munitionsList = (findDisplay 1115 getVariable "ExP_munitionsList");		
		_cursorSel = lbCurSel (findDisplay 1115 displayCtrl 1500);
		_selection = (_munitionsList select ((findDisplay 1115 displayCtrl 1500) lbValue _cursorSel));
		_picPath = getText(configFile >> "CfgMagazines" >>  _selection >> "picture");		
		ctrlSetText [1201, _picPath];
		_selMass = getNumber(configFile >> "CfgMagazines" >>  _selection >> "mass");
		_blacklistArray = [_selection] call Exp_fnc_blackList;
		_maxMass = _blacklistArray select 0;
		_validSelection = _blacklistArray select 1;
		if (_selMass > (_maxMass / 0.66)) then {_selMass = (_maxMass / 0.66)};
		_progressBar progressSetPosition ((_selMass/_maxMass) * 0.66);
		if ((progressPosition _progressBar) > 0.66) then 
		{
			_progressBar ctrlSetTextColor [0.80, 0, 0, 1];
		}
		else 
		{
			_progressBar ctrlSetTextColor [0.4,0.61,0.65,1];
		};
	}];


																		
// CheckBox
_ctrlCB ctrlAddEventHandler ["CheckedChanged",
	{
		params ["_control", "_checked"]; 			
		if ((_this select 1) == 1) then  //Dropped explosives //something is wrong in here for displaying proper picture
		{		 
			_ctrl = ((findDisplay 1115) displayCtrl 1500);
			lbClear _ctrl;
			_ctrl lbSetCurSel -1;
			_index = 0;		
			{
				_curMag = _x;
				_munitionsIndex = _forEachIndex;
				{
					if (_curMag isKindOf _x) exitwith 
					{
						_ctrl lbAdd (getText(configFile >> "CfgMagazines" >> _curMag >> "displayName"));
						_ctrl lbSetValue [_index, _munitionsIndex]; //2ND = _forEachIndex
						_ctrl lbSetPicture [_index, getText(configFile >> "CfgMagazines" >> _curMag >> "picture")];
						_index = _index + 1;
					};
				} foreach (findDisplay 1115 getVariable "ExP_dropModeList");
			} forEach (findDisplay 1115 getVariable "ExP_munitionsList"); 
		}
		else //Manual detonation
		{ 
			_ctrl = (findDisplay 1115) displayCtrl 1500;
			lbClear _ctrl;
			_ctrl lbSetCurSel -1;
			_index = 0;
			{
				_curMag = _x;
				_munitionsIndex = _forEachIndex;
				{
					if (_curMag isKindOf _x) exitwith 
					{
						_ctrl lbAdd (getText(configFile >> "CfgMagazines" >> _curMag >> "displayName"));
						_ctrl lbSetValue [_index, _munitionsIndex];  //2ND = _forEachIndex
						_ctrl lbSetPicture [_index, getText(configFile >> "CfgMagazines" >> _curMag >> "picture")];
						_index = _index + 1;
					};
				} foreach (findDisplay 1115 getVariable "ExP_defaultModeList");
			} forEach (findDisplay 1115 getVariable "ExP_munitionsList"); 
		};
	}];
			
// Confirm button, might need to add a check for when a drone is destroyed during munition GUI 
findDisplay 1115 displayCtrl 1600 ctrlAddEventHandler ["ButtonClick", 
	{
		params ["_control"];	
		if ((lbCurSel (findDisplay 1115 displayCtrl 1500)) != -1) then 
		{
			_cursorSel = lbCurSel (findDisplay 1115 displayCtrl 1500);
			_munitionsList = (findDisplay 1115 getVariable "ExP_munitionsList");
			_selection = (_munitionsList select ((findDisplay 1115 displayCtrl 1500) lbValue _cursorSel));
			_dropCheck = (cbChecked (findDisplay 1115 displayCtrl 2800));
			_filteredWHead = [_selection, "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ_0123456789"] call BIS_fnc_filterString; //removes any unwanted characters
			if ((progressPosition (findDisplay 1115 displayCtrl 3000)) > 0.66) then 
			{
				hint format["%1 is too heavy for the drone to fly!", getText(configFile >> "CfgMagazines" >> _selection >> "displayName")];
			}
			else
			{
				_Ammo = getText(configFile >> "CfgMagazines" >>  _filteredWHead >> "ammo");
				_droneX = (findDisplay 1115 getVariable "ExP_droneOBJ");
				[_Ammo, _droneX, _dropCheck] call Exp_fnc_finalStage;
				_magazineType = [_filteredWHead, aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ_0123456789 ] call BIS_fnc_filterString; //might be un-needed				
				_droneX setVariable ["ExpMagazine", _magazineType];
				if (_magazineType isKindOf ["1Rnd_HE_Grenade_shell", configFile >> "CfgMagazines"]) then {hint "Underbarrel grenades must be used above 20 Meters!! (arming distance)"};
				player removeMagazine _filteredWHead;
				player connectTerminalToUAV _droneX;
				closeDialog 1;
			};
		}
		else 
		{
			hint "Invalid selection! -> Click on an appropriate explosive";
		};
	}];
		
// Cancel button
findDisplay 1115 displayCtrl 1601 ctrlAddEventHandler ["ButtonClick", 
	{
		params ["_control"];
		_droneObjectX = (findDisplay 1115 getVariable "ExP_droneOBJ");
		[_droneObjectX] spawn Exp_fnc_rearmDrone;
		closeDialog 0;
	}];	

waitUntil {sleep 1.5; isnull findDisplay 1115};
findDisplay 1115 displayRemoveAllEventHandlers "KeyDown";
findDisplay 1115 displayCtrl 1600 ctrlRemoveAllEventHandlers "ButtonClick";
findDisplay 1115 displayCtrl 2800 ctrlRemoveAllEventHandlers "CheckedChanged";
findDisplay 1115 displayCtrl 1500 ctrlRemoveAllEventHandlers "LBSelChanged";
true;
