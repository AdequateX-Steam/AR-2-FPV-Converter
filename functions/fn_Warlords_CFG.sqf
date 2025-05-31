if (((missionname select [0,11]) == "MP_Warlords") || (!(isnil{BIS_WL_allWarlords}))) then 
{

	waitUntil {(alive player) && (!(player isnil "BIS_WL_purchasable"))};
	_faction = [];
	switch (side player) do 
	{
		case west:{ _faction = ["Box_NATO_FPV",350,[],"(8X) FPV drone crate [NATO]","\A3\EditorPreviews_F\Data\CfgVehicles\Box_NATO_AmmoVeh_F.jpg","4x UAV Terminal [NATO], 2x RPG-42 Rocket, 2x RPG-42 HE Rocket, 2x Claymore Charge, 2x PG-7VM HEAT Grenade, 8x AR-2 FPV Drone Bag (NATO), 2x Assault Pack (Black)","Gear"]};
		case east:{ _faction = ["Box_East_FPV",350,[],"(8X) FPV drone crate [CSAT]","\A3\EditorPreviews_F\Data\CfgVehicles\Box_East_AmmoVeh_F.jpg","4x UAV Terminal [CSAT], 2x RPG-42 Rocket, 2x RPG-42 HE Rocket, 2x Claymore Charge, 2x PG-7VM HEAT Grenade, 8x AR-2 FPV Drone Bag (CSAT), 2x Assault Pack (Black)","Gear"]};
		default {_faction = nil;};
	};
	_purchaseables = player getVariable "BIS_WL_purchasable";
	(_purchaseables # 2) pushBack _faction;
	player setVariable 
	[
		"BIS_WL_purchasable", 
		_purchaseables  
	];
};

/* 
//debug command for "BIS_WL_purchasable"
{
	{
		diag_log _x;
	} foreach _x;
	
} forEach (player getVariable "BIS_WL_purchasable");

*/

//["Box_NATO_FPV",450,[],"(8X) FPV drone crate [NATO]","\A3\EditorPreviews_F\Data\CfgVehicles\Box_NATO_AmmoVeh_F.jpg","4x UAV Terminal [NATO], 2x RPG-42 Rocket, 2x RPG-42 HE Rocket, 2x Claymore Charge, 2x PG-7VM HEAT Grenade, 2x AR-2 FPV Drone Bag (NATO), 2x Assault Pack (Black)","Gear"]
//format: ["itemCFG", cost(int), [], "display name", "display image path", "contents description", "Category"]
// [[inf], [veh], [gear], [def], [strategy]]...not sure about air/naval


/* {
} forEach BIS_WL_allWarlords; //list of all players
 */

