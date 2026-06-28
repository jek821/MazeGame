GameState = {
   startTime = 100,
   currentTime = 0,
   currentRoom = MainRoom,
   mx = 64,    -- cursor x (screen space)
   my = 64,    -- cursor y (screen space)
   mb = 0,
   mouseSens = 1.5,
   zombies = {},
   locationTransitionScreen = false
}

global function _init()
   poke(0x5f2d, 1)
   initRoom(GameState.currentRoom)
   godMode()
end

global function _update60()
   if not GameState.locationTransitionScreen then
      updateMouse()
      updateCamera()
      updatePlayer()
      updateZombies(GameState.currentRoom.zombies)
      updateGun()
      updateTimer()
      updateExits()
   end
end

global function _draw()
   if not GameState.locationTransitionScreen then
      cls()
      -- Shift all drawing by camX/camY so world (0,0) scrolls with the player.
      -- Subtract hudH from camY so world y=0 lands at screen y=10, below the hud:
      camera(DisplayState.camX, DisplayState.camY - DisplayState.hudH)
      -- Prevent drawing over the hud bar at the top of the screen:
      clip(0, DisplayState.hudH, DisplayState.screenW, DisplayState.viewH)

      renderCurrentRoom()
      renderRoomItems(GameState.currentRoom)
      renderZombies(GameState.currentRoom.zombies)
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
