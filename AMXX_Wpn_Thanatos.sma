#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <fun>

#define PLUGIN "THANATOS SERIES"
#define VERSION "1.0"
#define AUTHOR "EDo" //based plugin Dias no Pendragon

#define DAMAGE 42 // 84 for zombie
#define CLIP 7
#define BPAMMO 35
#define RELOAD_TIME 2.0
#define SCYTHE_SPEED 800.0

#define DAMAGE_TN3 25 // 45 for zombie
#define CLIP_TN3 60
#define BPAMMO_TN3 240
#define SCYTHE_SLASHTIME_TN3 7.0
#define STAGE_AMMO_TN3 10 // every x ammo -> stage up
#define RELOAD_TIME_TN3 3.25

#define DAMAGE_A_TN5 29 // 58 for zombie
#define DAMAGE_B_TN5 150 // 300 for zombie
#define CLIP_TN5 30
#define SCYTHE_RADIUS_TN5 120.0

#define DAMAGE_A_TN9 1000
#define DAMAGE_B_TN9 500
#define RADIUS_TN9 100.0
#define SLASH_DELAY_TN9 0.9
#define FALLEN_GALVATRON_TIME_TN9 5.0
#define CHANGE_TIME_MEGATRON_TN9 5.0
#define CHANGE_TIME_GALVATRON_TN9 3.5

#define DAMAGE_A_TN7 33 // 66 for zombie
#define DAMAGE_B_TN7 50 // 250 for zombie
#define CLIP_TN7 120
#define SCYTHE_LIFETIME_TN7 10.0

#define DAMAGE_A_TN11 140 // 140 for zombie, 70 for human
#define DAMAGE_B_TN11 560 // 560 for zombie, 280 for human
#define CLIP_TN11 15
#define BPAMMO_TN11 64
#define SPEED_TN11 0.85
#define SCYTHE_RELOAD 5.0 // Reload Time per one
#define SCYTHE_MAX 3 // Max Ammo

#define V_MODEL_TN11 "models/v_thanatos11_fix.mdl"
#define P_MODEL_TN11 "models/p_thanatos11.mdl"
#define W_MODEL_TN11 "models/w_thanatos11.mdl"
#define S_MODEL_TN11 "models/thanatos11_scythe.mdl"

#define V_MODEL_TN7 "models/v_thanatos7.mdl"
#define P_MODEL_TN7 "models/p_thanatos7.mdl"
#define W_MODEL_TN7 "models/w_thanatos7.mdl"
#define S_MODEL_TN7 "models/thanatos7_scythe.mdl"

#define V_MODEL "models/v_thanatos1.mdl"
#define P_MODEL "models/p_thanatos1.mdl"
#define W_MODEL "models/w_thanatos1.mdl"
#define S_MODEL "models/s_thanatos1.mdl"

#define V_MODEL_TN3 "models/v_thanatos3.mdl"
#define P_MODEL_TN3 "models/p_thanatos3.mdl"
#define W_MODEL_TN3 "models/w_thanatos3.mdl"
#define W_MODEL2_TN3 "models/w_thanatos3b.mdl"
#define S_MODEL_TN3 "models/thanatos3_knife.mdl"
#define S_MODEL2_TN3 "models/thanatos3_wind.mdl"

#define V_MODEL_TN5 "models/v_thanatos5.mdl"
#define P_MODEL_TN5 "models/p_thanatos5.mdl"
#define W_MODEL_TN5 "models/w_thanatos5.mdl"
#define S_MODEL_TN5 "models/thanatos5_bulleta.mdl"

#define MODEL_V_TN9 "models/v_thanatos9.mdl"
#define MODEL_PA_TN9 "models/p_thanatos9a.mdl"
#define MODEL_PB_TN9 "models/p_thanatos9b.mdl"
#define MODEL_PC_TN9 "models/p_thanatos9c.mdl"

#define THANATOS5_OLDMODEL "models/w_m4a1.mdl"
#define THANATOS3_OLDMODEL "models/w_mp5.mdl"
#define THANATOS1_OLDMODEL "models/w_deagle.mdl"

#define TASK_RELOAD_TN5 31515
#define TASK_CHANGING 32615
#define TASK_SLASHING_TN9 29411
#define TASK_CHANGING_TN9 29412
#define TASK_CHANGE_TN11 23332
#define TASK_RELOAD_TN7 12115

#define WEAPON_ANIMEXTA_TN9 "knife"
#define WEAPON_ANIMEXTB_TN9 "m249"
#define ANIME_EXT_TN3 "onehanded"

#define SCYTHE_CLASSNAME_TN7 "scythe"
#define SCYTHE_CLASSNAME_TN11 "scythe11"
#define SCYTHE_CLASSNAME "shikkoku"
#define SCYTHE_CLASSNAME_TN3 "saisu"
#define SCYTHE_CLASSNAME_TN5 "mines"
#define SCYTHE_CLASSNAME2_TN5 "mines2"

#define CSW_THANATOS3 CSW_MP5NAVY
#define CSW_THANATOS1 CSW_DEAGLE
#define CSW_THANATOS5 CSW_M4A1
#define CSW_THANATOS7 CSW_M249
#define CSW_THANATOS11 CSW_M3 
#define CSW_THANATOS9 CSW_KNIFE

#define weapon_thanatos1 "weapon_deagle"
#define weapon_thanatos3 "weapon_mp5navy"
#define weapon_thanatos9 "weapon_knife"
#define weapon_thanatos5 "weapon_m4a1"
#define weapon_thanatos11 "weapon_m3"
#define weapon_thanatos7 "weapon_m249"

#define SCYTHE_HEAD "sprites/thanatos11_scythe.spr"
#define SCYTHE_CIRCLE "sprites/circle.spr"
#define SCYTHE_DEATH "sprites/thanatos11_fire.spr"
#define WEAPON_SECRETCODE_TN11 2122015
#define OLD_W_MODEL_TN11 "models/w_m3.mdl"
#define OLD_EVENT_TN11 "events/m3.sc"
#define THANATOS7_OLDMODEL "models/w_m249.mdl"
//######################################
new const WeaponSounds[16][] =
{
	"weapons/thanatos1_shoot1.wav",
	"weapons/thanatos1_shoot_b.wav",
	"weapons/thanatos1_bidle.wav",
	"weapons/thanatos1_boltpull.wav",
	"weapons/thanatos1_changea.wav",
	"weapons/thanatos1_changeb.wav",
	"weapons/thanatos1_clipin.wav",
	"weapons/thanatos1_clipout.wav",
	"weapons/thanatos1_drawb.wav",
	"weapons/thanatos1_explode.wav",
	"weapons/thanatos1_reload_b.wav",
	"weapons/thanatos1_reloadb_clipin.wav",
	"weapons/thanatos1_reloadb_clipout.wav",
	"weapons/thanatos1_shoot_empty.wav",
	"weapons/thanatos1_shoot2_empty.wav",
	"weapons/thanatos1_stone1.wav"
}
new const WeaponSounds_TN3[29][] =
{
	"weapons/thanatos3-1.wav",
	"weapons/thanatos3_fly_shoot.wav",
	"weapons/thanatos3_fly_w2.wav",
	"weapons/thanatos3_fly_w3.wav",
	"weapons/thanatos3_ilde_w1.wav",
	"weapons/thanatos3_ilde_w2.wav",
	"weapons/thanatos3_ilde_w3.wav",
	"weapons/thanatos3_draw.wav",
	"weapons/thanatos3_draw_w1.wav",
	"weapons/thanatos3_draw_w2.wav",
	"weapons/thanatos3_draw_w3.wav",
	"weapons/thanatos3_boltpull.wav",
	"weapons/thanatos3_clipin.wav",
	"weapons/thanatos3_clipout.wav",
	"weapons/thanatos3_knife_hit1.wav",
	"weapons/thanatos3_knife_hit2.wav",
	"weapons/thanatos3_knife_swish.wav",
	"weapons/thanatos3_metal1.wav",
	"weapons/thanatos3_metal2.wav",
	"weapons/thanatos3_reload_w1.wav",
	"weapons/thanatos3_reload_w2.wav",
	"weapons/thanatos3_reload_w3.wav",
	"weapons/thanatos3_spread_w1.wav",
	"weapons/thanatos3_spread_w2.wav",
	"weapons/thanatos3_spread_w3.wav",
	"weapons/thanatos3_stone1.wav",
	"weapons/thanatos3_stone2.wav",
	"weapons/thanatos3_wood1.wav",
	"weapons/thanatos3_wood2.wav"
}
new const WeaponSounds_TN5[12][] =
{
	"weapons/thanatos5-1.wav",
	"weapons/thanatos5_shootb2_1.wav",
	"weapons/thanatos5_explode1.wav",
	"weapons/thanatos5_explode2.wav",
	"weapons/thanatos5_explode3.wav",
	"weapons/thanatos5_changea_1.wav",
	"weapons/thanatos5_changea_2.wav",
	"weapons/thanatos5_changea_3.wav",
	"weapons/thanatos5_changea_4.wav",
	"weapons/thanatos5_reloada_1.wav",
	"weapons/thanatos5_reloada_2.wav",
	"weapons/thanatos5_reloada_3.wav"
}
new const WeaponSounds_TN9[13][] =
{
	"weapons/thanatos9_shoota1.wav",
	"weapons/thanatos9_shoota2.wav",
	"weapons/thanatos9_shootb_end.wav",
	"weapons/thanatos9_shootb_loop.wav",
	"weapons/thanatos9_drawa.wav",
	"weapons/thanatos9_changea_1.wav",
	"weapons/thanatos9_changea_2.wav",
	"weapons/thanatos9_changea_3.wav",
	"weapons/thanatos9_changea_4.wav",
	"weapons/thanatos9_changeb_1.wav",
	"weapons/thanatos9_changeb_2.wav",
	"weapons/skullaxe_hit.wav",
	"weapons/skullaxe_hit_wall.wav"
}
new const WeaponSounds_TN7[10][] =
{
	"weapons/thanatos7-1.wav",
	"weapons/thanatos7_scytheshoot.wav",
	"weapons/thanatos7_bdraw.wav",
	"weapons/thanatos7_bidle2.wav",
	"weapons/thanatos7_clipin1.wav",
	"weapons/thanatos7_clipin2.wav",
	"weapons/thanatos7_clipout1.wav",
	"weapons/thanatos7_clipout2.wav",
	"weapons/thanatos7_draw.wav",
	"weapons/thanatos7_scythereload.wav"
}
new const WeaponSounds_TN11[16][] =
{
	"weapons/thanatos11-1.wav",
	"weapons/thanatos11_shootb.wav",
	"weapons/thanatos11_shootb_empty.wav",
	"weapons/thanatos11_shootb_hit.wav",
	"weapons/thanatos11_after_reload.wav",
	"weapons/thanatos11_changea.wav",
	"weapons/thanatos11_changea_empty.wav",
	"weapons/thanatos11_changeb.wav",
	"weapons/thanatos11_changeb_empty.wav",
	"weapons/thanatos11_count.wav",
	"weapons/thanatos11_count_start.wav",
	"weapons/thanatos11_explode.wav",
	"weapons/thanatos11_idleb_reload.wav",
	"weapons/thanatos11_idleb1.wav",
	"weapons/thanatos11_idleb2.wav",
	"weapons/thanatos11_insert_reload.wav"
}
//######################################
enum
{
	ANIME_IDLE_A = 0,
	ANIME_IDLE_B,
	ANIME_SHOOT_A,
	ANIME_SHOOT_B,
	ANIME_SHOOT_SPECIAL,
	ANIME_SHOOT_EMPTY_A,
	ANIME_SHOOT_EMPTY_B,
	ANIME_RELOAD_A,
	ANIME_RELOAD_B,
	ANIME_CHANGE,
	ANIME_DRAW_A,
	ANIME_DRAW_B
}

enum
{
	ANIME_IDLE_TN3 = 0,
	ANIME_IDLE_W1_TN3,
	ANIME_IDLE_W2_TN3,
	ANIME_IDLE_W3_TN3,
	ANIME_SHOOT_TN3,
	ANIME_SHOOT_W1_TN3,
	ANIME_SHOOT_W2_TN3,
	ANIME_SHOOT_W3_TN3,
	ANIME_FLY_W1_TN3,
	ANIME_FLY_W2_TN3,
	ANIME_FLY_W3_TN3,
	ANIME_RELOAD_TN3,
	ANIME_RELOAD_W1_TN3,
	ANIME_RELOAD_W2_TN3,
	ANIME_RELOAD_W3_TN3,
	ANIME_SPREAD_W1_TN3,
	ANIME_SPREAD_W2_TN3,
	ANIME_SPREAD_W3_TN3,
	ANIME_DRAW_TN3,
	ANIME_DRAW_W1_TN3,
	ANIME_DRAW_W2_TN3,
	ANIME_DRAW_W3_TN3
}
enum
{
	ANIM_IDLE_A_TN5 = 0,
	ANIM_IDLE_B_TN5,
	ANIM_SHOOT_A1_TN5,
	ANIM_SHOOT_A2_TN5,
	ANIM_SHOOT_A3_TN5,
	ANIM_SHOOT_B1_TN5,
	ANIM_SHOOT_B2_TN5,
	ANIM_SHOOT_B3_TN5,
	ANIM_SHOOT_SPECIAL_TN5,
	ANIM_RELOAD_A_TN5,
	ANIM_RELOAD_B_TN5,
	ANIM_CHANGE_TN5,
	ANIM_DRAW_A_TN5,
	ANIM_DRAW_B_TN5
}
enum
{
	T11_ANIM_IDLEA = 0, // 0
	T11_ANIM_IDLEB1,
	T11_ANIM_IDLEB2,
	T11_ANIM_INSERT,
	T11_ANIM_AFTER,
	T11_ANIM_START, // 5
	T11_ANIM_IDLEB_EMPTY,
	T11_ANIM_SHOOTA,
	T11_ANIM_SHOOTB,
	T11_ANIM_SHOOTB_EMPTY,
	T11_ANIM_CHANGEA, // 10
	T11_ANIM_CHANGEA_EMPTY,
	T11_ANIM_CHANGEB,
	T11_ANIM_CHANGEB_EMPTY,
	T11_ANIM_DRAW,
	T11_ANIM_IDLEB_RELOAD // 15
}
enum
{
	ANIM_IDLE_A_TN7 = 0,
	ANIM_IDLE_B_TN7,
	ANIM_IDLE_B2_TN7,
	ANIM_SHOOT_A1_TN7,
	ANIM_SHOOT_B1_TN7,
	ANIM_SHOOT_A2_TN7,
	ANIM_SHOOT_B2_TN7,
	ANIM_RELOAD_A_TN7,
	ANIM_RELOAD_B_TN7,
	ANIM_SPECIAL_SHOOT_TN7,
	ANIM_SPECIAL_RELOAD_TN7,
	ANIM_DRAW_A_TN7,
	ANIM_DRAW_B_TN7
}
enum
{
	ANIME_DRAW_A_TN9 = 0,
	ANIME_SHOOT_B_LOOP_TN9,
	ANIME_SHOOT_B_START_TN9,
	ANIME_SHOOT_B_END_TN9,
	ANIME_IDLE_B_TN9,
	ANIME_IDLE_A_TN9,
	ANIME_DRAW_B_TN9,
	ANIME_SHOOT_A1_TN9,
	ANIME_SHOOT_A2_TN9,
	ANIME_CHANGE_TO_MEGATRON,
	ANIME_CHANGE_TO_GALVATRON
}
//######################################
enum
{
	STAGE_NONE_TN3 = 0,
	STAGE_ULTIMATE_TN3,
	STAGE_OMEGA_TN3,
	STAGE_METATRON_TN3
}
enum
{
	T11_MODE_NORMAL = 0,
	T11_MODE_THANATOS
}

//######################################

new const WeaponResources_TN5[6][] =
{
	"sprites/thanatos5_explode.spr",
	"sprites/thanatos5_explode2.spr",
	"sprites/640hud7_2.spr",
	"sprites/640hud14_2.spr",
	"sprites/640hud125_2.spr",
	"sprites/weapon_thanatos5.txt"
}
new const WeaponResources_TN9[3][] = 
{
	"sprites/knife_thanatos9.txt",
	"sprites/640hud79.spr",
	"sprites/smoke_thanatos9.spr"
}

//######################################

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

// Attachment

#define MAX_CHANNEL 4
#define ATTACHMENT_CLASSNAME "hattach"

const pev_user = pev_iuser1
const pev_livetime = pev_fuser1
const pev_totalframe = pev_fuser2

new g_MyAttachment[33][MAX_CHANNEL+1]

// MACROS
#define Get_BitVar(%1,%2) (%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2) %1 |= (1 << (%2 & 31))
#define UnSet_BitVar(%1,%2) %1 &= ~(1 << (%2 & 31))

const PRIMARY_WEAPONS_BIT_SUM = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
const SECONDARY_WEAPONS_BIT_SUM = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE)

new g_Had_Thanatos1, g_Thanatos1_Clip[33], g_Charged, g_Changing
new g_MsgCurWeapon, g_InTempingAttack, g_ExpSprID, g_MaxPlayers
new g_Event_Thanatos1, g_ShellId, g_SmokePuff_SprId, g_HamBot

new g_Had_Thanatos3, g_Thanatos3_Clip[33], g_Thanatos3_Stage[33], g_Thanatos3_Count[33]
new g_Event_Thanatos3

new g_Had_Thanatos5, g_Thanatos5_Clip[33], g_GrenadeMode
new g_MsgStatusIcon, g_MsgWeaponList
new g_Event_Thanatos5, spr_trail, g_Exp_SprID, g_Exp2_SprID

new g_Had_Thanatos9, g_MegatronMode, g_FallenGalvatron, g_DarthVader, Float:CheckDamage[33]

new g_Had_Thanatos11, g_Thanatos11_Mode[33], g_ChargedAmmo2[33], g_OldWeapon[33], Float:ReloadTime[33]
new g_Event_Thanatos11, m_spriteTexture
new g_ScytheDeath

