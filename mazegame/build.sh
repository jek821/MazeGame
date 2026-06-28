#!/usr/bin/env bash
# Compile the Teal sources (src/*.tl) into the plain Lua files that
# mazegame.p8 #includes (mazegame/*.lua).
#
# Source of truth is src/*.tl -- DO NOT hand-edit the generated mazegame/*.lua;
# they are overwritten on every build.
#
# Requires the Teal compiler:  luarocks install tl
set -euo pipefail

cd "$(dirname "$0")"

ENV_DEF="src/pico8"
OUT_DIR="mazegame"
# Order mirrors the #include order in mazegame.p8.
MODULES=(constants rooms player gun enemies hud game)

SRCS=()
for m in "${MODULES[@]}"; do SRCS+=("src/$m.tl"); done

# 1. Type-check everything together against the shared global env.
echo "type-checking..."
tl check --global-env-def "$ENV_DEF" "${SRCS[@]}"

# 2. Emit Lua for each module.
echo "generating lua -> $OUT_DIR/"
for m in "${MODULES[@]}"; do
   tl gen --global-env-def "$ENV_DEF" -o "$OUT_DIR/$m.lua" "src/$m.tl"
   echo "  $OUT_DIR/$m.lua"
done

echo "done. open mazegame.p8 in PICO-8 to run."
