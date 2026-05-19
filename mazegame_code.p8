pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
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
	start_time = 100
	pellets = {}
	player = {
		sprite_num = 7,
		x = 64,
		y = 64,
		aim = 0,
		shoot_cooldown = 0,
		ammo = 10
	}
end

function _update60()
	if player.shoot_cooldown > 0 then
		player.shoot_cooldown -= 1
	end
	-- z
	if btn(4) and player.shoot_cooldown == 0 then
		fire_shotgun(player.x + 6, player.y + 4, player.aim)
		player.shoot_cooldown = 50
	end
	-- up
	if btn(2) then
		if not is_solid(player.x, player.y - 1)
				and not is_solid(player.x + 7, player.y - 1) then
			player.y -= 1
			player.sprite_num = 23
			player.aim = 0.25
		end
	end
	-- right
	if btn(1) then
		player.x += 1
		player.sprite_num = 8
		player.aim = 0
	end
	-- down
	if btn(3) then
		player.y += 1
		player.sprite_num = 7
		player.aim = 0.75
	end
	-- left
	if btn(0) then
		player.x -= 1
		player.sprite_num = 24
		player.aim = 0.5
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
end

function _draw()
	cls()
	camera(player.x - 64, player.y - 64)
	map()
	for p in all(pellets) do
		pset(p.x, p.y, 8)
	end
	spr(player.sprite_num, player.x, player.y)
	print(current_time, 0, 0, 7)
end
