#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include <xs>
#include <cstrike>


#define ENG_NULLENT			-1
#define EV_INT_WEAPONKEY	EV_INT_impulse
#define buffawp_WEAPONKEY 		821
#define MAX_PLAYERS  		32
#define IsValidUser(%1) (1 <= %1 <= g_MaxPlayers)

const USE_STOPPED = 0
const OFFSET_ACTIVE_ITEM = 373
const OFFSET_WEAPONOWNER = 41
const OFFSET_LINUX = 5
const OFFSET_LINUX_WEAPONS = 4

#define WEAP_LINUX_XTRA_OFF		4
#define m_fKnown					44
#define m_flNextPrimaryAttack 		46
#define m_flTimeWeaponIdle			48
#define m_iClip					51
#define m_fInReload				54
#define PLAYER_LINUX_XTRA_OFF	5
#define m_flNextAttack				83

#define RELOAD_TIME	3.0
#define SHOOT1		1
#define SHOOT2		2
#define RELOAD		4
#define DRAW		5

#define write_coord_f(%1)	engfunc(EngFunc_WriteCoord,%1)

new const Fire_Sounds[][] = { "weapons/buffawp_shoot1.wav" }

new V_MODEL[64] = "models/v_buffawp.mdl"
new P_MODEL[64] = "models/p_buffawp.mdl"
new W_MODEL[64] = "models/w_buffawp.mdl"

new const GUNSHOT_DECALS[] = { 41, 42, 43, 44, 45 }

new cvar_dmg_buffawp, cvar_recoil_buffawp, g_itemid_buffawp, cvar_clip_buffawp, cvar_spd_buffawp, cvar_buffawp_ammo
new g_MaxPlayers, g_orig_event_buffawp, g_IsInPrimaryAttack
new Float:cl_pushangle[MAX_PLAYERS + 1][3], m_iBlood[2]
new g_has_buffawp[33], g_clip_ammo[33], g_buffawp_TmpClip[33], oldweap[33]
new gmsgWeaponList

const PRIMARY_WEAPONS_BIT_SUM = 
(1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<
CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
new const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
			"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550",
			"weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
			"weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
			"weapon_ak47", "weapon_knife", "weapon_p90" }
new g_Energy[33],g_Beam_SprId
#define weapon_max_energy               3
#define weapon_energy_restore           1.5
#define CSW_BUFFAWP CSW_AWP
#define weapon_buffawp "weapon_awp"
public plugin_init()
{
	register_plugin("EXTRA BUFF AWP", "1.0", "EDo")
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")
	register_event("CurWeapon","CurrentWeapon","be","1=1")
	
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary_Post", 1)
	for (new i = 1; i < sizeof WEAPONENTNAMES; i++)
	if (WEAPONENTNAMES[i][0]) RegisterHam(Ham_Item_Deploy, WEAPONENTNAMES[i], "fw_Item_Deploy_Post", 1)
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_buffawp, "fw_buffawp_PrimaryAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_buffawp, "fw_buffawp_PrimaryAttack_Post", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_buffawp, "buffawp_ItemPostFrame")
	RegisterHam(Ham_Weapon_Reload, weapon_buffawp, "buffawp_Reload")
	RegisterHam(Ham_Weapon_Reload,weapon_buffawp, "buffawp_Reload_Post", 1)
	RegisterHam(Ham_Item_AddToPlayer, weapon_buffawp, "fw_buffawp_AddToPlayer")
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage")
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_PlaybackEvent, "fwPlaybackEvent")
	
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_breakable", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_wall", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_door", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_door_rotating", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_plat", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_rotating", "fw_TraceAttack", 1)

	cvar_dmg_buffawp = register_cvar("zp_buffawp_dmg", "800.0")
	cvar_recoil_buffawp = register_cvar("zp_buffawp_recoil", "0.94")
	cvar_clip_buffawp = register_cvar("zp_buffawp_clip", "20")
	cvar_spd_buffawp = register_cvar("zp_buffawp_spd", "1.0")
	cvar_buffawp_ammo = register_cvar("zp_buffawp_ammo", "999")
	
	g_MaxPlayers = get_maxplayers()
	gmsgWeaponList = get_user_msgid("WeaponList")
	register_clcmd("weapon_buffawp", "weapon_hook")	
}

