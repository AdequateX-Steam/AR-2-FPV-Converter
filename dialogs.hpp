class munition_Selector
{
	idd = 1115;
	movingEnabled = false;
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by AdequateX, v1.063, #Nyzycy)
		////////////////////////////////////////////////////////

		class munitions_pictureBackground: RscPicture
		{
			idc = 1200;
			text = "#(argb,8,8,3)color(1,1,1,0.65)";
			x = 0.324687 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.340312 * safezoneW;
			h = 0.418 * safezoneH;
			colorBackground[] = {0,0,0,0.35};
		};
		class munitions_pictureBorder : RscPicture 
		{
			type = 0;
			idc = 1210;
			x = 0.324687 * safezoneW + safezoneX;//
			y = 0.2805 * safezoneH + safezoneY;//
			w = 0.34125 * safezoneW; //
			h = 0.4305 * safezoneH;  //
			style = 64;
			colorBackground[] = {0,0,0,1};
			colorText[] = {0.10, 0.85, 0.10, 1};
			text = "Explosives";
			font = "PuristaBold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			shadow = 2;		
		};
		class munitions_confirmButton: RscButton
		{
			idc = 1600;
			text = "Confirm"; 
			x = 0.335 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.055 * safezoneH;
			style = 2; /////
			font = "PuristaLight";
			tooltip = "Can only be confirmed once";
			colorBackground[] = {0.41,0.89,0.41,1}; //{0,0.7,0,0.6}
			colorBackgroundActive[] = {0,1,0,1};
			colorText[] = {0,0,0,1};
			colorFocused[] = {0,1,0,1};
			
		};
		class munitions_ListBox: RscListbox
		{
			idc = 1500;
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.374 * safezoneH;
			colorText[] = {0,0,0,1};
			colorSelect[] = {0,0,0,1};
			colorSelectBackground[] = {0.31,0.44,0.46,1}; //{0,0.8,0.8,1}
			colorSelectBackground2[] = {0.75,0.75,0.75,1};
			colorBackground[] = {1,1,1,0.85};
		};
		class munitions_CancelButton: RscButton
		{
			idc = 1601;
			text = "Cancel"; 
			x = 0.335 * safezoneW + safezoneX;
			y = 0.632 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.055 * safezoneH;
			style = 2; ///////
			font = "PuristaLight";
			tooltip = "Can re-add warhead later";
			colorBackground[] = {0.89,0.41,0.41,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorText[] = {0,0,0,1};
			colorFocused[] = {1,0,0,1};
			
		};
		class munitions_dropCheck: RscCheckbox
		{
			idc = 2800;
			text = "Droppable"; //--- ToDo: Localize;
			x = 0.515469 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Drone will drop the explosive instead of manual detonation";
			color[] = {1,1,1,1};
			colorHover[] = {0,0.8,0.8,1};
			colorBackground[] = {0,0,0,0.7};
			colorBackgroundHover[] = {0,0,0,0.7};
			colorFocused[] = {1,1,1,1};
			colorBackgroundFocused[] = {0,0,0,0.7};
			colorPressed[] = {0,0.8,0.8,1}; //only when mouse button is down
			colorBackgroundPressed[] = {0,0,0,0.7}; //only when mouse button is down
		};
		
		class munitions_progressBar: RscProgress
		{
			idc = 3000;
			x = 0.395 * safezoneW + safezoneX;
			y = 0.334 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.015 * safezoneH;
			style = 0;
			colorBar[] = {0.3121,0.4405,0.4672,1};
			colorFrame[] = {0.702,0.702,0.702,1};
			//texture = "#(argb,8,8,3)color(1,1,1,1)";			
		};
		
		class munitions_massText: RscText
		{
			idc = 1100;
			x = 0.401 * safezoneW + safezoneX;
			y = 0.3 * safezoneH + safezoneY; //0.30
			w = 0.125 * safezoneW;
			h = 0.0225 * safezoneH;
			style = 2;
			font = "PuristaLight";
			text = "Maximum payload weight %:";
			colorBackground[] = {0.2,0.2,0.2,1};
			colorText[] = {0.4,0.502,0.902,1};
			shadow = 1;		
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);

		};
		
		class munitions_warheadPicture: RscPicture
		{
			idc = 1201;
			x = 0.3970 * safezoneW + safezoneX;
			y = 0.40 * safezoneH + safezoneY; //0.375
			w = 0.134 * safezoneW;
			h = 0.2 * safezoneH;
			text = "";		
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

	};
};

// Target override 
class target_Override
{
	idd = 1116;
	movingEnabled = false;
	class ControlsBackground
	{
			
