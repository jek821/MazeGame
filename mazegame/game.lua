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

-- Screen dimensions and derived viewport size:
Display = {
	screen_w = 128,  -- pico-8 screen width
	screen_h = 128,  -- pico-8 screen height
	hud_h    = 10,   -- pixels reserved for the top hud bar
	view_w   = 128,  -- playfield width (full screen, no horizontal hud)
	view_h   = 118,  -- playfield height (screen_h - hud_h)
	cam_x    = 0,    -- current camera offset x
	cam_y    = 0     -- current camera offset y
}

function update_mouse()
	-- Get raw absolute position and compute how far it moved since last frame:
	local rx = stat(32)
	local ry = stat(33)
	local dx = rx - Game._raw_mx
	local dy = ry - Game._raw_my
	Game._raw_mx = rx
	Game._raw_my = ry
	-- Accumulate scaled delta into virtual cursor, clamped to screen bounds:
	Game.mx = mid(0, Game.mx + dx * Game.mouse_sens, Display.screen_w)
	Game.my = mid(0, Game.my + dy * Game.mouse_sens, Display.screen_h)
	Game.mb = stat(34)
end

function update_camera()
	local mc = Game.current_map_component
	-- Keep player centered on screen, but stop scrolling before the component edge.
	-- Player.x - 64 puts player in the middle of the 128px screen.
	-- mc.tile_w * 8 - Display.view_w is how many pixels the camera can scroll before hitting the right edge.
	-- max(0, ...) handles rooms narrower than the screen -- the scroll range would be negative without it:
	Display.cam_x = mid(0, Player.x - 64,                        max(0, mc.tile_w * 8 - Display.view_w))
	Display.cam_y = mid(0, Player.y - flr(Display.view_h / 2),   max(0, mc.tile_h * 8 - Display.view_h))
end

function update_timer()
	Game.current_time = max(0, Game.start_time - flr(time()))
end

function render_current_map_component()
	local mc = Game.current_map_component
	-- Draw mc.tile_w x mc.tile_h tiles starting at map cell (mc.map_col, mc.map_row) at world position (0, 0):
	map(mc.map_col, mc.map_row, 0, 0, mc.tile_w, mc.tile_h)
end

function render_hud()
	spr(Assets.coin_sprite, 20, -2)
	print(Player.coins, 28, 0, 11)
	print(Game.current_time, 0, 0, 7)
	spr(Assets.ammo_sprite, 42, -2)
	print(Shotgun.current_rounds, 50, 0, 11)
end

function render_crosshair()
	line(Game.mx - 4, Game.my, Game.mx + 4, Game.my, 7)
	line(Game.mx, Game.my - 4, Game.mx, Game.my + 4, 7)
end

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
