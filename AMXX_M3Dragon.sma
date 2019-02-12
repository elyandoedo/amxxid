#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <fun>
#include <engine>
#define PLUGIN "[CSO] M3 BlackDragon"
#define VERSION "1.0"
#define AUTHOR "EDo"
#pragma compress 1
////FIX
public ShootM3_Dragon(id)
{
	new CURENT_WEAPON = g_weapon[id]
	static Float:Origin[3], Float:angles[3], Float:angles_fix[3], Float:velocity[3]
	get_position(id, 30.0, 1.0, -15.0, Origin)
	
	pev(id,pev_v_angle,angles)
	g_dragon_mode[id] = 0
	new ent = create_entity("info_target") 
	if(!pev_valid(ent)) return;
	
	angles_fix[0] = 360.0 - angles[0]
	angles_fix[1] = angles[1]
	angles_fix[2] = angles[2]
	ShowStatusIcon(id, g_dragon_mode[id])	
	
	engfunc(EngFunc_SetModel, ent, "models/nst_wpn/ef_fireball2.mdl")
	velocity_by_aim(id, 1000, velocity)
	set_pev(ent, pev_classname, M3DRAGON_CLASSNAME)
	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_rendermode, kRenderTransAdd)
	set_pev(ent, pev_renderamt, 25.0)
	set_pev(ent, pev_nextthink, get_gametime() + 0.05)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_mins, { -0.1, -0.1, -0.1 })
	set_pev(ent, pev_maxs, { 0.1, 0.1, 0.1 })
	set_pev(ent, pev_origin, Origin)
	set_pev(ent, pev_angles, angles_fix)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_velocity, velocity)
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_sequence, 0)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_fuser1, get_gametime() + 3.5)
	
	
}
public M3_Dragon_Think(iEnt)
{
	if(!pev_valid(iEnt)) 
		return
	static Float:Time; pev(iEnt, pev_fuser1, Time)
	
	if(Time <= get_gametime())
	{
		set_pev(iEnt, pev_flags, FL_KILLME)
		set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
		return
	}
	set_pev(iEnt, pev_frame, 0.5)
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
	
}
public M3_Dragon_Touch(ptr)
{
	if(!pev_valid(ptr)) 
		return
	static id; id = pev(ptr, pev_owner)
	new CURENT_WEAPON = g_weapon[id]
	new CHANGE_WEAPON = c_wpnchange[CURENT_WEAPON]
	static Float:Origins[3], Float:Originx[3], Float:Angles[3]
	pev(ptr, pev_origin, Origins)
	pev(id, pev_origin, Originx)
	pev(ptr, pev_angles, Angles)
	Angles[0] = 0.0
	/*Origins[2] = Originx[2]*/
	set_pev(ptr, pev_origin, Origins)
	set_pev(ptr, pev_angles, Angles)
	set_pev(ptr, pev_velocity, {0.0, 0.0, 0.0})
	set_pev(ptr, pev_movetype, MOVETYPE_NONE)
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origins[0])
	engfunc(EngFunc_WriteCoord, Origins[1])
	engfunc(EngFunc_WriteCoord, Origins[2])
	write_short(cache_explo)	// sprite index
	write_byte(30)	// scale in 0.1's
	write_byte(30)	// framerate
	write_byte(0)	// flags
	message_end()
	
	// Put decal on "world" (a wall)
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_WORLDDECAL)
	engfunc(EngFunc_WriteCoord, Origins[0])
	engfunc(EngFunc_WriteCoord, Origins[1])
	engfunc(EngFunc_WriteCoord, Origins[2])
	write_byte(random_num(46, 48))
	message_end()	
	
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY)
	write_byte(TE_SMOKE)
	engfunc(EngFunc_WriteCoord, Origins[0])
	engfunc(EngFunc_WriteCoord, Origins[1])
	engfunc(EngFunc_WriteCoord, Origins[2])
	write_short(cache_smoke)	// sprite index 
	write_byte(30)	// scale in 0.1's 
	write_byte(10)	// framerate 
	message_end()
	
	client_cmd(0,"spk weapons/m3dragon_exp.wav")
	for(new i = 0; i < get_maxplayers(); i++)
	{
		if(!is_user_alive(i))
			continue
		if(entity_range(ptr , i) > float(150))
			continue
			
		if(id != i) 
		{
			ExecuteHamB(Ham_TakeDamage, i, get_weapon_ent(id, CHANGE_WEAPON), id, float(750), DMG_BULLET)

		}
		
		
		
	}
	
	set_task(0.7,"M3_Dragon_Effect",ptr)
	
	csx_wpn_dmg_ent(id,1000)
	
		
}
public M3_Dragon_Effect(ptr)
{
	if(!pev_valid(ptr)) 
		return
	set_pev(ptr, pev_rendermode, kRenderTransAdd)
	set_pev(ptr, pev_renderamt, 255.0)
	engfunc(EngFunc_SetModel, ptr, "models/nst_wpn/m3dragon_effect.mdl")
	client_cmd(0,"spk weapons/m3dragon_dragon_fx.wav")
	set_task(0.1,"Damage_M3_Dragon",ptr)
	
	
		
}

