/* Things to do:
1) bug fixes
2) random sounds on detonation? "playSound", "playSound3D" (phonk walk, hehe boy, surprise motherfucker, sanic, samir your crashing the car, im dying help me, click noice, metal gear alert sound, gotcha bitch) https://www.myinstants.com/en/search/?name=samir
3) new drone engine sounds
4) removed deprecated code
5) laser pointer from RPG warhead to indicate impact point? drawLine3D, oneachframe, getposATL droneobject, eyepos, weapondirection, ASLToAGL, weaponsturret, currentweapon, getcameraviewdirection
6)onEachFrame { drawLine3D [ASLToAGL eyePos player, cursorObject, [1,0,0,1], 5];};
 */
class CfgPatches
{
	class fpvConverter
	{
		name = "fpvConverter";
		author = "AdequateX";
		requiredVersion= 1.60;
		requiredAddons[] = {"A3_Ui_F", "A3_Ui_F_Data", "A3_Drones_F", "A3_weapons_f", "A3_weapons_f_beta"};
		units[] = {"B_FPV_AR2", "O_FPV_AR2", "I_FPV_AR2", "B_FPVAR2_backpack_F", "O_FPVAR2_backpack_F", "I_FPVAR2_backpack_F"};
		weapons[] = {"fpvRocket","fpvGrenade"};
	};
};

class CfgFunctions {
	#include "\fpvConverter\functions\cfgFunctions.hpp"
}; 

class RscFrame;
class RscText;
class RscListBox;
class RscActiveText;
class RscProgress;
class RscPicture;
class RscCombo;
class RscButtonMenu;
class RscStructuredText;
class RscEdit;
class RscButton;
class RscCheckBox;
#include "dialogs.hpp"

class CfgWeapons 
{
	class FakeWeapon{};
	class fpvRocket: FakeWeapon 
	{
		displayName = "Activate";	
		burst=1;
		magazines[]={"FakeMagazine"};
	};
		
};


class CfgAmmo 
{ 
	class M_SPG9_HEAT;
	class Grenade;
	class fpvAmmo : M_SPG9_HEAT 
	{
		timeToLive = 2100; //35 minutes auto detonate
		effectsMissileInit = "";
		explosive = 0;
		hit = 0;
		indirectHit = 0;
		fuseDistance = 0;
		thrust = 0;
		thrustTime = 0;
		submunitionAmmo = "";
		triggerOnImpact = 0;
		soundFly[] ={};
		soundEngine[] = {};
		soundHit[] = {};
	};
	class fpvGrenade : Grenade 
	{
		explosionTime = -1; // -1
		explosive = 0;
		explosionAngle = 0;
		explosionDir = "";
		explosionEffects = "";
		explosionEffectsDir = "";
		explosionForceCoef = 0;
		explosionEffectsRadius = 0;
		explosionPos = "";
		explosionSoundEffect = "";
		explosionType = "";
		soundEngine[] = {};
		soundFall[] = {};
		soundFly[] = {};
		soundHit[] = {};
		soundFakeFall[] = {};
		SoundSetExplosion[] = {};
		soundHit1[] = {};
		soundHit2[] = {};
		soundHit3[] = {};
		soundHit4[] = {};
		hit = 0;
		indirectHitRange = 0;
		indirectHit = 0;
		timeToLive = 2100; //35 minutes auto delete (2100)
		thrustTime = 0;
		thrust = 0;
	};
};

class SensorTemplatePassiveRadar;
class SensorTemplateAntiRadiation;
class SensorTemplateActiveRadar;
class SensorTemplateIR;
class SensorTemplateVisual;
class SensorTemplateMan;
class SensorTemplateLaser;
class SensorTemplateNV;
class SensorTemplateDataLink;
class DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};

class CfgVehicles {
	
