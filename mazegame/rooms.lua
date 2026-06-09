Main_Component = {
	map_col = 0,
	map_row = 0,
	tile_w = 18,
	tile_h = 14,
	exits   = {},
	items   = {}
}

Test_Component = {
	map_col = 0,
	map_row = 15,
	tile_w = 16,
	tile_h = 7,
	exits   = {},
	items   = {}
}

add(Main_Component.exits, { x = 2, y = 5, dest = Test_Component, dest_x = tile_to_px(1 - Test_Component.map_col), dest_y = tile_to_px(19 - Test_Component.map_row), dest_direction = Assets.player_right_sprite})
add(Test_Component.exits, { x = 103, y = 20, dest = Main_Component, dest_x = tile_to_px(2), dest_y = tile_to_px(4) })

function update_exits()
	touching_exit = false
	for e in all(Game.current_map_component.exits) do
		local ex = tile_to_px(e.x)
		local ey = tile_to_px(e.y)
		if abs(ex - Player.x) < 8 and abs(ey - Player.y) < 8 then
			touching_exit = true
			Game.current_map_component = e.dest
			Player.x = e.dest_x
			Player.y = e.dest_y
			Player.sprite_num = e.dest_direction
			return
		end
	end
end

function render_component_items(comp)
	for item in all(comp.items) do
		spr(item.id, item.x, item.y)
	end
end
