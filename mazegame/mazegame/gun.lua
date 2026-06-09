ShotgunState = {
	pellets = {},
	shootCooldown = 0,
	maxRounds = 6,
	currentRounds = 6,
	reloading = false,
	reloadDuration = 30,
	reloadTime = 0
}

function canShootShotgun()
	return ShotgunState.shootCooldown == 0
		and not ShotgunState.reloading
		and ShotgunState.currentRounds > 0
end

function fireShotgun(px, py, aimAngle)
	music(Sounds.shotgunBlast)
	ShotgunState.currentRounds -= 1
	local spread = 0.10
	for i = 1, 8 do
		local a = aimAngle + rnd(spread) - spread / 2
		add(
			ShotgunState.pellets, {
				x = px,
				y = py,
				dx = cos(a) * 3,
				dy = sin(a) * 3,
				life = 20
			}
		)
	end
end

function updateGun()
	if ShotgunState.shootCooldown > 0 then
		ShotgunState.shootCooldown -= 1
	end
	for p in all(ShotgunState.pellets) do
		p.x += p.dx
		p.y += p.dy
		p.life -= 1
		if p.life <= 0 then
			del(ShotgunState.pellets, p)
		end
	end
	if ShotgunState.currentRounds == 0 and not ShotgunState.reloading then
		ShotgunState.reloading = true
	end
	if ShotgunState.reloading then
		if ShotgunState.currentRounds == ShotgunState.maxRounds then
			ShotgunState.reloading = false
		else
			ShotgunState.reloadTime += 1
			if ShotgunState.reloadTime == ShotgunState.reloadDuration then
				ShotgunState.currentRounds += 1
				ShotgunState.reloadTime = 0
			end
		end
	end
end

function renderGun()
	for p in all(ShotgunState.pellets) do
		pset(p.x, p.y, 8)
	end
	if ShotgunState.reloading then
		spr(Assets.reloadBar, PlayerState.x + 4, PlayerState.y)
		for i = 1, ShotgunState.currentRounds, 1 do
			pset(PlayerState.x + 8, PlayerState.y + (7 - i), 8)
		end
	end
end
