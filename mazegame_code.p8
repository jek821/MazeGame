pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
test_room = {
	-- * 8 because each "pixel" is a sprite which is actually 8 pixels...
	top_leftx = 1 * 8,
	top_lefty = 1 * 8,
	bottom_rightx = 16 * 8,
	bottom_righty = 12 * 8,
	items = {
		-- { 34, x = 0, y = 0 }
	}
}

start_time = 100

pellets = {}

player = {
	sprite_num = 7,
	x = 64,
	y = 64,
	aim = 0,
	shoot_cooldown = 0,
	ammo = 10,
	mx = 0,
	my = 0,
	current_room = test_room,
	coins = 0,
	cam_x = 0,
	cam_y = 0
}

--spawn item in room (random places)
function spawnItemArroundRoom(room, itemId, numItems)
	if itemId == 34 then
		for i = 0, numItems do
			rnd_x = flr(rnd(room.bottom_rightx - room.top_leftx) + room.top_leftx)
			rnd_y = flr(rnd(room.bottom_righty - room.top_lefty) + room.top_lefty)
			add(
				room.items, { id = itemId, x = rnd_x, y = rnd_y }
			)
		end
	end
end

-- render room items
function renderRoomItems(room)
	for item in all(room.items) do
		spr(item.id, item.x, item.y)
	end
end

function detectItemOnPlayer()
	for item in all(player.current_room.items) do
		-- need to check range of pixels
		if abs(item.x - player.x) < 8 and abs(item.y - player.y) < 8 then
			if item.id == 34 then
				music(0)
				del(player.current_room.items, item)
				player.coins += 1
			end
		end
	end
end

function handle_keys()
	-- !! is solid detection values look arbitrary but they are all different because of different player positions for each player sprite... !!
	-- Loop through all 256 key codes
	for i = 0, 255 do
		-- Check if the key is currently held down
		if stat(28, i) then
			-- W
			if i == 26 then
				player.sprite_num = 23
				if not is_solid(player.x, player.y - 1) then
					player.y -= 1
				end
			end
			-- d
			if i == 7 then
				player.sprite_num = 8
				if not is_solid(player.x + 7, player.y) then
					player.x += 1
				end
			end
			-- s
			if i == 22 then
				player.sprite_num = 7
				if not is_solid(player.x, player.y + 8) then
					player.y += 1
				end
			end
			-- a
			if i == 4 then
				player.sprite_num = 24
				if not is_solid(player.x - 1, player.y) then
					player.x -= 1
				end
			end
		end
	end
	-- z
	if mb == 1 and player.shoot_cooldown == 0 then
		-- 4 offset is so it comes from inside the character
		fire_shotgun(player.x + 4, player.y + 4, player.aim)
		player.shoot_cooldown = 50
	end
end

function is_solid(x, y)
	-- convert pixel position to map tile position
	local tile_x = flr(x / 8)
	local tile_y = flr(y / 8)
	local tile = mget(tile_x, tile_y)
	return fget(tile, 1)
	-- flag 0 is the first flag (what pico-8 calls "flag 1" in the editor)
end

function fire_shotgun(px, py, aim_angle)
	music(1)
	local pellet_count = 8
	local spread = 0.10
	for i = 1, pellet_count do
		local offset = rnd(spread) - spread / 2
		local a = aim_angle + offset
		add(
			pellets, {
				x = px,
				y = py,
				dx = cos(a) * 3,
				dy = sin(a) * 3,
				life = 20
			}
		)
	end
end

function _init()
	-- init track mouse pos
	poke(0x5f2d, 1)
	spawnItemArroundRoom(test_room, 34, 10)
end

function _update60()
	-- get_mouse_values
	mx = stat(32)
	-- get x
	my = stat(33)
	-- get y
	mb = stat(34)
	player.cam_x = player.x - 64
	player.cam_y = player.y - 64

	local world_mx = mx + player.cam_x
	local world_my = my + player.cam_y

	local px = player.x
	local py = player.y

	local dx = world_mx - px
	local dy = world_my - py

	player.aim = atan2(dx, dy)

	if player.shoot_cooldown > 0 then
		player.shoot_cooldown -= 1
	end


	for p in all(pellets) do
		p.x += p.dx
		p.y += p.dy
		p.life -= 1
		if p.life <= 0 then
			del(pellets, p)
		end
	end

	seconds = time()
	current_time = max(0, start_time - flr(seconds))
	handle_keys()
	detectItemOnPlayer()
end

function renderTopHud()
	local hud = current_time
	spr(34, 45, -2)
	print(player.coins, 40, 0, 12)
	print(hud, 0, 0, 7)
end

function _draw()
	cls()
	camera(player.x - 64, player.y - 64)
	map()
	for p in all(pellets) do
		pset(p.x, p.y, 8)
	end
	renderRoomItems(test_room)
	spr(player.sprite_num, player.x, player.y)
	-- reset camera for screen-space HUD and crosshair
	camera()
	renderTopHud()
	line(mx - 4, my, mx + 4, my, 7)
	line(mx, my - 4, mx, my + 4, 7)
end
