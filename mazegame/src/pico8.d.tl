--[[
  pico8.d.tl -- the typed global environment for the mazegame cart.

  This is a Teal DECLARATION file (.d.tl): it defines types and the signatures
  of every global shared across the cart's files, but contains no runtime code.
  It is passed to the compiler via --global-env-def (see build.sh / tlconfig.lua)
  so every src/*.tl file type-checks against the same shared globals -- which is
  how we model PICO-8's flat, #include-stitched namespace in Teal.

  Two halves:
    1. PICO-8 builtins used by the cart (add typed signatures as you use more).
    2. The game's own globals: record types, singleton state, and functions.
--]]

-----------------------------------------------------------------------------
-- 1. PICO-8 builtins
-----------------------------------------------------------------------------

-- collections (generic, so element types flow through them)
global add: function<T>(t: {T}, v: T): T
global del: function<T>(t: {T}, v: T): T
global all: function<T>(t: {T}): (function(): T)
global foreach: function<T>(t: {T}, f: function(T))

-- math
global abs: function(x: number): number
global flr: function(x: number): number
global max: function(a: number, b: number): number
global min: function(a: number, b: number): number
global mid: function(a: number, b: number, c: number): number
global sqrt: function(x: number): number
global cos: function(x: number): number
global sin: function(x: number): number
global atan2: function(dx: number, dy: number): number
global rnd: function(x?: number): number

-- graphics
global cls: function(c?: number)
global camera: function(x?: number, y?: number)
global clip: function(x?: number, y?: number, w?: number, h?: number)
global pset: function(x: number, y: number, c?: number)
global line: function(x0: number, y0: number, x1: number, y1: number, c?: number)
global rectfill: function(x0: number, y0: number, x1: number, y1: number, c?: number)
-- print is already a builtin global in Teal's standard library, so we don't
-- redeclare it; PICO-8's extra args (x, y, c) still pass through its ...: any.
global pal: function(c0?: number, c1?: number, p?: number)
global spr: function(n: number, x: number, y: number, w?: number, h?: number, flipx?: boolean, flipy?: boolean)
global map: function(celx: number, cely: number, sx: number, sy: number, celw: number, celh: number, layer?: number)
global mget: function(x: number, y: number): number
-- fget(n, f) returns the boolean state of flag f -- the only form this cart uses.
global fget: function(n: number, f: number): boolean

-- audio / system / input
global music: function(n: number, fade?: number, mask?: number)
global poke: function(addr: number, val: number)
global time: function(): number
-- stat() is polymorphic in PICO-8; this cart only reads numeric stats
-- (mouse x/y/button) and treats key-state stats as truthy in `if`.
global stat: function(n: number, b?: number): number

-----------------------------------------------------------------------------
-- 2a. Spawned / structural record types
-----------------------------------------------------------------------------

global record Zombie
   xPos: number
   yPos: number
   health: integer
   speed: number
   is_shot: boolean
   shot_effect_time: integer  -- frames of hit-flash added per pellet hit
   shot_time_left: integer    -- frames of hit-flash remaining
end

global record Pellet
   x: number
   y: number
   dx: number
   dy: number
   life: integer
end

global record ZombieSpawn
   tileX: integer
   tileY: integer
end

global record RoomItem
   id: integer  -- sprite index, compared against Assets.*
   x: number
   y: number
end

global record Exit
   x: integer
   y: integer
   dest: Room
   destX: number
   destY: number
   destDirection: integer
end

global record Room
   mapCol: integer
   mapRow: integer
   tileW: integer
   tileH: integer
   exits: {Exit}
   items: {RoomItem}
   zombies: {Zombie}
   zombieSpawns: {ZombieSpawn}  -- absent in rooms with no enemies
end

-----------------------------------------------------------------------------
-- 2b. Singleton state. The record type is suffixed (e.g. AssetsT) so the
--     plain name (Assets) can be the global value the game code uses.
-----------------------------------------------------------------------------

global record AssetsT
   playerDownSprite: integer
   playerUpSprite: integer
   playerRightSprite: integer
   playerLeftSprite: integer
   zombieDLeftSprite: integer
   zombieDRightSprite: integer
   zombieURightSprite: integer
   zombieULeftSprite: integer
   gunSprite: integer
   swordSprite: integer
   ammoSprite: integer
   coinSprite: integer
   brokenClockSprite: integer
   chestSprite: integer
   ritualSymbolSprites: {integer}
   pageSprites: {integer}
   windowNormalEmpty: integer
   windowBrokenEmpty: integer
   windowNormalZombie: integer
   windowBrokenZombie: integer
   reloadBar: integer
end
global Assets: AssetsT

global record SoundsT
   coinPickup: integer
   shotgunBlast: integer
end
global Sounds: SoundsT

global record FlagsT
   solid: integer
end
global Flags: FlagsT

global record DisplayStateT
   screenW: integer
   screenH: integer
   hudH: integer
   viewW: integer
   viewH: integer
   camX: number
   camY: number
end
global DisplayState: DisplayStateT

global record GameStateT
   startTime: number
   currentTime: number
   currentRoom: Room
   mx: number
   my: number
   mb: number
   mouseSens: number
   zombies: {Zombie}
   locationTransitionScreen: boolean
end
global GameState: GameStateT

global record PlayerStateT
   spriteNum: integer
   x: number
   y: number
   aim: number
   ammo: integer
   health: integer
   coins: integer
end
global PlayerState: PlayerStateT

global record ShotgunStateT
   pellets: {Pellet}
   shootCooldown: integer
   maxRounds: integer
   currentRounds: integer
   reloading: boolean
   reloadDuration: integer
   reloadTime: integer
   reloadHoldTime: integer
   maxReloadHoldTime: integer
end
global ShotgunState: ShotgunStateT

-- rooms are concrete global values, declared in rooms.tl
global MainRoom: Room
global StraightHorizontalHallway_toMarket: Room
global touchingExit: boolean

-----------------------------------------------------------------------------
-- 2c. Global functions (defined in src/*.tl; signatures repeated there).
-----------------------------------------------------------------------------

global tileToPx: function(t: number): number

global isSolid: function(x: number, y: number): boolean
global detectItemOnPlayer: function()
global updatePlayer: function()
global renderPlayer: function()
global godMode: function()
global updateMouse: function()
global renderCrosshair: function()

global canShootShotgun: function(): boolean
global makePellet: function(x: number, y: number, a: number): Pellet
global fireShotgun: function(px: number, py: number, aimAngle: number)
global updateGun: function()
global renderGun: function()
global getPelletCollision: function(spriteX: number, spriteY: number): boolean

global makeZombie: function(xPos: number, yPos: number): Zombie
global updateZombiePosition: function(zombie: Zombie)
global updateZombies: function(ZombiesTable: {Zombie})
global renderZombies: function(ZombiesTable: {Zombie})

global updateTimer: function()
global renderHud: function()

global initRoom: function(room: Room)
global updateExits: function()
global executeLocationTransition: function(exit: Exit)
global renderRoomItems: function(room: Room)
global updateCamera: function()
global renderCurrentRoom: function()