	class Air;
	class Helicopter: Air
	{
		class Turrets;
		class HitPoints;
	};
	class Helicopter_Base_F: Helicopter
	{
		class Turrets: Turrets
		{
			class MainTurret;
		};
		class HitPoints: HitPoints
		{
			class HitHRotor;
			class HitHull;
		};
		class AnimationSources;
		class EventHandlers;
		class ViewOptics;
		class ViewPilot;
		class Components;
	};
	
	class fpv_Base_F: Helicopter_Base_F 
	{
		features = "Randomization: No						<br />Camo selections: 1 - the whole body						<br />Script door sources: None						<br />Script animations: None						<br />Executed scripts: None						<br />Firing from vehicles: No						<br />Slingload: No						<br />Cargo proxy indexes: None";
		author = "AdequateX";
		mapSize = 15; //10
		class SpeechVariants
		{
			class Default
			{
				speechSingular[] = {"veh_air_UAV_s"};
				speechPlural[] = {"veh_air_UAV_p"};
			};
		};
		textSingular = "$STR_A3_nameSound_veh_air_UAV_s";
		textPlural = "$STR_A3_nameSound_veh_air_UAV_p";
		nameSound = "veh_air_UAV_s";
		_generalMacro = "fpv_Base_F";
		editorSubcategory = "EdSubcat_Drones";
		scope = 0;
		displayName = "$STR_A3_CfgVehicles_UAV_01_base0";
		isUav = 1;
		uavCameraDriverPos = "pip_pilot_pos";
		uavCameraDriverDir = "pip_pilot_dir";
		uavCameraGunnerPos = ""; /////////
		uavCameraGunnerDir = ""; /////////
		extCameraPosition[] = {0.0,-0.25,-2.35};
		extCameraParams[] = {0.93,10,30,0.25,1,10,30,0,1};
		formationX = 10;
		formationZ = 10;
		memoryPointTaskMarker = "TaskMarker_1_pos";
		memoryPointDriverOptics = "pip_pilot_pos";
		driverOpticsModel = "a3\Weapons_F_Orange\Reticle\UAV_06_driver_F.p3d";  ////"A3\weapons_f_beta\reticle\reticle_SDV_driver"; "A3\drones_f\Weapons_F_Gamma\Reticle\UGV_01_Optics_Driver_F.p3d", "A3\weapons_f\Reticle\optics_empty.p3d", "a3\Weapons_F_Orange\Reticle\UAV_06_driver_F.p3d"
		driverForceOptics = 1;
		disableInventory = 1;
		unitInfoType = "RscOptics_UAV_06"; //RscOptics_AV_pilot (default hud), RscUnitInfoParachute (blank hud), RscOptics_SDV_driver, "RscOptics_UAV_06"
		unitInfoTypeRTD = "RscOptics_UAV_06";  //this ^^^ and this <<< controls the MFD HUD
		driverWeaponsInfoType = "RscOptics_Offroad_01";
		getInRadius = 0;
		damageEffect = "UAVDestructionEffects";
		damageTexDelay = 0.5;
		dustEffect = "UAVDust";
		waterEffect = "UAVWater";
		washDownDiameter = "10.0f";
		washDownStrength = "0.25f";
		killFriendlyExpCoef = 0.1;
		accuracy = 2.5;
		camouflage = 0.20;
		audible = 0.1;
		armor = 2; //0.5
		cost = 100; /////200 //20000
		altFullForce = 1250; 
		altNoForce = 2000;	
		LODTurnedIn = -1;
		LODTurnedOut = -1;
		epeImpulseDamageCoef = 5;
		fuelExplosionPower = 0;
		vehicleClass = "Autonomous";
		model = "\A3\Drones_F\Air_F_Gamma\UAV_01\UAV_01_F.p3d";
		icon = "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa"; //"\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa" //controls the map icon of the unit
		picture = "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\UAV_01_CA.paa";
		class Reflectors{};
		startDuration = 0.5; //1.00
		maxSpeed = 170;
		precision = 10; //waypoint complete radius precision?
		steerAheadSimul = 0.5;
		steerAheadPlan = 0.7;
		predictTurnPlan = 2.0;
		predictTurnSimul = 1.5;
		liftForceCoef = 1.5; ////////////////////////////////// 1.00 (default) -> 1.10
		cyclicAsideForceCoef = 1.675; ///////////2.0 (default) -> 2.25
		cyclicForwardForceCoef = 0.675; //////////1.2 (default) -> 1.0
		bodyFrictionCoef = 0.25; //////////0.3 (default) -> 0.25
		backRotorForceCoef = 4.0; /////////5.0 (default) -> 4.0
		fuelCapacity = 15; ///////////////////////////////////
		maxFordingDepth = 0.3;
		threat[] = {0.60,0.70,0.125}; //{0.04,0.1,0.05};
		envelope[] = {0,0.4,1.3,2.5,2.9,3.7,3.9,4.0,4.1,4.2,4.2,3,0.9,0.7,0.5};   ////TEST/////////relative to maxspeed in increments of 10% -> 140%{0.1, 0.2, 0.3 ... 1.2, 1.3, 1.4}, stock ar-2 envelope[] = {0,0.2,0.9,2.1,2.5,3.3,3.5,3.6,3.7,3.8,3.8,3,0.9,0.7,0.5};
		maxMainRotorDive = 0;
		minMainRotorDive = 0;
		neutralMainRotorDive = 0;
		gearRetracting = 0;
		mainRotorSpeed = -7.0; //-7
		backRotorSpeed = 7.0; //7
		tailBladeVertical = 0;
		radarTarget = 1; ////////
		radarTargetSize = 0.175;
		visualTarget = 1; ///////
		visualTargetSize = 0.275; /// 0.1
		irTarget = 0;
		lockDetectionSystem = 0;
		incomingMissileDetectionSystem = 0;
		weapons[] = {"fpvRocket"};
		magazines[] = {};
		irScanRangeMin = 0;
		irScanRangeMax = 0;
		irScanToEyeFactor = 1;
		class TransportItems{};
		destrType = "DestructDefault";
		driverCompartments = "Compartment3";
		cargoCompartments[] = {"Compartment2"};	
		class HitPoints: HitPoints
		{
			class HitHull: HitHull
			{
				armor = 0.1;
			};
			class HitHRotor: HitHRotor
			{
				armor = 0.3;
			};
		};
		class Damage
		{
			tex[] = {};
			mat[] = {"A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01.rvmat","A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_damage.rvmat","A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_destruct.rvmat"};
		};
		class ViewPilot: ViewPilot
		{
			minFov = 0.225; ///////////
			maxFov = 1.0; /////////// 1.5
			initFov = 1.0;
			initAngleX = 0;
			minAngleX = -65;
			maxAngleX = 85;
			initAngleY = 0;
			minAngleY = -150;
			maxAngleY = 150;
		};
		class Viewoptics: ViewOptics
		{
			initAngleX = 0;
			minAngleX = 0;
			maxAngleX = 0;
			initAngleY = 0;
			minAngleY = 0;
			maxAngleY = 0;
			minFov = 0.225; ///////////
			maxFov = 1.0; //////////// 1.5
			initFov = 0.625; ///////////
			visionMode[] = {"Normal","NVG","Ti"};
			thermalMode[] = {0,1};
		};
		class MFD{}; //MULTI-FUNCTION DISPLAY
		enableManualFire = 1;
		receiveRemoteTargets = true; ////
		reportRemoteTargets = 1;
		reportOwnPosition = 1;
		class Components: Components
		{
			class SensorsManagerComponent
			{
				class Components
				{
					class DataLinkSensorComponent: SensorTemplateDataLink 
					{
						
