
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <fun>
#include <hamsandwich>
#include <amxmisc>
#include <nst_wpn>

#pragma compress 1
#define PLUGIN "New Plug-In"
#define VERSION "1.0"
#define AUTHOR "author"
#define BLOCK_CMD 25
#define MSG_CONFIG_NOT_FOUND "Configuration file not found! [%s]"
new g_CmdBlock[ BLOCK_CMD ][  ] = {"uspx","glockx","deagle","p228","elites","fn57","m3","xm1014","mp5","tmp","p90","mac10","ump45","ak47","galil","famas","sg552","m4a1","aug","scout","awp","g3sg1","sg550","m249","shield"};
new g_CmdBlock2[ BLOCK_CMD ][  ] = {"km45","9x19mm","nighthawk","228compact","elites","fiveseven","12gauge","autoshotgun","smg","mp","c90","mac10","ump45","cv47","defender","clarion","krieg552","m4a1","bullpup","scout","magnum","d3au1","krieg550","m249","shield"};
#define m_pPlayer	41
#define MAX_FILENAME 64
///////////////////////////////////////
new COUNT_WPN
#define WPN_SLOT	4

#define MAX_WPN		1024
new g_mywpn_cachenum[WPN_SLOT+1] //store mywpn cache numbers
new g_mywpn_r_cache[MAX_WPN_RIFLES][32]
new g_mywpn_p_cache[MAX_WPN_PISTOLS][32]
new g_mywpn_k_cache[MAX_WPN_KNIFES][32]
new g_mywpn_h_cache[MAX_WPN_HES][32]
new g_hamczbots
/////////////////////////////////////
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_forward( FM_SetModel, "Fwd_SetModel" );
	RegisterHam( Ham_Item_Deploy, "weapon_ak47", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_aug", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_awp", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_deagle", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_elite", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_famas", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_fiveseven", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_g3sg1", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_galil", "Fwd_ItemDeploy_Post", 1 );
//	RegisterHam( Ham_Item_Deploy, "weapon_glock18", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_m249", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_m3", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_m4a1", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_mac10", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_mp5navy", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_p228", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_p90", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_scout", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_sg550", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_sg552", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_tmp", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_ump45", "Fwd_ItemDeploy_Post", 1 );
//	RegisterHam( Ham_Item_Deploy, "weapon_usp", "Fwd_ItemDeploy_Post", 1 );
	RegisterHam( Ham_Item_Deploy, "weapon_xm1014", "Fwd_ItemDeploy_Post", 1 );
	register_forward( FM_SetModel, "Fwd_SetModel" );
	RegisterHam(Ham_Spawn, 			"player", 		"fw_PlayerSpawn_Post", 1)
	// Add your code here...
}
new Trie:g_tBlockedFiles
Array:getFileUnprecache()
{
	// Build customization file path
	static path[ 64 ];
	get_configsdir(path, charsmax(path))
	format(path, charsmax(path), "%s/%s", path, "csx_blockres.ini")
	if( !file_exists( path ) )
	{
		static error[ 100 ];
		formatex( error, charsmax( error ), MSG_CONFIG_NOT_FOUND, path )
		set_fail_state( error )
	}
	
	new szConfigFile = fopen( path, "r" );
	new Array:array = ArrayCreate( MAX_FILENAME );
	new szFile[ MAX_FILENAME+1 ];
	
	while( fgets( szConfigFile, szFile, charsmax( szFile ) ) )
	{
		// Remove spaces
		trim( szFile )
		
		// String will be truncated if it is longer than MAX_FILENAME
		ArrayPushString( array, szFile )
	}
	
	fclose( szConfigFile )
	return array;
}
public plugin_precache()
{	
	
	Read_MyWeapon()
	g_tBlockedFiles = TrieCreate();
	fn_BlockFiles( getFileUnprecache() );
	register_forward( FM_PrecacheModel, "Fwd_Precache" );
	register_forward( FM_PrecacheSound, "Fwd_Precache" );
	
}

