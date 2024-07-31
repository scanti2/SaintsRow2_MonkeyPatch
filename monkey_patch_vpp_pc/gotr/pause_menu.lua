-------[include]--------------
if get_game_play_mode() == "Pre-game lobby" then
	include("multi_pause_menu.lua")
end

--------[ PAUSE MENU ]-------- 
--	Flag that says we're in the pause menu
Pause_menu = true

-- Global handles
PAUSE_MENU_DOC_HANDLE = vint_document_find("pause_menu")

--	Custom controls
PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE	=	1000
PAUSE_MENU_CONTROL_STAT_TEXT_LINE		=	1001
PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE =	1002
PAUSE_MENU_CONTROL_CHECKBOX_IMAGE		=	1003
PAUSE_MENU_CONTROL_SAVE_LOAD				=	1004
PAUSE_MENU_CONTROL_HELP_TEXT				=	1005
PAUSE_MENU_CONTROL_CENTERED_LABEL		=	1006
PAUSE_MENU_CONTROL_PLAYLIST_EDITOR		=	1007
PAUSE_MENU_CONTROL_SCOREBOARD				= 	1008
PAUSE_MENU_CONTROL_LOBBY_PLAYERS			= 	1009
PAUSE_MENU_CONTROL_OBJECTIVE_WRAP_LINE = 	1010
PAUSE_MENU_CONTROL_PAGE_TEXT				=	1005

-- Bitmaps
PAUSE_MENU_CHECK_BOX_TRUE = "ui_menu_checkbox_true" 
PAUSE_MENU_CHECK_BOX_FALSE = "ui_menu_checkbox_false"

-- Color
PAUSE_MENU_RED_CHECK_COLOR   = {["R"] = 0.56, ["G"] = 0, ["B"] = 0} 
PAUSE_MENU_GREEN_CHECK_COLOR = {["R"] = 0.27, ["G"] = 0.47, ["B"] = 0.09} 			

--	Page control stuff
Pause_menu_page = { }
Pause_menu_help_text_tween = { }
PAGE_PADDING							= 	30

Pause_menu_help_page = { }

--	Control parameters
PAUSE_MENU_STAT_SPACE						=	50
PAUSE_MENU_CHECKBOX_IMAGE_HEIGHT			=	375
PAUSE_MENU_CHECK_BOX_IMAGE_PADDING		=  30
PAUSE_MENU_HITMAN_IMAGE_WIDTH				=	550
PAUSE_MENU_CHOPSHOP_IMAGE_WIDTH			=	580
PAUSE_MENU_CHOPSHOP_IMAGE_HEIGHT			=	375
PAUSE_MENU_HELP_TEXT_WIDTH					=	600
PAUSE_MENU_HELP_TEXT_HEIGHT				= 	375
PAUSE_MENU_HELP_TEXT_CLIP_WIDTH			=  610
PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT			=  362

-- PAUSE_MENU_HELP_LINE_HEIGHT					=  28 -- height of a line of text including spacer.
PAUSE_MENU_HELP_SLIDER_WIDTH				=  25

OBJECTIVES_MAX_ITEMS							= 18
OBJECTIVE_MAX_VISIBLE_ITEMS				= 1
OBJECTIVE_MAX_VISIBLE_PIXELS				= 400

PLAYLIST_MAX_ITEMS 							= 	9
PLAYLIST_WIDTH									= 708
PLAYLIST_HEIGHT								= 317
PLAYLIST_LEFT_SELECTBAR_WIDTH 			= 355
PLAYLIST_RIGHT_SELECTBAR_WIDTH			= 330

SCOREBOARD_WIDTH								= 782
SCOREBOARD_HEIGHT								= 377

LOBBY_PLAYERS_WIDTH								= 400
LOBBY_PLAYERS_HEIGHT								= 377

--brightness/gamma menu
Pause_menu_calibrate_image_peg			= 0

--	Hitman/Chopshop stuff
Pause_menu_checkbox_image_peg 			= 0
Pause_menu_checkbox_image_width			= 0
Pause_menu_check_box_image					= { image_h	= 0, bitmap_h = 0, text_h = 0 }
Pause_menu_hitman_offset					= { 
	x = 50, y = -14, 
	text = { 
		x = 20, y = 60, 
		rot = -0.06, 
		wrap = 292 
	},
	specific_text = {	x = 330, y = 280, rot = -0.05 }
}

Pause_menu_chop_shop_offset				= { 
	x = 50, y = -100, 
	text = { 
		x = 18, y = 120, 
		rot = -0.045, 
		wrap = 285
	},
	specific_text = {	x = 35, y = 370, rot = -0.038 }
}

-- Diversion Statistics stuff
DIV_DATA_NUMBER 	= 0
DIV_DATA_HHMMSS 	= 1
DIV_DATA_MMSS 		= 2
DIV_DATA_CASH		= 3
DIV_DATA_STAR		= 4
DIV_DATA_X_OF_Y	= 5

DIV_STAR_BRONZE 	= "ui_hud_diversion_star_bronze"
DIV_STAR_SILVER 	= "ui_hud_diversion_star_silver"
DIV_STAR_GOLD	 	= "ui_hud_diversion_star_gold"

Pause_menu_building = 0
Pause_menu_controller_image_peg = 0

-- Options menu stuff
PAUSE_MENU_CONTROL_SCHEME_ID		= 14
PAUSE_MENU_OPTIONS_POPULATE_ID 	= 15
PAUSE_MENU_PAD_AXES_POPULATE_ID = 20
Pause_menu_controller = { }
Pause_menu_control_scheme_data = { }
control_scheme_values = { [0] = { label = "CONTROL_SCHEME_A", }, [1] = { label = "CONTROL_SCHEME_B", }, [2] = { label = "CONTROL_SCHEME_C", }, cur_value = 0, num_values = 3 }
PAUSE_MENU_DIFFICULTY_ID = 0
PAUSE_MENU_CONTROL_ID = 1
PAUSE_MENU_DISPLAY_ID = 2
PAUSE_MENU_AUDIO_ID   = 3
PAUSE_MENU_PAD_CONTROL_ID = 5
Pause_menu_brightness = { 	input = { }		}
Pause_menu_current_option_menu = -1
Pause_menu_option_horz_swap_menu = -1
Pause_menu_exit_after = false
Quit_game = false

Pause_menu_current_difficulty = 0  -- needed to find out if difficulty menu is dirty

DIFFICULTY_CASUAL = 0
DIFFICULTY_NORMAL = 1
DIFFICULTY_HARDCORE = 2

Pause_menu_no_swap = false
Pause_menu_swap_to_map = false

-- only used if in the main menu
Pause_menu_return_to_main = 0
Pause_menu_main_close_ref = 0

----------------------------------
function format_time(data)
	local total_seconds = data
	local hours = floor(total_seconds / 3600)
	local minutes = floor(mod(total_seconds, 3600) / 60)
	local seconds = mod(total_seconds, 60)

	local new_value
	if hours > 0 then
		new_value = hours .. ":" .. minutes .. ":" .. seconds
	elseif minutes > 9 then
		new_value = "0:" .. minutes .. ":" .. seconds
	elseif minutes > 0 then
		new_value = "0:0" .. minutes .. ":" .. seconds
	elseif seconds > 9 then
		new_value = "0:0:" .. seconds
	else
		new_value = "0:0:0" .. seconds
	end
			
	return new_value
end

----------------------------------
--------[ MENU INIT/EXIT ]-------- 
----------------------------------
function pause_menu_init()
	menu_set_custom_control_callbacks(Pause_menu_controls)
	Pause_menu_no_swap = false
	if get_platform() == "PS3" then
		Pause_info_menu[5] = Pause_info_menu[6]	--	Swap the last two to remove achievements from PS3
		Pause_info_menu.num_items = 6
		Pause_save_load_btn_tips.x_button 	= 	{ label = "PS3_SAVE_SELECTION_MANAGE_MEMORY", 		enabled = btn_tips_default_a, }
		Pause_save_menu.on_alt_select = pause_save_delete_data
		Pause_load_menu.on_alt_select = pause_save_delete_data
		Pause_menu_friends_tips = Pause_menu_friends_tips_ps3
		Pause_menu_quit_to_main_tips = Pause_menu_quit_to_main_tips_ps3
	else
		if get_platform() == "PC" then
			Pause_info_menu[5] = Pause_info_menu[6]
			Pause_info_menu.num_items = 6
		end
	end
	
	local event_tracking_string = "Pause Menu"
	
	if Pause_menu_save_for_server_drop == true then
		-- save only for server drop
		menu_init()
		
		--Force button tips
		BTN_TIPS_DEFAULT.b_button.label = "CONTROL_BACK"
		Pause_save_load_btn_tips.b_button.label = "CONTROL_BACK"
		
		btn_tips_init()
		-- Set button tips to visible but hide the actual tips.
		local menu_tips_h = vint_object_find("menu_tips", nil, MENU_BASE_DOC_HANDLE)
		vint_set_property(menu_tips_h, "visible", true)
		local menu_btn_tips_h = vint_object_find("menu_btn_tips", nil, MENU_BASE_DOC_HANDLE)
		vint_set_property(menu_btn_tips_h, "alpha", 1)
		
		--Force background up
		local tips_clip_h = vint_object_find("tips_clip", nil, MENU_BASE_DOC_HANDLE)
		local x, y = vint_get_property(tips_clip_h, "offset")
		vint_set_property(tips_clip_h, "offset", 0, y)
		
		pause_save_menu_select()
		
		event_tracking_string = "Pause Menu: (Server Drop)"
	elseif Menu_mode_current == "pause" then
		-- for standard pause menu
		Pause_load_menu.on_pause = pause_menu_exit
		Pause_save_load_btn_tips.b_button.label = "CONTROL_BACK"
		menu_init()
--		interface_effect_begin("pause")
		if is_coop_start_screen() then
			Pause_horz_menu = Coop_invite_friends_horz_menu
			event_tracking_string = "Pause Menu: (Invite Friends)"
		elseif get_game_play_mode() == "Pre-game lobby" then 
			multi_lobby_menu_setup()
			event_tracking_string = "Pause Menu: (Pre-Game Lobby)"
		elseif get_is_tutorial() == true then
			pause_menu_setup_lobby_menu()
			event_tracking_string = "Pause Menu: (Tutorial)"
		elseif mp_is_enabled() == true then
			Pause_horz_menu = MP_Pause_horz_menu
			event_tracking_string = "Pause Menu: (Multiplayer)"
		elseif is_connected_to_network() and is_signed_in() then
			local num_items = Pause_horz_menu.num_items
			Pause_horz_menu[num_items] = { label = "MAINMENU_COOP", 	sub_menu = Pause_coop_menu 		}
			Pause_horz_menu.num_items = num_items + 1
		elseif is_signed_in() and get_platform() == "PC" then
			local num_items = Pause_horz_menu.num_items
			Pause_horz_menu[num_items] = { label = "MAINMENU_COOP", 	sub_menu = Pause_coop_menu 		}
			Pause_horz_menu.num_items = num_items + 1
		end
		
		--Event Tracking (Register Interface)
		event_tracking_interface_enter(event_tracking_string)
		
		if pause_menu_get_state() == 1 or pause_menu_get_state() == 2 then	--	Hitman or chopshop
			pause_menu_create_special()
		else
			menu_horz_init(Pause_horz_menu)
		end
		
		--We are in pause menu, Indicate it only if we are not in mp
		if mp_is_enabled() == false then
			local pause_menu_indicator_h = vint_object_find("pause_menu_indicator", nil, MENU_BASE_DOC_HANDLE)
			vint_set_property(pause_menu_indicator_h, "visible", true)
			
			if get_is_host() == false then
				pause_menu_option_menu_init(2)
			end
		elseif Pause_options_menu ~= Pause_options_menu_no_difficulty then
			pause_menu_option_menu_init(2)
		end
	else
		--Event Tracking (Register Interface)
		event_tracking_interface_enter("Main Menu")
	
		-- for main menu
		pause_menu_option_menu_init(1)
	end
end
	
function pause_menu_setup_lobby_menu()
	--rebuild options menu to not have the difficulty setting
	Pause_options_menu = Pause_options_menu_no_difficulty
	Pause_horz_menu = Multi_pause_horz_menu_options_only
	
	--kill the map setting
	Pause_menu_no_swap = true
end
	
function pause_menu_option_menu_init(menu_format)
	--Certain menu modes require different option sets
	--Circularly swap the menu items
	Pause_options_menu[0] = Pause_options_menu[1]
	Pause_options_menu[1] = Pause_options_menu[2]
	Pause_options_menu[2] = Pause_options_menu[3]
	Pause_options_menu[3] = Pause_options_menu[4]
	Pause_options_menu[4] = Pause_options_menu[0]  
	
	if menu_format == 0 then
		--Standard Pause Menu
		Pause_options_menu.num_items = 5
	elseif menu_format == 1 then
		--Main menu (No difficulty options
		Pause_options_menu.num_items = 3
		Pause_options_menu.on_pause = nil
	elseif menu_format == 2 then
		--Multiplayer pause menu
		Pause_options_menu.num_items = 4
	end
end

function pause_menu_init_check_box()

	if Pause_menu_check_box_image.image_h ~= nil and Pause_menu_check_box_image ~= 0 then
		vint_object_destroy(Pause_menu_check_box_image.image_h)
	end
	
	Pause_menu_check_box_image.image_h				= vint_object_clone(vint_object_find("pm_image"), Menu_option_labels.control_parent)
	Pause_menu_check_box_image.bitmap_h   			= vint_object_find("pm_bitmap", Pause_menu_check_box_image.image_h)
	Pause_menu_check_box_image.text_h   			= vint_object_find("pm_text", Pause_menu_check_box_image.image_h)
	Pause_menu_check_box_image.sp_text_h 			= vint_object_find("specific_text", Pause_menu_check_box_image.image_h)
	Pause_menu_check_box_image.sp_text_top_h 		= vint_object_find("specific_text_top", Pause_menu_check_box_image.sp_text_h)
	Pause_menu_check_box_image.sp_label_top_h 	= vint_object_find("specific_label_top", Pause_menu_check_box_image.sp_text_h)
	Pause_menu_check_box_image.sp_text_bottom_h  = vint_object_find("specific_text_bottom", Pause_menu_check_box_image.sp_text_h)
	Pause_menu_check_box_image.sp_label_bottom_h = vint_object_find("specific_label_bottom", Pause_menu_check_box_image.sp_text_h)
end

function pause_menu_cleanup()
	if Pause_menu_checkbox_image_peg ~= 0 then
		peg_unload(Pause_menu_checkbox_image_peg)
	end
	
	if Pause_menu_controller_image_peg ~= 0 then
		peg_unload(Pause_menu_controller_image_peg)
	end
	
	if Pause_menu_calibrate_image_peg ~= 0 then
		peg_unload(Pause_menu_calibrate_image_peg)
	end
	
	if SCOREBOARD_DOC_H ~= 0 then
		vint_document_unload(SCOREBOARD_DOC_H)
	end
	
	if LOBBY_PLAYERS_DOC_H ~= 0 then
		vint_document_unload(LOBBY_PLAYERS_DOC_H)
	end
	
	if Quit_game == true then
		pause_menu_quit_game_internal()
	end

	if Pause_menu_swap_to_map == false then
		--	Release the camera and close the menu
		pause_menu_release_camera()
	end

	-- Make sure the radio station stuff is done with
	peg_unload("ui_radio_logos")
	radio_station_preview(true)
	
	peg_unload("ui_crib_photos")
	
--	interface_effect_end()
end

function pause_menu_exit_final()
	if Pause_menu_control_scheme_data.thread_h ~= nil then
		thread_kill(Pause_menu_control_scheme_data.thread_h)
	end
	pause_menu_control_scheme_init(false)
	
	if Pause_menu_swap_to_map == true then
		hud_hide(true)
		pause_menu_swap_with_map(1)
	end
	
	vint_document_unload(PAUSE_MENU_DOC_HANDLE)	
end

function pause_menu_exit()
	if Menu_mode_current == "pause" then
		--	Revert things just in case
		for i = 0, 3 do 
			pause_menu_revert_options(i)
		end
		playlist_play_track(0, 0, true)	--	Stop any song playing
		-- Close the cellphone
		if(vint_document_find("cellphone") ~= 0) then
			vint_document_unload(vint_document_find("cellphone"))
		end
		
		if Pause_menu_swap_to_map == false then
			pause_menu_release_camera() 
		end
		
		menu_close(pause_menu_exit_final)
	else
	
		if Pause_menu_return_to_main ~= 0 then
			Pause_menu_return_to_main()
		end
	end
end

function pause_menu_swap()
	if pause_menu_get_state() ~= 0 then	--	Hitman or chopshop
		return
	end
	
	if Pause_menu_no_swap == true then
		return
	end
	
	if pause_menu_can_swap() == false then
		return
	end
	
	Pause_menu_swap_to_map = true
	pause_menu_exit()
end

function pause_menu_save_cancel_confirm(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == DIALOG_RESULT_YES then
		pause_menu_exit()
	end
end

function pause_menu_save_load_exit()
	-- this can get called from C so make it a bit defensive

	if Menu_active ~= 0 then
		if Menu_active.is_load_menu ~= true and Menu_active.is_save_menu ~= true then
			return
		end
	else
		return
	end
	
	if Pause_menu_save_for_server_drop == true then
		dialog_box_confirmation("PAUSE_MENU_QUIT_TITLE", "PAUSE_MENU_QUIT_NO_SAVE_CONFIRM_TEXT", "pause_menu_save_cancel_confirm")
	elseif Menu_mode_current == "pause" then
		menu_show(Pause_save_load_menu, MENU_TRANSITION_SWEEP_RIGHT)
	end
end

-----------------------------
--------[ INFO MENU ]-------- 
-----------------------------
function pause_menu_info_on_show(menu_data)
	event_tracking_interface_tab_change_string(menu_data.header_label_str)
end

function pause_menu_info_select(menu_label, menu_data)
	event_tracking_interface_tab_change_string(menu_data.label)
end

function pause_menu_build_info_menu(menu_data)
	if Menu_active.do_not_rebuild_previous == true and Menu_active.parent_menu == menu_data then
		Menu_active.do_not_rebuild = nil
		return
	end
		
	local hl_item = Menu_active.highlighted_item
	if hl_item == nil then
		hl_item = 0
	end

	local idx = Menu_active[hl_item].id
	
	-----------------------------------------
	if idx == 100 then	
		menu_data.header_label_str = "NOT IMPLEMENTED"
		menu_data.num_items = 1
		menu_data[0] = { label = "Not implemented yet", type = PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE }
		return
	end
	-----------------------------------------
	
	-- Set the header
	if Pause_info_menu_population_data[idx].header ~= nil then
		menu_data.header_label_str = Pause_info_menu_population_data[idx].header
--	elseif Menu_active[hl_item].sub_header ~= nil then
	--	menu_data.header_label_str = Menu_active[hl_item].sub_header
	else
		menu_data.header_label_str = Menu_active[hl_item].label
	end
	
	if Pause_info_menu_population_data[idx].prep_function ~= nil then
		Pause_info_menu_population_data[idx].prep_function(menu_data)
	else
		pause_menu_clear_funcs(menu_data)
		menu_data.on_show = pause_menu_build_info_menu
		menu_data.on_pause = pause_menu_exit
		menu_data.on_map = pause_menu_swap
	end

	--	Prepare to populate
	menu_data.num_items = 0
	menu_data.highlighted_item = 0
	
	if Menu_active[hl_item].index ~= nil then
		hl_item = Menu_active[hl_item].index
	end
	
	--	Populate the menu
	vint_dataresponder_request("pause_menu_populate", Pause_info_menu_population_data[idx].callback, 0, idx, hl_item)

	if menu_data.num_items == 0 then
		menu_data.num_items = 1
		if Pause_info_menu_population_data[idx].empty ~= nil then
			menu_data[0] = { label = Pause_info_menu_population_data[idx].empty, type=PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE }
		else 
			menu_data[0] = { label = "STORE_NO_ITEMS_IN_CATEGORY", type=PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE }
		end
		
		menu_data.btn_tips = Pause_menu_back_only
	end

end

function pause_menu_populate_objectives(objective_text, is_complete)
	local idx = Pause_info_objective_lines.num_lines
	local complete = nil
	
	--	Set complete to true or false
	if is_complete == 0 then
		complete = false
	elseif is_complete == 1 then
		complete = true
	end
	
	--script_assert(idx < OBJECTIVES_MAX_ITEMS, "Too many objetive messages, might have to bump the number.")
	
	-- Setup the menu item
	Pause_info_objective_lines[idx] = { text_string = objective_text, checked = complete, check_color = PAUSE_MENU_GREEN_CHECK_COLOR}
	Pause_info_objective_lines.num_lines = Pause_info_objective_lines.num_lines + 1
	Pause_info_objective_lines.current_line = 0
	
end



----------------------[ Stats ]----------------------
function pause_menu_prep_stats(menu_data)
	-- Destroy the old page group if it still exists
	if Pause_menu_page.grp_h ~= 0 and Pause_menu_page.grp_h ~= nil then
		--Do not destroy the old page group but reset the target
		--vint_object_destroy(Pause_menu_page.grp_h)
		Pause_menu_page.grp_h = 0
	end
	
	--Build a custom header 
	local header_h = vint_object_clone(vint_object_find("pm_header_nav"), Menu_option_labels.control_parent)
	local header_label_h = vint_object_find("title", header_h)
	vint_set_property(header_label_h, "text_tag", menu_data.header_label_str)
	vint_set_property(header_h, "anchor", 0, 0)
	vint_set_property(header_h, "visible", true)
	
	local header_nav_size = 105	--Size of header element
	Menu_option_labels.header_h = header_h
	
	--reset our standard label string
	menu_data.header_label_str = nil
	
	local header_label_width, header_label_height = element_get_actual_size(header_label_h)
	
	--Calculate Header width to include the new header nav object
	menu_data.header_width = header_nav_size + header_label_width + 20
		
	--	Initialize the new pages
	Pause_menu_page.max = 1
	Pause_menu_page.current = 1
	
	--	Display the new page indicator
	Pause_menu_page.label_h = vint_object_find("nav_id", header_h)
	Pause_menu_page.arrow_e = vint_object_find("pm_arrow_e", header_h)
	Pause_menu_page.arrow_w = vint_object_find("pm_arrow_w", header_h)
	vint_set_property(Pause_menu_page.label_h, "text_tag", Pause_menu_page.current .. "/" .. Pause_menu_page.max)

	menu_data.on_release = pause_menu_release_page
end

function pause_menu_update_page()
	local w_x, w_y = vint_get_property(Pause_menu_page.arrow_w, "anchor")
	local label_x, label_y = vint_get_property(Pause_menu_page.label_h, "anchor")
	
	--	Update the current pages
	vint_set_property(Pause_menu_page.label_h, "text_tag", Pause_menu_page.current .. "/" .. Pause_menu_page.max)
	
	local label_width, label_height = element_get_actual_size(Pause_menu_page.label_h)
	vint_set_property(Pause_menu_page.arrow_w, "anchor", label_x - label_width - 8, w_y)
	
end

function pause_menu_release_page(menu_data)
	--destroy custom header
	vint_object_destroy(Menu_option_labels_inactive.header_h)
	Menu_option_labels_inactive.header_h = nil
	Pause_menu_page = { }
	
	--Pause_info_sub_menu = table_clone(Pause_info_sub_menu_template)
	
	if Menu_mode_current == "pause" then
		Pause_info_menu[3].sub_menu = Pause_info_sub_menu
	else
		if get_platform() == "PS3" then	
			Main_menu_ps3_online[3].sub_menu = Pause_info_sub_menu
		else
			Main_menu_xbox_live[3].sub_menu = Pause_info_sub_menu
		end
	end
end

function pause_menu_anchor_stats(menu_data)
	
	local text_width = menu_data.menu_width - 20
	if Menu_option_labels.scroll_bar_visible == true and Menu_control_callbacks[menu_data[0].type].uses_scroll_bar ~= false then
		text_width = text_width - 37
	end
	
	-- Anchor the value on the right
	for i = 0, Menu_option_labels.max_rows - 1 do
		if Menu_option_labels[i].value_h ~= nil then
			vint_set_property(Menu_option_labels[i].value_h, "anchor", text_width, 0)
		end

		if Menu_option_labels[i].stars ~= nil then
			vint_set_property(Menu_option_labels[i].stars.star_grp, "anchor", text_width + 7, 0)
		end
	end
end

function pause_menu_finalize_stats(menu_data)
	pause_menu_anchor_stats(menu_data)	
		
	--Adjust the page indicator(arrows) in header
	local header_nav_h = vint_object_find("header_nav", Menu_option_labels.header_h)
	local ax, ay = vint_get_property(header_nav_h, "anchor")
	vint_set_property(header_nav_h, "anchor", menu_data.menu_width, ay)
		
	--Set Header line width
	vint_set_property(vint_object_find("header_horz", Menu_option_labels.header_h), "source_se", menu_data.menu_width - 10, 10)
		
	--Hide Scrollbar
	menu_scroll_bar_hide()
	
	--	Set the max for the pages and update the numbers
	Pause_menu_page.max = ceil(menu_data.num_items / Menu_option_labels.max_rows)
	pause_menu_update_page()

end

function pause_menu_stat_get_width(menu_data)
	local grp_h = vint_object_find("pm_stat_text_line")
	local label_h = vint_object_find("stat_label", grp_h)
	local value_h = vint_object_find("stat_value", grp_h)
	local star_h = vint_object_find("stat_stars", grp_h)
	local width
	
	--	Set the text tags to get the size
	vint_set_property(label_h, "text_tag", menu_data.label)
	width = element_get_actual_size(label_h)

	if menu_data.data_type == DIV_DATA_STAR then
		local value_width = element_get_actual_size(star_h)
		
		width = width + value_width + PAUSE_MENU_STAT_SPACE
	elseif menu_data.show_value == true then
		vint_set_property(value_h, "text_tag", menu_data.value)
		local value_width = element_get_actual_size(value_h)
		
		--	Add some space together to properly size the window
		width = width + value_width + PAUSE_MENU_STAT_SPACE
	end
	
	if Menu_option_labels.scroll_bar_visible == true then
		width = width + 25
	end
	
	return width
end

function pause_menu_populate_stats(stat_text, show_value, value)

	Pause_info_sub_menu.on_release	= pause_menu_release_page
	Pause_info_sub_menu.on_post_show = pause_menu_finalize_stats
	local idx = Pause_info_sub_menu.num_items
	if show_value == 1 then
		show_value = true
	else
		show_value = false
	end

	Pause_info_sub_menu[idx] = { label = stat_text, show_value = show_value, value = value, type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, get_width = pause_menu_stat_get_width }
	Pause_info_sub_menu.num_items = Pause_info_sub_menu.num_items + 1
	
	Pause_info_sub_menu.btn_tips = Pause_menu_back_only
end


----------------------[ Diversions ]----------------------
function pause_menu_hitman_target_select(menu_label, menu_data)
	local hl_item = Pause_info_diversions_sub_menu.highlighted_item
	if Pause_info_diversions_sub_menu[hl_item].dead == true then
		return
	end	
	
	pause_menu_select_target(1, hl_item)
	if pause_menu_update_checkmark(Pause_info_diversions_sub_menu, hl_item) == true then
		pause_menu_exit()
	end
end

function pause_menu_chop_shop_vehicle_select(menu_label, menu_data)
	local hl_item = Pause_info_diversions_sub_menu.highlighted_item
	if Pause_info_diversions_sub_menu[hl_item].retrieved == true then
		return
	end
	pause_menu_select_target(2, hl_item)
	
	if pause_menu_update_checkmark(Pause_info_diversions_sub_menu, hl_item) == true then
		pause_menu_exit()
	end
end

function pause_menu_update_checkmark(menu_data, index)
	for i = 0, menu_data.num_items - 1 do
		if menu_data[i].check_color == PAUSE_MENU_GREEN_CHECK_COLOR then
			vint_set_property(Menu_option_labels[i].check_h, "visible", false)
			menu_data[i].checked = false
			menu_data[i].check_color = PAUSE_MENU_RED_CHECK_COLOR
			if i == index then
				return false
			end
		end
	end
	
	menu_data[index].checked = true
	menu_data[index].check_color = PAUSE_MENU_GREEN_CHECK_COLOR
	vint_set_property(Menu_option_labels[index].check_h, "visible", true)
	vint_set_property(Menu_option_labels[index].check_h, "tint", menu_data[index].check_color.R, menu_data[index].check_color.G, menu_data[index].check_color.B)
	return true
end

function pause_menu_diversions_update_stars(menu_label, menu_data)
	if menu_data.data_type ~= DIV_DATA_STAR then
		return
	end
	
	local value = tonumber(menu_data.value)
	menu_data.value = value
	
	if menu_data.value == 0 then
		vint_set_property(menu_label.stars.star_grp, "visible", false)
	else
		local val = mod(menu_data.value - 1, 3)
		for i = 0, val do
			vint_set_property(menu_label.stars.star_h[i], "visible", true)
			
			if menu_data.value < 4 then
				vint_set_property(menu_label.stars.star_h[i], "image", DIV_STAR_BRONZE)
			elseif menu_data.value < 7 then
				vint_set_property(menu_label.stars.star_h[i], "image", DIV_STAR_SILVER)
			else
				vint_set_property(menu_label.stars.star_h[i], "image", DIV_STAR_GOLD)
			end
		end
		
		for i = (val + 1), 2 do 
			vint_set_property(menu_label.stars.star_h[i], "visible", false)
		end
		
	end
	
end

function pause_menu_diversions_post_show(menu_data)
	pause_menu_anchor_stats(menu_data)
	
	if menu_data[Menu_active.highlighted_item].type == PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE then
		pause_menu_control_diversion_text_line_enter(Menu_option_labels[Menu_active.highlighted_item - Menu_active.first_vis_item], menu_data[Menu_active.highlighted_item])
	end
end

function pause_menu_diversions_get_width(menu_data)
	local grp_h = vint_object_find("pm_stat_text_line")
	local label_h = vint_object_find("stat_label", grp_h)
	local value_h = vint_object_find("stat_value", grp_h)
	local star_h = vint_object_find("stat_stars", grp_h)
		
	local left_width = 0
	local right_width = 0
	local max_left = 0
	local max_right = 0
	
	-- set the labels and hide unused
	for i = 0, menu_data.num_items - 1 do
		local item = menu_data[i]
		--	Set the text tags to get the size
		vint_set_property(label_h, "text_tag", item.label)
		left_width = element_get_actual_size(label_h)
		
		if item.data_type == DIV_DATA_STAR then
			right_width = (element_get_actual_size(star_h) * 3) + 20 -- since there are 3 stars. .1 for good measure
		elseif item.show_value == true then
			vint_set_property(value_h, "text_tag", item.value)
			right_width = element_get_actual_size(value_h)
		end
		
		if left_width > max_left then
			max_left = left_width
		end
		
		if right_width > max_right then
			max_right = right_width
		end
	end
	
	local width = max_left + max_right + PAUSE_MENU_STAT_SPACE
	if Menu_option_labels.scroll_bar_visible == true then
		width = width + 25
	end
	
	return width
end

function pause_menu_clear_funcs(menu_data)
	menu_data.get_width = nil
	menu_data.get_height = nil
	menu_data.image_offset = nil
	menu_data.check_color = nil
	menu_data.on_nav = nil
	menu_data.on_release = nil
	menu_data.on_post_show = nil
	menu_data.do_not_rebuild_previous = nil
end

function pause_menu_prep_diversions(menu_data)
	pause_menu_clear_funcs(menu_data)
	menu_data.on_post_show = pause_menu_diversions_post_show
	menu_data.get_width = pause_menu_diversions_get_width	
end

function pause_menu_prep_diversions_stats(menu_data)
	pause_menu_prep_diversions(menu_data)

	menu_data.do_not_rebuild_previous = true
	menu_data.get_width = pause_menu_diversions_get_width
end

function pause_menu_prep_diversions_stats_sub(menu_data)
	pause_menu_clear_funcs(menu_data)

	menu_data.on_post_show = pause_menu_diversions_post_show
	menu_data.do_not_rebuild_previous = true
	menu_data.get_width = pause_menu_diversions_get_width
	if menu_data.previous_idx == nil then
		menu_data.previous_idx = Menu_active[Menu_active.highlighted_item].id
		menu_data.previous_hl_item = Menu_active.highlighted_item
	end
end

function pause_menu_populate_diversions_menu(diversion_name, stars)
	local idx = Pause_info_diversions_sub_menu.num_items 

	Pause_info_diversions_sub_menu[idx] = { 
		label = diversion_name, type = PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE, show_value = true, value = stars, data_type = DIV_DATA_STAR, sub_menu = Pause_info_diversions_stat_menu, id = 7, 
	}	
	
	Pause_info_diversions_sub_menu.num_items = Pause_info_diversions_sub_menu.num_items + 1
end

function pause_menu_populate_diversions_stat(stat_name, type_of_data, data, more)
	local idx = Pause_info_diversions_stat_menu.num_items

	Pause_info_diversions_stat_menu[idx] = { label = stat_name, data_type = type_of_data, show_value = true }
--[[if type_of_data == DIV_DATA_CASH then
		Pause_info_diversions_stat_menu[idx].value = "$" .. format_cash(data)
	elseif type_of_data == DIV_DATA_X_OF_Y then
		Pause_info_diversions_stat_menu[idx].value = data .. " of " .. y_value
	elseif type_of_data == DIV_DATA_HHMMSS or type_of_data == DIV_DATA_MMSS then
		Pause_info_diversions_stat_menu[idx].value = format_time(data)
	else
	
	end
]]--
	
	Pause_info_diversions_stat_menu[idx].value = data	
	
	if more == true then
		Pause_info_diversions_stat_menu[idx].type = PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE
		Pause_info_diversions_stat_menu[idx].sub_menu = Pause_info_diversions_stat_sub_menu
		Pause_info_diversions_stat_menu[idx].id = 8
		Pause_info_diversions_stat_menu.btn_tips = Pause_menu_accept_back_btn_tips
	else
		Pause_info_diversions_stat_menu[idx].type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE
		Pause_info_diversions_stat_menu.btn_tips = Pause_menu_back_only
	end
	
	Pause_info_diversions_stat_menu.num_items = Pause_info_diversions_stat_menu.num_items + 1
end

function pause_menu_populate_diversions_stat_sub(stat_name, type_of_data, data, y_value)
	local idx = Pause_info_diversions_stat_sub_menu.num_items
	
	Pause_info_diversions_stat_sub_menu[idx] = { label = stat_name, data_type = type_of_data, type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, show_value = true }
--[[if type_of_data == DIV_DATA_CASH then
		Pause_info_diversions_stat_sub_menu[idx].value = "$" .. format_cash(data)
	elseif type_of_data == DIV_DATA_X_OF_Y then
		Pause_info_diversions_stat_sub_menu[idx].value = data .. " of " .. y_value
	elseif type_of_data == DIV_DATA_HHMMSS or type_of_data == DIV_DATA_MMSS then
		Pause_info_diversions_stat_sub_menu[idx].value = format_time(data)
	else
		
	end
]]--	
	Pause_info_diversions_stat_sub_menu[idx].value = data
	
	Pause_info_diversions_stat_sub_menu.num_items = Pause_info_diversions_stat_sub_menu.num_items + 1
end

function pause_menu_populate_hitman_list(location, target_index)
	local idx = Pause_info_collection_sub_menu.num_items
	
	Pause_info_collection_sub_menu[idx] = { label = location, type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_diversions_sub_menu, id = 3, index = target_index }
	Pause_info_collection_sub_menu.num_items = Pause_info_collection_sub_menu.num_items + 1
end

function pause_menu_hitman_targets_width(menu_data)
	return pause_menu_control_checkbox_image_compute_width(menu_data) + PAUSE_MENU_HITMAN_IMAGE_WIDTH + menu_data.image_offset.x
end

function pause_menu_hitman_targets_height(menu_data)
	return PAUSE_MENU_CHECKBOX_IMAGE_HEIGHT
end

function pause_menu_create_special()
	local idx, callback
	--	Override the on_back and on_show
	Pause_info_diversions_sub_menu.on_back = pause_menu_exit
	Pause_info_diversions_sub_menu.on_pause = nil
	Pause_info_diversions_sub_menu.on_show = nil
	
	--	Hitman
	if pause_menu_get_state() == 1 then
		Pause_info_diversions_sub_menu.header_label_str = "INFO_COLLECTIONS_HITMAN"
		pause_menu_prep_hitman_targets(Pause_info_diversions_sub_menu)
		
		--Attach footer only if we are in special mode
		btn_tips_footer_attach(Pause_info_diversions_sub_menu)
		
		callback = "pause_menu_populate_hitman_target"
		idx = 3
	-- Chopshop
	elseif pause_menu_get_state() == 2 then
		Pause_info_diversions_sub_menu.header_label_str = "INFO_COLLECTIONS_CHOPSHOP"
		pause_menu_prep_chop_shop_vehicle(Pause_info_diversions_sub_menu)
		callback = "pause_menu_populate_chop_shop_vehicle"
		
		--Attach footer only if we are in special mode
		btn_tips_footer_attach(Pause_info_diversions_sub_menu)
	
		idx = 5
	end
	
	Pause_info_diversions_sub_menu.num_items = 0
	vint_dataresponder_request("pause_menu_populate", callback, 0, idx)
	menu_show(Pause_info_diversions_sub_menu, MENU_TRANSITION_SWEEP_RIGHT)
end

function pause_menu_hitman_chop_shop_post_show(menu_data)
	-- Untint it
	pause_menu_checkbox_image_post_show(menu_data)
end

function pause_menu_prep_hitman_targets(menu_data)
	pause_menu_init_check_box()
	menu_data.get_width = pause_menu_hitman_targets_width
	menu_data.get_height = pause_menu_hitman_targets_height
	menu_data.image_offset = Pause_menu_hitman_offset
	menu_data.on_post_show = pause_menu_hitman_chop_shop_post_show
	menu_data.on_nav = pause_menu_checkbox_image_nav
	menu_data.on_release = pause_menu_checkbox_image_release
	menu_data.do_not_rebuild_previous = true
	
	vint_set_property(Pause_menu_check_box_image.text_h, "anchor", menu_data.image_offset.text.x, menu_data.image_offset.text.y)
	vint_set_property(Pause_menu_check_box_image.text_h, "rotation", menu_data.image_offset.text.rot)
	vint_set_property(Pause_menu_check_box_image.text_h, "wrap_width", menu_data.image_offset.text.wrap)
end

function pause_menu_populate_hitman_target(name, dead, dossier, peg, image, location, current)
	local idx = Pause_info_diversions_sub_menu.num_items 
	
	local check_it = dead
	local check_color
	if current == true then
		Pause_info_diversions_sub_menu.highlighted_item = idx
		check_color = PAUSE_MENU_GREEN_CHECK_COLOR
		check_it = true
	else
		check_color = PAUSE_MENU_RED_CHECK_COLOR
	end
	
	Pause_info_diversions_sub_menu[idx] = { 
		type = PAUSE_MENU_CONTROL_CHECKBOX_IMAGE, label = name,
		on_select = pause_menu_hitman_target_select,
		checked = check_it, text = dossier, check_color = check_color,
		peg = peg, image = image, 
		specific_label_top = "HITMAN_NAME", specific_text_top = name,
		specific_label_bottom = "HITMAN_LOCATION",  specific_text_bottom = location,
		dead = dead,
	}	
	
	Pause_info_diversions_sub_menu.num_items = Pause_info_diversions_sub_menu.num_items + 1
end

function pause_menu_populate_chop_shop_list(location, location_idx)
	local idx = Pause_info_collection_sub_menu.num_items
	
	Pause_info_collection_sub_menu[idx] = { label = location, type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_diversions_sub_menu, index = location_idx, id = 5 }
	Pause_info_collection_sub_menu.num_items = Pause_info_collection_sub_menu.num_items + 1
end

function pause_menu_chop_shop_vehicle_width(menu_data)
	return pause_menu_control_checkbox_image_compute_width(menu_data) + PAUSE_MENU_CHOPSHOP_IMAGE_WIDTH + menu_data.image_offset.x
end

function pause_menu_chop_shop_vehicle_height(menu_data)
	return PAUSE_MENU_CHOPSHOP_IMAGE_HEIGHT
end

function pause_menu_prep_chop_shop_vehicle(menu_data)
	pause_menu_init_check_box()
	menu_data.get_width = pause_menu_chop_shop_vehicle_width
	menu_data.get_height = pause_menu_chop_shop_vehicle_height
	menu_data.image_offset = Pause_menu_chop_shop_offset
	menu_data.on_post_show = pause_menu_hitman_chop_shop_post_show
	menu_data.on_nav = pause_menu_checkbox_image_nav
	menu_data.on_release = pause_menu_checkbox_image_release
	menu_data.do_not_rebuild_previous = true
	
	vint_set_property(Pause_menu_check_box_image.text_h, "anchor", menu_data.image_offset.text.x, menu_data.image_offset.text.y)
	vint_set_property(Pause_menu_check_box_image.text_h, "rotation", menu_data.image_offset.text.rot)
	vint_set_property(Pause_menu_check_box_image.text_h, "wrap_width", menu_data.image_offset.text.wrap)
end

function pause_menu_populate_chop_shop_vehicle(name, retrieved, dossier, peg, image, cash, respect, current)
	local idx = Pause_info_diversions_sub_menu.num_items 
	local check_color
	local check_it = false
	if current == true then
		Pause_info_diversions_sub_menu.highlighted_item = idx
		if retrieved == false then
			check_color = PAUSE_MENU_GREEN_CHECK_COLOR
		else
			check_color = PAUSE_MENU_RED_CHECK_COLOR
		end
		
		check_it = true
	else
		check_color = PAUSE_MENU_RED_CHECK_COLOR
		if retrieved == true then
			check_it = true
		end
	end
	
	Pause_info_diversions_sub_menu[idx] = { 
		type = PAUSE_MENU_CONTROL_CHECKBOX_IMAGE, label = name,
		on_select = pause_menu_chop_shop_vehicle_select,
		checked = check_it, text = dossier, check_color = check_color,
		peg = peg, image = image .. ".tga", 
		specific_label_top = "CHOP_SHOP_CASH", specific_text_top = format_cash(cash),
		specific_label_bottom = "CHOP_SHOP_RESPECT",  specific_text_bottom = "+" .. respect,
		retrieved = retrieved,
	}	
	
	Pause_info_diversions_sub_menu.num_items = Pause_info_diversions_sub_menu.num_items + 1
end

function pause_menu_checkbox_image_nav(menu_data)
	------------------------------------------
	--	This causes a flicker with the peg
	------------------------------------------
	if Pause_menu_checkbox_image_peg ~= 0 then
		vint_set_property(Pause_menu_check_box_image.image_h, "visible", false)
		peg_unload(Pause_menu_checkbox_image_peg)
	end
	
	Pause_menu_checkbox_image_peg = menu_data[menu_data.highlighted_item].peg

	peg_load(Pause_menu_checkbox_image_peg)

	vint_set_property(Pause_menu_check_box_image.image_h, "anchor", Pause_menu_checkbox_image_width, menu_data.header_height + menu_data.image_offset.y)
	vint_set_property(Pause_menu_check_box_image.bitmap_h, "image", menu_data[menu_data.highlighted_item].image)
	vint_set_property(Pause_menu_check_box_image.text_h, "text_tag", menu_data[menu_data.highlighted_item].text)
	
	if menu_data[menu_data.highlighted_item].specific_text_top ~= nil then
		vint_set_property(Pause_menu_check_box_image.sp_text_h, "visible", true)
		vint_set_property(Pause_menu_check_box_image.sp_text_h, "anchor", menu_data.image_offset.specific_text.x, menu_data.image_offset.specific_text.y)
		vint_set_property(Pause_menu_check_box_image.sp_text_h, "rotation", menu_data.image_offset.specific_text.rot)		
		
		vint_set_property(Pause_menu_check_box_image.sp_label_top_h, "text_tag", menu_data[menu_data.highlighted_item].specific_label_top)
		vint_set_property(Pause_menu_check_box_image.sp_text_top_h, "text_tag", menu_data[menu_data.highlighted_item].specific_text_top)
		
		vint_set_property(Pause_menu_check_box_image.sp_label_top_h, "visible", true)
		vint_set_property(Pause_menu_check_box_image.sp_text_top_h, "visible", true)

		if menu_data[menu_data.highlighted_item].specific_text_bottom ~= nil then
			vint_set_property(Pause_menu_check_box_image.sp_label_bottom_h, "visible", true)
			vint_set_property(Pause_menu_check_box_image.sp_label_bottom_h, "text_tag", menu_data[menu_data.highlighted_item].specific_label_bottom)
			
			vint_set_property(Pause_menu_check_box_image.sp_text_bottom_h, "visible", true)
			vint_set_property(Pause_menu_check_box_image.sp_text_bottom_h, "text_tag", menu_data[menu_data.highlighted_item].specific_text_bottom)
		else
			vint_set_property(Pause_menu_check_box_image.sp_label_bottom_h, "visible", false)
			vint_set_property(Pause_menu_check_box_image.sp_text_bottom_h, "visible", false)
		end
		
	else
		vint_set_property(Pause_menu_check_box_image.specific_text_h, "visible", false)
	end
	
	vint_set_property(Pause_menu_check_box_image.text_h, "visible", true)
	vint_set_property(Pause_menu_check_box_image.image_h, "visible", true)
	vint_set_property(Pause_menu_check_box_image.image_h, "depth", -20)
end

function pause_menu_checkbox_image_post_show(menu_data)
	pause_menu_control_checkbox_image_resize_select_bar(menu_data)
--	vint_set_property(Pause_menu_check_box_image.text_h, "anchor", menu_data.image_offset.text.x, menu_data.image_offset.text.y)
	vint_set_property(Pause_menu_check_box_image.image_h, "anchor", Pause_menu_checkbox_image_width + 900, menu_data.image_offset.text.y)
--	vint_set_property(Pause_menu_check_box_image.text_h, "anchor", Pause_menu_checkbox_image_width, menu_data.image_offset.text.y)
	pause_menu_checkbox_image_nav(menu_data)
end

function pause_menu_checkbox_image_release(menu_data)
	if Pause_menu_checkbox_image_peg ~= 0 then
		peg_unload(Pause_menu_checkbox_image_peg)
		Pause_menu_checkbox_image_peg = 0;
	end
	
	vint_set_property(Pause_menu_check_box_image.image_h, "visible", false)
end


----------------------[ Collection ]----------------------

function pause_menu_build_collection_menu(menu_data)
	Pause_info_collection_menu.num_items = 0
	
	vint_dataresponder_request("pause_menu_populate", Pause_info_menu_population_data[9].callback, 0, 9)
end

function pause_menu_populate_collection(value)
	local idx = Pause_info_collection_menu.num_items
	
	Pause_info_collection_menu[idx].value = value 
		
	Pause_info_collection_menu.num_items = Pause_info_collection_menu.num_items + 1
end

----------------------[ Unlockables ]----------------------
function pause_menu_populate_player_unlockables(display_name, event_text)
	local idx = Pause_info_unlockables_sub_menu.num_items
	
	Pause_info_unlockables_sub_menu[idx] = { label = display_name, show_value = true, value = event_text, type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, get_width = pause_menu_stat_get_width }
	
	Pause_info_unlockables_sub_menu.num_items = Pause_info_unlockables_sub_menu.num_items + 1
end

----------------------[ Achievements ]----------------------
function pause_menu_do_achievements()
	pause_menu_open_achievements()
end

----------------------[ Help ]----------------------
function pause_menu_populate_help_categories(title_tag)
	local idx = Pause_info_help_menu.num_items
	
	Pause_info_help_menu[idx] = { label = title_tag, type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_help_topics_menu, id = 12 }
	Pause_info_help_menu.num_items = Pause_info_help_menu.num_items + 1
end

function pause_menu_populate_help_topics(title_tag)
	local idx = Pause_info_help_topics_menu.num_items
	
	Pause_info_help_topics_menu[idx] = { label = title_tag, type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_help_sub_menu, id = 13 }
	Pause_info_help_topics_menu.num_items = Pause_info_help_topics_menu.num_items + 1
end

function pause_menu_prep_help_menu(menu_data)
	menu_data.get_width = pause_menu_control_help_text_get_width
	menu_data.get_height = pause_menu_control_help_text_get_height
	menu_data.on_post_show = pause_menu_finalize_help
	menu_data.do_not_rebuild_previous = true
	
	-- Destroy the old page group if it still exists
--	if Pause_menu_page.grp_h ~= 0 and Pause_menu_page.grp_h ~= nil then
		--Do not destroy the old page group but reset the target
		--vint_object_destroy(Pause_menu_page.grp_h)
--		Pause_menu_page.grp_h = 0
--	end
	
	--Build a custom header 
--  local header_h = vint_object_clone(vint_object_find("pm_header_nav"), Menu_option_labels.control_parent)
--	local header_label_h = vint_object_find("title", header_h)
--	vint_set_property(header_label_h, "text_tag", menu_data.header_label_str)
--	vint_set_property(header_h, "anchor", 0, 0)
--	vint_set_property(header_h, "visible", true)
	
--	local header_nav_size = 105	--Size of header element
--	Menu_option_labels.header_h = header_h
	
	--reset our standard label string
--	menu_data.header_label_str = nil
	
--	local header_label_width, header_label_height = element_get_actual_size(header_label_h)
	
	--Calculate Header width to include the new header nav object
--	menu_data.header_width = header_nav_size + header_label_width + 20
		
	--	Initialize the new pages
--	Pause_menu_page.max = 1
--	Pause_menu_page.current = 1
	
	--	Display the new page indicator
--	Pause_menu_page.label_h = vint_object_find("nav_id", header_h)
--	vint_set_property(Pause_menu_page.label_h, "visible", false)
--	Pause_menu_page.arrow_e = vint_object_find("pm_arrow_e", header_h)
--	vint_set_property(Pause_menu_page.arrow_e, "visible", false)
--	Pause_menu_page.arrow_w = vint_object_find("pm_arrow_w", header_h)
--	vint_set_property(Pause_menu_page.arrow_w, "visible", false)
--	vint_set_property(Pause_menu_page.label_h, "text_tag", Pause_menu_page.current .. "/" .. Pause_menu_page.max)
	
--	menu_data.on_release = pause_menu_release_page
end

function pause_menu_prep_help_topics(menu_data)
	menu_data.do_not_rebuild_previous = true
end

function pause_menu_finalize_help(menu_data)
		
	--Adjust the page indicator(arrows) in header
	local header_nav_h = vint_object_find("header_nav", Menu_option_labels.header_h)
	local ax, ay = vint_get_property(header_nav_h, "anchor")
	vint_set_property(header_nav_h, "anchor", menu_data.menu_width, ay)
		
	--Set Header line width
	vint_set_property(vint_object_find("header_horz", Menu_option_labels.header_h), "source_se", menu_data.menu_width - 10, 10)
	
	--Hide scroll bar
	menu_scroll_bar_hide()
	
	--	Set the max for the pages and update the numbers
	local w, h = element_get_actual_size(Menu_option_labels[0].real_label_h)
	
	Pause_menu_page.max = ceil(h / PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT)	--	Get the amount of pages we've got.
	-- pause_menu_update_page()
end

function pause_menu_populate_help(description_tag)
	local idx = Pause_info_help_sub_menu.num_items
	Pause_info_help_sub_menu[idx] = { label = description_tag, type = PAUSE_MENU_CONTROL_HELP_TEXT }
	Pause_info_help_sub_menu.num_items = 1	--	Should never be more than one
	Pause_info_help_sub_menu.btn_tips = Pause_menu_back_only
end


--------------------------------
--------[ OPTIONS MENU ]-------- 
--------------------------------
function pause_menu_quit_game_confirm(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		Quit_game = true
		Menu_fade_to_black = true
		pause_menu_exit()
	end
end

function pause_menu_quit_game()
	if mp_is_enabled() == true then
		dialog_box_confirmation("PAUSE_MENU_QUIT_TITLE","QUIT_GAME_TEXT_SHORT","pause_menu_quit_game_confirm")
	else
		dialog_box_confirmation("PAUSE_MENU_QUIT_TITLE","QUIT_GAME_TEXT_FULL","pause_menu_quit_game_confirm")
	end
end

function pause_menu_options_exit_confirm()
	Pause_menu_swap_to_map = false
	if pause_menu_options_is_dirty() == false then
		pause_menu_exit()
		return
	end	
	Pause_menu_exit_after = true
	local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "PAUSE_MENU_REVERT", [2] = "CONTROL_CANCEL" }
	dialog_box_open("MENU_TITLE_NOTICE", "PLAYER_CREATION_SAVE_CHANGES", options, "pause_menu_option_accept_changes", 0, DIALOG_PRIORITY_ACTION)
end

function pause_menu_options_submenu_exit_confirm(menu_label, menu_data)
	pause_menu_option_revert(menu_label, menu_data);  
end

function pause_menu_options_swap_confirm()
	if Pause_menu_no_swap == true then
		return
	end
	
	if pause_menu_can_swap() == false then
		return
	end
	
	Pause_menu_swap_to_map = true
	if pause_menu_options_is_dirty() == false then
		pause_menu_exit()
		return
	end
	Pause_menu_exit_after = true
	local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "PAUSE_MENU_REVERT", [2] = "CONTROL_CANCEL" }
	dialog_box_open("MENU_TITLE_NOTICE", "PLAYER_CREATION_SAVE_CHANGES", options, "pause_menu_option_accept_changes", 0, DIALOG_PRIORITY_ACTION)
end	

function pause_menu_option_accept()
	pause_menu_option_accept_changes(0, DIALOG_ACTION_CLOSE)
end

function pause_menu_option_revert(menu_label, menu_data)
	if pause_menu_options_is_dirty() == true then
		local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "PAUSE_MENU_REVERT", [2] = "CONTROL_CANCEL" }
		dialog_box_open("MENU_TITLE_NOTICE", "PLAYER_CREATION_SAVE_CHANGES", options, "pause_menu_option_accept_changes", 0, DIALOG_PRIORITY_ACTION)
	else
		if Pause_menu_current_option_menu == PAUSE_MENU_DISPLAY_ID then
			Menu_active[2].initialized = nil
			Menu_active[3].initialized = nil
		end
		
		if Pause_menu_option_horz_swap_menu ~= -1 then
			menu_horz_do_nav(Pause_menu_option_horz_swap_menu)
			menu_show(Menu_horz_active[Pause_menu_option_horz_swap_menu].sub_menu, MENU_TRANSITION_SWAP)
			Pause_menu_option_horz_swap_menu = -1
		else
			menu_show(Pause_options_menu, MENU_TRANSITION_SWEEP_RIGHT)
		end
		audio_play(Menu_sound_back)
	end
