--[[
  pico8.lua -- typed stubs for the PICO-8 builtins whose types matter.

  Like types.lua, this file is annotations-only and is NOT #included in the
  cart, so it costs nothing at runtime. PICO-8 provides these functions
  natively; here we give the editor real (generic) signatures so types flow
  THROUGH them. The payoff: `for z in all(zombies) do` infers `z` as Zombie
  automatically when `zombies` is a Zombie[], and `add(pellets, p)` checks
  that `p` is a Pellet -- no manual ---@cast needed.

  The bare PICO-8 builtins that don't carry interesting types (spr, map,
  print, flr, ...) stay declared in .luarc.json's `globals` list.
--]]

---Iterate every value in a sequence. Tolerates nil (yields nothing).
---@generic T
---@param t T[]?
---@return fun(): T
function all(t) end

---Append v to t and return v.
---@generic T
---@param t T[]
---@param v T
---@return T
function add(t, v) end

---Remove the first occurrence of v from t; returns v if it was present.
---@generic T
---@param t T[]
---@param v T
---@return T?
function del(t, v) end

---Call f(v) for every value v in t.
---@generic T
---@param t T[]?
---@param f fun(v: T)
function foreach(t, f) end
