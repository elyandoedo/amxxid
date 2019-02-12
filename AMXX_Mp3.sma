
#include <amxmodx>
#include <amxmisc>

#define MAX_SONGS	10

new MP3
enum
{
	SECTION_NAME = 0,
	SECTION_MODEL,
	SECTION_WPNCHANGE
}

new c_type[MAX_SONGS]
new c_judul[MAX_SONGS][64]
new c_file[MAX_SONGS][32]
new sound1[MAX_SONGS][64]
new sound2[MAX_SONGS][64]
new data_tipe, data_judul[64], data_file[32]
public plugin_init()
{ 
	register_plugin("MUSIC PLAYER","1.0","EDo")
	register_concmd("csx_play","csx_dmg")
}
load_config_wpn()
{
	// Build customization file path
	new path[64]
	format(path, charsmax(path),"csx/music.ini")
	
	// File not present
	if (!file_exists(path))
	{
		new error[100]
		formatex(error, charsmax(error), "Cannot load customization file %s!", path)
		set_fail_state(error)
		return;
	}
	
	// Set up some vars to hold parsing info
	new linedata[1024], key[64], value[960]
	
	// Open customization file for reading
	new file = fopen(path, "rt")
	new idwpn = 1
	while (file && !feof(file))
	{
		// Read one line at a time
		fgets(file, linedata, charsmax(linedata))
		
		// Replace newlines with a null character to prevent headaches
		replace(linedata, charsmax(linedata), "^n", "")
		
		// Blank line or comment
		if (!linedata[0] || linedata[0] == ';') continue;
		
		// Replace
		replace_all(linedata, charsmax(linedata), ",", "")
		replace_all(linedata, charsmax(linedata), "[name]", ",")
		replace_all(linedata, charsmax(linedata), "[file]", ",")
		replace_all(linedata, charsmax(linedata), "[type]", ",")
		// Get value
		strtok(linedata, key, charsmax(key), value, charsmax(value), ',')
		new i
		while (value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
		{
			switch (i)
			{
				case SECTION_NAME: format(data_judul, charsmax(data_judul), "%s", key)
				case SECTION_MODEL: format(data_file, charsmax(data_file), "%s", key)
				case SECTION_WPNCHANGE: data_tipe = str_to_num(key)
				
			}
			
			//client_print(0, print_chat, "STT[%i] VL[%s]", i, key)
			i++
		}
		
		
		format(c_judul[idwpn], 63, "%s", data_judul)
		format(c_file[idwpn], 31, data_file)
		c_type[idwpn] = data_tipe
		if (data_tipe==1)
		{
			format(sound1[idwpn], 63, "musik/%s.wav", data_file)
			precache_sound(sound1[idwpn])
		}
		else if (data_tipe==2)
		{
			format(sound2[idwpn], 63, "musik/%s.mp3", data_file)
			precache_sound(sound2[idwpn])
		}
		idwpn++
		
		
		// check max wpn
		if (idwpn == MAX_SONGS) return;
	}
	MP3 = idwpn
	
}

public plugin_precache()
{
	load_config_wpn()

	
}
public csx_dmg(id)
{
	if(!is_user_alive(id))
		return
	new menu = menu_create("[Music]", "MenuHandle_dmg")  
	{
		menu_additem( menu, "List Music", "1" )
		menu_additem( menu, "Stop Music", "2" )
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
				showEquip(id)
			}
			case 1:{
				Function(id)
			}
		}
	}

	return
}
public showEquip(id)
{
	
	new mHandleID = menu_create("Playlist", "menu_wpn_handler")
	new i=0, check_value = 1
	while (check_value && i<MP3)
	{
		if (check_value)
		{
			new item_name[150], idwpn[32]
			format(item_name, 149, "%s", c_judul[i])
			format(idwpn, 31, "%i", i)
			
			new check_money
			
			menu_additem(mHandleID, item_name, idwpn, check_money)
		}
		i++
	}
	
	menu_display(id, mHandleID, 0)
}

public menu_wpn_handler(id, menu, item)
{
	if (item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new idwpn[32], name[32], access
	menu_item_getinfo(menu, item, access, idwpn, 31, name, 31, access)
	new idmp3 = str_to_num(idwpn)
	client_cmd(0,"mp3 stop;stopsound")
	if(c_type[idmp3]==2)
	{
		client_cmd(0,"mp3 play ^"sound/%s^"",sound2[idmp3])
	}
	if(c_type[idmp3]==1)
	{
		client_cmd(0,"spk ^"%s^"",sound1[idmp3])
	}
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public Function(id)
{
	client_cmd(0,"mp3 stop;stopsound")
}

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
