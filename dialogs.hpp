/* class munition_Selector
{
	idd = 1115;
	movingEnabled = false;
	class controls
	{
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

	};
}; */
class munition_Selector
{
	idd = 1115;
	movingEnable = false;
	
	class ControlsBackground
	{
		class Background_texture : RscPicture
		{
			type = 0;
			idc = 2000;
			x = safeZoneX + safeZoneW * 0.25;
			y = safeZoneY + safeZoneH * 0.25;
			w = safeZoneW * 0.5;
			h = safeZoneH * 0.5;
			style = 80;
			text = "";
			colorBackground[] = {0.1477,0.1832,0.2295,1};
			colorText[] = {0.4,0.4,0.4,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			blinkingPeriod = 0;
			shadow = 0;
			
		};
				
		class Background : RscPicture
		{
			type = 0;
			idc = 2001;
			x = safeZoneX + safeZoneW * 0.2609375;
			y = safeZoneY + safeZoneH * 0.25925926;
			w = safeZoneW * 0.48020834;
			h = safeZoneH * 0.47962963;
			style = 64;
			text = "Warhead Configurator";
			colorBackground[] = {0,0,0,0};
			colorText[] = {0.702,0.702,0.702,1};
			font = "TahomaB";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.25);
			shadow = 2;
			
		};
		
	};
	class Controls
	{
		class munitions_progressBar : RscProgress
		{
			type = 8;
			idc = 3000;
			x = safeZoneX + safeZoneW * 0.44479167;
			y = safeZoneY + safeZoneH * 0.30925926;
			w = safeZoneW * 0.1375;
			h = safeZoneH * 0.01481482;
			style = 0;
			colorBar[] = {0.3121,0.4405,0.4672,1};
			colorFrame[] = {0.702,0.702,0.702,1};
			texture = "#(argb,8,8,3)color(1,1,1,1)";
			
		};
		class munitions_massText : RscText
		{
			type = 0;
			idc = 1100;
			x = safeZoneX + safeZoneW * 0.45104167;
			y = safeZoneY + safeZoneH * 0.275;
			w = safeZoneW * 0.125;
			h = safeZoneH * 0.02222223;
			style = 2;
			text = "Maximum payload weight %";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {0.902,0.902,0.902,1};
			font = "PuristaLight";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			shadow = 0;
			
		};	
		
