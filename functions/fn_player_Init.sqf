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
			
			
};