						class AirTarget
						{
							minRange = 0; //////////
							maxRange = 2000; /////////
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 0; ///////////
							maxRange = 2000; ///////////
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};	
						
						
					};
					class ManSensorComponent: SensorTemplateMan
					{
						maxTrackableSpeed = 25;
						angleRangeHorizontal = 80; //60
						angleRangeVertical = 60; //45
						animDirection = "mainGun";
						aimDown = 5.5; //-0.5
						allowsMarking= 1;
						minRange = 100; //////////
						maxRange = 700; /////////
					};
					class VisualSensorComponent: SensorTemplateVisual /////////////////////////// new component
					{
						angleRangeHorizontal = 80;
						angleRangeVertical = 60;
						maxTrackableSpeed = 45;
						animDirection = "mainGun";
						aimDown = 5.5;
						allowsMarking= 1;
						class AirTarget
						{
							minRange = 400; //////////
							maxRange = 1700; /////////
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 125; ///////////
							maxRange = 1400; ///////////
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						
					};
					class IRSensorComponent: SensorTemplateIR
					{
						class AirTarget
						{
							minRange = 600; //////////
							maxRange = 2000; /////////
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 300; ///////////
							maxRange = 1600; ///////////
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						allowsMarking= 1;
						maxTrackableSpeed = 45; ////////////
						angleRangeHorizontal = 70; //60
						angleRangeVertical = 60; //45
						animDirection = "mainGun";
						aimDown = 5.5; // -0.5
					};
				};
			};
			class VehicleSystemsDisplayManagerComponentLeft: DefaultVehicleSystemsDisplayManagerLeft
			{
				class components
				{
					class EmptyDisplay
					{
						componentType = "EmptyDisplayComponent";
					};
					class MinimapDisplay
					{
						componentType = "MinimapDisplayComponent";
						resource = "RscCustomInfoMiniMap";
					};
					class UAVDisplay{};
					class SensorDisplay
					{
						componentType = "SensorsDisplayComponent";
						range[] = {500,1000,2000};
						resource = "RscCustomInfoSensors";
					};
				};
			};
			class VehicleSystemsDisplayManagerComponentRight: DefaultVehicleSystemsDisplayManagerRight
			{
				defaultDisplay = "SensorDisplay";
				class components
				{
					class EmptyDisplay
					{
						componentType = "EmptyDisplayComponent";
					};
					class MinimapDisplay
					{
						componentType = "MinimapDisplayComponent";
						resource = "RscCustomInfoMiniMap";
					};
					class UAVDisplay{};
					class SensorDisplay
					{
						componentType = "SensorsDisplayComponent";
						range[] = {500,1000,2000};
						resource = "RscCustomInfoSensors";
					};
				};
			};
		};
		
