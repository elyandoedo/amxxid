#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <xs>
#include <fun>
#pragma compress 1
#define PLUGIN "AMXX Desperado"
#define VERSION "1.0"
#define AUTHOR "EDo"

// Data Config
#define P_DESPERADO_M "models/p_desperado_m.mdl"
#define P_DESPERADO_W "models/p_desperado_w.mdl"

#define V_DESPERADO "models/v_desperado.mdl"
#define W_DESPERADO "models/w_desperado.mdl"

#define MODEL_W_OLD "models/w_deagle.mdl"
#define SOUND_FIRE "weapons/desperado_shoot1.wav"

#define CSW_DESPERADO CSW_DEAGLE
#define weapon_desperado "weapon_deagle"
#define WEAPON_EVENT "events/deagle.sc"
#define WEAPON_CODE 1182015

enum
{
	DESPERADO_IDLE_M = 0,
	DESPERADO_RUN_START_M,
	DESPERADO_RUN_IDLE_M,
	DESPERADO_RUN_END_M,
	DESPERADO_DRAW_M,
	DESPERADO_SHOOT_M,
	DESPERADO_RELOAD_M,
	DESPERADO_SWAB_M,
	DESPERADO_IDLE_W,
	DESPERADO_RUN_START_W,
	DESPERADO_RUN_IDLE_W,
	DESPERADO_RUN_END_W,
	DESPERADO_DRAW_W,
	DESPERADO_SHOOT_W,
	DESPERADO_RELOAD_W,
	DESPERADO_SWAB_W,
}


// Weapon Config
#define DAMAGE 70
#define ACCURACY 23 // 0 - 100 ; -1 Default
#define CLIP 7
#define BPAMMO 999
#define SPEED 0.12
#define RECOIL 0.5
#define RELOAD_TIME 0.3
#define CHANGE_TIME 0.1
#define TASK_CHANGE 92319319
// MACROS
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))

new g_Mode_w, g_Lagi_Charge,g_ready
new g_Had_Base, g_Clip[33], g_OldWeapon[33], Float:g_Recoil[33][3]
new g_Event_Base, g_SmokePuff_SprId, g_MsgCurWeapon

// Safety
new g_HamBot

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	
	// Event
	register_event("CurWeapon", "Fuck_Decompile", "be", "1=1")
	
	// Forward
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_SetModel, "fw_SetModel")	
	register_forward(FM_CmdStart, "Decompile_Kontol")	
	
	// Ham
	RegisterHam(Ham_Item_Deploy, weapon_desperado, "fw_Item_Deploy_Post", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_desperado, "fw_Item_AddToPlayer_Post", 1)
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_desperado, "fw_Weapon_WeaponIdle_Post", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_desperado, "fw_Item_PostFrame")	
	RegisterHam(Ham_Weapon_Reload, weapon_desperado, "fw_Weapon_Reload")
	RegisterHam(Ham_Weapon_Reload, weapon_desperado, "fw_Weapon_Reload_Post", 1)	
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_desperado, "fw_Weapon_PrimaryAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_desperado, "fw_Weapon_PrimaryAttack_Post", 1)
	
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player")	
	
	// Cache
	g_MsgCurWeapon = get_user_msgid("CurWeapon")
	
	register_clcmd("get_desperado", "Get_Base")
}
public plugin_precache()
{
	precache_model(P_DESPERADO_M)
	precache_model(P_DESPERADO_W)
	precache_model(V_DESPERADO)
	precache_model(W_DESPERADO)
	precache_sound(SOUND_FIRE)
	engfunc(EngFunc_PrecacheModel, "sprites/muzzleflash64.spr")
	g_SmokePuff_SprId = engfunc(EngFunc_PrecacheModel, "sprites/wall_puff1.spr")
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)
}

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(WEAPON_EVENT, name)) g_Event_Base = get_orig_retval()		
}

