Game = {
	start_time = 100,
	current_time = 0,
	current_map_component = Main_Component,
	mx = 0,
	my = 0,
	mb = 0,
	zombies = {}
}

Display = {
	map_component_x = 0,
	map_component_y = 10,
	cam_x = 0,
	cam_y = 0
}

function render_top_hud()
	spr(Assets.coin_sprite, 20, -2)
	print(Player.coins, 28, 0, 11)
	print(Game.current_time, 0, 0, 7)
	spr(Assets.ammo_sprite, 42, -2)
	print(Shotgun.current_rounds, 50, 0, 11)
end

function render_current_map_component()
	local mc = Game.current_map_component
	local vis_x = flr(Display.cam_x / 8)
	local vis_y = flr(Display.cam_y / 8)
	map(mc.map_col + vis_x, mc.map_row + vis_y, vis_x * 8, vis_y * 8, 17, 15)
end

function _init()
	poke(0x5f2d, 1)
end

function _update60()
	Game.mx = stat(32)
	Game.my = stat(33)
	Game.mb = stat(34)

	local mc = Game.current_map_component
	local view_h = 128 - Display.map_component_y
	Display.cam_x = mid(0, Player.x - 64, mc.tile_w * 8 - 128)
	Display.cam_y = mid(0, Player.y - flr(view_h / 2), mc.tile_h * 8 - view_h)

	local aim_x = Game.mx + Display.cam_x
	local aim_y = Game.my + Display.cam_y - Display.map_component_y
	Player.aim = atan2(aim_x - Player.x, aim_y - Player.y)

	Game.current_time = max(0, Game.start_time - flr(time()))

	handle_keys()
	update_gun()
	detect_item_on_player()
	check_current_component_exits()
end

function _draw()
	cls()
	local mc = Game.current_map_component

	camera(Display.cam_x, Display.cam_y - Display.map_component_y)
	clip(0, Display.map_component_y, 128, 128 - Display.map_component_y)

	render_current_map_component()
	render_pellets()
	render_component_items(mc)
	spr(Player.sprite_num, Player.x, Player.y)
	reload_animation()

	clip()
	camera()

	render_top_hud()
	line(Game.mx - 4, Game.my, Game.mx + 4, Game.my, 7)
	line(Game.mx, Game.my - 4, Game.mx, Game.my + 4, 7)

	if touching_exit then
		print("EXIT TOUCHED!")
	end
end