		class munitions_warheadPicture : RscPicture
		{
			idc = 1201;
			x = safeZoneX + safeZoneW * 0.32239584;
			y = safeZoneY + safeZoneH * 0.40925926;
			w = safeZoneW * 0.22916667;
			h = safeZoneH * 0.28333334;
			text = "";
			//colorBackground[] = {0.0953,0.12,0.2172,1};
			//colorText[] = {0.1451,0.3059,0.3216,1};
			//font = "PuristaMedium";
			//sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			//shadow = 0;
			
		};
		class munitions_dropTEXT : RscText 
		{
			type = 0;
			idc = 2801;
			x = safeZoneX + safeZoneW * 0.45052084;
			y = safeZoneY + safeZoneH * 0.3425;
			w = safeZoneW * 0.08489584;
			h = safeZoneH * 0.04351852;
			style = 2;
			text = ": DROP MODE :";
			borderSize = 0;
			colorText[] = {0.902, 0.902, 0.902, 1};
			colorBackground[] = {0.2,0.2,0.2,1};
			font = "PuristaMedium";
			shadow = 0;		
		};
		class munitions_dropCheck : RscCheckBox 
		{
			type = 77;
			idc = 2800;
			checked = 0;
			x = safeZoneX + safeZoneW * 0.5375;
			y = safeZoneY + safeZoneH * 0.3425;
			w = safeZoneW * 0.02552084;
			h = safeZoneH * 0.04351852;
			tooltip = "Drone will drop the explosive instead of manual detonation";
			borderSize = 0;
			color[] = {1,1,1,0.7};
			colorPressed[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			colorBackgroundFocused[] = {0,0,0,0};
			colorBackgroundHover[] = {0,0,0,0};
			colorBackgroundPressed[] = {0,0,0,0};
			colorBackgroundDisabled[] = {0,0,0,0};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			shadow = 0;		
		};
		class munitions_confirmButton : RscButton 
		{
			type = 1;
			idc = 1600;
			x = 0.020000;
			y = 0.13;
			w = 0.1;
			h = 0.1;
			style = 2;
			text = "Confirm";
			borderSize = 0;
			colorBackground[] = {0.1613,0.3484,0.1613,1};
			colorBackgroundActive[] = {0,1,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0,1,0,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",1.0,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",1.0,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",1.0,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",1.0,1.0};
			shadow = 0;
			tooltip = "Can only be confirmed once";
			
		};
		class munitions_cancelButton : RscButton 
		{
			type = 1;
			idc = 1601;
			x = 0.190;
			y = 0.13;
			w = 0.1;
			h = 0.1;
			style = 2;
			text = "Cancel";
			borderSize = 0;
			colorBackground[] = {0.3484,0.1599,0.1599,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {1,0,0,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",1.0,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",1.0,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",1.0,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",1.0,1.0};
			tooltip = "Can re-add warhead later";
			shadow = 0;
			
		};
		class munitions_ListBox : RscListBox 
		{
			type = 5;
			idc = 1500;
			x = safeZoneX + safeZoneW * 0.59270834;
			y = safeZoneY + safeZoneH * 0.275;
			w = safeZoneW * 0.11145834;
			h = safeZoneH * 0.46203704;
			style = 16;
			colorBackground[] = {1,1,1,0.75};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			maxHistoryDelay = 0;
			rowHeight = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
			colorSelectBackground[] = {0.3121,0.4405,0.4672,1};
			colorSelectBackground2[] = {0.75,0.75,0.75,1};
			class ListScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
	
	};
	
};








class target_Override
{
	idd = 1116;
	movingEnabled = false;	
	class ControlsBackground
	{
		class background_trim : RscPicture 
		{
			type = 0;
			idc = 0;
			x = safeZoneX + safeZoneW * 0.35989584;
			y = safeZoneY + safeZoneH * 0.38425926;
			w = safeZoneW * 0.28541667;
			h = safeZoneH * 0.24814815;
			style = 0;
			text = "";
			colorBackground[] = {0.102,0.102,0.102,1};
			colorText[] = {0.302,0.4,0.8,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			moving = false;
			shadow = 2;
			
		};
		class background : RscPicture 
		{
			type = 0;
			idc = 0;
			x = safeZoneX + safeZoneW * 0.36458334;
			y = safeZoneY + safeZoneH * 0.39814815;
			w = safeZoneW * 0.27447917;
			h = safeZoneH * 0.22314815;
			style = 0;
			text = "";
			colorBackground[] = {0.6,0.6,0.6,0.7};
			colorText[] = {0.302,0.4,0.8,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			moving = false;
			shadow = 2;
			
		};
		class lower_background : RscPicture 
		{
			type = 0;
			idc = 0;
			x = safeZoneX + safeZoneW * 0.36927084;
			y = safeZoneY + safeZoneH * 0.55277778;
			w = safeZoneW * 0.26510417;
			h = safeZoneH * 0.06388889;
			style = 0;
			text = "";
			colorBackground[] = {0.2,0.2,0.2,1};
			colorText[] = {0.302,0.4,0.8,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			moving = false;
			shadow = 2;
			
		};
		
	};
	class Controls
	{
		class confirmButton: RscButton
		{
			type = 1;
			idc = 1101;
			x = safeZoneX + safeZoneW * 0.375;
			y = safeZoneY + safeZoneH * 0.56;
			w = safeZoneW * 0.0546875;
			h = safeZoneH * 0.04444445;
			style = 2;
			text = "Confirm";
			borderSize = 0;
			colorBackground[] = {0.41,0.89,0.41,1};
			colorBackgroundActive[] = {0,1,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			colorFocused[] = {0,1,0,1};
			font = "PuristaLight";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		
				
		class CancelButton: RscButton
		{
			idc = 1102;
			x = safeZoneX + safeZoneW * 0.575;
			y = safeZoneY + safeZoneH * 0.56;
			w = safeZoneW * 0.0546875;
			h = safeZoneH * 0.04444445;
			style = 2;
			text = "Cancel";
			borderSize = 0;
			colorBackground[] = {0.89,0.41,0.41,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			colorFocused[] = {1,0,0,1};
			font = "PuristaLight";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		class targetType : RscListBox 
		{
			type = 5;
			idc = 1100;
			x = safeZoneX + safeZoneW * 0.371875;
			y = safeZoneY + safeZoneH * 0.40555556;
			w = safeZoneW * 0.2609375;
			h = safeZoneH * 0.14166667;
			style = 0;
			colorBackground[] = {0.302,0.302,0.302,1};
			colorDisabled[] = {0,0,0,1};
			colorSelect[] = {0.502,0.702,0.502,1};
			colorSelect2[] = {0.502,0.702,0.502,1};
			colorText[] = {1,1,1,1};
			font = "TahomaB";
			maxHistoryDelay = 0;
			rowHeight = 0.06;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
			blinkingPeriod = 0;
			colorSelectBackground[] = {0.2,0.2,0.2,1};
			colorSelectBackground2[] = {0,0,0,1};
			onMouseButtonClick = "";
			period = 1;
			shadow = 0;
			tooltipColorBox[] = {0.4,0.4,0.4,1};
			tooltipColorText[] = {1,0.5,0,1};
			class ListScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			class Items
			{
				class Man
				{
					text = "Soldiers / Infrantry";
					tooltip = "Default: (Tanks / IFVs)";
					//picture = "\A3\ui_f\data\map\vehicleicons\iconManAT_ca.paa";
					picture = "\A3\ui_f_curator\data\RscCommon\RscAttributeSpeedMode\normal_ca.paa";
					data = "Man";
					value = 0;
					default = 0;
				};
				class Truck
				{
					text = "Trucks / Cars / MRAPs";
					tooltip = "Default: (Tanks / IFVs)";
					picture = "\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_hmg_F_ca.paa";
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
		
	};
	
};




// Target override 
/* class target_Override
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
					data = "Man";
					value = 0;
					default = 0;
				};
				class Truck
				{
					text = "Trucks / Cars / MRAPs";
					tooltip = "Default: (Tanks / IFVs)";
					picture = "\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_hmg_F_ca.paa";
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
	
}; */


//custom hud Here, no different than GUI^^ but with updating elements.
// class RscTitles {};
/* 	class RscFpv_HUD
	{
		movingEnabled = false;
		idd = 1117;
		duration = 1801;
	}; */
	
class RscDisplayWarheadConfigurator
{
	idd = 1117;
	movingEnabled = false;
	
	class ControlsBackground
	{
		class Background_texture : RscPicture
		{
			type = 0;
			idc = 2000;
			x = safeZoneX + safeZoneW * 0.25;
			y = safeZoneY + safeZoneH * 0.25;
			w = safeZoneW * 0.5;
			h = safeZoneH * 0.5;
			style = 80;
			text = "";
			colorBackground[] = {0.1477,0.1832,0.2295,1};
			colorText[] = {0.4,0.4,0.4,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			blinkingPeriod = 0;
			shadow = 0;
			
		};
		class Background : RscPicture
		{
			type = 0;
			idc = 2001;
			x = -0.07808079;
			y = 0.06228957;
			w = 1.15151516;
			h = 0.86363637;
			style = 64; //+192+2
			text = "Drone Configurator";
			colorBackground[] = {0,0,0,0};
			colorText[] = {0.702,0.702,0.702,1};
			font = "TahomaB";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.25);
			moving = false;
			shadow = 1;
			
		};
		
	};
	class Controls
	{

		class DroneCount : RscXSliderH
		{
			type = 43;
			idc = 1502;
			x = safeZoneX + safeZoneW * 0.45;
			y = safeZoneY + safeZoneH * 0.35;
			w = safeZoneW * 0.125;
			h = safeZoneH * 0.025;
			style = 1024;
			arrowEmpty = "\A3\ui_f\data\GUI\Cfg\Slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\Cfg\Slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\GUI\Cfg\Slider\border_ca.paa";
			color[] = {0.502,0.702,0.502,1};
			colorActive[] = {0.502,0.702,0.502,1};
			thumb = "\A3\ui_f\data\GUI\Cfg\Slider\thumb_ca.paa";
			sliderRange[] = {1, 5};
			sliderStep = 1.0;
			sliderPosition = 1;
			
		};
		class SideSelector : RscCombo
		{
			type = 4;
			idc = 1501;
			x = safeZoneX + safeZoneW * 0.45;
			y = safeZoneY + safeZoneH * 0.285;
			w = safeZoneW * 0.125;
			h = safeZoneH * 0.03;
			style = 16+192;
			arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_active_ca.paa";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorDisabled[] = {0,0,0,0};
			colorSelect[] = {0.702,0.902,0.902,1};
			colorSelectBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {0.702,0.902,0.902,1};
			font = "TahomaB";
			maxHistoryDelay = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",1.0,1.0};
			soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",1.0,1.0};
			soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",1.0,1.0};
			wholeHeight = .2;
			shadow = 1;
			class ComboScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
		class DescriptionText : RscText
		{
			type = 0;
			idc = 1503;
			x = safeZoneX + safeZoneW * 0.435;
			y = safeZoneY + safeZoneH * 0.370;
			w = safeZoneW * 0.15;
			h = safeZoneH * 0.0275;
			style = 2;
			text = "FPV Drones: Count ";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaSemiBold";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.95);
			shadow = 1;
			
		};
		class munitions_confirmButton : RscButton 
		{
			type = 1;
			idc = 1600;
			x = 0.020000;
			y = 0.13;
			w = 0.1;
			h = 0.1;
			style = 2;
			text = "Confirm";
			borderSize = 0;
			colorBackground[] = {0.1613,0.3484,0.1613,1};
			colorBackgroundActive[] = {0,1,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0,1,0,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",1.0,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",1.0,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",1.0,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",1.0,1.0};
			tooltip = "Confirm to Place FPV drone with selected warhead";
			
		};
		class munitions_ListBox : RscListBox 
		{
			type = 5;
			idc = 1500;
			x = safeZoneX + safeZoneW * 0.6;
			y = safeZoneY + safeZoneH * 0.285;
			w = safeZoneW * 0.125;
			h = safeZoneH * 0.425;
			style = 16;
			colorBackground[] = {1,1,1,0.75};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			maxHistoryDelay = 0;
			rowHeight = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
			colorSelectBackground[] = {0.3121,0.4405,0.4672,1};
			colorSelectBackground2[] = {0.75,0.75,0.75,1};
			class ListScrollBar
			{
				color[] = {0.2, 0.4, 0.4, 1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
		class munitions_cancelButton : RscButton 
		{
			type = 1;
			idc = 1601;
			x = 0.190;
			y = 0.13;
			w = 0.1;
			h = 0.1;
			style = 2;
			text = "Cancel";
			borderSize = 0;
			colorBackground[] = {0.3484,0.1599,0.1599,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.9,0,0,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {0,0,0,1};
			font = "PuristaMedium";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",1.0,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",1.0,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",1.0,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",1.0,1.0};
			tooltip = "";		
		};	
		class munitions_warheadPicture : RscPicture
		{
			idc = 1200;
			x = 0.07000043;
			y = 0.33500033;
			w = 0.55500006;
			h = 0.51500006;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
	};	
};