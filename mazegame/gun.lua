Shotgun = {
	pellets = {},
	shoot_cooldown = 0,
	max_rounds = 6,
	current_rounds = 6,
	reloading = false,
	reload_duration = 30,
	reload_time = 0
}

function can_shoot_shotgun()
	return Shotgun.shoot_cooldown == 0
		and not Shotgun.reloading
		and Shotgun.current_rounds > 0
end

function fire_shotgun(px, py, aim_angle)
	music(Sounds.shotgun_blast)
	Shotgun.current_rounds -= 1
	local spread = 0.10
	for i = 1, 8 do
		local a = aim_angle + rnd(spread) - spread / 2
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

function update_gun()
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
	if Shotgun.current_rounds == 0 and not Shotgun.reloading then
		Shotgun.reloading = true
	end
	if Shotgun.reloading then
		if Shotgun.current_rounds == Shotgun.max_rounds then
			Shotgun.reloading = false
		else
			Shotgun.reload_time += 1
			if Shotgun.reload_time == Shotgun.reload_duration then
				Shotgun.current_rounds += 1
				Shotgun.reload_time = 0
			end
		end
	end
end

function render_gun()
	for p in all(Shotgun.pellets) do
		pset(p.x, p.y, 8)
	end
	if Shotgun.reloading then
		spr(53, Player.x + 4, Player.y)
		for i = 1, Shotgun.current_rounds, 1 do
			pset(Player.x + 8, Player.y + (7 - i), 8)
		end
	end
end
