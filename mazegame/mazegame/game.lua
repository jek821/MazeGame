GameState = {
	startTime = 100,
	currentTime = 0,
	currentRoom = MainRoom,
	mx = 64,        -- virtual cursor x, starts at screen center
	my = 64,        -- virtual cursor y, starts at screen center
	mb = 0,
	_rawMx = 0,    -- last raw stat(32) value, used to compute delta
	_rawMy = 0,    -- last raw stat(33) value, used to compute delta
	mouseSens = 2, -- multiply delta by this each frame
	zombies = {},
	locationTransitionScreen = false
}

function _init()
	poke(0x5f2d, 1)
end

function _update60()
	if not GameState.locationTransitionScreen then

	updateMouse()
	updateCamera()
	updatePlayer()
	updateGun()
	updateTimer()
	updateExits()
	end
end

function _draw()
	if not GameState.locationTransitionScreen then
	cls()
	-- Shift all drawing by camX/camY so world position (0,0) scrolls with the player.
	-- Subtract hudH from camY so world y=0 lands at screen y=10, below the hud:
	camera(DisplayState.camX, DisplayState.camY - DisplayState.hudH)
	-- Prevent drawing over the hud bar at the top of the screen:
	clip(0, DisplayState.hudH, DisplayState.screenW, DisplayState.viewH)

	renderCurrentRoom()
	renderRoomItems(GameState.currentRoom)
	renderPlayer()
	renderGun()

	clip()
	camera()

	renderHud()
	renderCrosshair()

	if touchingExit then
		print("EXIT TOUCHED!")
	end
end
end
