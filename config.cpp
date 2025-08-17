/* Things to do:
1) bug fixes
2) random sounds on detonation? "playSound", "playSound3D" (phonk walk, hehe boy, surprise motherfucker, sanic, samir your crashing the car, im dying help me, click noice, metal gear alert sound, gotcha bitch) https://www.myinstants.com/en/search/?name=samir
3) new drone engine sounds
4) laser pointer from RPG warhead to indicate impact point? drawLine3D, oneachframe, getposATL droneobject, eyepos, weapondirection, ASLToAGL, weaponsturret, currentweapon, getcameraviewdirection
5) automation (moduledefence and automation) consider swapping center of mass calculations for 'unitaimposition'

 */
class CfgPatches
{
	class fpvConverter
	{
		name = "fpvConverter";
		author = "AdequateX";
		requiredVersion= 1.60;
		requiredAddons[] = {"A3_Ui_F", "A3_Ui_F_Data", "A3_Drones_F", "A3_weapons_f", "A3_weapons_f_beta", "A3_missions_f_warlords", "A3_Modules_F", "A3_3DEN"};
		units[] = {"B_FPV_AR2", "O_FPV_AR2", "I_FPV_AR2", "B_FPVAR2_backpack_F", "O_FPVAR2_backpack_F", "I_FPVAR2_backpack_F", "EXP_ModuleDefence_F", "EXP_CuratorWarhead_F"};
		weapons[] = {"fpvRocket","fpvGrenade"};
	};
};

class CfgFunctions {
	#include "\fpvConverter\functions\cfgFunctions.hpp"
}; 

class RscObject;
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
class RscSlider;
class RscXSliderH;
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
		timeToLive = 10800; //35 minutes auto detonate (2100)
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
		scopeCurator = 2;
		scopeArsenal = 2;
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
		scopeCurator = 2;
		scopeArsenal = 2;
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
		scopeCurator = 2;
		scopeArsenal = 2;
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
	
	
///////////////////////////////////// DRONE CRATES (for warlords) ////////////////////////////////////////////
	class Box_NATO_AmmoVeh_F;
	class Box_NATO_FPV : Box_NATO_AmmoVeh_F
	{
		author = "AdequateX";
		mapSize = 1.53;
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 0.79;
			verticalOffsetWorld = 0;
			init = "''";
		};
		maximumLoad = 3000;
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Box_NATO_AmmoVeh_F.jpg";
		_generalMacro = "Box_NATO_FPV";
		scope = 2;
		displayName = "(8X) FPV drone crate [NATO]";
		model = "A3\Weapons_F\Ammoboxes\AmmoVeh_F";
		icon = "iconCrateVeh";
		slingLoadCargoMemoryPoints[] = {"SlingLoadCargo1","SlingLoadCargo2","SlingLoadCargo3","SlingLoadCargo4"};
		hiddenSelectionsTextures[] = {"A3\Weapons_F\Ammoboxes\data\AmmoBox_signs_CA.paa","A3\Weapons_F\Ammoboxes\data\AmmoVeh_CO.paa"};
		class TransportMagazines
		{
			class _xx_RPG32_F 
			{
				magazine = "RPG32_F";
				count = 2;
			};
			class _xx_RPG32_HE_F
			{
				magazine= "RPG32_HE_F";
				count = 2;
			};
			class _xx_ClaymoreDirectionalMine_Remote_Mag
			{
				magazine = "ClaymoreDirectionalMine_Remote_Mag";
				count = 2;
			};
			class _xx_RPG7_F
			{
				magazine = "RPG7_F";
				count = 2;
			};			
		};
		class TransportWeapons{};
		class TransportItems 
		{
			class _xx_B_UavTerminal 
			{
				name = "B_UavTerminal";
				count = 4;				
			};
			
		};
		class TransportBackpacks
		{
			class B_FPVAR2_backpack_F 
			{
				backpack = "B_FPVAR2_backpack_F";
				count = 8;
			};
			class _xx_B_AssaultPack_blk 
			{
				backpack = "B_AssaultPack_blk";
				count = 2;
			};
		};
		transportAmmo = 0;
		supplyRadius = 0;		
	};
	class Box_East_FPV : Box_NATO_FPV
	{
		author = "AdequateX";
		mapSize = 1.53;
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 0.79;
			verticalOffsetWorld = 0;
			init = "''";
		};
		maximumLoad = 3000;
		editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\Box_East_AmmoVeh_F.jpg";
		_generalMacro = "Box_East_FPV";
		scope = 2;
		displayName = "(8X) FPV drone crate [CSAT]";
		model = "A3\Weapons_F\Ammoboxes\AmmoVeh_F";
		icon = "iconCrateVeh";
		slingLoadCargoMemoryPoints[] = {"SlingLoadCargo1","SlingLoadCargo2","SlingLoadCargo3","SlingLoadCargo4"};
		hiddenSelectionsTextures[] = {"A3\Weapons_F\Ammoboxes\data\AmmoBox_signs_OPFOR_CA.paa","A3\Weapons_F\Ammoboxes\data\AmmoVeh_OPFOR_CO.paa"};
		class TransportMagazines
		{
			class _xx_RPG32_F 
			{
				magazine = "RPG32_F";
				count = 2;
			};
			class _xx_RPG32_HE_F
			{
				magazine= "RPG32_HE_F";
				count = 2;
			};
			class _xx_ClaymoreDirectionalMine_Remote_Mag
			{
				magazine = "ClaymoreDirectionalMine_Remote_Mag";
				count = 2;
			};
			class _xx_RPG7_F
			{
				magazine = "RPG7_F";
				count = 2;
			};	
		};
		class TransportWeapons{};
		class TransportItems 
		{
			class _xx_O_UavTerminal
			{
				name = "O_UavTerminal";
				count = 4;			
			};		
		};
		class TransportBackpacks
		{
			class _xx_O_FPVAR2_backpack_F 
			{
				backpack = "O_FPVAR2_backpack_F";
				count = 8;
			};
			class _xx_B_AssaultPack_blk 
			{
				backpack = "B_AssaultPack_blk";
				count = 2;
			};
		};
		transportAmmo = 0;
		supplyRadius = 0;		
	};
	
	
	