		class CargoTurret {}; // 
        class NewTurret {};   // one of these controls pilot free-looking
        class PilotCamera{};  //
		class Turrets{};	
		attenuationEffectType = "OpenHeliAttenuation";
		soundGetIn[] = {"",1.0,1};
		soundGetOut[] = {"",1.0,1,50};
		soundEnviron[] = {"",0.031622775,1.0};
		soundDammage[] = {"",0.56234133,1};
		soundEngineOnInt[] = {"A3\Sounds_F\air\Uav_01\quad_start_full_int",0.56234133,1.0};
		soundEngineOnExt[] = {"A3\Sounds_F\air\Uav_01\quad_start_full_01",0.56234133,1.0,200};
		soundEngineOffInt[] = {"A3\Sounds_F\air\Uav_01\quad_stop_full_int",0.56234133,1.0};
		soundEngineOffExt[] = {"A3\Sounds_F\air\Uav_01\quad_stop_full_01",0.56234133,1.0,200};
		soundBushCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_1",1.0,1,100};
		soundBushCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_2",1.0,1,100};
		soundBushCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_3",1.0,1,100};
		soundBushCrash[] = {"soundBushCollision1",0.33,"soundBushCollision2",0.33,"soundBushCollision3",0.33};
		soundWaterCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_1",1.0,1,100};
		soundWaterCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_2",1.0,1,100};
		soundWaterCrashes[] = {"soundWaterCollision1",0.5,"soundWaterCollision2",0.5};
		Crash0[] = {"A3\Sounds_F\vehicles\crashes\cars\cars_coll_big_default_ext_1",1.0,1,900};
		Crash1[] = {"A3\Sounds_F\vehicles\crashes\cars\cars_coll_big_default_ext_2",1.0,1,900};
		Crash2[] = {"A3\Sounds_F\vehicles\crashes\cars\cars_coll_big_default_ext_3",1.0,1,900};
		Crash3[] = {"A3\Sounds_F\vehicles\crashes\cars\cars_coll_big_default_ext_4",1.0,1,900};
		soundCrashes[] = {"Crash0",0.25,"Crash1",0.25,"Crash2",0.25,"Crash3",0.25};
		class Sounds
		{
			class Engine
			{
				sound[] = {"A3\Sounds_F\air\Uav_01\quad_engine_full_01",0.4466836,1.0,200};
				frequency = "rotorSpeed * 1.5";
				volume = "camPos*((rotorSpeed-0.72)*4)";
			};
			class RotorLowOut
			{
				sound[] = {"A3\Sounds_F\air\Uav_01\blade",0.31622776,1.0,200};
				frequency = "rotorSpeed * 1.5";
				volume = "camPos*(0 max (rotorSpeed-0.1))";
				cone[] = {1.6,3.14,1.6,0.95};
			};
			class RotorHighOut
			{
				sound[] = {"A3\Sounds_F\air\Uav_01\blade_high",0.31622776,1.0,250};
				frequency = "rotorSpeed * 1.5";
				volume = "camPos*10*(0 max (rotorThrust-0.9))";
				cone[] = {1.6,3.14,1.6,0.95};
			};
			class EngineIn
			{
				sound[] = {"A3\Sounds_F\air\Uav_01\quad_engine_full_int",0.56234133,1.0};
				frequency = "rotorSpeed * 1.5";
				volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
			};
			class RotorLowIn
			{
				sound[] = {"A3\Sounds_F\air\Uav_01\blade_int",0.56234133,1.0};
				frequency = "rotorSpeed * 1.5";
				volume = "(1-camPos)*(0 max (rotorSpeed-0.1))";
			};
			class RotorHighIn
			{
				sound[] = {"A3\Sounds_F\air\Uav_01\blade_high_int",0.56234133,1.0};
				frequency = "rotorSpeed * 1.5";
				volume = "(1-camPos)*3*(rotorThrust-0.9)";
			};
		};
		class Exhausts
		{
			class Exhaust_1
			{
				position = "Exhaust_1_pos";
				direction = "Exhaust_1_dir";
				effect = "ExhaustsEffectDrone";
			};
		};
		class Library
		{
			libTextDesc = "$STR_A3_CfgVehicles_UAV_01_base_Library0";
		};
		
