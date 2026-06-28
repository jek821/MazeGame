-- Teal project config for the mazegame cart.
-- Used by the Teal CLI and the VS Code Teal extension for editor diagnostics.
--
-- The cart's source of truth is src/*.tl. The compiler emits plain Lua into
-- mazegame/*.lua, which is what mazegame.p8 #includes. Build with ./build.sh
-- (this Teal version has no `tl build`, so the script drives `tl gen`).
return {
   global_env_def = "src/pico8",
   source_dir = "src",
   build_dir = "mazegame",
   gen_target = "5.4",
   -- PICO-8 ships its own runtime, so don't emit Lua-version compat shims:
   gen_compat = "off",
}