end

function pause_menu_option_revert_adv(menu_label, menu_data)
	if pause_menu_options_is_dirty() == true then
		local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "PAUSE_MENU_REVERT", [2] = "CONTROL_CANCEL" }
		dialog_box_open("MENU_TITLE_NOTICE", "PLAYER_CREATION_SAVE_CHANGES", options, "pause_menu_option_accept_changes_adv", 0, DIALOG_PRIORITY_ACTION)
	else
		if Pause_menu_option_horz_swap_menu ~= -1 then
			menu_horz_do_nav(Pause_menu_option_horz_swap_menu)
			menu_show(Menu_horz_active[Pause_menu_option_horz_swap_menu].sub_menu, MENU_TRANSITION_SWAP)
			Pause_menu_option_horz_swap_menu = -1
		else
			menu_show(Pause_display_menu_PC, MENU_TRANSITION_SWEEP_RIGHT)
		end
		audio_play(Menu_sound_back)
	end
end

function pause_menu_option_accept_horz(horz_selection)
	Pause_menu_option_horz_swap_menu = horz_selection
	pause_menu_option_revert()
end

function pause_menu_option_accept_changes(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then	-- Accept
		pause_menu_accept_options(Pause_menu_current_option_menu)
		if Pause_menu_current_option_menu == PAUSE_MENU_DISPLAY_ID then
			Menu_active[2].initialized = nil
			Menu_active[3].initialized = nil
		end
		
		if Pause_menu_option_horz_swap_menu ~= -1 then
			menu_horz_do_nav(Pause_menu_option_horz_swap_menu)
			menu_show(Menu_horz_active[Pause_menu_option_horz_swap_menu].sub_menu, MENU_TRANSITION_SWAP)
			Pause_menu_option_horz_swap_menu = -1
		else
			if Pause_menu_exit_after == true then
				pause_menu_exit()
				return
			end
			
			menu_show(Pause_options_menu, MENU_TRANSITION_SWEEP_RIGHT)
		end
		audio_play(Menu_sound_back)
	elseif result == 1 then -- Revert
		pause_menu_revert_options(Pause_menu_current_option_menu)
		if Pause_menu_exit_after == true then
			pause_menu_exit()
			return
		end
		
		if Pause_menu_current_option_menu == PAUSE_MENU_DIFFICULTY_ID then
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_options", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DIFFICULTY_ID, false)
			Menu_active.highlighted_item = Pause_menu_current_difficulty
	
		elseif Pause_menu_current_option_menu == PAUSE_MENU_CONTROL_ID then
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_options", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_CONTROL_ID, false)
		elseif Pause_menu_current_option_menu == PAUSE_MENU_DISPLAY_ID then
			Menu_active[2].initialized = nil
			Menu_active[3].initialized = nil
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_display", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DISPLAY_ID, false)
		elseif Pause_menu_current_option_menu == PAUSE_MENU_AUDIO_ID then
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_audio", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_AUDIO_ID, false)
		end
		menu_update_labels()
		menu_update_nav_bar(Menu_active.highlighted_item)

--		audio_play(Menu_sound_back)
	end
	
	Pause_menu_exit_after = false
	Pause_menu_swap_to_map = false
end

function pause_menu_control_scheme_width(menu_data)
	local w,h = vint_get_property(Pause_menu_control_scheme_data.grp_h, "screen_size")
	
	return w * Menu_scaler
end

function pause_menu_control_scheme_height(menu_data)
	return PAUSE_MENU_CHECKBOX_IMAGE_HEIGHT
end

function pause_menu_exit_control_scheme(menu_data)
	if Pause_menu_control_scheme_data.grp_h ~= 0 then
		vint_object_destroy(Pause_menu_control_scheme_data.grp_h)
		Pause_menu_control_scheme_data.grp_h = 0
	end
	
	if Pause_menu_controller_image_peg ~= 0 then
		peg_unload(Pause_menu_controller_image_peg)
		Pause_menu_controller_image_peg = 0
	end
	
	if Pause_menu_control_scheme_data.thread_h ~= nil then
		thread_kill(Pause_menu_control_scheme_data.thread_h)
		Pause_menu_control_scheme_data.thread_h = nil
	end
	
	pause_menu_control_scheme_init(false)
end

function pause_menu_control_scheme_adjust_tags()
	local click_handles = {
		left = {
			[0] = vint_object_find("3_lbl", Pause_menu_control_scheme_data.grp_h),
			[1] = vint_object_find("4_lbl", Pause_menu_control_scheme_data.grp_h),
		},

		right = {
			[0] = vint_object_find("16_lbl", Pause_menu_control_scheme_data.grp_h),	-- STATIC
			[1] = vint_object_find("17_lbl", Pause_menu_control_scheme_data.grp_h),
		}
	}
	
	local text_handles = {
		left = {
			[0] = vint_object_find("3_txt", Pause_menu_control_scheme_data.grp_h),
			[1] = vint_object_find("4_txt", Pause_menu_control_scheme_data.grp_h),
		},

		right = {
			[0] = vint_object_find("16_txt", Pause_menu_control_scheme_data.grp_h),	-- STATIC
			[1] = vint_object_find("17_txt", Pause_menu_control_scheme_data.grp_h),
		}
	}
	
	local x,y
	local w,h
	local max_w = 0
	
	-- Find max width on the left
	for i = 0, 1 do 
		if i ~= 0 then
			if get_platform() == "PS3" then
				vint_set_property(click_handles.left[i], "text_tag", "L3")
			else
				vint_set_property(click_handles.left[i], "text_tag", "PAUSE_MENU_CONTROL_CLICK")
			end
		end
		
		w,h = element_get_actual_size(click_handles.left[i])
		
		if w > max_w then
			max_w = w
		end
	end

	-- Adjust tags
	max_w = max_w + 5
	for i = 0, 1 do
		x,y = vint_get_property(text_handles.left[i], "anchor")
		vint_set_property(text_handles.left[i], "anchor", max_w, y)
	end

	-- Find max width on the right
	max_w = 0
	for i = 0, 1 do 
		if i ~= 0 then
			if get_platform() == "PS3" then
				vint_set_property(click_handles.right[i], "text_tag", "R3")
			else
				vint_set_property(click_handles.right[i], "text_tag", "PAUSE_MENU_CONTROL_CLICK")
			end
		end
		
		w,h = element_get_actual_size(click_handles.right[i])
		
		if w > max_w then
			max_w = w
		end
	end
	
	-- Adjust tags
	max_w = max_w + 5
	for i = 0, 1 do
		x,y = vint_get_property(text_handles.right[i], "anchor")
		x = vint_get_property(click_handles.right[i], "anchor")
		x = x - max_w
		vint_set_property(text_handles.right[i], "anchor", x, y)
	end
	
	
end

function pause_menu_build_control_scheme_menu(menu_data)
	local idx = Menu_active.highlighted_item
	menu_data.header_label_str = Menu_active[idx].label
	
	local which_controller, which_scheme, num_buttons = pause_menu_control_scheme_init(true, idx)
	local grp_h = 0
	
	if which_controller == 0 then
		Pause_menu_controller_image_peg = "ui_controls_360"
		peg_load(Pause_menu_controller_image_peg)
		grp_h = vint_object_clone(vint_object_find("ctrls_360"), Menu_option_labels.control_parent)
	else 
		Pause_menu_controller_image_peg = "ui_controls_ps3"
		peg_load(Pause_menu_controller_image_peg)
		grp_h = vint_object_clone(vint_object_find("ctrls_PS3"), Menu_option_labels.control_parent)
	end
	
	-- Anchor it
	local x, y = vint_get_property(Menu_option_labels[0].label_h, "anchor")
	local w, h = element_get_actual_size(Menu_option_labels[0].label_h)
	
	vint_set_property(grp_h, "anchor", x, y + h)
	vint_set_property(grp_h, "visible", true)

	Pause_menu_controller = { 
		["L1"] 						= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("1_txt", grp_h), label_h = vint_object_find("1_lbl", grp_h) } },
		["L2"] 						= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("0_txt", grp_h), label_h = vint_object_find("0_lbl", grp_h) } },
		["analog left"] 			= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("3_txt", grp_h), label_h = vint_object_find("3_lbl", grp_h) } },
		["analog left click 1"]	= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("4_txt", grp_h), label_h = vint_object_find("4_lbl", grp_h) } },
		["analog left click 2"]	= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = 0, label_h = 0 } },
		["dpad up"]					= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("6_txt", grp_h), label_h = vint_object_find("6_lbl", grp_h) } },
		["dpad left"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("7_txt", grp_h), label_h = vint_object_find("7_lbl", grp_h) } },
		["dpad down"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("8_txt", grp_h), label_h = vint_object_find("8_lbl", grp_h) } },
		["dpad right"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("9_txt", grp_h), label_h = vint_object_find("9_lbl", grp_h) } },
		["R2"]						= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("10_txt", grp_h), label_h = vint_object_find("10_lbl", grp_h) } },
		["R1"]						= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("11_txt", grp_h), label_h = vint_object_find("11_lbl", grp_h) } },
		["button y"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("12_txt", grp_h), label_h = vint_object_find("12_lbl", grp_h) } },
		["button b"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("13_txt", grp_h), label_h = vint_object_find("13_lbl", grp_h) } },
		["button a"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("14_txt", grp_h), label_h = vint_object_find("14_lbl", grp_h) } },
		["button x"]				= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("15_txt", grp_h), label_h = vint_object_find("15_lbl", grp_h) } },
		["analog right"]			= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("16_txt", grp_h), label_h = vint_object_find("16_lbl", grp_h) } },
		["analog right click"]	= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("17_txt", grp_h), label_h = vint_object_find("17_lbl", grp_h) } },
		["back"]						= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("19_txt", grp_h), label_h = 0 } },
		["start"]					= { labels = { }, num_buttons = 0, cur_button = 0, 
										  handles = { button_h = vint_object_find("18_txt", grp_h), label_h = 0 } }, 
	}
	
	for idx, val in Pause_menu_controller do
		vint_set_property(val.handles.button_h, "visible", false)
		vint_set_property(val.handles.label_h, "visible", false)
	end

	Pause_menu_control_scheme_data.grp_h = grp_h
	menu_data.get_width = pause_menu_control_scheme_width
	menu_data.get_height = pause_menu_control_scheme_height
	control_scheme_values.cur_value = which_scheme
	
	if Pause_menu_control_scheme_data.thread_h ~= nil then
		thread_kill(Pause_menu_control_scheme_data.thread_h)
	end
		
	
	Pause_menu_control_scheme_data.thread_h = thread_new("pause_menu_control_cycle")
--	Pause_menu_control_scheme_data.tween_h = tween_h
	
	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_scheme", 0, PAUSE_MENU_CONTROL_SCHEME_ID, which_scheme)
	
	pause_menu_control_scheme_adjust_tags()
end

function pause_menu_control_cycle()
	while true do
		delay(2)
		for i, val in Pause_menu_controller do
			local num_buttons = val.num_buttons
			local cur_button = val.cur_button
			
			cur_button = cur_button + 1
			if cur_button >= num_buttons then
				cur_button = 0
			end
			
			if cur_button ~= val.cur_button then
				val.cur_button = cur_button
				vint_set_property(val.handles.button_h, "text_tag", val.labels[cur_button])	
			end
		end
	end
end

function pause_menu_rebuild_control_scheme(menu_label, menu_data)
	for idx, val in Pause_menu_controller do
		vint_set_property(val.handles.button_h, "visible", false)
		vint_set_property(val.handles.label_h, "visible", false)
		val.num_buttons = 0
		val.cur_button = 0
	end

	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_scheme", 0, PAUSE_MENU_CONTROL_SCHEME_ID, control_scheme_values.cur_value)
end

Pause_menu_control_scheme_last = false
function pause_menu_populate_control_scheme(button_name, button)
	local num_buttons = Pause_menu_controller[button_name].num_buttons
	Pause_menu_controller[button_name].labels[num_buttons] = button
	
	if num_buttons == 0 then
		vint_set_property(Pause_menu_controller[button_name].handles.button_h, "visible", true)
		vint_set_property(Pause_menu_controller[button_name].handles.button_h, "text_tag", button)
		
		if Pause_menu_controller[button_name].handles.label_h ~= 0 then 
			vint_set_property(Pause_menu_controller[button_name].handles.label_h, "visible", true)
		end	
	end
	
	Pause_menu_controller[button_name].num_buttons = num_buttons + 1
end

function pause_menu_control_scheme_on_back(menu_label, menu_data)
	pause_menu_change_control_scheme(control_scheme_values.cur_value)
	Pause_menu_control_scheme_last = true
	audio_play(Menu_sound_back)
	menu_show(Menu_active.parent_menu, MENU_TRANSITION_SWEEP_RIGHT)
end

function pause_menu_control_update_scheme(menu_label, menu_data)
	pause_menu_change_control_scheme(control_scheme_values.cur_value)
	Pause_menu_control_scheme_last = true
	menu_show(Menu_active.parent_menu, MENU_TRANSITION_SWEEP_RIGHT)
	audio_play(Menu_sound_back)
end

function pause_menu_build_control_options_menu(menu_data)
	Pause_menu_current_option_menu = PAUSE_MENU_CONTROL_ID
	menu_data.parent_menu = nil

	-- set the label for the six axis sensor. 
	if get_platform() == "PS3" then
		Pause_control_menu[7].label = "SIXAXIS_SENSOR"
	end

	local store_options = true
	if Pause_menu_control_scheme_last == true then
		store_options = false
		Pause_menu_control_scheme_last = false
	end
	
	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_options", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_CONTROL_ID, store_options)
end

function pause_menu_build_difficulty_options_menu (menu_data)
	Pause_menu_current_option_menu = PAUSE_MENU_DIFFICULTY_ID 
	menu_data.parent_menu = nil
	menu_data.highlighted_item = get_current_difficulty()
	Pause_menu_current_difficulty = menu_data.highlighted_item
	if get_is_host() == false then
		for i = 0, menu_data.num_items - 1 do
			if i ~= menu_data.highlighted_item then
				menu_data[i].disabled = true
			end
		end
	end
	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_options", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DIFFICULTY_ID, true)

end

function pause_menu_difficulty_nav(menu_label, menu_data)
	game_difficulty_select(Pause_difficulty_menu[Pause_difficulty_menu.highlighted_item].difficulty_level )	
end


function pause_menu_populate_control_options(invert_y, invert_rot, left_stick, v_sense, h_sense, vibration, crouch_toggle, v_msens, h_msens )
	invert_y_slider_values.cur_value = invert_y
	invert_rot_slider_values.cur_value  = invert_rot
	left_stick_slider_values.cur_value  = left_stick
	Pause_control_menu_PC[6].cur_value = v_sense
	Pause_control_menu_PC[7].cur_value = h_sense
	Pause_control_menu_PC[4].cur_value = v_msens
	Pause_control_menu_PC[5].cur_value = h_msens

	if vibration == true then
		vibration = 1
	else
		vibration = 0
	end
	
	vibration_slider_values.cur_value  = vibration
	crouch_slider_values.cur_value  = crouch_toggle
	
	if Pause_control_menu_PC.highlighted_item == nil then
		Pause_control_menu_PC.highlighted_item = 0
	end
	
	pause_menu_control_options_nav()
end

function  pause_menu_control_options_nav(menu_label, menu_data)
	if Pause_control_menu.highlighted_item == 0 or Pause_control_menu.highlighted_item == 1 then
		Pause_options_btn_tips.a_button.label = "CONTROL_SELECT"
	else 
		Pause_options_btn_tips.a_button.label = "PAUSE_MENU_ACCEPT"
	end
	
	btn_tips_update()
end

function pause_menu_control_options_update_value(menu_label, menu_data)
	local idx = menu_data.id
	if menu_data.type == MENU_ITEM_TYPE_NUM_SLIDER then
		pause_menu_update_option(PAUSE_MENU_CONTROL_ID, idx, false, menu_data.cur_value)
		local h = vint_object_find("value_text", menu_label.control.grp_h)
		vint_set_property(h, "text_tag", floor(menu_data.cur_value * 100) .. "%%")
	else
		local boolean = false
		if menu_data.text_slider_values.cur_value == 1 then
			boolean = true
		end
		pause_menu_update_option(PAUSE_MENU_CONTROL_ID, idx, boolean)
	end
end

function pause_menu_options_on_show()
	pause_menu_init_options()
end

function pause_menu_options_restore_defaults(menu_data)
	local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "CONTROL_CANCEL" }
	dialog_box_open("OPTIONS_MENU_DEFAULTS_TITLE", "OPTIONS_MENU_DEFAULTS_DESC", options, "pm_option_restore_defaults", 0, DIALOG_PRIORITY_ACTION)
end

