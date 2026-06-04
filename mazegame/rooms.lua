function tile_to_px(t)
	return t * 8
end

Main_Component = {
	map_col = 0,
	map_row = 0,
	tile_w = 18,
	tile_h = 14,
	exits   = {},
	items   = {}
}

Test_Component = {
	map_col = 103,
	map_row = 12,
	draw_x  = 0,
	draw_y  = 0,
	pixel_w = 184,
	pixel_h = 144,
	exits   = {},
	items   = {}
}

add(Main_Component.exits, { x = 2, y = 4, dest = Test_Component, dest_x = tile_to_px(103), dest_y = tile_to_px(20) })
add(Test_Component.exits, { x = 103, y = 20, dest = Main_Component, dest_x = tile_to_px(2), dest_y = tile_to_px(4) })

function check_current_component_exits()
	touching_exit = false
	for e in all(Game.current_map_component.exits) do
		local ex = tile_to_px(e.x) + Display.map_component_x
		local ey = tile_to_px(e.y) + Display.map_component_y
		if abs(ex - Player.x) < 8 and abs(ey - Player.y) < 8 then
			touching_exit = true
			Game.current_map_component = e.dest
			Player.x = e.dest_x
			Player.y = e.dest_y
			return
		end
	end
end

function render_component_items(comp)
	for item in all(comp.items) do
		spr(item.id, item.x, item.y)
	end
end

function spawn_items_in_component(comp, item_id, count)
	for i = 1, count do
		local x = flr(rnd(comp.pixel_w) + comp.draw_x)
		local y = flr(rnd(comp.pixel_h) + comp.draw_y)
		add(comp.items, {id = item_id, x = x, y = y})
	end
end