public Damage_M3_Dragon(Ent)
{
	if(!pev_valid(Ent))
		return
	static id; id= pev(Ent, pev_owner)
	new CURENT_WEAPON = g_weapon[id]
	new CHANGE_WEAPON = c_wpnchange[CURENT_WEAPON]
	for(new i = 0; i < get_maxplayers(); i++)
	{
		if(!is_user_alive(i))
			continue
		if(entity_range(Ent, i) > float(250))
			continue
			
		if(id != i) 
		{
			//ExecuteHamB(Ham_TakeDamage, i, get_weapon_ent(id, CHANGE_WEAPON), id, float(150), DMG_GENERIC)
			do_attack(id, i, get_weapon_ent(id, CHANGE_WEAPON), float(140))
			static Float:Velocity[3]
			pev(i, pev_velocity, Velocity)
			
			Velocity[2] = 550.0
			set_pev(i, pev_velocity, Velocity)
		}
		
		
	}
	csx_wpn_dmg_ent(id,550)
	set_task(0.05,"Damage_M3_Dragon",Ent)
} 
//////////////////////////
#define V_MODEL "models/v_m3dragon.mdl"
#define P_MODEL "models/p_m3dragon.mdl"
#define W_MODEL "models/w_m3dragon.mdl"
#define MODEL_EFFECT "models/m3dragon_effect.mdl"
#define MODEL_FIRE "models/ef_fireball2.mdl"
new cvar_m3dragon[8]
#define DAMAGE_M3DRAGONX get_pcvar_num(cvar_m3dragon[0])
#define RADIUS_M3DRAGON get_pcvar_num(cvar_m3dragon[1])
#define DAMAGE_M3DRAGON get_pcvar_num(cvar_m3dragon[2])
#define DAMAGE_M3DRAGON2 get_pcvar_num(cvar_m3dragon[3])
#define KNOCK_M3DRAGON get_pcvar_num(cvar_m3dragon[4])
#define M3_DRAGON_AMMO get_pcvar_num(cvar_m3dragon[5])
#define CLIP_M3DRAGON get_pcvar_num(cvar_m3dragon[6])
#define BPAMMO_M3DRAGON get_pcvar_num(cvar_m3dragon[7])

#define CSW_M3DRAGON CSW_M3 
#define weapon_m3dragon "weapon_m3"
#define M3DRAGON_CLASSNAME "tetew"
#define WEAPON_SECRETCODE 28122014
#define OLD_W_MODEL "models/w_m3.mdl"
#define OLD_EVENT "events/m3.sc"

new const WeaponSounds[2][] =
{
	"weapons/m3dragon_shoot1.wav",
	"weapons/m3dragon_shoot2.wav"
}

enum
{
	M3DRAGON_NONE = 0,
	M3DRAGON_MODE
}

// MACROS
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))

new g_Had_M3Dragon, g_Old_Weapon[33]
new g_HamBot, g_MsgCurWeapon, g_Event_M3Dragon, g_SmokePuff_Id, g_dragon_mode[33],cache_smoke, cache_explo,g_BulletCount[33]

// Safety
new g_IsConnected, g_IsAlive, g_PlayerWeapon[33]

// ==========================================================
enum _:ShotGuns {
	m3,
	xm1014
}

const NOCLIP_WPN_BS	= ((1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_KNIFE)|(1<<CSW_C4))
const SHOTGUNS_BS	= ((1<<CSW_M3)|(1<<CSW_XM1014))

// weapons offsets
#define XTRA_OFS_WEAPON			4
#define m_pPlayer				41
#define m_iId					43
#define m_fKnown				44
#define m_flNextPrimaryAttack		46
#define m_flNextSecondaryAttack	47
#define m_flTimeWeaponIdle		48
#define m_iPrimaryAmmoType		49
#define m_iClip				51
#define m_fInReload				54
#define m_fInSpecialReload		55
#define m_fSilent				74

// players offsets
#define XTRA_OFS_PLAYER		5
#define m_flNextAttack		83
#define m_rgAmmo_player_Slot0	376

stock const g_iDftMaxClip[CSW_P90+1] = {
	-1,  13, -1, 10,  1,  7,    1, 30, 30,  1,  30, 
		20, 25, 30, 35, 25,   12, 20, 10, 30, 100, 
		8 , 30, 30, 20,  2,    7, 30, 30, -1,  50}

stock const Float:g_fDelay[CSW_P90+1] = {
	0.00, 2.70, 0.00, 2.00, 0.00, 0.55,   0.00, 3.15, 3.30, 0.00, 4.50, 
		 2.70, 3.50, 3.35, 2.45, 3.30,   2.70, 2.20, 2.50, 2.63, 4.70, 
		 0.55, 3.05, 2.12, 3.50, 0.00,   2.20, 3.00, 2.45, 0.00, 3.40
}