new g_Had_Thanatos7, g_Thanatos7_Clip[33], g_Had_Scythe
new g_Event_Thanatos7



public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0")
	register_think(SCYTHE_CLASSNAME, "fw_Scythe_Think")
	register_touch(SCYTHE_CLASSNAME, "*", "fw_Scythe_Touch")
	
	register_forward(FM_UpdateClientData,"fw_UpdateClientData_Post", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")	
	register_forward(FM_SetModel, "fw_SetModel")		
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_EmitSound, "fw_EmitSound")
	register_forward(FM_TraceLine, "fw_TraceLine")
	register_forward(FM_TraceHull, "fw_TraceHull")	
	
	RegisterHam(Ham_Item_Deploy, weapon_thanatos1, "fw_Item_Deploy_Post", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_thanatos1, "fw_Item_AddToPlayer_Post", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_thanatos1, "fw_Item_PostFrame")	
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos1, "fw_Weapon_Reload")
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos1, "fw_Weapon_Reload_Post", 1)	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos1, "fw_Weapon_WeaponIdle_Post", 1)
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_thanatos1, "fw_Weapon_PrimaryAttack_Post", 1)	
	
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player")	
	
	g_MaxPlayers = get_maxplayers()
	g_MsgCurWeapon = get_user_msgid("CurWeapon")
	register_concmd("wpn_tn","csx_dmg")
	
	plugin_init_TN3() 
	plugin_init_TN5() 
	plugin_init_TN9() 
	plugin_init_TN11() 
	plugin_init_TN7() 
}

public plugin_precache()
{
	precache_model(V_MODEL)
	precache_model(P_MODEL)
	precache_model(W_MODEL)
	precache_model(S_MODEL)
	
	for(new i = 0; i < sizeof(WeaponSounds); i++)
		precache_sound(WeaponSounds[i])
	
	g_ShellId = precache_model("models/rshell.mdl")
	g_SmokePuff_SprId = precache_model("sprites/wall_puff1.spr")
	g_ExpSprID = precache_model("sprites/thanatos1_exp.spr")
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)
	plugin_precache_TN3()
	plugin_precache_TN5()
	plugin_precache_TN9()
	plugin_precache_TN11()
	plugin_precache_TN7()
}

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal("events/deagle.sc", name)) g_Event_Thanatos1 = get_orig_retval()		
}

public client_putinserver(id)
{
	if(!g_HamBot && is_user_bot(id))
	{
		g_HamBot = 1
		set_task(0.1, "Do_Register_HamBot", id)
		
	}
}


public Do_Register_HamBot(id)
{
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_Player")
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_Player_TN3")
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_Player_TN5")
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_PlayerTraceAttack_TN9")
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_TN11")
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_Player_TN7")
}

public Event_NewRound() 
{
	remove_entity_name(SCYTHE_CLASSNAME_TN7)
	remove_entity_name(SCYTHE_CLASSNAME)
	remove_entity_name(SCYTHE_CLASSNAME_TN3)
	remove_entity_name(SCYTHE_CLASSNAME_TN5)
	remove_entity_name(SCYTHE_CLASSNAME2_TN5)
	remove_entity_name(ATTACHMENT_CLASSNAME)
}
public csx_dmg(id)
{
	if(!is_user_alive(id))
		return
	new menu = menu_create("[thanatos Weapon Pack]", "MenuHandle_dmg")  
	{
		menu_additem( menu, "Thanatos 1", "1" )
		menu_additem( menu, "Thanatos 3", "2" )
		menu_additem( menu, "Thanatos 5", "3" )
		menu_additem( menu, "Thanatos 7", "4" )
		menu_additem( menu, "Thanatos 9", "5" )
		menu_additem( menu, "Thanatos 11", "6" )
	}
	
	menu_additem( menu, "Exit", "MENU_EXIT" )
	menu_setprop(menu, MPROP_PERPAGE, 0)
	menu_display(id, menu, 0)
	return 
}
public MenuHandle_dmg(id, menu, item)
{
	if( item == MENU_EXIT ) {
		menu_destroy(menu)
		return
	}
	
	if(!is_user_alive(id))
		return
	{
			switch(item) {
			case 0:{
				Get_Thanatos1(id)
			}
			case 1:{
				Get_Thanatos3(id)
			}
			case 2:{
				Get_Thanatos5(id)
			}
			case 3:{
				Get_Thanatos7(id)
			}
			case 4:{
				Get_Thanatos9(id)
			}
			case 5:{
				Get_Thanatos11(id)
			}
		}
	}

	return
}
public Get_Thanatos11(id)
{
	drop_weapons(id, 1)
	
	Set_BitVar(g_Had_Thanatos11, id)
	g_Thanatos11_Mode[id] = T11_MODE_NORMAL
	g_ChargedAmmo2[id] = 0
	
	give_item(id, weapon_thanatos11)
	cs_set_user_bpammo(id, CSW_THANATOS11, BPAMMO_TN11)
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS11)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP_TN11)
	
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_THANATOS11)
	write_byte(CLIP_TN11)
	message_end()
	
	Update_SpecialAmmo(id, g_ChargedAmmo2[id], 0)
}

public Remove_Thanatos11(id)
{
	Update_SpecialAmmo(id, g_ChargedAmmo2[id], 0)
	
	UnSet_BitVar(g_Had_Thanatos11, id)
	g_Thanatos11_Mode[id] = T11_MODE_NORMAL
	g_ChargedAmmo2[id] = 0
}
public Get_Thanatos9(id)
{
	remove_task(id+TASK_SLASHING_TN9)
	remove_task(id+TASK_CHANGING_TN9)
	
	Set_BitVar(g_Had_Thanatos9, id)
	UnSet_BitVar(g_MegatronMode, id)
	UnSet_BitVar(g_FallenGalvatron, id)
	UnSet_BitVar(g_DarthVader, id)
	UnSet_BitVar(g_Changing, id)
			
	if(get_user_weapon(id) == CSW_KNIFE)
	{
		set_pev(id, pev_viewmodel2, MODEL_V_TN9)
		set_pev(id, pev_weaponmodel2, MODEL_PA_TN9)
		Set_WeaponAnim(id, ANIME_DRAW_A_TN9)
		
		set_pdata_string(id, (492) * 4, WEAPON_ANIMEXTA_TN9, -1 , 20)
		Set_PlayerNextAttack(id, 0.75)
	}
	
	// Update Hud
	message_begin(MSG_ONE_UNRELIABLE, g_MsgWeaponList, _, id)
	write_string("knife_thanatos9")
	write_byte(-1)
	write_byte(-1)
	write_byte(-1)
	write_byte(-1)
	write_byte(2)
	write_byte(1)
	write_byte(CSW_THANATOS9)
	write_byte(0)
	message_end()	
}

public Remove_Thanatos9(id)
{
	remove_task(id+TASK_SLASHING_TN9)
	remove_task(id+TASK_CHANGING_TN9)
	
	UnSet_BitVar(g_Had_Thanatos9, id)
	UnSet_BitVar(g_MegatronMode, id)
	UnSet_BitVar(g_FallenGalvatron, id)
	UnSet_BitVar(g_DarthVader, id)
	UnSet_BitVar(g_Changing, id)
}

public Get_Thanatos5(id)
{
	drop_weapons(id, 1)
	
	Set_BitVar(g_Had_Thanatos5, id)
	UnSet_BitVar(g_GrenadeMode, id)
	give_item(id, weapon_thanatos5)
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS5)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP_TN5)
	
	message_begin(MSG_ONE_UNRELIABLE, g_MsgWeaponList, _, id)
	write_string("weapon_thanatos5")
	write_byte(4)
	write_byte(90)
	write_byte(-1)
	write_byte(-1)
	write_byte(0)
	write_byte(6)
	write_byte(CSW_THANATOS5)
	write_byte(0)
	message_end()	
	
	Update_Ammo_TN5(id, CLIP_TN5)
	Update_SpecialAmmo(id, 1, 0)
	
	cs_set_user_bpammo(id, CSW_THANATOS5, 200)
}

public Remove_Thanatos5(id)
{
	if(is_user_connected(id)) 
		Update_SpecialAmmo(id, 1, 0)
	
	UnSet_BitVar(g_Had_Thanatos5, id)
	UnSet_BitVar(g_GrenadeMode, id)
}

public Get_Thanatos3(id)
{
	drop_weapons(id, 1)
	g_Thanatos3_Count[id] = 0
	g_Thanatos3_Stage[id] = STAGE_NONE_TN3
	Set_BitVar(g_Had_Thanatos3, id)
	give_item(id, weapon_thanatos3)
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS3)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP_TN3)
	
	Update_Ammo_TN3(id, CLIP_TN3)
	cs_set_user_bpammo(id, CSW_THANATOS3, BPAMMO_TN3)
}

public Remove_Thanatos3(id)
{
	g_Thanatos3_Count[id] = 0
	g_Thanatos3_Stage[id] = STAGE_NONE_TN3
	UnSet_BitVar(g_Had_Thanatos3, id)
}

public Get_Thanatos1(id)
{
	drop_weapons(id, 2)
	UnSet_BitVar(g_Changing, id)
	UnSet_BitVar(g_Charged, id)
	Set_BitVar(g_Had_Thanatos1, id)
	give_item(id, weapon_thanatos1)
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS1)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP)
	
	Update_Ammo(id, CLIP)
	cs_set_user_bpammo(id, CSW_THANATOS1, BPAMMO)
}

public Remove_Thanatos1(id)
{
	UnSet_BitVar(g_Changing, id)
	UnSet_BitVar(g_Charged, id)
	UnSet_BitVar(g_Had_Thanatos1, id)
}

public Update_Ammo(id, Ammo)
{
	if(!is_user_alive(id))
		return
	
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_THANATOS1)
	write_byte(Ammo)
	message_end()
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_THANATOS1 && Get_BitVar(g_Had_Thanatos1, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(invoker))
		return FMRES_IGNORED	
	if(get_user_weapon(invoker) != CSW_THANATOS1 || !Get_BitVar(g_Had_Thanatos1, invoker))
		return FMRES_IGNORED
	if(eventid != g_Event_Thanatos1)
		return FMRES_IGNORED
	
	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	
	if(!Get_BitVar(g_Charged, invoker)) Set_WeaponAnim(invoker, ANIME_SHOOT_A)
	else Set_WeaponAnim(invoker, ANIME_SHOOT_B)
	
	emit_sound(invoker, CHAN_WEAPON, WeaponSounds[0], 1.0, 0.4, 0, 94 + random_num(0, 15))
	Eject_Shell(invoker, g_ShellId, 0.01)
	
	return FMRES_IGNORED
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
	
	if(equal(model, THANATOS1_OLDMODEL))
	{
		static weapon; weapon = find_ent_by_owner(-1, weapon_thanatos1, entity)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED;
		
		if(Get_BitVar(g_Had_Thanatos1, iOwner))
		{
			set_pev(weapon, pev_impulse, 25112015)
			set_pev(weapon, pev_iuser4, Get_BitVar(g_Charged, iOwner) ? 1 : 0)
			
			engfunc(EngFunc_SetModel, entity, W_MODEL)
			Remove_Thanatos1(iOwner)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_THANATOS1 || !Get_BitVar(g_Had_Thanatos1, id))
		return FMRES_IGNORED
		
	static PressedButton
	PressedButton = get_uc(uc_handle, UC_Buttons)
	
	if(PressedButton & IN_ATTACK2)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return FMRES_IGNORED
		
		PressedButton &= ~IN_ATTACK2
		set_uc(uc_handle, UC_Buttons, PressedButton)
		
		if(Get_BitVar(g_Changing, id))
			return FMRES_IGNORED
		
		if(!Get_BitVar(g_Charged, id))
		{
			Set_BitVar(g_Changing, id)
			
			Set_Player_NextAttack(id, 2.0)
			Set_WeaponIdleTime(id, CSW_THANATOS1, 2.0)
			
			Set_WeaponAnim(id, ANIME_CHANGE)
			
			remove_task(id+TASK_CHANGING)
			set_task(1.85, "Complete_Change", id+TASK_CHANGING)
		} else {
			UnSet_BitVar(g_Changing, id)
			UnSet_BitVar(g_Charged, id)
			
			Create_FakeAttackAnim(id)
			
			Set_Player_NextAttack(id, 2.0)
			Set_WeaponIdleTime(id, CSW_THANATOS1, 2.0)
			
			Set_WeaponAnim(id, ANIME_SHOOT_SPECIAL)
			emit_sound(id, CHAN_WEAPON, WeaponSounds[1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			Create_Scythe(id)
			
			// Fake Punch
			static Float:Origin[3]; Origin[0] = -2.5
			set_pev(id, pev_punchangle, Origin)
		}
	}
		
	return FMRES_HANDLED
}

public Complete_Change(id)
{
	id -= TASK_CHANGING
	
	if(!is_user_alive(id))
		return
	
	UnSet_BitVar(g_Changing, id)
		
	if(get_user_weapon(id) != CSW_THANATOS1 || !Get_BitVar(g_Had_Thanatos1, id))
		return
		
	Set_BitVar(g_Charged, id)
}

public Create_Scythe(id)
{
	static Float:Origin[3], Float:Target[3], Float:Velocity[3], Float:Angles[3]
	
	get_position(id, 48.0, 6.0, 0.0, Origin)
	get_position(id, 1024.0, 0.0, 0.0, Target)
	
	pev(id, pev_v_angle, Angles)
	Angles[0] *= -1.0
	
	new Ent = create_entity("info_target")
	
	// set info for ent
	set_pev(Ent, pev_movetype, MOVETYPE_FLY)
	entity_set_string(Ent, EV_SZ_classname, SCYTHE_CLASSNAME)
	engfunc(EngFunc_SetModel, Ent, S_MODEL)
	
	set_pev(Ent, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(Ent, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(Ent, pev_origin, Origin)
	set_pev(Ent, pev_gravity, 0.25)
	set_pev(Ent, pev_angles, Angles)
	set_pev(Ent, pev_solid, SOLID_TRIGGER)
	set_pev(Ent, pev_owner, id)	
	set_pev(Ent, pev_iuser1, get_user_team(id))
	set_pev(Ent, pev_fuser1, get_gametime() + 5.0)

	get_speed_vector(Origin, Target, SCYTHE_SPEED, Velocity)
	set_pev(Ent, pev_velocity, Velocity)	
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
	
	// Animation
	set_pev(Ent, pev_animtime, get_gametime())
	set_pev(Ent, pev_framerate, 1.0)
	set_pev(Ent, pev_sequence, 0)
}

public fw_Scythe_Think(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Float:Time; pev(Ent, pev_fuser1, Time)
	if(Time <= get_gametime())
	{
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
			
		return
	}
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.25)
}

public fw_Scythe_Touch(Ent, id)
{
	if(!pev_valid(Ent))
		return
	
	if(!is_user_alive(id))
	{
		static Float:Origin[3]; pev(Ent, pev_origin, Origin)
	
		set_pev(Ent, pev_velocity, {0.0, 0.0, 0.0})
		set_pev(Ent, pev_movetype, MOVETYPE_NONE)
		set_pev(Ent, pev_solid, SOLID_NOT)
		
		// Bullet Hole
		static Owner; Owner = pev(Ent, pev_owner)
		Make_BulletHole(Owner, Origin, float(DAMAGE))
		
		// Sound
		emit_sound(Ent, CHAN_ITEM, WeaponSounds[15], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		emit_sound(Ent, CHAN_STATIC, WeaponSounds[9], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_short(g_ExpSprID)
		write_byte(10)
		write_byte(20)
		write_byte(4) 
		message_end()
		
		// Entity
		set_pev(Ent, pev_fuser1, get_gametime() + 3.0)
		if(!is_user_connected(Owner))
			return
		
		for(new i = 0; i < g_MaxPlayers; i++)
		{
			if(!is_user_alive(i))
				continue
			if(get_user_team(i) == get_user_team(Owner))
				continue
			if(entity_range(i, Ent) > 180.0)
				continue
				
			ExecuteHamB(Ham_TakeDamage, i, 0, Owner, float(DAMAGE) * 2.0, DMG_SLASH)
		}
	
	} else {
		static Team; Team = pev(Ent, pev_iuser1)
		if(get_user_team(id) == Team)
			return
		static Owner; Owner = pev(Ent, pev_owner)
		if(!is_user_connected(Owner))
			return
		
		ExecuteHamB(Ham_TakeDamage, id, 0, Owner, float(DAMAGE), DMG_SLASH)
	}
}

public fw_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
		
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
			return FMRES_SUPERCEDE
		if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
		{
			if (sample[17] == 'w')  return FMRES_SUPERCEDE
			else  return FMRES_SUPERCEDE
		}
		if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
			return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED
}

public fw_TraceLine(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)

	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceLine, vecStart, vecEnd, ignored_monster, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_TraceHull(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)
	
	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceHull, vecStart, vecEnd, ignored_monster, hull, id, handle)
	
	return FMRES_SUPERCEDE
}



public fw_Item_Deploy_Post(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Thanatos1, Id))
		return
	
	set_pev(Id, pev_viewmodel2, V_MODEL)
	set_pev(Id, pev_weaponmodel2, P_MODEL)
	
	if(!Get_BitVar(g_Charged, Id)) Set_WeaponAnim(Id, ANIME_DRAW_A)
	else Set_WeaponAnim(Id, ANIME_DRAW_B)
	
	remove_task(Id+TASK_CHANGING)
	
	UnSet_BitVar(g_Changing, Id)
	UnSet_BitVar(g_Charged, Id)
}

