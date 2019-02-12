/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <hamsandwich>
#define PLUGIN "New Plug-In"
#define VERSION "1.0"
#define AUTHOR "TITLE"
new g_hamczbots, cvar_botquota
new iTitleCached[4], g_iTitle[ 33 ]
new iTitleFile[4][] =
{
	"EDo/Sprite/Tit_Assault.spr",
	"EDo/Sprite/Tit_SMG.spr",
	"EDo/Sprite/Tit_Sniper.spr",
	"EDo/Sprite/Tit_SG.spr"
};
enum
{
	ASSAULT = 0,
	SMG,
	SNIPER,
	SG
};
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	cvar_botquota = get_cvar_pointer("bot_quota")
	RegisterHam( Ham_Spawn, "player", "Fwd_PlayerSpawn_Post", 1 )
}

public plugin_precache()
{
	// Weapon Title
	iTitleCached[ 0 ] = precache_model( iTitleFile[ 0 ] );
	iTitleCached[ 1 ] = precache_model( iTitleFile[ 1 ] );
	iTitleCached[ 2 ] = precache_model( iTitleFile[ 2 ] );
	iTitleCached[ 3 ] = precache_model( iTitleFile[ 3 ] );
}
public client_putinserver( id )
{
	if (is_user_bot(id) && !g_hamczbots && cvar_botquota)
	{
		set_task(0.1, "register_ham_czbots", id)
	}
	g_iTitle[ id ] = iTitleCached[ random_num( ASSAULT, SG ) ];
}
public register_ham_czbots(id)
{
	// Make sure it's a CZ bot and it's still connected
	if (g_hamczbots || !is_user_connected(id) || !get_pcvar_num(cvar_botquota))
		return;
	
	RegisterHamFromEntity(Ham_Spawn, id, "Fwd_PlayerSpawn_Post", 1)
	
	// Ham forwards for CZ bots succesfully registered
	g_hamczbots = true
	
	// If the bot has already spawned, call the forward manually for him
	if (is_user_alive(id)) Fwd_PlayerSpawn_Post( id )
}
public Fwd_PlayerSpawn_Post( id )
{
	if( !is_user_alive( id ) || !cs_get_user_team( id ) )
		return;
	
	// Set Weapon Title
	UTIL_KillAttachment(id)
	UTIL_SetAttachment( id, 65, g_iTitle[ id ], 255);
	
	
}
UTIL_SetAttachment(id, verticalOffset, modelIndex, iLife)
{
	new iPlayers[32], iNum, iPlayer;
	get_players(iPlayers, iNum, "a");
	
	for (new i = 0; i <= iNum ; i++)
	{
		iPlayer = iPlayers[i];
		
		if (id != iPlayer && get_user_team(id) == get_user_team(iPlayer))
		{
			message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, iPlayer);
			write_byte(TE_PLAYERATTACHMENT) ;
			write_byte(id); // entity index of player 
			write_coord(verticalOffset); // vertical offset (attachment origin.z = player origin.z + vertical offset) 
			write_short(modelIndex); // model index 
			write_short(iLife * 10); // life * 10 
			message_end();
		}
	}
}
UTIL_KillAttachment(id)
{
	message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id);
	write_byte(TE_KILLPLAYERATTACHMENTS);
	write_byte(id);
	message_end();
}