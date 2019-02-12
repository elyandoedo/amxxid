/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <xs>
#include <fun>
#include <csx_zp>

#define PLUGIN "FAKE BUNKER"
#define VERSION "2.0"
#define AUTHOR "EDo"

#define CSW_BUNKER CSW_HEGRENADE
#define weapon_bunker "weapon_hegrenade"
#define old_w_model "models/w_hegrenade.mdl"
#define WEAPON_SECRETCODE 4234234

#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))
//
const m_flTimeWeaponIdle	= 48
new g_Had_Bunker, bisa_nembak, lagi_ngeker, cvar_bunker[5]
new Bunker_sExplo, Bunker_sFireExp, Bunker_sSmoke, Bunker_sTrail
// Safety
new g_IsConnected, g_IsAlive, g_PlayerWeapon[33], g_HamBot
#define p_model "models/p_bunkerbuster.mdl"
#define v_model "models/v_bunkerbuster.mdl"
#define w_model "models/w_bunkerbuster.mdl"
#define s_model "models/bunkerbuster_missile.mdl"
#define target_model "models/bunkerbuster_target.mdl"
#define plane_model "models/bunkerbuster_target.mdl"
#define sight_model "models/v_bunkerbuster_sight.mdl"

#define BUNKER_CLASSNAME "BUNKER_BOMB"
#define BUNKER_EXP "weapons/bunkerbuster_explosion_1st.wav"
#define BUNKER_EXP_FIRE "weapons/bunkerbuster_fire.wav"
#define BUNKER_ZOOM_IN "weapons/bunkerbuster_zoom_in.wav"
#define BUNKER_ZOOM_OUT "weapons/bunkerbuster_zoom_out.wav"

new const bunker_call[] = "weapons/bunkerbuster_target_siren.wav"
new const bunker_use[] = "weapons/bunkerbuster_gauge.wav"
new const bunker_fly[] = "weapons/bunkerbuster_fly.wav"
new const bunker_drop[] = "weapons/bunkerbuster_whistling3.wav"
#define bunker_time_remove get_pcvar_float(cvar_bunker[0])
#define bunker_time_attack get_pcvar_float(cvar_bunker[1])
#define bunker_dmg get_pcvar_float(cvar_bunker[2])
#define bunker_speed get_pcvar_float(cvar_bunker[3])
#define bunker_reload get_pcvar_float(cvar_bunker[4])
enum (+= 100)
{
	TASK_LAUNCH = 2000,
	TASK_CALLBOMB,
	TASK_DROPBOMB,
	TASK_STOPBOMB,
	TASK_FLY,
	TASK_SIGHT_BEGIN
}
#define ID_LAUNCH (taskid - TASK_LAUNCH)
#define ID_SIGHT_BEGIN (taskid - TASK_SIGHT_BEGIN)
new g_Base
#define jarak_antara_kita1 200.0
#define jarak_antara_kita2 100.0
#define tinggi 300.0
#define kecepatan 2000
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	Register_SafetyFunc()
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	register_event("DeathMsg", "Event_Death", "a")	
	register_event("HLTV", "event_start_freezetime", "a", "1=0", "2=0")
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1)
	RegisterHam(Ham_Item_Deploy, weapon_bunker, "fw_Item_Deploy_Post", 1)	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_bunker, "fw_Weapon_WeaponIdle_Post", 1)
	register_forward(FM_SetModel, "fw_SetModel")	
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	
	register_touch(BUNKER_CLASSNAME, "*", "fw_Touch_tn7")
	register_clcmd("get_bunker", "Get_Bunker")
	g_Base = Mileage_RegisterWeapon("bunker")
	cvar_bunker[0] = register_cvar("bunker_time_remove","13.0")
	cvar_bunker[1] = register_cvar("bunker_time_attack","0.5")
	cvar_bunker[2] = register_cvar("bunker_damage","450.0")
	cvar_bunker[3] = register_cvar("bunker_speed_missile","1500.0")
	cvar_bunker[4] = register_cvar("bunker_reload","20.0")
	
}
public plugin_precache()
{
	Bunker_sSmoke = precache_model("sprites/bunkerbuster_smoke.spr")
	Bunker_sExplo = precache_model("sprites/bunkerbuster_explosion.spr")
	Bunker_sFireExp = precache_model("sprites/bunkerbuster_fire.spr")
	Bunker_sTrail = precache_model("sprites/zbeam2.spr")
	/////////////////////////
	precache_model(p_model) 
	precache_model(v_model) 
	precache_model(w_model) 
	precache_model(s_model) 
	precache_model(target_model) 
	precache_model(sight_model) 
	precache_model(plane_model) 
	////////////////////////
	precache_sound(BUNKER_EXP)
	precache_sound(BUNKER_EXP_FIRE)
	precache_sound(BUNKER_ZOOM_IN) 
	precache_sound(BUNKER_ZOOM_OUT) 
	precache_sound(bunker_call)
	precache_sound(bunker_use)
	precache_sound(bunker_fly)
	precache_sound(bunker_drop)
	////////////////////////
}
public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return
//	if(is_model(id,v_model)) Get_Bunker(id)
	new g_old_weapon[33]	
	if(get_user_weapon(id) == CSW_BUNKER && Get_BitVar(g_Had_Bunker, id))
	{
		set_pev(id, pev_weaponmodel2, p_model)
		if(Get_BitVar(lagi_ngeker,id)) set_pev(id, pev_viewmodel2, sight_model)
		else set_pev(id, pev_viewmodel2, v_model)
	}
	//else 
	
	g_old_weapon[id] = get_user_weapon(id)
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_BUNKER && Get_BitVar(g_Had_Bunker, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}
public Mileage_WeaponGet(id, ItemID)
{
	if(ItemID == g_Base) Get_Bunker(id)
}

