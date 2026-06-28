# mazegame

A PICO-8 cart written in [Teal](https://github.com/teal-language/tl) — a typed
dialect of Lua — instead of raw PICO-8 Lua, so the whole game is statically
type-checked before it ever runs.

## Layout

```
mazegame.p8        the cart. Its __lua__ section #includes mazegame/*.lua
src/               SOURCE OF TRUTH — typed Teal (*.tl)
  pico8.d.tl       typed declarations for PICO-8 builtins + every shared global
  constants.tl rooms.tl player.tl gun.tl enemies.tl hud.tl game.tl
mazegame/*.lua     GENERATED from src/ by build.sh — do not hand-edit
tlconfig.lua       Teal config (editor + CLI)
build.sh           type-check + compile src/*.tl -> mazegame/*.lua
```

PICO-8 stitches files together with `#include` into one flat global namespace
(there is no `require`). Teal models that with a single declaration file,
`src/pico8.d.tl`, passed to the compiler via `--global-env-def`: it declares the
PICO-8 builtins this cart uses plus the type of every record, singleton, and
function shared across files. Each `src/*.tl` is type-checked against it.

## Build

Requires the Teal compiler:

```sh
luarocks install tl
./build.sh          # type-checks, then regenerates mazegame/*.lua
```

Then open `mazegame.p8` in PICO-8. The generated `*.lua` are committed so the
cart runs without a build step, but **edit the `.tl` files, not the `.lua`** —
every build overwrites them.

## Editor

Install the **Teal** extension (`teal-language.vscode-teal`) for inline type
diagnostics on `.tl` files. It reads `tlconfig.lua` automatically. The
`.luarc.json` files only matter for the generated `.lua`.

## Why the `.d.tl` instead of writing types inline?

Cross-file globals have to be declared somewhere both the definition and every
caller can see. `pico8.d.tl` is that shared header. Function signatures are
repeated in their implementation (`global function foo(x: number)…`) — Teal
checks the two against each other, so they can't silently drift.
