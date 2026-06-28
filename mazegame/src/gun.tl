ShotgunState = {
   pellets = {},
   shootCooldown = 0,
   maxRounds = 6,
   currentRounds = 6,
   reloading = false,
   reloadDuration = 30,
   reloadTime = 0,
   reloadHoldTime = 0,
   maxReloadHoldTime = 30
}

global function canShootShotgun(): boolean
   return ShotgunState.shootCooldown == 0
      and not ShotgunState.reloading
      and ShotgunState.currentRounds > 0
end

-- Build a single pellet travelling along angle a (PICO-8 turns, 0..1).
global function makePellet(x: number, y: number, a: number): Pellet
   return {
      x = x,
      y = y,
      dx = cos(a) * 3,
      dy = sin(a) * 3,
      life = 20
   }
end

global function fireShotgun(px: number, py: number, aimAngle: number)
   music(Sounds.shotgunBlast)
   ShotgunState.currentRounds = ShotgunState.currentRounds - 1
   local spread = 0.10
   for _ = 1, 8 do
      local a = aimAngle + rnd(spread) - spread / 2
      add(ShotgunState.pellets, makePellet(px, py, a))
   end
end

global function updateGun()
   if ShotgunState.shootCooldown > 0 then
      ShotgunState.shootCooldown = ShotgunState.shootCooldown - 1
   end
   for p in all(ShotgunState.pellets) do
      p.x = p.x + p.dx
      p.y = p.y + p.dy
      p.life = p.life - 1
      if p.life <= 0 then
         del(ShotgunState.pellets, p)
      end
   end
   if ShotgunState.currentRounds == 0 and not ShotgunState.reloading then
      ShotgunState.reloading = true
      ShotgunState.reloadHoldTime = 0
   end
   if ShotgunState.reloading then
      if ShotgunState.currentRounds == ShotgunState.maxRounds then
         ShotgunState.reloadHoldTime = ShotgunState.reloadHoldTime + 1
         if ShotgunState.reloadHoldTime >= ShotgunState.maxReloadHoldTime then
            ShotgunState.reloading = false
            ShotgunState.reloadHoldTime = 0
         end
      else
         ShotgunState.reloadTime = ShotgunState.reloadTime + 1
         if ShotgunState.reloadTime == ShotgunState.reloadDuration then
            ShotgunState.currentRounds = ShotgunState.currentRounds + 1
            ShotgunState.reloadTime = 0
         end
      end
   end
end

global function renderGun()
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

global function getPelletCollision(spriteX: number, spriteY: number): boolean
   for pellet in all(ShotgunState.pellets) do
      if abs(pellet.x - spriteX) < 8 and abs(pellet.y - spriteY) < 8 then
         del(ShotgunState.pellets, pellet)
         return true
      end
   end
   return false
end
