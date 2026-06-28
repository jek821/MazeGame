--[[
  types.lua -- LuaCATS type definitions for the Lua language server (lua_ls).

  This file is PURE ANNOTATIONS. PICO-8 never runs it: it is intentionally
  left out of the #include list in mazegame.p8, so it adds ZERO tokens/chars
  to the cart. Its only job is to give the editor a gradual type system --
  autocomplete, hover docs, and a warning when a field is misspelled or an
  argument has the wrong type.

  Convention:
    number   -- continuous values (world positions, velocities, timers)
    integer  -- whole-number indices / counts (sprite ids, tiles, ammo)
    foo?     -- optional field (may be absent / nil on some instances)
--]]

-----------------------------------------------------------------------------
-- Spawned instances. Created in loops or make*() factories, so their shape
-- is declared here by hand rather than inferred from a single literal.
-----------------------------------------------------------------------------

---A single enemy. Built by makeZombie(); lives in Room.zombies.
---@class Zombie
---@field xPos number
---@field yPos number
---@field health integer
---@field speed number
---@field is_shot boolean
---@field shot_effect_time integer  -- frames of hit-flash added per pellet hit
---@field shot_time_left integer    -- frames of hit-flash remaining

---A shotgun pellet. Built by makePellet(); lives in ShotgunState.pellets.
---@class Pellet
---@field x number
---@field y number
---@field dx number
---@field dy number
---@field life integer  -- frames before the pellet despawns

---A spawn point for an enemy, expressed in map-tile coordinates.
---@class ZombieSpawn
---@field tileX integer
---@field tileY integer

---A pickup drawn inside a room (coin, ammo, ...).
---@class RoomItem
---@field id integer  -- sprite index, compared against Assets.*
---@field x number
---@field y number

---A doorway linking two rooms.
---@class Exit
---@field x integer             -- exit tile x (room-local)
---@field y integer             -- exit tile y (room-local)
---@field dest Room             -- room this exit leads to
---@field destX number          -- player world-x on arrival
---@field destY number          -- player world-y on arrival
---@field destDirection integer -- facing sprite the player arrives with

---A self-contained area of the map.
---@class Room
---@field mapCol integer        -- top-left map-cell column
---@field mapRow integer        -- top-left map-cell row
---@field tileW integer         -- room width in tiles
---@field tileH integer         -- room height in tiles
---@field exits Exit[]
---@field items RoomItem[]
---@field zombies Zombie[]
---@field zombieSpawns? ZombieSpawn[]  -- absent in rooms with no enemies