stock const g_iReloadAnims[CSW_P90+1] = {
	-1,  5, -1, 3, -1,  6,   -1, 1, 1, -1, 14, 
		4,  2, 3,  1,  1,   13, 7, 4,  1,  3, 
		6, 11, 1,  3, -1,    4, 1, 1, -1,  1}
		
new Float:g_PostFrame[33]

public plugin_init()
{
	
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")	
	
	// Safety
	Register_SafetyFunc()
	
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack")
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack")		
	
	RegisterHam(Ham_Item_Deploy, weapon_m3dragon, "fw_Item_Deploy_Post", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_m3dragon, "fw_Item_AddToPlayer_Post", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_m3dragon, "fw_Item_PostFrame")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_m3dragon, "fw_Weapon_WeaponIdle")	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_m3dragon, "fw_Weapon_WeaponIdle_Post", 1)	
	register_touch(M3DRAGON_CLASSNAME, "*", "M3_Dragon_Touch");
	register_think(M3DRAGON_CLASSNAME, "M3_Dragon_Think");
	// Cache
	g_MsgCurWeapon = get_user_msgid("CurWeapon")

	register_clcmd("get_m3dragon", "Get_M3Dragon")
	cvar_m3dragon[0]= register_cvar("cvar_m3dragon_damage","86")
	cvar_m3dragon[1]= register_cvar("cvar_m3dragon_radius_exp","150")
	cvar_m3dragon[2]= register_cvar("cvar_m3dragon_damage_exp","750")
	cvar_m3dragon[3]= register_cvar("cvar_m3dragon_damage_dragon","950")
	cvar_m3dragon[4]= register_cvar("cvar_m3dragon_knockback","900")
	cvar_m3dragon[5]= register_cvar("cvar_m3dragon_charge_ammo","8")
	cvar_m3dragon[6]= register_cvar("cvar_m3dragon_clip_ammo","12")
	cvar_m3dragon[7]= register_cvar("cvar_m3dragon_bp_ammo","64")
	
}

public plugin_precache()
{
	precache_model(V_MODEL)
	precache_model(P_MODEL)
	precache_model(W_MODEL)
	precache_model(MODEL_FIRE)
	precache_model(MODEL_EFFECT)
	
	precache_model("sprites/m3dragon_flame.spr")
	precache_model("sprites/m3dragon_flame2.spr")
	precache_sound("weapons/m3dragon_dragon_fx.wav")
	precache_sound("weapons/m3dragon_exp.wav")
	cache_smoke  = precache_model("sprites/steam1.spr")
	cache_explo = precache_model("sprites/fexplo.spr")
	for(new i = 0; i < sizeof(WeaponSounds); i++)
		precache_sound(WeaponSounds[i])
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)	
	g_SmokePuff_Id = engfunc(EngFunc_PrecacheModel, "sprites/wall_puff1.spr")
	engfunc(EngFunc_PrecacheModel, "sprites/zg_hit.spr")
	log_amx("PLUGIN [%s]",PLUGIN)
	log_amx("BY [%s]",AUTHOR)
}

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal(OLD_EVENT, name))
		g_Event_M3Dragon = get_orig_retval()
	
}

public client_putinserver(id)
{
	Safety_Connected(id)
	
	if(!g_HamBot && is_user_bot(id))
	{
		g_HamBot = 1
		set_task(0.1, "Do_Register_HamBot", id)
	}
}

public Do_Register_HamBot(id) 
{
	Register_SafetyFuncBot(id)
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack")
}

public client_disconnect(id)
{
	Safety_Disconnected(id)
}
public plugin_natives()
{
	register_native("Give_M3Dragon", "Get_M3Dragon", 1)
	register_native("Reset_M3Dragon", "Remove_M3Dragon", 1)	
	register_native("Ammo_M3Dragon", "Refill_M3Dragon", 1)
	
}
public Refill_M3Dragon(id)
{
	log_amx("PLUGIN [%s]",PLUGIN)
	log_amx("BY [%s]",AUTHOR)
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Visit**")
	client_print(id,print_chat,"https://facebook.com/elyando.edo")
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Subs For More Free Plugins And Mods :)**")
	client_print(id,print_chat,"https://youtube.com/c/Elyando")
	client_print(id,print_chat,"##################################")
	cs_set_user_bpammo(id, CSW_M3DRAGON, BPAMMO_M3DRAGON)
	
}
public Get_M3Dragon(id)
{
	Remove_M3Dragon(id)
	log_amx("PLUGIN [%s]",PLUGIN)
	log_amx("BY [%s]",AUTHOR)
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Visit**")
	client_print(id,print_chat,"https://facebook.com/elyando.edo")
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Subs For More Free Plugins And Mods :)**")
	client_print(id,print_chat,"https://youtube.com/c/Elyando")
	client_print(id,print_chat,"##################################")
	Set_BitVar(g_Had_M3Dragon, id)
	g_dragon_mode[id] = M3DRAGON_NONE
	give_item(id, weapon_m3dragon)
	cs_set_user_bpammo(id, CSW_M3DRAGON, BPAMMO_M3DRAGON)
	update_specialammo(id, g_dragon_mode[id], 0)
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_M3DRAGON)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP_M3DRAGON)

	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_M3DRAGON)
	write_byte(CLIP_M3DRAGON)
	message_end()
}

