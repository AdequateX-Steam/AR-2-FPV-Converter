params["_warhead"];
_maxMass = 300; //adjust this setting for the maximum allowable Mass desired

/* Mass of vanilla A3 explosives
	Titan AA/AT, vorona heat+he = 100
	satchel, nlaw, IED big, AT mine = 80
	titan ap, rpg 32 heat, maaws 75, apers dispenser = 60
	maaws 55 = 50
	rpg32 he, rpg7, maaws he, IED small = 40
	slam, demo charge, claymore, apers tripwire, apers bounding = 20
	grenade, apers step mine = 10
	
RHS:

fgm 148 javelin = 286.88
fgm 172 sraw = 140.8
fim 92 stinger = 120
igla 9k32 & 38 = 100
m80 = 31.24
ec 75 = 10.45
ec 200 = 13.2
ec 400 = 17.6
m2 tet = 25
maaws he = 68.36
	heat = 88.2
	hedp = 72.77
smaw heaa = 136.4
	hedp = 129.8
m2a3b = 40
m3 = 60
m7a2 = 48.4
mk2 = 13.09
ozm72 = 55
pmn2 = 9.24
smine = 80
stockmine = 44
tm43 = 100
tm62 = 104.5
rpg og7v = 28.6
	pg7v = 31.46
	pg7vl = 37.18
	pg7vm = 31.46
	pg7vr = 64.35
	pg7vs = 28.6
	tbg7v = 64.35
	type69 airburst = 28.6
tm100 = 3.3
	200 = 6.6
	500 = 14.3
tma4 = 69.3
pma3 = 3.96
mrud = 48.4
*/


_bool = false; //true results in an error to the user during munition selection
_returnX = [];


