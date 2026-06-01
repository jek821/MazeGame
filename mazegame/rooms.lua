function tile_to_px(t)
	return t * 8
end

-- rooms defined first so Portals can reference them
Test_Room = {
	top_leftx    = 103 * 8,
	top_lefty    = 12 * 8,
	bottom_rightx = 126 * 8,
	bottom_righty = 30 * 8,
	items   = {},
	portals = {}
}

Main_Room = {
	top_leftx    = 1 * 8,
	top_lefty    = 1 * 8,
	bottom_rightx = 16 * 8,
	bottom_righty = 12 * 8,
	items   = {},
	portals = {}
}

-- portals defined after rooms to avoid nil references
-- dest_x/dest_y are tile coordinates for where the player spawns on arrival
Portals = {
	to_test_maze = { destination = Test_Room, dest_x = 103, dest_y = 20, frame = 1, timer = 0 },
	to_main_maze = { destination = Main_Room, dest_x = 2,   dest_y = 5,  frame = 1, timer = 0 },
}

-- room portal entries: tile positions of top and bottom portal halves
add(Main_Room.portals, { top = {x=2, y=4}, bottom = {x=2, y=5}, ref = Portals.to_test_maze })
add(Test_Room.portals, { top = {x=103, y=20}, bottom = {x=103, y=21}, ref = Portals.to_main_maze })

function update_room_portals(room)
	for p in all(room.portals) do
		p.ref.timer += 1
		if p.ref.timer >= 15 then
			p.ref.timer = 0
			p.ref.frame = (p.ref.frame % #PortalStates) + 1
		end
	end
end

function render_room_portals(room)
	for p in all(room.portals) do
		local sprite = PortalStates[p.ref.frame]
		spr(sprite, tile_to_px(p.top.x),    tile_to_px(p.top.y))
		spr(sprite, tile_to_px(p.bottom.x), tile_to_px(p.bottom.y))
	end
end

function check_current_room_portals()
	touching_portal = false
	for p in all(Game.current_room.portals) do
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

function render_room_items(room)
	for item in all(room.items) do
		spr(item.id, item.x, item.y)
	end
end

function spawn_items_in_room(room, item_id, count)
	for i = 1, count do
		local x = flr(rnd(room.bottom_rightx - room.top_leftx) + room.top_leftx)
		local y = flr(rnd(room.bottom_righty - room.top_lefty) + room.top_lefty)
		add(room.items, {id = item_id, x = x, y = y})
	end
end
