class munition_Selector
{
	idd = 1115;
	movingEnabled = false;
	//onKeyDown = "(_this select 1) == 1";
	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Adequate, v1.063, #Nyzycy)
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
		class munitions_confirmButton: RscButton
		{
			idc = 1600;
			text = "Confirm"; //--- ToDo: Localize;
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
			tooltip = "Drone will drop the explosive instead of manual detonation"; //--- ToDo: Localize;
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
			y = 0.30 * safezoneH + safezoneY;
			w = 0.125 * safezoneW;
			h = 0.0225 * safezoneH;
			style = 2;
			font = "PuristaLight";
			text = "Maximum payload weight %";
			colorBackground[] = {0.2,0.2,0.2,1};
			colorText[] = {0.4,0.502,0.902,1};
			shadow = 1;		
		};
		
		class munitions_warheadPicture: RscPicture
		{
			idc = 1201;
			x = 0.3970 * safezoneW + safezoneX;
			y = 0.375 * safezoneH + safezoneY;
			w = 0.134 * safezoneW;
			h = 0.2 * safezoneH;
			text = "";		
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

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
