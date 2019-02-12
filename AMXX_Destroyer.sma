/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <engine>
#include <fun>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#define ENG_NULLENT		-1
#define EV_INT_WEAPONKEY	EV_INT_impulse

const OFFSET_LINUX_WEAPONS = 4
const OFFSET_WEAPONOWNER = 41
const m_flNextAttack = 83
/*
SPECIAL THANKS FOR DHANNY (CSBTEDHAN) *FOR CODE DISTANCE
*/
#define WEAP_LINUX_XTRA_OFF		4
#define m_flTimeWeaponIdle			48
#define m_iClip					51
#define m_fInReload				54
#define PLAYER_LINUX_XTRA_OFF	5
#define PLUGIN "New Plug-In"
#define VERSION "1.0"
#define AUTHOR "EDo"
#define EXPLODE_SPR "sprites/destroyer_explosion.spr"
#define CSW_DESTROYER CSW_G3SG1
#define weapon_destroyer "weapon_g3sg1"
#define old_event "events/g3sg1.sc"

#define DEFAULT_W_MODEL "models/w_g3sg1.mdl"
#define WEAPON_SECRET_CODE 4965

#define DTR_DEFAULT_BPAMMO 30
#define DTR_DEFAULT_CLIP 3
#define DTR_DAMAGE 420
#define DTR_RELOAD_TIME 3.5
#define DTR_DRAW_TIME 1.5
#define DTR_RECOIL 1.5
new const GUNSHOT_DECALS[] = { 41, 42, 43, 44, 45 }
new const shoot_sound[] = "weapons/destroyer-1.wav"
new const exp_sdestroyer[] = "weapons/destroyer_exp.wav" 
// MACROS
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
new const WeaponModel[][] =
{
	"models/p_destroyer.mdl",
	"models/v_destroyer.mdl",
	"models/w_destroyer.mdl"
}
enum
{
	MODEL_P = 0,
	MODEL_V,
	MODEL_W
}
enum
{
	DESTRO_IDLE = 0,
	DESTRO_SHOOT1,
	DESTRO_SHOOT2,
	DESTRO_RELOAD,
	DESTRO_DRAW
}
new g_had_destroyer, g_destroyer, m_iBlood[2]
new g_old_weapon[33], g_event_destroyer, g_smokepuff_id, g_scope_hud,
g_clip_ammo[33], Float:cl_pushangle[33][3], g_destroyer_TmpClip[33], g_reload[33], Float:g_attack_origin[3]
new g_MaxPlayers, Float:CheckDelay[33], Float:CheckDelay2[33], Float:CheckDelay3[33]
new g_Exp_SprId, g_Zoom[33]
const PRIMARY_WEAPONS_BIT_SUM = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
const SECONDARY_WEAPONS_BIT_SUM = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE)

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack")
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack")
	
	RegisterHam(Ham_Item_AddToPlayer, weapon_destroyer, "fw_AddToPlayer_Post", 1)
	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled");
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_destroyer, "fw_PrimaryAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_destroyer, "fw_PrimaryAttack_Post", 1)
	RegisterHam(Ham_Weapon_SecondaryAttack, weapon_destroyer, "fw_Weapon_SecondaryAttack")
	RegisterHam(Ham_Item_PostFrame, weapon_destroyer, "fw_ItemPostFrame")
	RegisterHam(Ham_Item_Deploy, weapon_destroyer, "fw_Item_Deploy_Post", 1)
	RegisterHam(Ham_Weapon_Reload, weapon_destroyer, "fw_Reload")
	RegisterHam(Ham_Weapon_Reload, weapon_destroyer, "fw_Reload_Post", 1)
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_destroyer, "fw_Idleanim", 1)
	g_scope_hud = CreateHudSyncObj(8)
	g_MaxPlayers = get_maxplayers()
	register_clcmd("weapon_destroyer", "hook_weapon")
	register_clcmd("get_destroyer", "cie_yang_mau_ngedecompile")
}
public plugin_precache()
{
	new i
	for(i = 0; i < sizeof(WeaponModel); i++)
		engfunc(EngFunc_PrecacheModel, WeaponModel[i])
	precache_sound(shoot_sound)
	precache_sound(exp_sdestroyer)
	m_iBlood[0] = precache_model("sprites/blood.spr")
	m_iBlood[1] = precache_model("sprites/bloodspray.spr")
	g_Exp_SprId = precache_model(EXPLODE_SPR)
	g_smokepuff_id = engfunc(EngFunc_PrecacheModel, "sprites/wall_puff1.spr")
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)
}
public plugin_natives ()
{
	register_native("give_destroyer", "native_get", 1)
	register_native("remove_destroyer", "native_remove", 1)
	register_native("refill_destroyer", "native_refill", 1)
}
public native_get(id)
{
	Get_Destroyer(id)
}

