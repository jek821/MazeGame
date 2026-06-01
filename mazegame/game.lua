Game = {
	start_time   = 100,
	current_time = 0,
	current_room = Main_Room,
	cam_x = 0,
	cam_y = 0,
	mx = 0,
	my = 0,
	mb = 0,
	zombies = {}
}

function render_top_hud()
	spr(Assets.coin_sprite, 45, -2)
	print(Player.coins, 40, 0, 12)
	print(Game.current_time, 0, 0, 7)
end

function _init()
	poke(0x5f2d, 1)
end

function _update60()
	Game.mx = stat(32)
	Game.my = stat(33)
	Game.mb = stat(34)
	Game.cam_x = Player.x - 64
	Game.cam_y = Player.y - 64

	local world_mx = Game.mx + Game.cam_x
	local world_my = Game.my + Game.cam_y
	Player.aim = atan2(world_mx - Player.x, world_my - Player.y)

	Game.current_time = max(0, Game.start_time - flr(time()))

	handle_keys()
	update_gun()
	detect_item_on_player()
	update_room_portals(Game.current_room)
	check_current_room_portals()
end

function _draw()
	cls()
	camera(Player.x - 64, Player.y - 64)
	map()
	render_pellets()
	render_room_items(Game.current_room)
	render_room_portals(Game.current_room)
	spr(Player.sprite_num, Player.x, Player.y)
	camera()
	render_top_hud()
	line(Game.mx - 4, Game.my, Game.mx + 4, Game.my, 7)
	line(Game.mx, Game.my - 4, Game.mx, Game.my + 4, 7)

	if touching_portal then
		print("PORTAL TOUCHED!")
	end
end