//////////////////////////////////////////////// MODULES //////////////////////////////////////////////


 	
	class Logic;
	class Module_F : Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e. text input field)
			class Combo;				// Default combo box (i.e. drop-down menu)
			class Slider; 			
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
			class Controls;
		};

		// Description base classes (for more information see below):
		class ModuleDescription
		{
			class AnyAI;
		};
	};
	class EXP_ModuleTemplate_F : Module_F
	{
		author = "AdequateX";
		_generalMacro = "EXP_ModuleTemplate_F";
		scope = 0;
		category = "Supports";
		icon = "\a3\ui_f\data\Map\Markers\HandDrawn\flag_CA.paa";
		isGlobal = 0;
		isTriggerActivated = 0;	
		isDisposable = 1;
		is3DEN = 0;			
		// 3DEN Attributes Menu Options
		canSetArea = 1;						// Allows for setting the area values in the Attributes menu in 3DEN
		canSetAreaShape = 1;				// Allows for setting "Rectangle" or "Ellipse" in Attributes menu in 3DEN
		canSetAreaHeight = 1;				// Allows for setting height or Z value in Attributes menu in 3DEN
		
	};
	class EXP_ModuleDefence_F : EXP_ModuleTemplate_F 
	{
		author = "AdequateX";
		_generalMacro = "EXP_ModuleDefence_F";
		scope = 2;
		category = "Supports";
		displayName = "FPV Area Defence";
		icon = "\a3\ui_f\data\Map\Markers\HandDrawn\flag_CA.paa";
		portrait = "\a3\ui_f\data\Map\Markers\HandDrawn\flag_CA.paa";
		function = "EXP_fnc_moduleDefence";
		isGlobal = 0;
		isTriggerActivated = 0;	
		isDisposable = 1;
		is3DEN = 0;
		canSetArea = 0;		
		canSetAreaShape = 0;				// Allows for setting "Rectangle" or "Ellipse" in Attributes menu in 3DEN
		canSetAreaHeight = 0;				// Allows for setting height or Z value in Attributes menu in 3DEN
		
		class AttributeValues
		{
			// This section allows you to set the default values for the attributes menu in 3DEN
			//size3[] = { 50, 50, -1 };		// 3D size (x-axis radius, y-axis radius, z-axis radius)
			//isRectangle = 0;				// Sets if the default shape should be a rectangle or ellipse
		};
		
		class Attributes: AttributesBase 
		{
			class Units : Units
			{
				class Values 
				{
					class B_FPV_AR2{};
					class O_FPV_AR2{};
					class I_FPV_AR2{};	
				};
			};
			
			class Warhead : Combo 
			{
				property = "EXP_ModuleDefence_Warhead";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Warhead Type:";			// Argument label
				tooltip = "What class of warheads to use";	// Tooltip description
				typeName = "NUMBER";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "0";							// Default attribute value. Warning: this is an expression, and its returned value will be used (50 in this case).
				control = "Combo";
				//expression = "_this setVariable ['%s',_value];";
				// Listbox items
				class Values
				{
					class Armour	{ name = "Anti-Armor";	value = 0; };
					class Personnel	{ name = "Anti-Personnel"; value = 1; };
					class Random 	{name = "Random"; value = 2;};
				};
			};
			class SearchRadius : Combo 
			{
				property = "EXP_ModuleDefence_Radius";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Defence Patrol Area Radius:";			// Argument label
				tooltip = "How wide of a loiter radius to defend, higher values = harder to detect targets";	// Tooltip description
				typeName = "NUMBER";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "150";							// Default attribute value. Warning: this is an expression, and its returned value will be used (50 in this case).
				control = "Combo";
				//expression = "_this setVariable ['%s',_value];";
				// Listbox items
				class Values 
				{
					class 150M	{name = "150 Meter radius";	value = 150;};
					class 200M	{name = "200 Meter radius";	value = 200;};
					class 300M	{name = "300 Meter radius";	value = 300;};
					class 400M	{name = "400 Meter radius";	value = 400;};
					class 500M	{name = "500 Meter radius";	value = 500;};
					class 750M	{name = "750 Meter radius"; value = 750;};
				};	
			};
			
			class DetectionChance
			{
				displayName = "Enemy Detection chance:";			// Argument label
				tooltip = "How likely the drone is able to spot an enemy (CIRCLE DETECTION ONLY!, above 0.75% is very fast!) (chance % / per-second) (0% = instant detection), Module has a 2-tiered Detection system (Line of sight @ 40% Radius, Circle detection @ 40%+ radius)... Line of sight is detected from module position @ 40M height (detected after continous visibility for 10 seconds), Circle radius detection is calculated 60M above current targets position (eye of god)... Buildings, trees, bushes will obstruct target from being detected";	// Tooltip description
				property = "EXP_ModuleDefence_DetectionChance";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				control = "DroneDetection";
				typeName = "NUMBER";
				expression = "_this setVariable ['%s',_value,true];";
				// Value type, can be "NUMBER", "STRING" or "BOOL"
				value = "1.00"; //10
				defaultValue = "1.00"; //10
			}; 
			
			class PrimaryTarget : Combo
			{
				property = "EXP_ModuleDefence_PrimaryTarget";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Primary target type:";			// Argument label
				tooltip = "What type of target to attack first (if multiple)";	// Tooltip description
				typeName = "STRING";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultvalue = "'Tank'";	
				control = "Combo";
				//expression = "_this setVariable ['%s',_value];";
				class Values 
				{
					class Man {name = "Soldiers"; value = "Man";};
					class Truck {name = "Truck/MRAPs"; value = "CAR";};
					class Light {name = "Wheeled APCs"; value = "Wheeled_APC_F";};
					class Heavy {name = "Heavy Armour"; value = "Tank";};
				};
			};
			
			class DroneSide : Combo
			{
				property = "EXP_ModuleDefence_DroneSide";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Drone's side:";			// Argument label
				tooltip = "What side is the drone?";	// Tooltip description
				typeName = "NUMBER";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultvalue = 0;	
				control = "Combo";
				//expression = "_this setVariable ['%s',_value];";
				class Values 
				{
					class WEST {name = "Blufor / West"; value = 0;};
					class EAST {name = "Opfor / East"; value = 1;};
					class INDEP {name = "Independant / Guerilla"; value = 2;};
				};
			};
				
			class ModuleDescription : ModuleDescription {};
		};
		
		class ModuleDescription : ModuleDescription
		{
			description = "Perimeter Defence. This module must be synced with AR-2 FPV drone(s).";
			direction = 0;
			directionDisabled = "Has no effect";
			directionEnabled = "Affects module function";
			displayName = "";
			duplicate = 1;
			duplicateDisabled = "Only one entity of this type can be synced.";
			duplicateEnabled = "Multiple entities of this type can be synced.";
			icon = "";
			position = 1;
			positionDisabled = "Has no effect";
			positionEnabled = "Affects module function (center point)";
			sync[] = {"B_FPV_AR2", "O_FPV_AR2", "I_FPV_AR2", "fpv_Base_F"}; //All
			vehicle[] = {"B_FPV_AR2", "O_FPV_AR2", "I_FPV_AR2"};
			
			class LocationArea_F
			{
				description[] = { // Multi-line descriptions are supported
					"First line",
					"Second line"
				};
				position = 1;	// Position is taken into effect
				direction = 1;	// Direction is taken into effect
				optional = 1;	// Synced entity is optional
				duplicate = 1;	// Multiple entities of this type can be synced
				synced[] = { "BluforUnit", "AnyBrain" };	// Pre-defined entities like "AnyBrain" can be used (see the table below)
			};

			class BluforUnit
			{
				description = "Short description";
				displayName = "Any BLUFOR unit";	// Custom name
				icon = "iconMan";					// Custom icon (can be file path or CfgVehicleIcons entry)
				side = 1;							// Custom side (determines icon color)
			};
			
		};
		
	}; 
	class EXP_CuratorWarhead_F : EXP_ModuleTemplate_F
	{
		author = "AdequateX";
		_generalMacro = "EXP_CuratorWarhead_F";
		displayName = "FPV Warhead Configurator";				// Name displayed in the menu
		//icon = "\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfoAirRTDFullDigital\digital_compass_plane_ca.paa";	// Map icon. Delete this entry to use the default icon.
		scope = 2;	// Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2;
		curatorCanAttach = 0;	// 1 to allow Zeus to attach the module to an entity
		curatorInfoType = "RscDisplayWarheadConfigurator";   //rsctitle display to open on place or double click (eg. "RscDisplayAttributesModuleObjectiveAttackDefend")
		isGlobal = 0;	// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		is3DEN = 1;		// 1 to run init function in Eden Editor as well
		isDisposable = 0;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation will not work)
		isTriggerActivated = 0;
		category = "Curator";
		portrait = "\a3\Ui_F_Curator\Data\CfgMarkers\minefieldAP_ca.paa";
		function = "EXP_fnc_zeusArmDrone"; // Name of function triggered once conditions are met	
		curatorCost = 1;	
		canSetArea = 0;		
		canSetAreaShape = 0;				// Allows for setting "Rectangle" or "Ellipse" in Attributes menu in 3DEN
		canSetAreaHeight = 0;				// Allows for setting height or Z value in Attributes menu in 3DEN
				
		class AttributeValues
		{
			// This section allows you to set the default values for the attributes menu in 3DEN
			//size3[] = { 50, 50, -1 };		// 3D size (x-axis radius, y-axis radius, z-axis radius)
			//isRectangle = 0;				// Sets if the default shape should be a rectangle or ellipse
		};
		
		class Attributes: AttributesBase 
		{
			
			class DroneSide : Combo
			{
				property = "EXP_ModuleDefence_DroneSide";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Drone's faction:";			// Argument label
				tooltip = "What side is the drone?";	// Tooltip description
				typeName = "STRING";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultvalue = 0;	
				control = "Combo";
				expression = "_this setVariable ['%s',_value, true];";
				class Values 
				{
					class WEST {name = "Blufor / West"; value = "B";};
					class EAST {name = "Opfor / East"; value = "O";};
					class INDEP {name = "Independant / Guerilla"; value = "I";};
				};
			};
			
			class DroneCount 
			{
				displayName = "Drone(s) to create:";			// Argument label
				tooltip = "";	// Tooltip description
				property = "EXP_ModuleDefence_DroneCount";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				control = "DroneCount";
				typeName = "NUMBER";
				expression = "_this setVariable ['%s',_value,true];";
				// Value type, can be "NUMBER", "STRING" or "BOOL"
				value = "1.00"; //10
				defaultValue = "1.00"; //10
			};
			
			class WarheadSelector 
			{
				displayName = "Warhead Type:";			// Argument label
				tooltip = "Choose which warhead to arm the drones with";	// Tooltip description
				property = "EXP_ModuleDefence_WarheadSelector";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				control = "WarheadSelector";
				typeName = "STRING";
				expression = "_this setVariable ['%s',_value,true];";
				// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "0"; //10
		
			};
				
			
		};
		
		class ModuleDescription : ModuleDescription
		{
			description = "AR-2 FPV drone configurator and spawner.";
			direction = 0;
			directionDisabled = "Has no effect";
			directionEnabled = "Affects module function";
			displayName = "";
			duplicate = 1;
			duplicateDisabled = "Only one entity of this type can be synced.";
			duplicateEnabled = "Multiple entities of this type can be synced.";
			icon = "";
			position = 1;
			positionDisabled = "Has no effect";
			positionEnabled = "Affects module function (center point)";
			sync[] = {}; //All
			vehicle[] = {};
			
			class LocationArea_F
			{
				description[] = { // Multi-line descriptions are supported
					"First line",
					"Second line"
				};
				position = 1;	// Position is taken into effect
				direction = 0;	// Direction is taken into effect
				optional = 0;	// Synced entity is optional
				duplicate = 0;	// Multiple entities of this type can be synced
				synced[] = {"AnyBrain"};	// Pre-defined entities like "AnyBrain" can be used (see the table below)
			};		
		};
	};



};