public Mileage_WeaponRemove(id, ItemID)
{
	if(ItemID == g_Base) Remove_Bunker(id)
}

public Get_Bunker(id)
{
	
	Set_BitVar(g_Had_Bunker, id)
	Set_BitVar(bisa_nembak,id)
	UnSet_BitVar(lagi_ngeker,id)
	give_item(id, weapon_bunker)
	remove_task(id+TASK_LAUNCH)
	remove_task(id+TASK_CALLBOMB)
	remove_task(id+TASK_DROPBOMB)
	remove_task(id+TASK_STOPBOMB)
	remove_task(id+TASK_FLY)
	client_print(id,print_chat,"You Get Bunker!")
	// Clip & Ammo
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_BUNKER)
	if(!pev_valid(Ent)) return
	cs_set_user_bpammo(id, CSW_BUNKER, 2)
}
/*
public Get_Bunker(id)
{
	if(Get_BitVar(g_Had_Bunker, id)) return
	Set_BitVar(g_Had_Bunker, id)
	Set_BitVar(bisa_nembak,id)
	UnSet_BitVar(lagi_ngeker,id)
}*/

public Remove_Bunker(id)
{
	UnSet_BitVar(g_Had_Bunker, id)
	UnSet_BitVar(bisa_nembak,id)
	UnSet_BitVar(lagi_ngeker,id)
	remove_task(id+TASK_LAUNCH)
	remove_task(id+TASK_CALLBOMB)
	remove_task(id+TASK_DROPBOMB)
	remove_task(id+TASK_STOPBOMB)
	remove_task(id+TASK_FLY)
	reset_zoom(id)
}

public event_start_freezetime()
{
	remove_entity_name(BUNKER_CLASSNAME)
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
	
}
public Event_Death()
{
	static Victim; Victim = read_data(2)
	UnSet_BitVar(g_IsAlive, Victim)
	Remove_Bunker(Victim)
}
public client_disconnect(id)
{
	Safety_Disconnected(id)
}
public fw_PlayerSpawn_Post(id) 
{
	Set_BitVar(g_IsAlive, id)
	
}