		hiddenSelections[] = {"camo"};
		class TextureSources
		{
			class Indep
			{
				displayName = "$STR_A3_TEXTURESOURCES_INDEP0";
				author = "AdequateX";
				textures[] = {"\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_INDP_CO.paa"};
				factions[] = {"IND_F"};
			};
			class Opfor
			{
				displayName = "$STR_A3_TEXTURESOURCES_OPFOR0";
				author = "AdequateX";
				textures[] = {"\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_OPFOR_CO.paa"};
				factions[] = {"OPF_F"};
			};
			class Blufor
			{
				displayName = "$STR_A3_TEXTURESOURCES_BLU0";
				author = "AdequateX";
				textures[] = {"\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_CO.paa"}; // "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_CO.paa"
				factions[] = {"BLU_F"};
			};
				
		};
		
	};


/////////////////////// DRONES ///////////////////////////

	class B_FPV_AR2: fpv_Base_F
	{	
		author = "AdequateX";
		class SimpleObject
		{
			eden = 1;
			animate[] = {{"damagehide",0},{"rotorimpacthide",0},{"tailrotorimpacthide",0},{"propeller1_rotation",0},{"propeller1_blur_rotation",0},{"propeller2_rotation",0},{"propeller2_blur_rotation",0},{"propeller3_rotation",0},{"propeller3_blur_rotation",0},{"propeller4_rotation",0},{"propeller4_blur_rotation",0},{"propeller1_hide",0},{"propeller1_blur_hide",0},{"propeller2_hide",0},{"propeller2_blur_hide",0},{"propeller3_hide",0},{"propeller3_blur_hide",0},{"propeller4_hide",0},{"propeller4_blur_hide",0},{"mainturret",0},{"maingun",-0.05}};
			hide[] = {"zasleh","tail rotor blur","main rotor blur","zadni svetlo","clan","podsvit pristroju","poskozeni"};
			verticalOffset = 0.15;
			verticalOffsetWorld = -0.001;
			init = "''";
		};
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\B_UAV_01_F.jpg";
		_generalMacro = "B_FPV_AR2";
		scope = 2;
		side = 1;
		faction = "BLU_F";
		crew = "B_UAV_AI";
		typicalCargo[] = {"B_UAV_AI"};
		displayName = "AR-2 FPV";
		class assembleInfo 
		{
			primary = 0;
			base = "";
			assembleTo = "";		
			dissasembleTo[] = {"B_FPVAR2_backpack_F"};
			displayName = "";
		};	
		class EventHandlers 
		{
			init = "[_this select 0] spawn Exp_fnc_drone_Init";
		};
		hiddenSelectionsTextures[] = {"\fpvConverter\textures\UAV_01_CO.paa"}; //"A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_CO.paa"
		textureList[] = {"Blufor",1};
	};	
	