public client_putinserver(id)
{
    
	
	if(!g_HamBot && is_user_bot(id))
	{
		g_HamBot = 1
		set_task(0.1, "Register_HamBot", id)
	}
}
 
public Register_HamBot(id)
{
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_Player")	
}

public plugin_natives ()
{
	register_native("give_desperado", "native_get", 1)
	register_native("remove_desperado", "native_remove", 1)
	register_native("refill_desperado", "native_refill", 1)
}
public native_get(id)
{
	Get_Base(id)
}

public native_refill(id)
{
	cs_set_user_bpammo(id, CSW_DESPERADO, BPAMMO)
}

public native_remove(id)
{
	Remove_Base(id)
}

public Get_Base(id)
{
	if(!is_user_alive(id)) return;
	
	
	fm_give_item(id, weapon_desperado)
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_DESPERADO)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP)
	cs_set_user_bpammo(id, CSW_DESPERADO, BPAMMO)
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Visit**")
	client_print(id,print_chat,"https://facebook.com/elyando.edo")
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Subs For More Free Plugins And Mods :)**")
	client_print(id,print_chat,"https://youtube.com/c/Elyando")
	client_print(id,print_chat,"##################################")
	Set_WeaponAnim(id, Get_BitVar(g_Mode_w, id) ? DESPERADO_IDLE_W: DESPERADO_IDLE_M)
	Set_BitVar(g_Had_Base, id)
	UnSet_BitVar(g_ready, id)
	UnSet_BitVar(g_Mode_w, id)
	UnSet_BitVar(g_Lagi_Charge, id)
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_DESPERADO)
	write_byte(CLIP)
	message_end()
	
	
}

public Remove_Base(id)
{
	
	UnSet_BitVar(g_ready, id)
	UnSet_BitVar(g_Lagi_Charge, id)
	UnSet_BitVar(g_Had_Base, id)
	UnSet_BitVar(g_Mode_w, id)
	
}

public Fuck_Decompile(id)
{
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, id))
		return
	
	static CSWID; CSWID = read_data(2)
	
	if((CSWID == CSW_DESPERADO && g_OldWeapon[id] != CSW_DESPERADO) && Get_BitVar(g_Had_Base, id))
	{
		set_pev(id, pev_viewmodel2, V_DESPERADO)
		Draw_NewWeapon(id, CSWID)
	} else if((CSWID == CSW_DESPERADO && g_OldWeapon[id] == CSW_DESPERADO) && Get_BitVar(g_Had_Base, id)) {
		static Ent; Ent = fm_get_user_weapon_entity(id, CSW_DESPERADO)
		if(!pev_valid(Ent))
		{
			g_OldWeapon[id] = get_user_weapon(id)
			return
		}
	//	set_pev(id, pev_viewmodel2, V_DESPERADO)
		set_pdata_float(Ent, 46, SPEED, 4)
		set_pdata_float(Ent, 47, SPEED, 4)
	} else if(CSWID != CSW_DESPERADO && g_OldWeapon[id] == CSW_DESPERADO) {
		Draw_NewWeapon(id, CSWID)
	}
	
	g_OldWeapon[id] = get_user_weapon(id)
}