public fw_Item_Deploy_Post(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Bunker, Id))
		return
	set_pev(Id, pev_viewmodel2, p_model)
	set_pev(Id, pev_weaponmodel2, v_model)
	reset_zoom(Id)
	Set_WeaponAnim(Id, 3)
}
public fw_Weapon_WeaponIdle_Post(Ent)
{
	if(pev_valid(Ent) != 2)
		return HAM_IGNORED	
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return HAM_IGNORED	
	if(!Get_BitVar(g_Had_Bunker, Id))
		return HAM_IGNORED	

	if(get_pdata_float(Ent, 48, 4) <= 0.1) 
	{
		if(Get_BitVar(lagi_ngeker,Id)) Set_WeaponAnim(Id, 1)
		else Set_WeaponAnim(Id, 0)
		set_pdata_float(Ent, 48, 20.0, 4)
	}
	
	return HAM_IGNORED	
}
public task_reset_bomb(id)
{
	id-=TASK_LAUNCH
	client_print(id,print_chat,"Bunker Ready")
	cs_set_user_bpammo(id, CSW_HEGRENADE, 2)
	Set_BitVar(bisa_nembak,id)
}	
public use_bomb(id)
{
	if(!is_user_connected(id) || !Get_BitVar(bisa_nembak,id)|| !is_user_alive(id)) return PLUGIN_CONTINUE
	UnSet_BitVar(bisa_nembak,id)
	emit_sound(id, CHAN_VOICE, bunker_use, 1.0, 0.5, 0, 100)
	if(task_exists(id+TASK_LAUNCH)) remove_task(id+TASK_LAUNCH)
	if(task_exists(id+TASK_CALLBOMB)) remove_task(id+TASK_CALLBOMB)
	if(is_user_alive(id)) set_task(bunker_reload, "task_reset_bomb", id+TASK_LAUNCH)
	if(is_user_alive(id)) set_task(3.0, "call_bomb", id+TASK_CALLBOMB)
	return PLUGIN_CONTINUE
}

#define jarak_antara_kita1 200.0
#define jarak_antara_kita2 100.0
new Float:MyOrigin[3]
new Float:MyTarget[3]
new Float:StartPesawat[3]
new Float:StopPesawat[3]
public call_bomb(id)
{
	id -= TASK_CALLBOMB
	if(!is_user_alive(id)) return
	fm_get_aim_origin(id, MyOrigin)
	fm_get_aim_origin(id, MyTarget)
	static Float:Origintouchbaru1[3], Float:Origintouchbaru2[3], Float:Origintouchbaru3[3], Float:Origintouchbaru4[3]
	Origintouchbaru1[0] = MyOrigin[0] - jarak_antara_kita1
	Origintouchbaru1[1] = MyOrigin[1] 
	Origintouchbaru1[2] = MyOrigin[2]
	
	Origintouchbaru2[0] = MyOrigin[0] + jarak_antara_kita1
	Origintouchbaru2[1] = MyOrigin[1] 
	Origintouchbaru2[2] = MyOrigin[2]
	
	Origintouchbaru3[0] = MyOrigin[0] - jarak_antara_kita2
	Origintouchbaru3[1] = MyOrigin[1] 
	Origintouchbaru3[2] = MyOrigin[2]
	
	Origintouchbaru4[0] = MyOrigin[0] + jarak_antara_kita2
	Origintouchbaru4[1] = MyOrigin[1] 
	Origintouchbaru4[2] = MyOrigin[2]
	
	StartPesawat[0] = MyOrigin[0] - jarak_antara_kita1
	StartPesawat[1] = MyOrigin[1] 
	StartPesawat[2] = MyOrigin[2]
	
	StopPesawat[0] = MyOrigin[0] + jarak_antara_kita2
	StopPesawat[1] = MyOrigin[1] 
	StopPesawat[2] = MyOrigin[2]
	create_target(id, Origintouchbaru1)
	create_target(id, Origintouchbaru2)
	create_target(id, Origintouchbaru3)
	create_target(id, Origintouchbaru4)
	create_target(id, MyOrigin)
	
	emit_sound(id, CHAN_VOICE, bunker_call, 1.0, 0.5, 0, 100)
	Set_WeaponAnim(id, 2)
	set_weapons_timeidle(id, 1.0)
	reset_zoom(id)
	cs_set_user_bpammo(id, CSW_HEGRENADE, 1)
	call_plane(id, StartPesawat)
}

