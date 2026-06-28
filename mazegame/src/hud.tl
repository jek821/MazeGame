global function updateTimer()
   GameState.currentTime = max(0, GameState.startTime - flr(time()))
end

global function renderHud()
   spr(Assets.coinSprite, 20, -2)
   print(PlayerState.coins, 28, 0, 11)
   print(GameState.currentTime, 0, 0, 7)
   spr(Assets.ammoSprite, 42, -2)
   print(ShotgunState.currentRounds, 50, 0, 11)
end