public Read_MyWeapon()
{
	new file_url[64]
	get_configsdir(file_url, charsmax(file_url))
	format(file_url, charsmax(file_url), "%s/%s", file_url, NST_MYWPN_SETTING_FILE)
	
	
	new linedata[1024], key[64], value[960], iLine//, lineset[1024]
	new file = fopen(file_url, "rt")
	
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata))
		replace(linedata, charsmax(linedata), "^n", "")
		if (!linedata[0] || linedata[0] == ';')
		{
			iLine++
			continue;
		}
		strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
		trim(key)
		trim(value)
		
				
		//Rifles
		if(equali(key, "RIFLES"))
		{
			strtolower(value)
			new e
			while (e<MAX_MYWPN_RIFLES && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_r_cache[e], 31, "%s", key)
				//("LOAD PRIMARY:%s",key)
				e++
				g_mywpn_cachenum[NST_WPN_RIFLES] ++
			}
		}
		//Pistols
		else if(equali(key, "PISTOLS"))
		{
			strtolower(value)
			new e
			while (e<MAX_MYWPN_PISTOLS && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_p_cache[e], 31, "%s", key)
				//("LOAD PISTOLS:%s",key)
				e++
				g_mywpn_cachenum[NST_WPN_PISTOLS] ++
			}
		}
		//Knives
		else if(equali(key, "KNIFE"))
		{
			
			strtolower(value)
			new e
			while (e<MAX_MYWPN_KNIFES && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_k_cache[e], 31, "%s", key)
				//("LOAD MELEE:%s",key)
				e++
				g_mywpn_cachenum[NST_WPN_KNIFE] ++
			}
		}
		//Hes
		else if(equali(key, "HEGRENADE"))
		{
			
			strtolower(value)
			new e
			while (e<MAX_MYWPN_HES && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_h_cache[e], 31, "%s", key)
				
				e++
				g_mywpn_cachenum[NST_WPN_HE] ++
			}
		}
		iLine++
	}
	
}


public Fwd_ItemDeploy_Post( iEnt )
{
	new id = get_pdata_cbase( iEnt, m_pPlayer );
	
	// Prevent bug
	set_pev( id, pev_weaponmodel2, "" );
	set_pev( id, pev_viewmodel2, "" );
}
public client_command( id )
{
	// Block buy default wpn
	new arg[ 13 ];
	if( read_argv( 0, arg, 12 ) > 11 )
	{
		return PLUGIN_CONTINUE;
	}
	
	new a = 0 
	
	do
	{
		if( equali( g_CmdBlock[ a ], arg ) || equali( g_CmdBlock2[ a ], arg ) )
		{
			return PLUGIN_HANDLED;
		}
	}
	
	while ( ++a < BLOCK_CMD )
	{
		return PLUGIN_CONTINUE;
	}
}
public Fwd_Precache( sData[  ] )
{
	// Block Precache
	if( TrieKeyExists( g_tBlockedFiles, sData ) )
	{
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}
public Fwd_SetModel( iEnt, const sModel[  ] )
{
	if( !pev_valid( iEnt ) )
	{
		return FMRES_IGNORED;
	}
	
	// Remove set w_model of blocked entity
	if( TrieKeyExists( g_tBlockedFiles, sModel ) )
	{
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}
fn_BlockFiles( Array:array )
{
	static szFile[ MAX_FILENAME ];
	for( new i = 0; i < ArraySize( array ); i++ )
	{
		// Get string from an array
		ArrayGetString( array, i, szFile, charsmax( szFile ) );
		TrieSetCell( g_tBlockedFiles, szFile, true );
		//("Blocked Files %s", szFile );
	}
}

public client_putinserver(id) {
	if (is_user_bot(id) && !g_hamczbots && get_cvar_pointer("bot_quota"))
	{
		
		
		//register zbot
		set_task(0.1, "register_ham_czbots", id)
	}
	
}
public register_ham_czbots(id) {
	if (g_hamczbots || !is_user_connected(id)) return
	
	RegisterHamFromEntity(Ham_Spawn, id, "fw_PlayerSpawn_Post", 1)
	// HAM FORWARD FOR BOTS
	g_hamczbots = true
	
	if (is_user_alive(id)) fw_PlayerSpawn_Post(id)
}

public fw_PlayerSpawn_Post(id) {
	if (!is_user_alive(id))
		return;
	if (is_user_bot(id))
	{
		strip_user_weapons(id)
		nst_wpn_give_weapon(id,g_mywpn_r_cache[random_num(1,g_mywpn_cachenum[NST_WPN_RIFLES])])
		nst_wpn_give_weapon(id,g_mywpn_p_cache[random_num(1,g_mywpn_cachenum[NST_WPN_PISTOLS])])
		nst_wpn_give_weapon(id,g_mywpn_k_cache[random_num(1,g_mywpn_cachenum[NST_WPN_KNIFE])])
		nst_wpn_give_weapon(id,g_mywpn_h_cache[random_num(1,g_mywpn_cachenum[NST_WPN_HE])])
	}
	
}