///////////////////// 3DEN ///////////////////
class ctrlCombo;
class Cfg3DEN
{
	class Attributes
	{
		class Default;
		class Title: Default
		{
			class Controls
			{
				class Title;
			};
		};

 		class Combo: Title 
		{
			attributeLoad = "		comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';		_ctrlCombo = _this controlsGroupCtrl 100;		_cfgValues = _config >> 'Values';		if (isclass _cfgValues) then {			{				_lbadd = _ctrlCombo lbadd gettext (_x >> 'name');				if (isnumber (_x >> 'value')) then {					_valueConfig = getnumber (_x >> 'value');					_ctrlCombo lbsetdata [_lbadd,str _valueConfig];					_ctrlCombo lbsetvalue [_lbadd,_valueConfig];				} else {					_ctrlCombo lbsetdata [_lbadd,gettext (_x >> 'value')];				};				_ctrlCombo lbsetpicture [_lbadd,gettext (_x >> 'picture')];				_ctrlCombo lbsetpictureright [_lbadd,gettext (_x >> 'pictureRight')];				_ctrlCombo lbsettooltip [_lbadd,gettext (_x >> 'tooltip')];				if (getnumber (_x >> 'default') > 0) then {_ctrlCombo lbsetcursel _lbadd;};			} foreach configproperties [_cfgValues,'isclass _x'];		};		if (lbsize _ctrlCombo == 0) then {			{				_lbAdd = _ctrlCombo lbadd _x;				_ctrlCombo lbsetvalue [_lbAdd,1 - _foreachindex];				_ctrlCombo lbsetdata [_lbAdd,str (1 - _foreachindex)];			} foreach [localize 'str_enabled',localize 'str_disabled'];		};		if (_value isequaltype true) then {			_value = parseNumber _value;		} else {			if (_value isequaltype '') then {_value = tolower _value;};		};		for '_i' from 0 to (lbsize _ctrlCombo - 1) do {			if (_value in [parsenumber (_ctrlCombo lbdata _i),tolower (_ctrlCombo lbdata _i),_ctrlCombo lbvalue _i]) exitwith {_ctrlCombo lbsetcursel _i;};		};	";
			attributeSave = "		comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';		_ctrlCombo = _this controlsGroupCtrl 100;		switch toupper gettext (_config >> 'typeName') do {			case 'NUMBER': {				_returnData = parsenumber (_ctrlCombo lbdata lbcursel _ctrlCombo);				_returnValue = _ctrlCombo lbvalue lbcursel _ctrlCombo;				if (round _returnData != _returnValue) then {_returnData = _returnValue;};				_returnData			};			case 'BOOL': {				[false,true] select ((parsenumber (_ctrlCombo lbdata lbcursel _ctrlCombo)) max 0 min 1)			};			default {_ctrlCombo lbdata lbcursel _ctrlCombo};		};	";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: ctrlCombo
				{
					idc = 100;
					x = "48 * (pixelW * pixelGrid * 	0.50)";
					w = "82 * (pixelW * pixelGrid * 	0.50)";
					h = "5 * (pixelH * pixelGrid * 	0.50)";
					colorTextRight[] = {1,1,1,0.5};
					colorSelectRight[] = {0,0,0,0.5};
					onLoad = "				comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';				_control = _this select 0;				_config = _this select 1;				_configItems = _config >> 'itemsconfig';				if (isclass _configItems) then {					_pathRoots = if (getnumber (_configItems >> 'localConfig') > 0) then {[configfile,campaignconfigfile,missionconfigfile]} else {[configfile]};					_paths = [];					{						_path = _x;						{_path = _path >> _x;} foreach getarray (_configItems >> 'path');						_paths pushback _path;					} foreach _pathRoots;					_propertyText = gettext (_configItems >> 'propertyText');					_propertyTextRight = gettext (_configItems >> 'propertyTextRight');					_propertyColor = gettext (_configItems >> 'propertyColor');					_propertyPicture = gettext (_configItems >> 'propertyPicture');					_tooltip = gettext (_configItems >> 'tooltip');					if (_tooltip == '') then {_tooltip = '%1\n%2';};					_sort = getnumber (_configItems >> 'sort');					{						{							_text = gettext (_x >> _propertyText);							if (_text != '') then {								_lbadd = _control lbadd _text;								_control lbsetdata [_lbadd,configname _x];								if (_propertyPicture != '') then {_control lbsetpicture [_lbadd,gettext (_x >> _propertyPicture)];};								if (_propertyTextRight != '') then {_control lbsettextright [_lbadd,gettext (_x >> _propertyTextRight)];};								_control lbsettooltip [_lbadd,format [_tooltip,_control lbtext _lbadd,_control lbdata _lbadd]];								_dlcLogo = if (configsourcemod _x == '') then {''} else {modParams [configsourcemod  _x,['logo']] param [0,'']};								if (_dlcLogo != '') then {_control lbsetpictureright [_lbadd,_dlcLogo];};							};						} foreach configproperties [_x,'isclass _X'];					} foreach _paths;					if (_sort > 1) then {lbsortbyvalue _control} else {if (_sort > 0) then {lbsort _control};};				};			";
				};
			};		
		};
		class Slider: Title
		{
			class Controls: Controls
			{
				class Title;
				class Value;
				class Edit;
			};
		};
	