public Draw_NewWeapon(id, CSW_ID)
{
	if(CSW_ID == CSW_DESPERADO)
	{
		static ent
		ent = fm_get_user_weapon_entity(id, CSW_DESPERADO)
		
		if(pev_valid(ent) && Get_BitVar(g_Had_Base, id))
		{
			set_pev(ent, pev_effects, pev(ent, pev_effects) &~ EF_NODRAW) 
			engfunc(EngFunc_SetModel, ent, Get_BitVar(g_Mode_w, id) ? P_DESPERADO_W : P_DESPERADO_M)
			
			
		}
	} else {
		static ent
		ent = fm_get_user_weapon_entity(id, CSW_DESPERADO)
		
		if(pev_valid(ent)) set_pev(ent, pev_effects, pev(ent, pev_effects) | EF_NODRAW) 			
	}
	
}
public Decompile_Kontol(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, id))
		return
	static Float:Next; Next = get_pdata_float(id, 83, 5)
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_DESPERADO)
	static iButton
	new iState = Get_BitVar(g_Mode_w, id)
	iButton = get_uc(uc_handle, UC_Buttons)
	new iChange = 0;
	if (iButton & IN_ATTACK || iButton & IN_ATTACK2)
	{
		if ((iState && (iButton & IN_ATTACK)) || (!iState && (iButton & IN_ATTACK2)))
			iChange = 1;
		else
			iChange = -1;
		
		iButton &= ~IN_ATTACK;
		iButton &= ~IN_ATTACK2;
		set_pev(id, pev_button, iButton);
	}
	if (iChange == 1)
	{
		iState = 1 - iState;
		change_special(id)
		return;
	}
	else if (iChange == -1)
	{
		if(Next > 0.0) return
		ExecuteHamB(Ham_Weapon_PrimaryAttack, Ent)
		set_pdata_float(id, 83, 0.175, 5);
		
	}
}
public change_special(id)
{
	if(Get_BitVar(g_Lagi_Charge, id))
			return 
	if(get_pdata_float(id, 83, 5) <= 0.0)
	{
		UnSet_BitVar(g_ready, id)
		Set_BitVar(g_Lagi_Charge, id)
		if(get_user_weapon(id) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, id))
			return 
		set_pev(id, pev_weaponmodel2, Get_BitVar(g_Mode_w, id) ? P_DESPERADO_W: P_DESPERADO_M)
		if(!Get_BitVar(g_Mode_w, id))
		{
			Set_WeaponAnim(id, DESPERADO_SWAB_W)
		}
		if(Get_BitVar(g_Mode_w, id))
		{
			Set_WeaponAnim(id, DESPERADO_SWAB_W)
		}
		Set_WeaponIdleTime(id,CSW_DESPERADO,1.0)
		if (task_exists(id+TASK_CHANGE)) remove_task(id+TASK_CHANGE)
		set_task(CHANGE_TIME, "ready", id+TASK_CHANGE)
		
	}
	
}
public ready(id)
{
	id -= TASK_CHANGE
	if(get_user_weapon(id) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, id))
		return 
	UnSet_BitVar(g_Lagi_Charge, id)
	Set_BitVar(g_ready, id)
	if(!Get_BitVar(g_Mode_w, id))
	{
		Set_BitVar(g_Mode_w, id)
	}
	else UnSet_BitVar(g_Mode_w, id)
	set_pev(id, pev_weaponmodel2, Get_BitVar(g_Mode_w, id) ? P_DESPERADO_W: P_DESPERADO_M)
	
	Set_WeaponAnim(id, Get_BitVar(g_Mode_w, id) ? DESPERADO_IDLE_W: DESPERADO_IDLE_M)
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_DESPERADO)	
	new szClip, szAmmo
	get_user_weapon(id, szClip, szAmmo)
	new clip_max = CLIP
	if (szClip>=clip_max || !szAmmo) 
		return;	
	new clip_set = min(clip_max, szClip+szAmmo)
	new ammo_set = max(0, szAmmo-(clip_set-szClip))
	cs_set_weapon_ammo(Ent, CLIP)	
	cs_set_user_bpammo(id, CSW_DESPERADO, ammo_set)
	
}
public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_DESPERADO && Get_BitVar(g_Had_Base, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(invoker))
		return FMRES_IGNORED	
	if(get_user_weapon(invoker) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, invoker))
		return FMRES_IGNORED
	if(eventid != g_Event_Base)
		return FMRES_IGNORED
	
	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)

	Set_WeaponAnim(invoker, Get_BitVar(g_Mode_w, invoker) ? DESPERADO_SHOOT_W : DESPERADO_SHOOT_M)
	emit_sound(invoker, CHAN_WEAPON, SOUND_FIRE, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	return FMRES_SUPERCEDE
}