public native_refill(id)
{
	cs_set_user_bpammo (id, CSW_DESTROYER, DTR_DEFAULT_BPAMMO)
}

public native_remove(id)
{
	Remove_Destroyer(id)
}

public fw_PlayerKilled(id) Remove_Destroyer(id)

public hook_weapon(id)
{
	engclient_cmd(id, weapon_destroyer)
	return
}

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(old_event, name))
		g_event_destroyer = get_orig_retval()
}
public cie_yang_mau_ngedecompile(id)
{
	Get_Destroyer(id)	
}

public Get_Destroyer(id)
{
	if(!is_user_alive(id))
		return
		
	new iWep2 = give_item(id,"weapon_g3sg1")
	if( iWep2 > 0 )
	{
		cs_set_weapon_ammo(iWep2, DTR_DEFAULT_CLIP)
		cs_set_user_bpammo (id, CSW_DESTROYER, DTR_DEFAULT_BPAMMO)
	}
	client_print(id,print_chat,"[DESTROYER] Plugin By EDo")
	Set_BitVar(g_had_destroyer, id)
}

public Remove_Destroyer(id)
{
	UnSet_BitVar(g_had_destroyer, id)
}

public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) == CSW_DESTROYER && Get_BitVar(g_had_destroyer, id))
	{
		set_pev(id, pev_viewmodel2, WeaponModel[MODEL_V])
		set_pev(id, pev_weaponmodel2, WeaponModel[MODEL_P])
		
		if(g_old_weapon[id] != CSW_DESTROYER) 
		{
			set_weapon_anim(id, DESTRO_DRAW)
			set_player_nextattack(id, DTR_DRAW_TIME)
		} 
	} 
	
	
	g_old_weapon[id] = get_user_weapon(id)	
	
}

public fw_Item_Deploy_Post(Ent)
{
	if (!pev_valid(Ent))
		return

	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(!Get_BitVar(g_had_destroyer, Id))
		return

			
	set_pev(Id, pev_viewmodel2, WeaponModel[MODEL_V])
	set_pev(Id, pev_weaponmodel2, WeaponModel[MODEL_P])
		
	set_weapon_anim(Id, DESTRO_DRAW)
}

public fw_TraceAttack(iEnt, iAttacker, Float:flDamage, Float:fDir[3], ptr, iDamageType)
{
	if(!is_user_alive(iAttacker))
		return

	new g_currentweapon = get_user_weapon(iAttacker)

	if(g_currentweapon != CSW_DESTROYER || !Get_BitVar(g_had_destroyer, iAttacker))
		return
		
	SetHamParamFloat(3, float(DTR_DAMAGE))
	
	static Float:flEnd[3], Float:myOrigin[3]
	
	pev(iAttacker, pev_origin, myOrigin)
	get_tr2(ptr, TR_vecEndPos, flEnd)
		
	
}

