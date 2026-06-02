function tile_to_px(t)
	return t * 8
end

Main_Component = {
	map_col = 1,
	map_row = 1,
	draw_x  = 0,
	draw_y  = 0,
	pixel_w = 120,
	pixel_h = 88,
	exits   = {},
	items   = {},
	portals = {}
}

Test_Component = {
	map_col = 103,
	map_row = 12,
	draw_x  = 0,
	draw_y  = 0,
	pixel_w = 184,
	pixel_h = 144,
	exits   = {},
	items   = {},
	portals = {}
}

horizontal_open_open_hallway = {
	top_leftx = 0,
	top_lefty = 15,
	bottom_rightx = 15,
	bottom_righty = 21,
	-- r_dest =
	-- l_dest =
}

Portals = {
	to_test_maze = { destination = Test_Component, dest_x = 103, dest_y = 20, frame = 1, timer = 0 },
	to_main_maze = { destination = Main_Component, dest_x = 2,   dest_y = 5,  frame = 1, timer = 0 },
}

add(Main_Component.portals, { top = {x=2, y=4}, bottom = {x=2, y=5}, ref = Portals.to_test_maze })
add(Test_Component.portals, { top = {x=103, y=20}, bottom = {x=103, y=21}, ref = Portals.to_main_maze })

function update_component_portals(comp)
	for p in all(comp.portals) do
		p.ref.timer += 1
		if p.ref.timer >= 15 then
			p.ref.timer = 0
			p.ref.frame = (p.ref.frame % #PortalStates) + 1
		end
	end
end

function render_component_portals(comp)
	for p in all(comp.portals) do
		local sprite = PortalStates[p.ref.frame]
		spr(sprite, tile_to_px(p.top.x),    tile_to_px(p.top.y))
		spr(sprite, tile_to_px(p.bottom.x), tile_to_px(p.bottom.y))
	end
end

function check_current_component_portals()
	touching_portal = false
	for p in all(Game.current_map_component.portals) do
		local tx = tile_to_px(p.top.x)
		local ty = tile_to_px(p.top.y)
		local bx = tile_to_px(p.bottom.x)
		local by = tile_to_px(p.bottom.y)
		if (abs(tx - Player.x) < 8 and abs(ty - Player.y) < 8) or
		   (abs(bx - Player.x) < 8 and abs(by - Player.y) < 8) then
			touching_portal = true
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