		class background : RscPicture 
		{
			idc = -1;
			x = 0.324687 * safezoneW + safezoneX;;
			y = 0.291 * safezoneH + safezoneY;;
			w = 0.340312 * safezoneW;;
			h = 0.418 * safezoneH;;
			style = 0;
			text = "";
			colorBackground[] = {0.6,0.6,0.6,0.7};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		
		class munitions_pictureBorder : RscPicture 
		{
			type = -1;
			idc = 1210;
			x = 0.324687 * safezoneW + safezoneX;//
			y = 0.2805 * safezoneH + safezoneY;//
			w = 0.34125 * safezoneW; //
			h = 0.4305 * safezoneH;  //
			style = 64;
			colorBackground[] = {0,0,0,1};
			colorText[] = {0.85, 0.10, 0.10, 1};
			text = "Target type override";
			font = "PuristaBold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			shadow = 2;		
		};
		
	};
	class Controls
	{
		class targetType : RscListBox 
		{
			type = 5;
			idc = 1100;
			x = safeZoneX + safeZoneW * 0.33854167;
			y = safeZoneY + safeZoneH * 0.42222223;
			w = safeZoneW * 0.3125;
			h = safeZoneH * 0.15555556;
			colorBackground[] = {0.2,0.2,0.2,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {1,0,0,1};
			colorText[] = {0.902,0.902,0.902,1};
			font = "TahomaB";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.6);
			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
			blinkingPeriod = 0;
			colorSelect2[] = {1,0,0,1};
			colorSelectBackground[] = {0.2,0.302,0.702,1};
			colorSelectBackground2[] = {0.4,0.4,0.519,1};
			onMouseButtonClick = "";
			period = 1;
			shadow = 1;
			tooltipColorBox[] = {0.4,0.4,0.4,1};
			tooltipColorText[] = {1,0.5,0,1};
			class Items
			{
				class Man
				{
					text = "Soldiers / Infrantry";
					tooltip = "Default: (Tanks / IFVs)";
					picture = "\A3\ui_f\data\map\vehicleicons\iconManAT_ca.paa";
					//pictureRight = "\a3\Ui_f\data\Map\Markers\Military\unknown_CA.paa";
/* 					color[] = {1,0,1,1};
					colorRight[] = {1,1,0,1};
					colorPicture[] = {0,1,1,1};
					colorPictureSelected[] = {1,0,0,1};
					colorPictureDisabled[] = {0,0,0,1};
					colorPictureRight[] = {0,1,0,1};
					colorPictureRightSelected[] = {0,0,1,1};
					colorPictureRightDisabled[] = {0,0,0,1}; */
					data = "Man";
					value = 0;
					default = 0;
				};
				class Truck
				{
					text = "Trucks / Cars / MRAPs";
					tooltip = "Default: (Tanks / IFVs)";
					picture = "\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_hmg_F_ca.paa";
					//pictureRight = "\a3\Ui_f\data\Map\Markers\Military\unknown_CA.paa";
					data = "CAR";
					value = 1;
					default = 1;
				};
				class Apc
				{
					text = "Wheeled APCs";
					tooltip = "Default: (Tanks / IFVs)";
					picture = "\A3\Armor_F_Beta\APC_Wheeled_02\Data\UI\APC_Wheeled_02_RCWS_CA.paa";
					data = "Wheeled_APC_F";
					value = 2;
					default = 2;
				};
				class Tank
				{
					text = "Tanks / IFVs";
					tooltip = "Default: (Tanks / IFVs)";
					picture = "\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa";
					data = "Tank";
					value = 3;
					default = 3;
				};
			};	
		};
		class confirmButton: RscButton
		{
			idc = 1101;
			text = "Confirm"; 
			x = 0.335 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.055 * safezoneH;
			style = 2; 
			font = "PuristaLight";
			tooltip = "";
			colorBackground[] = {0.41,0.89,0.41,1};
			colorBackgroundActive[] = {0,1,0,1};
			colorText[] = {0,0,0,1};
			colorFocused[] = {0,1,0,1};		
		};
		
		class CancelButton: RscButton
		{
			idc = 1102;
			text = "Cancel"; 
			x = 0.335 * safezoneW + safezoneX;
			y = 0.632 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.055 * safezoneH;
			style = 2; 
			font = "PuristaLight";
			tooltip = "";
			colorBackground[] = {0.89,0.41,0.41,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorText[] = {0,0,0,1};
			colorFocused[] = {1,0,0,1};			
		};

		
	};
	
};


//custom hud Here, no different than GUI^^ but with updating elements.
class RscTitles
{
	class RscFpv_HUD
	{
		movingEnabled = false;
		idd = 1116;
		duration = 1801;
	};
};
