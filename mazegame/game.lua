Game = {
	start_time = 100,
	current_time = 0,
	current_map_component = Main_Component,
	mx = 0,
	my = 0,
	mb = 0,
	zombies = {}
}

function render_top_hud()
	spr(Assets.coin_sprite, 20, -2)
	print(Player.coins, 28, 0, 11)
	print(Game.current_time, 0, 0, 7)
	spr(Assets.ammo_sprite, 42, -2)
	print(Shotgun.current_rounds, 50, 0, 11)
end

function _init()
	poke(0x5f2d, 1)
end

function _update60()
	Game.mx = stat(32)
	Game.my = stat(33)
	Game.mb = stat(34)

	Player.aim = atan2(Game.mx - Player.x, Game.my - Player.y)

	Game.current_time = max(0, Game.start_time - flr(time()))

	handle_keys()
	update_gun()
	detect_item_on_player()
	update_component_portals(Game.current_map_component)
	check_current_component_portals()
end

function _draw()
	cls()
	local comp = Game.current_map_component
	map(comp.map_col, comp.map_row, comp.draw_x, comp.draw_y, flr(comp.pixel_w / 8), flr(comp.pixel_h / 8))
	render_pellets()
	reload_animation()
	render_component_items(comp)
	render_component_portals(comp)
	spr(Player.sprite_num, Player.x, Player.y)
	render_top_hud()
	line(Game.mx - 4, Game.my, Game.mx + 4, Game.my, 7)
	line(Game.mx, Game.my - 4, Game.mx, Game.my + 4, 7)

	if touching_portal then
		print("PORTAL TOUCHED!")
	end
end