	class O_FPV_AR2: fpv_Base_F
	{	
		author = "AdequateX";
		class SimpleObject
		{
			eden = 1;
			animate[] = {{"damagehide",0},{"rotorimpacthide",0},{"tailrotorimpacthide",0},{"propeller1_rotation",0},{"propeller1_blur_rotation",0},{"propeller2_rotation",0},{"propeller2_blur_rotation",0},{"propeller3_rotation",0},{"propeller3_blur_rotation",0},{"propeller4_rotation",0},{"propeller4_blur_rotation",0},{"propeller1_hide",0},{"propeller1_blur_hide",0},{"propeller2_hide",0},{"propeller2_blur_hide",0},{"propeller3_hide",0},{"propeller3_blur_hide",0},{"propeller4_hide",0},{"propeller4_blur_hide",0},{"mainturret",0},{"maingun",-0.05}};
			hide[] = {"zasleh","tail rotor blur","main rotor blur","zadni svetlo","clan","podsvit pristroju","poskozeni"};
			verticalOffset = 0.15;
			verticalOffsetWorld = -0.001;
			init = "''";
		};
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\O_UAV_01_F.jpg";
		_generalMacro = "O_FPV_AR2";
		scope = 2;
		side = 0;
		faction = "OPF_F";
		crew = "O_UAV_AI";
		typicalCargo[] = {"O_UAV_AI"};
		displayName = "AR-2 FPV";
		class assembleInfo 
		{
			primary = 0;
			base = "";
			assembleTo = "";		
			dissasembleTo[] = {"O_FPVAR2_backpack_F"};
			displayName = "";
		};	
		class EventHandlers 
		{
			init = "[_this select 0] spawn Exp_fnc_drone_Init";
		};
		hiddenSelectionsTextures[] = {"\fpvConverter\textures\UAV_01_OPFOR_CO.paa"}; //"A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_OPFOR_CO.paa"
		textureList[] = {"Opfor",1};
	};
	