public call_plane(id, Float:origin[3])
{
	
	new ent = create_entity("info_target")
	origin[0] -= 500.0
	origin[2] += 500.0
	entity_set_origin(ent, origin)
	engfunc(EngFunc_SetModel, ent, plane_model)
	entity_set_int(ent, EV_INT_movetype, MOVETYPE_NOCLIP)
	set_entity_visibility(ent, 0)

	emit_sound(ent, CHAN_STATIC, bunker_fly, 1.0, 0.1, 0, 100)
	
	set_task(3.7, "task_fly", ent+TASK_FLY)
	set_task(4.5, "drop_bomb", id+TASK_DROPBOMB)
}
public task_fly(ent)
{
	ent-= TASK_FLY
	if(!is_valid_ent(ent)) return
	set_entity_visibility(ent, 1)
	StopPesawat[0] -= 500.0
	StopPesawat[2] += 500.0
	ent_move_to(ent, StopPesawat, 2000)
	set_task(12.0, "task_stop", ent+TASK_STOPBOMB)
	
}

public task_stop(ent)
{
	ent-=TASK_STOPBOMB
	if(!is_valid_ent(ent)) return
	
	set_entity_visibility(ent, 0)
	
	set_task(15.4, "task_remove", ent+TASK_STOPBOMB)
}
public task_remove(ent)
{
	ent-=TASK_STOPBOMB
	if(!is_valid_ent(ent)) return
	
	remove_entity(ent)
}
public drop_bomb(id)
{
	id-= TASK_DROPBOMB
	if(!is_user_alive(id)) return
	
	static Float:Origintouchbaru1[3], Float:Origintouchbaru2[3], Float:Origintouchbaru3[3], Float:Origintouchbaru4[3]
	Origintouchbaru1[0] = MyOrigin[0] - jarak_antara_kita1
	Origintouchbaru1[1] = MyOrigin[1] 
	Origintouchbaru1[2] = MyOrigin[2]
	
	Origintouchbaru2[0] = MyOrigin[0] + jarak_antara_kita1
	Origintouchbaru2[1] = MyOrigin[1] 
	Origintouchbaru2[2] = MyOrigin[2]
	
	Origintouchbaru3[0] = MyOrigin[0] - jarak_antara_kita2
	Origintouchbaru3[1] = MyOrigin[1] 
	Origintouchbaru3[2] = MyOrigin[2]
	
	Origintouchbaru4[0] = MyOrigin[0] + jarak_antara_kita2
	Origintouchbaru4[1] = MyOrigin[1] 
	Origintouchbaru4[2] = MyOrigin[2]
	static Float:OriginTargetBaru1[3], Float:OriginTargetBaru2[3], Float:OriginTargetBaru3[3], Float:OriginTargetBaru4[3]
	OriginTargetBaru1[0] = MyTarget[0] - jarak_antara_kita1
	OriginTargetBaru1[1] = MyTarget[1] 
	OriginTargetBaru1[2] = MyTarget[2]
	
	OriginTargetBaru2[0] = MyTarget[0] + jarak_antara_kita1
	OriginTargetBaru2[1] = MyTarget[1] 
	OriginTargetBaru2[2] = MyTarget[2]
	
	OriginTargetBaru3[0] = MyTarget[0] - jarak_antara_kita2
	OriginTargetBaru3[1] = MyTarget[1] 
	OriginTargetBaru3[2] = MyTarget[2]
	
	OriginTargetBaru4[0] = MyTarget[0] + jarak_antara_kita2
	OriginTargetBaru4[1] = MyTarget[1] 
	OriginTargetBaru4[2] = MyTarget[2]
	remove_entity_name("bunkertarget")
	create_bomb(id, Origintouchbaru1,OriginTargetBaru1)
	create_bomb(id, Origintouchbaru2,OriginTargetBaru2)
	create_bomb(id, Origintouchbaru3,OriginTargetBaru3)
	create_bomb(id, Origintouchbaru4,OriginTargetBaru4)
	create_bomb(id, MyOrigin,MyTarget)
	emit_sound(id, CHAN_STATIC, bunker_drop, 1.0, 0.1, 0, 100)
}