public Remove_M3Dragon(id)
{
	log_amx("PLUGIN [%s]",PLUGIN)
	log_amx("BY [%s]",AUTHOR)
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Visit**")
	client_print(id,print_chat,"https://facebook.com/elyando.edo")
	client_print(id,print_chat,"##################################")
	client_print(id,print_chat,"**Subs For More Free Plugins And Mods :)**")
	client_print(id,print_chat,"https://youtube.com/c/Elyando")
	client_print(id,print_chat,"##################################")
	g_dragon_mode[id] = M3DRAGON_NONE
	UnSet_BitVar(g_Had_M3Dragon, id)
	update_specialammo(id, g_dragon_mode[id], 0)
}

public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return
	
	static CSWID; CSWID = read_data(2)
	
	if((CSWID == CSW_M3DRAGON && g_Old_Weapon[id] != CSW_M3DRAGON) && Get_BitVar(g_Had_M3Dragon, id))
	{
		set_pev(id, pev_viewmodel2, V_MODEL)
		set_pev(id, pev_weaponmodel2, "")
		
		Draw_NewWeapon(id, CSWID)
	} else if((CSWID == CSW_M3DRAGON && g_Old_Weapon[id] == CSW_M3DRAGON) && Get_BitVar(g_Had_M3Dragon, id)) {
		static Ent; Ent = fm_get_user_weapon_entity(id, CSW_M3DRAGON)
		if(!pev_valid(Ent))
		{
			g_Old_Weapon[id] = get_user_weapon(id)
			return
		}
		
		set_pdata_float(Ent, 46, get_pdata_float(Ent, 46, 4) * 1.0, 4)
		set_pdata_float(Ent, 47, get_pdata_float(Ent, 46, 4) * 1.0, 4)
	} else if(CSWID != CSW_M3DRAGON && g_Old_Weapon[id] == CSW_M3DRAGON) Draw_NewWeapon(id, CSWID)
	
	g_Old_Weapon[id] = get_user_weapon(id)
}

