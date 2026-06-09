Assets = {
	-- player
	playerDownSprite = 7,
	playerUpSprite = 23,
	playerRightSprite = 8,
	playerLeftSprite = 24,
	-- zombie
	zombieDLeftSprite = 17,
	zombieDRightSprite = 18,
	zombieURightSprite = 19,
	zombieULeftSprite = 20,
	-- items
	gunSprite = 4,
	swordSprite = 5,
	ammoSprite = 3,
	coinSprite = 34,
	brokenClockSprite = 16,
	chestSprite = 50,
	-- decor
	ritualSymbolSprites = { 21, 22, 37, 38 },
	pageSprites = { 32, 33, 48, 49 },
	-- windows
	windowNormalEmpty = 51,
	windowBrokenEmpty = 52,
	windowNormalZombie = 35,
	windowBrokenZombie = 36,
	reloadBar = 53
}

Sounds = {
	coinPickup = 0,
	shotgunBlast = 1
}

Flags = {
	solid = 1
}

function tileToPx(t)
	return t * 8
end

-- Screen dimensions and derived viewport size:
DisplayState = {
	screenW = 128,  -- pico-8 screen width
	screenH = 128,  -- pico-8 screen height
	hudH    = 10,   -- pixels reserved for the top hud bar
	viewW   = 128,  -- playfield width (full screen, no horizontal hud)
	viewH   = 118,  -- playfield height (screenH - hudH)
	camX    = 0,    -- current camera offset x
	camY    = 0     -- current camera offset y
}