Game = {
	start_time = 100,
	current_time = 0,
	current_map_component = Main_Component,
	mx = 64,        -- virtual cursor x, starts at screen center
	my = 64,        -- virtual cursor y, starts at screen center
	mb = 0,
	_raw_mx = 0,    -- last raw stat(32) value, used to compute delta
	_raw_my = 0,    -- last raw stat(33) value, used to compute delta
	mouse_sens = 2, -- multiply delta by this each frame
	zombies = {}
}

function _init()
	poke(0x5f2d, 1)
end

function _update60()
	update_mouse()
	update_camera()
	update_player()
	update_gun()
	update_timer()
	update_exits()
end

function _draw()
	cls()
	-- Shift all drawing by cam_x/cam_y so world position (0,0) scrolls with the player.
	-- Subtract hud_h from cam_y so world y=0 lands at screen y=10, below the hud:
	camera(Display.cam_x, Display.cam_y - Display.hud_h)
	-- Prevent drawing over the hud bar at the top of the screen:
	clip(0, Display.hud_h, Display.screen_w, Display.view_h)

	render_current_map_component()
	render_component_items(Game.current_map_component)
	render_player()
	render_gun()

	clip()
	camera()

	render_hud()
	render_crosshair()

	if touching_exit then
		print("EXIT TOUCHED!")
	end
end