public Draw_NewWeapon(id, CSW_ID)
{
	if(CSW_ID == CSW_M3DRAGON)
	{
		static ent
		ent = fm_get_user_weapon_entity(id, CSW_M3DRAGON)
		
		if(pev_valid(ent) && Get_BitVar(g_Had_M3Dragon, id))
		{
			set_pev(ent, pev_effects, pev(ent, pev_effects) &~ EF_NODRAW) 
			engfunc(EngFunc_SetModel, ent, P_MODEL)	
		}
	} else {
		static ent
		ent = fm_get_user_weapon_entity(id, CSW_M3DRAGON)
		
		if(pev_valid(ent)) set_pev(ent, pev_effects, pev(ent, pev_effects) | EF_NODRAW) 			
	}
	
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
	
	if(equal(model, OLD_W_MODEL))
	{
		static weapon
		weapon = fm_get_user_weapon_entity(entity, CSW_M3DRAGON)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED
		
		if(Get_BitVar(g_Had_M3Dragon, id))
		{
			set_pev(weapon, pev_impulse, WEAPON_SECRETCODE)
			engfunc(EngFunc_SetModel, entity, W_MODEL)
			
			Remove_M3Dragon(id)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart(id, uc_handle, seed)
{
	if(!is_player(id, 1))
		return
	if(get_player_weapon(id) != CSW_M3DRAGON || !Get_BitVar(g_Had_M3Dragon, id))
		return
		
	static NewButton; NewButton = get_uc(uc_handle, UC_Buttons)
	//static OldButton; OldButton = pev(id, pev_oldbuttons)
	
	if (NewButton & IN_ATTACK2)
	{
		if(g_dragon_mode[id])
		{
			if(get_pdata_float(id, 83, 5) > 0.0)
						return
			NewButton &= ~IN_ATTACK2
			set_uc(uc_handle, UC_Buttons, NewButton)
			Set_Weapon_Idle(id, CSW_M3DRAGON,1.0)
			Set_Player_NextAttack(id, 1.0)
			Set_WeaponAnim(id, 8)
			emit_sound(id, CHAN_WEAPON, WeaponSounds[1], 1.0, ATTN_NORM, 0, PITCH_NORM)
			
			ShootM3_Dragon(id)
		}
	}
}
public ShootM3_Dragon(id)
{
	static Float:Origin[3], Float:angles[3], Float:angles_fix[3], Float:velocity[3]
	get_position(id, 30.0, 1.0, -15.0, Origin)
	
	pev(id,pev_v_angle,angles)
	update_specialammo(id, g_dragon_mode[id], 1)
	g_dragon_mode[id] = M3DRAGON_NONE
	update_specialammo(id, g_dragon_mode[id], 0)
	new ent = create_entity("info_target") 
	if(!pev_valid(ent)) return;
	
	angles_fix[0] = 360.0 - angles[0]
	angles_fix[1] = angles[1]
	angles_fix[2] = angles[2]	
	
	engfunc(EngFunc_SetModel, ent, MODEL_FIRE)
	velocity_by_aim(id, 1000, velocity)
	set_pev(ent, pev_classname, M3DRAGON_CLASSNAME)
	set_pev(ent, pev_movetype, MOVETYPE_FLY)
	set_pev(ent, pev_nextthink, get_gametime() + 0.05)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_mins, { -0.1, -0.1, -0.1 })
	set_pev(ent, pev_maxs, { 0.1, 0.1, 0.1 })
	set_pev(ent, pev_origin, Origin)
	set_pev(ent, pev_angles, angles_fix)
	set_pev(ent, pev_owner, id)
	set_pev(ent, pev_velocity, velocity)
	set_pev(ent, pev_framerate, 1.0)
	set_pev(ent, pev_sequence, 0)
	set_pev(ent, pev_animtime, get_gametime())
	set_pev(ent, pev_fuser1, get_gametime() + 3.5)
	
	
}
public M3_Dragon_Think(iEnt)
{
	if(!pev_valid(iEnt)) 
		return
	static Float:Time; pev(iEnt, pev_fuser1, Time)
	
	if(Time <= get_gametime())
	{
		set_pev(iEnt, pev_flags, FL_KILLME)
		set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
		return
	}
	set_pev(iEnt, pev_frame, 0.5)
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
	
}
public M3_Dragon_Touch(ptr)
{
	if(!pev_valid(ptr)) 
		return
	static id; id = pev(ptr, pev_owner)
	static Float:Origins[3], Float:Originx[3], Float:Angles[3]
	pev(ptr, pev_origin, Origins)
	pev(id, pev_origin, Originx)
	pev(ptr, pev_angles, Angles)
	Angles[0] = 0.0
/*	Origins[2] = Originx[2]*/
	set_pev(ptr, pev_origin, Origins)
	set_pev(ptr, pev_angles, Angles)
	set_pev(ptr, pev_velocity, {0.0, 0.0, 0.0})
	set_pev(ptr, pev_movetype, MOVETYPE_NONE)
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origins[0])
	engfunc(EngFunc_WriteCoord, Origins[1])
	engfunc(EngFunc_WriteCoord, Origins[2])
	write_short(cache_explo)	// sprite index
	write_byte(30)	// scale in 0.1's
	write_byte(30)	// framerate
	write_byte(0)	// flags
	message_end()
	
	// Put decal on "world" (a wall)
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_WORLDDECAL)
	engfunc(EngFunc_WriteCoord, Origins[0])
	engfunc(EngFunc_WriteCoord, Origins[1])
	engfunc(EngFunc_WriteCoord, Origins[2])
	write_byte(random_num(46, 48))
	message_end()	
	
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY)
	write_byte(TE_SMOKE)
	engfunc(EngFunc_WriteCoord, Origins[0])
	engfunc(EngFunc_WriteCoord, Origins[1])
	engfunc(EngFunc_WriteCoord, Origins[2])
	write_short(cache_smoke)	// sprite index 
	write_byte(30)	// scale in 0.1's 
	write_byte(10)	// framerate 
	message_end()
	
	client_cmd(0,"spk weapons/m3dragon_exp.wav")
	for(new i = 0; i < get_maxplayers(); i++)
	{
		if(!is_user_alive(i))
			continue
		if(entity_range(ptr , i) > float(RADIUS_M3DRAGON))
			continue
			
		if(id != i) 
		{
			ExecuteHamB(Ham_TakeDamage, i, 0, id, float(DAMAGE_M3DRAGON), DMG_BULLET)

		}
		
		
	}
	set_task(0.7,"M3_Dragon_Effect",ptr)
	
		
}
public M3_Dragon_Effect(ptr)
{
	if(!pev_valid(ptr)) 
		return
	engfunc(EngFunc_SetModel, ptr, MODEL_EFFECT)
	client_cmd(0,"spk weapons/m3dragon_dragon_fx.wav")
	static ID; ID = pev(ptr, pev_owner)
	Damage_M3_Dragon(ptr, ID)
	
		
}

