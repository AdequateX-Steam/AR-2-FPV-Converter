/* params [
	["_logic", objNull, [objNull]],		// module logic
	["_units", [], [[]]],				// list of affected units (affected by value selected in the 'class Units' argument))
	["_activated", true, [true]]		// True when activated, false when deactivated
]; */
//disableSerialization
params [
	["_mode", "", [""]],
	["_input", [], [[]]]
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




//--- Wait for params to be set (zeus???)
/* if (_logic call bis_fnc_isCuratorEditable) then {
	waituntil {!isnil {_logic getvariable "vehicle"} || isnull _logic};
};
  */
 
/* if (isnull _logic) exitwith {};
if (!isserver) exitwith {}; */

switch _mode do
{
	case "init":
	{
		_input params [
			["_logic", objNull, [objNull]],		// Module logic
			["_isActivated", true, [true]],		// True when the module was activated, false when it is deactivated
			["_isCuratorPlaced", false, [true]]	// True if the module was placed by Zeus
		];
		
		//--- Terminate on client (unless it's curator who created the module)
		if (!isserver && {local _x} count (objectcurators _logic) == 0) exitwith {}; 
		
		
		//Zues or Curator activation
		if ((_isActivated && _isCuratorPlaced)) then
		{
			waitUntil {!isNull (findDisplay 1117)};
			private _ctrlListBox = (findDisplay 1117) displayCtrl 1500;
			private _ctrlCombo = (findDisplay 1117) displayCtrl 1501;
			private _ctrlSlider = (findDisplay 1117) displayCtrl 1502;
			private _ctrlSliderText = (findDisplay 1117) displayCtrl 1503;
			lbClear _ctrlListBox;
			_ctrlListBox lbSetCurSel -1; //sets cursor to unselected row
			private _WarheadList = [];
			private _DisplayList = [];
			private _ClassTypes = 
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
			//_ExperimentalList = "((getArray( _x >> 'hardpoints')) select 0) isEqualType ''" configClasses (configFile >> "CfgMagazines");   //vehicle based warheads
			//_ExperimentalList = _ExperimentalList apply {configName _x;};
			
			{
				_currentMag = _x;
				_currentIndex = _forEachIndex;
				{
					if (_currentMag isKindOf [_x , configFile >> "CfgMagazines"]) then { _DisplayList pushBack _currentMag};
				} forEach _ClassTypes;	
			} forEach _WarheadList;
/* 			
		 	{
				_DisplayList pushBack _x;
			} forEach _ExperimentalList; 
*/
			{
					_ctrlListBox lbAdd (getText(configFile >> "CfgMagazines" >> _x >> "displayName"));
					_ctrlListBox lbSetData [_forEachIndex, (getText(configFile >> "CfgMagazines" >>  _x >> "ammo"))];
					_ctrlListBox lbSetPicture [_forEachIndex, (getText(configFile >> "CfgMagazines" >> _x >> "picture"))];
			} foreach _DisplayList;


			{
				_ctrlCombo lbAdd _x;
				_ctrlCombo lbSetColor [_forEachIndex, ([[1,0,0,1],[0,1,0,1],[0,0,1,1]] select _forEachIndex)];
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

			// Confirm button
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
					_FpvArray = [];
					for "_i" from 0 to (_droneCount - 1) step 1 do 
					{
						_newFPV = createVehicle [(_droneSide + "_FPV_AR2"), (getPosATL _logicX), [], 5, "NONE"];
						{_x addCuratorEditableObjects [[_newFPV], true]} forEach allCurators;			
						[_newFPV, _Ammo, _magazine] spawn 
						{
							waitUntil {sleep 0.10; (getMass (_this select 0)) >= 200};
							[(_this select 1), (_this select 0), false] call Exp_fnc_finalStage;	
							(_this select 0) setVariable ["ExpMagazine", (_this select 2)];		
							_actionInit = (_this select 0) getVariable "ExpInitAction";
							(_this select 0) removeAction _actionInit;							
						};
						
						
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
		
		
		
		
		
		////3den Module activation
		if ((_isActivated && !(_isCuratorPlaced)) && !(is3DEN)) then
		{
			private _warheadClass = _logic getVariable "WarheadSelector"; 
			private _DroneSide = _logic getVariable ["DroneSide", "B"];
			private _DroneCount = _logic getVariable ["DroneCount", 1];
			_Ammo = gettext (configFile >> 'CfgMagazines' >> _warheadClass >> 'ammo');	
			for "_i" from 0 to (_droneCount - 1) step 1 do 
			{				
				_newFPV = createVehicle [(_DroneSide + "_FPV_AR2"), (getPosATL _logic), [], 5, "NONE"];
				[_newFPV, _Ammo, _warheadClass] spawn 
				{
					waitUntil {sleep 0.10; (getMass (_this select 0)) >= 200};
					[(_this select 1), (_this select 0), false] call Exp_fnc_finalStage;	
					(_this select 0) setVariable ["ExpMagazine", (_this select 2)];		
					_actionInit = (_this select 0) getVariable "ExpInitAction";
					(_this select 0) removeAction _actionInit;							
				};
					
			};		
		};
	};
};