function pm_option_restore_defaults(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		pause_menu_restore_defaults(Pause_menu_current_option_menu)
		if Pause_menu_current_option_menu == PAUSE_MENU_DIFFICULTY_ID then
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_options", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DIFFICULTY_ID, false)
		elseif Pause_menu_current_option_menu == PAUSE_MENU_CONTROL_ID then
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_control_options", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_CONTROL_ID, false)
		elseif Pause_menu_current_option_menu == PAUSE_MENU_DISPLAY_ID then
			Menu_active[2].initialized = nil
			Menu_active[3].initialized = nil
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_display", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DISPLAY_ID, false)
		elseif Pause_menu_current_option_menu == PAUSE_MENU_AUDIO_ID then
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_audio", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_AUDIO_ID, false)
		end
		menu_update_labels()
		menu_update_nav_bar(Menu_active.highlighted_item)
	end	
end

function pause_menu_build_display_options_menu(menu_data)
	Pause_menu_current_option_menu = PAUSE_MENU_DISPLAY_ID
	menu_data.parent_menu = nil
	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_display", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DISPLAY_ID, true)
end

function pause_menu_brightness_input_override(override)
	if override == true then
		Pause_menu_brightness.input = { 
			vint_subscribe_to_input_event(nil, "nav_left",			"pause_menu_brightness_input", 50),
			vint_subscribe_to_input_event(nil, "nav_right",			"pause_menu_brightness_input", 50),
			vint_subscribe_to_input_event(nil, "select",				"pause_menu_brightness_input", 50),
			vint_subscribe_to_input_event(nil, "back",				"pause_menu_brightness_input", 50),
			vint_subscribe_to_input_event(nil, "all_unassigned",	"pause_menu_brightness_input", 50),
		}

		vint_set_input_params(Pause_menu_brightness.input[1], MENU_NUM_SLIDER_ACCEL_REPEAT, MENU_NUM_SLIDER_ACCEL_FACTOR, MENU_NUM_SLIDER_ACCEL_LIMIT, true)
		vint_set_input_params(Pause_menu_brightness.input[2], MENU_NUM_SLIDER_ACCEL_REPEAT, MENU_NUM_SLIDER_ACCEL_FACTOR, MENU_NUM_SLIDER_ACCEL_LIMIT, true)

	else
	
		if Pause_menu_brightness.input ~= nil then
			for idx, key in Pause_menu_brightness.input  do
				vint_unsubscribe_to_input_event(key)
			end
		end
		
		Pause_menu_brightness.input = nil
	end
end

function pause_menu_brightness_input(target, event, accelleration)
	if menu_input_is_blocked() == true then
		return
	end
	
	if event == "nav_left" then
		local cur_value = Pause_display_menu_PC[0].cur_value
		if cur_value > 0 then
			cur_value = cur_value - (0.01 * accelleration)
		
			if cur_value < 0 then
				cur_value = 0
			end
		
			Pause_display_menu_PC[0].cur_value = cur_value
			audio_play(Menu_sound_value_nav)
			pause_menu_brightness_update_value()
		end
	elseif event == "nav_right" then
		local cur_value = Pause_display_menu_PC[0].cur_value
		
		if cur_value < 1 then
			cur_value = cur_value + (0.01 * accelleration)
		
			if cur_value > 1 then
				cur_value = 1
			end
		
			Pause_display_menu_PC[0].cur_value = cur_value	
			audio_play(Menu_sound_value_nav)
			pause_menu_brightness_update_value()
		end
	elseif event == "back" then
		pause_menu_update_option(PAUSE_MENU_DISPLAY_ID, 0, false, Pause_menu_brightness.old_val)
		Pause_display_menu_PC[0].cur_value = Pause_menu_brightness.old_val
		pause_menu_exit_brightness_screen()
	elseif event == "select" then
		pause_menu_exit_brightness_screen()
	end
	
end

function pause_difficulty_casual_select (menu_label, menu_data)
	game_difficulty_select(DIFFICULTY_CASUAL)
	pause_menu_option_accept()
end

function pause_difficulty_normal_select (menu_label, menu_data)
	game_difficulty_select(DIFFICULTY_NORMAL)
	pause_menu_option_accept()
end

function pause_difficulty_hardcore_select (menu_label, menu_data)
	game_difficulty_select(DIFFICULTY_HARDCORE)
	pause_menu_option_accept()
end

function pause_menu_force_close_brightness_screen()
	vint_set_property(Pause_menu_brightness.screen_h, "visible", false)
	pause_menu_brightness_input_override(false)
end

function pause_menu_display_brightness_screen(menu_label, menu_data)

	Pause_menu_brightness.screen_h = vint_object_find("brightness")
	Pause_menu_brightness.slider_h = vint_object_find("slider", Pause_menu_brightness.screen_h)
	Pause_menu_brightness.thumb_h = vint_object_find("brightness_value", Pause_menu_brightness.slider_h)
	Pause_menu_brightness.value_h = vint_object_find("brightness_value", Pause_menu_brightness.thumb_h)
	Pause_menu_brightness.line_h = vint_object_find("line_bg", Pause_menu_brightness.slider_h)
	
	local image_h = vint_object_find("calibrate_image")
	local text_h = vint_object_find("brightness_text")
	
	local accept_grp_h = vint_object_find("accept")
	local accept_tip_h = vint_object_find("accept_text")
	local accept_button_h = vint_object_find("btn_accept")
	vint_set_property(accept_button_h, "image", get_a_button())
	local cancel_grp_h = vint_object_find("cancel")
	local cancel_tip_h = vint_object_find("cancel_text")
	local cancel_button_h = vint_object_find("btn_cancel")
	vint_set_property(cancel_button_h, "image", get_b_button())
	
	--cancel text anchor and dimensions
	local ctw, cth = element_get_actual_size(cancel_tip_h)
	local btn_size = 34
	local gap = 20

	-- move the cancel btn graphic
	vint_set_property(cancel_button_h, "anchor", -(ctw), 0) 	 
	
	local cbx, cby = vint_get_property(cancel_button_h, "anchor") 	 -- cancel button x, y position
	
	-- move the accept group	
	vint_set_property(accept_grp_h, "anchor", cbx - btn_size - gap, 0) 		 
	
	local atw, ath = element_get_actual_size(accept_tip_h) 			 -- accept text dimensions
	
	-- move the accept btn graphic
	vint_set_property(accept_button_h, "anchor", -(atw), 0)  	 
	
	-- Turn the screen on
	vint_set_property(Pause_menu_brightness.screen_h, "visible", true)
	vint_set_property(Pause_menu_brightness.screen_h, "alpha", 0.0)
	
	--	Load the image
	Pause_menu_calibrate_image_peg = "ui_test_calibrate"
	peg_load(Pause_menu_calibrate_image_peg)	
	vint_set_property(image_h, "image", "ui_test_calibrate.tga")
	
	--	Adjust the text tags and get the min/max for the slider bar
	local w, h = element_get_actual_size(text_h)
	local x, y = vint_get_property(Pause_menu_brightness.slider_h, "anchor")
	vint_set_property(Pause_menu_brightness.slider_h, "anchor", w + 5, y)
	x, y = vint_get_property(Pause_menu_brightness.line_h, "anchor")
	w, h = element_get_actual_size(Pause_menu_brightness.line_h)
	Pause_menu_brightness.max = w - 40
	Pause_menu_brightness.min = x + 20
	
	Pause_menu_brightness.old_val = Pause_display_menu_PC[0].cur_value
	Pause_menu_brightness.value = Pause_display_menu_PC[0].cur_value
	pause_menu_brightness_update_value()
	
	menu_input_block(true)
	-- Grab the input
	pause_menu_brightness_input_override(true)
	
	-- Tween the old one
	local tween_h = menu_create_tween("pause_menu_brightness", Pause_menu_brightness.screen_h, "alpha", 0.2)
	vint_set_property(tween_h, "start_value", 0)	
	vint_set_property(tween_h, "end_value", 1)	
	vint_set_property(tween_h, "end_event", "pm_end_brightness_tween")
	Pause_menu_brightness.tween_h = tween_h
	
	--Hide the button tips if we are in the main menu
	if vint_document_find("main_menu") ~= 0 then
		main_menu_btn_tips_show(false)
	end
end

function pm_end_brightness_tween()
	menu_input_block(false)
	vint_object_destroy(Pause_menu_brightness.tween_h)
end

function pause_menu_brightness_update_value()
	local x, y = vint_get_property(Pause_menu_brightness.thumb_h, "anchor")
	vint_set_property(Pause_menu_brightness.thumb_h, "anchor", (Pause_menu_brightness.max * Pause_display_menu_PC[0].cur_value) + Pause_menu_brightness.min, y)
	vint_set_property(Pause_menu_brightness.value_h, "text_tag", floor(Pause_display_menu_PC[0].cur_value * 100))	--	Set the proper tag
	local w, h = element_get_actual_size(Pause_menu_brightness.value_h)
	local old_w, old_h = element_get_actual_size(Pause_menu_brightness.thumb_h)
	vint_set_property(Pause_menu_brightness.thumb_h, "screen_size", w, old_h)
	pause_menu_update_option(PAUSE_MENU_DISPLAY_ID, 0, false, Pause_display_menu_PC[0].cur_value)
end

function pause_menu_exit_brightness_screen(menu_label, menu_data)
	menu_input_block(true)
	-- Restore input
	pause_menu_brightness_input_override(false)
	
	

	-- Tween the old one
	local tween_h = menu_create_tween("pause_menu_brightness", Pause_menu_brightness.screen_h, "alpha", 0.2)
	vint_set_property(tween_h, "start_value", 1)	
	vint_set_property(tween_h, "end_value", 0)	
	vint_set_property(tween_h, "end_event", "pm_end_brightness_tween_exit")
	Pause_menu_brightness.tween_h = tween_h

	--Restore button tips if on main menu
	if vint_document_find("main_menu") ~= 0 then
		main_menu_btn_tips_show(true)
	end
end

function pm_end_brightness_tween_exit()
	pm_end_brightness_tween()
		
	-- Unload the image
	peg_unload("ui_test_calibrate")
	Pause_menu_calibrate_image_peg = 0
	
	-- Hide the brightness screen
	vint_set_property(Pause_menu_brightness.screen_h, "visible", false)

end

function vsync_gameplay_confirm(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		pause_menu_update_option(PAUSE_MENU_DISPLAY_ID, 2, true)
	else
		vsync_gameplay_slider_values.cur_value = 0
		menu_text_slider_update_value(Menu_option_labels[2], Pause_display_menu[2])
	end
end

function vsync_cutscene_confirm(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		pause_menu_update_option(PAUSE_MENU_DISPLAY_ID, 3, true)
	else
		vsync_cutscene_slider_values.cur_value = 0
		menu_text_slider_update_value(Menu_option_labels[3], Pause_display_menu[3])
	end
end

function pause_menu_display_options_update_value(menu_label, menu_data)
	local idx = menu_data.id
	if menu_data.type == MENU_ITEM_TYPE_NUM_SLIDER then
		pause_menu_update_option(PAUSE_MENU_DISPLAY_ID, idx, false, menu_data.cur_value)
		local h = vint_object_find("value_text", menu_label.control.grp_h)
		vint_set_property(h, "text_tag", floor(menu_data.cur_value * 100) .. "%%")
	else
		local update_menu = true
		local boolean = false

        if get_platform() == "PC" then
			pause_menu_update_option( PAUSE_MENU_DISPLAY_ID, idx, boolean, menu_data.text_slider_values.cur_value )
			vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_display", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DISPLAY_ID, false)

			menu_update_labels()
			menu_update_nav_bar(Menu_active.highlighted_item)

			return
        end



		if menu_data.text_slider_values.cur_value == 1 then
			boolean = true
		end
		if menu_data.initialized == nil or menu_data.initialized == false then
			if boolean == true then
				-- menu_data.initialized = true
				if menu_data.id == 2 then
					dialog_box_confirmation("MENU_TITLE_NOTICE", "MENU_VSYNC_WARNING_TEXT", "vsync_gameplay_confirm")
					update_menu = false
				elseif menu_data.id == 3 then
					dialog_box_confirmation("MENU_TITLE_NOTICE", "MENU_VSYNC_WARNING_TEXT", "vsync_cutscene_confirm")
					update_menu = false;
				end
			end
		end
		if update_menu == true then
			pause_menu_update_option(PAUSE_MENU_DISPLAY_ID, idx, boolean)
		end
	end
end

function pause_menu_display_options_update_value_adv(menu_label, menu_data)
	local idx = menu_data.id
	if menu_data.type == MENU_ITEM_TYPE_NUM_SLIDER then
		pause_menu_update_option(PAUSE_MENU_DISPLAY_ADV_ID, idx, false, menu_data.cur_value)
		local h = vint_object_find("value_text", menu_label.control.grp_h)
		vint_set_property(h, "text_tag", floor(menu_data.cur_value * 100) .. "%%")
	else
		local update_menu = true
		local boolean = false
	        if get_platform() == "PC" then
			pause_menu_update_option(PAUSE_MENU_DISPLAY_ADV_ID, idx, boolean, menu_data.text_slider_values.cur_value)
			return
	        end
		if menu_data.text_slider_values.cur_value == 1 then
			boolean = true
		end
		if menu_data.initialized == nil or menu_data.initialized == false then
			if boolean == true then
				-- menu_data.initialized = true
				if menu_data.id == 2 then
					dialog_box_confirmation("MENU_TITLE_NOTICE", "MENU_VSYNC_WARNING_TEXT", "vsync_gameplay_confirm")
					update_menu = false
				elseif menu_data.id == 3 then
					dialog_box_confirmation("MENU_TITLE_NOTICE", "MENU_VSYNC_WARNING_TEXT", "vsync_cutscene_confirm")
					update_menu = false;
				end
			end
		end
		if update_menu == true then
			pause_menu_update_option(PAUSE_MENU_DISPLAY_ADV_ID, idx, boolean)
		end
	end
end

function pm_bool_to_1(value)
	if value == true then
		return 1
	elseif value == false then
		return 0
	else
		return value
	end
end

function pause_menu_populate_display(gamma, resolution, fullscreen, vsync, quality, subtitles, minimap,ssao,mblur,antial,anisotropy,hdr,shadows,viewdist,dynamiclights,blur,depthoffield)
	Pause_display_menu_PC[0].cur_value = gamma
	resolution_slider_values.cur_value = resolution
	fullscreen_slider_values.cur_value = pm_bool_to_1(fullscreen)
	vsync_slider_values.cur_value = pm_bool_to_1(vsync)
	graphics_quality_slider_values.cur_value = quality
	subtitles_slider_values.cur_value = pm_bool_to_1(subtitles)
	minimap_slider_values.cur_value = pm_bool_to_1(minimap)

	adv_ambient_slider_values.cur_value = ssao
	adv_motion_blur_slider_values.cur_value = pm_bool_to_1(mblur)
	adv_antiali_slider_values.cur_value = antial
	adv_anisotropy_slider_values.cur_value = anisotropy
	adv_hdr_slider_values.cur_value = pm_bool_to_1(hdr)
	adv_shadow_slider_values.cur_value = shadows
	adv_distance_slider_values.cur_value = viewdist
	adv_dynamic_lights_slider_values.cur_value = dynamiclights
	adv_blur_slider_values.cur_value = pm_bool_to_1(blur)
	adv_depthoffield_slider_values.cur_value = pm_bool_to_1(depthoffield)
	
	if Pause_display_menu_PC.highlighted_item == nil then
		Pause_display_menu_PC.highlighted_item = 0
	end
		
	pause_menu_display_options_nav()
end

function  pause_menu_display_options_nav(menu_label, menu_data)
	if Pause_display_menu.highlighted_item == 0 then
		Pause_options_btn_tips.a_button.label = "CONTROL_SELECT"
	else 
		Pause_options_btn_tips.a_button.label = "PAUSE_MENU_ACCEPT"
	end
	
	btn_tips_update()
end

function pause_menu_audio_nav(menu_label, menu_data)
	pause_menu_audio_play_preview(-1)	--	Shut 'er off
end

function pause_menu_audio_options_update_value(menu_label, menu_data)
	local idx = menu_data.id
	if menu_data.type == MENU_ITEM_TYPE_NUM_SLIDER then
		pause_menu_update_option(PAUSE_MENU_AUDIO_ID, idx, false, menu_data.cur_value)
		local h = vint_object_find("value_text", menu_label.control.grp_h)
		vint_set_property(h, "text_tag", floor(menu_data.cur_value * 100) .. "%%")
	else
		pause_menu_update_option(PAUSE_MENU_AUDIO_ID, idx, false, menu_data.text_slider_values.cur_value)
	end
	
	if menu_data.id == 0 then
		pause_menu_audio_play_preview(0) 	-- SFX
	elseif menu_data.id == 2 then
		pause_menu_audio_play_preview(1)	-- VOICE
	end
end

function pause_menu_build_audio_options_menu(menu_data)
	Pause_menu_current_option_menu = PAUSE_MENU_AUDIO_ID
	menu_data.parent_menu = nil
	-- set the label for the six axis sensor. 
	if get_platform() == "PS3" then
	-- the last item is not needed in the PS3 build (the audio player)
		Pause_audio_menu.num_items = 4
	end

	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_audio", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_AUDIO_ID, true)
end

function pause_menu_populate_audio(sound, music, volume, radio_on_entry)
	Pause_audio_menu[0].cur_value = sound 
	Pause_audio_menu[1].cur_value = music
	Pause_audio_menu[2].cur_value = volume 
	vehicle_radio_slider_values.cur_value = radio_on_entry 
end

----------------
-- CELL PHONE --
----------------
Menu_out_tween_h = 0
Cellphone_doc_h = 0
function pause_menu_cellphone_show()
	vint_force_lua_gc()
	vint_document_load("cellphone")
	Cellphone_doc_h = vint_document_find("cellphone")
end

function pause_menu_cellphone_exit()
	local phone_h = vint_object_find("cell_phone", nil, Cellphone_doc_h)
	Menu_out_tween_h = vint_object_create("cell_phone_custom_transition_out", "tween", vint_object_find("root_animation", nil, Cellphone_doc_h), Cellphone_doc_h)
	vint_set_property(Menu_out_tween_h, "duration", 0.15)
	vint_set_property(Menu_out_tween_h, "target_handle", phone_h)
	vint_set_property(Menu_out_tween_h, "target_property", "anchor")
	vint_set_property(Menu_out_tween_h, "start_time", vint_get_time_index(Cellphone_doc_h))
	vint_set_property(Menu_out_tween_h, "is_paused", false)
	vint_set_property(Menu_out_tween_h, "start_value", Menu_active_anchor_end_x, Menu_active_anchor_end_y)
	vint_set_property(Menu_out_tween_h, "end_value", 0 - Menu_active.menu_width, Menu_active_anchor_end_y)
	vint_set_property(Menu_out_tween_h, "end_event", "pause_menu_cellphone_exit_final")
end

function pause_menu_cellphone_exit_final()
	vint_object_destroy(Menu_out_tween_h)
	vint_document_unload(Cellphone_doc_h)
	Cellphone_doc_h = 0
end
----------------------
-- STATION SELECTOR --
----------------------

-- 
-- 
Station_Images = {
   ["105.0 EZZZY FM"] = "ui_radio_105_ezzzy",
	["89.0 ULTOR FM"] = "ui_radio_89_ultor",
	["RADIO FREE STILWATER 87.6"] = "ui_radio_876_rfs", -- Cut probably 
	["89.0 GENERATION X"] = "ui_radio_89_gen_x",
	["95.4 KRhyme FM"] = "ui_radio_954_khryme",
	["97.6 K12 FM"] = "ui_radio_976_k12",
	["FUNK 98.4"] = "ui_radio_984_funk",
	["99.0 THE UNDERGROUND"] = "ui_radio_99_underground",
	["101.69 SIZZURP FM"] = "ui_radio_10169_sizzurp",
	["102.4 KLASSIC FM"] = "ui_radio_1024_klassic", 
	["103.6 420 FM"] = "ui_radio_1036_four_20",
	["105.0 THE WORLD"] = "ui_radio_105_world",
	["THE KRUNCH 106.66"] = "ui_radio_10666_krunch",
	["107.77 THE MIX FM"] = "ui_radio_10777_the_mix",
	["108.0 WMD KBOOM FM"] = "ui_radio_108_wmd_kboom", -- Cut probably
}

Station_Genres = {
	["105.0 EZZZY FM"] = "RADIO_STATION_GENRE_EZZZY",
	["89.0 ULTOR FM"] = "RADIO_STATION_GENRE_ULTOR",
	["RADIO FREE STILWATER 87.6"] = "RADIO_STATION_GENRE_RFS", 
	["89.0 GENERATION X"] = "RADIO_STATION_GENRE_GEN_X",
	["95.4 KRhyme FM"] = "RADIO_STATION_GENRE_KRHYME",
	["97.6 K12 FM"] = "RADIO_STATION_GENRE_K12FM",
	["FUNK 98.4"] = "RADIO_STATION_GENRE_FUNK",
	["99.0 THE UNDERGROUND"] = "RADIO_STATION_GENRE_UNDERGROUND",
	["101.69 SIZZURP FM"] = "RADIO_STATION_GENRE_SIZZURP",
	["102.4 KLASSIC FM"] = "RADIO_STATION_GENRE_KLASSIC", 
	["103.6 420 FM"] = "RADIO_STATION_GENRE_FOUR_20",
	["105.0 THE WORLD"] = "RADIO_STATION_GENRE_THE_WORLD",
	["THE KRUNCH 106.66"] = "RADIO_STATION_GENRE_KRUNCH",
	["107.77 THE MIX FM"] = "RADIO_STATION_GENRE_MIX",
	["108.0 WMD KBOOM FM"] = "RADIO_STATION_GENRE_KBOOM",
}

Station_Songs = {
	["105.0 EZZZY FM"] = "Bachelor Samba",
	["89.0 ULTOR FM"] = "Misery Business",
	["RADIO FREE STILWATER 87.6"] = "RADIO_STATION_GENRE_RFS", 
	["89.0 GENERATION X"] = "Misery Business",
	["95.4 KRhyme FM"] = "Ridin In That Black Joint",
	["97.6 K12 FM"] = "Over and Over",
	["FUNK 98.4"] = "Love Fades",
	["99.0 THE UNDERGROUND"] = "Shoot The Runner",
	["101.69 SIZZURP FM"] = "RADIO_STATION_GENRE_SIZZURP",
	["102.4 KLASSIC FM"] = "Ride of the Valkyries", 
	["103.6 420 FM"] = "Ganja Smuggling",
	["105.0 THE WORLD"] = "Bangara Dance",
	["THE KRUNCH 106.66"] = "Resurrection",
	["107.77 THE MIX FM"] = "Everybody Wants To Rule The World",
	["108.0 WMD KBOOM FM"] = "RADIO_STATION_GENRE_KBOOM",
}

function pause_menu_station_exit(menu_data)
	peg_unload("ui_radio_logos")
	radio_station_preview(true)
	menu_grid_release(Pause_menu_station_selection[0])
end

function pause_menu_station_build_footer(menu_data)
	local grp = vint_object_clone(vint_object_find("station_footer"), Menu_option_labels.control_parent)
	vint_set_property(grp, "visible", true)

	if menu_data.footer ~= nil and menu_data.footer.footer_grp ~= nil and menu_data.footer.footer_grp ~= 0 then
		vint_object_destroy(menu_data.footer.footer_grp)
	end

	menu_data.footer = { }
	menu_data.footer.footer_grp = grp
	
	menu_data.footer.label_h = vint_object_find("station_label", grp)
	menu_data.footer.genre_h = vint_object_find("genre_label", grp)
	
	vint_set_property(menu_data.footer.label_h, "tint", MENU_FOOTER_CASH_NORMAL_COLOR.R, MENU_FOOTER_CASH_NORMAL_COLOR.G, MENU_FOOTER_CASH_NORMAL_COLOR.B)
end

function pause_menu_station_update_footer(label, genre)
	vint_set_property(Pause_menu_station_selection.footer.label_h, "text_tag", label)
	vint_set_property(Pause_menu_station_selection.footer.genre_h, "text_tag", genre)
end

function pause_menu_station_show(menu_data)
	local menu_item = menu_data[0]
	
	-- Reset the swatches
	menu_item.swatches = { num_swatches = 0 }
	local swatches = menu_item.swatches 
	swatches.num_swatches = 0
	
	-- Load the peg
	peg_load("ui_radio_logos")
	
	-- Get the data
	vint_dataresponder_request("pause_menu_populate", "pause_menu_station_build", 0, 19)
	
	local master_swatch = vint_object_find("swatch_radio")
	vint_set_property(master_swatch, "visible", true)
	menu_grid_show(menu_data, menu_item, master_swatch)		

	pause_menu_station_build_footer(menu_data)
	
	pause_menu_station_update_footer(swatches[0].label_str, swatches[0].genre)
	radio_station_preview(false, swatches[0].track_name)
	vint_set_property(vint_object_find("icon", swatches[0].swatch_h), "tint", 1.0, 1.0, 1.0)
end

function pause_menu_station_build(display_name, selected, identifier, index)
	if identifier == "OFF" then
		return
	end
	
	local swatches = Pause_menu_station_selection[0].swatches
	
	local genre = nil
	local bitmap_name = nil
	
	swatches[swatches.num_swatches] = 
	{ label_str = display_name, swatch_str = Station_Images[identifier], genre = Station_Genres[identifier], track_name = Station_Songs[identifier], selected = selected, index = index}
	swatches.num_swatches = swatches.num_swatches + 1	
end

function pause_menu_station_select(menu_label, menu_data)
	local swatches = menu_data.swatches
	local idx = menu_data.cur_row * menu_data.num_cols + menu_data.cur_col
	
	if idx < swatches.num_swatches then
		swatches[idx].selected = swatches[idx].selected == false
		radio_station_disable(swatches[idx].index, swatches[idx].selected)
		pause_menu_station_update_swatch(swatches[idx])
		vint_set_property(vint_object_find("icon", swatches[idx].swatch_h), "tint", 1.0, 1.0, 1.0)
	end
	
end
 
function pause_menu_station_nav(menu_label, menu_data)
	local swatches = menu_data.swatches
	local idx = menu_data.cur_row * menu_data.num_cols + menu_data.cur_col
	
	if idx < swatches.num_swatches then
		pause_menu_station_update_footer(swatches[idx].label_str, swatches[idx].genre)
		radio_station_preview(false, swatches[idx].track_name)
		vint_set_property(vint_object_find("icon", swatches[idx].swatch_h), "tint", 1.0, 1.0, 1.0)
	end
end

function pause_menu_station_leave_swatch(swatch)
	local icon_h = vint_object_find("icon", swatch.swatch_h)
	
	if swatch.selected == false then
		vint_set_property(icon_h, "tint", 0.5, 0.5, 0.5)
	else
		vint_set_property(icon_h, "tint", 0.7, 0.7, 0.7)
	end
end

function pause_menu_station_update_swatch(swatch)
	local deselect_h = vint_object_find("deselected", swatch.swatch_h)
	local icon_h = vint_object_find("icon", swatch.swatch_h)
	if swatch.selected == false then
		vint_set_property(deselect_h, "visible", true)
		vint_set_property(deselect_h, "alpha", 1.0)
		vint_set_property(deselect_h, "render_mode", "default")
		vint_set_property(deselect_h, "scale", 1.25, 1.25)
		vint_set_property(icon_h, "tint", 0.5, 0.5, 0.5)
	else
		vint_set_property(deselect_h, "visible", false)
		vint_set_property(icon_h, "tint", 0.7, 0.7, 0.7)
	end
	
	vint_set_property(vint_object_find("icon_highlight", swatch.swatch_h), "visible", false)
	vint_set_property(vint_object_find("bg", swatch.swatch_h), "visible", false)
	vint_set_property(vint_object_find("shadow", swatch.swatch_h), "visible", false)
end

-----------------------------------
--------[ CUSTOM CONTROLS ]--------
-----------------------------------
--------------------------------------[ OBJECTIVE_TEXT_LINE ]--------------------------------------
function pause_menu_control_objective_text_line_show(menu_label, menu_data)
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE then
			-- this isn't a PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE so release it
			menu_release_control(control)
			control = nil
		end
	end

	if control == nil then
		local control_h = vint_object_clone(vint_object_find("pm_objective_text_line"), Menu_option_labels.control_parent)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE, is_highlighted = false }
		menu_label.original_anchor = { }
		menu_label.original_anchor.x, menu_label.original_anchor.y  = vint_get_property(vint_object_find("pm_objective_text_line_label"), "anchor")
	end

	menu_label.control = control
	
	--	Hide the O.G. Label
	vint_set_property(menu_label.label_h, "visible", false)
	
	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x, menu_label.anchor_y)
	vint_set_property(control.grp_h, "depth", menu_label.depth)
	
	--	Set the color and text_tag
	menu_label.real_label_h = vint_object_find("pm_objective_text_line_label", control.grp_h)
	vint_set_property(menu_label.real_label_h, "text_tag", menu_data.label)
	
	vint_set_property(menu_label.real_label_h, "tint", 0.623, 0.635, 0.643)
	
	vint_set_property(menu_label.real_label_h, "visible", true)
	menu_label.checkbox_h = vint_object_find("pm_objective_checkbox", control.grp_h)
	menu_label.check_h = vint_object_find("pm_objective_checkmark", control.grp_h)
	vint_set_property(menu_label.checkbox_h, "tint", 0.364, 0.368, 0.376)

	--	Set whether or not it's checked.
	if menu_data.checked == nil then
		vint_set_property(menu_label.real_label_h, "anchor", 6, 0)
		-- hide the check box		
		vint_set_property(menu_label.checkbox_h, "visible", false)
		vint_set_property(menu_label.check_h, "visible", false)
	else
		vint_set_property(menu_label.real_label_h, "anchor", menu_label.original_anchor.x, menu_label.original_anchor.y)
		vint_set_property(menu_label.checkbox_h, "visible", true)
		if menu_data.checked == true then
			vint_set_property(menu_label.check_h, "visible", true)
			vint_set_property(menu_label.check_h, "tint", menu_data.check_color.R, menu_data.check_color.G, menu_data.check_color.B)
		else
			vint_set_property(menu_label.real_label_h, "alpha", 1.0)
			vint_set_property(menu_label.check_h, "visible", false)
		end
	end
end

--------------------------------------[ OBJECTIVE_WRAP_LINE ]--------------------------------------

-- for the data responder
function pause_menu_objective_menu_show(menu_data)
	menu_scroll_bar_hide()
	menu_data.header_label_str = "INFO_OBJECTIVES_TITLE"
	--	Populate the menu
	vint_dataresponder_request("pause_menu_objectives_populate", "pause_menu_populate_objectives", OBJECTIVES_MAX_ITEMS)
	
	local menu_label = Menu_option_labels[0]
	
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_OBJECTIVE_WRAP_LINE then
			-- this isn't a PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE so release it
			menu_release_control(control)
			control = nil
		end
	end

	vint_set_property(menu_label.label_h, "text_tag", "")	
	
	if control == nil then
		local control_h = vint_object_clone(vint_object_find("pm_objectives_control"), Menu_option_labels.control_parent)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_OBJECTIVE_WRAP_LINE, is_highlighted = false, label = ""}
		menu_label.control = control		
		
--		menu_label.original_anchor = { }
		
		menu_label.objective_list = { }
		
		menu_label.clip_object = vint_object_find("pm_objective_clip", control.grp_h) 
		
		vint_set_property(menu_label.clip_object, "clip_size", 565.0, OBJECTIVE_MAX_VISIBLE_PIXELS)
		menu_label.objective_list.line_h = vint_object_find("pm_objective_wrap_line", menu_label.clip_object)

		--	Create the labels
		menu_label.objective_list.objective_lines 		= { [0] = { label_h = menu_label.objective_list.line_h } }
	end

	--	Create the labels
	-- menu_label.edit.option_labels 		= { [0] = { label_h = menu_label.objective_list.line_h } }
	--vint_get_property(menu_label.objective_list.line_h, "anchor")
	
	
	

	local current_y = 0
	Pause_info_objective_lines.total_y  = 0
	
	local obj_lines = menu_label.objective_list.objective_lines
	for i = 0, Pause_info_objective_lines.num_lines - 1 do
		local line_data = obj_lines[i]

		if line_data == nil then
			obj_lines[i] = { label_h	= vint_object_clone(menu_label.objective_list.line_h) }
			line_data = obj_lines[i]
		end
		
		local text_box_h = vint_object_find("pm_objective_wrap_line_label", line_data.label_h)
		
		vint_set_property(text_box_h, "text_tag", Pause_info_objective_lines[i].text_string)
		vint_set_property(text_box_h, "tint", 0.623, 0.635, 0.643)
		local dummy_x, size_y = element_get_actual_size(text_box_h)


		current_y = current_y + size_y
		
		Pause_info_objective_lines.current_y = current_y
		
		-- we need the max as well.
		Pause_info_objective_lines.total_y = Pause_info_objective_lines.total_y + size_y
		
		if (current_y > OBJECTIVE_MAX_VISIBLE_PIXELS) then
			current_y = OBJECTIVE_MAX_VISIBLE_PIXELS
			Pause_info_objective_lines.more_lines = true
			Pause_info_objective_lines.current_y = OBJECTIVE_MAX_VISIBLE_PIXELS
			vint_set_property(menu_label.clip_object, "clip_enabled", true)
		end
	end
--	vint_set_property(menu_label.objective_list.objective_lines[0].label_h, "anchor", text_pos_x, current_y )
	
end

function pause_menu_objective_menu_release(menu_data)
	
	local menu_label = Menu_option_labels[0]
	
	if menu_label.control ~= nil then
		vint_object_destroy(menu_label.control) 
	end
	
	if menu_label.objective_list ~= nil then 
	
		local obj_lines = menu_label.objective_list.objective_lines
		for i = 0, Pause_info_objective_lines.num_lines - 1 do
			local line_data = obj_lines[i]
			vint_object_destroy(line_data.label_h)
		end
	end
	
	Pause_info_objective_lines.num_lines = 0
	Pause_info_objective_lines.current_line = 0
end

	

function pause_menu_control_objective_wrap_line_show(menu_label, menu_data)
	
	-- we need to move this back because there is an unknown offset.
	local clip_y = -20
	-- TODO: you probably want a small offset here instead of 0. 
	vint_set_property(menu_label.clip_object, "anchor", 6, clip_y )
			
	
	local current_x = 0
	local current_y = 0
	
	local total_y = 0
	local real_y = 0
	
	local first_vis_item_location = -1
	
	local control = menu_label.control
		
	Pause_info_objective_lines.more_lines = false
	local obj_lines = menu_label.objective_list.objective_lines
	for i = 0, Pause_info_objective_lines.num_lines - 1 do
		local line_data = obj_lines[i]
		local text_box_h = vint_object_find("pm_objective_wrap_line_label", line_data.label_h)	
		
		local dummy_x, size_y = element_get_actual_size(text_box_h)
			
		if(i >= Pause_info_objective_lines.current_line and  total_y  < OBJECTIVE_MAX_VISIBLE_PIXELS and i < Pause_info_objective_lines.num_lines) then
			vint_set_property(line_data.label_h, "visible", true)
			if (first_vis_item_location == -1) then
				first_vis_item_location = real_y
			end
				
			local dummy_x, size_y = element_get_actual_size(text_box_h)
			-- move it down to the next line.
			vint_set_property(line_data.label_h, "anchor", current_x, current_y )
			if ( i == 0 ) then 
				vint_set_property(vint_object_find("pm_objective_wrap_checkbox", line_data.label_h), "visible", false)
				vint_set_property(vint_object_find("pm_objective_wrap_checkmark", line_data.label_h), "visible", false)
				vint_set_property(text_box_h, "anchor",  current_x, current_y)
			else
				vint_set_property(vint_object_find("pm_objective_wrap_checkmark", line_data.label_h), "visible", Pause_info_objective_lines[i].checked)
			end
			

			
			current_y = current_y + size_y
			total_y = total_y + size_y
			if (total_y > OBJECTIVE_MAX_VISIBLE_PIXELS) then
				total_y = OBJECTIVE_MAX_VISIBLE_PIXELS
				Pause_info_objective_lines.more_lines = true
			
			end
		else 
			vint_set_property(line_data.label_h, "visible", false)
			if (i >= Pause_info_objective_lines.current_line) then
				Pause_info_objective_lines.more_lines = true
			end
		end
		
		real_y = real_y + size_y
	end
	

	if (Pause_info_objective_lines.more_lines) then
		pause_menu_objective_create_scroll_bar(menu_label,menu_data)
	end
	
	pause_menu_objective_set_thumb_pos_scroll_bar(menu_data, first_vis_item_location / (Pause_info_objective_lines.total_y))

	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x, menu_label.anchor_y)
	
end

function pause_menu_control_objective_release(Menu_control)

	local menu_data = Pause_menu_objective_menu[0]

	if menu_data.has_scroll_bar == true then
		menu_data.has_scroll_bar = false
		vint_object_destroy(menu_data.scroll_bar.bar_grp)
		menu_data.scroll_bar = nil
	end

	
	
	local menu_label = Menu_option_labels_inactive[0]
	pause_menu_control_release(menu_label.control)
	
	
	
end 


function pause_menu_control_objective_nav_down(menu_label, menu_data)
	
	if(Pause_info_objective_lines.more_lines) then 
		Pause_info_objective_lines.current_line = Pause_info_objective_lines.current_line + 1
		
		local first_vis_item_location = -1
		
		local control = menu_label.control

		local current_x, current_y, real_y	= 0, 0, 0
	
		Pause_info_objective_lines.more_lines = false
		
		local obj_lines = menu_label.objective_list.objective_lines
		for i = 0, Pause_info_objective_lines.num_lines - 1 do
			local line_data = obj_lines[i]
			
			local text_box_h = vint_object_find("pm_objective_wrap_line_label", line_data.label_h)	
			local dummy_x, size_y = element_get_actual_size(text_box_h)
			
			if(i >= Pause_info_objective_lines.current_line and  current_y < OBJECTIVE_MAX_VISIBLE_PIXELS and i < Pause_info_objective_lines.num_lines) then
				vint_set_property(line_data.label_h, "visible", true)
				if (first_vis_item_location == -1) then
					first_vis_item_location = real_y
				end
				
				local dummy_x, size_y = element_get_actual_size(text_box_h)
				-- move it down to the next line.
				vint_set_property(line_data.label_h, "anchor", current_x, current_y )
				
				current_y = current_y + size_y
				if (current_y > OBJECTIVE_MAX_VISIBLE_PIXELS) then
					current_y = OBJECTIVE_MAX_VISIBLE_PIXELS
					Pause_info_objective_lines.more_lines = true
				end
			else 
				if (i >= Pause_info_objective_lines.current_line) then
					Pause_info_objective_lines.more_lines = true
				end
				vint_set_property(line_data.label_h, "visible", false)
			end
			
			
			real_y = real_y + size_y
		end
		
		
		pause_menu_objective_set_thumb_pos_scroll_bar(menu_data, first_vis_item_location / Pause_info_objective_lines.total_y)

	end
end

function pause_menu_control_objective_nav_up(menu_label, menu_data)
	if(Pause_info_objective_lines.current_line > 0 ) then 
		Pause_info_objective_lines.current_line = Pause_info_objective_lines.current_line - 1
		
		local first_vis_item_location = -1
		
		local control = menu_label.control

		local current_x, current_y, real_y		= 0, 0, 0
		
		Pause_info_objective_lines.more_lines = false
					
		local obj_lines = menu_label.objective_list.objective_lines
		for i = 0, Pause_info_objective_lines.num_lines - 1 do
			local line_data = obj_lines[i]
			local text_box_h = vint_object_find("pm_objective_wrap_line_label", line_data.label_h)	
			
			local dummy_x, size_y = element_get_actual_size(text_box_h)
			
			if(i >= Pause_info_objective_lines.current_line and  current_y < OBJECTIVE_MAX_VISIBLE_PIXELS and i < Pause_info_objective_lines.num_lines) then
				vint_set_property(line_data.label_h, "visible", true)
				if (first_vis_item_location == -1) then
					first_vis_item_location = real_y
				end
		
				
				-- move it down to the next line.
				vint_set_property(line_data.label_h, "anchor", current_x, current_y )
				current_y = current_y + size_y
				if (current_y > OBJECTIVE_MAX_VISIBLE_PIXELS) then
					current_y = OBJECTIVE_MAX_VISIBLE_PIXELS
					Pause_info_objective_lines.more_lines = true
				
				end
			else 
				if (i >= Pause_info_objective_lines.current_line) then
					Pause_info_objective_lines.more_lines = true
				end
				vint_set_property(line_data.label_h, "visible", false)
			end
			
				
			real_y = real_y + size_y
				
		end

		
		pause_menu_objective_set_thumb_pos_scroll_bar(menu_data, first_vis_item_location / Pause_info_objective_lines.total_y)

	end
end

function pause_menu_objective_wrap_get_width(menu_item)
	local menu_data = Menu_active[Menu_active.first_vis_item]
	
	if (menu_data.has_scroll_bar == true) then
		return 565.0 + 25.0 -- for the scroll bar
	else 
		return 565.0
	end
end