public Damage_M3_Dragon(Ent, id)
{
	
	for(new i = 0; i < get_maxplayers(); i++)
	{
		if(!is_user_alive(i))
			continue
		if(entity_range(Ent, i) > float(RADIUS_M3DRAGON))
			continue
			
		if(id != i) 
		{
			ExecuteHamB(Ham_TakeDamage, i, 0, id, float(DAMAGE_M3DRAGON2), DMG_BULLET)
			static Float:Velocity[3]
			pev(i, pev_velocity, Velocity)
			
			Velocity[2] = float(KNOCK_M3DRAGON)
			
			if(Velocity[2] < 0.0)
				Velocity[2] = float(KNOCK_M3DRAGON) / 2.0
			
			set_pev(i, pev_velocity, Velocity)
		}
		
		
	}
}
public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_player(id, 1))
		return FMRES_IGNORED	
	if(get_player_weapon(id) == CSW_M3DRAGON && Get_BitVar(g_Had_M3Dragon, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_player(invoker, 0))
		return FMRES_IGNORED		
	if(get_player_weapon(invoker) == CSW_M3DRAGON && Get_BitVar(g_Had_M3Dragon, invoker) && eventid == g_Event_M3Dragon)
	{
		new target, body
		get_user_aiming(invoker, target, body)
		engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)	
		if(g_dragon_mode[invoker] == M3DRAGON_NONE) 
		{
			g_BulletCount[invoker]++
			if(g_BulletCount[invoker] >=  M3_DRAGON_AMMO)
			{
				g_BulletCount[invoker] = 0
				if(!g_dragon_mode[invoker]) 
				{
					g_dragon_mode[invoker] = 1
					update_specialammo(invoker, g_dragon_mode[invoker], 1)
						
				}
			}
		}
		if(is_user_alive(target) && is_user_connected(target))
		{
			Make_Hitmark(invoker)
		}
		
		Set_WeaponAnim(invoker,g_dragon_mode[invoker] ? 8:random_num(1,2))
		emit_sound(invoker, CHAN_WEAPON, WeaponSounds[0], 1.0, ATTN_NORM, 0, PITCH_LOW)	
		return FMRES_SUPERCEDE
	}
	
	return FMRES_HANDLED
}

public fw_TraceAttack(Ent, Attacker, Float:Damage, Float:Dir[3], ptr, DamageType)
{
	if(!is_player(Attacker, 0))
		return HAM_IGNORED	
	if(get_player_weapon(Attacker) != CSW_M3DRAGON || !Get_BitVar(g_Had_M3Dragon, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
	
	get_tr2(ptr, TR_vecEndPos, flEnd)
	get_tr2(ptr, TR_vecPlaneNormal, vecPlane)		
		
	if(!is_player(Ent, 0))
	{
		make_bullet(Attacker, flEnd)
		fake_smoke(Attacker, ptr)
	}
	
	SetHamParamFloat(3, float(DAMAGE_M3DRAGONX) / 6.0)
	
	return HAM_HANDLED	
}

public fw_Item_Deploy_Post(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_M3Dragon, Id))
		return

	set_pev(Id, pev_viewmodel2, V_MODEL)
	set_pev(Id, pev_weaponmodel2, P_MODEL)
	Set_WeaponAnim(Id,g_dragon_mode[Id] ? 12: 6)
	
}

public fw_Item_AddToPlayer_Post(ent, id)
{
	if(pev(ent, pev_impulse) == WEAPON_SECRETCODE)
	{
		Set_BitVar(g_Had_M3Dragon, id)
		set_pev(ent, pev_impulse, 0)
	}			
}

public fw_Weapon_WeaponIdle( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return 
	static id; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)
	if(get_pdata_cbase(id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_M3Dragon, id))
		return
	
	if( get_pdata_float(iEnt, m_flTimeWeaponIdle, XTRA_OFS_WEAPON) > 0.0 )
	{
		return
	}
	
	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = CLIP_M3DRAGON

	static iClip ; iClip = get_pdata_int(iEnt, m_iClip, XTRA_OFS_WEAPON)
	static fInSpecialReload ; fInSpecialReload = get_pdata_int(iEnt, m_fInSpecialReload, XTRA_OFS_WEAPON)

	if( !iClip && !fInSpecialReload )
	{
		return
	}

	if( fInSpecialReload )
	{
		static iBpAmmo ; iBpAmmo = get_pdata_int(id, 381, XTRA_OFS_PLAYER)
		static iDftMaxClip ; iDftMaxClip = g_iDftMaxClip[iId]

		if( iClip < iMaxClip && iClip == iDftMaxClip && iBpAmmo )
		{
			Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
			return
		}
		else if( iClip == iMaxClip && iClip != iDftMaxClip )
		{
			Set_WeaponAnim(id,g_dragon_mode[id] ? 10: 4)
			set_pdata_int(iEnt, m_fInSpecialReload, 0, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.5, XTRA_OFS_WEAPON)
		}
	}
	
	return
}