public plugin_precache()
{
	precache_model(V_MODEL)
	precache_model(P_MODEL)
	precache_model(W_MODEL)
	for(new i = 0; i < sizeof Fire_Sounds; i++)
	precache_sound(Fire_Sounds[i])	
	m_iBlood[0] = precache_model("sprites/blood.spr")
	m_iBlood[1] = precache_model("sprites/bloodspray.spr")
	precache_generic("sprites/weapon_buffawp.txt")
	g_Beam_SprId=engfunc(EngFunc_PrecacheModel,"sprites/zbeam2.spr")
         register_forward(FM_PrecacheEvent,"fwPrecacheEvent_Post",1)

	
}

public weapon_hook(id)
{
    	engclient_cmd(id, weapon_buffawp)
    	return PLUGIN_HANDLED
}

public fw_TraceAttack(iEnt, iAttacker, Float:flDamage, Float:fDir[3], ptr, iDamageType)
{
	if(!is_user_alive(iAttacker))
		return

	new g_currentweapon = get_user_weapon(iAttacker)

	if(g_currentweapon != CSW_BUFFAWP) return
	
	if(!g_has_buffawp[iAttacker]) return

	static Float:flEnd[3]
	get_tr2(ptr, TR_vecEndPos, flEnd)
	
	if(iEnt)
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_DECAL)
		write_coord_f(flEnd[0])
		write_coord_f(flEnd[1])
		write_coord_f(flEnd[2])
		write_byte(GUNSHOT_DECALS[random_num (0, sizeof GUNSHOT_DECALS -1)])
		write_short(iEnt)
		message_end()
	}
	else
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_WORLDDECAL)
		write_coord_f(flEnd[0])
		write_coord_f(flEnd[1])
		write_coord_f(flEnd[2])
		write_byte(GUNSHOT_DECALS[random_num (0, sizeof GUNSHOT_DECALS -1)])
		message_end()
	}
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_GUNSHOTDECAL)
	write_coord_f(flEnd[0])
	write_coord_f(flEnd[1])
	write_coord_f(flEnd[2])
	write_short(iAttacker)
	write_byte(GUNSHOT_DECALS[random_num (0, sizeof GUNSHOT_DECALS -1)])
	message_end()
}



public plugin_natives ()
{
	register_native("give_buffawp", "native_give", 1)
	register_native("remove_buffawp", "native_remove", 1)
}
public native_give(id)
{
	give_buffawp(id)
}
public native_remove(id)
{
	remove_buffawp(id)
}
public fwPrecacheEvent_Post(type, const name[])
{
	if (equal("events/awp.sc", name))
	{
		g_orig_event_buffawp = get_orig_retval()
		return FMRES_HANDLED
	}
	return FMRES_IGNORED
}

public client_connect(id)
{
	g_has_buffawp[id] = false
}

public client_disconnect(id)
{
	g_has_buffawp[id] = false
}


public Mileage_WeaponGet(id, ItemID)
{
	if(ItemID == g_itemid_buffawp) give_buffawp(id)
}

public Mileage_WeaponRefillAmmo(id, ItemID)
{
	if(ItemID == g_itemid_buffawp) give_buffawp(id)
}