function pause_menu_objective_wrap_get_height(menu_item)
	return Pause_info_objective_lines.current_y
end

	
function pause_menu_objective_get_width(menu_item)
	return 565.0
end

function pause_menu_objective_get_height(menu_item)
	return Pause_info_objective_lines.current_y
end

function pause_menu_objective_create_scroll_bar(menu_label, menu_data)
	if menu_data.has_scroll_bar == true then
		menu_data.has_scroll_bar = false
		vint_object_destroy(menu_data.scroll_bar.bar_grp)
		menu_data.scroll_bar = nil
	end
	
	local thumb_size = OBJECTIVE_MAX_VISIBLE_PIXELS / Pause_info_objective_lines.total_y 
	menu_data.has_scroll_bar = true;
	
	

	local bar_grp = vint_object_clone(vint_object_find("menu_scroll_bar", nil, MENU_BASE_DOC_HANDLE), Menu_option_labels.control_parent)
		
		
	local scroll_data = {
		visible =			false,
		bar_grp =			bar_grp,
		bg_n_h =			vint_object_find("menu_scroll_bg_n", bar_grp),
		bg_c_h =			vint_object_find("menu_scroll_bg_c", bar_grp),
		bg_s_h =			vint_object_find("menu_scroll_bg_s", bar_grp),
		thumb_n_h =			vint_object_find("menu_scroll_thumb_n", bar_grp),
		thumb_s_h =			vint_object_find("menu_scroll_thumb_s", bar_grp),
		thumb_blend_h =		vint_object_find("menu_scroll_thumb_blend", bar_grp),
		thumb_pos =			0,
		bar_height =		332,
		thumb_height =		332,
	}

	menu_data.scroll_bar = scroll_data
		
	pause_menu_objective_show_scroll_bar(menu_data)
	pause_menu_objective_set_bar_height(menu_data, OBJECTIVE_MAX_VISIBLE_PIXELS) -- 33?
	pause_menu_objective_set_thumb_size_scroll_bar(menu_data, thumb_size)
	pause_menu_objective_set_pos_scroll_bar(menu_data, 565, Pause_menu_objective_menu.header_height)
end

-- working!
function pause_menu_objective_show_scroll_bar(menu_data)
	local scroll_data = menu_data.scroll_bar
	vint_set_property(scroll_data.bar_grp, "visible", true)
end

function pause_menu_objective_set_pos_scroll_bar(menu_data, x, y)
	vint_set_property(menu_data.scroll_bar.bar_grp, "anchor", x, y)
end

-- working I think
function pause_menu_objective_set_bar_height(menu_data, new_height)
	local scroll_data = menu_data.scroll_bar
	scroll_data.bar_height = new_height - 54 --This magic number will allow you to change the base height of the scrollbar

	
	vint_set_property(scroll_data.bg_s_h, "anchor", 38, new_height +10 )
	vint_set_property(scroll_data.bg_c_h, "source_se", 10, new_height)

	pause_menu_objective_update_scroll_bar_scroll_bar(menu_data, scroll_data)
end

function pause_menu_objective_set_thumb_size_scroll_bar(menu_data, height)
	local scroll_data = menu_data.scroll_bar
	scroll_data.thumb_height = height * scroll_data.bar_height
	
	
	if scroll_data.thumb_height < 10 then
		scroll_data.thumb_height = 10
	end
	
	
	vint_set_property(scroll_data.thumb_n_h, "source_se", 32, scroll_data.thumb_height - 20)
	pause_menu_objective_update_scroll_bar_scroll_bar(menu_data, scroll_data)
end

function pause_menu_objective_set_thumb_pos_scroll_bar(menu_data, value)
	
	if menu_data.has_scroll_bar ~= true then
		return
	end
	
	local scroll_data = menu_data.scroll_bar
	
	if scroll_data.thumb_pos ~= value then
		scroll_data.thumb_pos = value
		pause_menu_objective_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	end
end

function pause_menu_objective_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	if menu_data.has_scroll_bar ~= true then
		return
	end
	
	-- update the thumb pos
	local thumb_offset = scroll_data.thumb_pos * scroll_data.bar_height + 10
	
	
	if thumb_offset > scroll_data.bar_height then
		thumb_offset = scroll_data.bar_height
	end
	
	
	vint_set_property(scroll_data.thumb_n_h,		"anchor", 3, thumb_offset)
	vint_set_property(scroll_data.thumb_s_h,		"anchor", 3, thumb_offset + scroll_data.thumb_height - 20) --Magic Number represents the offset from the thumb height
	vint_set_property(scroll_data.thumb_blend_h,	"anchor", 3, thumb_offset + scroll_data.thumb_height - 63) --Magic Number represents the offset from the thumb height
end

--------------------------------------[ STAT_TEXT_LINE ]--------------------------------------
function pause_menu_control_stat_text_line_show_internal(menu_label, menu_data, control_type)
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= control_type then
			-- this isn't my control so release it
			menu_release_control(control)
			control = nil
		end
	end

	vint_set_property(menu_label.label_h, "text_tag", "")	
	
	if control == nil then
		local control_h = vint_object_clone(vint_object_find("pm_stat_text_line"), Menu_option_labels.control_parent)
		control = { grp_h = control_h, type = control_type, is_highlighted = false }
		
		menu_label.control = control		
		menu_label.stars = { star_h = { } }
		menu_label.value_h = vint_object_find("stat_value", control.grp_h)
		menu_label.real_label_h = vint_object_find("stat_label", control.grp_h)
		menu_label.stars.star_grp = vint_object_find("stat_stars", control.grp_h)
		menu_label.stars.star_h[0] = vint_object_find("stat_star1", menu_label.stars.star_grp)
		menu_label.stars.star_h[1]= vint_object_find("stat_star2", menu_label.stars.star_grp)
		menu_label.stars.star_h[2] = vint_object_find("stat_star3", menu_label.stars.star_grp)
	end
	
	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x + 7, menu_label.anchor_y)
	vint_set_property(control.grp_h, "depth", menu_label.depth)
	
	--	Set the color and text_tag
	vint_set_property(menu_label.real_label_h, "text_tag", menu_data.label)
	
	if control_type == PAUSE_MENU_CONTROL_STAT_TEXT_LINE then
		vint_set_property(menu_label.real_label_h, "tint", 0.623, 0.635, 0.643)
	else
		vint_set_property(menu_label.real_label_h, "tint", 0.364, 0.368, 0.376)
	end
	vint_set_property(menu_label.real_label_h, "visible", true)
		
	if menu_data.show_value == true then
		vint_set_property(menu_label.value_h, "visible", true)
		vint_set_property(menu_label.value_h, "text_tag", menu_data.value)

		if control_type == PAUSE_MENU_CONTROL_STAT_TEXT_LINE then
			vint_set_property(menu_label.value_h, "tint", 0.623, 0.635, 0.643)
		else
			vint_set_property(menu_label.value_h, "tint", 0.364, 0.368, 0.376)
		end
	else
		vint_set_property(menu_label.value_h, "visible", false)
	end
	
	if menu_data.data_type == DIV_DATA_STAR then
		vint_set_property(menu_label.value_h, "visible", false)
		vint_set_property(menu_label.stars.star_grp, "visible", true)
		pause_menu_diversions_update_stars(menu_label, menu_data)
	end
end

function pause_menu_control_diversion_text_line_show(menu_label, menu_data)
	pause_menu_control_stat_text_line_show_internal(menu_label, menu_data, PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE)
	
--	pause_menu_control_stat_text_line_show_internal(menu_label, menu_data, PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE)
--	if Menu_active[Menu_active.highlighted_item] == menu_data then
--		pause_menu_control_diversion_text_line_enter(menu_label, menu_data)
--	end
end

function pause_menu_control_stat_text_line_show(menu_label, menu_data)
	pause_menu_control_stat_text_line_show_internal(menu_label, menu_data, PAUSE_MENU_CONTROL_STAT_TEXT_LINE)
end

function pause_menu_control_diversion_text_line_enter(menu_label, menu_data)
	if menu_label.control.hl_control ~= nil then
		vint_object_destroy(menu_label.control.hl_control)
		menu_label.control.hl_control = nil
	end
	
	local hl_bar_label_h = vint_object_find("menu_sel_bar_label", Menu_option_labels.hl_bar)
	vint_set_property(hl_bar_label_h, "visible", false)		--	Disable the previous label from showing
	
	local clone = vint_object_clone(menu_label.control.grp_h, Menu_option_labels.hl_bar)
	menu_label.control.hl_control = clone
	vint_set_property(clone, "anchor", 12, 0)
	
	for i, n in { "stat_label", "stat_value" } do
		local t = vint_object_find(n, clone)
		vint_set_property(t, "tint", 0, 0, 0)
		vint_set_property(t, "font", "thin")
	end
end

function pause_menu_control_diversion_text_line_leave(menu_label, menu_data)
	if menu_label.control.hl_control ~= nil then
		vint_object_destroy(menu_label.control.hl_control)
		menu_label.control.hl_control = nil
	end
end

function pause_menu_control_stat_text_line_release(control)
	if control.grp_h ~= nil then
		vint_object_destroy(control.grp_h)
		control.grp_h = nil
	end
	
	if control.hl_control ~= nil then
		vint_object_destroy(control.hl_control)
		control.hl_control = nil
	end
end

--------------------------------------[ CHECKBOX IMAGE ]--------------------------------------
function pause_menu_control_checkbox_image_show(menu_label, menu_data)
	pause_menu_control_objective_text_line_show(menu_label, menu_data)

	vint_set_property(menu_label.real_label_h, "tint", 0.364, 0.368, 0.376)
	
	if menu_data.dead == true or menu_data.retrieved == true then
		vint_set_property(menu_label.real_label_h, "alpha", 0.6)
		vint_set_property(menu_label.checkbox_h, "alpha", 0.6)
	end
end


function pause_menu_control_checkbox_image_update_select_bar(old_index)
	local new_idx = Menu_active.highlighted_item
		
	local anchor_x, anchor_y = vint_get_property(Menu_option_labels[new_idx].real_label_h, "anchor")
	local hl_bar_label_h = vint_object_find("menu_sel_bar_label", Menu_option_labels.hl_bar)
	
	if old_index ~= nil then
		vint_set_property(Menu_option_labels[old_index].checkbox_h, "tint", 0.364, 0.368, 0.376)
	end
	
	vint_set_property(Menu_option_labels[new_idx].checkbox_h, "tint", 0.9, 0.74, 0.05)
	vint_set_property(Menu_option_labels.hl_bar, "anchor", anchor_x + 5, Menu_option_labels[new_idx].anchor_y + 1)
	vint_set_property(hl_bar_label_h, "text_tag", Menu_active[new_idx].label)
end

function pause_menu_control_checkbox_image_nav_up(menu_label, menu_data)
	local idx = Menu_active.highlighted_item 
	
	if idx - 1 >= 0 then
		Menu_active.highlighted_item = Menu_active.highlighted_item - 1
	else 
		Menu_active.highlighted_item = Menu_active.num_items - 1
	end
		
	pause_menu_control_checkbox_image_update_select_bar(idx)
	
	if Menu_active.on_nav ~= nil then
		Menu_active.on_nav(Menu_active)
	end
end

function pause_menu_control_checkbox_image_nav_down(menu_label, menu_data)
	local idx = Menu_active.highlighted_item 
	
	if idx + 1 < Menu_active.num_items then
		Menu_active.highlighted_item = Menu_active.highlighted_item + 1
	else
		Menu_active.highlighted_item = 0
	end
	
	pause_menu_control_checkbox_image_update_select_bar(idx)
	
	if Menu_active.on_nav ~= nil then
		Menu_active.on_nav(Menu_active)
	end
end

function pause_menu_control_checkbox_image_release(menu_label, menu_data)
end

function pause_menu_control_checkbox_image_compute_width(menu_data)
	local width, max_width
	local grp_h = vint_object_find("pm_objective_text_line")
	local label_h = vint_object_find("pm_objective_text_line_label", grp_h)
	local anchor_x, anchor_y = vint_get_property(label_h, "anchor")
	
	width = 0
	max_width = 0
	for i = 0, menu_data.num_items - 1 do
		vint_set_property(label_h, "text_tag", menu_data[i].label)
		width = element_get_actual_size(label_h)
		if width > max_width then
			max_width = width
		end
	end
	
	return max_width + anchor_x
end

function pause_menu_control_checkbox_image_resize_select_bar(menu_data)
	--Resize Selector bar
	local	width = pause_menu_control_checkbox_image_compute_width(menu_data)
	
	local frame_h = Menu_option_labels.frame
	local sel_bar_width = floor(width) - 8
		
	local bg_h = vint_object_find("menu_sel_bar_w", frame_h)
	vint_set_property(bg_h, "source_se", sel_bar_width, 36)
		
	bg_h = vint_object_find("menu_sel_bar_w_hl", frame_h)
	vint_set_property(bg_h, "source_se", sel_bar_width, 36)
		
	local menu_bar_e_anchor_x, menu_bar_e_anchor_y = vint_get_property(vint_object_find("menu_sel_bar_e", frame_h), "anchor")
	local menu_bar_e_anchor_x = sel_bar_width + 5
		
	local bg_h = vint_object_find("menu_sel_bar_e", frame_h)
	vint_set_property(bg_h, "anchor", menu_bar_e_anchor_x, menu_bar_e_anchor_y)
		
	local bg_h = vint_object_find("menu_sel_bar_e_hl", frame_h)
	vint_set_property(bg_h, "anchor", menu_bar_e_anchor_x - 1, menu_bar_e_anchor_y)
		
	vint_set_property(Menu_option_labels.hl_clip, "offset", 12, -15)
	vint_set_property(Menu_option_labels.hl_clip, "clip_size", width - 17, MENU_ITEM_HEIGHT)
	
	Pause_menu_checkbox_image_width = width + menu_data.image_offset.x
	pause_menu_control_checkbox_image_update_select_bar()
end

--------------------------------------[ HELP TEXT ]--------------------------------------
function pause_menu_control_help_text_show(menu_label, menu_data)
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_HELP_TEXT then
			-- this isn't my control so release it
			menu_release_control(control)
			control = nil
		end
	end

	vint_set_property(menu_label.label_h, "text_tag", "")	
	
	if control == nil then
		local control_h = vint_object_clone(vint_object_find("pm_help_text"), Menu_option_labels.control_parent)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_HELP_TEXT, is_highlighted = false }
			
		menu_label.control = control		
		menu_label.help_clip_h = vint_object_find("pm_help_text_clip", control.grp_h)
		menu_label.real_label_h = vint_object_find("pm_help_text_label", control.grp_h)
	end
	
	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x + 7, menu_label.anchor_y)
	vint_set_property(control.grp_h, "depth", menu_label.depth)

	vint_set_property(menu_label.real_label_h, "text_tag", menu_data.label)
	vint_set_property(menu_label.real_label_h, "wrap_width", PAUSE_MENU_HELP_TEXT_WIDTH)
	vint_set_property(menu_label.help_clip_h, "clip_size", PAUSE_MENU_HELP_TEXT_CLIP_WIDTH, PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT)
	
	-- we need a version we can manipulate
	
	local anchor_x, anchor_y= vint_get_property(menu_label.real_label_h, "anchor")
	Pause_menu_help_page.original_y = anchor_y
	
	local size_x, size_y = element_get_actual_size(menu_label.real_label_h)
	
	if menu_data.has_scroll_bar == nil then
		menu_data.has_scroll_bar = false
	end
		
	
	if  size_y > PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT then
		Pause_menu_help_page.use_slider = true
		vint_set_property(menu_label.real_label_h, "wrap_width", PAUSE_MENU_HELP_TEXT_CLIP_WIDTH - PAUSE_MENU_HELP_SLIDER_WIDTH)
		vint_set_property(menu_label.help_clip_h, "clip_size", PAUSE_MENU_HELP_TEXT_CLIP_WIDTH - PAUSE_MENU_HELP_SLIDER_WIDTH, PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT)

		pause_menu_control_help_create_scroll_bar(menu_label, menu_data)
		
		local accel_repeat = 0.08
		local accel_factor = 15
		local accel_limit  = 1000

		menu_label.input1 = vint_subscribe_to_input_event(nil, "nav_up", "pause_menu_help_page_up", 5)
		vint_set_input_params(menu_label.input1, accel_repeat, accel_factor, accel_limit, true)
		menu_label.input2 = vint_subscribe_to_input_event(nil, "nav_down", "pause_menu_help_page_down", 5)
		vint_set_input_params(menu_label.input2, accel_repeat, accel_factor, accel_limit, true)

	else 
		Pause_menu_help_page.use_slider = false
	end


end
	
	
function pause_menu_control_help_release()
	local menu_data
	
	if Menu_mode_current == "pause" then
		menu_data = Pause_info_help_sub_menu[0]
	else
		menu_data = Main_menu_mp_help_info[0]
	end
	
	if menu_data.has_scroll_bar == true then
		menu_data.has_scroll_bar = false
		vint_object_destroy(menu_data.scroll_bar.bar_grp)
		menu_data.scroll_bar = nil
	end
		

	local menu_label = Menu_option_labels_inactive[0]
	if menu_label.input1 ~= nil then
		vint_unsubscribe_to_input_event(menu_label.input1)
		vint_unsubscribe_to_input_event(menu_label.input2)
		menu_label.input1 = nil
		menu_label.input2 = nil
	end
	
	pause_menu_control_release(menu_label.control)
	menu_label.real_label_h = nil
end

function pause_menu_control_help_set_pos_scroll_bar(menu_data, x, y)
	vint_set_property(menu_data.scroll_bar.bar_grp, "anchor", x, y)
end

function pause_menu_control_help_create_scroll_bar(menu_label, menu_data)
	if menu_data.has_scroll_bar == true then
		menu_data.has_scroll_bar = false
		vint_object_destroy(menu_data.scroll_bar.bar_grp)
		menu_data.scroll_bar = nil
	end
	
	menu_data.has_scroll_bar = true;
	
	
	
	local bar_grp = vint_object_clone(vint_object_find("menu_scroll_bar", nil, MENU_BASE_DOC_HANDLE), Menu_option_labels.control_parent)
		
		
	local scroll_data = {
		visible =			false,
		bar_grp =			bar_grp,
		bg_n_h =			vint_object_find("menu_scroll_bg_n", bar_grp),
		bg_c_h =			vint_object_find("menu_scroll_bg_c", bar_grp),
		bg_s_h =			vint_object_find("menu_scroll_bg_s", bar_grp),
		thumb_n_h =			vint_object_find("menu_scroll_thumb_n", bar_grp),
		thumb_s_h =			vint_object_find("menu_scroll_thumb_s", bar_grp),
		thumb_blend_h =		vint_object_find("menu_scroll_thumb_blend", bar_grp),
		thumb_pos =			0,
		bar_height =		332,
		thumb_height =		332,
	}

	menu_data.scroll_bar = scroll_data
	
	local dummy_x, size_y = element_get_actual_size(menu_label.real_label_h)
	local thumb_size =  PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT / size_y
	
	
	pause_menu_control_help_show_scroll_bar(menu_data)
	pause_menu_control_help_set_bar_height(menu_data, PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT)
	pause_menu_control_help_set_thumb_size_scroll_bar(menu_data, thumb_size)
	local box_x, box_y = vint_get_property(menu_label.control.grp_h, "anchor")
	local clip_x, clip_y = vint_get_property(menu_label.help_clip_h, "anchor")
	local label_x, label_y = vint_get_property(menu_label.real_label_h, "anchor")
	local real_y = box_y + clip_y + label_y
	local real_x = box_x + clip_x + label_x
	pause_menu_control_help_set_pos_scroll_bar(menu_data, real_x + PAUSE_MENU_HELP_TEXT_CLIP_WIDTH - PAUSE_MENU_HELP_SLIDER_WIDTH + 5, real_y)
	
end

function pause_menu_control_help_text_get_width()
	return PAUSE_MENU_HELP_TEXT_WIDTH
end

function pause_menu_control_help_text_get_height()
	return PAUSE_MENU_HELP_TEXT_HEIGHT
end

function pause_menu_help_page_down(target, event, accelleration)
	local menu_label = Menu_option_labels[0]
	local menu_data = Menu_active[0]
	
	if menu_label.real_label_h == nil then
		return
	end
	

	local size_x, size_y = element_get_actual_size(menu_label.real_label_h)
	local anchor_x, anchor_y = vint_get_property(menu_label.real_label_h, "anchor")

	if 0 - anchor_y < size_y - PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT then
		-- we only manipulate the working text object. 
		anchor_y = anchor_y - 0.9 * accelleration
		
		if 0 - anchor_y > size_y - PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT then
			anchor_y = 0 - (size_y - PAUSE_MENU_HELP_TEXT_CLIP_HEIGHT)
		end
		
		vint_set_property(menu_label.real_label_h, "anchor", anchor_x, anchor_y)
		pause_menu_control_help_set_thumb_pos_scroll_bar(menu_data, (0 - anchor_y) / size_y)
	end
end

function pause_menu_help_page_up(target, event, accelleration)
	local menu_label = Menu_option_labels[0]
	local menu_data = Menu_active[0]
	
	if menu_label.real_label_h == nil then
		return
	end

	local size_x, size_y = element_get_actual_size(menu_label.real_label_h)
	local anchor_x, anchor_y = vint_get_property(menu_label.real_label_h, "anchor")
	
	if anchor_y < 0 then
		anchor_y = anchor_y + 0.9 * accelleration
		if anchor_y > 0 then
			anchor_y = 0
		end

		vint_set_property(menu_label.real_label_h, "anchor", anchor_x, anchor_y)

		pause_menu_control_help_set_thumb_pos_scroll_bar(menu_data, (0 - anchor_y) / size_y)
	end
end

-- working I think
function pause_menu_control_help_set_bar_height(menu_data, new_height)
	local scroll_data = menu_data.scroll_bar
	scroll_data.bar_height = new_height - 54--This magic number will allow you to change the base height of the scrollbar

	vint_set_property(scroll_data.bg_s_h, "anchor", 38, new_height - 10 )
	vint_set_property(scroll_data.bg_c_h, "source_se", 10, new_height - 28)

	pause_menu_control_help_update_scroll_bar_scroll_bar(menu_data, scroll_data)
end

function pause_menu_control_help_set_thumb_size_scroll_bar(menu_data, height)
	local scroll_data = menu_data.scroll_bar
	scroll_data.thumb_height = height * scroll_data.bar_height
	
	if scroll_data.thumb_height < 60 then
		scroll_data.thumb_height = 60
	end
	
	
	vint_set_property(scroll_data.thumb_n_h, "source_se", 32, scroll_data.thumb_height - 20)
	pause_menu_control_help_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	
end

-- working!
function pause_menu_control_help_show_scroll_bar(menu_data)
	local scroll_data = menu_data.scroll_bar
	vint_set_property(scroll_data.bar_grp, "visible", true)
end

	
function pause_menu_control_help_set_thumb_pos_scroll_bar(menu_data, value)
	
	if menu_data.has_scroll_bar ~= true then
		return
	end
	
	local scroll_data = menu_data.scroll_bar
	
	if scroll_data.thumb_pos ~= value then
		scroll_data.thumb_pos = value
		pause_menu_control_help_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	end
end

function pause_menu_control_help_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	if menu_data.has_scroll_bar ~= true then
		return
	end
	
	-- update the thumb pos
	local thumb_offset = scroll_data.thumb_pos * scroll_data.bar_height + 10
	
	
	if thumb_offset > scroll_data.bar_height then
		thumb_offset = scroll_data.bar_height - 50
	end
	
	
	vint_set_property(scroll_data.thumb_n_h,		"anchor", 3, thumb_offset)
	vint_set_property(scroll_data.thumb_s_h,		"anchor", 3, thumb_offset + scroll_data.thumb_height - 20) --Magic Number represents the offset from the thumb height
	vint_set_property(scroll_data.thumb_blend_h,	"anchor", 3, thumb_offset + scroll_data.thumb_height - 63) --Magic Number represents the offset from the thumb height
end

--------------------------------------[ PLAYLIST EDITOR ]--------------------------------------

------------
-- Control Functions
------------
function pause_menu_control_playlist_editor_show(menu_label, menu_data)
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_PLAYLIST_EDITOR then
			-- this isn't my control so release it
			menu_release_control(control)
			control = nil
		end
	end

	vint_set_property(menu_label.label_h, "text_tag", "")	
	
	if control == nil then
		local control_h = vint_object_clone(vint_object_find("plist_frame"), Menu_option_labels.control_parent)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_PLAYLIST_EDITOR, is_highlighted = false }
			
		menu_label.control = control		

		menu_label.edit = { }
		menu_label.playlist = { }
		
		menu_label.edit.header_h = vint_object_find("plist_edit_header", control.grp_h)
		menu_label.playlist.header_h = vint_object_find("plist_playlist_header", control.grp_h)
		menu_label.edit.label_h = vint_object_find("plist_edit_label00", control.grp_h)
		menu_label.playlist.label_h = vint_object_find("plist_playlist_label00", control.grp_h)
		menu_label.arrow_h = vint_object_find("plist_arrow", control.grp_h)
		
		menu_label.edit_clip_h = vint_object_find("edit_clip", control.grp_h)
		menu_label.playlist_clip_h = vint_object_find("playlist_clip", control.grp_h)
	end
	
	--	Create the labels
	menu_label.edit.option_labels 		= { [0] = { label_h = menu_label.edit.label_h } }
	menu_label.playlist.option_labels 	= { [0] = { label_h = menu_label.playlist.label_h } }
	local edit_x, edit_y 		= vint_get_property(menu_label.edit.label_h, "anchor")
	local plist_x, plist_y 		= vint_get_property(menu_label.playlist.label_h, "anchor")
	
	for i = 1, PLAYLIST_MAX_ITEMS - 1 do
		menu_label.edit.option_labels[i] = { label_h	= vint_object_clone(menu_label.edit.label_h) }
		vint_set_property(menu_label.edit.option_labels[i].label_h, "anchor", edit_x, edit_y + (i * 33))
		
		menu_label.playlist.option_labels[i] = { label_h = vint_object_clone(menu_label.playlist.label_h) }
		vint_set_property(menu_label.playlist.option_labels[i].label_h, "anchor", plist_x, plist_y + (i * 33))
	end

	-- For the select bar
	menu_label.edit.offset_x 		= vint_get_property(menu_label.edit.header_h, "anchor")
	menu_label.playlist.offset_x 	= vint_get_property(menu_label.playlist.label_h, "anchor")
		
	-- Set that arrow
	vint_set_property(menu_label.arrow_h, "tint", MENU_FOOTER_CASH_NORMAL_COLOR.R, MENU_FOOTER_CASH_NORMAL_COLOR.G, MENU_FOOTER_CASH_NORMAL_COLOR.B)
			
	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x, menu_label.anchor_y)
	vint_set_property(control.grp_h, "depth", menu_label.depth)
	
	pause_menu_playlist_update_labels(menu_label, menu_data)
	
	menu_label.input = {
		vint_subscribe_to_input_event(nil, "playlist_up",		"pause_menu_plist_up_down", 10),
		vint_subscribe_to_input_event(nil, "playlist_down",		"pause_menu_plist_up_down", 10), 
		--vint_subscribe_to_input_event(nil, "dpad_left",		"pause_menu_plist_sort", 10),
		--vint_subscribe_to_input_event(nil, "dpad_right",	"pause_menu_plist_sort", 10),
		--vint_subscribe_to_input_event(nil, "joy_up",			"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "joy_down",		"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "joy_left",		"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "joy_right",		"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "nav_up",			"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "nav_left",		"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "nav_down",		"pause_menu_plist_nav", 10),
		--vint_subscribe_to_input_event(nil, "nav_right",		"pause_menu_plist_nav", 10),
		vint_subscribe_to_input_event(nil, "scroll_left",		"pause_menu_plist_nav", 10),
		vint_subscribe_to_input_event(nil, "scroll_right",		"pause_menu_plist_nav", 10),
	}
end

function pause_menu_plist_up_down(target, event, accelleration)
	if menu_input_is_blocked() == true then
		return
	end
	
	if Pause_menu_playlist_editor[0].active_pane == Pause_menu_playlist_editor[0].playlist then
		if event == "playlist_up" then
			pause_menu_playlist_rs_input(0); -- move track up
		elseif event == "playlist_down" then
			pause_menu_playlist_rs_input(1); -- move track down
		end
	elseif Pause_menu_playlist_editor[0].active_pane == Pause_menu_playlist_editor[0].edit then
		if Pause_menu_playlist_editor[0].active_pane.in_genre == false then
			pause_menu_plist_sort();
		else
			local menu_label = Menu_option_labels[Menu_active.highlighted_item - Menu_active.first_vis_item];
			local menu_data =  Menu_active[Menu_active.highlighted_item];
			if event == "playlist_up" then
				pause_menu_control_playlist_nav_up(menu_label, menu_data);
			elseif event == "playlist_down" then
				pause_menu_control_playlist_nav_down(menu_label, menu_data);
			end		
		end
	end
	return;
end

function pause_menu_plist_nav(target, event, accelleration)
	-- if menu_input_is_blocked() == true then
		-- return
	-- end
	
	-- btn_tips_update()
	-- local item_type = 0
	-- if Menu_active.num_items > 0 then
		-- item_type = Menu_active[Menu_active.highlighted_item].type
		-- Menu_input_accelleration = accelleration
	-- end

	-- if event == "joy_up" then
		-- local menu_option = Menu_option_labels[Menu_active.highlighted_item - Menu_active.first_vis_item]
		-- Menu_control_callbacks[item_type].on_nav_up(menu_option, Menu_active[Menu_active.highlighted_item])
		-- audio_play(Menu_sound_item_nav)
	-- elseif event == "joy_down" then
		-- local menu_option = Menu_option_labels[Menu_active.highlighted_item - Menu_active.first_vis_item]
		-- Menu_control_callbacks[item_type].on_nav_down(menu_option, Menu_active[Menu_active.highlighted_item])
		-- audio_play(Menu_sound_item_nav)
	-- elseif event == "joy_left" then
		-- local menu_option = Menu_option_labels[Menu_active.highlighted_item - Menu_active.first_vis_item]
		-- Menu_control_callbacks[item_type].on_nav_right(menu_option, Menu_active[Menu_active.highlighted_item])
		-- audio_play(Menu_sound_item_nav)
	-- elseif event == "joy_right" then
		-- local menu_option = Menu_option_labels[Menu_active.highlighted_item - Menu_active.first_vis_item]
		-- Menu_control_callbacks[item_type].on_nav_left(menu_option, Menu_active[Menu_active.highlighted_item])
		-- audio_play(Menu_sound_item_nav)
	-- end
end

function pause_menu_control_playlist_on_release()
	local menu_label = Menu_option_labels_inactive[0]

	--	Unsubscribe to input
	if menu_label.input ~= nil then
		for idx, val in menu_label.input do
			vint_unsubscribe_to_input_event(val)
		end
	end
	menu_label.input = nil
	
	for i = 1, PLAYLIST_MAX_ITEMS - 1 do
		vint_object_destroy(menu_label.edit.option_labels[i].label_h)
		vint_object_destroy(menu_label.playlist.option_labels[i].label_h)
	end
	
	pause_menu_control_release(menu_label.control)

	if Pause_menu_playlist_editor[0].edit.has_scroll_bar == true then
		Pause_menu_playlist_editor[0].edit.has_scroll_bar = false
		vint_object_destroy(Pause_menu_playlist_editor[0].edit.scroll_bar.bar_grp)
		Pause_menu_playlist_editor[0].edit.scroll_bar = nil
	end
	
	if Pause_menu_playlist_editor[0].playlist.has_scroll_bar == true then
		Pause_menu_playlist_editor[0].playlist.has_scroll_bar = false
		vint_object_destroy(Pause_menu_playlist_editor[0].playlist.scroll_bar.bar_grp)
		Pause_menu_playlist_editor[0].playlist.scroll_bar = nil
	end

	playlist_play_track(0, 0, true)	--	Stop any song playing
	pause_menu_set_playlist_input_callback()
end

------------
-- Scrollbar Functions
------------
function pause_menu_playlist_create_scroll_bar(menu_label, menu_data)
	if menu_data.has_scroll_bar == true then
		menu_data.has_scroll_bar = false
		vint_object_destroy(menu_data.scroll_bar.bar_grp)
		menu_data.scroll_bar = nil
	end
	
	if menu_data.num_items > PLAYLIST_MAX_ITEMS then
		local thumb_size = PLAYLIST_MAX_ITEMS / menu_data.num_items
		menu_data.has_scroll_bar = true;

		local bar_grp = vint_object_clone(vint_object_find("menu_scroll_bar", nil, MENU_BASE_DOC_HANDLE), Menu_option_labels.control_parent)
		
		
		local scroll_data = {
			visible =			false,
			bar_grp =			bar_grp,
			bg_n_h =				vint_object_find("menu_scroll_bg_n", bar_grp),
			bg_c_h =				vint_object_find("menu_scroll_bg_c", bar_grp),
			bg_s_h =				vint_object_find("menu_scroll_bg_s", bar_grp),
			thumb_n_h =			vint_object_find("menu_scroll_thumb_n", bar_grp),
			thumb_s_h =			vint_object_find("menu_scroll_thumb_s", bar_grp),
			thumb_blend_h =	vint_object_find("menu_scroll_thumb_blend", bar_grp),
			thumb_pos =			0,
			bar_height =		332,
			thumb_height =		332,
		}

		menu_data.scroll_bar = scroll_data
		
		pause_menu_playlist_show_scroll_bar(menu_data)
		pause_menu_playlist_set_bar_height(menu_data, PLAYLIST_MAX_ITEMS * 34) -- 33?
		pause_menu_playlist_set_thumb_size_scroll_bar(menu_data, thumb_size)
		pause_menu_playlist_set_pos_scroll_bar(menu_data, menu_label.offset_x + menu_label.select_bar_width - 25, Pause_menu_playlist_editor.header_height + 20)
		
		pause_menu_playlist_update_clip_region()
	end
end

function pause_menu_playlist_show_scroll_bar(menu_data)
	local scroll_data = menu_data.scroll_bar
	vint_set_property(scroll_data.bar_grp, "visible", true)
end

function pause_menu_playlist_set_pos_scroll_bar(menu_data, x, y)
	local current_clip = 0
	
	if menu_data == Menu_active[0].edit then
		current_clip = Menu_option_labels[0].edit_clip_h
	elseif menu_data == Menu_active[0].playlist then
		current_clip = Menu_option_labels[0].playlist_clip_h
	end

	local anchor_x, anchor_y = vint_get_property(current_clip, "anchor")

	vint_set_property(menu_data.scroll_bar.bar_grp, "anchor", x + anchor_x, y + anchor_y)
end

function pause_menu_playlist_set_bar_height(menu_data, new_height)
	local scroll_data = menu_data.scroll_bar
	scroll_data.bar_height = new_height - 54 --This magic number will allow you to change the base height of the scrollbar

	vint_set_property(scroll_data.bg_s_h, "anchor", 38, new_height - 10)
	vint_set_property(scroll_data.bg_c_h, "source_se", 10, new_height - 28)

	pause_menu_playlist_update_scroll_bar_scroll_bar(menu_data, scroll_data)
end

function pause_menu_playlist_set_thumb_size_scroll_bar(menu_data, height)
	local scroll_data = menu_data.scroll_bar
	scroll_data.thumb_height = floor(height * scroll_data.bar_height)
	
	if scroll_data.thumb_height < 60 then
		scroll_data.thumb_height = 60
	end
	
	vint_set_property(scroll_data.thumb_n_h, "source_se", 32, scroll_data.thumb_height - 20)
	pause_menu_playlist_update_scroll_bar_scroll_bar(menu_data, scroll_data)
end

function pause_menu_playlist_set_thumb_pos_scroll_bar(menu_data, value)
	if menu_data.has_scroll_bar ~= true then
		return
	end
	
	local scroll_data = menu_data.scroll_bar
	if scroll_data.thumb_pos ~= value then
		scroll_data.thumb_pos = value
		pause_menu_playlist_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	end
end

function pause_menu_playlist_update_scroll_bar_scroll_bar(menu_data, scroll_data)
	if menu_data.has_scroll_bar ~= true then
		return
	end
	
	-- update the thumb pos
	local thumb_offset = scroll_data.thumb_pos * (scroll_data.bar_height - scroll_data.thumb_height) + 10 
	thumb_offset = floor(thumb_offset)
	
	vint_set_property(scroll_data.thumb_n_h,		"anchor", 3, thumb_offset)
	vint_set_property(scroll_data.thumb_s_h,		"anchor", 3, thumb_offset + scroll_data.thumb_height - 20) --Magic Number represents the offset from the thumb height
	vint_set_property(scroll_data.thumb_blend_h,	"anchor", 3, thumb_offset + scroll_data.thumb_height - 63) --Magic Number represents the offset from the thumb height
end