public create_bomb(attacker, Float:origin[3], Float:target[3])
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	set_pev(ent, pev_classname, BUNKER_CLASSNAME)
	set_pev(ent, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(ent, pev_maxs, Float:{1.0, 1.0, 1.0})
	origin[2] += 300.0
	set_pev(ent, pev_origin, origin)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_owner, attacker)
	
	
	engfunc(EngFunc_SetModel, ent, s_model)
	set_pev(ent, pev_movetype, 6)

	ent_move_to(ent, target, 1000)
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte(TE_BEAMFOLLOW)
	write_short(ent)		//entity
	write_short(Bunker_sTrail)	//model
	write_byte(6)			//10)//life
	write_byte(3)			//5)//width
	write_byte(224)			//r
	write_byte(224)			//g
	write_byte(255)			//b
	write_byte(100)			//brightness
	message_end()	
}
public create_target(attacker, Float:origin[3])
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	set_pev(ent, pev_classname, "bunkertarget")
	set_pev(ent, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(ent, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(ent, pev_origin, origin)
	set_pev(ent, pev_solid, SOLID_BBOX)
	set_pev(ent, pev_owner, attacker)
	engfunc(EngFunc_SetModel, ent, target_model)	
	set_pev(ent, pev_movetype, 6)
	set_entity_anim(ent, 0)
	

}
public fw_Touch_tn7(Ent, Id)
{
	// If ent is valid
	if(!pev_valid(Ent))
		return
	if(pev(Ent, pev_movetype) == MOVETYPE_NONE)
		return
	new Float:entOrigin[3]
	pev(Ent, pev_origin, entOrigin)
	entOrigin[2] += 1.0
	// create effect exp
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY); 
	write_byte(TE_EXPLOSION); // TE_EXPLOSION
	write_coord(floatround(entOrigin[0])); // origin x
	write_coord(floatround(entOrigin[1])); // origin y
	write_coord(floatround(entOrigin[2])); // origin z
	write_short(Bunker_sExplo); // sprites
	write_byte(40); // scale in 0.1's
	write_byte(30); // framerate
	write_byte(TE_EXPLFLAG_NONE); // flags 
	message_end(); // message end
	
	/*message_begin(MSG_BROADCAST, SVC_TEMPENTITY)  // Rauchwolke ����Ч��
	write_byte(5)
	write_coord(floatround(entOrigin[0])); // origin x
	write_coord(floatround(entOrigin[1])); // origin y
	write_coord(floatround(entOrigin[2])); // origin z
	write_short(Bunker_sSmoke)
	write_byte(35)
	write_byte(5)
	message_end()*/
	
	set_pev(Ent, pev_movetype, MOVETYPE_NONE)
	set_pev(Ent, pev_solid, SOLID_NOT)
	engfunc(EngFunc_SetModel, Ent, "")
	entity_set_float(Ent, EV_FL_nextthink, halflife_time() + 0.01)
	engfunc(EngFunc_EmitSound, Ent, CHAN_WEAPON, BUNKER_EXP, 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	set_task(bunker_time_attack, "action_scythe", Ent)
	set_task(bunker_time_attack+bunker_time_remove, "remove", Ent)
}

public remove(Ent)
{
	if(!pev_valid(Ent))
		return
		
	remove_entity(Ent)
	
}
public explode(Ent)
{
	new Float:originZ[3], Float:originX[3]
	pev(Ent, pev_origin, originX)
	entity_get_vector(Ent, EV_VEC_origin, originZ)
	
	static Float:Origintouchbaru1[3], Float:Origintouchbaru2[3], Float:Origintouchbaru3[3], Float:Origintouchbaru4[3]
	Origintouchbaru1[0] = originZ[0] - 100.0
	Origintouchbaru1[1] = originZ[1]
	Origintouchbaru1[2] = originZ[2]+65.0
	
	Origintouchbaru2[0] = originZ[0] + 100.0
	Origintouchbaru2[1] = originZ[1]
	Origintouchbaru2[2] = originZ[2]+65.0
	
	Origintouchbaru3[0] = originZ[0]
	Origintouchbaru3[1] = originZ[1] - 100.0
	Origintouchbaru3[2] = originZ[2]+65.0
	
	Origintouchbaru4[0] = originZ[0]
	Origintouchbaru4[1] = originZ[1] + 100.0
	Origintouchbaru4[2] = originZ[2]+65.0
	///////////API TENGAH
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_SPRITE)
	engfunc(EngFunc_WriteCoord, originZ[0])
	engfunc(EngFunc_WriteCoord, originZ[1])
	engfunc(EngFunc_WriteCoord, originZ[2]+65.0)
	write_short(Bunker_sFireExp) // Sprite index
	write_byte(5) // Scale
	write_byte(50) // Framerate
	message_end()
	if(!is_wall_between_points(originZ, Origintouchbaru1, Ent))
	{
		///////////API 1
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_SPRITE)
		engfunc(EngFunc_WriteCoord, Origintouchbaru1[0])
		engfunc(EngFunc_WriteCoord,Origintouchbaru1[1])
		engfunc(EngFunc_WriteCoord, Origintouchbaru1[2])
		write_short(Bunker_sFireExp) // Sprite index
		write_byte(5) // Scale
		write_byte(50) // Framerate
		message_end()
	}
	if(!is_wall_between_points(originZ, Origintouchbaru2, Ent))
	{
		///////////API 2
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_SPRITE)
		engfunc(EngFunc_WriteCoord, Origintouchbaru2[0])
		engfunc(EngFunc_WriteCoord,Origintouchbaru2[1])
		engfunc(EngFunc_WriteCoord, Origintouchbaru2[2])
		write_short(Bunker_sFireExp) // Sprite index
		write_byte(5) // Scale
		write_byte(50) // Framerate
		message_end()
	}
	if(!is_wall_between_points(originZ, Origintouchbaru3, Ent))
	{
		///////////API 3
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_SPRITE)
		engfunc(EngFunc_WriteCoord, Origintouchbaru3[0])
		engfunc(EngFunc_WriteCoord,Origintouchbaru3[1])
		engfunc(EngFunc_WriteCoord, Origintouchbaru3[2])
		write_short(Bunker_sFireExp) // Sprite index
		write_byte(5) // Scale
		write_byte(50) // Framerate
		message_end()
	}
	if(!is_wall_between_points(originZ, Origintouchbaru4, Ent))
	{
		///////////API 4
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_SPRITE)
		engfunc(EngFunc_WriteCoord, Origintouchbaru4[0])
		engfunc(EngFunc_WriteCoord,Origintouchbaru4[1])
		engfunc(EngFunc_WriteCoord, Origintouchbaru4[2])
		write_short(Bunker_sFireExp) // Sprite index
		write_byte(5) // Scale
		write_byte(50) // Framerate
		message_end()
	}
	
	engfunc(EngFunc_EmitSound, Ent, CHAN_WEAPON, BUNKER_EXP_FIRE, 1.0, ATTN_NORM, 0, PITCH_NORM)
}
public action_scythe(Ent)
{
	if(!pev_valid(Ent))
		return
	explode(Ent)	
	Damage_scythe(Ent)
}
public Damage_scythe(Ent)
{
	if(!pev_valid(Ent))
		return
	
	static id; id = pev(Ent, pev_owner)
	new Float:origin[3]
	pev(Ent, pev_origin, origin)
	// Alive...
	new a = FM_NULLENT
	// Get distance between victim and epicenter
	while((a = find_ent_in_sphere(a, origin, 350.0)) != 0)
	{
		if (id == a)
			continue
	
		if(pev(a, pev_takedamage) != DAMAGE_NO)
		{
			ExecuteHamB(Ham_TakeDamage, a, id, id, bunker_dmg, DMG_BULLET)
		}
	}
	set_task(0.5, "action_scythe", Ent)
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
	
	if(equal(model, old_w_model))
	{
		static weapon
		weapon = fm_get_user_weapon_entity(entity, CSW_BUNKER)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED
		
		if(Get_BitVar(g_Had_Bunker, id))
		{
			UnSet_BitVar(g_Had_Bunker, id)
			
			set_pev(weapon, pev_impulse, WEAPON_SECRETCODE)
			
			engfunc(EngFunc_SetModel, entity, w_model)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart(id, uc_handle, seed)
{
	if(!is_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_BUNKER || !Get_BitVar(g_Had_Bunker, id))
		return FMRES_IGNORED
	
	
	static buttons
	buttons = get_uc(uc_handle, UC_Buttons)
		
	if(buttons & IN_ATTACK)
	{
		create_zoom(id, uc_handle)
		buttons &= ~IN_ATTACK
		set_uc(uc_handle, UC_Buttons, buttons)
		if(Get_BitVar(lagi_ngeker,id))use_bomb(id)
	}
	if(buttons & IN_ATTACK2)
	{
		create_zoom(id, uc_handle)
	}
	if (Get_BitVar(lagi_ngeker,id) && get_user_weapon(id) != CSW_BUNKER)
	{
		reset_zoom(id)
	}
	return FMRES_HANDLED
}
create_zoom(id, uc_handle)
{
	
	// create zoom
	new buttons = get_uc(uc_handle, UC_Buttons)
	if ((buttons & IN_ATTACK2) && !(pev(id, pev_oldbuttons) & IN_ATTACK2))
	{
		
		if(!Get_BitVar(lagi_ngeker,id))
		{
			PlayEmitSound(id, BUNKER_ZOOM_IN, CHAN_ITEM)
			set_weapons_timeidle(id, 1.0)
			Set_WeaponAnim(id, 1)
			if (task_exists(id+TASK_SIGHT_BEGIN)) remove_task(id+TASK_SIGHT_BEGIN)
			set_task(0.5, "task_set_model_sight_begin", id+TASK_SIGHT_BEGIN)
		}
		else if (Get_BitVar(lagi_ngeker,id))
		{
			PlayEmitSound(id, BUNKER_ZOOM_OUT, CHAN_ITEM)
			set_weapons_timeidle(id, 1.0)
			Set_WeaponAnim(id, 2)
			reset_zoom(id)
		}
	}
		
	
}
public task_set_model_sight_begin(taskid)
{
	new id = ID_SIGHT_BEGIN
	cs_set_user_zoom(id, CS_SET_AUGSG552_ZOOM, 0)
	Set_BitVar(lagi_ngeker,id)
	set_pev(id, pev_viewmodel2, sight_model)
}
remove_zoom(id, uc_handle)
{
	reset_zoom(id)
	remove_wpnzoom(id, uc_handle)
	
}
reset_zoom(id)
{
	UnSet_BitVar(lagi_ngeker,id)
	cs_set_user_zoom(id, CS_RESET_ZOOM, 0)
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
	if(!is_alive(id))
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

public fw_say_Killed_Post(id)
{
	UnSet_BitVar(g_IsAlive, id)
}

public is_alive(id)
{
	if(!(1 <= id <= 32))
		return 0
	if(!Get_BitVar(g_IsConnected, id))
		return 0
	if(!Get_BitVar(g_IsAlive, id)) 
		return 0
	
	return 1
}

public is_connected(id)
{
	if(!(1 <= id <= 32))
		return 0
	if(!Get_BitVar(g_IsConnected, id))
		return 0
	
	return 1
}

public get_player_weapon(id)
{
	if(!is_alive(id))
		return 0
	
	return g_PlayerWeapon[id]
}
/* ===============================
------------- STOCK -------------
=================================*/
stock is_wall_between_points(Float:start[3], Float:end[3], ignore_ent)
{
	static ptr
	ptr = create_tr2()

	engfunc(EngFunc_TraceLine, start, end, IGNORE_MONSTERS, ignore_ent, ptr)
	
	static Float:EndPos[3]
	get_tr2(ptr, TR_vecEndPos, EndPos)

	free_tr2(ptr)
	return floatround(get_distance_f(end, EndPos))
}	
set_weapons_timeidle(id, Float:timeidle)
{
	new entwpn = get_weapon_ent(id, get_user_weapon(id))
	if (pev_valid(entwpn)) set_pdata_float(entwpn, m_flTimeWeaponIdle, timeidle+3.0, 4)
}
get_weapon_ent(id, weaponid)
{
	static wname[32], weapon_ent
	get_weaponname(weaponid, wname, charsmax(wname))
	weapon_ent = fm_find_ent_by_owner(-1, wname, id)
	return weapon_ent
}
PlayEmitSound(id, const sound[], type)
{
	emit_sound(id, type, sound, 1.0, ATTN_NORM, 0, PITCH_NORM)
}

stock get_speed_vector(const Float:origin1[3],const Float:origin2[3],Float:speed, Float:new_velocity[3])
{
	new_velocity[0] = origin2[0] - origin1[0]
	new_velocity[1] = origin2[1] - origin1[1]
	new_velocity[2] = origin2[2] - origin1[2]
	static Float:num; num = floatsqroot(speed*speed / (new_velocity[0]*new_velocity[0] + new_velocity[1]*new_velocity[1] + new_velocity[2]*new_velocity[2]))
	new_velocity[0] *= num
	new_velocity[1] *= num
	new_velocity[2] *= num
	
	return 1;
}
stock set_entity_anim(ent, anim)
{
	entity_set_float(ent, EV_FL_animtime, get_gametime())
	entity_set_float(ent, EV_FL_framerate, 1.0)
	entity_set_int(ent, EV_INT_sequence, anim)	
}
stock Set_WeaponAnim(id, anim)
{
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}
stock get_position(id,Float:forw, Float:right, Float:up, Float:vStart[], check=1)
{
	static Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(id, pev_origin, vOrigin)
	if(is_user_connected(id)){
		pev(id, pev_view_ofs, vUp) //for player
		xs_vec_add(vOrigin, vUp, vOrigin)
	}
	pev(id, pev_v_angle, vAngle) // if normal entity ,use pev_angles
	
	if(!check) vAngle[0] = 0.0
	
	angle_vector(vAngle, ANGLEVECTOR_FORWARD, vForward) //or use EngFunc_AngleVectors
	angle_vector(vAngle, ANGLEVECTOR_RIGHT, vRight)
	angle_vector(vAngle, ANGLEVECTOR_UP, vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}	
stock aim_at_origin(id, Float:target[3], Float:angles[3])
{
	static Float:vec[3]
	pev(id,pev_origin,vec)
	vec[0] = target[0] - vec[0]
	vec[1] = target[1] - vec[1]
	vec[2] = target[2] - vec[2]
	engfunc(EngFunc_VecToAngles,vec,angles)
	angles[0] *= -1.0, angles[2] = 0.0
}
stock ent_move_to(ent, Float:target[3], speed)
{
	// set vel
	static Float:vec[3]
	aim_at_origin(ent,target,vec)
	engfunc(EngFunc_MakeVectors, vec)
	global_get(glb_v_forward, vec)
	vec[0] *= speed
	vec[1] *= speed
	vec[2] *= speed
	set_pev(ent, pev_velocity, vec)
		
	// turn to target
	new Float:angle[3]
	aim_at_origin(ent, target, angle)
	angle[0] *= -1.0
	entity_set_vector(ent, EV_VEC_angles, angle)
}