public fw_Weapon_WeaponIdle_Post( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return 
	static id; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)
	if(get_pdata_cbase(id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_M3Dragon, id))
		return
		
	static SpecialReload; SpecialReload = get_pdata_int(iEnt, 55, 4)
	if(!SpecialReload && get_pdata_float(iEnt, 48, 4) <= 0.25)
	{
		Set_WeaponAnim(id,g_dragon_mode[id] ? 7: 0)
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public fw_Item_PostFrame( iEnt )
{
	static id ; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)	

	static iBpAmmo ; iBpAmmo = get_pdata_int(id, 381, XTRA_OFS_PLAYER)
	static iClip ; iClip = get_pdata_int(iEnt, m_iClip, XTRA_OFS_WEAPON)
	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = CLIP_M3DRAGON

	// Support for instant reload (used for example in my plugin "Reloaded Weapons On New Round")
	// It's possible in default cs
	if( get_pdata_int(iEnt, m_fInReload, XTRA_OFS_WEAPON) && get_pdata_float(id, m_flNextAttack, 5) <= 0.0 )
	{
		new j = min(iMaxClip - iClip, iBpAmmo)
		set_pdata_int(iEnt, m_iClip, iClip + j, XTRA_OFS_WEAPON)
		set_pdata_int(id, 381, iBpAmmo-j, XTRA_OFS_PLAYER)
		
		set_pdata_int(iEnt, m_fInReload, 0, XTRA_OFS_WEAPON)
		return
	}

	static iButton ; iButton = pev(id, pev_button)
	if( iButton & IN_ATTACK && get_pdata_float(iEnt, m_flNextPrimaryAttack, XTRA_OFS_WEAPON) <= 0.0 )
	{
		return
	}
	
	if( iButton & IN_RELOAD  )
	{
		if( iClip >= iMaxClip )
		{
			set_pev(id, pev_button, iButton & ~IN_RELOAD) // still this fucking animation
			set_pdata_float(iEnt, m_flNextPrimaryAttack, 0.5, XTRA_OFS_WEAPON)  // Tip ?
		}

		else if( iClip == g_iDftMaxClip[iId] )
		{
			if( iBpAmmo )
			{
				Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
			}
		}
	}
	
	if(get_pdata_int(iEnt, 55, 4) == 1)
	{
		static Float:CurTime
		CurTime = get_gametime()
		
		if(CurTime - 0.35 > g_PostFrame[id])
		{
			Set_WeaponAnim(id,g_dragon_mode[id] ? 9: 3)
			g_PostFrame[id] = CurTime
		}
	}
}

Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
{
	if(iBpAmmo <= 0 || iClip == iMaxClip)
		return

	if(get_pdata_int(iEnt, m_flNextPrimaryAttack, XTRA_OFS_WEAPON) > 0.0)
		return

	switch( get_pdata_int(iEnt, m_fInSpecialReload, XTRA_OFS_WEAPON) )
	{
		case 0:
		{
			Set_WeaponAnim(id,g_dragon_mode[id] ? 11: 5)
			set_pdata_int(iEnt, m_fInSpecialReload, 1, XTRA_OFS_WEAPON)
			set_pdata_float(id, m_flNextAttack, 0.55, 5)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 0.55, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flNextPrimaryAttack, 0.55, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flNextSecondaryAttack, 0.55, XTRA_OFS_WEAPON)
			return
		}
		case 1:
		{
			if( get_pdata_float(iEnt, m_flTimeWeaponIdle, XTRA_OFS_WEAPON) > 0.0 )
			{
				return
			}
			set_pdata_int(iEnt, m_fInSpecialReload, 2, XTRA_OFS_WEAPON)
			
			
			set_pdata_float(iEnt, m_flTimeWeaponIdle, iId == CSW_XM1014 ? 0.30 : 0.45, XTRA_OFS_WEAPON)
		}
		default:
		{
			set_pdata_int(iEnt, m_iClip, iClip + 1, XTRA_OFS_WEAPON)
			set_pdata_int(id, 381, iBpAmmo-1, XTRA_OFS_PLAYER)
			set_pdata_int(iEnt, m_fInSpecialReload, 1, XTRA_OFS_WEAPON)
		}
	}
}


stock Set_WeaponAnim(id, anim)
{
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

stock Set_Weapon_Idle(id, WeaponId ,Float:TimeIdle)
{
	static entwpn; entwpn = fm_get_user_weapon_entity(id, WeaponId)
	if(!pev_valid(entwpn)) 
		return
		
	set_pdata_float(entwpn, 46, TimeIdle, 4)
	set_pdata_float(entwpn, 47, TimeIdle, 4)
	set_pdata_float(entwpn, 48, TimeIdle + 0.5, 4)
}

stock Set_Player_NextAttack(id, Float:NextTime) set_pdata_float(id, 83, NextTime, 5)
stock make_bullet(id, Float:Origin[3])
{
	// Find target
	new decal = random_num(41, 45)
	const loop_time = 2
	
	static Body, Target
	get_user_aiming(id, Target, Body, 999999)
	
	if(is_user_connected(Target))
		return
	
	for(new i = 0; i < loop_time; i++)
	{
		// Put decal on "world" (a wall)
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_WORLDDECAL)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_byte(decal)
		message_end()
		
		// Show sparcles
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_GUNSHOTDECAL)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_short(id)
		write_byte(decal)
		message_end()
	}
}