function pause_menu_playlist_resize_select_bar()
	
	local width = Menu_option_labels[0].active_pane.select_bar_width
	local bg_h
	local frame_h = Menu_option_labels.frame
	local sel_bar_width = width
	
	-- Resize the scroll bar
	if Pause_menu_playlist_editor[0].active_pane.has_scroll_bar == true then
		sel_bar_width = sel_bar_width - 40
	end
	
	--Floor the selection bar width
	sel_bar_width = floor(sel_bar_width)
	
	Menu_option_labels.item_width = sel_bar_width
	
	bg_h = vint_object_find("menu_sel_bar_w", frame_h)
	vint_set_property(bg_h, "source_se", sel_bar_width, 36)
	
	bg_h = vint_object_find("menu_sel_bar_w_hl", frame_h)
	vint_set_property(bg_h, "source_se", sel_bar_width, 36)
	
	bg_h = vint_object_find("menu_sel_bar_e", frame_h)
	local menu_bar_e_anchor_x, menu_bar_e_anchor_y = vint_get_property(bg_h, "anchor")
	menu_bar_e_anchor_x = sel_bar_width + 5
	vint_set_property(bg_h, "anchor", menu_bar_e_anchor_x, menu_bar_e_anchor_y)
	
	local bg_h = vint_object_find("menu_sel_bar_e_hl", frame_h)
	vint_set_property(bg_h, "anchor", menu_bar_e_anchor_x - 1, menu_bar_e_anchor_y)
	
	vint_set_property(Menu_option_labels.hl_clip, "offset", 12, -15)
	vint_set_property(Menu_option_labels.hl_clip, "clip_size", sel_bar_width - 17, MENU_ITEM_HEIGHT)

end