public fw_SetModel(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static Classname[64]
	pev(entity, pev_classname, Classname, sizeof(Classname))
	
	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED
	
	static id
	id = pev(entity, pev_owner)
	
	if(equal(model, DEFAULT_W_MODEL))
	{
		static weapon
		weapon = fm_get_user_weapon_entity(entity, CSW_DESTROYER)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED
		
		if(Get_BitVar(g_had_destroyer, id))
		{
			set_pev(weapon, pev_impulse, WEAPON_SECRET_CODE)
			engfunc(EngFunc_SetModel, entity, WeaponModel[MODEL_W])
			
			Remove_Destroyer(id)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_AddToPlayer_Post(ent, id)
{
	if(pev(ent, pev_impulse) == WEAPON_SECRET_CODE)
	{
		Set_BitVar(g_had_destroyer, id)
		
		set_pev(ent, pev_impulse, 0)
	}			
	
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id) || !is_user_connected(id))
		return FMRES_IGNORED
	
	if(get_user_weapon(id) == CSW_DESTROYER && Get_BitVar(g_had_destroyer, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PrimaryAttack(Weapon)
{
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	if (!Get_BitVar(g_had_destroyer, Player))
		return
	
	pev(Player, pev_punchangle, cl_pushangle[Player])
	
	g_clip_ammo[Player] = cs_get_weapon_ammo(Weapon)
}

public fw_PrimaryAttack_Post(Weapon)
{
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	new szClip, szAmmo
	get_user_weapon(Player, szClip, szAmmo)
		
	if(Get_BitVar(g_had_destroyer, Player))
	{
		if (!g_clip_ammo[Player])
			return
			
		new Float:push[3]
		pev(Player,pev_punchangle,push)
		xs_vec_sub(push,cl_pushangle[Player],push)
		
		xs_vec_mul_scalar(push,DTR_RECOIL,push)
		xs_vec_add(push,cl_pushangle[Player],push)
		set_pev(Player,pev_punchangle,push)
		emit_sound(Player, CHAN_WEAPON, shoot_sound, 1.0, ATTN_NORM, 0, PITCH_NORM)
		set_player_nextattack(Player, 2.0)
		set_weapon_anim(Player, random_num(DESTRO_SHOOT1,DESTRO_SHOOT2))
		
		static Float:PunchAngles[3]
		PunchAngles[0] = -5.0
		set_pev(Player, pev_punchangle, PunchAngles)
		make_blood_and_bulletholes(Player)
		set_task(0.2, "after_shoot", Player)
		set_task(0.4, "explode", Player)
		
		fm_get_aim_origin(Player, g_attack_origin)
	}
}

public after_shoot(id)
{
	static Float:PunchAngles[3]
	PunchAngles[0] = -3.0
	set_pev(id, pev_punchangle, PunchAngles)
}

#define x_y 0.72, 0.855
public client_PreThink(id)
{
	if(!is_user_alive(id) || !is_user_connected(id))
		return
	if(get_user_weapon(id) != CSW_DESTROYER || !Get_BitVar(g_had_destroyer, id))
		return
	new Float:origin[2][3]
	Stock_Get_Origin(id, origin[0])
	fm_get_aim_origin(id, origin[1])
	new distance[32], Float:range=vector_distance(origin[0], origin[1])*0.0254
	format(distance, 31, "%im", floatround(range))
	static Body, Target; get_user_aiming(id, Target, Body, 99999)
	if(g_Zoom[id] == ZOOM_ACT)
	{
		if(is_user_alive(Target))  
		{
			set_hudmessage(200, 0, 0, x_y, 0, 0.1, 0.1)
		} else {
			set_hudmessage(0, 0, 200, x_y, 0, 0.1, 0.1)
		}
		ShowSyncHudMsg(id, g_scope_hud, distance)
	} else {
		set_hudmessage(0, 0, 200, x_y, 0, 0.1, 0.1)
		ShowSyncHudMsg(id, g_scope_hud, "")	
	}
}

public Activate_Zoom(id, Level)
{
	switch(Level)
	{
		case ZOOM_NONE:
		{
			g_Zoom[id] = Level
			set_pev(id, pev_viewmodel2, WeaponModel[MODEL_V])
		}
		case ZOOM_ACT:
		{
			g_Zoom[id] = Level
			set_pev(id, pev_viewmodel2, WeaponModel[MODEL_SN])
		}
		default:
		{
			g_Zoom[id] = ZOOM_NONE
			Set_UserFov(id, 90)
			set_pev(id, pev_viewmodel2, WeaponModel[MODEL_V])
		}
	}
}

public explode(id)
{
	new TE_FLAG
	
	TE_FLAG |= TE_EXPLFLAG_NODLIGHTS
	TE_FLAG |= TE_EXPLFLAG_NOSOUND
	TE_FLAG |= TE_EXPLFLAG_NOPARTICLES
	
	// Draw explosion
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION) // Temporary entity ID
	engfunc(EngFunc_WriteCoord, g_attack_origin[0]) // engfunc because float
	engfunc(EngFunc_WriteCoord, g_attack_origin[1])
	engfunc(EngFunc_WriteCoord, g_attack_origin[2])
	write_short(g_Exp_SprId) // Sprite index
	write_byte(5) // Scale
	write_byte(20) // Framerate
	write_byte(TE_FLAG) // Flags
	message_end()
	emit_sound(id, CHAN_WEAPON, exp_sound, 1.0, ATTN_NORM, 0, PITCH_NORM)		
	// Alive...
	new a = FM_NULLENT
	// Get distance between victim and epicenter
	while((a = find_ent_in_sphere(a, g_attack_origin, 50.0)) != 0)
	{
		if (id == a)
			continue
	
		if(pev(a, pev_takedamage) != DAMAGE_NO)
		{
			ExecuteHamB(Ham_TakeDamage, a, id, id, 200.0, DMG_BULLET)
		}
	}
}
public fw_Weapon_SecondaryAttack(Ent)
{
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	//if(get_pdata_cbase(Id, 373) != Ent)
		//return HAM_IGNORED	
	if(!Get_BitVar(g_had_destroyer, Id))
		return HAM_IGNORED	
		
	return HAM_SUPERCEDE
}

public fw_Idleanim(Weapon)
{
	new id = get_pdata_cbase(Weapon, 41, 4)

	if(!is_user_alive(id) || !Get_BitVar(g_had_destroyer, id) || get_user_weapon(id) != CSW_DESTROYER)
		return HAM_IGNORED;
	
	if(get_pdata_float(Weapon, 48, 4) <= 0.25) 
	{
		set_weapon_anim(id, DESTRO_IDLE)
		set_pdata_float(Weapon, 48, 20.0, 4)
		return HAM_SUPERCEDE;
	}
	
	return HAM_IGNORED;
}

public fw_ItemPostFrame( wpn )
{
	new id = pev(wpn, pev_owner)
	if(!is_user_connected(id))
		return HAM_IGNORED
	
	if(!Get_BitVar(g_had_destroyer, id))
		return HAM_IGNORED
				
	new Float:flNextAttack = get_pdata_float(id, m_flNextAttack, PLAYER_LINUX_XTRA_OFF)
	new iBpAmmo = cs_get_user_bpammo(id, CSW_DESTROYER)
	new iClip = get_pdata_int(wpn, m_iClip, WEAP_LINUX_XTRA_OFF)
	new fInReload = get_pdata_int(wpn, m_fInReload, WEAP_LINUX_XTRA_OFF)
	
	if(fInReload && flNextAttack <= 0.0)
	{
		new j = min(DTR_DEFAULT_CLIP - iClip, iBpAmmo)
		set_pdata_int(wpn, m_iClip, iClip + j, WEAP_LINUX_XTRA_OFF)
		cs_set_user_bpammo(id, CSW_DESTROYER, iBpAmmo-j)
		set_pdata_int(wpn, m_fInReload, 0, WEAP_LINUX_XTRA_OFF)
		fInReload = 0
		g_reload[id] = 0
	}
	return HAM_IGNORED
}

public fw_Reload( wpn ) {
	new id = pev(wpn, pev_owner)
	if(!is_user_connected(id))
		return HAM_IGNORED
	
	if(!Get_BitVar(g_had_destroyer, id))
		return HAM_IGNORED
				
	g_destroyer_TmpClip[id] = -1
	new iBpAmmo = cs_get_user_bpammo(id, CSW_DESTROYER)
	new iClip = get_pdata_int(wpn, m_iClip, WEAP_LINUX_XTRA_OFF)
	if(iBpAmmo <= 0)
		return HAM_SUPERCEDE
	
	if(iClip >= DTR_DEFAULT_CLIP)
		return HAM_SUPERCEDE
	
	g_destroyer_TmpClip[id] = iClip
	g_reload[id] = 1
	
	return HAM_IGNORED
}

public fw_Reload_Post(weapon) {
	new id = pev(weapon, pev_owner)
	if(!is_user_connected(id))
		return HAM_IGNORED
		
	if(!Get_BitVar(g_had_destroyer, id))
		return HAM_IGNORED
		
	if(g_destroyer_TmpClip[id] == -1)
		return HAM_IGNORED
	Activate_Zoom(id, ZOOM_NONE)		
	set_pdata_int(weapon, m_iClip, g_destroyer_TmpClip[id], WEAP_LINUX_XTRA_OFF)
	set_pdata_float(weapon, m_flTimeWeaponIdle, DTR_RELOAD_TIME, WEAP_LINUX_XTRA_OFF)
	set_pdata_float(id, m_flNextAttack, DTR_RELOAD_TIME, PLAYER_LINUX_XTRA_OFF)
	set_pdata_int(weapon, m_fInReload, 1, WEAP_LINUX_XTRA_OFF)
	
	set_weapon_anim(id, DESTRO_RELOAD)
	
	return HAM_IGNORED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if ((eventid != g_event_destroyer))
		return FMRES_IGNORED
	if (!(1 <= invoker <= g_MaxPlayers))
		return FMRES_IGNORED

	playback_event(flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	
	return FMRES_SUPERCEDE
}

stock make_blood_and_bulletholes(id)
{
	new aimOrigin[3], target, body
	get_user_origin(id, aimOrigin, 3)
	get_user_aiming(id, target, body)
	
	if(target > 0 && target <= g_MaxPlayers )
	{
		new Float:fStart[3], Float:fEnd[3], Float:fRes[3], Float:fVel[3]
		pev(id, pev_origin, fStart)
		
		velocity_by_aim(id, 64, fVel)
		
		fStart[0] = float(aimOrigin[0])
		fStart[1] = float(aimOrigin[1])
		fStart[2] = float(aimOrigin[2])
		fEnd[0] = fStart[0]+fVel[0]
		fEnd[1] = fStart[1]+fVel[1]
		fEnd[2] = fStart[2]+fVel[2]
		
		new res
		engfunc(EngFunc_TraceLine, fStart, fEnd, 0, target, res)
		get_tr2(res, TR_vecEndPos, fRes)
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY) 
		write_byte(TE_BLOODSPRITE)
		write_coord(floatround(fStart[0])) 
		write_coord(floatround(fStart[1])) 
		write_coord(floatround(fStart[2])) 
		write_short( m_iBlood [ 1 ])
		write_short( m_iBlood [ 0 ] )
		write_byte(70)
		write_byte(random_num(1,2))
		message_end()
		
		
	} 
	else if(!is_user_connected(target))
	{
		if(target)
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_DECAL)
			write_coord(aimOrigin[0])
			write_coord(aimOrigin[1])
			write_coord(aimOrigin[2])
			write_byte(GUNSHOT_DECALS[random_num ( 0, sizeof GUNSHOT_DECALS -1 ) ] )
			write_short(target)
			message_end()
		} 
		else 
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_WORLDDECAL)
			write_coord(aimOrigin[0])
			write_coord(aimOrigin[1])
			write_coord(aimOrigin[2])
			write_byte(GUNSHOT_DECALS[random_num ( 0, sizeof GUNSHOT_DECALS -1 ) ] )
			message_end()
		}
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_GUNSHOTDECAL)
		write_coord(aimOrigin[0])
		write_coord(aimOrigin[1])
		write_coord(aimOrigin[2])
		write_short(id)
		write_byte(GUNSHOT_DECALS[random_num ( 0, sizeof GUNSHOT_DECALS -1 ) ] )
		message_end()
	}
}