		class DroneDetection: Slider
		{
			onLoad = "		comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';		_ctrlGroup = _this select 0;		[_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;	";
			attributeLoad = "		comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';		_ctrlGroup = _this;		[_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;	";
			expression = "_this setVariable ['%s',_value,true];";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: Value
				{
					
					sliderStep = 0.05;
					sliderRange[] = {0,5};	
					sliderPosition = 8;
					lineSize = 1;
				};
				class Edit: Edit{};
			};
		};
		class DroneCount: Slider
		{
			onLoad = "		comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';		_ctrlGroup = _this select 0;		[_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,''] call bis_fnc_initSliderValue;	";
			attributeLoad = "		comment 'DO NOT COPY THIS CODE TO YOUR ATTRIBUTE CONFIG UNLESS YOU ARE CHANGING SOMETHING IN THE CODE!';		_ctrlGroup = _this;		[_ctrlGroup controlsgroupctrl 100,_ctrlGroup controlsgroupctrl 101,'',_value] call bis_fnc_initSliderValue;	";
			expression = "_this setVariable ['%s',_value,true];";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: Value
				{
					
					sliderStep = 1;
					sliderRange[] = {1,10};	
					sliderPosition = 1;
					lineSize = 2;
				};
				class Edit: Edit{};
			};
		};
		
 		class WarheadSelector : Combo
		{
			//attributeSave = "_ctrlCombo = _this controlsGroupCtrl 100; (_ctrlCombo lbdata lbcursel _ctrlCombo)";
			class Controls: Controls
			{
				class Title: Title{};
				class Value: ctrlCombo
				{ 
					idc = 100;
					x = "48 * (pixelW * pixelGrid * 	0.50)";
					w = "82 * (pixelW * pixelGrid * 	0.50)";
					h = "5 * (pixelH * pixelGrid * 	0.50)";
					//colorTextRight[] = {1,1,1,0.5};
					//colorSelectRight[] = {0,0,0,0.5};
					onLoad ="_control = _this select 0; _ClassTypes = ['CA_LauncherMagazine', 'ATMine_Range_Mag','SatchelCharge_Remote_Mag','ClaymoreDirectionalMine_Remote_Mag','rhssaf_tm100_mag','rhs_rpg26_mag','rhs_rpg75_mag'];	_WarheadList = ""901 in (getArray( _x >> 'allowedSlots'))"" configClasses (configFile >> 'CfgMagazines');		_WarheadList = _WarheadList apply {configName _x;}; 	_WarheadList deleteAt (_WarheadList find 'CA_LauncherMagazine');	{	_currentMag = _x;		{				if (_currentMag isKindOf [_x , configFile >> 'CfgMagazines']) then { 		_lbadd = _control lbadd gettext (configFile >> 'CfgMagazines' >> _currentMag >> 'displayname');	_control lbsetdata [_lbadd, _currentMag];	_control lbsetpicture [_lbadd,gettext (configFile >> 'CfgMagazines' >> _currentMag >> 'picture')];		};			} forEach _ClassTypes;		} forEach _WarheadList;"; 	
				};
			};		
		};
		
	};	
};


