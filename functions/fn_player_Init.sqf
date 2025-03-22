if (hasInterface) then  //Run on all players + SP host
{
		waitUntil {Alive Player};		
			//Drone Assembled EH
			player addEventHandler ["WeaponAssembled", 
			{
				params ["_unit", "_staticWeapon", "_primaryBag", "_secondaryBag"];
				if (_staticWeapon isKindOf "UAV_01_base_F") then 
				{
					removeAllActions _staticWeapon;
					[_staticWeapon] spawn Exp_fnc_droneConverter;
				};
			}];
/* 	//old Hud handling				
			player addEventHandler ["Respawn", 
			{
				params ["_unit", "_corpse"];
				[] spawn Exp_fnc_showHUD;
			}];
			
			Player addEventHandler ["Killed", 
			{
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				isNil {[] spawn Exp_fnc_removeHud};  //either spawn only, or isnil call code for unscheduled environment
			}]; */
			
			
			
		///for UI handling	
			addMissionEventHandler ["PlayerViewChanged",
			{
				params 
				[
					"_oldUnit", "_newUnit", "_vehicleIn",
					"_oldCameraOn", "_newCameraOn", "_uav"
				];
				if ((_newCameraOn isKindOf "fpv_Base_F")) then 
				{
					player setVariable ["UiEnabled", false];
					[] spawn Exp_fnc_hudHandler;
				};
							
				if (!(_newCameraOn isKindOf "fpv_Base_F")) then 
				{
					player setVariable ["UiEnabled", true];
					[] spawn Exp_fnc_hudHandler;
				};
			}];  

			
			
/* 			[] spawn Exp_fnc_showHUD;		 */
			
};