public fw_Item_AddToPlayer_Post(Ent, id)
{
	if(!pev_valid(Ent))
		return HAM_IGNORED
		
	if(pev(Ent, pev_impulse) == 25112015)
	{
		Set_BitVar(g_Had_Thanatos1, id)
		set_pev(Ent, pev_impulse, 0)
		
		if(pev(Ent, pev_iuser4)) Set_BitVar(g_Charged, id)
		else UnSet_BitVar(g_Charged, id)
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
	if(!Get_BitVar(g_Had_Thanatos1, Id))
		return
		
	if(get_pdata_float(iEnt, 48, 4) <= 0.1)
	{
		if(!Get_BitVar(g_Charged, Id)) Set_WeaponAnim(Id, ANIME_IDLE_A)
		else Set_WeaponAnim(Id, ANIME_IDLE_B)
		
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public fw_TraceAttack_World(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS1 || !Get_BitVar(g_Had_Thanatos1, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
		
	get_tr2(Ptr, TR_vecEndPos, flEnd)
	get_tr2(Ptr, TR_vecPlaneNormal, vecPlane)		
			
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, float(DAMAGE))
	
	return HAM_IGNORED
}

public fw_TraceAttack_Player(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS1 || !Get_BitVar(g_Had_Thanatos1, Attacker))
		return HAM_IGNORED
		
	SetHamParamFloat(3, float(DAMAGE))
	
	return HAM_IGNORED
}

public fw_Item_PostFrame(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos1, id))
		return HAM_IGNORED	
	
	static Float:flNextAttack; flNextAttack = get_pdata_float(id, 83, 5)
	static bpammo; bpammo = cs_get_user_bpammo(id, CSW_THANATOS1)
	
	static iClip; iClip = get_pdata_int(ent, 51, 4)
	static fInReload; fInReload = get_pdata_int(ent, 54, 4)
	
	if(fInReload && flNextAttack <= 0.0)
	{
		static temp1
		temp1 = min(CLIP - iClip, bpammo)

		set_pdata_int(ent, 51, iClip + temp1, 4)
		cs_set_user_bpammo(id, CSW_THANATOS1, bpammo - temp1)		
		
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
	if(!Get_BitVar(g_Had_Thanatos1, id))
		return HAM_IGNORED	

	g_Thanatos1_Clip[id] = -1
		
	static BPAmmo; BPAmmo = cs_get_user_bpammo(id, CSW_THANATOS1)
	static iClip; iClip = get_pdata_int(ent, 51, 4)
		
	if(BPAmmo <= 0)
		return HAM_SUPERCEDE
	if(iClip >= CLIP)
		return HAM_SUPERCEDE		
			
	g_Thanatos1_Clip[id] = iClip	
	
	return HAM_HANDLED
}

public fw_Weapon_Reload_Post(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos1, id))
		return HAM_IGNORED	
		
	if((get_pdata_int(ent, 54, 4) == 1))
	{ // Reload
		if(g_Thanatos1_Clip[id] == -1)
			return HAM_IGNORED
		
		set_pdata_int(ent, 51, g_Thanatos1_Clip[id], 4)
		set_pdata_float(id, 83, RELOAD_TIME, 5)
		
		if(!Get_BitVar(g_Charged, id)) Set_WeaponAnim(id, ANIME_RELOAD_A)
		else Set_WeaponAnim(id, ANIME_RELOAD_B)
	}
	
	return HAM_HANDLED
}

public fw_Weapon_PrimaryAttack_Post(Ent)
{
	static id; id = pev(Ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos1, id))
		return HAM_IGNORED
		
	set_pdata_float(Ent, 48, 0.5, 4)
	return HAM_IGNORED
}



public plugin_init_TN3() 
{
	register_think(SCYTHE_CLASSNAME_TN3, "fw_Scythe_Think_TN3")
	register_touch(SCYTHE_CLASSNAME_TN3, "*", "fw_Scythe_Touch_TN3")
	
	register_forward(FM_UpdateClientData,"fw_UpdateClientData_Post_TN3", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent_TN3")	
	register_forward(FM_SetModel, "fw_SetModel_TN3")		
	register_forward(FM_CmdStart, "fw_CmdStart_TN3")
	register_forward(FM_EmitSound, "fw_EmitSound_TN3")
	register_forward(FM_TraceLine, "fw_TraceLine_TN3")
	register_forward(FM_TraceHull, "fw_TraceHull_TN3")	
	
	RegisterHam(Ham_Item_Deploy, weapon_thanatos3, "fw_Item_Deploy_Post_TN3", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_thanatos3, "fw_Item_AddToPlayer_Post_TN3", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_thanatos3, "fw_Item_PostFrame_TN3")	
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos3, "fw_Weapon_Reload_TN3")
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos3, "fw_Weapon_Reload_Post_TN3", 1)	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos3, "fw_Weapon_WeaponIdle_Post_TN3", 1)
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_thanatos3, "fw_Weapon_PrimaryAttack_Post_TN3", 1)	
	
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World_TN3")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player_TN3")	
	
	g_MsgCurWeapon = get_user_msgid("CurWeapon")
}

public plugin_precache_TN3()
{
	precache_model(V_MODEL_TN3)
	precache_model(P_MODEL_TN3)
	precache_model(W_MODEL_TN3)
	precache_model(W_MODEL2_TN3)
	precache_model(S_MODEL_TN3)
	precache_model(S_MODEL2_TN3)
	
	for(new i = 0; i < sizeof(WeaponSounds_TN3); i++)
		precache_sound(WeaponSounds_TN3[i])
	
	g_ShellId = precache_model("models/rshell.mdl")
	g_SmokePuff_SprId = precache_model("sprites/wall_puff1.spr")
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post_TN3", 1)
}

public fw_PrecacheEvent_Post_TN3(type, const name[])
{
	if(equal("events/mp5n.sc", name)) g_Event_Thanatos3 = get_orig_retval()		
}

public Event_NewRound_TN3() remove_entity_name(SCYTHE_CLASSNAME_TN3)


public Update_Ammo_TN3(id, Ammo)
{
	if(!is_user_alive(id))
		return
	
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_THANATOS3)
	write_byte(Ammo)
	message_end()
}

public fw_UpdateClientData_Post_TN3(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_THANATOS3 && Get_BitVar(g_Had_Thanatos3, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent_TN3(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(invoker))
		return FMRES_IGNORED	
	if(get_user_weapon(invoker) != CSW_THANATOS3 || !Get_BitVar(g_Had_Thanatos3, invoker))
		return FMRES_IGNORED
	if(eventid != g_Event_Thanatos3)
		return FMRES_IGNORED
	
	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	
	switch(g_Thanatos3_Stage[invoker])
	{
		case STAGE_NONE_TN3: Set_WeaponAnim(invoker, ANIME_SHOOT_TN3)
		case STAGE_ULTIMATE_TN3: Set_WeaponAnim(invoker, ANIME_SHOOT_W1_TN3)
		case STAGE_OMEGA_TN3: Set_WeaponAnim(invoker, ANIME_SHOOT_W2_TN3)
		case STAGE_METATRON_TN3: Set_WeaponAnim(invoker, ANIME_SHOOT_W3_TN3)
	}
	
	emit_sound(invoker, CHAN_WEAPON, WeaponSounds_TN3[0], 1.0, 0.4, 0, 94 + random_num(0, 15))
	Eject_Shell(invoker, g_ShellId, 0.01)
	
	// Check Stage
	g_Thanatos3_Count[invoker]++
	if(g_Thanatos3_Count[invoker] >= STAGE_AMMO_TN3)
	{
		if(g_Thanatos3_Stage[invoker] < STAGE_METATRON_TN3)
		{
			g_Thanatos3_Stage[invoker]++
			
			switch(g_Thanatos3_Stage[invoker])
			{
				case STAGE_ULTIMATE_TN3: Set_WeaponAnim(invoker, ANIME_SPREAD_W1_TN3)
				case STAGE_OMEGA_TN3: Set_WeaponAnim(invoker, ANIME_SPREAD_W2_TN3)
				case STAGE_METATRON_TN3: Set_WeaponAnim(invoker, ANIME_SPREAD_W3_TN3)
			}
		}
		
		g_Thanatos3_Count[invoker] = 0
	}

	return FMRES_IGNORED
}

public fw_SetModel_TN3(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static Classname[32]
	pev(entity, pev_classname, Classname, sizeof(Classname))
	
	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner
	iOwner = pev(entity, pev_owner)
	
	if(equal(model, THANATOS3_OLDMODEL))
	{
		static weapon; weapon = find_ent_by_owner(-1, weapon_thanatos3, entity)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED;
		
		if(Get_BitVar(g_Had_Thanatos3, iOwner))
		{
			set_pev(weapon, pev_impulse, 25112015)
			set_pev(weapon, pev_iuser3, g_Thanatos3_Count[iOwner])
			set_pev(weapon, pev_iuser4, g_Thanatos3_Stage[iOwner])
			
			engfunc(EngFunc_SetModel, entity, g_Thanatos3_Stage[iOwner] ? W_MODEL2_TN3 : W_MODEL_TN3)
			Remove_Thanatos3(iOwner)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart_TN3(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_THANATOS3 || !Get_BitVar(g_Had_Thanatos3, id))
		return FMRES_IGNORED
		
	static PressedButton
	PressedButton = get_uc(uc_handle, UC_Buttons)
	
	if(PressedButton & IN_ATTACK2)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return FMRES_IGNORED
		
		PressedButton &= ~IN_ATTACK2
		set_uc(uc_handle, UC_Buttons, PressedButton)
		
		if(g_Thanatos3_Stage[id]) Check_Scythe(id)
	}
		
	return FMRES_HANDLED
}

public Check_Scythe(id)
{
	Create_FakeAttackAnim(id)
	
	Set_Player_NextAttack(id, 1.75)
	Set_WeaponIdleTime(id, CSW_THANATOS3, 2.0)
	
	switch(g_Thanatos3_Stage[id])
	{
		case STAGE_ULTIMATE_TN3: Set_WeaponAnim(id, ANIME_FLY_W1_TN3)
		case STAGE_OMEGA_TN3: Set_WeaponAnim(id, ANIME_FLY_W2_TN3)
		case STAGE_METATRON_TN3: Set_WeaponAnim(id, ANIME_FLY_W3_TN3)
	}
	
	emit_sound(id, CHAN_WEAPON, WeaponSounds_TN3[1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	Shoot_Scyche(id, g_Thanatos3_Stage[id])
	
	// Fake Punch
	static Float:Origin[3]; Origin[0] = -2.5
	set_pev(id, pev_punchangle, Origin)
	
	g_Thanatos3_Stage[id] = STAGE_NONE_TN3
}

public Shoot_Scyche(id, Level)
{
	static Float:Origin[6][3], Float:Target[3], LoopTime, Float:Speed[6]
	
	get_position(id, 48.0, -10.0, random_float(-5.0, 5.0), Origin[0]); Speed[0] = random_float(500.0, 1000.0)
	get_position(id, 48.0, 10.0, random_float(-5.0, 5.0), Origin[1]); Speed[1] = random_float(500.0, 1000.0)
	get_position(id, 48.0, -20.0, random_float(-5.0, 5.0), Origin[2]); Speed[2] = random_float(500.0, 1000.0)
	get_position(id, 48.0, 20.0, random_float(-5.0, 5.0), Origin[3]); Speed[3] = random_float(500.0, 1000.0)
	get_position(id, 48.0, -30.0, random_float(-5.0, 5.0), Origin[4]); Speed[4] = random_float(500.0, 1000.0)
	get_position(id, 48.0, 30.0, random_float(-5.0, 5.0), Origin[5]); Speed[5] = random_float(500.0, 1000.0)
	
	get_position(id, 1024.0, 0.0, 0.0, Target)
	
	switch(Level)
	{
		case STAGE_ULTIMATE_TN3: LoopTime = 2
		case STAGE_OMEGA_TN3: LoopTime = 4
		case STAGE_METATRON_TN3: LoopTime = 6
	}
	
	for(new i = 0; i < LoopTime; i++)
		Create_Scythe_tn3(id, Origin[i], Target, Speed[i])
}

public Create_Scythe_tn3(id, Float:Start[3], Float:End[3], Float:Speed)
{
	static Float:Velocity[3], Float:Angles[3]
	
	pev(id, pev_v_angle, Angles)
	new Ent = create_entity("info_target")
	
	Angles[0] *= -1.0

	// set info for ent
	set_pev(Ent, pev_movetype, MOVETYPE_FLY)
	entity_set_string(Ent, EV_SZ_classname, SCYTHE_CLASSNAME_TN3)
	engfunc(EngFunc_SetModel, Ent, S_MODEL_TN3)
	
	set_pev(Ent, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(Ent, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(Ent, pev_origin, Start)
	set_pev(Ent, pev_gravity, 0.25)
	set_pev(Ent, pev_angles, Angles)
	set_pev(Ent, pev_solid, SOLID_TRIGGER)
	set_pev(Ent, pev_owner, id)	
	set_pev(Ent, pev_iuser1, get_user_team(id))
	set_pev(Ent, pev_iuser2, 0)
	set_pev(Ent, pev_iuser3, 206)
	set_pev(Ent, pev_fuser1, get_gametime() + SCYTHE_SLASHTIME_TN3)

	get_speed_vector(Start, End, Speed, Velocity)
	set_pev(Ent, pev_velocity, Velocity)	
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
	
	// Animation
	set_pev(Ent, pev_animtime, get_gametime())
	set_pev(Ent, pev_framerate, 1.0)
	set_pev(Ent, pev_sequence, 0)
	
	// Sound
	emit_sound(Ent, CHAN_BODY, WeaponSounds_TN3[16], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
}

public fw_Scythe_Think_TN3(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Float:Time; pev(Ent, pev_fuser1, Time)
	static Float:Time2; pev(Ent, pev_fuser2, Time2)
	static Owner; Owner = pev(Ent, pev_owner)
	static Team; Team = pev(Ent, pev_iuser1)
	static Target; Target = pev(Ent, pev_iuser2)
	
	if(Time <= get_gametime() || !is_user_connected(Owner))
	{
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
			
		return
	}
	
	if(is_user_alive(Target))
	{
		if(get_user_team(Target) == Team)
		{
			set_pev(Ent, pev_flags, FL_KILLME)
			set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
			
			return
		}
		
		if(get_gametime() - 0.75 > Time2)
		{
			emit_sound(Ent, CHAN_BODY, WeaponSounds_TN3[16], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			set_pev(Ent, pev_fuser2, get_gametime())
		}
		
		ExecuteHamB(Ham_TakeDamage, Target, 0, Owner, float(DAMAGE_TN3) / 1.5, DMG_SLASH)
	} else {
		if(Target)
		{
			set_pev(Ent, pev_flags, FL_KILLME)
			set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
				
			return
		}
	}
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.2)
}

public fw_Scythe_Touch_TN3(Ent, id)
{
	if(!pev_valid(Ent))
		return
	if(pev_valid(id) && pev(id, pev_iuser3) == 206)
		return
		
	if(!is_user_alive(id))
	{
		static Float:Origin[3]; pev(Ent, pev_origin, Origin)
		
		set_pev(Ent, pev_fuser1, get_gametime() + random_float(1.0, 3.0))
		
		set_pev(Ent, pev_velocity, {0.0, 0.0, 0.0})
		set_pev(Ent, pev_movetype, MOVETYPE_NONE)
		set_pev(Ent, pev_solid, SOLID_NOT)
		
		// Animation
		set_pev(Ent, pev_animtime, get_gametime())
		set_pev(Ent, pev_framerate, 1.0)
		set_pev(Ent, pev_sequence, 1)
		
		// Bullet Hole
		static Owner; Owner = pev(Ent, pev_owner)
		Make_BulletHole(Owner, Origin, float(DAMAGE_TN3))
		
		// Sound
		emit_sound(Ent, CHAN_BODY, WeaponSounds_TN3[random_num(25, 28)], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	} else {
		static Team; Team = pev(Ent, pev_iuser1)
		if(get_user_team(id) == Team)
			return
		static Owner; Owner = pev(Ent, pev_owner)
		if(!is_user_connected(Owner))
			return
		
		if(!pev(Ent, pev_iuser2))
		{
			set_pev(Ent, pev_fuser1, get_gametime() + SCYTHE_SLASHTIME_TN3)
			set_pev(Ent, pev_iuser2, id)
			
			set_pev(Ent, pev_velocity, {0.0, 0.0, 0.0})
			set_pev(Ent, pev_movetype, MOVETYPE_FOLLOW)
			set_pev(Ent, pev_solid, SOLID_NOT)
			set_pev(Ent, pev_aiment, id)
			
			engfunc(EngFunc_SetModel, Ent, S_MODEL2_TN3)
			
			// Animation
			set_pev(Ent, pev_animtime, get_gametime())
			set_pev(Ent, pev_framerate, random_float(1.0, 5.0))
			set_pev(Ent, pev_sequence, 0)
			
			// Sound
			emit_sound(id, CHAN_STATIC, WeaponSounds_TN3[random_num(14, 15)], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		}
	}
}

public fw_EmitSound_TN3(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
		
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
			return FMRES_SUPERCEDE
		if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
		{
			if (sample[17] == 'w')  return FMRES_SUPERCEDE
			else  return FMRES_SUPERCEDE
		}
		if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
			return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED
}

public fw_TraceLine_TN3(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)

	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceLine, vecStart, vecEnd, ignored_monster, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_TraceHull_TN3(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)
	
	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceHull, vecStart, vecEnd, ignored_monster, hull, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_Item_Deploy_Post_TN3(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Thanatos3, Id))
		return
	
	set_pev(Id, pev_viewmodel2, V_MODEL_TN3)
	set_pev(Id, pev_weaponmodel2, P_MODEL_TN3)
	
	switch(g_Thanatos3_Stage[Id])
	{
		case STAGE_NONE_TN3: Set_WeaponAnim(Id, ANIME_DRAW_TN3)
		case STAGE_ULTIMATE_TN3: Set_WeaponAnim(Id, ANIME_DRAW_W1_TN3)
		case STAGE_OMEGA_TN3: Set_WeaponAnim(Id, ANIME_DRAW_W2_TN3)
		case STAGE_METATRON_TN3: Set_WeaponAnim(Id, ANIME_DRAW_W3_TN3)
	}
	
	set_pdata_string(Id, (492) * 4, ANIME_EXT_TN3, -1 , 20)
}

public fw_Item_AddToPlayer_Post_TN3(Ent, id)
{
	if(!pev_valid(Ent))
		return HAM_IGNORED
		
	if(pev(Ent, pev_impulse) == 25112015)
	{
		Set_BitVar(g_Had_Thanatos3, id)
		set_pev(Ent, pev_impulse, 0)
		
		g_Thanatos3_Count[id] = pev(Ent, pev_iuser3)
		g_Thanatos3_Stage[id] = pev(Ent, pev_iuser4)
	}

	return HAM_HANDLED	
}

public fw_Weapon_WeaponIdle_Post_TN3( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return
	static Id; Id = get_pdata_cbase(iEnt, 41, 4)
	if(get_pdata_cbase(Id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_Thanatos3, Id))
		return
		
	if(get_pdata_float(iEnt, 48, 4) <= 0.1)
	{
		switch(g_Thanatos3_Stage[Id])
		{
			case STAGE_NONE_TN3: Set_WeaponAnim(Id, ANIME_IDLE_TN3)
			case STAGE_ULTIMATE_TN3: Set_WeaponAnim(Id, ANIME_IDLE_W1_TN3)
			case STAGE_OMEGA_TN3: Set_WeaponAnim(Id, ANIME_IDLE_W2_TN3)
			case STAGE_METATRON_TN3: Set_WeaponAnim(Id, ANIME_IDLE_W3_TN3)
		}
		
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public fw_TraceAttack_World_TN3(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS3 || !Get_BitVar(g_Had_Thanatos3, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
		
	get_tr2(Ptr, TR_vecEndPos, flEnd)
	get_tr2(Ptr, TR_vecPlaneNormal, vecPlane)		
			
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, float(DAMAGE_TN3))
	
	return HAM_IGNORED
}

public fw_TraceAttack_Player_TN3(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS3 || !Get_BitVar(g_Had_Thanatos3, Attacker))
		return HAM_IGNORED
		
	SetHamParamFloat(3, float(DAMAGE_TN3))
	
	return HAM_IGNORED
}

public fw_Item_PostFrame_TN3(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos3, id))
		return HAM_IGNORED	
	
	static Float:flNextAttack; flNextAttack = get_pdata_float(id, 83, 5)
	static bpammo; bpammo = cs_get_user_bpammo(id, CSW_THANATOS3)
	
	static iClip; iClip = get_pdata_int(ent, 51, 4)
	static fInReload; fInReload = get_pdata_int(ent, 54, 4)
	
	if(fInReload && flNextAttack <= 0.0)
	{
		static temp1
		temp1 = min(CLIP_TN3 - iClip, bpammo)

		set_pdata_int(ent, 51, iClip + temp1, 4)
		cs_set_user_bpammo(id, CSW_THANATOS3, bpammo - temp1)		
		
		set_pdata_int(ent, 54, 0, 4)
		
		fInReload = 0
	}		
	
	return HAM_IGNORED
}

public fw_Weapon_Reload_TN3(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos3, id))
		return HAM_IGNORED	

	g_Thanatos3_Clip[id] = -1
		
	static BPAmmo; BPAmmo = cs_get_user_bpammo(id, CSW_THANATOS3)
	static iClip; iClip = get_pdata_int(ent, 51, 4)
		
	if(BPAmmo <= 0)
		return HAM_SUPERCEDE
	if(iClip >= CLIP_TN3)
		return HAM_SUPERCEDE		
			
	g_Thanatos3_Clip[id] = iClip	
	
	return HAM_HANDLED
}

public fw_Weapon_Reload_Post_TN3(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos3, id))
		return HAM_IGNORED	
		
	if((get_pdata_int(ent, 54, 4) == 1))
	{ // Reload
		if(g_Thanatos3_Clip[id] == -1)
			return HAM_IGNORED
		
		set_pdata_int(ent, 51, g_Thanatos3_Clip[id], 4)
		set_pdata_float(id, 83, RELOAD_TIME_TN3, 5)
		set_pdata_float(ent, 48, 3.5, 4)
		
		switch(g_Thanatos3_Stage[id])
		{
			case STAGE_NONE_TN3: Set_WeaponAnim(id, ANIME_RELOAD_TN3)
			case STAGE_ULTIMATE_TN3: Set_WeaponAnim(id, ANIME_RELOAD_W1_TN3)
			case STAGE_OMEGA_TN3: Set_WeaponAnim(id, ANIME_RELOAD_W2_TN3)
			case STAGE_METATRON_TN3: Set_WeaponAnim(id, ANIME_RELOAD_W3_TN3)
		}
	}
	
	return HAM_HANDLED
}

public fw_Weapon_PrimaryAttack_Post_TN3(Ent)
{
	static id; id = pev(Ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos3, id))
		return HAM_IGNORED
		
	set_pdata_float(Ent, 48, 0.5, 4)
	return HAM_IGNORED
}

public plugin_init_TN5() 
{
	
	register_think(SCYTHE_CLASSNAME_TN5, "fw_Scythe_Think_TN5")
	register_think(SCYTHE_CLASSNAME2_TN5, "fw_Scythe_Think2_TN5")
	
	register_forward(FM_UpdateClientData,"fw_UpdateClientData_Post_TN5", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent_TN5")	
	register_forward(FM_SetModel, "fw_SetModel_TN5")		
	register_forward(FM_CmdStart, "fw_CmdStart_TN5")
	register_forward(FM_EmitSound, "fw_EmitSound_TN5")
	register_forward(FM_TraceLine, "fw_TraceLine_TN5")
	register_forward(FM_TraceHull, "fw_TraceHull_TN5")	
	
	RegisterHam(Ham_Item_Deploy, weapon_thanatos5, "fw_Item_Deploy_Post_TN5", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_thanatos5, "fw_Item_AddToPlayer_Post_TN5", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_thanatos5, "fw_Item_PostFrame_TN5")	
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos5, "fw_Weapon_Reload_TN5")
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos5, "fw_Weapon_Reload_Post_TN5", 1)	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos5, "fw_Weapon_WeaponIdle_Post_TN5", 1)
	
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World_TN5")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player_TN5")	
	
	g_MsgCurWeapon = get_user_msgid("CurWeapon")
	g_MsgStatusIcon = get_user_msgid("StatusIcon")
	g_MsgWeaponList = get_user_msgid("WeaponList")
	g_MaxPlayers = get_maxplayers()
	
}

