pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--==========
-- Debug GusCHung
--==========
touching_portal = false 




--==========
-- AI Movement
--==========





--==========
-- Sprite Flags
--==========
flags = {
	solid = 1
}


--==========
-- ROOM DEFINITIONS
--==========

Test_Room = {
	top_leftx = 103 * 8,
	top_lefty = 12 * 8, 
	bottom_rightx = 126 * 8,
	bottom_righty = 30 * 8
}


Main_Room = {
	-- * 8 because each "pixel" is a sprite which is actually 8 pixels...
	-- Offset by 1 pixel ine very direction from room listed coordinates, to exclude walls
	top_leftx = 1 * 8,
	top_lefty = 1 * 8,
	bottom_rightx = 16 * 8,
	bottom_righty = 12 * 8,
	items = {
		-- { sprite_id, x_pos, y_pos}
	},
	portals = {
		{x = 2*8, y = 5*8, destination = Test_Room}
	}
}

--==========
-- STATES
--==========


--GUN STATE
Shotgun = {
	pellets = {},
	shoot_cooldown = 0,
	max_rounds = 6,
	current_rounds = 6,
	reloading = false
}

-- PLAYER STATE
Player = {
	sprite_num = 7,
	x = 64,
	y = 64,
	aim = 0,
	ammo = 10,
	health = 100,
	coins = 0
}

-- GAME STATE
Game = {
	start_time = 100,
	current_time = 0,
	current_room = Main_Room,
	cam_x = 0,
	cam_y = 0,
	mx = 0,
	my = 0,
	mb = 0,
	zombies = {
		-- {x, y, health, speed}
	}
}

--==========
-- HELPERS
--==========

--GUN HELPERS
function can_shoot_shotgun()
	if Shotgun.shoot_cooldown == 0 and Shotgun.reloading == false and Shotgun.current_rounds > 0 then
		return true
	end
	return false
end

function fire_shotgun(px, py, aim_angle)
	music(1)
	local pellet_count = 8
	local spread = 0.10
	for i = 1, pellet_count do
		local offset = rnd(spread) - spread / 2
		local a = aim_angle + offset
		add(
			Shotgun.pellets, {
				x = px,
				y = py,
				dx = cos(a) * 3,
				dy = sin(a) * 3,
				life = 20
			}
		)
	end
end

-- ROOM HELPERS

function checkCurrentRoomPortals()
	for portal in all(Game.current_room.portals) do
		if abs(portal.x - Player.x) < 8 and abs(portal.y - Player.y) < 8 then
			touching_portal = true
			return
		end
		touching_portal = false

	end
end

function renderRoomItems(room)
	for item in all(room.items) do
		spr(item.id, item.x, item.y)
	end
end

function randomItemSpawnInRoom(room, itemId, numItems)
	if itemId == 34 then
		for i = 0, numItems do
			local rnd_x = flr(rnd(room.bottom_rightx - room.top_leftx) + room.top_leftx)
			local rnd_y = flr(rnd(room.bottom_righty - room.top_lefty) + room.top_lefty)
			add(
				room.items, { id = itemId, x = rnd_x, y = rnd_y }
			)
		end
	end
end

-- PLAYER HELPERS

function godMode()
	Shotgun.current_rounds = 1000
	Player.health = 100000
end

function detectItemOnPlayer()
	for item in all(Game.current_room.items) do
		-- need to check range of pixels
		if abs(item.x - Player.x) < 8 and abs(item.y - Player.y) < 8 then
			if item.id == 34 then
				music(0)
				del(Game.current_room.items, item)
				Player.coins += 1
			end
		end
	end
end

function is_solid(x, y)
	-- convert pixel position to map tile position
	local tile_x = flr(x / 8)
	local tile_y = flr(y / 8)
	local tile = mget(tile_x, tile_y)
	return fget(tile, flags.solid)
end


--==========
-- Enemy Helpers
--==========


--===========
-- USER INPUT
--===========

function handle_keys()
	-- !! is solid detection values look arbitrary but they are all different because of different player positions for each player sprite... !!
	-- Loop through all 256 key codes
	for i = 0, 255 do
		-- Check if the key is currently held down
		if stat(28, i) then
			-- W
			if i == 26 then
				Player.sprite_num = 23
				if not is_solid(Player.x, Player.y - 1) and not is_solid(Player.x + 7, Player.y - 1) then
					Player.y -= 1
				end
			end
			-- d
			if i == 7 then
				Player.sprite_num = 8
				if not is_solid(Player.x + 8, Player.y) and not is_solid(Player.x + 8, Player.y + 7) then
					Player.x += 1
				end
			end
			-- s
			if i == 22 then
				Player.sprite_num = 7
				if not is_solid(Player.x, Player.y + 8) and not is_solid(Player.x + 7, Player.y + 8) then
					Player.y += 1
				end
			end
			-- a
			if i == 4 then
				Player.sprite_num = 24
				if not is_solid(Player.x - 1, Player.y) and not is_solid(Player.x - 1, Player.y + 7) then
					Player.x -= 1
				end
			end
		end
	end
	-- z
	if Game.mb == 1 and can_shoot_shotgun() then
		-- 4 offset is so it comes from inside the character
		fire_shotgun(Player.x + 4, Player.y + 4, Player.aim)
		Shotgun.shoot_cooldown = 50
	end
end

function _init()
	-- init track mouse pos
	poke(0x5f2d, 1)
	--randomItemSpawnInRoom(Main_Room, 34, 10)
end

function _update60()
	Game.mx = stat(32)
	Game.my = stat(33)
	Game.mb = stat(34)
	Game.cam_x = Player.x - 64
	Game.cam_y = Player.y - 64

	local world_mx = Game.mx + Game.cam_x
	local world_my = Game.my + Game.cam_y

	local px = Player.x
	local py = Player.y

	local dx = world_mx - px
	local dy = world_my - py

	Player.aim = atan2(dx, dy)

	if Shotgun.shoot_cooldown > 0 then
		Shotgun.shoot_cooldown -= 1
	end

	for p in all(Shotgun.pellets) do
		p.x += p.dx
		p.y += p.dy
		p.life -= 1
		if p.life <= 0 then
			del(Shotgun.pellets, p)
		end
	end

	local seconds = time()
	Game.current_time = max(0, Game.start_time - flr(seconds))
	handle_keys()
	detectItemOnPlayer()
	checkCurrentRoomPortals()
end

function renderTopHud()
	local hud = Game.current_time
	spr(34, 45, -2)
	print(Player.coins, 40, 0, 12)
	print(hud, 0, 0, 7)
end

function _draw()
	cls()
	camera(Player.x - 64, Player.y - 64)
	map()
	for p in all(Shotgun.pellets) do
		pset(p.x, p.y, 8)
	end
	renderRoomItems(Game.current_room)
	spr(Player.sprite_num, Player.x, Player.y)
	-- reset camera for screen-space HUD and crosshair
	camera()
	renderTopHud()
	line(Game.mx - 4, Game.my, Game.mx + 4, Game.my, 7)
	line(Game.mx, Game.my - 4, Game.mx, Game.my + 4, 7)
	


	-- DEBUG GUS CHUNG
	if touching_portal then
		print("PORTAL TOUCHED!")
	end

end
