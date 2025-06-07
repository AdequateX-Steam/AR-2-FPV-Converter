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
		if ((activatedAddons find "itc_land_veh_uav01") != -1) then 
		{
		
			addMissionEventHandler ["PlayerViewChanged",
			{
				params 
				[
					"_oldUnit", "_newUnit", "_vehicleIn",
					"_oldCameraOn", "_newCameraOn", "_uav"
				];
				if ((_newCameraOn isKindOf "fpv_Base_F") || (_newCameraOn isKindOf "ITC_Land_UAV_AR2i_base") || (_newCameraOn isKindOf "ITC_Land_UAV_AR2e_base")) then  //add handler function for other "drones" to be used as FPVs?
				{
					player setVariable ["UiEnabled", false];
					[] spawn Exp_fnc_hudHandler;
				};
							
				if ((!(_newCameraOn isKindOf "fpv_Base_F") && !(_newCameraOn isKindOf "ITC_Land_UAV_AR2i_base") && !(_newCameraOn isKindOf "ITC_Land_UAV_AR2e_base"))) then //add handler function for other "drones" to be used as FPVs?
				{
					player setVariable ["UiEnabled", true];
					[] spawn Exp_fnc_hudHandler;
				};
			}];  
		}
		else 
		{
			addMissionEventHandler ["PlayerViewChanged",
			{
				params 
				[
					"_oldUnit", "_newUnit", "_vehicleIn",
					"_oldCameraOn", "_newCameraOn", "_uav"
				];
				if ((_newCameraOn isKindOf "fpv_Base_F")) then  //add handler function for other "drones" to be used as FPVs
				{
					player setVariable ["UiEnabled", false];
					[] spawn Exp_fnc_hudHandler;
				};
							
				if (!(_newCameraOn isKindOf "fpv_Base_F")) then //add handler function for other "drones" to be used as FPVs
				{
					player setVariable ["UiEnabled", true];
					[] spawn Exp_fnc_hudHandler;
				};
			}];  
		};		
};