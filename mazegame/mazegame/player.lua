PlayerState = {
	spriteNum = Assets.playerDownSprite,
	x = 68,
	y = 52,
	aim = 0,
	ammo = 10,
	health = 100,
	coins = 0
}

function isSolid(x, y)
	local mapX = flr(x / 8) + GameState.currentRoom.mapCol
	local mapY = flr(y / 8) + GameState.currentRoom.mapRow
	return fget(mget(mapX, mapY), Flags.solid)
end

function detectItemOnPlayer()
	for item in all(GameState.currentRoom.items) do
		if abs(item.x - PlayerState.x) < 8 and abs(item.y - PlayerState.y) < 8 then
			if item.id == Assets.coinSprite then
				music(Sounds.coinPickup)
				del(GameState.currentRoom.items, item)
				PlayerState.coins += 1
			end
		end
	end
end

function updatePlayer()
	-- Convert mouse screen position to world position using camera offset:
	local aimX = GameState.mx + DisplayState.camX
	local aimY = GameState.my + DisplayState.camY - DisplayState.hudH
	PlayerState.aim = atan2(aimX - PlayerState.x, aimY - PlayerState.y)

	-- Key codes differ per direction because collision offsets differ per sprite:
	for i = 0, 255 do
		if stat(28, i) then
			if i == 26 then
				-- w
				PlayerState.spriteNum = Assets.playerUpSprite
				if not isSolid(PlayerState.x, PlayerState.y - 1) and not isSolid(PlayerState.x + 7, PlayerState.y - 1) then
					PlayerState.y -= 1
				end
			end
			if i == 7 then
				-- d
				PlayerState.spriteNum = Assets.playerRightSprite
				if not isSolid(PlayerState.x + 8, PlayerState.y) and not isSolid(PlayerState.x + 8, PlayerState.y + 7) then
					PlayerState.x += 1
				end
			end
			if i == 22 then
				-- s
				PlayerState.spriteNum = Assets.playerDownSprite
				if not isSolid(PlayerState.x, PlayerState.y + 8) and not isSolid(PlayerState.x + 7, PlayerState.y + 8) then
					PlayerState.y += 1
				end
			end
			if i == 4 then
				-- a
				PlayerState.spriteNum = Assets.playerLeftSprite
				if not isSolid(PlayerState.x - 1, PlayerState.y) and not isSolid(PlayerState.x - 1, PlayerState.y + 7) then
					PlayerState.x -= 1
				end
			end
		end
	end

	if GameState.mb == 1 and canShootShotgun() then
		fireShotgun(PlayerState.x + 4, PlayerState.y + 4, PlayerState.aim)
		ShotgunState.shootCooldown = 50
	end

	detectItemOnPlayer()
end

function renderPlayer()
	spr(PlayerState.spriteNum, PlayerState.x, PlayerState.y)
end

function godMode()
	ShotgunState.currentRounds = 1000
	PlayerState.health = 100000
end

function updateMouse()
	GameState.mx = mid(0, 64 + (stat(32) - 64) * GameState.mouseSens, 127)
	GameState.my = mid(0, 64 + (stat(33) - 64) * GameState.mouseSens, 127)
	GameState.mb = stat(34)
end

function renderCrosshair()
	line(GameState.mx - 4, GameState.my, GameState.mx + 4, GameState.my, 7)
	line(GameState.mx, GameState.my - 4, GameState.mx, GameState.my + 4, 7)
end