public plugin_precache_TN5()
{
	precache_model(V_MODEL_TN5)
	precache_model(P_MODEL_TN5)
	precache_model(W_MODEL_TN5)
	precache_model(S_MODEL_TN5)
	
	for(new i = 0; i < sizeof(WeaponSounds_TN5); i++)
		precache_sound(WeaponSounds_TN5[i])
		
	g_Exp_SprID = precache_model(WeaponResources_TN5[0])
	g_Exp2_SprID = precache_model(WeaponResources_TN5[1])
	precache_model(WeaponResources_TN5[2])
	precache_model(WeaponResources_TN5[3])
	precache_model(WeaponResources_TN5[4])
	precache_generic(WeaponResources_TN5[5])
	
	g_ShellId = precache_model("models/rshell.mdl")
	g_SmokePuff_SprId = precache_model("sprites/wall_puff1.spr")
	spr_trail = engfunc(EngFunc_PrecacheModel, "sprites/laserbeam.spr")
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post_TN5", 1)
}

public fw_PrecacheEvent_Post_TN5(type, const name[])
{
	if(equal("events/m4a1.sc", name)) g_Event_Thanatos5 = get_orig_retval()		
}

public Hook_Weapon(id) 
{
	engclient_cmd(id, weapon_thanatos5)
	return PLUGIN_HANDLED
}


public Update_Ammo_TN5(id, Ammo)
{
	if(!is_user_alive(id))
		return
	
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_THANATOS5)
	write_byte(Ammo)
	message_end()
}

public fw_UpdateClientData_Post_TN5(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_THANATOS5 && Get_BitVar(g_Had_Thanatos5, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent_TN5(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(invoker))
		return FMRES_IGNORED	
	if(get_user_weapon(invoker) != CSW_THANATOS5 || !Get_BitVar(g_Had_Thanatos5, invoker))
		return FMRES_IGNORED
	if(eventid != g_Event_Thanatos5)
		return FMRES_IGNORED
	
	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	
	if(Get_BitVar(g_GrenadeMode, invoker)) Set_WeaponAnim(invoker, ANIM_SHOOT_B1_TN5)
	else Set_WeaponAnim(invoker, ANIM_SHOOT_A1_TN5)
	emit_sound(invoker, CHAN_WEAPON, WeaponSounds_TN5[0], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	Eject_Shell(invoker, g_ShellId, 0.01)

	return FMRES_IGNORED
}



public fw_SetModel_TN5(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static Classname[32]
	pev(entity, pev_classname, Classname, sizeof(Classname))
	
	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner
	iOwner = pev(entity, pev_owner)
	
	if(equal(model, THANATOS5_OLDMODEL))
	{
		static weapon; weapon = find_ent_by_owner(-1, weapon_thanatos5, entity)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED;
		
		if(Get_BitVar(g_Had_Thanatos5, iOwner))
		{
			set_pev(weapon, pev_impulse, 3152015)
			set_pev(weapon, pev_iuser4, Get_BitVar(g_GrenadeMode, iOwner) ? 1 : 0)
			
			engfunc(EngFunc_SetModel, entity, W_MODEL_TN5)
			
			Remove_Thanatos5(iOwner)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart_TN5(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_THANATOS5 || !Get_BitVar(g_Had_Thanatos5, id))
		return FMRES_IGNORED
		
	static PressedButton
	PressedButton = get_uc(uc_handle, UC_Buttons)
	
	if(PressedButton & IN_ATTACK2)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return FMRES_IGNORED
		
		PressedButton &= ~IN_ATTACK2
		set_uc(uc_handle, UC_Buttons, PressedButton)

		if(!Get_BitVar(g_GrenadeMode, id))
		{
			set_pdata_float(id, 83, 5.0, 5)
			Set_WeaponIdleTime(id, CSW_THANATOS5, 5.0)
			
			Set_WeaponAnim(id, ANIM_CHANGE_TN5)
			
			remove_task(id+TASK_RELOAD_TN5)
			set_task(4.75, "Complete_Reload_TN5", id+TASK_RELOAD_TN5)
		} else {
			Shoot_Scythe_TN5(id)
		}
	}
		
	return FMRES_HANDLED
}

public Complete_Reload_TN5(id)
{
	id -= TASK_RELOAD_TN5
	
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) != CSW_THANATOS5 || !Get_BitVar(g_Had_Thanatos5, id))
		return
	if(Get_BitVar(g_GrenadeMode, id))
		return
		
	Set_BitVar(g_GrenadeMode, id)
	
	set_pdata_float(id, 83, 0.0, 5)
	Set_WeaponIdleTime(id, CSW_THANATOS5, 0.0)
	Set_WeaponAnim(id, ANIM_IDLE_B_TN5)
	
	Update_SpecialAmmo(id, 1, 1)
}

public Shoot_Scythe_TN5(id)
{
	emit_sound(id, CHAN_WEAPON, WeaponSounds_TN5[1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	Create_FakeAttackAnim(id)
	Set_WeaponAnim(id, ANIM_SHOOT_SPECIAL_TN5)
	
	Update_SpecialAmmo(id, 1, 0)
	set_pdata_float(id, 83, 2.0, 5)
	Set_WeaponIdleTime(id, CSW_THANATOS5, 2.0)
	
	UnSet_BitVar(g_GrenadeMode, id)
	
	// Fake Punch
	//static Float:Origin[3]
	//Origin[0] = random_float(-2.5, -5.0)
	
	//set_pev(id, pev_punchangle, Origin)
	
	// Scythe
	Create_Scythe_TN5(id)
}

public fw_EmitSound_TN5(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
		
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
			return FMRES_SUPERCEDE
		if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
		{
			if (sample[17] == 'w')  return FMRES_SUPERCEDE
			else  return FMRES_SUPERCEDE
		}
		if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
			return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED
}

public fw_TraceLine_TN5(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)

	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceLine, vecStart, vecEnd, ignored_monster, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_TraceHull_TN5(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)
	
	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceHull, vecStart, vecEnd, ignored_monster, hull, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_Item_Deploy_Post_TN5(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Thanatos5, Id))
		return
	
	set_pev(Id, pev_viewmodel2, V_MODEL_TN5)
	set_pev(Id, pev_weaponmodel2, P_MODEL_TN5)
	
	if(Get_BitVar(g_GrenadeMode, Id)) Set_WeaponAnim(Id, ANIM_DRAW_B_TN5)
	else Set_WeaponAnim(Id, ANIM_DRAW_A_TN5)
}

public fw_Item_AddToPlayer_Post_TN5(Ent, id)
{
	if(!pev_valid(Ent))
		return HAM_IGNORED
		
	if(pev(Ent, pev_impulse) == 3152015)
	{
		Set_BitVar(g_Had_Thanatos5, id)
		set_pev(Ent, pev_impulse, 0)
		
		if(pev(Ent, pev_iuser4)) 
		{
			Set_BitVar(g_GrenadeMode, id)
			Update_SpecialAmmo(id, 1, 1)
		}
		
		message_begin(MSG_ONE_UNRELIABLE, g_MsgWeaponList, _, id)
		write_string("weapon_thanatos5")
		write_byte(4)
		write_byte(90)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(6)
		write_byte(CSW_THANATOS5)
		write_byte(0)
		message_end()		
	}

	return HAM_HANDLED	
}

public fw_Weapon_WeaponIdle_Post_TN5( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return
	static Id; Id = get_pdata_cbase(iEnt, 41, 4)
	if(get_pdata_cbase(Id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_Thanatos5, Id))
		return
		
	if(get_pdata_float(iEnt, 48, 4) <= 0.25)
	{
		if(Get_BitVar(g_GrenadeMode, Id)) Set_WeaponAnim(Id, ANIM_IDLE_B_TN5)
		else Set_WeaponAnim(Id, ANIM_IDLE_A_TN5)
		
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public fw_TraceAttack_World_TN5(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS5 || !Get_BitVar(g_Had_Thanatos5, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
		
	get_tr2(Ptr, TR_vecEndPos, flEnd)
	get_tr2(Ptr, TR_vecPlaneNormal, vecPlane)		
			
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, float(DAMAGE_A_TN5))
	
	return HAM_IGNORED
}

public fw_TraceAttack_Player_TN5(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS5 || !Get_BitVar(g_Had_Thanatos5, Attacker))
		return HAM_IGNORED
		
	SetHamParamFloat(3, float(DAMAGE_A_TN5))
	
	return HAM_IGNORED
}

public fw_Item_PostFrame_TN5(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos5, id))
		return HAM_IGNORED	
	
	static Float:flNextAttack; flNextAttack = get_pdata_float(id, 83, 5)
	static bpammo; bpammo = cs_get_user_bpammo(id, CSW_THANATOS5)
	
	static iClip; iClip = get_pdata_int(ent, 51, 4)
	static fInReload; fInReload = get_pdata_int(ent, 54, 4)
	
	if(fInReload && flNextAttack <= 0.0)
	{
		static temp1
		temp1 = min(CLIP_TN5 - iClip, bpammo)

		set_pdata_int(ent, 51, iClip + temp1, 4)
		cs_set_user_bpammo(id, CSW_THANATOS5, bpammo - temp1)		
		
		set_pdata_int(ent, 54, 0, 4)
		
		fInReload = 0
	}		
	
	return HAM_IGNORED
}

public fw_Weapon_Reload_TN5(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos5, id))
		return HAM_IGNORED	

	g_Thanatos5_Clip[id] = -1
		
	static BPAmmo; BPAmmo = cs_get_user_bpammo(id, CSW_THANATOS5)
	static iClip; iClip = get_pdata_int(ent, 51, 4)
		
	if(BPAmmo <= 0)
		return HAM_SUPERCEDE
	if(iClip >= CLIP_TN5)
		return HAM_SUPERCEDE		
			
	g_Thanatos5_Clip[id] = iClip	
	
	return HAM_HANDLED
}

public fw_Weapon_Reload_Post_TN5(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos5, id))
		return HAM_IGNORED	
		
	if((get_pdata_int(ent, 54, 4) == 1))
	{ // Reload
		if(g_Thanatos5_Clip[id] == -1)
			return HAM_IGNORED
		
		set_pdata_int(ent, 51, g_Thanatos5_Clip[id], 4)
		set_pdata_float(id, 83, 3.0, 5)
		
		if(Get_BitVar(g_GrenadeMode, id)) Set_WeaponAnim(id, ANIM_RELOAD_B_TN5)
		else Set_WeaponAnim(id, ANIM_RELOAD_A_TN5)
	}
	
	return HAM_HANDLED
}