public fw_SetModel(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static Classname[32]
	pev(entity, pev_classname, Classname, sizeof(Classname))
	
	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner
	iOwner = pev(entity, pev_owner)
	
	if(equal(model, MODEL_W_OLD))
	{
		static weapon; weapon = find_ent_by_owner(-1, weapon_desperado, entity)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED;
		
		if(Get_BitVar(g_Had_Base, iOwner))
		{
			set_pev(weapon, pev_impulse, WEAPON_CODE)
			engfunc(EngFunc_SetModel, entity, W_DESPERADO)

			Remove_Base(iOwner)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_Item_Deploy_Post(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Base, Id))
		return
	set_pev(Id, pev_viewmodel2, V_DESPERADO)
	set_pev(Id, pev_weaponmodel2, Get_BitVar(g_Mode_w, Id) ? P_DESPERADO_W: P_DESPERADO_M)
	Set_WeaponAnim(Id, Get_BitVar(g_Mode_w, Id) ? DESPERADO_DRAW_W : DESPERADO_DRAW_M)
}

public fw_Item_AddToPlayer_Post(Ent, id)
{
	if(!pev_valid(Ent))
		return HAM_IGNORED
		
	if(pev(Ent, pev_impulse) == WEAPON_CODE)
	{
		Set_BitVar(g_Had_Base, id)
		set_pev(Ent, pev_impulse, 0)
	}
	
	return HAM_HANDLED	
}

public fw_Item_PostFrame(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Base, id))
		return HAM_IGNORED	
	
	static Float:flNextAttack; flNextAttack = get_pdata_float(id, 83, 5)
	static bpammo; bpammo = cs_get_user_bpammo(id, CSW_DESPERADO)
	
	static iClip; iClip = get_pdata_int(ent, 51, 4)
	static fInReload; fInReload = get_pdata_int(ent, 54, 4)
	
	if(fInReload && flNextAttack <= 0.0)
	{
		static temp1
		temp1 = min(CLIP - iClip, bpammo)

		set_pdata_int(ent, 51, iClip + temp1, 4)
		cs_set_user_bpammo(id, CSW_DESPERADO, bpammo - temp1)		
		
		set_pdata_int(ent, 54, 0, 4)
		
		fInReload = 0
	}		
	
	return HAM_IGNORED
}

public fw_Weapon_Reload(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Base, id))
		return HAM_IGNORED	

	g_Clip[id] = -1
		
	static BPAmmo; BPAmmo = cs_get_user_bpammo(id, CSW_DESPERADO)
	static iClip; iClip = get_pdata_int(ent, 51, 4)
		
	if(BPAmmo <= 0)
		return HAM_SUPERCEDE
	if(iClip >= CLIP)
		return HAM_SUPERCEDE		
			
	g_Clip[id] = iClip
	
	return HAM_HANDLED
}

public fw_Weapon_Reload_Post(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Base, id))
		return HAM_IGNORED	
	
	if((get_pdata_int(ent, 54, 4) == 1))
	{ // Reload
		if(g_Clip[id] == -1)
			return HAM_IGNORED
		
		set_pdata_int(ent, 51, g_Clip[id], 4)
		
		Set_WeaponAnim(id, Get_BitVar(g_Mode_w, id) ? DESPERADO_RELOAD_W : DESPERADO_RELOAD_M)
		Set_PlayerNextAttack(id, RELOAD_TIME)
	}
	
	return HAM_HANDLED
}

public fw_Weapon_WeaponIdle_Post( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return
	static Id; Id = get_pdata_cbase(iEnt, 41, 4)
	if(get_pdata_cbase(Id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_Base, Id))
		return

	if(get_pdata_float(iEnt, 48, 4) <= 0.1)
	{
		Set_WeaponAnim(Id,  Get_BitVar(g_Mode_w, Id) ? DESPERADO_IDLE_W : DESPERADO_IDLE_M)
		set_pdata_float(iEnt, 48, 20.0, 4)
	}
}