/*
 					_control = _this select 0;
					_ClassTypes = ['CA_LauncherMagazine', 'ATMine_Range_Mag','SatchelCharge_Remote_Mag','ClaymoreDirectionalMine_Remote_Mag','rhssaf_tm100_mag','rhs_rpg26_mag','rhs_rpg75_mag'];
					_WarheadList = "901 in (getArray( _x >> 'allowedSlots'))" configClasses (configFile >> "CfgMagazines");
					_WarheadList = _WarheadList apply {configName _x;};
					_WarheadList deleteAt (_WarheadList find "CA_LauncherMagazine");
					{
						_currentMag = _x;
						{
							if (_currentMag isKindOf [_x , configFile >> "CfgMagazines"]) then 
							{ 
								_lbadd = _control lbadd gettext (configFile >> 'CfgMagazines' >> _currentMag >> 'displayname');
								_control lbsetdata [_lbadd, _currentMag];						
								_control lbsetpicture [_lbadd,gettext (configFile >> 'CfgMagazines' >> _currentMag >> 'picture')];
							};
						} forEach _ClassTypes;	
					} forEach _WarheadList; 
*/														

///onLoad ="_control = _this select 0; _ClassTypes = ['CA_LauncherMagazine', 'ATMine_Range_Mag','SatchelCharge_Remote_Mag','ClaymoreDirectionalMine_Remote_Mag','rhssaf_tm100_mag','rhs_rpg26_mag','rhs_rpg75_mag'];	_WarheadList = ""901 in (getArray( _x >> 'allowedSlots'))"" configClasses (configFile >> 'CfgMagazines');		_WarheadList = _WarheadList apply {configName _x;}; 	_WarheadList deleteAt (_WarheadList find 'CA_LauncherMagazine');	{	_currentMag = _x;		{				if (_currentMag isKindOf [_x , configFile >> 'CfgMagazines']) then { 		_lbadd = _control lbadd gettext (configFile >> 'CfgMagazines' >> _currentMag >> 'displayname');	_control lbsetdata [_lbadd, _currentMag];	_control lbsetpicture [_lbadd,gettext (configFile >> 'CfgMagazines' >> _currentMag >> 'picture')];		};			} forEach _ClassTypes;		} forEach _WarheadList;"; 	
 	





//enableDebugConsole = 2; ///FOR TESTING ONLY DELETE OR COMMENT OUT AFTER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!