public Create_Scythe_TN5(id)
{
	new iEnt = create_entity("info_target")
	
	static Float:Origin[3], Float:Angles[3], Float:TargetOrigin[3], Float:Velocity[3]
	
	get_weapon_attachment(id, Origin, 40.0)
	get_position(id, 1024.0, 6.0, 0.0, TargetOrigin)
	
	pev(id, pev_v_angle, Angles)
	Angles[0] *= -1.0

	// set info for ent
	set_pev(iEnt, pev_movetype, MOVETYPE_PUSHSTEP)
	entity_set_string(iEnt, EV_SZ_classname, SCYTHE_CLASSNAME_TN5)
	engfunc(EngFunc_SetModel, iEnt, S_MODEL_TN5)
	
	set_pev(iEnt, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(iEnt, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(iEnt, pev_origin, Origin)
	set_pev(iEnt, pev_gravity, 1.0)
	set_pev(iEnt, pev_angles, Angles)
	set_pev(iEnt, pev_solid, SOLID_TRIGGER)
	set_pev(iEnt, pev_owner, id)	
	set_pev(iEnt, pev_iuser1, get_user_team(id))
	set_pev(iEnt, pev_iuser2, 0)
	set_pev(iEnt, pev_fuser1, get_gametime() + 1.5)

	get_speed_vector(Origin, TargetOrigin, 900.0, Velocity)
	set_pev(iEnt, pev_velocity, Velocity)	
	
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
	
	// Animation
	set_pev(iEnt, pev_animtime, get_gametime())
	set_pev(iEnt, pev_framerate, 2.0)
	set_pev(iEnt, pev_sequence, 0)
	
	// Make a Beam
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)
	write_short(iEnt) // entity
	write_short(spr_trail) // sprite
	write_byte(20)  // life
	write_byte(2)  // width
	write_byte(200) // r
	write_byte(200);  // g
	write_byte(200);  // b
	write_byte(200); // brightness
	message_end();
}

public fw_Scythe_Think_TN5(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Float:Time; pev(Ent, pev_fuser1, Time)
	static Team; Team = pev(Ent, pev_iuser1)
	
	if(Time <= get_gametime())
	{
		static Float:Origin[3];
		pev(Ent, pev_origin, Origin)
		
		Thanatos5_Explose(Origin)
		emit_sound(Ent, CHAN_BODY, WeaponSounds_TN5[2], VOL_NORM, ATTN_NONE, 0, PITCH_NORM)
		
		static ID; ID = pev(Ent, pev_owner)
		if(!is_user_connected(ID))
		{
			set_pev(Ent, pev_flags, FL_KILLME)
			set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
			
			return
		}
		
		Thanatos5_Damage(ID, Team, Origin)
		Create_ScytheSystem_TN5(ID, Ent, 1)
		
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
		
		return
	}
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
}

public Create_ScytheSystem_TN5(id, Ent, Next)
{
	static Float:Origin[4][3]
	static Float:Start[3]; pev(Ent, pev_origin, Start)
	
	get_position(Ent, 100.0, 0.0, 100.0, Origin[0])
	get_position(Ent, -100.0, 0.0, 100.0, Origin[1])
	get_position(Ent, 0.0, -100.0, 100.0, Origin[2])
	get_position(Ent, 0.0, 100.0, 100.0, Origin[3])
	
	for(new i = 0; i < 4; i++)
		Create_Mine_TN5(id, Start, Origin[i], Next)
}

public Create_Mine_TN5(id, Float:Origin[3], Float:TargetOrigin[3], Next)
{
	new iEnt = create_entity("info_target")
	static Float:Velocity[3]

	// set info for ent
	set_pev(iEnt, pev_movetype, MOVETYPE_PUSHSTEP)
	entity_set_string(iEnt, EV_SZ_classname, SCYTHE_CLASSNAME2_TN5)
	engfunc(EngFunc_SetModel, iEnt, S_MODEL_TN5)
	
	set_pev(iEnt, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(iEnt, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(iEnt, pev_origin, Origin)
	set_pev(iEnt, pev_gravity, 1.0)
	set_pev(iEnt, pev_solid, SOLID_TRIGGER)
	set_pev(iEnt, pev_owner, id)	
	set_pev(iEnt, pev_iuser1, get_user_team(id))
	set_pev(iEnt, pev_iuser2, Next)
	set_pev(iEnt, pev_fuser1, get_gametime() + 1.5)

	get_speed_vector(Origin, TargetOrigin, 250.0, Velocity)
	set_pev(iEnt, pev_velocity, Velocity)	
	
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
	
	// Animation
	set_pev(iEnt, pev_animtime, get_gametime())
	set_pev(iEnt, pev_framerate, 2.0)
	set_pev(iEnt, pev_sequence, 0)
	
	// Make a Beam
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)
	write_short(iEnt) // entity
	write_short(spr_trail) // sprite
	write_byte(10)  // life
	write_byte(2)  // width
	write_byte(200) // r
	write_byte(200);  // g
	write_byte(200);  // b
	write_byte(200); // brightness
	message_end();
}

public fw_Scythe_Think2_TN5(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Float:Time; pev(Ent, pev_fuser1, Time)
	static Next; Next = pev(Ent, pev_iuser2)
	static Team; Team = pev(Ent, pev_iuser1)
	
	if(Time <= get_gametime())
	{
		static Float:Origin[3];
		pev(Ent, pev_origin, Origin)
		
		Thanatos5_Explose(Origin)
		emit_sound(Ent, CHAN_BODY, WeaponSounds_TN5[2], VOL_NORM, ATTN_NONE, 0, PITCH_NORM)
		
		static ID; ID = pev(Ent, pev_owner)
		if(!is_user_connected(ID))
		{
			set_pev(Ent, pev_flags, FL_KILLME)
			set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
			
			return
		}
		
		Thanatos5_Damage(ID, Team, Origin)
		if(Next) Create_ScytheSystem_TN5(ID, Ent, 0)
		
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
		
		return
	}
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
}

public Thanatos5_Explose(Float:Origin[3])
{
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(g_Exp_SprID)	// sprite index
	write_byte(5)	// scale in 0.1's
	write_byte(30)	// framerate
	write_byte(TE_EXPLFLAG_NOSOUND)	// flags
	message_end()
	
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(g_Exp2_SprID)	// sprite index
	write_byte(5)	// scale in 0.1's
	write_byte(30)	// framerate
	write_byte(TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NODLIGHTS)	// flags
	message_end()
}

public Thanatos5_Damage(id, Team, Float:Origin[3])
{
	static Float:MyOrigin[3]
	for(new i = 0; i < g_MaxPlayers; i++)
	{
		if(!is_user_alive(id))
			continue
		if(get_user_team(i) == Team)
			continue
		if(id == i)
			continue
		pev(i, pev_origin, MyOrigin)
		if(get_distance_f(Origin, MyOrigin) > SCYTHE_RADIUS_TN5)
			continue
			
		ExecuteHamB(Ham_TakeDamage, i, 0, id, float(DAMAGE_B_TN5), DMG_BULLET)
	}
}


public plugin_init_TN9()
{
	
	// Forward
	register_forward(FM_EmitSound, "fw_EmitSound_TN9")
	register_forward(FM_CmdStart, "fw_CmdStart_TN9")
	register_forward(FM_TraceLine, "fw_TraceLine_TN9")
	register_forward(FM_TraceHull, "fw_TraceHull_TN9")	
	
	// Hams
	RegisterHam(Ham_TraceAttack, "player", "fw_PlayerTraceAttack_TN9")
	RegisterHam(Ham_Item_Deploy, weapon_thanatos9, "fw_Item_Deploy_Post_TN9", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_thanatos9, "fw_Item_AddToPlayer_Post_TN9", 1)
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos9, "fw_Weapon_WeaponIdle_Post_TN9", 1)
	
	// Cache
	g_MaxPlayers = get_maxplayers();
	g_MsgWeaponList = get_user_msgid("WeaponList")
}

public plugin_precache_TN9()
{
	precache_model(MODEL_V_TN9)
	precache_model(MODEL_PA_TN9)
	precache_model(MODEL_PB_TN9)
	precache_model(MODEL_PC_TN9)
	
	for(new i = 0; i < sizeof(WeaponSounds_TN9); i++)
		precache_sound(WeaponSounds_TN9[i])
	
	precache_generic(WeaponResources_TN9[0])
	precache_model(WeaponResources_TN9[1])
	g_SmokePuff_SprId = precache_model(WeaponResources_TN9[2])
}

public Hook_Thanatos9(id)
{
	engclient_cmd(id, weapon_thanatos9)
	return PLUGIN_HANDLED
}

public fw_EmitSound_TN9(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return FMRES_IGNORED
	if(!Get_BitVar(g_FallenGalvatron, id))
		return FMRES_IGNORED
		
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
			return FMRES_SUPERCEDE
		if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
		{
			if (sample[17] == 'w') // wall
			{
				return FMRES_SUPERCEDE
			} else {
				emit_sound(id, CHAN_BODY, sample, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE
			}
		}
		if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
			return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED
}

public fw_CmdStart_TN9(id, uc_handle, seed)
{
	if(!is_user_alive(id)) 
		return
		
	if(get_user_weapon(id) != CSW_THANATOS9)
	{
		if(Get_BitVar(g_FallenGalvatron, id))
		{
			UnSet_BitVar(g_FallenGalvatron, id)
			emit_sound(id, CHAN_WEAPON, WeaponSounds_TN9[4], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		}
		if(Get_BitVar(g_Changing, id))
			UnSet_BitVar(g_Changing, id)
		return
	}
	if(!Get_BitVar(g_Had_Thanatos9, id))
		return 
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS9)
	if(!pev_valid(Ent))
		return
	
	//if(get_pdata_float(Ent, 46, OFFSET_LINUX_WEAPONS) > 0.0 || get_pdata_float(Ent, 47, OFFSET_LINUX_WEAPONS) > 0.0) 
	//	return
	
	static CurButton; CurButton = get_uc(uc_handle, UC_Buttons)
	
	if(Get_BitVar(g_FallenGalvatron, id))
	{
		if(get_gametime() - 0.085 > CheckDamage[id])
		{
			ExecuteHamB(Ham_Weapon_PrimaryAttack, Ent)
			
			emit_sound(id, CHAN_WEAPON, WeaponSounds_TN9[3], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			if(pev(id, pev_weaponanim) != ANIME_SHOOT_B_LOOP_TN9)
				Set_WeaponAnim(id, ANIME_SHOOT_B_LOOP_TN9)
			
			CheckDamage[id] = get_gametime()
		}
		
		if(CurButton & IN_ATTACK) set_uc(uc_handle, UC_Buttons, CurButton & ~IN_ATTACK)
		else if (CurButton & IN_ATTACK2) set_uc(uc_handle, UC_Buttons, CurButton & ~IN_ATTACK2)
	}
	
	if(get_pdata_float(id, 83, 5) > 0.0)
		return
	
	if(CurButton & IN_ATTACK)
	{
		set_uc(uc_handle, UC_Buttons, CurButton & ~IN_ATTACK)
		
		if(!Get_BitVar(g_MegatronMode, id))
		{
			Set_WeaponIdleTime(id, CSW_THANATOS9, SLASH_DELAY_TN9 + 0.25)
			Set_PlayerNextAttack(id, SLASH_DELAY_TN9 + 0.25)
			
			if(!Get_BitVar(g_DarthVader, id))
			{
				Set_WeaponAnim(id, ANIME_SHOOT_A1_TN9)
				emit_sound(id, CHAN_WEAPON, WeaponSounds_TN9[0], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				
				Set_BitVar(g_DarthVader, id)
			} else {
				Set_WeaponAnim(id, ANIME_SHOOT_A2_TN9)
				emit_sound(id, CHAN_WEAPON, WeaponSounds_TN9[1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				
				UnSet_BitVar(g_DarthVader, id)
			}
			
			remove_task(id+TASK_SLASHING_TN9)
			set_task(SLASH_DELAY_TN9, "Check_Slashing", id+TASK_SLASHING_TN9)
		} else {
			if(!Get_BitVar(g_FallenGalvatron, id))
			{
				Set_WeaponIdleTime(id, CSW_THANATOS9, 0.5)
				Set_PlayerNextAttack(id, 0.5)
				
				Set_WeaponAnim(id, ANIME_SHOOT_B_START_TN9)
				set_task(0.45, "Activate_FallenGalvatron", id+TASK_CHANGING_TN9)
			} else {
				
			}
		}
	} else if (CurButton & IN_ATTACK2) {
		set_uc(uc_handle, UC_Buttons, CurButton & ~IN_ATTACK2)
		
		if(Get_BitVar(g_Changing, id))
			return
			
		Set_BitVar(g_Changing, id)
		CheckDamage[id] = get_gametime() + 0.75
			
		if(!Get_BitVar(g_MegatronMode, id))
		{
			remove_task(id+TASK_CHANGING_TN9)

			Set_WeaponIdleTime(id, CSW_THANATOS9, CHANGE_TIME_MEGATRON_TN9 + 0.25)
			Set_PlayerNextAttack(id, CHANGE_TIME_MEGATRON_TN9)
			
			Set_WeaponAnim(id, ANIME_CHANGE_TO_MEGATRON)
			
			set_task(0.75, "Create_Smoke", id+TASK_CHANGING_TN9)
			set_task(3.0, "Remove_Smoke", id+TASK_CHANGING_TN9)
		} else {
			remove_task(id+TASK_CHANGING_TN9)
			
			Set_WeaponIdleTime(id, CSW_THANATOS9, CHANGE_TIME_GALVATRON_TN9 + 0.25)
			Set_PlayerNextAttack(id, CHANGE_TIME_GALVATRON_TN9)
			
			Set_WeaponAnim(id, ANIME_CHANGE_TO_GALVATRON)
			
			set_task(0.75, "Create_Smoke", id+TASK_CHANGING_TN9)
			set_task(CHANGE_TIME_GALVATRON_TN9 - 0.25, "Change_Thanatos9", id+TASK_CHANGING_TN9)
		}
	}
}

public Create_Smoke(id)
{
	id -= TASK_CHANGING_TN9
	
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return
		
	static Float:Origin[3]; get_position(id, 25.0, 15.0, 0.0, Origin)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY) 
	write_byte(TE_EXPLOSION) 
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(g_SmokePuff_SprId)
	write_byte(1)
	write_byte(30)
	write_byte(14)
	message_end()
	
	set_task(0.5, "Create_Smoke", id+TASK_CHANGING_TN9)
}

public Remove_Smoke(id)
{
	id -= TASK_CHANGING_TN9
	
	if(!is_user_alive(id))
		return
		
	remove_task(id+TASK_CHANGING_TN9)
	set_task(CHANGE_TIME_MEGATRON_TN9 - 3.25, "Change_Thanatos9", id+TASK_CHANGING_TN9)
}

public Activate_FallenGalvatron(id)
{
	id -= TASK_CHANGING_TN9
	
	if(!is_user_alive(id)) 
		return
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return 
	if(!Get_BitVar(g_MegatronMode, id))
		return
		
	UnSet_BitVar(g_MegatronMode, id)
	Set_BitVar(g_FallenGalvatron, id)
	
	set_pev(id, pev_weaponmodel2, MODEL_PC_TN9)
	
	Set_WeaponIdleTime(id, CSW_THANATOS9, FALLEN_GALVATRON_TIME_TN9)
	Set_PlayerNextAttack(id, FALLEN_GALVATRON_TIME_TN9)
	
	Set_WeaponAnim(id, ANIME_SHOOT_B_LOOP_TN9)
	
	remove_task(id+TASK_CHANGING_TN9)
	set_task(FALLEN_GALVATRON_TIME_TN9, "Deactivate_FallenGalvatron", id+TASK_CHANGING_TN9)
}

public Deactivate_FallenGalvatron(id)
{
	id -= TASK_CHANGING_TN9
	
	if(!is_user_alive(id)) 
		return
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return 
	if(!Get_BitVar(g_FallenGalvatron, id))
		return
		
	UnSet_BitVar(g_FallenGalvatron, id)
	UnSet_BitVar(g_MegatronMode, id)
	
	set_pev(id, pev_weaponmodel2, MODEL_PB_TN9)
	
	Set_WeaponIdleTime(id, CSW_THANATOS9, 0.7 + CHANGE_TIME_GALVATRON_TN9)
	Set_PlayerNextAttack(id, 0.7 + CHANGE_TIME_GALVATRON_TN9)
	
	Set_WeaponAnim(id, ANIME_SHOOT_B_END_TN9)
	emit_sound(id, CHAN_WEAPON, WeaponSounds_TN9[4], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	remove_task(id+TASK_CHANGING_TN9)
	set_task(0.65, "Deactivate_MegatronMode", id+TASK_CHANGING_TN9)
}

public Deactivate_MegatronMode(id)
{
	id -= TASK_CHANGING_TN9
	
	if(!is_user_alive(id)) 
		return
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return 

	set_pev(id, pev_weaponmodel2, MODEL_PA_TN9)
	set_pdata_string(id, (492) * 4, WEAPON_ANIMEXTA_TN9, -1 , 20)
	
	set_task(0.75, "Create_Smoke", id+TASK_CHANGING_TN9)
	set_task(3.0, "Remove_Smoke", id+TASK_CHANGING_TN9)
	
	Set_WeaponAnim(id, ANIME_CHANGE_TO_GALVATRON)
}

public Change_Thanatos9(id)
{
	id -= TASK_CHANGING_TN9
	
	remove_task(id+TASK_CHANGING_TN9)
	
	if(!is_user_alive(id)) 
		return
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return 
	if(!Get_BitVar(g_Changing, id))
		return
		
	UnSet_BitVar(g_Changing, id)
			
	if(!Get_BitVar(g_MegatronMode, id))
	{
		set_pev(id, pev_weaponmodel2, MODEL_PB_TN9)
		
		Set_BitVar(g_MegatronMode, id)
		Set_WeaponAnim(id, ANIME_IDLE_B_TN9)
		
		set_pdata_string(id, (492) * 4, WEAPON_ANIMEXTB_TN9, -1 , 20)
	} else {
		set_pev(id, pev_weaponmodel2, MODEL_PA_TN9)
		
		UnSet_BitVar(g_MegatronMode, id)
		Set_WeaponAnim(id, ANIME_IDLE_A_TN9)
		
		set_pdata_string(id, (492) * 4, WEAPON_ANIMEXTA_TN9, -1 , 20)
	}
}

public Check_Slashing(id)
{
	id -= TASK_SLASHING_TN9
	
	if(!is_user_alive(id)) 
		return
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return 	
		
	Set_WeaponIdleTime(id, CSW_THANATOS9, 1.0)
	Set_PlayerNextAttack(id, 0.75)

	Damage_Slashing(id)
}

public Damage_Slashing(id)
{
	static Float:Max_Distance, Float:Point[4][3], Float:TB_Distance, Float:Point_Dis
	
	Point_Dis = 80.0
	Max_Distance = RADIUS_TN9
	TB_Distance = Max_Distance / 4.0
	
	static Float:VicOrigin[3], Float:MyOrigin[3]
	pev(id, pev_origin, MyOrigin)
	
	for(new i = 0; i < 4; i++) get_position(id, TB_Distance * (i + 1), 0.0, 0.0, Point[i])
		
	static Have_Victim; Have_Victim = 0
	static ent
	ent = fm_get_user_weapon_entity(id, get_user_weapon(id))
		
	if(!pev_valid(ent))
		return
		
	for(new i = 0; i < g_MaxPlayers; i++)
	{
		if(!is_user_alive(i))
			continue
		if(id == i)
			continue
		if(entity_range(id, i) > Max_Distance)
			continue

		pev(i, pev_origin, VicOrigin)
		if(is_wall_between_points(MyOrigin, VicOrigin, id))
			continue
			
		if(get_distance_f(VicOrigin, Point[0]) <= Point_Dis
		|| get_distance_f(VicOrigin, Point[1]) <= Point_Dis
		|| get_distance_f(VicOrigin, Point[2]) <= Point_Dis
		|| get_distance_f(VicOrigin, Point[3]) <= Point_Dis)
		{
			if(!Have_Victim) Have_Victim = 1
			do_attack(id, i, ent, float(DAMAGE_A_TN9))
		}
	}

	if(Have_Victim) emit_sound(id, CHAN_STATIC, WeaponSounds_TN9[11], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	else {
		MyOrigin[2] += 26.0
		get_position(id, RADIUS_TN9 - 5.0, 0.0, 0.0, Point[0])
		
		if(is_wall_between_points(MyOrigin, Point[0], id))
			emit_sound(id, CHAN_STATIC, WeaponSounds_TN9[12], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	}
}

public fw_TraceLine_TN9(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)

	if(!Get_BitVar(g_FallenGalvatron, id)) xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	else xs_vec_mul_scalar(v_forward, RADIUS_TN9, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceLine, vecStart, vecEnd, ignored_monster, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_TraceHull_TN9(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) != CSW_THANATOS9 || !Get_BitVar(g_Had_Thanatos9, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)
	
	if(!Get_BitVar(g_FallenGalvatron, id)) xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	else xs_vec_mul_scalar(v_forward, RADIUS_TN9, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceHull, vecStart, vecEnd, ignored_monster, hull, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_PlayerTraceAttack_TN9(Victim, Attacker, Float:Damage, Float:Direction[3], TraceResult, DamageBits) 
{
	if(!is_user_alive(Attacker))	
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos9, Attacker) || !Get_BitVar(g_FallenGalvatron, Attacker))
		return HAM_IGNORED
		
	SetHamParamFloat(3, float(DAMAGE_B_TN9))
		
	return HAM_IGNORED
}

public fw_Item_Deploy_Post_TN9(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Thanatos9, Id))
		return
	
	remove_task(Id+TASK_CHANGING_TN9)
	UnSet_BitVar(g_Changing, Id)
	UnSet_BitVar(g_FallenGalvatron, Id)
	
	set_pev(Id, pev_viewmodel2, MODEL_V_TN9)

	if(!Get_BitVar(g_MegatronMode, Id))
	{
		set_pev(Id, pev_weaponmodel2, MODEL_PA_TN9)
		Set_WeaponAnim(Id, ANIME_DRAW_A_TN9)
		
		set_pdata_string(Id, (492) * 4, WEAPON_ANIMEXTA_TN9, -1 , 20)
	} else {
		set_pev(Id, pev_weaponmodel2, MODEL_PB_TN9)
		Set_WeaponAnim(Id, ANIME_DRAW_B_TN9)
		
		set_pdata_string(Id, (492) * 4, WEAPON_ANIMEXTB_TN9, -1 , 20)
	}
}

public fw_Item_AddToPlayer_Post_TN9(Ent, id)
{
	if(!pev_valid(Ent))
		return HAM_IGNORED
	
	if(Get_BitVar(g_Had_Thanatos9, id))
	{
		message_begin(MSG_ONE_UNRELIABLE, g_MsgWeaponList, _, id)
		write_string("knife_thanatos9")
		write_byte(-1)
		write_byte(-1)
		write_byte(-1)
		write_byte(-1)
		write_byte(2)
		write_byte(1)
		write_byte(CSW_THANATOS9)
		write_byte(0)
		message_end()		
	} 
	
	return HAM_HANDLED	
}

public fw_Weapon_WeaponIdle_Post_TN9(iEnt)
{
	if(pev_valid(iEnt) != 2)
		return
	static Id; Id = get_pdata_cbase(iEnt, 41, 4)
	//if(get_pdata_cbase(Id, 373) != iEnt)
	//	/return
	if(!Get_BitVar(g_Had_Thanatos9, Id))
		return
		
	if(get_pdata_float(iEnt, 48, 4) <= 0.25)
	{
		if(Get_BitVar(g_FallenGalvatron, Id)) Set_WeaponAnim(Id, ANIME_SHOOT_B_LOOP_TN9)
		else if(Get_BitVar(g_MegatronMode, Id)) Set_WeaponAnim(Id, ANIME_IDLE_B_TN9)
		else Set_WeaponAnim(Id, ANIME_IDLE_A_TN9)
		
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public plugin_init_TN11()
{
	

	register_event("CurWeapon", "Event_CurWeapon_TN11", "be", "1=1")
	
	register_forward(FM_SetModel, "fw_SetModel_TN11")
	register_forward(FM_CmdStart, "fw_CmdStart_TN11")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post_TN11", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent_TN11")	
	register_forward(FM_EmitSound, "fw_EmitSound_TN11")
	register_forward(FM_TraceLine, "fw_TraceLine_TN11")
	register_forward(FM_TraceHull, "fw_TraceHull_TN11")		
	
	register_touch(SCYTHE_CLASSNAME_TN11, "*", "fw_Scythe_Touch_TN11")
	register_think(SCYTHE_CLASSNAME_TN11, "fw_Scythe_Think_TN11")
	
	// Safety
	
	
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_TN11")
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_TN11")		
	
	RegisterHam(Ham_Item_Deploy, weapon_thanatos11, "fw_Item_Deploy_Post_TN11", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_thanatos11, "fw_Item_AddToPlayer_Post_TN11", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_thanatos11, "fw_Item_PostFrame_TN11")
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos11, "fw_Weapon_WeaponIdle_TN11")	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos11, "fw_Weapon_WeaponIdle_Post_TN11", 1)	
	
	// Cache
	g_MsgStatusIcon = get_user_msgid("StatusIcon")
	g_MsgCurWeapon = get_user_msgid("CurWeapon")
	
	
	
	
	
	register_think(ATTACHMENT_CLASSNAME, "fw_Think")
}

public plugin_precache_TN11()
{
	precache_model(V_MODEL_TN11)
	precache_model(P_MODEL_TN11)
	precache_model(W_MODEL_TN11)
	precache_model(S_MODEL_TN11)
	g_ScytheDeath = precache_model(SCYTHE_DEATH)
	
	precache_model(SCYTHE_HEAD)
	precache_model(SCYTHE_CIRCLE)
	
	for(new i = 0; i < sizeof(WeaponSounds_TN11); i++)
		precache_sound(WeaponSounds_TN11[i])

	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post_TN11", 1)	
	
	m_spriteTexture = precache_model("sprites/laserbeam.spr")
	g_SmokePuff_SprId = engfunc(EngFunc_PrecacheModel, "sprites/wall_puff1.spr")
}

public fw_PrecacheEvent_Post_TN11(type, const name[])
{
	if(equal(OLD_EVENT_TN11, name))
		g_Event_Thanatos11 = get_orig_retval()
}




public Hook_Weapon_TN11(id)
{
	engclient_cmd(id, weapon_thanatos11)
	return PLUGIN_HANDLED
}

public Event_CurWeapon_TN11(id)
{
	if(!is_user_alive(id))
		return
	
	static CSWID; CSWID = read_data(2)

	if((CSWID == CSW_THANATOS11 && g_OldWeapon[id] == CSW_THANATOS11) && Get_BitVar(g_Had_Thanatos11, id)) 
	{
		static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS11)
		if(pev_valid(Ent)) 
		{
			set_pdata_float(Ent, 46, get_pdata_float(Ent, 46, 4) * SPEED_TN11, 4)
			set_pdata_float(Ent, 47, get_pdata_float(Ent, 46, 4) * SPEED_TN11, 4)	
		}
	}
	
	g_OldWeapon[id] = CSWID
}

public fw_SetModel_TN11(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static Classname[64]
	pev(entity, pev_classname, Classname, sizeof(Classname))
	
	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED
	
	static id
	id = pev(entity, pev_owner)
	
	if(equal(model, OLD_W_MODEL_TN11))
	{
		static weapon
		weapon = fm_get_user_weapon_entity(entity, CSW_THANATOS11)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED
		
		if(Get_BitVar(g_Had_Thanatos11, id))
		{
			set_pev(weapon, pev_impulse, WEAPON_SECRETCODE_TN11)
			set_pev(weapon, pev_iuser4, g_ChargedAmmo2[id])
			engfunc(EngFunc_SetModel, entity, W_MODEL_TN11)
			
			Remove_Thanatos11(id)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart_TN11(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return
	if(!Get_BitVar(g_Had_Thanatos11, id))
		return
		
	if(get_gametime() - SCYTHE_RELOAD > ReloadTime[id])
	{
		if(g_ChargedAmmo2[id] < SCYTHE_MAX)
		{
			Update_SpecialAmmo(id, g_ChargedAmmo2[id], 0)
			g_ChargedAmmo2[id]++
			if(g_ChargedAmmo2[id] == 1 && g_Thanatos11_Mode[id] == T11_MODE_THANATOS) 
				Set_WeaponAnim(id, T11_ANIM_IDLEB_RELOAD)
			
			emit_sound(id, CHAN_ITEM, WeaponSounds_TN11[9], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			Update_SpecialAmmo(id, g_ChargedAmmo2[id], 1)
		}
		
		ReloadTime[id] = get_gametime()
	}
	
	if(get_user_weapon(id) != CSW_THANATOS11)
		return
		
	static PressedButton
	PressedButton = get_uc(uc_handle, UC_Buttons)
	
	if(PressedButton & IN_RELOAD)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return 
	
		if(g_Thanatos11_Mode[id] == T11_MODE_THANATOS)
		{
			PressedButton &= ~IN_RELOAD
			set_uc(uc_handle, UC_Buttons, PressedButton)
		}
	}
	
	if(PressedButton & IN_ATTACK)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return 
	
		if(g_Thanatos11_Mode[id] == T11_MODE_THANATOS)
		{
			PressedButton &= ~IN_ATTACK
			set_uc(uc_handle, UC_Buttons, PressedButton)
			
			Shoot_Scythe_TN11(id)
		}
	}
	
	if(PressedButton & IN_ATTACK2)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return 
	
		switch(g_Thanatos11_Mode[id])
		{
			case T11_MODE_NORMAL:
			{
				if(g_ChargedAmmo2[id] > 0) Set_WeaponAnim(id, T11_ANIM_CHANGEA)
				else Set_WeaponAnim(id, T11_ANIM_CHANGEA_EMPTY)
				
				set_pdata_float(id, 83, 2.5, 5)
				
				remove_task(id+TASK_CHANGE_TN11)
				set_task(2.35, "Complete_Reload_TN11", id+TASK_CHANGE_TN11)
			}
			case T11_MODE_THANATOS:
			{
				if(g_ChargedAmmo2[id] > 0) Set_WeaponAnim(id, T11_ANIM_CHANGEB)
				else Set_WeaponAnim(id, T11_ANIM_CHANGEB_EMPTY)
				
				set_pdata_float(id, 83, 2.5, 5)
				
				remove_task(id+TASK_CHANGE_TN11)
				set_task(2.35, "Complete_Reload_TN11", id+TASK_CHANGE_TN11)
			}
		}
	}
}

public Complete_Reload_TN11(id)
{
	id -= TASK_CHANGE_TN11
	
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) != CSW_THANATOS11 || !Get_BitVar(g_Had_Thanatos11, id))
		return
		
	switch(g_Thanatos11_Mode[id])
	{
		case T11_MODE_NORMAL:
		{
			g_Thanatos11_Mode[id] = T11_MODE_THANATOS
		}
		case T11_MODE_THANATOS:
		{
			g_Thanatos11_Mode[id] = T11_MODE_NORMAL
		}
	}
}

public Shoot_Scythe_TN11(id)
{
	if(g_ChargedAmmo2[id] <= 0)
		return

	Create_FakeAttackAnim(id)
	Update_SpecialAmmo(id, g_ChargedAmmo2[id], 0)
	g_ChargedAmmo2[id]--
	
	if(g_ChargedAmmo2[id]) 
	{	
		Set_WeaponAnim(id, T11_ANIM_SHOOTB)
		Update_SpecialAmmo(id, g_ChargedAmmo2[id], 1)
		
		emit_sound(id, CHAN_WEAPON, WeaponSounds_TN11[1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	} else {
		Set_WeaponAnim(id, T11_ANIM_SHOOTB_EMPTY)
		
		emit_sound(id, CHAN_WEAPON, WeaponSounds_TN11[2], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	}
	
	set_pdata_float(id, 83, 1.0, 5)
	
	// Fake Punch
	static Float:Origin[3]
	Origin[0] = random_float(-2.5, -5.0)
	
	set_pev(id, pev_punchangle, Origin)
	
	// Scythe
	Create_Scythe_TN11(id)
}

public Create_Scythe_TN11(id)
{
	new iEnt = create_entity("info_target")
	
	static Float:Origin[3], Float:Angles[3], Float:TargetOrigin[3], Float:Velocity[3]
	
	get_weapon_attachment(id, Origin, 40.0)
	get_position(id, 1024.0, 0.0, 0.0, TargetOrigin)
	
	pev(id, pev_v_angle, Angles)
	Angles[0] *= -1.0

	// set info for ent
	set_pev(iEnt, pev_movetype, MOVETYPE_FLY)
	entity_set_string(iEnt, EV_SZ_classname, SCYTHE_CLASSNAME_TN11)
	engfunc(EngFunc_SetModel, iEnt, S_MODEL_TN11)
	
	set_pev(iEnt, pev_mins, Float:{-6.0, -6.0, -6.0})
	set_pev(iEnt, pev_maxs, Float:{6.0, 6.0, 6.0})
	set_pev(iEnt, pev_origin, Origin)
	set_pev(iEnt, pev_gravity, 0.01)
	set_pev(iEnt, pev_angles, Angles)
	set_pev(iEnt, pev_solid, SOLID_TRIGGER)
	set_pev(iEnt, pev_owner, id)	
	set_pev(iEnt, pev_iuser1, get_user_team(id))
	set_pev(iEnt, pev_iuser2, 0)
	set_pev(iEnt, pev_fuser1, get_gametime() + 10.0)
	
	get_speed_vector(Origin, TargetOrigin, 1600.0, Velocity)
	set_pev(iEnt, pev_velocity, Velocity)	
	
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
	
	// Animation
	set_pev(iEnt, pev_animtime, get_gametime())
	set_pev(iEnt, pev_framerate, 2.0)
	set_pev(iEnt, pev_sequence, 0)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)
	write_short(iEnt)
	write_short(m_spriteTexture)
	write_byte(10)
	write_byte(3)
	write_byte(0)
	write_byte(85)
	write_byte(255)
	write_byte(255)
	message_end()
}

public fw_Scythe_Touch_TN11(Ent, id)
{
	if(!pev_valid(Ent))
		return
		
	if(is_user_alive(id))
	{
		static Owner; Owner = pev(Ent, pev_owner)
		if(!is_user_connected(Owner) || (get_user_team(id) == pev(Ent, pev_iuser1)))
			return
			
		ThanatosBladeSystem_TN11(id, Owner)
			
		set_pev(Ent, pev_movetype, MOVETYPE_NONE)
		set_pev(Ent, pev_velocity, {0.0, 0.0, 0.0})
		
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
	} else {
		set_pev(Ent, pev_movetype, MOVETYPE_NONE)
		set_pev(Ent, pev_velocity, {0.0, 0.0, 0.0})
		
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
		
		return
	}
}

public ThanatosBladeSystem_TN11(id, attacker)
{
	Show_Attachment(id, SCYTHE_HEAD, 3.0, 1.0, 1.0, 6)
	Show_Attachment(id, SCYTHE_CIRCLE, 3.0, 1.0, 0.1, 10)
	
	emit_sound(id, CHAN_ITEM, WeaponSounds_TN11[3], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	static ArraySuck[2]
	ArraySuck[0] = id
	ArraySuck[1] = attacker
	
	set_task(3.0, "Explosion_TN11", id+2122, ArraySuck, 2)
}

public Explosion_TN11(ArraySuck[], taskid)
{
	static id, attacker;
	id = ArraySuck[0]
	attacker = ArraySuck[1]
	
	if(!is_user_alive(id) || !is_user_connected(attacker))
		return
	if(get_user_team(id) == get_user_team(attacker))
		return
		
	emit_sound(id, CHAN_ITEM, WeaponSounds_TN11[11], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	static Float:Origin[3];
	pev(id, pev_origin, Origin)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(g_ScytheDeath)
	write_byte(10)
	write_byte(15)
	write_byte(TE_EXPLFLAG_NOSOUND)  
	message_end()
	
	ExecuteHamB(Ham_TakeDamage, id, fm_get_user_weapon_entity(attacker, CSW_THANATOS11), attacker, float(DAMAGE_B_TN11), DMG_BULLET)
}

public fw_Scythe_Think_TN11(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Float:Time; pev(Ent, pev_fuser1, Time)
	
	if(Time <= get_gametime())
	{
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
		
		return
	}
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
}


public fw_UpdateClientData_Post_TN11(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_THANATOS11 && Get_BitVar(g_Had_Thanatos11, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent_TN11(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(invoker))
		return FMRES_IGNORED		
	if(get_user_weapon(invoker) == CSW_THANATOS11 && Get_BitVar(g_Had_Thanatos11, invoker) && eventid == g_Event_Thanatos11)
	{
		engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
		Set_WeaponAnim(invoker, T11_ANIM_SHOOTA)

		emit_sound(invoker, CHAN_WEAPON, WeaponSounds_TN11[0], 1.0, ATTN_NORM, 0, PITCH_LOW)	
			
		return FMRES_SUPERCEDE
	}
	
	return FMRES_HANDLED
}

public fw_TraceAttack_TN11(Ent, Attacker, Float:Damage, Float:Dir[3], ptr, DamageType)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS11 || !Get_BitVar(g_Had_Thanatos11, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
	
	get_tr2(ptr, TR_vecEndPos, flEnd)
	get_tr2(ptr, TR_vecPlaneNormal, vecPlane)		
		
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, ptr)
	
	SetHamParamFloat(3, float(DAMAGE_A_TN11) / 6.0)
	
	return HAM_HANDLED	
}

public fw_Item_Deploy_Post_TN11(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Thanatos11, Id))
		return

	g_Thanatos11_Mode[Id] = T11_MODE_NORMAL
		
	set_pev(Id, pev_viewmodel2, V_MODEL_TN11)
	set_pev(Id, pev_weaponmodel2, P_MODEL_TN11)
	
	Set_WeaponAnim(Id, T11_ANIM_DRAW)
}

public fw_Item_AddToPlayer_Post_TN11(ent, id)
{
	if(pev(ent, pev_impulse) == WEAPON_SECRETCODE_TN11)
	{
		Set_BitVar(g_Had_Thanatos11, id)
		
		set_pev(ent, pev_impulse, 0)
		g_ChargedAmmo2[id] = pev(ent, pev_iuser4)
		
		Update_SpecialAmmo(id, g_ChargedAmmo2[id], 1)
	}			
}

public fw_Weapon_WeaponIdle_TN11( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return 
	static id; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)
	if(get_pdata_cbase(id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_Thanatos11, id))
		return
	
	if( get_pdata_float(iEnt, m_flTimeWeaponIdle, XTRA_OFS_WEAPON) > 0.0 )
	{
		return
	}
	
	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = CLIP_TN11

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
			Set_WeaponAnim(id, T11_ANIM_AFTER)
			
			set_pdata_int(iEnt, m_fInSpecialReload, 0, XTRA_OFS_WEAPON)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.5, XTRA_OFS_WEAPON)
		}
	}
	
	return
}

public fw_Weapon_WeaponIdle_Post_TN11( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return 
	static id; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)
	if(get_pdata_cbase(id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_Thanatos11, id))
		return
		
	static SpecialReload; SpecialReload = get_pdata_int(iEnt, 55, 4)
	if(!SpecialReload && get_pdata_float(iEnt, 48, 4) <= 0.25)
	{
		switch(g_Thanatos11_Mode[id])
		{
			case T11_MODE_NORMAL: Set_WeaponAnim(id, T11_ANIM_IDLEA)
			case T11_MODE_THANATOS: 
			{
				if(g_ChargedAmmo2[id] > 0) Set_WeaponAnim(id, T11_ANIM_IDLEB1)
				else Set_WeaponAnim(id, T11_ANIM_IDLEB_EMPTY)
			}
		}
		
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public fw_Item_PostFrame_TN11( iEnt )
{
	static id ; id = get_pdata_cbase(iEnt, m_pPlayer, XTRA_OFS_WEAPON)	

	static iBpAmmo ; iBpAmmo = get_pdata_int(id, 381, XTRA_OFS_PLAYER)
	static iClip ; iClip = get_pdata_int(iEnt, m_iClip, XTRA_OFS_WEAPON)
	static iId ; iId = get_pdata_int(iEnt, m_iId, XTRA_OFS_WEAPON)
	static iMaxClip ; iMaxClip = CLIP_TN11

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
			Set_WeaponAnim(id, T11_ANIM_INSERT)
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
			Set_WeaponAnim(id, T11_ANIM_START)
		
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

public fw_EmitSound_TN11(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
		
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
			return FMRES_SUPERCEDE
		if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
		{
			if (sample[17] == 'w')  return FMRES_SUPERCEDE
			else  return FMRES_SUPERCEDE
		}
		if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
			return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED
}

public fw_TraceLine_TN11(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)

	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceLine, vecStart, vecEnd, ignored_monster, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_TraceHull_TN11(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)
	
	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceHull, vecStart, vecEnd, ignored_monster, hull, id, handle)
	
	return FMRES_SUPERCEDE
}
public Show_Attachment(id, const Sprite[],  Float:Time, Float:Scale, Float:FrameRate, TotalFrame)
{
	if(!is_user_alive(id))
		return

	static channel; channel = 0
	for(new i = 0; i < MAX_CHANNEL; i++)
	{
		if(pev_valid(g_MyAttachment[id][i])) channel++
		else {
			channel = i
			break
		}
	}
	if(channel >= MAX_CHANNEL) return
	if(!pev_valid(g_MyAttachment[id][channel]))
		g_MyAttachment[id][channel] = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	if(!pev_valid(g_MyAttachment[id][channel]))
		return
	
	// Set Properties
	set_pev(g_MyAttachment[id][channel], pev_takedamage, DAMAGE_NO)
	set_pev(g_MyAttachment[id][channel], pev_solid, SOLID_NOT)
	set_pev(g_MyAttachment[id][channel], pev_movetype, MOVETYPE_FOLLOW)
	
	// Set Sprite
	set_pev(g_MyAttachment[id][channel], pev_classname, ATTACHMENT_CLASSNAME)
	engfunc(EngFunc_SetModel, g_MyAttachment[id][channel], Sprite)
	
	// Set Rendering
	set_pev(g_MyAttachment[id][channel], pev_renderfx, kRenderFxNone)
	set_pev(g_MyAttachment[id][channel], pev_rendermode, kRenderTransAdd)
	set_pev(g_MyAttachment[id][channel], pev_renderamt, 200.0)
	
	// Set other
	set_pev(g_MyAttachment[id][channel], pev_user, id)
	set_pev(g_MyAttachment[id][channel], pev_scale, Scale)
	set_pev(g_MyAttachment[id][channel], pev_livetime, get_gametime() + Time)
	set_pev(g_MyAttachment[id][channel], pev_totalframe, float(TotalFrame))
	
	// Set Origin
	static Float:Origin[3]; pev(id, pev_origin, Origin)
	if(!(pev(id, pev_flags) & FL_DUCKING)) Origin[2] += 25.0
	else Origin[2] += 20.0
	
	engfunc(EngFunc_SetOrigin, g_MyAttachment[id][channel], Origin)
	
	// Allow animation of sprite ?
	if(TotalFrame && FrameRate > 0.0)
	{
		set_pev(g_MyAttachment[id][channel], pev_animtime, get_gametime())
		set_pev(g_MyAttachment[id][channel], pev_framerate, FrameRate + 9.0)
		
		set_pev(g_MyAttachment[id][channel], pev_spawnflags, SF_SPRITE_STARTON)
		dllfunc(DLLFunc_Spawn, g_MyAttachment[id][channel])
	}	
	
	// Force Think
	set_pev(g_MyAttachment[id][channel], pev_nextthink, get_gametime() + 0.05)
}

public fw_Think(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Owner; Owner = pev(Ent, pev_user)
	if(!is_user_alive(Owner))
	{
		engfunc(EngFunc_RemoveEntity, Ent)
		return
	}
	if(get_gametime() >= pev(Ent, pev_livetime))
	{
		if(pev(Ent, pev_renderamt) > 0.0)
		{
			static Float:AMT; pev(Ent, pev_renderamt, AMT)
			static Float:RealAMT; 
			
			AMT -= 10.0
			RealAMT = float(max(floatround(AMT), 0))
			
			set_pev(Ent, pev_renderamt, RealAMT)
		} else {
			engfunc(EngFunc_RemoveEntity, Ent)
			return
		}
	}
	if(pev(Ent, pev_frame) >= pev(Ent, pev_totalframe)) 
		set_pev(Ent, pev_frame, 0.0)
	
	// Set Attachment
	static Float:Origin[3]; pev(Owner, pev_origin, Origin)
	
	if(!(pev(Owner, pev_flags) & FL_DUCKING)) Origin[2] += 36.0
	else Origin[2] += 26.0
	
	engfunc(EngFunc_SetOrigin, Ent, Origin)
	
	// Force Think
	set_pev(Ent, pev_nextthink, get_gametime() + 0.05)
}

public plugin_init_TN7() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0")
	
	register_forward(FM_UpdateClientData,"fw_UpdateClientData_Post_TN7", 1)	
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent_TN7")	
	register_forward(FM_SetModel, "fw_SetModel_TN7")		
	register_forward(FM_CmdStart, "fw_CmdStart_TN7")
	register_forward(FM_EmitSound, "fw_EmitSound_TN7")
	register_forward(FM_TraceLine, "fw_TraceLine_TN7")
	register_forward(FM_TraceHull, "fw_TraceHull_TN7")	
	
	register_touch(SCYTHE_CLASSNAME_TN7, "*", "fw_Scythe_Touch_TN7")
	register_think(SCYTHE_CLASSNAME_TN7, "fw_Scythe_Think_TN7")
	
	RegisterHam(Ham_Item_Deploy, weapon_thanatos7, "fw_Item_Deploy_Post_TN7", 1)	
	RegisterHam(Ham_Item_AddToPlayer, weapon_thanatos7, "fw_Item_AddToPlayer_Post_TN7", 1)
	RegisterHam(Ham_Item_PostFrame, weapon_thanatos7, "fw_Item_PostFrame_TN7")	
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos7, "fw_Weapon_Reload_TN7")
	RegisterHam(Ham_Weapon_Reload, weapon_thanatos7, "fw_Weapon_Reload_Post_TN7", 1)	
	RegisterHam(Ham_Weapon_WeaponIdle, weapon_thanatos7, "fw_Weapon_WeaponIdle_Post_TN7", 1)
	
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack_World_TN7")
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack_Player_TN7")	
	
	g_MsgCurWeapon = get_user_msgid("CurWeapon")
	g_MsgStatusIcon = get_user_msgid("StatusIcon")
	
	
}