public fw_TraceAttack_World(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
		
	get_tr2(Ptr, TR_vecEndPos, flEnd)
	get_tr2(Ptr, TR_vecPlaneNormal, vecPlane)		
			
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, float(DAMAGE))
	
	return HAM_HANDLED
}

public fw_TraceAttack_Player(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_DESPERADO || !Get_BitVar(g_Had_Base, Attacker))
		return HAM_IGNORED

	SetHamParamFloat(3, float(DAMAGE))
	return HAM_HANDLED
}

public fw_Weapon_PrimaryAttack(Ent)
{
	static id; id = pev(Ent, pev_owner)
	if(!is_user_alive(id))
		return
	if(!Get_BitVar(g_Had_Base, id))
		return
	if(cs_get_weapon_ammo(Ent) > 0) 
	{
		Make_Muzzleflash(id,11)
	}
	pev(id, pev_punchangle, g_Recoil[id])
}
public Make_Muzzleflash(id,size)
{
	static Float:Origin[3], TE_FLAG
	if(Get_BitVar(g_Mode_w, id)) get_position(id, 32.0, get_cvar_num("cl_righthand") ? -6.0 : 6.0, -15.0, Origin)
	else get_position(id, 32.0, get_cvar_num("cl_righthand") ? 6.0 : -6.0, -15.0, Origin)	
	TE_FLAG |= TE_EXPLFLAG_NODLIGHTS
	TE_FLAG |= TE_EXPLFLAG_NOSOUND
	TE_FLAG |= TE_EXPLFLAG_NOPARTICLES
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, Origin, id)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(engfunc(EngFunc_PrecacheModel, "sprites/muzzleflash64.spr"))
	write_byte(2)
	write_byte(size)
	write_byte(TE_FLAG)
	message_end()
}
public fw_Weapon_PrimaryAttack_Post(Ent)
{
	static id; id = pev(Ent, pev_owner)
	if(!is_user_alive(id))
		return
	if(!Get_BitVar(g_Had_Base, id))
		return

	static Float:Push[3]
	pev(id, pev_punchangle, Push)
	xs_vec_sub(Push, g_Recoil[id], Push)
	
	xs_vec_mul_scalar(Push, RECOIL, Push)
	xs_vec_add(Push, g_Recoil[id], Push)
	
	set_pev(id, pev_punchangle, Push)
	
	// Acc
	static Accena; Accena = ACCURACY
	if(Accena != -1)
	{
		static Float:Accuracy
		Accuracy = (float(100 - ACCURACY) * 1.5) / 100.0

		set_pdata_float(Ent, 62, Accuracy, 4);
	}
	set_pdata_int(Ent, 64, 0, 4)
	
}



/* ===============================
--------- END OF SAFETY  ---------
=================================*/

stock Set_WeaponAnim(id, anim)
{
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

stock Make_BulletHole(id, Float:Origin[3], Float:Damage)
{
	// Find target
	static Decal; Decal = random_num(41, 45)
	static LoopTime; 
	
	if(Damage > 100.0) LoopTime = 2
	else LoopTime = 1
	
	for(new i = 0; i < LoopTime; i++)
	{
		// Put decal on "world" (a wall)
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_WORLDDECAL)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_byte(Decal)
		message_end()
		
		// Show sparcles
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_GUNSHOTDECAL)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_short(id)
		write_byte(Decal)
		message_end()
	}
}

stock Make_BulletSmoke(id, TrResult)
{
	static Float:vecSrc[3], Float:vecEnd[3], TE_FLAG
	
	get_weapon_attachment(id, vecSrc)
	global_get(glb_v_forward, vecEnd)
    
	xs_vec_mul_scalar(vecEnd, 8192.0, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecEnd)

	get_tr2(TrResult, TR_vecEndPos, vecSrc)
	get_tr2(TrResult, TR_vecPlaneNormal, vecEnd)
    
	xs_vec_mul_scalar(vecEnd, 2.5, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecEnd)
    
	TE_FLAG |= TE_EXPLFLAG_NODLIGHTS
	TE_FLAG |= TE_EXPLFLAG_NOSOUND
	TE_FLAG |= TE_EXPLFLAG_NOPARTICLES
	
	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, vecEnd, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, vecEnd[0])
	engfunc(EngFunc_WriteCoord, vecEnd[1])
	engfunc(EngFunc_WriteCoord, vecEnd[2] - 10.0)
	write_short(g_SmokePuff_SprId)
	write_byte(2)
	write_byte(50)
	write_byte(TE_FLAG)
	message_end()
}