// Remove "//" slashes to enable the blacklist of specified explosive.
switch (_warhead) do 
{
////////// XXXXXXXXX Vanilla Arma 3 Explosives XXXXXXX ///////////
//	case "M_Titan_AA": {_bool = True};
//	case "M_Titan_AP": {_bool = True};
//	case "M_Titan_AT": {_bool = True};
//	case "ATMine_Range_Ammo": {_bool = True};
	case "APERSTripMine_Wire_Ammo": {_bool = True};
//	case "APERSBoundingMine_Range_Ammo": {_bool = True};
//	case "APERSMine_Range_Ammo": {_bool = True};
//	case "APERSMineDispenser_Ammo": {_bool = True};
//	case "DemoCharge_Remote_Ammo": {_bool = True};
//	case "SLAMDirectionalMine_Wire_Ammo": {_bool = True};
//	case "ClaymoreDirectionalMine_Remote_Ammo": {_bool = True};
//	case "SatchelCharge_Remote_Ammo": {_bool = True};
//	case "IEDUrbanBig_Remote_Ammo": {_bool = True};
//	case "IEDLandBig_Remote_Ammo": {_bool = True};
//	case "IEDUrbanSmall_Remote_Ammo": {_bool = True};
//	case "IEDLandSmall_Remote_Ammo": {_bool = True};
//	case "M_Vorona_HE": {_bool = True};
//	case "M_Vorona_HEAT": {_bool = True};
//	case "R_PG7_F": {_bool = True};
//	case "R_TBG32V_F": {_bool = True};
//	case "R_PG32V_F": {_bool = True};
//	case "M_NLAW_AT_F": {_bool = True};
//	case "R_MRAAWS_HEAT55_F": {_bool = True};
//	case "R_MRAAWS_HE_F": {_bool = True};
//	case "R_MRAAWS_HEAT_F": {_bool = True};
	case "Chemlight_green": {_bool = True};
	case "Chemlight_blue": {_bool = True};
	case "Chemlight_red": {_bool = True};
	case "Chemlight_yellow": {_bool = True};


//////// XXXXXXX RHS Explosives XXXXXXX	/////////
//	case "rhssaf_tm500_ammo": {_bool = True};
//	case "rhssaf_tm200_ammo": {_bool = True};
//	case "rhssaf_tm100_ammo": {_bool = True};
//	case "rhssaf_mine_tma4_ammo": {_bool = True};
//	case "rhssaf_mine_pma3_ammo": {_bool = True}; 
//	case "rhssaf_mine_mrud_d_ammo": {_bool = True};
//	case "rhssaf_mine_mrud_c_ammo": {_bool = True};
//	case "rhssaf_mine_mrud_b_ammo": {_bool = True};
//	case "rhssaf_mine_mrud_a_ammo": {_bool = True};
//	case "rhs_rpg7v2_type63_airburst": {_bool = True};
//	case "rhs_rpg7v2_tbg7v": {_bool = True};
//	case "rhs_rpg7v2_pg7vs": {_bool = True};
//	case "rhs_rpg7v2_pg7vr": {_bool = True};
//	case "rhs_rpg7v2_pg7vm": {_bool = True};
//	case "rhs_rpg7v2_pg7vl": {_bool = True};
//	case "rhs_rpg7v2_pg7v": {_bool = True};
//	case "rhs_rpg7v2_og7v": {_bool = True};
//	case "rhs_rpg26_rocket": {_bool = True};
//	case "rhs_rpg18_rocket": {_bool = True};
//	case "rhs_mine_tm62m_ammo": {_bool = True};
//	case "rhs_mine_TM43_ammo": {_bool = True};
//	case "rhs_mine_stockmine43_4m_ammo": {_bool = True};
//	case "rhs_mine_stockmine43_2m_ammo": {_bool = True};
//	case "rhs_mine_smine44_trip_ammo": {_bool = True};
//	case "rhs_mine_smine44_press_ammo": {_bool = True};
//	case "rhs_mine_smine35_trip_ammo": {_bool = True};
//	case "rhs_mine_smine35_press_ammo": {_bool = True};
//	case "rhs_mine_pmn2_ammo": {_bool = True};
//	case "rhs_mine_ozm72_c_ammo": {_bool = True};
//	case "rhs_mine_ozm72_b_ammo": {_bool = True};
//	case "rhs_mine_ozm72_a_ammo": {_bool = True};
//	case "rhs_mine_Mk2_tripwire_ammo": {_bool = True};
//	case "rhs_mine_Mk2_pressure_ammo": {_bool = True};
//	case "rhs_mine_M7A2_ammo": {_bool = True};
//	case "rhs_mine_M3_tripwire_ammo": {_bool = True};
//	case "rhs_mine_M3_pressure_ammo": {_bool = True};
//	case "rhs_mine_m2a3b_trip_ammo": {_bool = True};
//	case "rhs_mine_m2a3b_press_ammo": {_bool = True};
//	case "rhsusf_mine_m19_ammo": {_bool = True};
//	case "rhs_mine_glasmine43_hz_ammo": {_bool = True};
//	case "rhs_mine_glasmine43_bz_ammo": {_bool = True};
//	case "rhs_mine_a200_dz35_ammo": {_bool = True};
//	case "rhs_mine_a200_bz_ammo": {_bool = True};
//	case "rhs_ammo_smaw_HEDP": {_bool = True};
//	case "rhs_ammo_smaw_HEAA": {_bool = True};
	case "rhs_ammo_maaws_SMOKE": {_bool = True};
	case "rhs_ammo_maaws_ILLUM": {_bool = True};
//	case "rhs_ammo_maaws_HEDP": {_bool = True};
//	case "rhs_ammo_maaws_HEAT": {_bool = True};
//	case "rhs_ammo_maaws_HE": {_bool = True};
//	case "rhs_ammo_9k32": {_bool = True};
//	case "rhs_ammo_9k38": {_bool = True};
//	case "rhs_ammo_fim92_missile": {_bool = True};
//	case "rhs_ammo_M136_rocket": {_bool = True};
//	case "rhs_ammo_M136_hp_rocket": {_bool = True};
//	case "rhs_ammo_M136_hedp_rocket": {_bool = True};
//	case "rhs_ammo_m72a7_rocket": {_bool = True};
//	case "rhs_ammo_M_fgm148_AT": {_bool = True};
//	case "rhs_ammo_M_fgm172a_AT": {_bool = True};
//	case "rhs_ec75_sand_ammo": {_bool = True};
//	case "rhs_ec75_ammo": {_bool = True};
//	case "rhs_ec400_sand_ammo": {_bool = True};
//	case "rhs_ec400_ammo": {_bool = True};
//	case "rhs_ec200_sand_ammo": {_bool = True};
//	case "rhs_ec200_ammo": {_bool = True};
//	case "rhs_charge_M2tet_x2_ammo": {_bool = True};


////////////////////////////////////////////////
//////////Add other CfgMagazine names here ^^^
///////////////////////////////////////////////
	default {_bool = false};
};

_returnX = [_maxMass, _bool];
_returnX;