public plugin_precache_TN7()
{
	precache_model(V_MODEL_TN7)
	precache_model(P_MODEL_TN7)
	precache_model(W_MODEL_TN7)
	precache_model(S_MODEL_TN7)
	
	for(new i = 0; i < sizeof(WeaponSounds_TN7); i++)
		precache_sound(WeaponSounds_TN7[i])
	
	g_ShellId = precache_model("models/rshell.mdl")
	g_SmokePuff_SprId = precache_model("sprites/wall_puff1.spr")

	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post_TN7", 1)
}

public fw_PrecacheEvent_Post_TN7(type, const name[])
{
	if(equal("events/m249.sc", name)) g_Event_Thanatos7 = get_orig_retval()		
}


public Get_Thanatos7(id)
{
	drop_weapons(id, 1)
	
	Set_BitVar(g_Had_Thanatos7, id)
	UnSet_BitVar(g_Had_Scythe, id)
	give_item(id, weapon_thanatos7)
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_THANATOS7)
	if(pev_valid(Ent)) cs_set_weapon_ammo(Ent, CLIP_TN7)
	
	Update_Ammo_TN7(id, CLIP_TN7)
	Update_SpecialAmmo(id, 1, 0)
	
	cs_set_user_bpammo(id, CSW_THANATOS7, 250)
}

