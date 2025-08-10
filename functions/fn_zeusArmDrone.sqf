params [
	["_logic", objNull, [objNull]],		// module logic
	["_units", [], [[]]],				// list of affected units (affected by value selected in the 'class Units' argument))
	["_activated", true, [true]]		// True when activated, false when deactivated
];
//Display: 1700
//Control IDCs:
	//LISTBOX: 1500
	//COMBO : 1501
	//SLIDER: 1502
	//SLIDER TEXT: 1503
	//CONFIRM: 1600
	//CANCEL: 1601
	//PICTURE: 1201

//--- Terminate on client (unless it's curator who created the module)
if (!isserver && {local _x} count (objectcurators _logic) == 0) exitwith {}; 


//--- Wait for params to be set (zeus???)
/* if (_logic call bis_fnc_isCuratorEditable) then {
	waituntil {!isnil {_logic getvariable "vehicle"} || isnull _logic};
};
  */
 
/* if (isnull _logic) exitwith {};
if (!isserver) exitwith {}; */

 

// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then
{
	waitUntil {!isNull (findDisplay 1117)};
	//all parent-class types of common explosives
	_ctrlListBox = (findDisplay 1117) displayCtrl 1500; // listbox
	_ctrlCombo = (findDisplay 1117) displayCtrl 1501;
	_ctrlSlider = (findDisplay 1117) displayCtrl 1502;
	_ctrlSliderText = (findDisplay 1117) displayCtrl 1503;
	lbClear _ctrlListBox;
	_ctrlListBox lbSetCurSel -1; //sets cursor to unselected row
	_WarheadList = [];
	_DisplayList = [];
	_ClassTypes = 
	[
		"CA_LauncherMagazine", 
		"ATMine_Range_Mag",
		"SatchelCharge_Remote_Mag",
		"ClaymoreDirectionalMine_Remote_Mag",
		"rhssaf_tm100_mag",
		"rhs_rpg26_mag",
		"rhs_rpg75_mag"
	];
	_WarheadList = "901 in (getArray( _x >> 'allowedSlots'))" configClasses (configFile >> "CfgMagazines");
	_WarheadList = _WarheadList apply {configName _x;};
	_WarheadList deleteAt (_WarheadList find "CA_LauncherMagazine");
	
	{
		_currentMag = _x;
		_currentIndex = _forEachIndex;
		{
			if (_currentMag isKindOf [_x , configFile >> "CfgMagazines"]) then { _DisplayList pushBack _currentMag};
		} forEach _ClassTypes;	
	} forEach _WarheadList;
_DisplayList;
	
	{
			_ctrlListBox lbAdd (getText(configFile >> "CfgMagazines" >> _x >> "displayName"));
			_ctrlListBox lbSetData [_forEachIndex, (getText(configFile >> "CfgMagazines" >>  _x >> "ammo"))];
			_ctrlListBox lbSetPicture [_forEachIndex, (getText(configFile >> "CfgMagazines" >> _x >> "picture"))];
	} foreach _DisplayList;


	{
		_ctrlCombo lbAdd _x;
		_ctrlCombo lbSetColor [_forEachIndex, ([[1,0,0,1],[0,1,0,1],[0,0,1,1]] select _forEachIndex)];
		//_ctrlCombo lbSetColorRight [_forEachIndex, ([[1,0,0,1],[0,1,0,1],[0,0,1,1]] select _forEachIndex)];
		_ctrlCombo lbSetPicture [_forEachIndex, ["\A3\ui_f\data\map\markers\flags\CSAT_ca.paa", "\A3\ui_f\data\map\markers\flags\FIA_ca.paa", "\A3\ui_f\data\map\markers\flags\nato_ca.paa"] select _forEachIndex];
	} foreach ["CSAT", "INDEP", "NATO"];
	_ctrlSliderText ctrlSetText (format ["FPV Drones: %1", (sliderPosition _ctrlSlider)]);
	_ctrlCombo lbSetCurSel 0;


findDisplay 1117 setVariable ["ExP_DisplayList", _DisplayList];
findDisplay 1117 setVariable ["ExP_logic", _logic];






							//XXXXXXXXXX EVENT HANDLERS XXXXXXXXXX


	//'Esc' / 'Escape' key handler
	(findDisplay 1117) displayAddEventHandler ["KeyDown",
	{
		params ["", "_key"];
		if ((_this select 1) == 1) then 
		{
			_droneObjectX = (findDisplay 1117 getVariable "ExP_droneOBJ");
			_logicX = findDisplay 1117 getVariable "ExP_logic";
			deletevehicle _logicX;
			[_droneObjectX] spawn Exp_fnc_rearmDrone;
			closeDialog 0;
		};
	}];

	_ctrlListBox ctrlAddEventHandler ["LBSelChanged", 
		{
			params ["_control", "_lbCurSel", "_lbSelection"];
			_munitionsList = (findDisplay 1117 getVariable "ExP_DisplayList");		
			_cursorSel = lbCurSel (findDisplay 1117 displayCtrl 1500);
			_selection = (_munitionsList select _cursorSel);
			_picPath = getText(configFile >> "CfgMagazines" >>  _selection >> "picture");		
			ctrlSetText [1201, _picPath];
		}];

	_ctrlSlider ctrlAddEventHandler ["SliderPosChanged", 
		{
			((findDisplay 1117) displayCtrl 1503) ctrlSetText (format["FPV Drones: %1", (sliderPosition ((findDisplay 1117) displayCtrl 1502))]);	
		}];

// Confirm button, might need to add a check for when a drone is destroyed during munition GUI 
	findDisplay 1117 displayCtrl 1600 ctrlAddEventHandler ["ButtonClick", 
	{
		params ["_control"];	
		if ((lbCurSel (findDisplay 1117 displayCtrl 1500)) != -1) then 
		{
			_cursorSel = lbCurSel (findDisplay 1117 displayCtrl 1500);
			_Ammo = (findDisplay 1117 displayCtrl 1500) lbData _cursorSel;
			_logicX = findDisplay 1117 getVariable "ExP_logic";
			_droneCount = (sliderPosition ((findDisplay 1117) displayCtrl 1502));
			_droneSide = ["O", "I", "B"] select (lbCurSel ((findDisplay 1117) displayCtrl 1501));
			_magazine =  ((findDisplay 1117 getVariable "ExP_DisplayList") select _cursorSel);
			for "_i" from 0 to (_droneCount - 1) step 1 do 
			{
				_newFPV = createVehicle [(_droneSide + "_FPV_AR2"), (getPosATL _logicX), [], 0, "NONE"];
				_actionInit = _newFPV getVariable "ExpInitAction";
				_newFPV removeAction _actionInit;
				{_x addCuratorEditableObjects [[_newFPV], true]} forEach allCurators;
				[_Ammo, _newFPV, false] call Exp_fnc_finalStage;
				//_newFPV setVariable ["ExpMagazine", _magazine];

			};	
			
			(findDisplay 1117) closeDisplay 0;
			deletevehicle _logicX;
		};
	}];
		
// Cancel button
	findDisplay 1117 displayCtrl 1601 ctrlAddEventHandler ["ButtonClick", 
	{
		params ["_control"];
		_logicX = findDisplay 1117 getVariable "ExP_logic";
		deletevehicle _logicX;
		(findDisplay 1117) closeDisplay 0;

	}];	

};
//waitUntil {sleep 1;(isNull (findDisplay 1117))};