public Mileage_WeaponRemove(id, ItemID)
{
	if(ItemID == g_itemid_buffawp) remove_buffawp(id)
}
public fw_SetModel(entity, model[])
{
	if(!is_valid_ent(entity))
		return FMRES_IGNORED
	
	static szClassName[33]
	entity_get_string(entity, EV_SZ_classname, szClassName, charsmax(szClassName))
		
	if(!equal(szClassName, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner
	
	iOwner = entity_get_edict(entity, EV_ENT_owner)
	
	if(equal(model, "models/w_awp.mdl"))
	{
		static iStoredAugID
		
		iStoredAugID = find_ent_by_owner(ENG_NULLENT, weapon_buffawp, entity)
	
		if(!is_valid_ent(iStoredAugID))
			return FMRES_IGNORED
	
		if(g_has_buffawp[iOwner])
		{
			entity_set_int(iStoredAugID, EV_INT_WEAPONKEY, buffawp_WEAPONKEY)
			
			g_has_buffawp[iOwner] = false
			
			entity_set_model(entity, W_MODEL)
			
			return FMRES_SUPERCEDE
		}
	}
	return FMRES_IGNORED
}

public give_buffawp(id)
{
	drop_weapons(id, 1)
	ShowStatusIcon(id, g_Energy[id], 1)
	new iWep2 = give_item(id,"weapon_awp")
	if( iWep2 > 0 )
	{
		cs_set_weapon_ammo(iWep2, get_pcvar_num(cvar_clip_buffawp))
		cs_set_user_bpammo (id, CSW_AWP, get_pcvar_num(cvar_buffawp_ammo))	
		UTIL_PlayWeaponAnimation(id, DRAW)
		set_pdata_float(id, m_flNextAttack, 1.0, PLAYER_LINUX_XTRA_OFF)

		message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
		write_string("weapon_buffawp")
		write_byte(1)
		write_byte(30)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(2)
		write_byte(CSW_AWP)
		message_end()
	}
	
	g_Energy[id]=0
	g_has_buffawp[id] = true
}
public remove_buffawp(id)
{
	g_Energy[id]=0
	g_has_buffawp[id] = false
}


public fw_buffawp_AddToPlayer(buffawp, id)
{
	if(!is_valid_ent(buffawp) || !is_user_connected(id))
		return HAM_IGNORED
	
	if(entity_get_int(buffawp, EV_INT_WEAPONKEY) == buffawp_WEAPONKEY)
	{
		g_has_buffawp[id] = true
		
		entity_set_int(buffawp, EV_INT_WEAPONKEY, 0)

		message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
		write_string("weapon_buffawp")
		write_byte(1)
		write_byte(30)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(2)
		write_byte(CSW_AWP)
		message_end()
		
		return HAM_HANDLED
	}
	else
	{
		message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
		write_string("weapon_awp")
		write_byte(1)
		write_byte(30)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(2)
		write_byte(CSW_AWP)
		message_end()
	}
	return HAM_IGNORED
}

public fw_UseStationary_Post(entity, caller, activator, use_type)
{
	if (use_type == USE_STOPPED && is_user_connected(caller))
		replace_weapon_models(caller, get_user_weapon(caller))
}

public fw_Item_Deploy_Post(weapon_ent)
{
	static owner
	owner = fm_cs_get_weapon_ent_owner(weapon_ent)
	
	static weaponid
	weaponid = cs_get_weapon_id(weapon_ent)
	g_Energy[owner]=0
	ShowStatusIcon(owner, g_Energy[owner], 1)
	replace_weapon_models(owner, weaponid)
}

public CurrentWeapon(id)
{
     replace_weapon_models(id, read_data(2))

     if(read_data(2) != CSW_AWP || !g_has_buffawp[id])
          return
     
     static Float:iSpeed
     if(g_has_buffawp[id])
          iSpeed = get_pcvar_float(cvar_spd_buffawp)
   
     static weapon[32],Ent
     get_weaponname(read_data(2),weapon,31)
     Ent = find_ent_by_owner(-1,weapon,id)
     if(Ent)
     {
          static Float:Delay
          Delay = get_pdata_float( Ent, 46, 4) * iSpeed
          if (Delay > 0.0)
          {
               set_pdata_float(Ent, 46, Delay, 4)
          }
     }
}

replace_weapon_models(id, weaponid)
{
	switch (weaponid)
	{
		case CSW_AWP:
		{
			if(g_has_buffawp[id])
			{
				ShowStatusIcon(id, g_Energy[id], 1)
				set_pev(id, pev_viewmodel2, V_MODEL)
				set_pev(id, pev_weaponmodel2, P_MODEL)
				if(oldweap[id] != CSW_AWP) 
				{
					UTIL_PlayWeaponAnimation(id, DRAW)
					set_pdata_float(id, m_flNextAttack, 1.0, PLAYER_LINUX_XTRA_OFF)

					message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
					write_string("weapon_buffawp")
					write_byte(1)
					write_byte(30)
					write_byte(-1)
					write_byte(-1)
					write_byte(0)
					write_byte(2)
					write_byte(CSW_AWP)
					message_end()
				}
			}
		}
	}
	oldweap[id] = weaponid
}

public fw_UpdateClientData_Post(Player, SendWeapons, CD_Handle)
{
	if(!is_user_alive(Player) || (get_user_weapon(Player) != CSW_AWP || !g_has_buffawp[Player]))
		return FMRES_IGNORED
	
	set_cd(CD_Handle, CD_flNextAttack, halflife_time () + 0.001)
	return FMRES_HANDLED
}

public fw_buffawp_PrimaryAttack(Weapon)
{
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	if (!g_has_buffawp[Player])
		return
	
	g_IsInPrimaryAttack = 1
	pev(Player,pev_punchangle,cl_pushangle[Player])
	
	g_clip_ammo[Player] = cs_get_weapon_ammo(Weapon)
}

public fwPlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if ((eventid != g_orig_event_buffawp) || !g_IsInPrimaryAttack)
		return FMRES_IGNORED
	if (!(1 <= invoker <= g_MaxPlayers))
    return FMRES_IGNORED

	playback_event(flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	return FMRES_SUPERCEDE
}

public fw_buffawp_PrimaryAttack_Post(Weapon)
{
	g_IsInPrimaryAttack = 0
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	new szClip, szAmmo
	get_user_weapon(Player, szClip, szAmmo)
	
	if(!is_user_alive(Player))
		return

	if(g_has_buffawp[Player])
	{
		if (!g_clip_ammo[Player])
			return

		new Float:push[3]
		pev(Player,pev_punchangle,push)
		xs_vec_sub(push,cl_pushangle[Player],push)
		xs_vec_mul_scalar(push,get_pcvar_float(cvar_recoil_buffawp),push)
		xs_vec_add(push,cl_pushangle[Player],push)
		set_pev(Player,pev_punchangle,push)
		emit_sound(Player, CHAN_WEAPON, Fire_Sounds[0], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		UTIL_PlayWeaponAnimation(Player, random_num(SHOOT1, SHOOT2))
		if(g_Energy[Player]==weapon_max_energy)
		{
			laser(Player)	
		}
		
		g_Energy[Player]=0
		ShowStatusIcon(Player, g_Energy[Player], 1)
	}
}
public laser(id)
{
	new Float:flAim[3]
	fm_get_aim_origin(id, flAim)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte(TE_BEAMENTPOINT)
	write_short(id | 0x1000)
	engfunc(EngFunc_WriteCoord, flAim[0])
	engfunc(EngFunc_WriteCoord, flAim[1])
	engfunc(EngFunc_WriteCoord, flAim[2])
	write_short(g_Beam_SprId) 
	write_byte(1) 
	write_byte(1) 
	write_byte(5) 
	write_byte(30) 
	write_byte(0) 
	write_byte(0)
	write_byte(255)
	write_byte(0)
	write_byte(255)
	write_byte(10)
	message_end()
}	

public client_putinserver(id)
{
	new g_ham_bot
	if(!g_ham_bot && is_user_bot(id))
	{
		g_ham_bot = 1
		set_task(0.1, "do_register", id)
	}
}

public do_register(id)
{
	RegisterHamFromEntity(Ham_TakeDamage, id, "fw_TakeDamage")
}
public fw_TakeDamage(victim, inflictor, attacker, Float:damage)
{
	if (victim != attacker && is_user_connected(attacker))
	{
		if(get_user_weapon(attacker) == CSW_AWP)
		{
			if(g_has_buffawp[attacker])
			{
				if(!g_Energy[attacker])
				{
					SetHamParamFloat(4,get_pcvar_float(cvar_dmg_buffawp))
					client_print(attacker,print_chat,"%i",get_pcvar_float(cvar_dmg_buffawp))
				}
				else
				{
					SetHamParamFloat(4,get_pcvar_float(cvar_dmg_buffawp)*float(g_Energy[attacker]))
					client_print(attacker,print_chat,"%i",get_pcvar_float(cvar_dmg_buffawp)*float(g_Energy[attacker]))
				}
				set_hudmessage(255, 0, 0, -1.0, 0.46, 0, 0.2, 0.2)
				show_hudmessage(attacker, "\         /^n+^n/         \")
			}
				//client_print(attacker,print_chat,"%d",damage *(get_pcvar_float(cvar_dmg_buffawp)*float(g_Energy[attacker])))
		}
	}
}

public message_DeathMsg(msg_id, msg_dest, id)
{
	static szTruncatedWeapon[33], iAttacker, iVictim
	
	get_msg_arg_string(4, szTruncatedWeapon, charsmax(szTruncatedWeapon))
	
	iAttacker = get_msg_arg_int(1)
	iVictim = get_msg_arg_int(2)
	
	if(!is_user_connected(iAttacker) || iAttacker == iVictim)
		return PLUGIN_CONTINUE
	
	if(equal(szTruncatedWeapon, "awp") && get_user_weapon(iAttacker) == CSW_AWP)
	{
		if(g_has_buffawp[iAttacker])
			set_msg_arg_string(4, "buffawp")
	}
	return PLUGIN_CONTINUE
}

public buffawp_ItemPostFrame(weapon_entity) 
{
     new id = pev(weapon_entity, pev_owner)
     if (!is_user_connected(id))
          return HAM_IGNORED

     if (!g_has_buffawp[id])
          return HAM_IGNORED

     static iClipExtra
     
     iClipExtra = get_pcvar_num(cvar_clip_buffawp)
     new Float:flNextAttack = get_pdata_float(id, m_flNextAttack, PLAYER_LINUX_XTRA_OFF)

     new iBpAmmo = cs_get_user_bpammo(id, CSW_AWP)
     new iClip = get_pdata_int(weapon_entity, m_iClip, WEAP_LINUX_XTRA_OFF)

     new fInReload = get_pdata_int(weapon_entity, m_fInReload, WEAP_LINUX_XTRA_OFF) 

     if( fInReload && flNextAttack <= 0.0 )
     {
	     new j = min(iClipExtra - iClip, iBpAmmo)
	
	     set_pdata_int(weapon_entity, m_iClip, iClip + j, WEAP_LINUX_XTRA_OFF)
	     cs_set_user_bpammo(id, CSW_AWP, iBpAmmo-j)
		
	     set_pdata_int(weapon_entity, m_fInReload, 0, WEAP_LINUX_XTRA_OFF)
	     fInReload = 0
     }
     if(cs_get_user_zoom(id)==2||cs_get_user_zoom(id)==3)
     {
     	ShowStatusIcon(id, g_Energy[id], 1)
	if(g_Energy[id]<weapon_max_energy)
	{
		static Float:EnergyTime[512];
		if((EnergyTime[id]+weapon_energy_restore)<get_gametime())
		{
			EnergyTime[id]=get_gametime()
			g_Energy[id]++
		}
	}
     }
     else
     {
	g_Energy[id]=0
     }
     return HAM_IGNORED
}
public buffawp_Reload(weapon_entity) 
{
     new id = pev(weapon_entity, pev_owner)
     if (!is_user_connected(id))
          return HAM_IGNORED

     if (!g_has_buffawp[id])
          return HAM_IGNORED

     static iClipExtra

     if(g_has_buffawp[id])
          iClipExtra = get_pcvar_num(cvar_clip_buffawp)

     g_buffawp_TmpClip[id] = -1

     new iBpAmmo = cs_get_user_bpammo(id, CSW_AWP)
     new iClip = get_pdata_int(weapon_entity, m_iClip, WEAP_LINUX_XTRA_OFF)

     if (iBpAmmo <= 0)
          return HAM_SUPERCEDE

     if (iClip >= iClipExtra)
          return HAM_SUPERCEDE

     g_buffawp_TmpClip[id] = iClip

     return HAM_IGNORED
}

public buffawp_Reload_Post(weapon_entity) 
{
	new id = pev(weapon_entity, pev_owner)
	if (!is_user_connected(id))
		return HAM_IGNORED

	if (!g_has_buffawp[id])
		return HAM_IGNORED

	if (g_buffawp_TmpClip[id] == -1)
		return HAM_IGNORED

	set_pdata_int(weapon_entity, m_iClip, g_buffawp_TmpClip[id], WEAP_LINUX_XTRA_OFF)

	set_pdata_float(weapon_entity, m_flTimeWeaponIdle, RELOAD_TIME, WEAP_LINUX_XTRA_OFF)

	set_pdata_float(id, m_flNextAttack, RELOAD_TIME, PLAYER_LINUX_XTRA_OFF)

	set_pdata_int(weapon_entity, m_fInReload, 1, WEAP_LINUX_XTRA_OFF)

	UTIL_PlayWeaponAnimation(id, RELOAD)

	return HAM_IGNORED
}
ShowStatusIcon(id, idspr, run)
{	
	HideStatusIcon(id)
	if (idspr) StatusIcon(id, idspr, run)
}
HideStatusIcon(id)
{	
	for (new i = 1; i <= 9; i++)
	{
		StatusIcon(id, i, 0)
	}

}
StatusIcon(id, idspr, run)
{	
	message_begin(MSG_ONE, get_user_msgid("StatusIcon"), {0,0,0}, id)
	write_byte(run) // status (0=hide, 1=show, 2=flash)
	write_string(GetStatusIconName(idspr)) // sprite name
	if(g_Energy[id]==weapon_max_energy)
	{
		write_byte(255)// red
		write_byte(0)// green
		write_byte(0)// blue
		message_end()
	}
	else if(g_Energy[id]==2)
	{
		write_byte(0)// red
		write_byte(0)// green
		write_byte(255)// blue
		message_end()
	}
	else 
	{
		write_byte(0)// red
		write_byte(255)// green
		write_byte(0)// blue
		message_end()
	}
	
	
	

}
GetStatusIconName(idspr)
{
	new sprname[33]
	format(sprname, charsmax(sprname), "number_%i", idspr)
	return sprname;
}

stock fm_cs_get_current_weapon_ent(id)
{
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX)
}

stock fm_cs_get_weapon_ent_owner(ent)
{
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS)
}

stock UTIL_PlayWeaponAnimation(const Player, const Sequence)
{
	set_pev(Player, pev_weaponanim, Sequence)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, .player = Player)
	write_byte(Sequence)
	write_byte(pev(Player, pev_body))
	message_end()
}
stock drop_weapons(id, dropwhat)
{
     static weapons[32], num, i, weaponid
     num = 0
     get_user_weapons(id, weapons, num)
     
     for (i = 0; i < num; i++)
     {
          weaponid = weapons[i]
          
          if (dropwhat == 1 && ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM))
          {
               static wname[32]
               get_weaponname(weaponid, wname, sizeof wname - 1)
               engclient_cmd(id, "drop", wname)
          }
     }
}
stock get_position(id,Float:forw, Float:right, Float:up, Float:vStart[])
{
	static Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(id, pev_origin, vOrigin)
	pev(id, pev_view_ofs, vUp) //for player
	xs_vec_add(vOrigin, vUp, vOrigin)
	pev(id, pev_v_angle, vAngle) // if normal entity ,use pev_angles
	
	angle_vector(vAngle, ANGLEVECTOR_FORWARD, vForward) //or use EngFunc_AngleVectors
	angle_vector(vAngle, ANGLEVECTOR_RIGHT, vRight)
	angle_vector(vAngle, ANGLEVECTOR_UP, vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}
stock fm_get_aim_origin(index, Float:origin[3]) {
	new Float:start[3], Float:view_ofs[3];
	pev(index, pev_origin, start);
	pev(index, pev_view_ofs, view_ofs);
	xs_vec_add(start, view_ofs, start);

	new Float:dest[3];
	pev(index, pev_v_angle, dest);
	engfunc(EngFunc_MakeVectors, dest);
	global_get(glb_v_forward, dest);
	xs_vec_mul_scalar(dest, 9999.0, dest);
	xs_vec_add(start, dest, dest);

	engfunc(EngFunc_TraceLine, start, dest, 0, index, 0);
	get_tr2(0, TR_vecEndPos, origin);

	return 1;
}