	class I_FPV_AR2: fpv_Base_F
	{	
		author = "AdequateX";
		class SimpleObject
		{
			eden = 1;
			animate[] = {{"damagehide",0},{"rotorimpacthide",0},{"tailrotorimpacthide",0},{"propeller1_rotation",0},{"propeller1_blur_rotation",0},{"propeller2_rotation",0},{"propeller2_blur_rotation",0},{"propeller3_rotation",0},{"propeller3_blur_rotation",0},{"propeller4_rotation",0},{"propeller4_blur_rotation",0},{"propeller1_hide",0},{"propeller1_blur_hide",0},{"propeller2_hide",0},{"propeller2_blur_hide",0},{"propeller3_hide",0},{"propeller3_blur_hide",0},{"propeller4_hide",0},{"propeller4_blur_hide",0},{"mainturret",0},{"maingun",-0.05}};
			hide[] = {"zasleh","tail rotor blur","main rotor blur","zadni svetlo","clan","podsvit pristroju","poskozeni"};
			verticalOffset = 0.15;
			verticalOffsetWorld = -0.001;
			init = "''";
		};
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\I_UAV_01_F.jpg";
		_generalMacro = "I_FPV_AR2";
		scope = 2;
		side = 2;
		faction = "IND_F";
		crew = "I_UAV_AI";
		typicalCargo[] = {"I_Soldier_lite_F"};
		displayName = "AR-2 FPV";
		class assembleInfo 
		{
			primary = 0;
			base = "";
			assembleTo = "";		
			dissasembleTo[] = {"I_FPVAR2_backpack_F"};
			displayName = "";
		};	
		class EventHandlers 
		{
			init = "[_this select 0] spawn Exp_fnc_drone_Init";
		};
		hiddenSelectionsTextures[] = {"\fpvConverter\textures\UAV_01_INDP_CO.paa"}; //"A3\Drones_F\Air_F_Gamma\UAV_01\Data\UAV_01_INDP_CO.paa"
		textureList[] = {"Indep",1};
	};
	
	
/////////////////////// BACKPACKS ///////////////////////////
	
	
	class Bag_Base;
	class Weapon_Bag_Base: Bag_Base
	{
		class assembleInfo;
	};
	class B_FPVAR2_backpack_F: Weapon_Bag_Base
	{
		author = "AdequateX";
		mapSize = 0.6;
		_generalMacro = "B_FPVAR2_backpack_F ";
		scope = 2;
		scopeCurator = 2;
		displayName = "AR-2 FPV Drone Bag (NATO)";
		model = "\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\UAV_backpack_F.p3d";
		editorCategory = "EdCat_Equipment";
		editorSubcategory = "EdSubcat_Backpacks";
		faction = "BLU_F";
		picture = "\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\Data\UI\icon_B_C_UAV_rgr_ca";
		hiddenSelectionsTextures[] = {"\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\Data\UAV_backpack_rgr_co.paa"};
		maximumLoad = 0;
		mass = 63;
		class assembleInfo: assembleInfo
		{
			base = "";
			displayName = "AR-2 FPV";
			assembleTo = "B_FPV_AR2";
		};
	};
	class O_FPVAR2_backpack_F: B_FPVAR2_backpack_F
	{
		author = "AdequateX";
		_generalMacro = "O_FPVAR2_backpack_F";
		displayName = "AR-2 FPV Drone Bag (CSAT)";
		faction = "OPF_F";
		picture = "\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\Data\UI\icon_B_C_UAV_cbr_ca";
		hiddenSelectionsTextures[] = {"\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\Data\UAV_backpack_cbr_co.paa"};
		class assembleInfo: assembleInfo
		{
			displayName = "AR-2 FPV";
			assembleTo = "O_FPV_AR2";
			
		};
	};
	class I_FPVAR2_backpack_F: B_FPVAR2_backpack_F
	{
		author = "AdequateX";
		_generalMacro = "I_FPVAR2_backpack_F";
		displayName = "AR-2 FPV Drone Bag (AAF)";
		faction = "IND_F";
		picture = "\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\Data\UI\icon_B_C_UAV_oli_ca";
		hiddenSelectionsTextures[] = {"\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\Data\UAV_backpack_oli_co.paa"};
		class assembleInfo: assembleInfo
		{
			displayName = "AR-2 FPV";
			assembleTo = "I_FPV_AR2";
		};
	};
};