stock get_weapon_attachment(id, Float:output[3], Float:fDis = 40.0)
{ 
	new Float:vfEnd[3], viEnd[3] 
	get_user_origin(id, viEnd, 3)  
	IVecFVec(viEnd, vfEnd) 
	
	new Float:fOrigin[3], Float:fAngle[3]
	
	pev(id, pev_origin, fOrigin) 
	pev(id, pev_view_ofs, fAngle)
	
	xs_vec_add(fOrigin, fAngle, fOrigin) 
	
	new Float:fAttack[3]
	
	xs_vec_sub(vfEnd, fOrigin, fAttack)
	xs_vec_sub(vfEnd, fOrigin, fAttack) 
	
	new Float:fRate
	
	fRate = fDis / vector_length(fAttack)
	xs_vec_mul_scalar(fAttack, fRate, fAttack)
	
	xs_vec_add(fOrigin, fAttack, output)
}

stock set_weapon_anim(id, anim)
{
	if(!is_user_alive(id))
		return
		
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(anim)
	write_byte(0)
	message_end()	
}

stock set_weapons_timeidle(id, WeaponId ,Float:TimeIdle)
{
	if(!is_user_alive(id))
		return
		
	static entwpn; entwpn = fm_get_user_weapon_entity(id, WeaponId)
	if(!pev_valid(entwpn)) 
		return
		
	set_pdata_float(entwpn, 46, TimeIdle, OFFSET_LINUX_WEAPONS)
	set_pdata_float(entwpn, 47, TimeIdle, OFFSET_LINUX_WEAPONS)
	set_pdata_float(entwpn, 48, TimeIdle + 0.5, OFFSET_LINUX_WEAPONS)
}

stock set_player_nextattack(id, Float:nexttime)
{
	if(!is_user_alive(id))
		return
		
	set_pdata_float(id, m_flNextAttack, nexttime, 5)
}

stock fm_cs_get_weapon_ent_owner(ent)
{
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS)
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

stock Stock_Get_Origin(id, Float:origin[3])
{
	new Float:maxs[3],Float:mins[3]
	if(pev(id,pev_solid)==SOLID_BSP)
	{
		pev(id,pev_maxs,maxs)
		pev(id,pev_mins,mins)
		origin[0] = (maxs[0] - mins[0]) / 2 + mins[0]
		origin[1] = (maxs[1] - mins[1]) / 2 + mins[1]
		origin[2] = (maxs[2] - mins[2]) / 2 + mins[2]
	} else pev(id,pev_origin,origin)
}
stock Set_UserFov(id, FOV)
{
	if(!is_user_connected(id))
		return
		
	set_pdata_int(id, 363, FOV, 5)
	set_pev(id, pev_fov, FOV)
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/