function pause_menu_playlist_refresh()
	pause_menu_playlist_update_labels(Menu_option_labels[0], Pause_menu_playlist_editor[0])

	-- Create the scroll bars (if necessary)
	pause_menu_playlist_create_scroll_bar(Menu_option_labels[0].edit, Pause_menu_playlist_editor[0].edit)
	pause_menu_playlist_create_scroll_bar(Menu_option_labels[0].playlist, Pause_menu_playlist_editor[0].playlist)

	--	Update other things
	
	pause_menu_control_playlist_update_scroll_bar(Menu_option_labels[0], Pause_menu_playlist_editor[0], Pause_menu_playlist_editor[0].edit)
	pause_menu_control_playlist_update_scroll_bar(Menu_option_labels[0], Pause_menu_playlist_editor[0], Pause_menu_playlist_editor[0].playlist)
	pause_menu_control_playlist_update_selectbar(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	pause_menu_control_playlist_update_arrow(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	
	-- If necessary again...
	pause_menu_playlist_resize_select_bar()
	pause_menu_playlist_update_clip_region()
end

------------
-- Update Functions
------------
function pause_menu_playlist_update_labels(menu_label, menu_data)
	local index
	for i = 0, PLAYLIST_MAX_ITEMS - 1 do
		index = menu_data.edit.first_vis_item + i
		if index < menu_data.edit.num_items then
			vint_set_property(menu_label.edit.option_labels[i].label_h, "visible", true)
			vint_set_property(menu_label.edit.option_labels[i].label_h, "text_tag", menu_data.edit[index].label)
		else
			vint_set_property(menu_label.edit.option_labels[i].label_h, "visible", false)
		end
		
		index = menu_data.playlist.first_vis_item + i
		if i < menu_data.playlist.num_items then
			vint_set_property(menu_label.playlist.option_labels[i].label_h, "visible", true)
			vint_set_property(menu_label.playlist.option_labels[i].label_h, "text_tag", menu_data.playlist[index].label)
		else
			vint_set_property(menu_label.playlist.option_labels[i].label_h, "visible", false)
		end
	end
end

function pause_menu_playlist_stop()
	Pause_menu_playlist_editor[0].arrow_index = -1
	pause_menu_control_playlist_update_arrow(Menu_option_labels[0], Pause_menu_playlist_editor[0])
end

function pause_menu_control_playlist_update_arrow(menu_label, menu_data)
	if menu_label.active_pane == menu_label.edit then
		return
	end

	if menu_data.active_pane.highlighted_item == menu_data.arrow_index then
		Pause_menu_playlist_right_tips.x_button.label = "MP3_PLAY_STATE_STOP"
	else
		Pause_menu_playlist_right_tips.x_button.label = "MP3_PLAY_STATE_PLAY"
	end
	btn_tips_update()

	local opt_idx = menu_data.arrow_index - menu_data.active_pane.first_vis_item
	if opt_idx >= PLAYLIST_MAX_ITEMS or opt_idx < 0  then
		vint_set_property(menu_label.arrow_h, "visible", false)
		return
	end
	
	local clip_x, clip_y = vint_get_property(Menu_option_labels[0].playlist_clip_h, "anchor")
	local x, y = vint_get_property(menu_label.active_pane.option_labels[opt_idx].label_h, "anchor")
	vint_set_property(menu_label.arrow_h, "anchor", clip_x + x, clip_y + y)
	vint_set_property(menu_label.arrow_h, "visible", true)
end

function pause_menu_control_playlist_update_scroll_bar(menu_label, menu_data, active_pane)
	local first_vis_item 		= 0
	local prev_first_vis_item 	= active_pane.first_vis_item
	local new_idx 					= active_pane.highlighted_item
	
	-- Gotta keep it in the middle
	if active_pane.num_items > PLAYLIST_MAX_ITEMS then
		local half_max = floor(PLAYLIST_MAX_ITEMS / 2)
		first_vis_item = limit(new_idx - half_max, 0, active_pane.num_items - PLAYLIST_MAX_ITEMS)
	end
	
	active_pane.first_vis_item = first_vis_item
	pause_menu_playlist_update_labels(menu_label, menu_data)
	pause_menu_control_playlist_update_arrow(menu_label, menu_data)
	pause_menu_playlist_set_thumb_pos_scroll_bar(active_pane, first_vis_item / (active_pane.num_items - PLAYLIST_MAX_ITEMS))

	return first_vis_item
end	
	

function pause_menu_control_playlist_update_selectbar(menu_label, menu_data)
	local option_labels 	= menu_label.active_pane.option_labels
	local active_menu 	= menu_data.active_pane
		
	if active_menu.highlighted_item >= active_menu.num_items then
		active_menu.highlighted_item = active_menu.num_items - 1
	end

	local current_clip = 0
	
	if active_menu == Menu_active[0].edit then
		current_clip = Menu_option_labels[0].edit_clip_h
	elseif active_menu == Menu_active[0].playlist then
		current_clip = Menu_option_labels[0].playlist_clip_h
	end
		
	local new_idx 			= active_menu.highlighted_item
	
	local first_vis_item = pause_menu_control_playlist_update_scroll_bar(menu_label, menu_data, active_menu)
	local opt_idx 			= menu_data.active_pane.highlighted_item - first_vis_item
	
	local x, y = vint_get_property(current_clip, "anchor")
	
	local anchor_x, anchor_y = vint_get_property(option_labels[opt_idx].label_h, "anchor")
	local hl_bar_label_h = vint_object_find("menu_sel_bar_label", Menu_option_labels.hl_bar)
	
	anchor_x = anchor_x + x
	anchor_y = anchor_y + y + 99
	
	vint_set_property(Menu_option_labels.hl_bar, "anchor", anchor_x + 6, anchor_y + 1)
	vint_set_property(hl_bar_label_h, "text_tag", active_menu[new_idx].label)
end

------------
-- Input Functions
------------
function pause_menu_control_playlist_activate_pane(menu_label, menu_data)
	local first_vis_item = menu_data.active_pane.first_vis_item
	
	if menu_label.active_pane == menu_label.edit then
		if menu_data.playlist.num_items == 0 then
			return
		end
		
		menu_label.active_pane = menu_label.playlist
		menu_data.active_pane = menu_data.playlist
	else
		menu_label.active_pane = menu_label.edit
		menu_data.active_pane = menu_data.edit
	end
	
	-- Swap btn tips
	Pause_menu_playlist_editor.btn_tips = menu_data.active_pane.btn_tips
	btn_tips_update()
	
	-- Update the select bar
	pause_menu_control_playlist_update_selectbar(menu_label, menu_data)
	pause_menu_playlist_resize_select_bar()	
	pause_menu_playlist_update_clip_region()
	
	-- Update the footer
	local hl_item = menu_data.active_pane.highlighted_item
	pause_menu_playlist_update_footer(menu_data.active_pane[hl_item].artist_name, menu_data.active_pane[hl_item].track_name)
end

function pause_menu_control_playlist_nav_up(menu_label, menu_data)
	local hl_item = menu_data.active_pane.highlighted_item
	hl_item = hl_item - 1
	if hl_item < 0 then
		hl_item = menu_data.active_pane.num_items - 1
	end
	
	menu_data.active_pane.highlighted_item = hl_item
	pause_menu_control_playlist_update_selectbar(menu_label, menu_data)
	
	pause_menu_playlist_update_footer(menu_data.active_pane[hl_item].artist_name, menu_data.active_pane[hl_item].track_name)
end

function pause_menu_control_playlist_nav_down(menu_label, menu_data)
	local hl_item = menu_data.active_pane.highlighted_item
	hl_item = hl_item + 1
	if hl_item >= menu_data.active_pane.num_items then
		hl_item = 0
	end
	
	menu_data.active_pane.highlighted_item = hl_item
	pause_menu_control_playlist_update_selectbar(menu_label, menu_data)
	
	pause_menu_playlist_update_footer(menu_data.active_pane[hl_item].artist_name, menu_data.active_pane[hl_item].track_name)
end

function pause_menu_playlist_rs_input(direction)
	--	Only do this is we're the playlist pane
	if Pause_menu_playlist_editor[0].active_pane ~= Pause_menu_playlist_editor[0].playlist then
		return
	end
	
	local menu_data = Pause_menu_playlist_editor[0].playlist
	
	local hl_item = menu_data.highlighted_item
	local other_item
	local swap = menu_data[hl_item]
	if direction == 0 then
		other_item = hl_item - 1
		if other_item < 0 then
			return
		end		
	elseif direction == 1 then
		other_item = hl_item + 1
		if other_item == menu_data.num_items then
			return
		end
	end
	
	if Pause_menu_playlist_editor[0].arrow_index == hl_item then
		Pause_menu_playlist_editor[0].arrow_index = other_item
	elseif Pause_menu_playlist_editor[0].arrow_index == other_item then
		Pause_menu_playlist_editor[0].arrow_index = hl_item
	end
	
	menu_data[hl_item] = menu_data[other_item]
	menu_data[other_item] = swap
	
	menu_data.highlighted_item = other_item
	audio_play(Menu_sound_item_nav)
	pause_menu_playlist_update_labels(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	pause_menu_control_playlist_update_arrow(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	pause_menu_control_playlist_update_selectbar(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	pause_menu_playlist_update_clip_region()
	
end

function pause_menu_plist_sort()
	if Pause_menu_playlist_editor.block_sort == true then
		return
	end
	
	if Pause_menu_playlist_editor[0].edit ~= Pause_menu_playlist_editor[0].active_pane then
		return
	end
	
	local pane_data = Pause_menu_playlist_editor[0].edit
	if pane_data.sort_by_artist == true then
		pane_data.sort_by_artist = false
		Pause_menu_playlist_left_tips.right_stick.label_text = "MP3_PLAYLIST_OPTIONS_SORT_ARTIST"
	else
		pane_data.sort_by_artist = true
		Pause_menu_playlist_left_tips.right_stick.label_text = "MP3_PLAYLIST_OPTIONS_SORT_TITLE"
	end
	
	btn_tips_update()
	
	if pane_data.in_genre == true then
		return
	end
	
	audio_play(Menu_sound_item_nav)
	pane_data.num_items = 0
	vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_genre_tracks", 0, 18, pane_data.genre_number, pane_data.sort_by_artist)		-- 18: Genre 

	-- Check for no items
	if pane_data.num_items == 0 then
		pane_data.num_items = 1
		pane_data.no_items = true
		pane_data[0] = { label = "PLIST_NO_TRACKS" }
	else
		pane_data.no_items = false
	end

	pause_menu_playlist_refresh()	
	local hl_item = pane_data.highlighted_item
	pause_menu_playlist_update_footer(Pause_menu_playlist_editor[0].active_pane[hl_item].artist_name, Pause_menu_playlist_editor[0].active_pane[hl_item].track_name)
end

function pause_menu_playlist_on_select(menu_label, menu_data)
	menu_data.active_pane.on_select(menu_label, menu_data)
end

function pause_menu_playlist_on_back(menu_data)
	menu_data[0].active_pane.on_back()
	btn_tips_update()
end

function pause_menu_playlist_plist_select(menu_label, menu_data)
	local pane_data = Pause_menu_playlist_editor[0].playlist
	local hl_item = pane_data.highlighted_item
	
	for i = hl_item, pane_data.num_items - 2 do
		pane_data[i] = pane_data[i + 1]
	end
	
	if menu_data.arrow_index > hl_item then
		menu_data.arrow_index = menu_data.arrow_index  - 1
		pause_menu_control_playlist_update_arrow(menu_label, menu_data)
	end

	if menu_data.arrow_index == hl_item then
		menu_data.arrow_index = -1
		pause_menu_control_playlist_update_arrow(menu_label, menu_data)
	end
	
	pane_data.num_items = pane_data.num_items - 1
	if pane_data.num_items <= 0 then
		pause_menu_control_playlist_activate_pane(menu_label, menu_data)
	end
	
	-- Remove it from the genre list
	pane_data = Pause_menu_playlist_editor[0].edit
	if pane_data.in_genre == true then
		pause_menu_playlist_refresh()	
		local hl_item = Pause_menu_playlist_editor[0].playlist.highlighted_item
		pause_menu_playlist_update_footer(Pause_menu_playlist_editor[0].playlist[hl_item].artist_name, Pause_menu_playlist_editor[0].playlist[hl_item].track_name)
		return
	end
	
	pane_data.num_items = 0
	vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_genre_tracks", 0, 18, pane_data.genre_number, pane_data.sort_by_artist)		-- 18: Genre 

	-- Check for no items
	if pane_data.num_items == 0 then
		pane_data.num_items = 1
		pane_data.no_items = true
		pane_data[0] = { label = "PLIST_NO_TRACKS" }
		pause_menu_playlist_update_footer(" ", " ")
	else
		pane_data.no_items = false
	end

	pause_menu_playlist_refresh()	
	
	local hl_item = Pause_menu_playlist_editor[0].playlist.highlighted_item
	pause_menu_playlist_update_footer(Pause_menu_playlist_editor[0].playlist[hl_item].artist_name, Pause_menu_playlist_editor[0].playlist[hl_item].track_name)
end

function btn_tip_always_hidden()
	return false
end

function pause_menu_playlist_in_genre()
	local pane_data = Pause_menu_playlist_editor[0].edit
	
	if pane_data.in_genre == true then
		return false
	else
		return true
	end
end

function pause_menu_playlist_edit_select(menu_label, menu_data)
	local pane_data = Pause_menu_playlist_editor[0].edit
	local hl_item = pane_data.highlighted_item
	
	if pane_data.no_items == true then
		return
	end
	
	if pane_data.in_genre == true then
		pane_data.num_items = 0
		pane_data.in_genre = false
		pane_data.genre_number = pane_data[hl_item].idx
		pane_data.old_hl_item = hl_item
		pane_data.old_first_index = pane_data.first_vis_index
		vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_genre_tracks", 0, 18, pane_data[hl_item].idx, pane_data.sort_by_artist)		-- 18: Genre 
		pane_data.highlighted_item = 0
		
		pause_menu_playlist_update_footer(pane_data[0].artist_name, pane_data[0].track_name)
	else
		local playlist 	= Pause_menu_playlist_editor[0].playlist
		local num_items 	= playlist.num_items

		-- Add it to the playlist
		playlist[num_items] = { 
			label = pane_data[hl_item].label, 
			track_name = pane_data[hl_item].track_name, 
			artist_name = pane_data[hl_item].artist_name, 
			genre = pane_data[hl_item].genre,
			idx = pane_data[hl_item].idx
		}
		playlist.num_items = num_items + 1
		
		-- Remove it from the genre list
		pane_data.num_items = 0
		pane_data.in_genre = false
		vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_genre_tracks", 0, 18, pane_data.genre_number, pane_data.sort_by_artist)		-- 18: Genre 
	end

	-- Check for no items
	if pane_data.num_items == 0 then
		pane_data.num_items = 1
		pane_data.highlighted_item = 0
		pane_data.no_items = true
		pane_data[0] = { label = "PLIST_NO_TRACKS", artist_name = "", track_name = "" }
		pause_menu_playlist_update_footer("", "")
	else
		local hl_item = pane_data.highlighted_item
		if hl_item >= pane_data.num_items then
			hl_item = pane_data.num_items - 1
		end
		pause_menu_playlist_update_footer(pane_data[hl_item].artist_name, pane_data[hl_item].track_name)
		pane_data.no_items = false
	end
	
	btn_tips_update()
	pause_menu_playlist_refresh()
end

function pause_menu_playlist_horz_show(horz_selection)
	Pause_menu_option_horz_swap_menu = horz_selection
	Pause_menu_playlist_editor.block_sort = true
	local indices = { }
	local playlist = table_clone(Pause_menu_playlist_editor[0].playlist)
	local pos = 0
	for i = 0, playlist.num_items - 1 do
		indices[pos] = playlist[i].genre
		indices[pos + 1] =  playlist[i].idx
		pos = pos + 2
	end
	
	if playlist_is_dirty(indices) == true then
		local header = "PAUSE_MENU_PLAYLIST_SAVE_TITLE"
		local body = "PAUSE_MENU_PLAYLIST_SAVE_PROMPT" 	-- Would you like to save your changes?
		local options = { [0] = "CONTROL_YES", [1] = "CONTROL_NO", [2] = "CONTROL_CANCEL" }
		dialog_box_open(header, body, options, "pause_menu_playlist_cb", 0, DIALOG_PRIORITY_ACTION)
	else 
		pause_menu_playlist_cb(1, DIALOG_ACTION_CLOSE)
	end

end

function pause_menu_playlist_plist_back()
	pause_menu_playlist_edit_back()
end

function pause_menu_playlist_cb(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		local indices = { }
		local playlist = table_clone(Pause_menu_playlist_editor[0].playlist)
		local pos = 0
		for i = 0, playlist.num_items - 1 do
			indices[pos] = playlist[i].genre
			indices[pos + 1] =  playlist[i].idx
			pos = pos + 2
		end
		
		playlist_save_list(indices, Pause_menu_playlist_editor[0].arrow_index)
		Pause_menu_playlist_editor.block_sort = false
	end
	
	if result == 0 or result == 1 then
		local menu_label = Menu_option_labels[0]
		--	Unsubscribe to input
		if menu_label.input ~= nil then
			for idx, val in menu_label.input do
				vint_unsubscribe_to_input_event(val)
			end
		end
		menu_label.input = nil

		if Pause_menu_option_horz_swap_menu ~= -1 then
			menu_horz_do_nav(Pause_menu_option_horz_swap_menu)
			menu_show(Menu_horz_active[Pause_menu_option_horz_swap_menu].sub_menu, MENU_TRANSITION_SWAP)
			Pause_menu_option_horz_swap_menu = -1
		else 
		
			if Pause_menu_exit_after == true then
				pause_menu_exit()
				return
			end
			
			menu_show(Pause_menu_playlist_editor.parent_menu, MENU_TRANSITION_SWEEP_RIGHT)
			audio_play(Menu_sound_back)
		end
	end
	
	Pause_menu_playlist_editor.block_sort = false
	Pause_menu_swap_to_map = false
	Pause_menu_exit_after = false
	
end

function pause_menu_playlist_confirm_exit()
	Pause_menu_swap_to_map = false
	Pause_menu_exit_after = true
	Pause_menu_playlist_editor.block_sort = true
	
	local indices = { }
	local playlist = table_clone(Pause_menu_playlist_editor[0].playlist)
	local pos = 0
	for i = 0, playlist.num_items - 1 do
		indices[pos] = playlist[i].genre
		indices[pos + 1] =  playlist[i].idx
		pos = pos + 2
	end
	
	if playlist_is_dirty(indices) == true then
		local header = "PAUSE_MENU_PLAYLIST_SAVE_TITLE"
		local body = "PAUSE_MENU_PLAYLIST_SAVE_PROMPT" 	-- Would you like to save your changes?
		local options = { [0] = "CONTROL_YES", [1] = "CONTROL_NO", [2] = "CONTROL_CANCEL" }
		dialog_box_open(header, body, options, "pause_menu_playlist_cb", 0, DIALOG_PRIORITY_ACTION)
	else 
		pause_menu_playlist_cb(1, DIALOG_ACTION_CLOSE)
	end

end

function pause_menu_playlist_confirm_swap()

	if pause_menu_can_swap() == false then
		return
	end
	
	Pause_menu_swap_to_map = true
	Pause_menu_exit_after = true
	Pause_menu_playlist_editor.block_sort = true
	local indices = { }
	local playlist = table_clone(Pause_menu_playlist_editor[0].playlist)
	local pos = 0
	for i = 0, playlist.num_items - 1 do
		indices[pos] = playlist[i].genre
		indices[pos + 1] =  playlist[i].idx
		pos = pos + 2
	end
	
	if playlist_is_dirty(indices) == true then
		local header = "PAUSE_MENU_PLAYLIST_SAVE_TITLE"
		local body = "PAUSE_MENU_PLAYLIST_SAVE_PROMPT" 	-- Would you like to save your changes?
		local options = { [0] = "CONTROL_YES", [1] = "CONTROL_NO", [2] = "CONTROL_CANCEL" }
		dialog_box_open(header, body, options, "pause_menu_playlist_cb", 0, DIALOG_PRIORITY_ACTION)
	else 
		pause_menu_playlist_cb(1, DIALOG_ACTION_CLOSE)
	end

end

function pause_menu_playlist_edit_back()
	local pane_data = Pause_menu_playlist_editor[0].edit

	if pane_data.in_genre == true then
		local indices = { }
		local playlist = table_clone(Pause_menu_playlist_editor[0].playlist)
		local pos = 0
		for i = 0, playlist.num_items - 1 do
			indices[pos] = playlist[i].genre
			indices[pos + 1] =  playlist[i].idx
			pos = pos + 2
		end
		
		if playlist_is_dirty(indices) == true then
			local header = "PAUSE_MENU_PLAYLIST_SAVE_TITLE"
			local body = "PAUSE_MENU_PLAYLIST_SAVE_PROMPT" 	-- Would you like to save your changes?
			local options = { [0] = "CONTROL_YES", [1] = "CONTROL_NO", [2] = "CONTROL_CANCEL" }
			Pause_menu_playlist_editor.block_sort = true
			dialog_box_open(header, body, options, "pause_menu_playlist_cb", 0, DIALOG_PRIORITY_ACTION)
		else 
			pause_menu_playlist_cb(1, DIALOG_ACTION_CLOSE)
		end
	
		return
	end
	
	pane_data.num_items = 0
	pane_data.no_items = false
	pane_data.in_genre = true
	pane_data.highlighted_item = pane_data.old_hl_item
	pane_data.first_vis_index = pane_data.old_first_index
	
	vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_genre", 0, 18, -1)		-- 18: Genre 
	pause_menu_playlist_refresh()
	
	local active_pane = Pause_menu_playlist_editor[0].active_pane
	local hl_item = active_pane.highlighted_item
	pause_menu_playlist_update_footer(active_pane[hl_item].artist_name, active_pane[hl_item].track_name)
end

function pause_menu_control_playlist_alt_select(menu_label, menu_data)
	if menu_data.active_pane.in_genre == true then
		return
	end

	if menu_data.active_pane.no_items == true then
		return
	end
	
	if menu_label.active_pane == menu_label.edit then
		local play_index = menu_data.active_pane.highlighted_item
		menu_data.arrow_index = -1
		pause_menu_control_playlist_update_arrow(menu_label, menu_data)
		vint_set_property(menu_label.arrow_h, "visible", false)

		if menu_data.active_pane.playing == play_index then
			if playlist_is_playing() == true then
				playlist_play_track(0, 0, true)
				return
			end
		end
		
		menu_data.active_pane.playing = play_index		
		playlist_play_track(menu_data.active_pane[play_index].genre, menu_data.active_pane[play_index].idx)
		return
	end
	
	local arrow_index = menu_data.active_pane.highlighted_item
	
	if arrow_index ~= menu_data.arrow_index then
		menu_data.arrow_index = arrow_index
		-- Play song
		local play_index = menu_data.active_pane.highlighted_item
		playlist_play_track(menu_data.active_pane[play_index].genre, menu_data.active_pane[play_index].idx)
	else
		menu_data.arrow_index = -1
		-- stop song
		playlist_play_track(0, 0, true)
	end
	
	pause_menu_control_playlist_update_arrow(menu_label, menu_data)
end

------------
-- Content Functions
------------

function pause_menu_playlist_build_footer(menu_data)
	local grp = vint_object_clone(vint_object_find("plist_footer"), Menu_option_labels.control_parent)
	vint_set_property(grp, "visible", true)

	if menu_data.footer ~= nil and menu_data.footer.footer_grp ~= nil and menu_data.footer.footer_grp ~= 0 then
		vint_object_destroy(menu_data.footer.footer_grp)
	end

	menu_data.footer = { }
	menu_data.footer.footer_grp = grp
	
	menu_data.footer.title_h 	= vint_object_find("title_label", grp)
	menu_data.footer.artist_h 	= vint_object_find("artist_label", grp)
	
	menu_data.footer.title_text_h = vint_object_find("title_text", grp)
	menu_data.footer.artist_text_h = vint_object_find("artist_text", grp)
	
	local x,y = vint_get_property(menu_data.footer.title_h, "anchor")
	local width, height = element_get_actual_size(menu_data.footer.title_h)
	vint_set_property(menu_data.footer.title_text_h, "anchor", width + x + 5, y)
	
	x,y = vint_get_property(menu_data.footer.artist_h, "anchor")
	width, height = element_get_actual_size(menu_data.footer.artist_h)
	vint_set_property(menu_data.footer.artist_text_h, "anchor", width + x + 5, y)
	
	vint_set_property(menu_data.footer.title_text_h, "tint", MENU_FOOTER_CASH_NORMAL_COLOR.R, MENU_FOOTER_CASH_NORMAL_COLOR.G, MENU_FOOTER_CASH_NORMAL_COLOR.B)
	vint_set_property(menu_data.footer.artist_text_h, "tint", MENU_FOOTER_CASH_NORMAL_COLOR.R, MENU_FOOTER_CASH_NORMAL_COLOR.G, MENU_FOOTER_CASH_NORMAL_COLOR.B)
end

function pause_menu_playlist_update_footer(artist, track)
	local track_h = Pause_menu_playlist_editor.footer.title_text_h
	local artist_h = Pause_menu_playlist_editor.footer.artist_text_h
	
	vint_set_property(track_h, "text_tag", track)
	vint_set_property(artist_h, "text_tag", artist)
end

function pause_menu_playlist_show(menu_data)

	-- Initialize everything
	menu_data[0].edit 		= { 
		num_items = 0, 
		first_vis_item = 0, 
		highlighted_item = 0, 
		in_genre = true, 	
		on_back = pause_menu_playlist_edit_back,
		on_select = pause_menu_playlist_edit_select,	
		btn_tips = Pause_menu_playlist_left_tips, 	
	}
	
	menu_data[0].playlist 	= { 
		num_items = 0, 
		first_vis_item = 0, 
		highlighted_item = 0, 
		on_back = pause_menu_playlist_plist_back,
		on_select = pause_menu_playlist_plist_select, 		
		btn_tips = Pause_menu_playlist_right_tips,	
	}

	menu_data[0].arrow_index = -1
	menu_data[0].sort_by_artist = false
	-- Set the inpuit callback for the right stick
	pause_menu_set_playlist_input_callback("pause_menu_playlist_rs_input")

	--	Populate the menu
	vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_playlist", 0, 17) 	-- 17: Playlist
	vint_dataresponder_request("pause_menu_populate", "pause_menu_playlist_populate_genre", 0, 18, -1)		-- 18: Genre -1: No specific genre (list genres)
	Pause_menu_playlist_editor.block_sort = false
	
	-- Check for no items
	local pane_data = menu_data[0].edit
	if pane_data.num_items == 0 then
		pane_data.num_items = 1
		pane_data.no_items = true
		pane_data[0] = { label = "No tracks available", artist_name = "", track_name = "" }
	else
		pane_data.no_items = false
	end

	--	Set the active pane and the current button tips
	menu_data[0].active_pane = menu_data[0].edit
	menu_data.btn_tips = menu_data[0].active_pane.btn_tips

	Pause_menu_playlist_right_tips.x_button.label = "MP3_PLAY_STATE_PLAY"
	btn_tips_update()
	
	-- And finally, build the footer
	pause_menu_playlist_build_footer(menu_data)
	pause_menu_playlist_update_footer(menu_data[0].active_pane[0].artist_name, menu_data[0].active_pane[0].artist_name)
end

function pause_menu_playlist_populate_genre(genre_name, index)
	local menu_data = Pause_menu_playlist_editor[0].edit
	local num_items = menu_data.num_items
	
	menu_data[num_items] = { label = genre_name, idx = index, artist_name = "", track_name = "" }
	
	menu_data.num_items = num_items + 1
end

function pause_menu_playlist_populate_genre_tracks(track_name, artist_name, genre, index)
	local menu_data = Pause_menu_playlist_editor[0].edit
	local playlist_menu = Pause_menu_playlist_editor[0].playlist
	local num_items = menu_data.num_items
	local is_on_playlist = false
	
	for i = 0, playlist_menu.num_items - 1 do
		if track_name == playlist_menu[i].track_name then
			is_on_playlist = true
			break
		end
	end
	
	if is_on_playlist == false then
		menu_data[num_items] = { label = track_name, track_name = track_name, artist_name = artist_name, genre = genre, idx = index }
		menu_data.num_items = num_items + 1
	end
end

function pause_menu_playlist_populate_playlist(track_name, artist_name, genre, index)
	local menu_data = Pause_menu_playlist_editor[0].playlist
	local num_items = menu_data.num_items
	
	menu_data[num_items] = { label = track_name, track_name = track_name, artist_name = artist_name, genre = genre, idx = index }
	
	menu_data.num_items = num_items + 1
	
end

function pause_menu_playlist_post_show(menu_data)
	Menu_option_labels[0].active_pane = Menu_option_labels[0].edit
	Menu_option_labels[0].edit.select_bar_width = PLAYLIST_LEFT_SELECTBAR_WIDTH
	Menu_option_labels[0].playlist.select_bar_width = PLAYLIST_RIGHT_SELECTBAR_WIDTH

	pause_menu_playlist_update_clip_region()
	
	-- Create the scroll bars
	pause_menu_playlist_create_scroll_bar(Menu_option_labels[0].edit, menu_data[0].edit)
	pause_menu_playlist_create_scroll_bar(Menu_option_labels[0].playlist, menu_data[0].playlist)

	pause_menu_control_playlist_update_arrow(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	pause_menu_control_playlist_update_selectbar(Menu_option_labels[0], Pause_menu_playlist_editor[0])
	pause_menu_playlist_resize_select_bar()
end

function pause_menu_playlist_update_clip_region()
	local w, height = element_get_actual_size(Menu_option_labels[0].edit_clip_h)
	
	local edit_sel_bar_width = 0
	local playlist_sel_bar_width = 0
	
	if Pause_menu_playlist_editor[0].edit.has_scroll_bar == true then
		edit_sel_bar_width = 40
	end
	
	if Pause_menu_playlist_editor[0].playlist.has_scroll_bar == true then
		playlist_sel_bar_width = 40
	end
	
	vint_set_property(Menu_option_labels[0].edit_clip_h, "clip_size", PLAYLIST_LEFT_SELECTBAR_WIDTH - 7 - edit_sel_bar_width, 1000)
	vint_set_property(Menu_option_labels[0].playlist_clip_h, "clip_size", PLAYLIST_RIGHT_SELECTBAR_WIDTH - 7 - playlist_sel_bar_width, 1000)
end

function pause_menu_playlist_get_width()
	return PLAYLIST_WIDTH
end

function pause_menu_playlist_get_height()
	return PLAYLIST_HEIGHT
end

--------------------------------------[ SCOREBOARD ]--------------------------------------
SCOREBOARD_DOC_H = 0
function pause_menu_control_scoreboard_on_show(menu_label, menu_data)

	
	if get_is_syslink() then
		Pause_score_board.btn_tips = Multi_scoreboard_tips_syslink
	else
		Pause_score_board.btn_tips = Multi_scoreboard_tips
	end
	

	vint_document_load("mp_scoreboard")
	SCOREBOARD_DOC_H = vint_document_find("mp_scoreboard")
	
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_SCOREBOARD then
			-- this isn't my control so release it
			menu_release_control(control)
			control = nil
		end
	end

	vint_set_property(menu_label.label_h, "text_tag", "")	
	
	if control == nil then
		vint_object_set_parent(vint_object_find("mp_scoreboard", nil, SCOREBOARD_DOC_H), Menu_option_labels.control_parent)
		local control_h = vint_object_find("mp_scoreboard")
		vint_set_property(control_h, "anchor", 0, 0)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_SCOREBOARD, is_highlighted = false }
		menu_label.control = control		
	end
	
	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x, menu_label.anchor_y - 67)
	vint_set_property(control.grp_h, "depth", menu_label.depth)

end

function pause_menu_control_scoreboard_on_release(control)
	vint_object_destroy(control.grp_h)
	vint_document_unload(SCOREBOARD_DOC_H)
	SCOREBOARD_DOC_H = 0
end

function pause_menu_scoreboard_get_width(menu_data)
	return SCOREBOARD_WIDTH
end

function pause_menu_scoreboard_get_height(menu_data)
	return SCOREBOARD_HEIGHT
end

function pause_menu_scoreboard_show(menu_data)
	-- vint_dataresponder_request("Mp_scoreboard_populate, "mp_scoreboard_populate", 0)

end

--------------------------------------[ LOBBY_PLAYERS ]--------------------------------------
LOBBY_PLAYERS_DOC_H = 0
function pause_menu_control_lobby_players_on_show(menu_label, menu_data)
	vint_document_load("mp_lobby_players")
	LOBBY_PLAYERS_DOC_H = vint_document_find("mp_lobby_players")
	
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_LOBBY_PLAYERS then
			-- this isn't my control so release it
			menu_release_control(control)
			control = nil
		end
	end

	vint_set_property(menu_label.label_h, "text_tag", "")	
	
	if control == nil then
		vint_object_set_parent(vint_object_find("mp_lobby_players", nil, LOBBY_PLAYERS_DOC_H), Menu_option_labels.control_parent)
		local control_h = vint_object_find("mp_lobby_players")
		vint_set_property(control_h, "anchor", 0, 0)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_LOBBY_PLAYERS, is_highlighted = false }
		menu_label.control = control		
	end
	
	--	Show the new control
	vint_set_property(control.grp_h, "visible", true)
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x, menu_label.anchor_y - 67)
	vint_set_property(control.grp_h, "depth", menu_label.depth)

end

function pause_menu_control_lobby_players_on_release(control)
	vint_object_destroy(control.grp_h)
	vint_document_unload(LOBBY_PLAYERS_DOC_H)
	LOBBY_PLAYERS_DOC_H = 0
end

function pause_menu_lobby_players_get_width(menu_data)
	return LOBBY_PLAYERS_WIDTH
end

function pause_menu_lobby_players_get_height(menu_data)
	return LOBBY_PLAYERS_HEIGHT
end

--------------------------------------[ COMMON ]--------------------------------------
function pause_menu_update_custom_control()
	local h, ch, item, label_w, control

	-- set the labels and hide unused
	for i = 0, Menu_option_labels.max_rows - 1 do
		if Menu_active.first_vis_item < 0 then
			Menu_active.first_vis_item = 0
		end
		
		item = Menu_active.first_vis_item + i
		if item < Menu_active.num_items then
			local item_type = Menu_active[item].type
			
			-- update control
			local cb = Menu_control_callbacks[item_type]
			if cb ~= nil then
				if cb.on_show ~= nil then
					cb.on_show(Menu_option_labels[i], Menu_active[item])
				end
			end
			
			vint_set_property(Menu_option_labels[i].stripe_h, "visible", true)
		else
			if Menu_option_labels[i].control ~= nil then
				h = Menu_option_labels[i].control.grp_h
				vint_set_property(Menu_option_labels[i].stripe_h, "visible", false)
				vint_set_property(h, "visible", false)
			end
		end
	end

	-- update scroll bar
	if Menu_option_labels.scroll_bar_visible == true then
		menu_scroll_bar_set_thumb_pos(Menu_active.first_vis_item / (Menu_active.num_items - Menu_option_labels.max_rows))
	end
end

function pause_menu_control_nav_up(menu_label, menu_data)
	if Menu_active.first_vis_item > 0 then
		Menu_active.first_vis_item = Menu_active.first_vis_item - 1
	end
	pause_menu_update_custom_control()
	menu_scroll_bar_set_thumb_pos(Menu_active.first_vis_item / (Menu_active.num_items - Menu_option_labels.max_rows))
	
	if Menu_active.on_nav ~= nil then
		Menu_active.on_nav(Menu_active)
	end
end

function pause_menu_control_nav_down(menu_label, menu_data)
	if Menu_active.first_vis_item < Menu_active.num_items then
		Menu_active.first_vis_item = Menu_active.first_vis_item + 1
	end
	if Menu_active.first_vis_item > Menu_active.num_items - Menu_option_labels.max_rows then
		Menu_active.first_vis_item = Menu_active.num_items - Menu_option_labels.max_rows 
	end
	
	pause_menu_update_custom_control()
	menu_scroll_bar_set_thumb_pos(Menu_active.first_vis_item / (Menu_active.num_items - Menu_option_labels.max_rows))
	
	if Menu_active.on_nav ~= nil then
		Menu_active.on_nav(Menu_active)
	end
end

function pause_menu_control_page_up(menu_label, menu_data)
	if Pause_menu_page.current == nil then
		return
	end

	if Pause_menu_page.current > 1 then
		Menu_active.first_vis_item = Menu_active.first_vis_item - Menu_option_labels.max_rows
		Pause_menu_page.current = Pause_menu_page.current - 1
	end
		
	if Menu_active.first_vis_item < 0 then
		Menu_active.first_vis_item = 0
	end
	
	pause_menu_update_page()
	pause_menu_update_custom_control()
	menu_scroll_bar_hide()
	
	if Menu_active.on_nav ~= nil then
		Menu_active.on_nav(Menu_active)
	end
end

function pause_menu_control_page_down(menu_label, menu_data)
	if Pause_menu_page.current == nil then
		return
	end
	
	if Pause_menu_page.current < Pause_menu_page.max then
		Menu_active.first_vis_item = Menu_active.first_vis_item + Menu_option_labels.max_rows
		Pause_menu_page.current = Pause_menu_page.current + 1
	end
	
	pause_menu_update_page()
	pause_menu_update_custom_control()
	menu_scroll_bar_hide()
	
	if Menu_active.on_nav ~= nil then
		Menu_active.on_nav(Menu_active)
	end
end

function pause_menu_control_release(control)
	if control == nil then
		return
	end
	
	if control.grp_h ~= nil then
		vint_object_destroy(control.grp_h)
		control.grp_h = nil
	end
end

----------------[ SAVE LOAD CONTROL ]----------------

function pause_menu_control_save_load_show(menu_label, menu_data)
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_SAVE_LOAD then
			-- this isn't my control type so release it
			menu_release_control(control)
			control = nil
		end
	end
	
	vint_set_property(menu_label.label_h, "text_tag", "")

	if control == nil then
		local master_h = vint_object_find("save_game_control")
		local control_h = vint_object_clone(master_h, Menu_option_labels.control_parent)
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_SAVE_LOAD, is_highlighted = false }
		vint_set_property(control.grp_h, "visible", true)
		menu_label.control = control

		-- store handles of elements
		menu_label.last_mission_name_h = vint_object_find("last_mission_name", control_h)
		menu_label.percent_complete_h = vint_object_find("percent_complete", control_h)
		menu_label.cheats_enabled_h = vint_object_find("cheats_enabled", control_h)
		menu_label.game_time_h = vint_object_find("game_time", control_h)
	--	menu_label.missions_complete_h = vint_object_find("missions_complete", control_h)
		menu_label.size_point_h = vint_object_find("size_point", control_h)
	end

	-- update pos and depth
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x, menu_label.anchor_y)
	vint_set_property(control.grp_h, "depth", menu_label.depth)
	vint_set_property(menu_label.size_point_h, "anchor", Menu_option_labels.item_width - 150, 0)
	
	--	Update the values
	local label
	if menu_data.autosave == true then
		label = "SAVELOAD_AUTOSAVE_LABEL"
	else
		label = menu_data.last_mission_name
	end
	vint_set_property(menu_label.last_mission_name_h, "text_tag", label)
	
	vint_set_property(menu_label.percent_complete_h, "text_tag", menu_data.percent_complete.."%")
	vint_set_property(menu_label.game_time_h, "text_tag", menu_data.game_time)
	--vint_set_property(menu_label.missions_complete_h, "text_tag", menu_data.missions_complete)
	vint_set_property(menu_label.cheats_enabled_h, "visible", menu_data.cheats_enabled)

end

function pause_menu_control_save_load_enter(menu_label, menu_data)
	local clone = vint_object_clone(menu_label.control.grp_h, Menu_option_labels.hl_bar)
	menu_label.control.hl_control = clone
	vint_set_property(clone, "anchor", 5, 0)
	
	for i, n in { "last_mission_name", "percent_complete", "game_time" } do
		local t = vint_object_find(n, clone)		
		vint_set_property(t, "tint", 0, 0, 0)
		vint_set_property(t, "font", "thin")
	end
end

function pause_menu_control_save_load_release(control)
	if control.hl_control ~= nil then
		vint_object_destroy(control.hl_control)
		control.hl_control = nil
	end
	
	if control.grp_h ~= nil then
		vint_object_destroy(control.grp_h)
		control.grp_h = nil
	end
end

function pause_menu_control_save_load_leave(menu_label, menu_data)
	local control = menu_label.control
	if control.hl_control ~= nil then
		vint_object_destroy(control.hl_control)
		control.hl_control = nil
	end
end

function pause_menu_control_save_load_get_width(menu_item)

	local h = vint_object_find("save_game_header")
	local status_h = vint_object_find("game_status",h)
	local difficulty_h = vint_object_find("difficulty",h)
	local width = element_get_actual_size(status_h) + element_get_actual_size(difficulty_h)
	width = width + 200

	return width
end

Pause_save_new_master = 0

function pause_menu_control_centered_label_get_master()
	if Pause_save_new_master == 0 then
		Pause_save_new_master = vint_object_create("save_new_game_label", "text", vint_object_find("safe_frame"))
		-- the doc is checked out by other persons so I'll build it manually
--		vint_set_property(Pause_save_new_master, "text_tag", "SAVELOAD_NEW_SAVE_GAME")
		vint_set_property(Pause_save_new_master, "tint", 0.3647, 0.3725, 0.384)
		vint_set_property(Pause_save_new_master, "auto_offset", "c")
		vint_set_property(Pause_save_new_master, "font", "thin_overlay")
		vint_set_property(Pause_save_new_master, "scale", 0.68, 0.68)
		vint_set_property(Pause_save_new_master, "visible", false)
	end
	
	return Pause_save_new_master
end

function pause_menu_control_centered_label_show(menu_label, menu_data)
	local control = menu_label.control

	if control ~= nil then
		if control.type ~= PAUSE_MENU_CONTROL_CENTERED_LABEL then
			-- this isn't my control type so release it
			menu_release_control(control)
			control = nil
		end
	end
	
	vint_set_property(menu_label.label_h, "text_tag", "")

	if control == nil then
		local control_h = vint_object_clone(pause_menu_control_centered_label_get_master(), Menu_option_labels.control_parent)
		
		control = { grp_h = control_h, type = PAUSE_MENU_CONTROL_CENTERED_LABEL, is_highlighted = false }
		menu_label.control = control
		vint_set_property(control_h, "visible", true)
	end

	-- update pos and depth
	vint_set_property(control.grp_h, "anchor", menu_label.anchor_x + Menu_option_labels.item_width * 0.5, menu_label.anchor_y)
	vint_set_property(control.grp_h, "depth", menu_label.depth)
	vint_set_property(control.grp_h, "text_tag", menu_data.label_str)

end

function pause_menu_control_centered_label_enter(menu_label, menu_data)
	local clone = vint_object_clone(menu_label.control.grp_h, Menu_option_labels.hl_bar)
	menu_label.control.hl_control = clone
	vint_set_property(clone, "anchor", 5 + (Menu_option_labels.item_width * 0.5), 0)
	vint_set_property(clone, "tint", 0, 0, 0)
	vint_set_property(clone, "font", "thin")
end

function pause_menu_control_centered_label_release(control)
	if control.hl_control ~= nil then
		vint_object_destroy(control.hl_control)
		control.hl_control = nil
	end
	
	if control.grp_h ~= nil then
		vint_object_destroy(control.grp_h)
		control.grp_h = nil
	end
end

function pause_menu_control_centered_label_leave(menu_label, menu_data)
	local control = menu_label.control
	if control.hl_control ~= nil then
		vint_object_destroy(control.hl_control)
		control.hl_control = nil
	end
end

function pause_menu_control_centered_label_get_width(menu_item)
	local master_h = pause_menu_control_centered_label_get_master()
	vint_set_property(master_h, "text_tag", menu_item.label_str)
	local w = vint_get_property(master_h, "unscaled_size")
	return w * 0.68
end

----------------[ SAVE LOAD MENU ]----------------

Pause_save_global_info = { }
Pause_save_cheats_enabled_color = { r = 1, g = .5, b = .25 }
Pause_save_cheats_disabled_color = { r = .3, g = .3, b = .3 }
Pause_save_crib_peg_refs = 0

Pause_save_team_icons = {
	[0] = "ui_hud_act_ico_saints",
	[1] = "ui_hud_act_ico_samedi",
	[2] = "ui_hud_act_ico_ronin",
	[3] = "ui_hud_act_ico_ultor",
	[4] = "ui_hud_act_ico_brotherhood",
}

function pause_save_load_crib_peg()
	if Pause_save_crib_peg_refs == 0 then
		peg_load("ui_crib_photos")
	end
	
	Pause_save_crib_peg_refs = Pause_save_crib_peg_refs + 1
end

function pause_save_unload_crib_peg()
	if Pause_save_crib_peg_refs == 1 then
		peg_unload("ui_crib_photos")
	end

	Pause_save_crib_peg_refs = Pause_save_crib_peg_refs - 1
end

function pause_save_get_device_result(success, cancelled)
	if success == true then
		thread_new("pause_save_get_device_result_deferred")
	elseif Pause_menu_save_for_server_drop == true then
		if cancelled == false then
			thread_new("pause_save_get_device_deferred")
		else
			vint_document_unload(vint_document_find("pause_menu"))
		end
	end
end

function pause_save_get_device_result_deferred()
	pause_save_get_global_info()
	menu_show(Pause_save_menu, MENU_TRANSITION_SWEEP_LEFT)
end

-- called by C if the current device is removed
function pause_save_device_removed()
	if Menu_active ~= 0 then
		if Menu_active.is_load_menu == true or Menu_active.is_save_menu == true then
			dialog_box_message("MENU_TITLE_WARNING", "SAVELOAD_SELECTED_DEVICE_REMOVED_FULL")
			Menu_active.on_back()
		end
	end
end

function pause_save_get_device_deferred()
	vint_dataresponder_request("save_load", "pause_save_get_device_result", 0, "get_device")
end

function pause_save_menu_select()
	thread_new("pause_save_sign_in_deferred")
end

function pause_save_sign_in_deferred()
	vint_dataresponder_request("save_load", "pause_save_sign_in_result", 0, "sign_in")
end

function pause_save_sign_in_result(success)
	if success == false then
		if Pause_menu_return_to_main ~= 0 then
			Pause_menu_return_to_main()
		end
	else
		thread_new("pause_save_get_device_deferred")
	end
end

function pause_save_get_global_info(get_device)
	vint_dataresponder_request("save_load", "pause_save_consume_global_info", 0, "global_info", get_device == true)
end

function pause_save_menu_select_deferred()
	pause_save_get_global_info()
	
	if Pause_save_global_info.device_selected == true and Pause_save_global_info.in_profile == true then
		local t
		if Menu_mode_current == "pause" then
			t = MENU_TRANSITION_SWEEP_LEFT
		else
			t = MENU_TRANSITION_SWAP
		end
		
		menu_show(Pause_save_pending_menu, t)
	elseif Pause_menu_save_for_server_drop == true then
		vint_document_unload(vint_document_find("pause_menu"))
	end
end

function pause_save_consume_global_info(can_save_new, device_selected, total_missions, total_hoods, continue_avail, in_profile)
	Pause_save_global_info.can_save_new = can_save_new
	Pause_save_global_info.device_selected = device_selected
	Pause_save_global_info.total_missions = total_missions
	Pause_save_global_info.total_hoods = total_hoods
	Pause_save_global_info.continue_avail = continue_avail
	Pause_save_global_info.in_profile = in_profile
end

function pause_save_populate_header(handle, last_mission_name, last_mission_icon, loadable, missions, hoods, crib_photo, cheats, time_played, difficulty, autosave, percent_complete)
	-- not used: handle, loadable
	local hdr = Menu_option_labels.header_h

	local o = vint_object_find("last_mission_logo", hdr)
	vint_set_property(o, "image", last_mission_icon)

	o = vint_object_find("missions_complete", hdr)
	vint_set_property(o, "insert_values", missions, 0)
	
	o = vint_object_find("game_status", hdr)
	vint_set_property(o, "insert_values", percent_complete.."%", 0)

	time_played = floor(time_played)
	local hours = floor(time_played / 60)
	local minutes = time_played - (hours * 60)
	if minutes > 9 then
		vint_set_property(o, "insert_values", hours..":"..minutes, 1)
	else
		vint_set_property(o, "insert_values", hours..":0"..minutes, 1)
	end
	
	o = vint_object_find("hoods_owned", hdr)
	vint_set_property(o, "insert_values", hoods, 0)
	vint_set_property(o, "insert_values", Pause_save_global_info.total_hoods, 1)
	
	o = vint_object_find("cheats_enabled", hdr)
	vint_set_property(o, "visible", cheats)
	
	o = vint_object_find("difficulty", hdr)
	vint_set_property(o, "insert_values", difficulty, 0)
end

function pause_save_show(menu_data)
	-- clone the header CLUSTER
	local header_h = vint_object_clone(vint_object_find("save_game_header"), Menu_option_labels.control_parent)
	vint_set_property(header_h, "anchor", 0, 0)
	vint_set_property(header_h, "visible", true)
	Menu_option_labels.header_h = header_h
	
	-- now put some info in header
	vint_dataresponder_request("save_load", "pause_save_populate_header", 0, "current")
	
	if Pause_save_global_info.can_save_new == true then
		menu_data[0] = { 
			type = PAUSE_MENU_CONTROL_CENTERED_LABEL,
			label_str = "SAVELOAD_NEW_SAVE_GAME",
			on_select = pause_save_save_new_selected
		}
		
		menu_data.num_items = 1
	else
		menu_data.num_items = 0
	end
	
	Pause_menu_building = menu_data
	vint_dataresponder_request("save_load", "pause_save_add_item", 0, "save_files")

	if get_platform() ~= "PS3" then
		if menu_data.num_items == 0 then
			dialog_box_message("MENU_TITLE_WARNING", "SAVELOAD_CANNOT_SAVE_TO_FULL_DEVICE")
			
			menu_data[0] = {
				type = PAUSE_MENU_CONTROL_CENTERED_LABEL,
				label_str = "SAVELOAD_SELECT_DEVICE",
				on_select = pause_save_select_device
			}
			
			menu_data.num_items = 1
		end
		
	else -- if ps3
	
		if Pause_save_global_info.can_save_new == false then
		
			pause_menu_error_message_while_saving_PS3()
			if menu_data.num_items == 0 then
			
				menu_data[0] = {
					type = PAUSE_MENU_CONTROL_CENTERED_LABEL,
					label_str = "PS3_SAVE_SELECTION_MANAGE_MEMORY",
					on_select = pause_save_delete_data
				}
				menu_data.num_items = 1
			end 
		end
	end
	
	--Object names
	local game_status_h = vint_object_find("game_status", header_h)
	local difficulty_h = vint_object_find("difficulty", header_h)
	local b_w, b_h = element_get_actual_size(difficulty_h)
	local a_w, a_h = element_get_actual_size(game_status_h)
	local a_x, a_y = vint_get_property(game_status_h, "anchor")
	menu_data.header_width = a_x + a_w + b_w + 10
end

function pause_save_add_item(handle, desc, team_index, loadable, missions, hoods, crib_icon, cheats, time_played, difficulty, autosave, percent)
	if autosave == true and Pause_menu_building.is_save_menu == true then
		-- don't show autosave for save over
		return
	end
	
	local num_items = Pause_menu_building.num_items

	local item = { type = PAUSE_MENU_CONTROL_SAVE_LOAD, handle = handle, last_mission_name = desc, autosave = autosave,
		cheats_enabled = cheats, loadable = loadable, crib_icon = crib_icon, difficulty = difficulty, hoods = hoods }
		
	local played_hours = floor(time_played / 60)
	local played_mins = floor(time_played - (played_hours * 60))
	if played_mins > 9 then
		item.game_time = ""..played_hours..":"..played_mins
	else
		item.game_time = ""..played_hours..":0"..played_mins
	end
	
	item.missions_complete = missions

	item.mission_icon = Pause_save_team_icons[team_index]
	if item.mission_icon == nil then
		item.mission_icon = Pause_save_team_icons[0]
	end
	
	item.percent_complete = ""..percent.."%"
	
	item.on_select = pause_save_save_over_select
	Pause_menu_building[num_items] = item
	num_items = num_items + 1     
	Pause_menu_building.num_items = num_items
end

function pause_save_release(menu_data)
	if Menu_option_labels_inactive.header_h ~= nil then
		vint_object_destroy(Menu_option_labels_inactive.header_h)
		Menu_option_labels_inactive.header_h = nil
	end
end

function pause_save_post_show(menu_data)
	if Menu_option_labels.header_h ~= nil then
		local cheats = vint_object_find("cheats_enabled", Menu_option_labels.header_h)
		local ax, ay = vint_get_property(cheats, "anchor")
		vint_set_property(cheats, "anchor", menu_data.menu_width, ay)
		
		local difficulty = vint_object_find("difficulty", Menu_option_labels.header_h)
		local ax, ay = vint_get_property(difficulty, "anchor")
		vint_set_property(difficulty, "anchor", menu_data.menu_width, ay)
		
		--Set Header line width
		vint_set_property(vint_object_find("header_horz", Menu_option_labels.header_h), "source_se", menu_data.menu_width - 10, 10)
	end
end

function pause_save_save_new_selected()
	thread_new("pause_save_save_new_deferred")
end

function pause_save_save_new_deferred()
	menu_input_block(true)
	-- this needs to be deferred since it's a multi-frame operation
	vint_dataresponder_request("save_load", "pause_save_save_new_results", 0, "save_new")
	menu_input_block(false)
end

function pause_save_save_new_results(success)
	if success == true then
		if Pause_menu_save_for_server_drop == true then
			pause_menu_exit()
		else
			menu_show(Pause_save_load_menu, MENU_TRANSITION_SWEEP_LEFT)
		end
	end
end

function pause_save_save_over_select()
	thread_new("pause_save_save_over_deferred")
end

function pause_save_save_over_deferred()
	menu_input_block(true)
	-- this needs to be deferred since it's a multi-frame operation
	local over_handle = Pause_save_menu[Pause_save_menu.highlighted_item].handle
	vint_dataresponder_request("save_load", "pause_save_save_over_results", 0, "save_over", over_handle)
	menu_input_block(false)
end

function pause_save_save_over_results(success)
	if success == true then
		if Pause_menu_save_for_server_drop == true then
			pause_menu_exit()
		else
			menu_show(Pause_save_load_menu, MENU_TRANSITION_SWEEP_LEFT)
		end
	end
end

function pause_save_select_device()
	thread_new("pause_save_select_device2")
end

function pause_save_delete_data()
	thread_new("pause_save_delete_system")
end

function pause_save_select_device2()
	menu_input_block(true)
	vint_dataresponder_request("save_load", "pause_save_refresh", 0, "get_device", true)
	menu_input_block(false)
end

function pause_save_delete_system()
	menu_input_block(true)
	vint_dataresponder_request("save_load", "pause_save_refresh", 0, "delete_data", true)
	menu_input_block(false)
end

function pause_save_dropped_device_response(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		pause_save_select_device()
	else
		pause_menu_exit()
	end
end

function pause_save_refresh(success)
	if success == true then
		pause_save_get_global_info()
		local m = menu_clone(Menu_active)
		menu_show(m, MENU_TRANSITION_NONE)
	else
		if Pause_menu_save_for_server_drop == true then
			local options = { [0] = "OPTION_YES", [1] = "MENU_OPTIONS_QUIT_GAME" }
			dialog_box_open("MENU_TITLE_WARNING", "SAVELOAD_SELECT_DEVICE_NOW", options, "pause_save_dropped_device_response", 0, DIALOG_PRIORITY_ACTION)
		elseif Menu_mode_current == "pause" then
			menu_show(Pause_save_load_menu, MENU_TRANSITION_SWEEP_LEFT)
		else
			if Pause_menu_return_to_main ~= 0 then
				Pause_menu_return_to_main()
			end
		end
	end
end

function pause_load_get_device_success()
	pause_save_get_global_info()

	local t
	if Menu_mode_current == "pause" then
		t = MENU_TRANSITION_SWEEP_LEFT
	else
		t = MENU_TRANSITION_SWAP
	end
	
	if vint_document_find("main_menu") ~= 0 then
		--Darken main menu if we are in it
		main_menu_screen_fade(Main_menu_screen_alpha)
	end
	
	menu_show(Pause_load_menu, t)
end

function pause_load_get_device_result(success)
	if success == false then
		if Pause_menu_return_to_main ~= 0 then
			Pause_menu_return_to_main()
		end
	else
		thread_new("pause_load_get_device_success")
	end
end

function pause_load_get_device_deferred()
	vint_dataresponder_request("save_load", "pause_load_get_device_result", 0, "get_device")
end

function pause_load_sign_in_result(success)
	if success == false then
		if Pause_menu_return_to_main ~= 0 then
			Pause_menu_return_to_main()
		end
	else
		thread_new("pause_load_get_device_deferred")
	end
end

function pause_load_menu_select_deferred()
	vint_dataresponder_request("save_load", "pause_load_sign_in_result", 0, "sign_in")
end

function pause_load_menu_select()
	if get_is_coop_client() == true then
		dialog_box_message("MENU_TITLE_WARNING", "SAVELOAD_LOAD_NOT_AS_CLIENT")
		return
	end

	thread_new("pause_load_menu_select_deferred")
end

function pause_load_show(menu_data)
	local header_h = vint_object_clone(vint_object_find("load_game_header"), Menu_option_labels.control_parent)
	vint_set_property(header_h, "anchor", 0, 0)
	vint_set_property(header_h, "visible", true)
	Menu_option_labels.header_h = header_h
	pause_save_load_crib_peg()
	menu_data.num_items = 0
	
	Pause_menu_building = menu_data
	vint_dataresponder_request("save_load", "pause_save_add_item", 0, "save_files")
	
	menu_data.highlighted_item = 0
	
	if menu_data.num_items > 0 then
		for i = 0, menu_data.num_items - 1 do
			menu_data[i].on_select = pause_load_select
		end
		
		pause_load_nav(Pause_menu_building)
		menu_data.loadable = true
	else
		menu_data[0] = { label = "SAVELOAD_NOTHING_TO_LOAD", type = MENU_ITEM_TYPE_SELECTABLE }
		menu_data.num_items = 1
		menu_data.loadable = false
	end
	
	
	--Calculate Header width
	
	--Object names
	local game_status_h = vint_object_find("game_status", header_h)
	local difficulty_h = vint_object_find("difficulty", header_h)
	local b_w, b_h = element_get_actual_size(difficulty_h)
	local a_w, a_h = element_get_actual_size(game_status_h)
	local a_x, a_y = vint_get_property(game_status_h, "anchor")
	menu_data.header_width = a_x + a_w + b_w + 10
end

function pause_load_release(menu_data)
	if Menu_option_labels_inactive.header_h ~= nil then
		vint_object_destroy(Menu_option_labels_inactive.header_h)
		Menu_option_labels_inactive.header_h = nil
	end
	pause_save_unload_crib_peg()
	Pause_load_is_coop = false
	Pause_load_from_menu = PAUSE_LOAD_FROM_MENU_OTHER
end

function pause_load_post_show(menu_data)
	if Menu_option_labels.header_h ~= nil then
		if menu_data.loadable == true then
			local cheats = vint_object_find("cheats_enabled", Menu_option_labels.header_h)
			local ax, ay = vint_get_property(cheats, "anchor")
			vint_set_property(cheats, "anchor", menu_data.menu_width, ay)
			
			local difficulty = vint_object_find("difficulty", Menu_option_labels.header_h)
			local ax, ay = vint_get_property(difficulty, "anchor")
			vint_set_property(difficulty, "anchor", menu_data.menu_width, ay)
		end
		
		for k, v in {"difficulty", "crib_image", "game_status", "hoods_owned", "last_mission_logo", "missions_complete", "last_mission_name"} do
			local h = vint_object_find(v, Menu_option_labels.header_h)
			vint_set_property(h, "visible", menu_data.loadable)
		end
		--Set Header line width
		vint_set_property(vint_object_find("header_horz", Menu_option_labels.header_h), "source_se", menu_data.menu_width - 10, 10)
	end
end        

function pause_load_nav(menu_data)
	local item = menu_data[menu_data.highlighted_item]
	local hdr = Menu_option_labels.header_h
	local o = vint_object_find("last_mission_name", hdr)
	vint_set_property(o, "text_tag", item.last_mission_name)
	
	o = vint_object_find("last_mission_logo", hdr)
	vint_set_property(o, "image", item.mission_icon)

	o = vint_object_find("missions_complete", hdr)
	vint_set_property(o, "insert_values", item.missions_complete, 0)

	o = vint_object_find("game_status", hdr)
	vint_set_property(o, "insert_values", item.percent_complete, 0)
	vint_set_property(o, "insert_values", item.game_time, 1)
	
	o = vint_object_find("hoods_owned", hdr)
	vint_set_property(o, "insert_values", item.hoods, 0)
	vint_set_property(o, "insert_values", Pause_save_global_info.total_hoods, 1)
	
	o = vint_object_find("cheats_enabled", hdr)
	vint_set_property(o, "visible", item.cheats_enabled)
	
	o = vint_object_find("crib_image", hdr)
	vint_set_property(o, "image", item.crib_icon)
	
	o = vint_object_find("difficulty", hdr)
	vint_set_property(o, "insert_values", item.difficulty, 0)
end

Pause_load_is_coop = false
PAUSE_LOAD_FROM_MENU_OTHER = 0
PAUSE_LOAD_FROM_MENU_COOP_ONLINE = 1
PAUSE_LOAD_FROM_MENU_COOP_SYSLINK = 2
Pause_load_from_menu = PAUSE_LOAD_FROM_MENU_OTHER

function pause_load_select_deferred(handle)
	menu_input_block(true)
	vint_dataresponder_request("save_load", "pause_load_results", 0, "load", handle, Pause_load_is_coop, Pause_load_from_menu)
	menu_input_block(false)
end

function pause_load_select(menu_label, menu_data)
	if menu_data.loadable == true then
		thread_new("pause_load_select_deferred", menu_data.handle)
	else
		dialog_box_message("SAVELOAD_ERROR", "SAVELOAD_FILE_NOT_LOADABLE")
	end
end

function pause_load_results(success)
	if success == true then
		local for_main_menu = Menu_mode_current ~= "pause"
		
		if for_main_menu == true then
			Pause_menu_main_close_ref()
		else
			vint_document_unload()
		end
	end
end

-- coop menu
Coop_pause_loading_friends_dialog_handle = 0
Coop_pause_loading_friends_at_startup = false
Coop_pause_waiting_on_join_dialog_handle = 0

function pause_menu_maybe_quit_game_callback(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end

	if result == 0 then	
		pause_menu_quit_game()
	end
	
end

function coop_player_joined_start()
	start_intro_cutscene()
end

function coop_pause_close_wait_on_join_dialog()
	if Coop_pause_waiting_on_join_dialog_handle ~= 0 then
		dialog_box_force_close(Coop_pause_waiting_on_join_dialog_handle)
		Coop_pause_waiting_on_join_dialog_handle = 0
	end
end

function coop_pause_send_invite_and_wait()
	local result = send_pause_menu_player_invite(Menu_active.highlighted_item)
	if result == true then
		--popup the waiting to end dialogue
		local options = { [0] = "QUIT_TO_MAIN_MENU", [1] = "CONTROL_CANCEL" }
		Coop_pause_waiting_on_join_dialog_handle = dialog_box_open("MENU_TITLE_NOTICE", "MULTI_COOP_WAITING_PLAYER_2", options, "pause_menu_maybe_quit_game_callback", 0, DIALOG_PRIORITY_ACTION, false, true)
	else
		local style_insert = {[0] = Coop_pause_invite_player_menu[Menu_active.highlighted_item].label}
		local style_string = vint_insert_values_in_string("INVITE_FAILED_BODY", style_insert)
		dialog_box_message("INVITE_FAILED_TITLE", style_string)
	end
end

function pause_menu_get_gamercard()
	debug_print("vint", "Get friend gamercard here!\n")
	show_pause_menu_friend_gamercard(Menu_active.highlighted_item)
end

function coop_pause_just_wait()
	--popup the waiting to end dialogue
	local options = { [0] = "QUIT_TO_MAIN_MENU", [1] = "CONTROL_CANCEL" }
	Coop_pause_waiting_on_join_dialog_handle = dialog_box_open("MENU_TITLE_NOTICE", "MULTI_COOP_WAITING_PLAYER_2", options, "pause_menu_maybe_quit_game_callback", 0, DIALOG_PRIORITY_ACTION, false, true)
end

function coop_pause_send_invite()
	local result = send_pause_menu_player_invite(Menu_active.highlighted_item)
	
	if result == true then
		--say we invited the friend  
		local style_insert = {[0] = Coop_pause_invite_player_menu[Menu_active.highlighted_item].label}
		local style_string = vint_insert_values_in_string("MP_INVITE_SENT_BODY", style_insert)
		dialog_box_message("MP_INVITE_SENT_TITLE", style_string)
	else
		local style_insert = {[0] = Coop_pause_invite_player_menu[Menu_active.highlighted_item].label}
		local style_string = vint_insert_values_in_string("INVITE_FAILED_BODY", style_insert)
		dialog_box_message("INVITE_FAILED_TITLE", style_string)
	end
end

function coop_pause_populate_friends(display_name)
	local num_items = Coop_pause_invite_player_menu.num_items
	--add item yay
	if Coop_pause_loading_friends_at_startup then
		Coop_pause_invite_player_menu[num_items] = {label = display_name, type = MENU_ITEM_TYPE_SELECTABLE, on_select = coop_pause_send_invite_and_wait }	
		Coop_pause_invite_player_menu.on_back = pause_menu_quit_game
	else
		Coop_pause_invite_player_menu[num_items] = {label = display_name, type = MENU_ITEM_TYPE_SELECTABLE, on_select = coop_pause_send_invite 	}
	end
	Coop_pause_invite_player_menu.num_items = num_items + 1

end

function coop_pause_build_invite_player_request()
	Coop_pause_invite_player_menu.num_items = 0
	vint_dataresponder_request("sr2_pause_menu_friends", "coop_pause_populate_friends", 0) 

	if Coop_pause_loading_friends_dialog_handle ~= 0 then
		dialog_box_force_close(Coop_pause_loading_friends_dialog_handle)
		Coop_pause_loading_friends_dialog_handle = 0
	end
	if Coop_pause_invite_player_menu.num_items == 0 then
		dialog_box_message("MENU_TITLE_NOTICE", "NO_FRIENDS_ONLINE")
		--change the current menu to not say loading
		if is_coop_start_screen() then
			Pause_menu_no_friends_menu.on_alt_select = nil
			Pause_menu_no_friends_menu.btn_tips = Pause_menu_quit_to_main_only_tips
		else
			Pause_menu_no_friends_menu.on_back = nil
			Pause_menu_no_friends_menu.btn_tips = Pause_menu_back_only
		end
		menu_show(Pause_menu_no_friends_menu, MENU_TRANSITION_SWAP)
	else
		if is_coop_start_screen() then
			if get_coop_join_type() == 2 then
				Coop_pause_invite_player_menu.on_alt_select = nil
				Coop_pause_invite_player_menu.btn_tips = Pause_menu_quit_to_main_only_tips
			else
				Coop_pause_invite_player_menu.on_alt_select = pause_menu_get_gamercard
				Coop_pause_invite_player_menu.btn_tips = Pause_menu_quit_to_main_tips
			end
			Pause_horz_menu[0].sub_menu = Coop_pause_invite_player_menu
		end
		menu_show(Coop_pause_invite_player_menu, MENU_TRANSITION_SWEEP_RIGHT)
	end

end

--load friends
function coop_pause_load_friends()
	--open a dialog box
	Coop_pause_loading_friends_at_startup = false
	Coop_pause_loading_friends_dialog_handle = dialog_box_message("GAME_LOADING", "MULTI_INVITE_FILTER_FRIENDS")
	--request the friends
	thread_new("coop_pause_build_invite_player_request")
end

--load friends for coop start, have invite sent, popup a waiting dialogue instead
function coop_pause_load_friends_coop_start()
	if is_coop_start_screen() then
		if get_coop_join_type() == 2 then
			Coop_invite_friends_menu.on_alt_select = nil
			Coop_invite_friends_menu.btn_tips = Pause_menu_quit_to_main_only_tips
		else
			Coop_invite_friends_menu.on_alt_select = pause_menu_get_gamercard
			Coop_invite_friends_menu.btn_tips = Pause_menu_quit_to_main_tips
		end
	end
	Coop_pause_loading_friends_at_startup = true
	Coop_pause_loading_friends_dialog_handle = dialog_box_message("GAME_LOADING", "MULTI_INVITE_FILTER_FRIENDS")
	--request the friends
	thread_new("coop_pause_build_invite_player_request")
end

function coop_pause_change_privacy()
	if get_is_host() then
		local type = coop_privacy_slider_values_pc.cur_value
		set_coop_join_type(type)
	end
end

function coop_pause_change_friendly_fire()
	if get_is_host() then
		local type = coop_friendly_fire_slider_values.cur_value
		set_coop_friendly_fire(type)
	end
end

function coop_pause_kick_player_confirm(result, action)

	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 and get_is_host() then
		kick_coop_player()
	end
	
end

function coop_pause_maybe_kick_player()
	--set this up in code so we can get players name
	coop_kick_player()
end

function coop_update_friendly_fire(data_item_handle, event_name)
	local option = vint_dataitem_get(data_item_handle)
	if get_is_host() then
		return
	end
	
	local ff_option = get_coop_friendly_fire()
	if coop_is_active() then
		if ff_option == 0 then
			Pause_coop_menu[3].info_text_str = "MULTI_LOBBY_ON"
		elseif ff_option == 1 then
			Pause_coop_menu[3].info_text_str = "GENERAL_LIGHT"
		else
			Pause_coop_menu[3].info_text_str = "MULTI_LOBBY_OFF"
		end
	else
		if ff_option == 0 then
			Pause_coop_menu[2].info_text_str = "MULTI_LOBBY_ON"
		elseif ff_option == 1 then
			Pause_coop_menu[2].info_text_str = "GENERAL_LIGHT"
		else
			Pause_coop_menu[2].info_text_str = "MULTI_LOBBY_OFF"
		end
	end
	
	if Menu_active == Pause_coop_menu then
		menu_info_box_show(Menu_option_labels[pos-top], Menu_active[pos])
	end
end

function pause_menu_display_coop_tab()
	menu_show(Pause_coop_menu, MENU_TRANSITION_SWAP)
end

function on_multi_login_enter_sp_session_name(menu_label, menu_data)
	menu_open_game_name_window()
	vint_dataresponder_request( "enter_login_PC_data_responder", "dummy_login_pc_func", 0 )
	if menu_open_enter_name_result() == 1 then
		local entered_text = menu_open_enter_name_result_string(5)
		if entered_text == nil then
			entered_text = ""
		end
		vint_set_property(vint_object_find("value_text", menu_label.control.grp_h), "text_tag", entered_text )
	end
	menu_resize()
end

function pause_menu_coop_show(menu_label, menu_data)
	Pause_coop_menu.num_items = 0
	-- see if we already have a second player
	if get_is_host() then
		if coop_is_active() then
			--show kick player 
			Pause_coop_menu[0] = { label = "CONTROL_KICK_PLAYER",		type = MENU_ITEM_TYPE_SELECTABLE, on_select = coop_pause_maybe_kick_player }
			Pause_coop_menu.num_items = 1
		elseif is_signed_in() and is_connected_to_service() and user_has_online_privlage() and get_is_syslink() == false then
			--show invite players
			if get_platform() ~= "PC" then
				Pause_coop_menu[0] = { label = "MULTI_LOBBY_INVITE_FRIENDS",		type = MENU_ITEM_TYPE_SELECTABLE, on_select = coop_pause_load_friends }
				Pause_coop_menu.num_items = 1
			end
		end
		
		if get_platform() == "PC" then
			Pause_coop_menu[Pause_coop_menu.num_items] = 	{ label = "MULTI_SESSION_NAME",			type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "",   on_select = on_multi_login_enter_sp_session_name } --{ label = "MULTI_SESSION_PASS",			type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "", on_select = on_multi_login_enter_session_pass }
			
			local entered_text = menu_open_enter_name_result_string(5)
			if entered_text == nil then
				entered_text = ""
			end
			Pause_coop_menu[Pause_coop_menu.num_items].info_text_str = entered_text
			
			Pause_coop_menu.num_items = Pause_coop_menu.num_items + 1
		end
		
		if get_platform() == "PC" then
			Pause_coop_menu[Pause_coop_menu.num_items] = 	{ label = "MULTI_LOBBY_PRIVACY",		type = MENU_ITEM_TYPE_TEXT_SLIDER,  text_slider_values = coop_privacy_slider_values_pc, on_value_update = coop_pause_change_privacy }
			Pause_coop_menu.num_items = Pause_coop_menu.num_items + 1
			coop_privacy_slider_values_pc.cur_value = get_coop_join_type()
		else
			Pause_coop_menu[Pause_coop_menu.num_items] = 	{ label = "MULTI_LOBBY_PRIVACY",		type = MENU_ITEM_TYPE_TEXT_SLIDER,  text_slider_values = coop_privacy_slider_values, on_value_update = coop_pause_change_privacy }
			Pause_coop_menu.num_items = Pause_coop_menu.num_items + 1
			coop_privacy_slider_values.cur_value = get_coop_join_type()
		end		
		
		Pause_coop_menu[Pause_coop_menu.num_items] = 	{ label = "MULTI_LOBBY_FRIENDLY_FIRE",		type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values = coop_friendly_fire_slider_values, on_value_update = coop_pause_change_friendly_fire }
		Pause_coop_menu.num_items = Pause_coop_menu.num_items + 1
		coop_friendly_fire_slider_values.cur_value = get_coop_friendly_fire()
	else
		Pause_coop_menu[Pause_coop_menu.num_items] = 	 {label = "MULTI_LOBBY_FRIENDLY_FIRE",	type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "CONTROL_NO"}
		local option =  get_coop_friendly_fire()
		if option == 0 then
			Pause_coop_menu[Pause_coop_menu.num_items].info_text_str = "MULTI_LOBBY_ON"
		elseif option == 1 then
			Pause_coop_menu[Pause_coop_menu.num_items].info_text_str = "GENERAL_LIGHT"
		else
			Pause_coop_menu[Pause_coop_menu.num_items].info_text_str = "MULTI_LOBBY_OFF"
		end
		Pause_coop_menu.num_items = Pause_coop_menu.num_items + 1

		vint_dataitem_add_subscription("sr2_pause_menu_friendly_fire", "update", "coop_update_friendly_fire")
	end
	
	
end


-------------------------
--------[ MENUS ]--------
-------------------------

--[ Menu populate information ]--
Pause_info_menu_population_data = {
	--	Objectives menu
	[0] = { header = "INFO_OBJECTIVES_TITLE", callback = "pause_menu_populate_objectives", prep_function = nil},
	
	--	Stats menu
	[1] = { header = "PAUSE_STATS_TITLE", 		callback = "pause_menu_populate_stats", 		prep_function = pause_menu_prep_stats},

	--	Hitman menus
	[2] = { header = "PAUSE_ACT_HITMAN_TITLE", callback = "pause_menu_populate_hitman_list", prep_function = nil, empty = "PAUSE_ACT_HITMAN_EMPTY" },
	[3] = { header = nil, callback = "pause_menu_populate_hitman_target", prep_function = pause_menu_prep_hitman_targets },
	
	-- Chopshop Menus
	[4] = { header = "PAUSE_ACT_CHOP_TITLE", callback = "pause_menu_populate_chop_shop_list", prep_function = nil, empty = "PAUSE_ACT_CHOPSHOP_EMPTY" },
	[5] = { header = nil, callback = "pause_menu_populate_chop_shop_vehicle", prep_function = pause_menu_prep_chop_shop_vehicle },
	
	--	Diversions Menus
	[6] = { header = nil, callback = "pause_menu_populate_diversions_menu", prep_function = pause_menu_prep_diversions },
	[7] = { header = nil, callback = "pause_menu_populate_diversions_stat", prep_function = pause_menu_prep_diversions_stats },
	[8] = { header = nil, callback = "pause_menu_populate_diversions_stat_sub", prep_function = pause_menu_prep_diversions_stats_sub },
	
	-- Collections
	[9] = { header = nil, callback = "pause_menu_populate_collection", prep_function = nil },
	
	--	Unlockables
	[10] = { header = nil, callback = "pause_menu_populate_player_unlockables", prep_function = pause_menu_prep_stats, empty = "PAUSE_INFO_UNLOCKABLE_EMPTY" },
	
	-- Help Menu
	[11] = { header = nil, callback = "pause_menu_populate_help_categories", prep_function = nil },
	[12] = { header = nil, callback = "pause_menu_populate_help_topics", prep_function = pause_menu_prep_help_topics },
	[13] = { header = nil, callback = "pause_menu_populate_help", prep_function = pause_menu_prep_help_menu },
	
	--14 Options
	--15 Control Scheme
	
	--16 Cellphone
	
	--17 Play list Editor
	--18 Play list editor
}

----[ Sliders for the Menus ]----

adv_ambient_slider_values 			= { [0] = { label = "SHADOW_NONE" },[1] = { label = "SHADOW_STENCIL" }, [2] = { label = "SHADOW_HYBRID" },														num_values = 3, cur_value = 0 }
adv_motion_blur_slider_values		= { [0] = { label = "CONTROL_NO" }, [1] = { label = "CONTROL_YES" },																							num_values = 2, cur_value = 0 }
adv_antiali_slider_values 			= { [0] = { label = "CONTROL_NO" }, [1] = { label = "2x" },				[2] = { label = "4x" },																	num_values = 3, cur_value = 0 }
adv_anisotropy_slider_values 		= { [0] = { label = "CONTROL_NO" }, [1] = { label = "2x" }, 			[2] = { label = "4x" },				[3] = { label = "8x" },	[4] = { label = "16x" },	num_values = 5,	cur_value = 0 }
adv_hdr_slider_values 				= { [0] = { label = "CONTROL_NO" },	[1] = { label = "CONTROL_YES" },																							num_values = 2, cur_value = 0 }
adv_shadow_slider_values 			= { [0] = { label = "SHADOW_NONE" },[1] = { label = "SHADOW_STENCIL" }, [2] = { label = "SHADOW_HYBRID" },														num_values = 3, cur_value = 0 }
adv_distance_slider_values 			= { [0] = { label = "VIEW_NEAR" },	[1] = { label = "VIEW_MEDIUM" 	},	[2] = { label = "VIEW_FAR" },															num_values = 3, cur_value = 0 }
adv_dynamic_lights_slider_values	= { [0] = { label = "SHADOW_NONE" },[1] = { label = "SHADOW_STENCIL" }, [2] = { label = "SHADOW_HYBRID" },														num_values = 3, cur_value = 0 }
adv_blur_slider_values				= { [0] = { label = "CONTROL_NO" }, [1] = { label = "CONTROL_YES" },																							num_values = 2, cur_value = 0 }
adv_depthoffield_slider_values		= { [0] = { label = "CONTROL_NO" }, [1] = { label = "CONTROL_YES" },																							num_values = 2, cur_value = 0 }

invert_y_slider_values 			= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
invert_rot_slider_values	 	= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
left_stick_slider_values	 	= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
vibration_slider_values 		= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
crouch_slider_values 			= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
subtitles_slider_values 		= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
vsync_gameplay_slider_values	= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
vsync_cutscene_slider_values	= { [1] = { label = "CONTROL_YES" }, [0] = { label = "CONTROL_NO" }, num_values = 2, cur_value = 0 }
minimap_slider_values 			= { [0] = { label = "MINIMAP_ROTATIONAL" 	}, [1] = { label = "MINIMAP_STATIC" 	}, num_values = 2, cur_value = 0 }
vehicle_radio_slider_values 	= { [2] = { label = "RADIO_LIFE_LIKE" 		}, [0] = { label = "RADIO_ALWAYS_ON" 	}, [1] = { label = "RADIO_HIJACK_ON" }, num_values = 3, cur_value = 0 }
coop_privacy_slider_values		= { [0] = { label = "MULTI_LOBBY_OPEN" }, [1] = { label = "MULTI_LOBBY_FRIENDS_ONLY" }, [2] = { label = "MULTI_LOBBY_INVITE_ONLY" }, num_values = 3, cur_value = 0 }
coop_friendly_fire_slider_values = { [0] = { label = "MULTI_LOBBY_ON" }, [1] = { label = "GENERAL_LIGHT"}, [2] = { label = "MULTI_LOBBY_OFF" }, num_values = 3, cur_value = 0 }
coop_privacy_slider_values_pc	= { [0] = { label = "MULTI_LOBBY_OPEN" }, [1] = { label = "MULTI_LOBBY_CLOSED" }, num_values = 2, cur_value = 1 }


pad_axis_lx_slider_values 		= { [0] = { label = "AXIS_1" }, [1] = { label = "AXIS_2" }, [2] = { label = "AXIS_3" }, [3] = { label = "AXIS_4" }, num_values = 4, cur_value = 0 }
pad_axis_ly_slider_values 		= { [0] = { label = "AXIS_1" }, [1] = { label = "AXIS_2" }, [2] = { label = "AXIS_3" }, [3] = { label = "AXIS_4" }, num_values = 4, cur_value = 1 }
pad_axis_rx_slider_values 		= { [0] = { label = "AXIS_1" }, [1] = { label = "AXIS_2" }, [2] = { label = "AXIS_3" }, [3] = { label = "AXIS_4" }, num_values = 4, cur_value = 2 }
pad_axis_ry_slider_values 		= { [0] = { label = "AXIS_1" }, [1] = { label = "AXIS_2" }, [2] = { label = "AXIS_3" }, [3] = { label = "AXIS_4" }, num_values = 4, cur_value = 3 }

----[ Button Tips for the Menus ]----
Pause_options_btn_tips = {
	a_button 	= 	{ label = "PAUSE_MENU_ACCEPT", 	enabled = btn_tips_default_a, },
	x_button 	= 	{ label = "CONTROLS_DEFAULTS", 	enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "MENU_BACK", 			enabled = btn_tips_default_a, },
}

Multi_scoreboard_tips_syslink = {
	b_button 	= 	{ label = "MENU_RESUME", 		enabled = btn_tips_default_a, },
}
	
Multi_scoreboard_tips = {
	a_button 	= 	{ label = "CONTROL_SELECT", 	enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "MENU_RESUME", 		enabled = btn_tips_default_a, },
}

Pause_save_load_btn_tips = {
	a_button 	= 	{ label = "CONTROL_SELECT", 					enabled = btn_tips_default_a, },
	x_button 	= 	{ label = "MENU_OPTIONS_SELECT_STORAGE", 		enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "CONTROL_RESUME",						enabled = btn_tips_default_a, },
}

Pause_save_load_btn_tips_PC = {
	a_button 	= 	{ label = "CONTROL_SELECT", 					enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "CONTROL_RESUME",						enabled = btn_tips_default_a, },
}

Pause_menu_accept_back_btn_tips = {
	a_button 	= 	{ label = "CONTROL_SELECT", 	enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "CONTROL_BACK", 		enabled = btn_tips_default_a, },
}

Pause_menu_playlist_left_tips = {
	a_button 	=	{ label = "MP3_CTRL_ADD_TRK", 					enabled = btn_tips_default_a,		}, 	 
	x_button 	=	{ label = "MP3_CTRL_PREVIEW",					enabled = pause_menu_playlist_in_genre,		},
	b_button 	=	{ label = "MENU_BACK", 							enabled = btn_tips_default_a,		},
	right_stick =  	{ label = "{MENU_UP}{0}", label_text="MP3_PLAYLIST_OPTIONS_SORT_ARTIST", enabled = pause_menu_playlist_in_genre, in_playlist = true},--btn_tip_always_hidden,	use_dpad = true, independent = false},
}

Pause_menu_playlist_right_tips = {
	a_button		= 	{ label = "MP3_CTRL_REMOVE_TRK", 			enabled = btn_tips_default_a,	}, 	 
	x_button		=  	{ label = "MP3_PLAY_STATE_PLAY", 			enabled = btn_tips_default_a,	},
	b_button		=	{ label = "MENU_BACK", 					enabled = btn_tips_default_a,	},
	right_stick		= 	{ label = "{MENU_UP}{MENU_DOWN}{0}", label_text="MP3_FOOTER_MOVE_TRACK", enabled = btn_tips_default_a, in_playlist = true},
}

Pause_control_schemes_btn_tips = {
	a_button 	= 	{ label = "CONTROL_SELECT", 	enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "MENU_BACK", 			enabled = btn_tips_default_a, },
}

Pause_menu_back_only = { 
	b_button	=	{ label = "MENU_BACK",			enabled = btn_tips_default_a, },
}

Pause_menu_quit_to_main_tips = {
	a_button 	= 	{ label = "CONTROL_SELECT", 	enabled = btn_tips_default_a, },
	x_button 	= 	{ label = "COOP_WAIT_FOR_ANYONE", 	enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "QUIT_TO_MAIN_MENU", 	enabled = btn_tips_default_a, },
}

Pause_menu_quit_to_main_tips_ps3 = {
	a_button 	= 	{ label = "CONTROL_SELECT", 	enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "QUIT_TO_MAIN_MENU", 	enabled = btn_tips_default_a, },
}

Pause_menu_quit_to_main_only_tips = {
	b_button 	= 	{ label = "QUIT_TO_MAIN_MENU", 	enabled = btn_tips_default_a, },
}

Pause_menu_friends_tips = {
	a_button 	= 	{ label = "CONTROL_SELECT", 					enabled = btn_tips_default_a, },
	x_button 	= 	{ label = "MULTI_MENU_SHOW_GAMERCARD", 			enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "MENU_BACK", 						enabled = btn_tips_default_a, },
}

Pause_menu_friends_tips_ps3 = {
	a_button 	= 	{ label = "CONTROL_SELECT", 					enabled = btn_tips_default_a, },
	b_button 	= 	{ label = "MENU_BACK", 						enabled = btn_tips_default_a, },
}


--Button tips for cellphone page
Pause_cellphone_btn_tips = { 
	a_button 	=	{ label = "CONTROL_SELECT",		enabled = btn_tips_default_a, },
	b_button 	=	{ label = "CONTROL_RESUME",		enabled = btn_tips_default_a, },
}

---[ TEMP MENU while implementing shings ]---
Pause_menu_temp = {
	header_label_str = "NOT IMPLEMENTED",
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	num_items = 1,
	
	[0] = { label = "Not implemented yet", type = MENU_ITEM_TYPE_SELECTABLE, },
}

--[ Actual menus ]--

Pause_info_collection_sub_menu = {
	on_show  = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map 	 = pause_menu_swap,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

	
Pause_info_activities_menu = {
	num_items = 2,
	header_label_str = "INFO_ACTIVITIES",
	on_pause	= pause_menu_exit,
	on_map 		= pause_menu_swap,

	[0] = { label = "INFO_COLLECTIONS_HITMAN", 			type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_collection_sub_menu, id = 2 },
	[1] = { label = "INFO_COLLECTIONS_CHOPSHOP", 		type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_collection_sub_menu, id = 4 },
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_collection_menu = {
	num_items = 6,
	header_label_str = "INFO_COLLECTION",
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	on_show = pause_menu_build_collection_menu,
	get_width = pause_menu_diversions_get_width,
	on_post_show = pause_menu_diversions_post_show,

	[0] = { label = "INFO_COLLECTIONS_BARNSTORMING", 	type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, data_type = DIV_DATA_X_OF_Y, show_value = true}, 
	[1] = { label = "INFO_COLLECTIONS_CD_COLLECTION",	type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, data_type = DIV_DATA_X_OF_Y, show_value = true}, 
	[2] = { label = "INFO_COLLECTIONS_SECRET_AREAS",	type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, data_type = DIV_DATA_X_OF_Y, show_value = true}, 
	[3] = { label = "INFO_COLLECTIONS_STUNT_JUMPS",		type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, data_type = DIV_DATA_X_OF_Y, show_value = true}, 
	[4] = { label = "INFO_COLLECTIONS_TAGGING",			type = PAUSE_MENU_CONTROL_STAT_TEXT_LINE, data_type = DIV_DATA_X_OF_Y, show_value = true}, 
	
	btn_tips = Pause_menu_back_only,
}

Pause_info_diversions_stat_sub_menu = {
	on_show = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap, 
	get_width = pause_menu_diversions_get_width,
	
	btn_tips = Pause_menu_back_only,
}

Pause_info_diversions_stat_menu = {
	on_show = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	get_width = pause_menu_diversions_get_width,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_diversions_sub_menu = {
	on_show = pause_menu_build_info_menu,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	get_width = pause_menu_diversions_get_width,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_diversions_menu = {
	num_items = 4,
	header_label_str = "INFO_DIVERSIONS",
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	
	[0] = { label = "INFO_DIVERSIONS_COLLECTION", 	type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_collection_menu, },
	[1] = { label = "INFO_DIVERSIONS_JOBS", 		type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_diversions_sub_menu, id = 6	},
	[2] = { label = "INFO_DIVERSIONS_STUNTS", 		type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_diversions_sub_menu, id = 6	},
	[3] = { label = "INFO_DIVERSIONS_GAMES", 		type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_diversions_sub_menu, id = 6	},
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_help_sub_menu = {
	num_items = 0,
	on_show = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_help_topics_menu = {
	num_items = 0,
	on_show = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_help_menu = {
	num_items = 0,
	on_show = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_unlockables_sub_menu = {
	num_items = 0,
	on_show = pause_menu_build_info_menu,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	on_post_show = pause_menu_finalize_stats,
	
	btn_tips = Pause_menu_back_only
}

Pause_info_unlockables_menu = {
	header_label_str = "INFO_UNLOCKABLES",
	num_items = 6,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	
	[0] = { label = "INFO_UNLOCKABLES_PLAYER_ABILITIES", 	type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_unlockables_sub_menu, id = 10 },
	[1] = { label = "INFO_UNLOCKABLES_WEAPONS", 				type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_unlockables_sub_menu, id = 10 },
	[2] = { label = "INFO_UNLOCKABLES_VEHICLES", 			type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_unlockables_sub_menu, id = 10 },
	[3] = { label = "INFO_UNLOCKABLES_DISCOUNTS", 			type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_unlockables_sub_menu, id = 10 },
	[4] = { label = "INFO_UNLOCKABLES_HOMIES", 				type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_unlockables_sub_menu, id = 10 },
	[5] = { label = "INFO_UNLOCKABLES_CUSTOMIZATION", 		type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_unlockables_sub_menu, id = 10 },
	
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_sub_menu_template = {
	num_items = 0,
	on_show = pause_menu_build_info_menu,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	multi_menu = true,
	
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_info_sub_menu = {
	num_items = 0,
	on_show = pause_menu_build_info_menu,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	multi_menu = true,
	
	btn_tips = Pause_menu_accept_back_btn_tips
}

Pause_info_objective_lines = {
-- start at 0
	num_lines = 0,
	current_line = 0,
	current_y = 0,
	total_y = 0,
	more_lines = false,
}

Pause_menu_objective_menu = {
--	header_label_str = "PAUSE_MENU_CAT_RADIO", 
	on_show			= pause_menu_objective_menu_show,
--	on_back			= pause_menu_playlist_on_back,
--	on_exit			= pause_menu_playlist_on_exit,
--	on_post_show	= pause_menu_playlist_post_show,
	on_map = pause_menu_swap,
	on_pause 		= pause_menu_exit,
	on_release		= pause_menu_objective_menu_release,
--	get_width 		= pause_menu_playlist_get_width,
--	get_height 		= pause_menu_playlist_get_height,
	
	num_items 		= 1,
	header_height = 65,
	
	[0] = { label = "", type = PAUSE_MENU_CONTROL_OBJECTIVE_WRAP_LINE, on_select = pause_menu_playlist_on_select },
	
	btn_tips = Pause_menu_back_only
}

Pause_info_menu = {
	num_items = 7,
	header_label_str = "PAUSEMENU_CAT_INFO",
	on_show = pause_menu_info_on_show,
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	
	[0] = { label = "INFO_OBJECTIVES",  on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SUB_MENU,	sub_menu = Pause_menu_objective_menu		},
	[1] = { label = "INFO_ACTIVITIES",	on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_info_activities_menu		},
	[2] = { label = "INFO_DIVERSIONS",	on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SUB_MENU,	sub_menu = Pause_info_diversions_menu		},
	[3] = { label = "INFO_STATS",		on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SUB_MENU,	sub_menu = Pause_info_sub_menu, id = 1		},
	[4] = { label = "INFO_UNLOCKABLES",	on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SUB_MENU,	sub_menu = Pause_info_unlockables_menu, 	}, 
	[5] = { label = "INFO_ACHIEVE",		on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SELECTABLE, on_select = pause_menu_do_achievements },
	[6] = { label = "INFO_HELP",		on_select = pause_menu_info_select, type = MENU_ITEM_TYPE_SUB_MENU,	sub_menu = Pause_info_help_menu, id = 11	},
}

Pause_save_menu = {
	on_show = pause_save_show,
	on_release = pause_save_release,
	on_post_show = pause_save_post_show,
	num_items = 0,
	on_back = pause_menu_save_load_exit,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	header_height = 150,
	header_width = 525,
	
	is_save_menu = true,
	
	btn_tips = Pause_save_load_btn_tips_PC,
}

Pause_load_menu = {
	on_show = pause_load_show,
	on_release = pause_load_release,
	on_post_show = pause_load_post_show,
	on_nav = pause_load_nav,
	on_back = pause_menu_save_load_exit,
	on_map = pause_menu_swap,
	num_items = 0,
	header_height = 198,
	header_width = 525,
	
	is_load_menu = true,
	
	btn_tips = Pause_save_load_btn_tips_PC,
}

Pause_save_load_menu = {
	num_items = 2,
	header_label_str = "PAUSEMENU_CAT_SAVELOAD",
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	
	[0] = { label = "SAVELOAD_SAVE_GAME", type = MENU_ITEM_TYPE_SELECTABLE, on_select = pause_save_menu_select }, 
	[1] = { label = "SAVELOAD_LOAD_GAME", type = MENU_ITEM_TYPE_SELECTABLE, on_select = pause_load_menu_select }, 
}

Pause_menu_control_sub_menu = {
	on_show 	= pause_menu_build_control_scheme_menu,
	on_pause	= pause_menu_options_exit_confirm,
	on_map 	 	= pause_menu_options_swap_confirm,
	on_back 	= pause_menu_control_scheme_on_back,
	on_release 	= pause_menu_exit_control_scheme,
	num_items 	= 1,
	
	[0] = { label = "CONTROL_SETUP_CHANGE_SCHEME", 		type = MENU_ITEM_TYPE_TEXT_SLIDER, on_select = pause_menu_control_update_scheme, text_slider_values = control_scheme_values, on_value_update = pause_menu_rebuild_control_scheme },

	btn_tips = Pause_control_schemes_btn_tips,
}

Pause_menu_pad_control_sub_menu = {
	on_show 	= pause_menu_build_control_scheme_menu,
	on_pause	= pause_menu_options_exit_confirm,
	on_map 	 	= pause_menu_options_swap_confirm,
	on_back 	= pause_menu_control_scheme_on_back,
	on_release 	= pause_menu_exit_control_scheme,
	num_items 	= 1,
	
	[0] = { label = "CONTROL_SETUP_CHANGE_SCHEME", 		type = MENU_ITEM_TYPE_TEXT_SLIDER, on_select = pause_menu_control_update_scheme, text_slider_values = control_scheme_values, on_value_update = pause_menu_rebuild_control_scheme },

	btn_tips = Pause_control_schemes_btn_tips,
}

function dummy_pc_func()

end

function pause_menu_build_control_scheme_menu_PC( menu_data )
	for i = 0, Pause_menu_control_sub_menu_PC.num_items - 1 do
		if Pause_menu_control_sub_menu_PC[i].actid ~= nil then
			local action_key_text = pc_get_action_key_pure_text( Pause_menu_control_sub_menu_PC[i].actid )
			Pause_menu_control_sub_menu_PC[i].info_text_str = action_key_text
		end
	end
end

function pause_menu_populate_pad_axes(axis_lx, axis_ly, axis_rx, axis_ry)
	pad_axis_lx_slider_values.cur_value = axis_lx;
	pad_axis_ly_slider_values.cur_value = axis_ly;
	pad_axis_rx_slider_values.cur_value = axis_rx;
	pad_axis_ry_slider_values.cur_value = axis_ry;
end

function pause_menu_build_pad_control_scheme_menu_PC( menu_data )
	for i = 0, Pause_menu_pad_control_sub_menu_PC.num_items - 1 do
		if Pause_menu_pad_control_sub_menu_PC[i].actid ~= nil then
			local action_key_text = pc_get_action_pad_pure_text( Pause_menu_pad_control_sub_menu_PC[i].actid )
			Pause_menu_pad_control_sub_menu_PC[i].info_text_str = action_key_text
		end
	end
	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_pad_axes", 0, PAUSE_MENU_PAD_AXES_POPULATE_ID)
end

function pause_menu_controls_restore_defaults_PC(menu_data)
	local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "CONTROL_CANCEL" }
	dialog_box_open("OPTIONS_MENU_DEFAULTS_TITLE", "OPTIONS_MENU_DEFAULTS_DESC", options, "pm_option_controls_defaults_PC", 0, DIALOG_PRIORITY_ACTION)
end

function pause_menu_pad_controls_restore_defaults_PC(menu_data)
	local options = { [0] = "PAUSE_MENU_ACCEPT", [1] = "CONTROL_CANCEL" }
	dialog_box_open("OPTIONS_MENU_DEFAULTS_TITLE", "OPTIONS_MENU_DEFAULTS_DESC", options, "pm_option_pad_controls_defaults_PC", 0, DIALOG_PRIORITY_ACTION)
end

function pm_option_controls_defaults_PC(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		input_controls_restore_defaults_PC()
		for i = 0, Pause_menu_control_sub_menu_PC.num_items - 1 do
			local action_key_text = pc_get_action_key_pure_text( Pause_menu_control_sub_menu_PC[i].actid )
			Pause_menu_control_sub_menu_PC[i].info_text_str = action_key_text
		end
		menu_update_labels()
		menu_update_nav_bar(Menu_active.highlighted_item)
	end	
end

function pm_option_pad_controls_defaults_PC(result, action)
	if action ~= DIALOG_ACTION_CLOSE then
		return
	end
	
	if result == 0 then
		input_pad_controls_restore_defaults_PC()
		for i = 0, Pause_menu_pad_control_sub_menu_PC.num_items - 1 do
			local action_key_text = pc_get_action_pad_pure_text( Pause_menu_pad_control_sub_menu_PC[i].actid )
			Pause_menu_pad_control_sub_menu_PC[i].info_text_str = action_key_text
		end
		vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_pad_axes", 0, PAUSE_MENU_PAD_AXES_POPULATE_ID)
		menu_update_labels()
		menu_update_nav_bar(Menu_active.highlighted_item)
	end	
end

function pause_menu_pad_axis_update_value(menu_label, menu_data)
	local idx = menu_data.id
	pause_menu_update_option( PAUSE_MENU_PAD_CONTROL_ID, idx, false, menu_data.text_slider_values.cur_value )
end

function pause_menu_exit_control_scheme_PC(menu_data)

end

function pause_menu_exit_pad_control_scheme_PC(menu_data)

end

pause_control_key_refresh_item_PC = {}

function pause_control_key_change_PC(menu_label, menu_data)
	pc_capture_input_key( menu_data.actid )
	vint_dataresponder_request( "pause_control_key_change_PC_data_responder", "dummy_pc_func", 0, "save_files")
	local action_changed = pc_capture_input_key_get_result()
	if action_changed >= 0 then
		-- have to refresh all items
		for i = 0, Pause_menu_control_sub_menu_PC.num_items - 1 do
			local action_key_text = pc_get_action_key_pure_text( Pause_menu_control_sub_menu_PC[i].actid )
			Pause_menu_control_sub_menu_PC[i].info_text_str = action_key_text
		end
		menu_update_labels()
		menu_update_nav_bar(Menu_active.highlighted_item)
	end
end

function pause_control_pad_button_change_PC(menu_label, menu_data)
	pc_capture_input_pad( menu_data.actid )
	vint_dataresponder_request( "pause_control_pad_button_change_PC_data_responder", "dummy_pc_func", 0, "save_files")
	local action_changed = pc_capture_input_pad_get_result()
	if action_changed >= 0 then
		-- have to refresh all items
		for i = 0, Pause_menu_pad_control_sub_menu_PC.num_items - 1 do
			local action_key_text = pc_get_action_pad_pure_text( Pause_menu_pad_control_sub_menu_PC[i].actid )
			Pause_menu_pad_control_sub_menu_PC[i].info_text_str = action_key_text
		end
		menu_update_labels()
		menu_update_nav_bar(Menu_active.highlighted_item)
	end
end

function pause_control_key_refresh_item_PC()
--	pc_capture_input_key( 101 )
end

PC_BTN_MOVE_UP = 0
PC_BTN_MOVE_DOWN = 1
PC_BTN_MOVE_LEFT = 2
PC_BTN_MOVE_RIGHT = 3
PC_BTN_ACTION = 4
PC_BTN_JUMP = 5
PC_BTN_RADIAL = 6
PC_BTN_BREAK = 7
PC_DPAD_RIGHT = 8
PC_DPAD_UP = 9
PC_DPAD_LEFT = 10
PC_DPAD_DOWN = 11
PC_BTN_START = 12
PC_BTN_BACK = 13
PC_BTN_RELOAD = 14
PC_BTN_CROUCH = 15
PC_BTN_FINE_AIM = 16
PC_BTN_GRAB_HUMAN = 17
PC_BTN_SPRINT = 18
PC_BTN_BLOCK = 19
PC_BTN_MAP = 20
PC_BTN_PAUSE = 21
PC_BTN_HORN = 26
PC_BTN_CRUISE = 27
PC_BTN_RESET_CAMERA = 28
PC_BTN_RADIO_PREV = 29
PC_BTN_RADIO_NEXT = 30
PC_BTN_LOOK_RIGHT = 31
PC_BTN_LOOK_LEFT = 32
PC_WPN_SWITCH_UP = 33
PC_WPN_SWITCH_DOWN = 34
PC_BTN_ATTACK = 35
PC_BTN_ATTACK2 = 36
PC_BTN_ACCELERATE = 37
PC_BTN_REVERSE = 38
PC_BTN_SELECT_WEAPON_1 = 39
PC_BTN_SELECT_WEAPON_2 = 40
PC_BTN_SELECT_WEAPON_3 = 41
PC_BTN_SELECT_WEAPON_4 = 42
PC_BTN_SELECT_WEAPON_5 = 43
PC_BTN_SELECT_WEAPON_6 = 44
PC_BTN_SELECT_WEAPON_7 = 45
PC_BTN_SELECT_WEAPON_8 = 46
PC_BTN_HELI_TURN_LEFT = 47
PC_BTN_HELI_TURN_RIGHT = 48
PC_BTN_VEHICLE_LOOK_BEHIND = 49
PC_BTN_AIR_ACCELERATE = 50
PC_BTN_AIR_DECELERATE = 51
PC_BTN_RECRUIT = 52
PC_BTN_CANCEL = 53
PC_BTN_TAUNT = 54
PC_BTN_COMPLIMENT = 55
PC_BTN_HYDRAULICS = 56
PC_BTN_NITRO = 57
PC_BTN_FIGHT_CLUB_MASH_1 = 58
PC_BTN_FIGHT_CLUB_MASH_2 = 59
PC_BTN_FIGHT_CLUB_MASH_3 = 60
PC_BTN_FIGHT_CLUB_MASH_4 = 61
PC_BTN_PAD_MENU_SELECT = 62
PC_BTN_WALK = 63
PC_BTN_MOTO_PITCH_UP = 64
PC_BTN_MOTO_PITCH_DOWN = 65
PC_BTN_ZOOM_IN = 66
PC_BTN_ZOOM_OUT = 67
PC_BTN_MENU_SCROLL_LEFT = 68
PC_BTN_MENU_SCROLL_RIGHT = 69
PC_BTN_MENU_DPAD_UP = 70
PC_BTN_MENU_DPAD_DOWN = 71
PC_BTN_MENU_DPAD_LEFT = 72
PC_BTN_MENU_DPAD_RIGHT = 73
PC_BTN_MENU_ALT_SELECT = 74
PC_BTN_X = 75
PC_BTN_PAD_BACK = 76
PC_PAD_DPAD_RIGHT = 77
PC_PAD_DPAD_UP = 78
PC_PAD_DPAD_LEFT = 79
PC_PAD_DPAD_DOWN = 80
PC_BTN_PAD_START = 81
PC_BTN_PAD_LS_PRESS = 82
PC_BTN_PAD_RS_PRESS = 83
PC_BTN_CHAT_ALL = 84
PC_BTN_CHAT_TEAM = 85
	
Pause_menu_control_sub_menu_PC = {
	header_label_str = "CONTROLS_SETUP",
	on_show = pause_menu_build_control_scheme_menu_PC,
	on_alt_select = pause_menu_controls_restore_defaults_PC,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	on_exit = pause_menu_exit_control_scheme_PC,
	num_items = 54,
	btn_tips = Pause_options_btn_tips,	

	[0] = { label = "GENERAL_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[1] = { label = "PCACTION_ACTION", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "E", actid = PC_BTN_ACTION, on_select = pause_control_key_change_PC },
	[2] = { label = "PCACTION_ATTACK_PRIMARY", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LMB", actid = PC_BTN_ATTACK, on_select = pause_control_key_change_PC },
	[3] = { label = "PCACTION_ATTACK_SECONDARY", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "RMB", actid = PC_BTN_ATTACK2, on_select = pause_control_key_change_PC },
	[4] = { label = "PCACTION_RECRUIT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_RECRUIT, on_select = pause_control_key_change_PC },
	[5] = { label = "PCACTION_DISMISS_CANCEL", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_CANCEL, on_select = pause_control_key_change_PC },
	[6] = { label = "PCACTION_RADIAL_MENU", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_RADIAL, on_select = pause_control_key_change_PC },
	[7] = { label = "PCACTION_WEAPON_1", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "1", actid = PC_BTN_SELECT_WEAPON_1, on_select = pause_control_key_change_PC },
	[8] = { label = "PCACTION_WEAPON_2", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "2", actid = PC_BTN_SELECT_WEAPON_2, on_select = pause_control_key_change_PC },
	[9] = { label = "PCACTION_WEAPON_3", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "3", actid = PC_BTN_SELECT_WEAPON_3, on_select = pause_control_key_change_PC },
	[10] = { label = "PCACTION_WEAPON_4", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "4", actid = PC_BTN_SELECT_WEAPON_4, on_select = pause_control_key_change_PC },
	[11] = { label = "PCACTION_WEAPON_5", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "5", actid = PC_BTN_SELECT_WEAPON_5, on_select = pause_control_key_change_PC },
	[12] = { label = "PCACTION_WEAPON_6", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "6", actid = PC_BTN_SELECT_WEAPON_6, on_select = pause_control_key_change_PC },
	[13] = { label = "PCACTION_WEAPON_7", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "7", actid = PC_BTN_SELECT_WEAPON_7, on_select = pause_control_key_change_PC },
	[14] = { label = "PCACTION_WEAPON_8", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "8", actid = PC_BTN_SELECT_WEAPON_8, on_select = pause_control_key_change_PC },
	[15] = { label = "PCACTION_CHAT_ALL", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Y", actid = PC_BTN_CHAT_ALL, on_select = pause_control_key_change_PC },
	[16] = { label = "PCACTION_CHAT_TEAM", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "T", actid = PC_BTN_CHAT_TEAM, on_select = pause_control_key_change_PC },

	[17] = { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[18] = { label = "ON_FOOT_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },
	
	[19] = { label = "PCACTION_FORWARD", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "W", actid = PC_BTN_MOVE_UP, on_select = pause_control_key_change_PC }, 
	[20] = { label = "PCACTION_BACKWARD", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "S", actid = PC_BTN_MOVE_DOWN, on_select = pause_control_key_change_PC},
	[21] = { label = "PCACTION_STRAFE_LEFT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "A", actid = PC_BTN_MOVE_LEFT, on_select = pause_control_key_change_PC},
	[22] = { label = "PCACTION_STRAFE_RIGHT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "D", actid = PC_BTN_MOVE_RIGHT, on_select = pause_control_key_change_PC},
	[23] = { label = "PCACTION_JUMP", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "SPACEBAR", actid = PC_BTN_JUMP, on_select = pause_control_key_change_PC },
	[24] = { label = "PCACTION_SPRINT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LSHIFT", actid = PC_BTN_SPRINT, on_select = pause_control_key_change_PC },
	[25] = { label = "PCACTION_WALK", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "CAPSLOCK", actid = PC_BTN_WALK, on_select = pause_control_key_change_PC },
	[26] = { label = "PCACTION_RELOAD", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "R", actid = PC_BTN_RELOAD, on_select = pause_control_key_change_PC },
	[27] = { label = "PCACTION_CROUCH", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "C", actid = PC_BTN_CROUCH, on_select = pause_control_key_change_PC },
	[28] = { label = "PCACTION_FINE_AIM", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "V", actid = PC_BTN_FINE_AIM, on_select = pause_control_key_change_PC },
	[29] = { label = "PCACTION_GRAB_HUMAN", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LCTRL", actid = PC_BTN_GRAB_HUMAN, on_select = pause_control_key_change_PC },
	[30] = { label = "PCACTION_TAUNT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_TAUNT, on_select = pause_control_key_change_PC },
	[31] = { label = "PCACTION_COMPLIMENT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_COMPLIMENT, on_select = pause_control_key_change_PC }, 
	[32] = { label = "PCACTION_ZOOM_IN", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "H", actid = PC_BTN_ZOOM_IN, on_select = pause_control_key_change_PC },
	[33] = { label = "PCACTION_ZOOM_OUT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "N", actid = PC_BTN_ZOOM_OUT, on_select = pause_control_key_change_PC },

	[34] =  { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[35] =  { label = "VEHICLE_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[36] = { label = "PCACTION_ACCELERATE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "W", actid = PC_BTN_ACCELERATE, on_select = pause_control_key_change_PC },
	[37] = { label = "PCACTION_REVERSE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "S", actid = PC_BTN_REVERSE, on_select = pause_control_key_change_PC },
	[38] = { label = "PCACTION_BREAK", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "SPACEBAR", actid = PC_BTN_BREAK, on_select = pause_control_key_change_PC },
	[39] = { label = "PCACTION_CRUISE_CONTROL", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "SPACEBAR", actid = PC_BTN_CRUISE, on_select = pause_control_key_change_PC },
	[40] = { label = "PCACTION_HORN", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "H", actid = PC_BTN_HORN, on_select = pause_control_key_change_PC },
	[41] = { label = "PCACTION_RADIO_NEXT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "RIGHT", actid = PC_BTN_RADIO_NEXT, on_select = pause_control_key_change_PC },
	[42] = { label = "PCACTION_RADIO_PREVIOUS", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LEFT", actid = PC_BTN_RADIO_PREV, on_select = pause_control_key_change_PC },
	[43] = { label = "PCACTION_LOOK_BEHIND", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "X", actid = PC_BTN_VEHICLE_LOOK_BEHIND, on_select = pause_control_key_change_PC },
	[44] = { label = "PCACTION_HYDRAULICS", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "P", actid = PC_BTN_HYDRAULICS, on_select = pause_control_key_change_PC },
	[45] = { label = "PCACTION_NITRO", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "X", actid = PC_BTN_NITRO, on_select = pause_control_key_change_PC },
	[46] = { label = "PCACTION_LEAN_FORWARD", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "R", actid = PC_BTN_MOTO_PITCH_DOWN, on_select = pause_control_key_change_PC },
	[47] = { label = "PCACTION_LEAN_BACK", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "F", actid = PC_BTN_MOTO_PITCH_UP, on_select = pause_control_key_change_PC },

	[48] =  { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[49] = { label = "AIRCRAFT_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[50] = { label = "PCACTION_AIR_ACCELERATE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "W", actid = PC_BTN_AIR_ACCELERATE, on_select = pause_control_key_change_PC },
	[51] = { label = "PCACTION_AIR_DECELERATE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "S", actid = PC_BTN_AIR_DECELERATE, on_select = pause_control_key_change_PC },
	[52] = { label = "PCACTION_RUDDER_LEFT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Z", actid = PC_BTN_HELI_TURN_LEFT, on_select = pause_control_key_change_PC },
	[53] = { label = "PCACTION_RUDDER_RIGHT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "C", actid = PC_BTN_HELI_TURN_RIGHT, on_select = pause_control_key_change_PC }
}

Pause_menu_pad_control_sub_menu_PC = {
	header_label_str = "PAD_CONTROLS_SETUP",
	on_show		= pause_menu_build_pad_control_scheme_menu_PC,
	on_alt_select 	= pause_menu_pad_controls_restore_defaults_PC,
	on_pause	= pause_menu_exit,
	on_map 		= pause_menu_swap,
	on_exit = pause_menu_exit_pad_control_scheme_PC,
	num_items = 55,
	btn_tips = Pause_options_btn_tips,

	[0] = { label = "PC_PAD_AXES", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[1] = { label = "PC_PAD_LEFT_AXIS_X", type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values = pad_axis_lx_slider_values, on_value_update = pause_menu_pad_axis_update_value, id = 0 },
	[2] = { label = "PC_PAD_LEFT_AXIS_Y", type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values = pad_axis_ly_slider_values, on_value_update = pause_menu_pad_axis_update_value, id = 1 },
	[3] = { label = "PC_PAD_RIGHT_AXIS_X", type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values = pad_axis_rx_slider_values, on_value_update = pause_menu_pad_axis_update_value, id = 2 },
	[4] = { label = "PC_PAD_RIGHT _AXIS_Y", type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values = pad_axis_ry_slider_values, on_value_update = pause_menu_pad_axis_update_value, id = 3 },

	[5] =  { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[6] = { label = "GENERAL_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[7] = { label = "PCACTION_ACTION", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "E", actid = PC_BTN_ACTION, on_select = pause_control_pad_button_change_PC },
	[8] = { label = "PCACTION_ATTACK_PRIMARY", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LMB", actid = PC_BTN_ATTACK, on_select = pause_control_pad_button_change_PC },
	[9] = { label = "PCACTION_ATTACK_SECONDARY", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "RMB", actid = PC_BTN_ATTACK2, on_select = pause_control_pad_button_change_PC },
	[10] = { label = "PCACTION_RECRUIT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_RECRUIT, on_select = pause_control_pad_button_change_PC },
	[11] = { label = "PCACTION_DISMISS_CANCEL", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_CANCEL, on_select = pause_control_pad_button_change_PC },
	[12] = { label = "PCACTION_MAP", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "TAB", actid = PC_BTN_MAP, on_select = pause_control_pad_button_change_PC },
	[13] = { label = "PCACTION_PAUSE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "ESC", actid = PC_BTN_PAUSE, on_select = pause_control_pad_button_change_PC },
	[14] = { label = "PCACTION_START", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "ESC", actid = PC_BTN_PAD_START, on_select = pause_control_pad_button_change_PC },
	[15] = { label = "PCACTION_RADIAL_MENU", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_RADIAL, on_select = pause_control_pad_button_change_PC },
	[16] = { label = "PCACTION_MENU_SELECT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_PAD_MENU_SELECT, on_select = pause_control_pad_button_change_PC },
	[17] = { label = "PCACTION_MENU_ALT_SELECT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_MENU_ALT_SELECT, on_select = pause_control_pad_button_change_PC },
	[18] = { label = "PCACTION_MENU_BACK", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_PAD_BACK, on_select = pause_control_pad_button_change_PC },
	[19] = { label = "PCACTION_MENU_SCROLL_LEFT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_MENU_SCROLL_LEFT, on_select = pause_control_pad_button_change_PC },
	[20] = { label = "PCACTION_MENU_SCROLL_RIGHT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Q", actid = PC_BTN_MENU_SCROLL_RIGHT, on_select = pause_control_pad_button_change_PC },

	[21] =  { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[22] = { label = "ON_FOOT_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },
	
	[23] = { label = "PCACTION_JUMP", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "SPACEBAR", actid = PC_BTN_JUMP, on_select = pause_control_pad_button_change_PC },
	[24] = { label = "PCACTION_SPRINT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LSHIFT", actid = PC_BTN_SPRINT, on_select = pause_control_pad_button_change_PC },
	[25] = { label = "PCACTION_RELOAD", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "R", actid = PC_BTN_RELOAD, on_select = pause_control_pad_button_change_PC },
	[26] = { label = "PCACTION_CROUCH", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "C", actid = PC_BTN_CROUCH, on_select = pause_control_pad_button_change_PC },
	[27] = { label = "PCACTION_FINE_AIM", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "V", actid = PC_BTN_FINE_AIM, on_select = pause_control_pad_button_change_PC },
	[28] = { label = "PCACTION_GRAB_HUMAN", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LCTRL", actid = PC_BTN_GRAB_HUMAN, on_select = pause_control_pad_button_change_PC },
	[29] = { label = "PCACTION_TAUNT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_TAUNT, on_select = pause_control_pad_button_change_PC },
	[30] = { label = "PCACTION_COMPLIMENT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_COMPLIMENT, on_select = pause_control_pad_button_change_PC }, 
	[31] = { label = "PCACTION_ZOOM_IN", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "H", actid = PC_BTN_ZOOM_IN, on_select = pause_control_pad_button_change_PC },
	[32] = { label = "PCACTION_ZOOM_OUT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "N", actid = PC_BTN_ZOOM_OUT, on_select = pause_control_pad_button_change_PC },

	[33] = { label = "PCACTION_FIGHT_CLUB_1", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_FIGHT_CLUB_MASH_1, on_select = pause_control_pad_button_change_PC },
	[34] = { label = "PCACTION_FIGHT_CLUB_2", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "AU", actid = PC_BTN_FIGHT_CLUB_MASH_2, on_select = pause_control_pad_button_change_PC }, 
	[35] = { label = "PCACTION_FIGHT_CLUB/AMBULANCE_L", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "H", actid = PC_BTN_FIGHT_CLUB_MASH_3, on_select = pause_control_pad_button_change_PC },
	[36] = { label = "PCACTION_FIGHT_CLUB/AMBULANCE_R", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "N", actid = PC_BTN_FIGHT_CLUB_MASH_4, on_select = pause_control_pad_button_change_PC },

	[37] =  { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[38] = { label = "VEHICLE_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[39] = { label = "PCACTION_ACCELERATE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "W", actid = PC_BTN_ACCELERATE, on_select = pause_control_pad_button_change_PC },
	[40] = { label = "PCACTION_REVERSE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "S", actid = PC_BTN_REVERSE, on_select = pause_control_pad_button_change_PC },
	[41] = { label = "PCACTION_BREAK", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "SPACEBAR", actid = PC_BTN_BREAK, on_select = pause_control_pad_button_change_PC },
	[42] = { label = "PCACTION_CRUISE_CONTROL", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "SPACEBAR", actid = PC_BTN_CRUISE, on_select = pause_control_pad_button_change_PC },
	[43] = { label = "PCACTION_HORN", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "H", actid = PC_BTN_HORN, on_select = pause_control_pad_button_change_PC },
	[44] = { label = "PCACTION_RADIO_NEXT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "RIGHT", actid = PC_BTN_RADIO_NEXT, on_select = pause_control_pad_button_change_PC },
	[45] = { label = "PCACTION_RADIO_PREVIOUS", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "LEFT", actid = PC_BTN_RADIO_PREV, on_select = pause_control_pad_button_change_PC },
	[46] = { label = "PCACTION_LOOK_BEHIND", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "X", actid = PC_BTN_VEHICLE_LOOK_BEHIND, on_select = pause_control_pad_button_change_PC },
	[47] = { label = "PCACTION_HYDRAULICS", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "P", actid = PC_BTN_HYDRAULICS, on_select = pause_control_pad_button_change_PC },
	[48] = { label = "PCACTION_NITRO", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "X", actid = PC_BTN_NITRO, on_select = pause_control_pad_button_change_PC },

	[49] =  { label = " ", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true },
	[50] = { label = "AIRCRAFT_CONTROLS", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil, disabled = true, it_is_caption_label = true, dimm_disabled = true },

	[51] = { label = "PCACTION_AIR_ACCELERATE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "W", actid = PC_BTN_AIR_ACCELERATE, on_select = pause_control_pad_button_change_PC },
	[52] = { label = "PCACTION_AIR_DECELERATE", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "S", actid = PC_BTN_AIR_DECELERATE, on_select = pause_control_pad_button_change_PC },
	[53] = { label = "PCACTION_RUDDER_LEFT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "Z", actid = PC_BTN_HELI_TURN_LEFT, on_select = pause_control_pad_button_change_PC },
	[54] = { label = "PCACTION_RUDDER_RIGHT", type = MENU_ITEM_TYPE_INFO_BOX, info_text_str = "C", actid = PC_BTN_HELI_TURN_RIGHT, on_select = pause_control_pad_button_change_PC }
}

Pause_control_menu = {
	header_label_str 	= "MENU_OPTIONS_CONTROLS",
	on_show 			= pause_menu_build_control_options_menu,
	on_alt_select 		= pause_menu_options_restore_defaults,
	on_back 			= pause_menu_option_revert,
	on_pause			= pause_menu_options_exit_confirm,
	on_map 				= pause_menu_options_swap_confirm,
	on_nav				= pause_menu_control_options_nav, 
	on_horz_show 		= pause_menu_option_accept_horz,
	num_items 			= 9,

	[0] = { label = "CONTROLS_SETUP_FOOT_SCHEMES", 		type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_menu_control_sub_menu, id = 0 },
	[1] = { label = "CONTROLS_SETUP_DRIVING_SCHEMES", 	type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_menu_control_sub_menu, id = 0 },
	[2] = { label = "MENU_CONTROLS_INVERT_Y", 			type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = invert_y_slider_values, 	on_value_update = pause_menu_control_options_update_value, id = 0, on_select = pause_menu_option_accept, },
	[3] = { label = "MENU_CONTROLS_INVERT_ROTATION", 	type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = invert_rot_slider_values,	on_value_update = pause_menu_control_options_update_value, id = 1, on_select = pause_menu_option_accept, },
	[4] = { label = "MENU_CONTROLS_STICK", 				type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = left_stick_slider_values,	on_value_update = pause_menu_control_options_update_value, id = 2, on_select = pause_menu_option_accept, },
	[5] = { label = "CONTROLS_SENSE_V",		 			type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, 				on_value_update = pause_menu_control_options_update_value, id = 3, on_select = pause_menu_option_accept, },
	[6] = { label = "CONTROLS_SENSE_H",				 	type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, 				on_value_update = pause_menu_control_options_update_value, id = 4, on_select = pause_menu_option_accept, },
	[7] = { label = "CONTROLS_FORCE_FEED", 				type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = vibration_slider_values,	on_value_update = pause_menu_control_options_update_value, id = 5, on_select = pause_menu_option_accept, },
	[8] = { label = "CONTROLS_CROUCH_TOGGLE", 			type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = crouch_slider_values,		on_value_update = pause_menu_control_options_update_value, id = 6, on_select = pause_menu_option_accept, },

	btn_tips = Pause_options_btn_tips,	
}

Pause_control_menu_PC = {
	header_label_str	= "MENU_OPTIONS_CONTROLS",
	on_show				= pause_menu_build_control_options_menu,
	on_back 			= pause_menu_option_revert,
	on_alt_select		= pause_menu_options_restore_defaults,
	on_map 				= pause_menu_options_swap_confirm,
	on_pause			= pause_menu_options_exit_confirm,
	num_items = 11,
	
	[0] = { label = "CONTROLS_SETUP", 		        	type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_menu_control_sub_menu_PC, id = -1 },
	[1] = { label = "PAD_CONTROLS_SETUP",				type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_menu_pad_control_sub_menu_PC, id = -1 },
	[2] = { label = "MENU_CONTROLS_INVERT_Y", 			type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = invert_y_slider_values, 	on_value_update = pause_menu_control_options_update_value, id = 0, on_select = pause_menu_option_accept, },
	[3] = { label = "MENU_CONTROLS_INVERT_ROTATION", 		type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = invert_rot_slider_values,	on_value_update = pause_menu_control_options_update_value, id = 1, on_select = pause_menu_option_accept, },
--uwaga! jak sie zmienia numeracje tu to trzeba poprawic w funkcji pause_menu_populate_control_options
	[4] = { label = "CONTROLS_MOUSE_SENS_V",		 	type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, on_value_update = pause_menu_control_options_update_value, id = 7, on_select = pause_menu_option_accept, },
	[5] = { label = "CONTROLS_MOUSE_SENSE_H",			type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, on_value_update = pause_menu_control_options_update_value, id = 8, on_select = pause_menu_option_accept, },
	[6] = { label = "CONTROLS_SENSE_V",		 		type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, on_value_update = pause_menu_control_options_update_value, id = 3, on_select = pause_menu_option_accept, },
	[7] = { label = "CONTROLS_SENSE_H",				type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, on_value_update = pause_menu_control_options_update_value, id = 4, on_select = pause_menu_option_accept, },
	[8] = { label = "MENU_CONTROLS_STICK", 				type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = left_stick_slider_values,	on_value_update = pause_menu_control_options_update_value, id = 2, on_select = pause_menu_option_accept, },
	[9] = { label = "CONTROLS_CROUCH_TOGGLE", 			type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = crouch_slider_values,		on_value_update = pause_menu_control_options_update_value, id = 6, on_select = pause_menu_option_accept, },
	[10] = { label = "CONTROLS_FORCE_FEED", 			type = MENU_ITEM_TYPE_TEXT_SLIDER, 	text_slider_values = vibration_slider_values,	on_value_update = pause_menu_control_options_update_value, id = 5, on_select = pause_menu_option_accept, },

	btn_tips = Pause_options_btn_tips,	
}


Pause_difficulty_menu = {
	num_items = 3,
	header_label_str = "MULTI_MENU_QUICK_MATCH_COOP_DIFFICULTY",
	on_show = pause_menu_build_difficulty_options_menu,
	on_back = pause_menu_option_revert,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	on_nav = pause_menu_difficulty_nav,
	
	
	[0] = { label = "DLT_CASUAL", type = MENU_ITEM_TYPE_SELECTABLE, difficulty_level = DIFFICULTY_CASUAL, on_select = pause_menu_option_revert }, 
	[1] = { label = "DLT_NORMAL", type = MENU_ITEM_TYPE_SELECTABLE, difficulty_level = DIFFICULTY_NORMAL, on_select = pause_menu_option_revert }, 
	[2] = { label = "DLT_HARDCORE", type = MENU_ITEM_TYPE_SELECTABLE, difficulty_level = DIFFICULTY_HARDCORE, on_select = pause_menu_option_revert }, 
	
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_display_menu = {
	header_label_str = "MENU_OPTIONS_DISPLAY",
	on_show 			= pause_menu_build_display_options_menu,
	on_alt_select 		= pause_menu_options_restore_defaults,
	on_back 			= pause_menu_option_revert,
	on_pause			= pause_menu_options_exit_confirm,
	on_map 				= pause_menu_options_swap_confirm,
	on_nav				= pause_menu_display_options_nav,
	on_horz_show 		= pause_menu_option_accept_horz,
	num_items = 5,

	[0] = { label = "MENU_DISPLAY_MONITOR_ADJUSTMENT",	type = MENU_ITEM_TYPE_SELECTABLE,	on_select = pause_menu_display_brightness_screen,	},
	[1] = { label = "MENU_CONTROLS_SUBTITLES",			type = MENU_ITEM_TYPE_TEXT_SLIDER,	text_slider_values =	subtitles_slider_values,		on_value_update = pause_menu_display_options_update_value, id = 1, on_select = pause_menu_option_accept,	},
	[2] = { label = "MENU_VSYNC_GAMEPLAY_TEXT",			type = MENU_ITEM_TYPE_TEXT_SLIDER,	text_slider_values =	vsync_gameplay_slider_values,	on_value_update = pause_menu_display_options_update_value, id = 2, on_select = pause_menu_option_accept,	},
	[3] = { label = "MENU_VSYNC_CUTSCENE_TEXT",			type = MENU_ITEM_TYPE_TEXT_SLIDER,	text_slider_values =	vsync_cutscene_slider_values,	on_value_update = pause_menu_display_options_update_value, id = 3, on_select = pause_menu_option_accept,	},
	[4] = { label = "CONTROLS_MINIMAP_VIEW",				type = MENU_ITEM_TYPE_TEXT_SLIDER,	text_slider_values =	minimap_slider_values,			on_value_update = pause_menu_display_options_update_value, id = 4, on_select = pause_menu_option_accept,	},

	btn_tips = Pause_options_btn_tips,
}

function pause_menu_build_display_options_menu_PC(menu_data)
	Pause_menu_current_option_menu = PAUSE_MENU_DISPLAY_ID
	menu_data.parent_menu = nil
	
	vint_dataresponder_request("pause_menu_populate", "pause_menu_populate_display", 0, PAUSE_MENU_OPTIONS_POPULATE_ID, PAUSE_MENU_DISPLAY_ID, false)
end

function screen_change_failed_pc()
	dialog_box_message( "MENU_TITLE_WARNING", "GRAPHICS_CHANGE_FAILED" )
end

fullscreen_slider_values	= {
	[0] = { label = "CONTROL_NO" },
	[1] = { label = "CONTROL_YES" },
	num_values = 2,
	cur_value = 1
}

vsync_slider_values	= {
	[0] = { label = "CONTROL_NO" },
	[1] = { label = "CONTROL_YES" },
	num_values = 2,
	cur_value = 0
}

resolution_slider_values	= {
	[0] = { label = "640x480" },
	[1] = { label = "800x600" },
	[2] = { label = "1024x768" },
	[3] = { label = "1280x720" },
	[4] = { label = "1280x800" },
	[5] = { label = "1280x960" },
	[6] = { label = "1280x1024" },
	[7] = { label = "1440x900" },
	[8] = { label = "1600x1200" },
	[9] = { label = "1680x1050" },
	[10] = { label = "1920x1080" },
	[11] = { label = "1920x1200" },
	[12] = { label = "1920x1440" },
	[13] = { label = "2048x1536" },
	num_values = 14,
	cur_value = 0
}

graphics_quality_slider_values	= {
	[0] = { label = "QUALITY_LOW_TEXT" },
	[1] = { label = "QUALITY_MEDIUM_TEXT" },
	[2] = { label = "QUALITY_HIGH_TEXT" },
	[3] = { label = "QUALITY_CUSTOM_TEXT" },

	num_values = 4,
	cur_value = 2
}

function pause_menu_display_options_update_value_fullscreen(menu_label, menu_data)

end

function pause_menu_display_options_update_value_resolution(menu_label, menu_data)

end

Pause_display_menu_PC = {
	header_label_str	= "MENU_OPTIONS_DISPLAY",
	on_show 			= pause_menu_build_display_options_menu_PC,
	on_alt_select 		= pause_menu_options_restore_defaults,
	on_back 			= pause_menu_option_revert,
	on_pause			= pause_menu_options_exit_confirm,
	on_map 				= pause_menu_options_swap_confirm,
	on_nav				= pause_menu_display_options_nav,
	on_horz_show 		= pause_menu_option_accept_horz,
	num_items = 17,

	[0] = { label = "MENU_DISPLAY_MONITOR_ADJUSTMENT",	type = MENU_ITEM_TYPE_SELECTABLE,																																		on_select = pause_menu_display_brightness_screen,	cur_value = 0, },
	[1] = { label = "MENU_RESOLUTION_TEXT",				type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	resolution_slider_values,				on_value_update = pause_menu_display_options_update_value,	id = 1,		on_select = pause_menu_options_submenu_exit_confirm },
	[2] = { label = "MENU_FULLSCREEN_TEXT",				type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	fullscreen_slider_values,				on_value_update = pause_menu_display_options_update_value,	id = 2,		on_select = pause_menu_options_submenu_exit_confirm },
	[3] = { label = "MENU_VSYNC",						type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	vsync_slider_values,					on_value_update = pause_menu_display_options_update_value,	id =15,		on_select = pause_menu_options_submenu_exit_confirm },
	[4] = { label = "MENU_CONTROLS_SUBTITLES",			type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	subtitles_slider_values,				on_value_update = pause_menu_display_options_update_value,	id = 4,		on_select = pause_menu_options_submenu_exit_confirm },
	[5] = { label = "CONTROLS_MINIMAP_VIEW",			type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	minimap_slider_values,					on_value_update = pause_menu_display_options_update_value,	id = 5,		on_select = pause_menu_options_submenu_exit_confirm },
	[6] = { label = "MENU_GRAPHICS_QUALITY_TEXT",		type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	graphics_quality_slider_values,			on_value_update = pause_menu_display_options_update_value,	id = 3,		on_select = pause_menu_options_submenu_exit_confirm },
	[7] = { label = "Ambient_Occlussion",				type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_ambient_slider_values,				on_value_update = pause_menu_display_options_update_value,	id = 6,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[8] = { label = "MENU_MOTION_BLUR",					type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_motion_blur_slider_values,			on_value_update = pause_menu_display_options_update_value,	id =11,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[9] = { label = "Fullscreen_Antialiasing",			type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_antiali_slider_values,				on_value_update = pause_menu_display_options_update_value,	id = 7,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[10] = { label = "ANISOTROPY_FILTERING",			type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_anisotropy_slider_values,			on_value_update = pause_menu_display_options_update_value,	id =16,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[11] = { label = "HDR",								type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_hdr_slider_values,					on_value_update = pause_menu_display_options_update_value,	id = 8,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[12] = { label = "Shadow_Maps",						type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_shadow_slider_values,				on_value_update = pause_menu_display_options_update_value,	id = 9,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[13] = { label = "View_Distance",					type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_distance_slider_values,				on_value_update = pause_menu_display_options_update_value,	id =10,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[14] = { label = "MENU_DYNAMIC_LIGHTS",				type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_dynamic_lights_slider_values,		on_value_update = pause_menu_display_options_update_value,	id =12,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[15] = { label = "MENU_BLUR",						type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_blur_slider_values,					on_value_update = pause_menu_display_options_update_value,	id =13,		on_select = pause_menu_options_submenu_exit_confirm }, 
	[16] = { label = "MENU_DEPTH_OF_FIELD",				type = MENU_ITEM_TYPE_TEXT_SLIDER, text_slider_values =	adv_depthoffield_slider_values,			on_value_update = pause_menu_display_options_update_value,	id =14,		on_select = pause_menu_options_submenu_exit_confirm }, 

	btn_tips = Pause_options_btn_tips,
}


Pause_audio_menu = {
	header_label_str 	= "MENU_OPTIONS_AUDIO",
	on_alt_select 		= pause_menu_options_restore_defaults,
	on_back 			= pause_menu_option_revert,
	on_show 			= pause_menu_build_audio_options_menu,
	on_pause			= pause_menu_options_exit_confirm,
	on_map 				= pause_menu_options_swap_confirm,
	on_nav_down			= pause_menu_audio_nav,
	on_horz_show 		= pause_menu_option_accept_horz,
	num_items = 4,
	
	[0] = { label = "MENU_AUDIO_SFX", 						type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0, 							on_value_update = pause_menu_audio_options_update_value, id = 0, on_select = pause_menu_option_accept,	},
	[1] = { label = "MENU_AUDIO_MUSIC", 					type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0,  							on_value_update = pause_menu_audio_options_update_value, id = 1, on_select = pause_menu_option_accept,	},
	[2] = { label = "MENU_AUDIO_VOICE",						type = MENU_ITEM_TYPE_NUM_SLIDER,	thumb_width = 70, cur_value = 0,  							on_value_update = pause_menu_audio_options_update_value, id = 2, on_select = pause_menu_option_accept,	},
	[3] = { label = "MENU_AUDIO_RADIO",						type = MENU_ITEM_TYPE_TEXT_SLIDER,	text_slider_values = vehicle_radio_slider_values,		on_value_update = pause_menu_audio_options_update_value, id = 3, on_select = pause_menu_option_accept,	},

	btn_tips = Pause_options_btn_tips,
}

function pause_menu_options_show_pc()
	pause_menu_options_init_call()
end

--modes:
-- 0 natural
-- 1 main menu
-- 2 multiplayer
Pause_options_menu = {
	num_items = 5,
	header_label_str = "PAUSEMENU_CAT_OPTIONS",
	on_show = pause_menu_options_show_pc,
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	on_show = pause_menu_options_on_show,
	
	[0] = { label = "MULTI_MENU_QUICK_MATCH_COOP_DIFFICULTY",	type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_difficulty_menu, 			},
	[1] = { label = "MENU_OPTIONS_CONTROLS", 	type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_control_menu_PC, 		},
	[2] = { label = "MENU_OPTIONS_DISPLAY",	type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_display_menu_PC, 		},
	[3] = { label = "MENU_OPTIONS_AUDIO",		type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_audio_menu, 			},
	[4] = { label = "MENU_OPTIONS_QUIT_GAME",	type = MENU_ITEM_TYPE_SELECTABLE, on_select = pause_menu_quit_game 	},
}

Pause_options_menu_no_difficulty = {
	num_items = 4,
	header_label_str = "PAUSEMENU_CAT_OPTIONS",
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	
	[0] = { label = "MENU_OPTIONS_CONTROLS", 	type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_control_menu_PC, 		},
	[1] = { label = "MENU_OPTIONS_DISPLAY",	type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_display_menu_PC, 		},
	[2] = { label = "MENU_OPTIONS_AUDIO",		type = MENU_ITEM_TYPE_SUB_MENU, 	sub_menu = Pause_audio_menu, 			},
	[3] = { label = "MENU_OPTIONS_QUIT_GAME",	type = MENU_ITEM_TYPE_SELECTABLE, on_select = pause_menu_quit_game 	},
}

Pause_menu_cell_phone = {
	on_show 	= pause_menu_cellphone_show,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	on_exit 	= pause_menu_cellphone_exit,
	custom_show = true,
	num_items = 1,

	[0] = { label = "", type = MENU_ITEM_TYPE_SELECTABLE },
	
	btn_tips = Pause_cellphone_btn_tips,
}

Pause_menu_playlist_editor = {
	header_label_str = "PAUSE_MENU_CAT_RADIO", 
	on_show			= pause_menu_playlist_show,
	on_back			= pause_menu_playlist_on_back,
	--on_exit			= pause_menu_playlist_on_exit,
	on_post_show	= pause_menu_playlist_post_show,
	--on_pause 		= pause_menu_playlist_confirm_exit,
	on_map 			= pause_menu_playlist_confirm_swap,
	get_width 		= pause_menu_playlist_get_width,
	get_height 		= pause_menu_playlist_get_height,
	on_horz_show 	= pause_menu_playlist_horz_show,
	
	
	num_items 		= 1,
	
	[0] = { label = "", type = PAUSE_MENU_CONTROL_PLAYLIST_EDITOR, on_select = pause_menu_playlist_on_select },
	
	footer_height = 40,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_menu_station_selection = {
	header_label_str = "PAUSE_MENU_STATION_SELECTION",
	on_show  = pause_menu_station_show,
	on_release = pause_menu_station_exit,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,
	num_items = 1,
	
	[0] = {	label = "", type = MENU_ITEM_TYPE_GRID, on_select = pause_menu_station_select, on_nav = pause_menu_station_nav, update_swatch = pause_menu_station_update_swatch,
				col_width = 138, row_height = 108, num_cols = 5, highlight_scale = 1, unhighlight_scale = 0.75, on_leave = pause_menu_station_leave_swatch	},
				
	footer_height = 40,
	btn_tips = Pause_menu_accept_back_btn_tips,
}

Pause_menu_radio = {
	header_label_str = "PAUSEMENU_CAT_AUDIO",
	on_pause = pause_menu_exit,
	on_back = pause_menu_exit,
	on_map = pause_menu_swap,
	num_items = 2,
	
	[0] = { label = "PAUSE_MENU_STATION_SELECTION", type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_menu_station_selection,		},
	[1] = { label = "PAUSE_MENU_CAT_RADIO", 			type = MENU_ITEM_TYPE_SUB_MENU, sub_menu = Pause_menu_playlist_editor,			},
}

Pause_score_board	= { 
	header_label_str = "MP_SCOREBOARD_CAPS",
	on_show = pause_menu_scoreboard_show,
	on_back = pause_menu_exit,
	on_pause = pause_menu_exit,
	num_items = 1,
	get_width = pause_menu_scoreboard_get_width,
	get_height = pause_menu_scoreboard_get_height,
	on_map = pause_menu_swap,
	
	[0] = { label = "", type = PAUSE_MENU_CONTROL_SCOREBOARD }
}

Coop_pause_invite_player_menu = {
	num_items = 1,
	header_label_str = "MULTI_LOBBY_INVITE_FRIENDS",
	btn_tips = Pause_control_schemes_btn_tips,
	
	[0] =  { label = "MM_LOAD_LOADING", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil },
}

Pause_coop_menu = {
	header_label_str = "MAINMENU_COOP",
	on_show = pause_menu_coop_show,
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	num_items = 0,
}

Pause_horz_menu = {
	num_items = 5,
	current_selection = 0,
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	on_map = pause_menu_swap,
	
	[0] = { label = "PAUSEMENU_CAT_INFO", 			sub_menu = Pause_info_menu 		},
	[1] = { label = "PAUSEMENU_CAT_SAVELOAD", 	sub_menu = Pause_save_load_menu 	},
	[2] = { label = "PAUSEMENU_CAT_OPTIONS",		sub_menu = Pause_options_menu 	},
	[3] = { label = "PAUSEMENU_CAT_AUDIO", 		sub_menu = Pause_menu_radio		},	
	[4] = { label = "PAUSEMENU_CAT_PHONE", 		sub_menu = Pause_menu_cell_phone }, 
   [5] = { label = "MP_SCOREBOARD_CAPS", 			sub_menu = Pause_score_board		},
}

Multi_pause_horz_menu_options_only = {
	num_items = 1,
	current_selection = 0,
	on_back = pause_menu_exit,
	on_pause	= pause_menu_exit,
	
	[0] = { label = "TUTORIAL_LOBBY",	sub_menu = Pause_options_menu_no_difficulty 	},
}

Pause_menu_no_friends_menu = {
	num_items = 1,
	header_label_str = "MULTI_LOBBY_INVITE_FRIENDS",
	on_back = pause_menu_quit_game,
	
	[0] =  { label = "NO_FRIENDS_ONLINE", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil },
}

Coop_invite_friends_menu = {
	num_items = 1,
	header_label_str = "MULTI_LOBBY_INVITE_FRIENDS",
	on_show = coop_pause_load_friends_coop_start,
	on_back = pause_menu_quit_game,
	
	[0] =  { label = "MM_LOAD_LOADING", type = MENU_ITEM_TYPE_SELECTABLE, on_select = nil },
}

Coop_invite_friends_horz_menu = {
	num_items = 0, 
	current_selection = 0,
	on_back = pause_menu_quit_game,
	btn_tips = Pause_menu_quit_to_main_only_tips,

	--[0] = { label = "MULTI_LOBBY_INVITE_FRIENDS", sub_menu = Coop_invite_friends_menu },
}

MP_Pause_horz_menu = {
	num_items = 2, 
	current_selection = 0,
	on_back = pause_menu_exit,
	on_pause = pause_menu_exit,
	on_map = pause_menu_swap,

	[0] = { label = "MP_SCOREBOARD_CAPS", 	sub_menu = Pause_score_board		},
	[1] = { label = "PAUSEMENU_CAT_OPTIONS",		sub_menu = Pause_options_menu 	},
}

Pause_menu_controls = {
	[PAUSE_MENU_CONTROL_OBJECTIVE_TEXT_LINE] = {
		on_show 		=	pause_menu_control_objective_text_line_show,
		on_select 	=	nil,
		on_nav_up	=	pause_menu_control_nav_up,
		on_nav_down	=	pause_menu_control_nav_down,
		on_release	=  pause_menu_control_release,
--		get_width	=	pause_menu_objective_get_width,
--		get_height	=	pause_menu_objective_get_height, 	
		use_scroll_bar  = false,
		hide_select_bar = true,
	},
	
	[PAUSE_MENU_CONTROL_OBJECTIVE_WRAP_LINE] = {
	
		on_show 		=	pause_menu_control_objective_wrap_line_show,
		on_select 	=	nil,
		on_release  =  pause_menu_control_objective_release,
		on_nav_up	=	pause_menu_control_objective_nav_up,
		on_nav_down	=	pause_menu_control_objective_nav_down,
		get_width		=	pause_menu_objective_wrap_get_width,
		get_height		=	pause_menu_objective_wrap_get_height, 	
		uses_scroll_bar =		true,
		hide_select_bar =		true,
		hide_label_stripe =	true,
	},

	[PAUSE_MENU_CONTROL_STAT_TEXT_LINE] = {
		on_show			=	pause_menu_control_stat_text_line_show,
		on_select		= 	nil,
		on_nav_left 	=  pause_menu_control_page_up,
		on_nav_up		=	pause_menu_control_page_up,
		on_nav_right	=	pause_menu_control_page_down,
		on_nav_down		=	pause_menu_control_page_down,
		on_release		=  pause_menu_control_stat_text_line_release,
		uses_scroll_bar = false,
		hide_select_bar = true,
	},
	
	[PAUSE_MENU_CONTROL_DIVERSION_TEXT_LINE] = {
		on_show			=	pause_menu_control_diversion_text_line_show,
		on_select		= 	menu_submenu_on_select,
		on_release		=	pause_menu_control_release,
		on_enter			=	pause_menu_control_diversion_text_line_enter,
		on_leave			=	pause_menu_control_diversion_text_line_leave,
	},
	
	[PAUSE_MENU_CONTROL_CHECKBOX_IMAGE] = {
		on_show			=	pause_menu_control_checkbox_image_show,
		on_select		= 	menu_control_on_select,
		on_nav_up		=	pause_menu_control_checkbox_image_nav_up,
		on_nav_down		=	pause_menu_control_checkbox_image_nav_down,
		on_release		=  pause_menu_control_checkbox_image_release,
		uses_scroll_bar = false,
	},

	[PAUSE_MENU_CONTROL_SAVE_LOAD] = {
		on_show			=	pause_menu_control_save_load_show,
		on_select		= 	menu_control_on_select,
		on_release		=  pause_menu_control_save_load_release,
		on_enter			=	pause_menu_control_save_load_enter,
		on_leave			=	pause_menu_control_save_load_leave,
		get_width		=	pause_menu_control_save_load_get_width,
	},
	
	[PAUSE_MENU_CONTROL_HELP_TEXT] = { 
		on_show			=  pause_menu_control_help_text_show,
		on_select		=	nil,
		on_release		=	pause_menu_control_help_release,
		uses_scroll_bar = true,
		hide_select_bar = true,
	},

	[PAUSE_MENU_CONTROL_CENTERED_LABEL] = {
		on_show			=	pause_menu_control_centered_label_show,
		on_select		= 	menu_control_on_select,
		on_release		=  pause_menu_control_centered_label_release,
		on_enter			=	pause_menu_control_centered_label_enter,
		on_leave			=	pause_menu_control_centered_label_leave,
		get_width		=	pause_menu_control_centered_label_get_width,
	},
	
	[PAUSE_MENU_CONTROL_PLAYLIST_EDITOR] = {
		on_show			=	pause_menu_control_playlist_editor_show,
		on_release		=  pause_menu_control_playlist_on_release,
		on_select		= 	menu_control_on_select,
		on_alt_select	=	pause_menu_control_playlist_alt_select,
		on_nav_up		=	pause_menu_control_playlist_nav_up,
		on_nav_down		=  pause_menu_control_playlist_nav_down,
		on_nav_left		= 	pause_menu_control_playlist_activate_pane,
		on_nav_right	= 	pause_menu_control_playlist_activate_pane,
		use_scroll_bar  = false,
		hide_label_stripe =	true,
	},
	
	[PAUSE_MENU_CONTROL_SCOREBOARD] = {
		on_show			=	pause_menu_control_scoreboard_on_show,
		on_release		=  pause_menu_control_scoreboard_on_release,
			
		hide_select_bar = true,
		use_scroll_bar  = false,
	},
	
	[PAUSE_MENU_CONTROL_LOBBY_PLAYERS] = {
		on_show			=	pause_menu_control_lobby_players_on_show,
		on_release		=  pause_menu_control_lobby_players_on_release,
			
		hide_select_bar = true,
		use_scroll_bar  = false,
	}
}