public Remove_Thanatos7(id)
{
	if(is_user_connected(id)) 
		Update_SpecialAmmo(id, 1, 0)
	
	UnSet_BitVar(g_Had_Thanatos7, id)
}

public Update_Ammo_TN7(id, Ammo)
{
	if(!is_user_alive(id))
		return
	
	engfunc(EngFunc_MessageBegin, MSG_ONE_UNRELIABLE, g_MsgCurWeapon, {0, 0, 0}, id)
	write_byte(1)
	write_byte(CSW_THANATOS7)
	write_byte(Ammo)
	message_end()
}

public fw_UpdateClientData_Post_TN7(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(get_user_weapon(id) == CSW_THANATOS7 && Get_BitVar(g_Had_Thanatos7, id))
		set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_PlaybackEvent_TN7(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if (!is_user_connected(invoker))
		return FMRES_IGNORED	
	if(get_user_weapon(invoker) != CSW_THANATOS7 || !Get_BitVar(g_Had_Thanatos7, invoker))
		return FMRES_IGNORED
	if(eventid != g_Event_Thanatos7)
		return FMRES_IGNORED
	
	engfunc(EngFunc_PlaybackEvent, flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	
	if(Get_BitVar(g_Had_Scythe, invoker)) Set_WeaponAnim(invoker, ANIM_SHOOT_B1_TN7)
	else Set_WeaponAnim(invoker, ANIM_SHOOT_A1_TN7)
	emit_sound(invoker, CHAN_WEAPON, WeaponSounds_TN7[0], 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	Eject_Shell(invoker, g_ShellId, 0.01)

	return FMRES_IGNORED
}
public fw_SetModel_TN7(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static Classname[32]
	pev(entity, pev_classname, Classname, sizeof(Classname))
	
	if(!equal(Classname, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner
	iOwner = pev(entity, pev_owner)
	
	if(equal(model, THANATOS7_OLDMODEL))
	{
		static weapon; weapon = find_ent_by_owner(-1, weapon_thanatos7, entity)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED;
		
		if(Get_BitVar(g_Had_Thanatos7, iOwner))
		{
			set_pev(weapon, pev_impulse, 1212015)
			set_pev(weapon, pev_iuser4, Get_BitVar(g_Had_Scythe, iOwner) ? 1 : 0)
			
			engfunc(EngFunc_SetModel, entity, W_MODEL_TN7)
			
			Remove_Thanatos7(iOwner)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED;
}

public fw_CmdStart_TN7(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_THANATOS7 || !Get_BitVar(g_Had_Thanatos7, id))
		return FMRES_IGNORED
		
	static PressedButton
	PressedButton = get_uc(uc_handle, UC_Buttons)
	
	if(PressedButton & IN_ATTACK2)
	{
		if(get_pdata_float(id, 83, 5) > 0.0)
			return FMRES_IGNORED
		

		if(!Get_BitVar(g_Had_Scythe, id))
		{
			Set_WeaponAnim(id, ANIM_SPECIAL_RELOAD_TN7)
			set_pdata_float(id, 83, 3.0, 5)
			
			remove_task(id+TASK_RELOAD_TN7)
			set_task(2.75, "Complete_Reload_TN7", id+TASK_RELOAD_TN7)
		} else {
			Shoot_Scythe_TN7(id)
		}
	}
		
	return FMRES_HANDLED
}

public Shoot_Scythe_TN7(id)
{
	emit_sound(id, CHAN_WEAPON, WeaponSounds_TN7[1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	
	Create_FakeAttackAnim(id)
	Set_WeaponAnim(id, ANIM_SPECIAL_SHOOT_TN7)
	
	Update_SpecialAmmo(id, 1, 0)
	set_pdata_float(id, 83, 4.0, 5)
	
	UnSet_BitVar(g_Had_Scythe, id)
	
	// Fake Punch
	static Float:Origin[3]
	Origin[0] = random_float(-2.5, -5.0)
	
	set_pev(id, pev_punchangle, Origin)
	
	// Scythe
	Create_Scythe_TN7(id)
}

public Complete_Reload_TN7(id)
{
	id -= TASK_RELOAD_TN7
	
	if(!is_user_alive(id))
		return
	if(get_user_weapon(id) != CSW_THANATOS7 || !Get_BitVar(g_Had_Thanatos7, id))
		return
	if(Get_BitVar(g_Had_Scythe, id))
		return
		
	Set_BitVar(g_Had_Scythe, id)
	Set_WeaponAnim(id, ANIM_IDLE_B2_TN7)
	
	Update_SpecialAmmo(id, 1, 1)
}

public fw_EmitSound_TN7(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if(!is_user_connected(id))
		return FMRES_IGNORED
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
		
	if(sample[8] == 'k' && sample[9] == 'n' && sample[10] == 'i')
	{
		if(sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a')
			return FMRES_SUPERCEDE
		if (sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't')
		{
			if (sample[17] == 'w')  return FMRES_SUPERCEDE
			else  return FMRES_SUPERCEDE
		}
		if (sample[14] == 's' && sample[15] == 't' && sample[16] == 'a')
			return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED
}

public fw_TraceLine_TN7(Float:vector_start[3], Float:vector_end[3], ignored_monster, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)

	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceLine, vecStart, vecEnd, ignored_monster, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_TraceHull_TN7(Float:vector_start[3], Float:vector_end[3], ignored_monster, hull, id, handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
	if(!Get_BitVar(g_InTempingAttack, id))
		return FMRES_IGNORED
	
	static Float:vecStart[3], Float:vecEnd[3], Float:v_angle[3], Float:v_forward[3], Float:view_ofs[3], Float:fOrigin[3]
	
	pev(id, pev_origin, fOrigin)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(fOrigin, view_ofs, vecStart)
	pev(id, pev_v_angle, v_angle)
	
	engfunc(EngFunc_MakeVectors, v_angle)
	get_global_vector(GL_v_forward, v_forward)
	
	xs_vec_mul_scalar(v_forward, 0.0, v_forward)
	xs_vec_add(vecStart, v_forward, vecEnd)
	
	engfunc(EngFunc_TraceHull, vecStart, vecEnd, ignored_monster, hull, id, handle)
	
	return FMRES_SUPERCEDE
}

public fw_Item_Deploy_Post_TN7(Ent)
{
	if(pev_valid(Ent) != 2)
		return
	static Id; Id = get_pdata_cbase(Ent, 41, 4)
	if(get_pdata_cbase(Id, 373) != Ent)
		return
	if(!Get_BitVar(g_Had_Thanatos7, Id))
		return
	
	set_pev(Id, pev_viewmodel2, V_MODEL_TN7)
	set_pev(Id, pev_weaponmodel2, P_MODEL_TN7)
	
	if(Get_BitVar(g_Had_Scythe, Id)) Set_WeaponAnim(Id, ANIM_DRAW_B_TN7)
	else Set_WeaponAnim(Id, ANIM_DRAW_A_TN7)
}

public fw_Item_AddToPlayer_Post_TN7(Ent, id)
{
	if(!pev_valid(Ent))
		return HAM_IGNORED
		
	if(pev(Ent, pev_impulse) == 1212015)
	{
		Set_BitVar(g_Had_Thanatos7, id)
		set_pev(Ent, pev_impulse, 0)
		
		if(pev(Ent, pev_iuser4)) Update_SpecialAmmo(id, 1, 1)
	}

	return HAM_HANDLED	
}

public fw_Weapon_WeaponIdle_Post_TN7( iEnt )
{
	if(pev_valid(iEnt) != 2)
		return
	static Id; Id = get_pdata_cbase(iEnt, 41, 4)
	if(get_pdata_cbase(Id, 373) != iEnt)
		return
	if(!Get_BitVar(g_Had_Thanatos7, Id))
		return
		
	if(get_pdata_float(iEnt, 48, 4) <= 0.25)
	{
		if(Get_BitVar(g_Had_Scythe, Id)) Set_WeaponAnim(Id, ANIM_IDLE_B_TN7)
		else Set_WeaponAnim(Id, ANIM_IDLE_A_TN7)
		
		set_pdata_float(iEnt, 48, 20.0, 4)
	}	
}

public fw_TraceAttack_World_TN7(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS7 || !Get_BitVar(g_Had_Thanatos7, Attacker))
		return HAM_IGNORED
		
	static Float:flEnd[3], Float:vecPlane[3]
		
	get_tr2(Ptr, TR_vecEndPos, flEnd)
	get_tr2(Ptr, TR_vecPlaneNormal, vecPlane)		
			
	Make_BulletHole(Attacker, flEnd, Damage)
	Make_BulletSmoke(Attacker, Ptr)

	SetHamParamFloat(3, float(DAMAGE_A_TN7))
	
	return HAM_IGNORED
}

public fw_TraceAttack_Player_TN7(Victim, Attacker, Float:Damage, Float:Direction[3], Ptr, DamageBits)
{
	if(!is_user_connected(Attacker))
		return HAM_IGNORED	
	if(get_user_weapon(Attacker) != CSW_THANATOS7 || !Get_BitVar(g_Had_Thanatos7, Attacker))
		return HAM_IGNORED
		
	SetHamParamFloat(3, float(DAMAGE_A_TN7))
	
	return HAM_IGNORED
}

public fw_Item_PostFrame_TN7(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos7, id))
		return HAM_IGNORED	
	
	static Float:flNextAttack; flNextAttack = get_pdata_float(id, 83, 5)
	static bpammo; bpammo = cs_get_user_bpammo(id, CSW_THANATOS7)
	
	static iClip; iClip = get_pdata_int(ent, 51, 4)
	static fInReload; fInReload = get_pdata_int(ent, 54, 4)
	
	if(fInReload && flNextAttack <= 0.0)
	{
		static temp1
		temp1 = min(CLIP_TN7 - iClip, bpammo)

		set_pdata_int(ent, 51, iClip + temp1, 4)
		cs_set_user_bpammo(id, CSW_THANATOS7, bpammo - temp1)		
		
		set_pdata_int(ent, 54, 0, 4)
		
		fInReload = 0
	}		
	
	return HAM_IGNORED
}

public fw_Weapon_Reload_TN7(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos7, id))
		return HAM_IGNORED	

	g_Thanatos7_Clip[id] = -1
		
	static BPAmmo; BPAmmo = cs_get_user_bpammo(id, CSW_THANATOS7)
	static iClip; iClip = get_pdata_int(ent, 51, 4)
		
	if(BPAmmo <= 0)
		return HAM_SUPERCEDE
	if(iClip >= CLIP_TN7)
		return HAM_SUPERCEDE		
			
	g_Thanatos7_Clip[id] = iClip	
	
	return HAM_HANDLED
}

public fw_Weapon_Reload_Post_TN7(ent)
{
	static id; id = pev(ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!Get_BitVar(g_Had_Thanatos7, id))
		return HAM_IGNORED	
		
	if((get_pdata_int(ent, 54, 4) == 1))
	{ // Reload
		if(g_Thanatos7_Clip[id] == -1)
			return HAM_IGNORED
		
		set_pdata_int(ent, 51, g_Thanatos7_Clip[id], 4)
		set_pdata_float(id, 83, 3.0, 5)
		
		if(Get_BitVar(g_Had_Scythe, id)) Set_WeaponAnim(id, ANIM_RELOAD_B_TN7)
		else Set_WeaponAnim(id, ANIM_RELOAD_A_TN7)
	}
	
	return HAM_HANDLED
}

public Create_Scythe_TN7(id)
{
	new iEnt = create_entity("info_target")
	
	static Float:Origin[3], Float:Angles[3], Float:TargetOrigin[3], Float:Velocity[3]
	
	get_weapon_attachment(id, Origin, 40.0)
	get_position(id, 1024.0, 0.0, 0.0, TargetOrigin)
	
	pev(id, pev_v_angle, Angles)
	Angles[0] *= -1.0

	// set info for ent
	set_pev(iEnt, pev_movetype, MOVETYPE_FLY)
	entity_set_string(iEnt, EV_SZ_classname, SCYTHE_CLASSNAME_TN7)
	engfunc(EngFunc_SetModel, iEnt, S_MODEL_TN7)
	
	set_pev(iEnt, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(iEnt, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(iEnt, pev_origin, Origin)
	set_pev(iEnt, pev_gravity, 0.01)
	set_pev(iEnt, pev_angles, Angles)
	set_pev(iEnt, pev_solid, SOLID_TRIGGER)
	set_pev(iEnt, pev_owner, id)	
	set_pev(iEnt, pev_iuser1, get_user_team(id))
	set_pev(iEnt, pev_iuser2, 0)
	set_pev(iEnt, pev_fuser1, get_gametime() + SCYTHE_LIFETIME_TN7)

	get_speed_vector(Origin, TargetOrigin, 1000.0, Velocity)
	set_pev(iEnt, pev_velocity, Velocity)	
	
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
	
	// Animation
	set_pev(iEnt, pev_animtime, get_gametime())
	set_pev(iEnt, pev_framerate, 2.0)
	set_pev(iEnt, pev_sequence, 0)
}

public fw_Scythe_Touch_TN7(Ent, id)
{
	if(!pev_valid(Ent))
		return
		
	if(!pev(Ent, pev_iuser2))
	{
		set_pev(Ent, pev_mins, Float:{-40.0, -40.0, -40.0})
		set_pev(Ent, pev_maxs, Float:{40.0, 40.0, 40.0})
		
		set_pev(Ent, pev_iuser2, 1)
		
		set_pev(Ent, pev_movetype, MOVETYPE_NONE)
		set_pev(Ent, pev_velocity, {0.0, 0.0, 0.0})
	} else {
		static Time2; pev(Ent, pev_fuser2, Time2)
		
		if(get_gametime() - 0.5 > Time2)
		{
			set_pev(Ent, pev_fuser2, Time2)
			
			static Owner; Owner = pev(Ent, pev_owner)
			if(!is_user_connected(Owner) || (get_user_team(id) == pev(Ent, pev_iuser1)))
				return
				
			ExecuteHamB(Ham_TakeDamage, id, 0, Owner, float(DAMAGE_B_TN7), DMG_BLAST)
		}	
	}
}

public fw_Scythe_Think_TN7(Ent)
{
	if(!pev_valid(Ent))
		return
		
	static Float:Time; pev(Ent, pev_fuser1, Time)
	
	if(Time <= get_gametime())
	{
		set_pev(Ent, pev_flags, FL_KILLME)
		set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
		
		return
	}
	
	set_pev(Ent, pev_nextthink, get_gametime() + 0.1)
}
stock Set_PlayerNextAttack(id, Float:nexttime)
{
	set_pdata_float(id, 83, nexttime, 5)
}
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


do_attack(Attacker, Victim, Inflictor, Float:fDamage)
{
	fake_player_trace_attack(Attacker, Victim, fDamage)
	fake_take_damage(Attacker, Victim, fDamage, Inflictor)
}

fake_player_trace_attack(iAttacker, iVictim, &Float:fDamage)
{
	// get fDirection
	new Float:fAngles[3], Float:fDirection[3]
	pev(iAttacker, pev_angles, fAngles)
	angle_vector(fAngles, ANGLEVECTOR_FORWARD, fDirection)
	
	// get fStart
	new Float:fStart[3], Float:fViewOfs[3]
	pev(iAttacker, pev_origin, fStart)
	pev(iAttacker, pev_view_ofs, fViewOfs)
	xs_vec_add(fViewOfs, fStart, fStart)
	
	// get aimOrigin
	new iAimOrigin[3], Float:fAimOrigin[3]
	get_user_origin(iAttacker, iAimOrigin, 3)
	IVecFVec(iAimOrigin, fAimOrigin)
	
	// TraceLine from fStart to AimOrigin
	new ptr = create_tr2() 
	engfunc(EngFunc_TraceLine, fStart, fAimOrigin, DONT_IGNORE_MONSTERS, iAttacker, ptr)
	new pHit = get_tr2(ptr, TR_pHit)
	new iHitgroup = get_tr2(ptr, TR_iHitgroup)
	new Float:fEndPos[3]
	get_tr2(ptr, TR_vecEndPos, fEndPos)

	// get target & body at aiming
	new iTarget, iBody
	get_user_aiming(iAttacker, iTarget, iBody)
	
	// if aiming find target is iVictim then update iHitgroup
	if (iTarget == iVictim)
	{
		iHitgroup = iBody
	}
	
	// if ptr find target not is iVictim
	else if (pHit != iVictim)
	{
		// get AimOrigin in iVictim
		new Float:fVicOrigin[3], Float:fVicViewOfs[3], Float:fAimInVictim[3]
		pev(iVictim, pev_origin, fVicOrigin)
		pev(iVictim, pev_view_ofs, fVicViewOfs) 
		xs_vec_add(fVicViewOfs, fVicOrigin, fAimInVictim)
		fAimInVictim[2] = fStart[2]
		fAimInVictim[2] += get_distance_f(fStart, fAimInVictim) * floattan( fAngles[0] * 2.0, degrees )
		
		// check aim in size of iVictim
		new iAngleToVictim = get_angle_to_target(iAttacker, fVicOrigin)
		iAngleToVictim = abs(iAngleToVictim)
		new Float:fDis = 2.0 * get_distance_f(fStart, fAimInVictim) * floatsin( float(iAngleToVictim) * 0.5, degrees )
		new Float:fVicSize[3]
		pev(iVictim, pev_size , fVicSize)
		if ( fDis <= fVicSize[0] * 0.5 )
		{
			// TraceLine from fStart to aimOrigin in iVictim
			new ptr2 = create_tr2() 
			engfunc(EngFunc_TraceLine, fStart, fAimInVictim, DONT_IGNORE_MONSTERS, iAttacker, ptr2)
			new pHit2 = get_tr2(ptr2, TR_pHit)
			new iHitgroup2 = get_tr2(ptr2, TR_iHitgroup)
			
			// if ptr2 find target is iVictim
			if ( pHit2 == iVictim && (iHitgroup2 != HIT_HEAD || fDis <= fVicSize[0] * 0.25) )
			{
				pHit = iVictim
				iHitgroup = iHitgroup2
				get_tr2(ptr2, TR_vecEndPos, fEndPos)
			}
			
			free_tr2(ptr2)
		}
		
		// if pHit still not is iVictim then set default HitGroup
		if (pHit != iVictim)
		{
			// set default iHitgroup
			iHitgroup = HIT_GENERIC
			
			new ptr3 = create_tr2() 
			engfunc(EngFunc_TraceLine, fStart, fVicOrigin, DONT_IGNORE_MONSTERS, iAttacker, ptr3)
			get_tr2(ptr3, TR_vecEndPos, fEndPos)
			
			// free ptr3
			free_tr2(ptr3)
		}
	}
	
	// set new Hit & Hitgroup & EndPos
	set_tr2(ptr, TR_pHit, iVictim)
	set_tr2(ptr, TR_iHitgroup, iHitgroup)
	set_tr2(ptr, TR_vecEndPos, fEndPos)
	
	// hitgroup multi fDamage
	new Float:fMultifDamage 
	switch(iHitgroup)
	{
		case HIT_HEAD: fMultifDamage  = 4.0
		case HIT_STOMACH: fMultifDamage  = 1.25
		case HIT_LEFTLEG: fMultifDamage  = 0.75
		case HIT_RIGHTLEG: fMultifDamage  = 0.75
		default: fMultifDamage  = 1.0
	}
	
	fDamage *= fMultifDamage
	
	// ExecuteHam
	fake_trake_attack(iAttacker, iVictim, fDamage, fDirection, ptr)
	
	// free ptr
	free_tr2(ptr)
}

stock fake_trake_attack(iAttacker, iVictim, Float:fDamage, Float:fDirection[3], iTraceHandle, iDamageBit = (DMG_NEVERGIB | DMG_BULLET))
{
	ExecuteHamB(Ham_TraceAttack, iVictim, iAttacker, fDamage, fDirection, iTraceHandle, iDamageBit)
}

stock fake_take_damage(iAttacker, iVictim, Float:fDamage, iInflictor = 0, iDamageBit = (DMG_NEVERGIB | DMG_BULLET))
{
	iInflictor = (!iInflictor) ? iAttacker : iInflictor
	ExecuteHamB(Ham_TakeDamage, iVictim, iInflictor, iAttacker, fDamage, iDamageBit)
}

stock get_angle_to_target(id, const Float:fTarget[3], Float:TargetSize = 0.0)
{
	new Float:fOrigin[3], iAimOrigin[3], Float:fAimOrigin[3], Float:fV1[3]
	pev(id, pev_origin, fOrigin)
	get_user_origin(id, iAimOrigin, 3) // end position from eyes
	IVecFVec(iAimOrigin, fAimOrigin)
	xs_vec_sub(fAimOrigin, fOrigin, fV1)
	
	new Float:fV2[3]
	xs_vec_sub(fTarget, fOrigin, fV2)
	
	new iResult = get_angle_between_vectors(fV1, fV2)
	
	if (TargetSize > 0.0)
	{
		new Float:fTan = TargetSize / get_distance_f(fOrigin, fTarget)
		new fAngleToTargetSize = floatround( floatatan(fTan, degrees) )
		iResult -= (iResult > 0) ? fAngleToTargetSize : -fAngleToTargetSize
	}
	
	return iResult
}

stock get_angle_between_vectors(const Float:fV1[3], const Float:fV2[3])
{
	new Float:fA1[3], Float:fA2[3]
	engfunc(EngFunc_VecToAngles, fV1, fA1)
	engfunc(EngFunc_VecToAngles, fV2, fA2)
	
	new iResult = floatround(fA1[1] - fA2[1])
	iResult = iResult % 360
	iResult = (iResult > 180) ? (iResult - 360) : iResult
	
	return iResult
}
// Drop primary/secondary weapons
stock drop_weapons(id, dropwhat)
{
	// Get user weapons
	static weapons[32], num, i, weaponid
	num = 0 // reset passed weapons count (bugfix)
	get_user_weapons(id, weapons, num)
	
	// Loop through them and drop primaries or secondaries
	for (i = 0; i < num; i++)
	{
		// Prevent re-indexing the array
		weaponid = weapons[i]
		
		if ((dropwhat == 1 && ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM)) || (dropwhat == 2 && ((1<<weaponid) & SECONDARY_WEAPONS_BIT_SUM)))
		{
			// Get weapon entity
			static wname[32]; get_weaponname(weaponid, wname, charsmax(wname))
			engclient_cmd(id, "drop", wname)
		}
	}
}

stock Set_Player_NextAttack(id, Float:NextTime) set_pdata_float(id, 83, NextTime, 5)

stock Set_WeaponAnim(id, anim)
{
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

stock Eject_Shell(id, Shell_ModelIndex, Float:Time) // By Dias
{
	static Ent; Ent = get_pdata_cbase(id, 373, 5)
	if(!pev_valid(Ent))
		return

        set_pdata_int(Ent, 57, Shell_ModelIndex, 4)
        set_pdata_float(id, 111, get_gametime() + Time)
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
public Create_FakeAttackAnim(id)
{
	Set_BitVar(g_InTempingAttack, id)
	
	static Ent; Ent = fm_get_user_weapon_entity(id, CSW_KNIFE)
	if(pev_valid(Ent)) ExecuteHamB(Ham_Weapon_PrimaryAttack, Ent)
	
	UnSet_BitVar(g_InTempingAttack, id)
}
stock Update_SpecialAmmo(id, Ammo, On)
{
	static AmmoSprites[33], Color[3]
	format(AmmoSprites, sizeof(AmmoSprites), "number_%d", Ammo)

	switch(Ammo)
	{
		case 1..3: { Color[0] = 0; Color[1] = 200; Color[2] = 0; }
		case 4..5: { Color[0] = 200; Color[1] = 200; Color[2] = 0; }
		case 6..10: { Color[0] = 200; Color[1] = 0; Color[2] = 0; }
	}
	
	message_begin(MSG_ONE_UNRELIABLE, g_MsgStatusIcon, {0,0,0}, id)
	write_byte(On)
	write_string(AmmoSprites)
	write_byte(Color[0]) // red
	write_byte(Color[1]) // green
	write_byte(Color[2]) // blue
	message_end()
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