stock get_weapon_attachment(id, Float:output[3], Float:fDis = 40.0)
{ 
	static Float:vfEnd[3], viEnd[3] 
	get_user_origin(id, viEnd, 3)  
	IVecFVec(viEnd, vfEnd) 
	
	static Float:fOrigin[3], Float:fAngle[3]
	
	pev(id, pev_origin, fOrigin) 
	pev(id, pev_view_ofs, fAngle)
	
	xs_vec_add(fOrigin, fAngle, fOrigin) 
	
	static Float:fAttack[3]
	
	xs_vec_sub(vfEnd, fOrigin, fAttack)
	xs_vec_sub(vfEnd, fOrigin, fAttack) 
	
	static Float:fRate
	
	fRate = fDis / vector_length(fAttack)
	xs_vec_mul_scalar(fAttack, fRate, fAttack)
	
	xs_vec_add(fOrigin, fAttack, output)
}

stock get_position(id,Float:forw, Float:right, Float:up, Float:vStart[])
{
	new Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(id, pev_origin, vOrigin)
	pev(id, pev_view_ofs,vUp) //for player
	xs_vec_add(vOrigin,vUp,vOrigin)
	pev(id, pev_v_angle, vAngle) // if normal entity ,use pev_angles
	
	angle_vector(vAngle,ANGLEVECTOR_FORWARD,vForward) //or use EngFunc_AngleVectors
	angle_vector(vAngle,ANGLEVECTOR_RIGHT,vRight)
	angle_vector(vAngle,ANGLEVECTOR_UP,vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}

stock get_speed_vector(const Float:origin1[3],const Float:origin2[3],Float:speed, Float:new_velocity[3])
{
	new_velocity[0] = origin2[0] - origin1[0]
	new_velocity[1] = origin2[1] - origin1[1]
	new_velocity[2] = origin2[2] - origin1[2]
	new Float:num = floatsqroot(speed*speed / (new_velocity[0]*new_velocity[0] + new_velocity[1]*new_velocity[1] + new_velocity[2]*new_velocity[2]))
	new_velocity[0] *= num
	new_velocity[1] *= num
	new_velocity[2] *= num
	
	return 1;
}

stock Set_WeaponIdleTime(id, WeaponId ,Float:TimeIdle)
{
	static entwpn; entwpn = fm_get_user_weapon_entity(id, WeaponId)
	if(!pev_valid(entwpn)) 
		return
		
	set_pdata_float(entwpn, 46, TimeIdle, 4)
	set_pdata_float(entwpn, 47, TimeIdle, 4)
	set_pdata_float(entwpn, 48, TimeIdle + 0.5, 4)
}

stock Set_PlayerNextAttack(id, Float:nexttime)
{
	set_pdata_float(id, 83, nexttime, 5)
}


stock Get_Position(id,Float:forw, Float:right, Float:up, Float:vStart[])
{
	static Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(id, pev_origin, vOrigin)
	pev(id, pev_view_ofs,vUp) //for player
	xs_vec_add(vOrigin,vUp,vOrigin)
	pev(id, pev_v_angle, vAngle) // if normal entity ,use pev_angles
	
	angle_vector(vAngle,ANGLEVECTOR_FORWARD,vForward) //or use EngFunc_AngleVectors
	angle_vector(vAngle,ANGLEVECTOR_RIGHT,vRight)
	angle_vector(vAngle,ANGLEVECTOR_UP,vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}