stock fake_smoke(id, trace_result)
{
	static Float:vecSrc[3], Float:vecEnd[3], TE_FLAG
	
	get_weapon_attachment(id, vecSrc)
	global_get(glb_v_forward, vecEnd)
    
	xs_vec_mul_scalar(vecEnd, 8192.0, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecEnd)

	get_tr2(trace_result, TR_vecEndPos, vecSrc)
	get_tr2(trace_result, TR_vecPlaneNormal, vecEnd)
    
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
	write_short(g_SmokePuff_Id)
	write_byte(2)
	write_byte(50)
	write_byte(TE_FLAG)
	message_end()
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

stock get_position(ent, Float:forw, Float:right, Float:up, Float:vStart[])
{
	static Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(ent, pev_origin, vOrigin)
	pev(ent, pev_view_ofs,vUp) //for player
	xs_vec_add(vOrigin,vUp,vOrigin)
	pev(ent, pev_v_angle, vAngle) // if normal entity ,use pev_angles
	
	angle_vector(vAngle,ANGLEVECTOR_FORWARD,vForward) //or use EngFunc_AngleVectors
	angle_vector(vAngle,ANGLEVECTOR_RIGHT,vRight)
	angle_vector(vAngle,ANGLEVECTOR_UP,vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}

public update_specialammo(id, Ammo, On)
{
	static AmmoSprites[33]
	format(AmmoSprites, sizeof(AmmoSprites), "number_%d", Ammo)
  	
	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("StatusIcon"), {0,0,0}, id)
	write_byte(On)
	write_string(AmmoSprites)
	write_byte(0) // red
	write_byte(85) // green
	write_byte(255) // blue
	message_end()	
}
public Make_Hitmark(id)
{
	static Float:Origin[3], TE_FLAG
	get_position(id, float(70), float(0), float(-4), Origin)
	TE_FLAG |= TE_EXPLFLAG_NODLIGHTS
	TE_FLAG |= TE_EXPLFLAG_NOSOUND
	TE_FLAG |= TE_EXPLFLAG_NOPARTICLES
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, Origin, id)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(engfunc(EngFunc_PrecacheModel, "sprites/zg_hit.spr"))
	write_byte(3)
	write_byte(30)
	write_byte(TE_FLAG)
	message_end()
}
/* ===============================
------------- SAFETY -------------
=================================*/
public Register_SafetyFunc()
{
	register_event("CurWeapon", "Safety_CurWeapon", "be", "1=1")
	
	RegisterHam(Ham_Spawn, "player", "fw_Safety_Spawn_Post", 1)
	RegisterHam(Ham_Killed, "player", "fw_Safety_Killed_Post", 1)
}

public Register_SafetyFuncBot(id)
{
	RegisterHamFromEntity(Ham_Spawn, id, "fw_Safety_Spawn_Post", 1)
	RegisterHamFromEntity(Ham_Killed, id, "fw_Safety_Killed_Post", 1)
}

public Safety_Connected(id)
{
	Set_BitVar(g_IsConnected, id)
	UnSet_BitVar(g_IsAlive, id)
	
	g_PlayerWeapon[id] = 0
}

public Safety_Disconnected(id)
{
	UnSet_BitVar(g_IsConnected, id)
	UnSet_BitVar(g_IsAlive, id)
	
	g_PlayerWeapon[id] = 0
}

public Safety_CurWeapon(id)
{
	if(!is_player(id, 1))
		return
		
	static CSW; CSW = read_data(2)
	if(g_PlayerWeapon[id] != CSW) g_PlayerWeapon[id] = CSW
}

public fw_Safety_Spawn_Post(id)
{
	if(!is_user_alive(id))
		return
		
	Set_BitVar(g_IsAlive, id)
}

public fw_Safety_Killed_Post(id)
{
	UnSet_BitVar(g_IsAlive, id)
}

public is_player(id, IsAliveCheck)
{
	if(!(1 <= id <= 32))
		return 0
	if(!Get_BitVar(g_IsConnected, id))
		return 0
	if(IsAliveCheck)
	{
		if(Get_BitVar(g_IsAlive, id)) return 1
		else return 0
	}
	
	return 1
}

public get_player_weapon(id)
{
	if(!is_player(id, 1))
		return 0
	
	return g_PlayerWeapon[id]
}

/* ===============================
--------- End of SAFETY ----------
=================================*/
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
