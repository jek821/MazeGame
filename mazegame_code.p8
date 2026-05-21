pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function handle_keys()
	-- Loop through all 256 key codes
	for i = 0, 255 do
		-- Check if the key is currently held down
		if stat(28, i) then
			-- W
			if i == 26 then
				if not is_solid(player.x, player.y - 1)
						and not is_solid(player.x + 7, player.y - 1) then
					player.y -= 1
					player.sprite_num = 23
				end
			end
			-- d
			if i == 7 then
				player.x += 1
				player.sprite_num = 8
			end
			-- s
			if i == 22 then
				player.y += 1
				player.sprite_num = 7
			end
			-- a
			if i == 4 then
				player.x -= 1
				player.sprite_num = 24
			end
		end
	end
	-- z
	if mb == 1 and player.shoot_cooldown == 0 then
		fire_shotgun(player.x, player.y, player.aim)
		player.shoot_cooldown = 50
	end
end

function is_solid(x, y)
	-- convert pixel position to map tile position
	local mx = flr(x / 8)
	local my = flr(y / 8)
	local tile = mget(mx, my)
	return fget(tile, 1)
	-- flag 0 is the first flag (what pico-8 calls "flag 1" in the editor)
end

pellets = {}
function fire_shotgun(px, py, aim_angle)
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
		my = 0
	}
end

function _update60()
	-- get_mouse_values
	mx = stat(32)
	-- get x
	my = stat(33)
	-- get y
	mb = stat(34)
	local cam_x = player.x - 64
	local cam_y = player.y - 64

	local world_mx = mx + cam_x
	local world_my = my + cam_y

	local px = player.x + 4
	local py = player.y + 4

	local dx = world_mx - px
	local dy = world_my - py

	player.aim = atan2(dx, dy)

	if player.shoot_cooldown > 0 then
		player.shoot_cooldown -= 1
	end

	handle_keys()

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
end

function _draw()
	cls()
	camera(player.x - 64, player.y - 64)
	map()
	for p in all(pellets) do
		pset(p.x, p.y, 8)
	end
	spr(player.sprite_num, player.x, player.y)
	-- reset camera for screen-space HUD and crosshair
	camera()
	print(current_time, 0, 0, 7)
	line(mx - 4, my, mx + 4, my, 7)
	line(mx, my - 4, mx, my + 4, 7)
	handle_keys()
end
