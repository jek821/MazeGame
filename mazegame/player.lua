touching_exit = false
debug_i = -1

Player = {
	sprite_num = Assets.player_down_sprite,
	x = 68,
	y = 52,
	aim = 0,
	ammo = 10,
	health = 100,
	coins = 0
}

function is_solid(x, y)
	local map_x = flr(x / 8) + Game.current_map_component.map_col
	local map_y = flr(y / 8) + Game.current_map_component.map_row
	return fget(mget(map_x, map_y), flags.solid)
end

function detect_item_on_player()
	for item in all(Game.current_map_component.items) do
		if abs(item.x - Player.x) < 8 and abs(item.y - Player.y) < 8 then
			if item.id == Assets.coin_sprite then
				music(Sounds.coin_pickup)
				del(Game.current_map_component.items, item)
				Player.coins += 1
			end
		end
	end
end

function update_player()
	-- Convert mouse screen position to world position using camera offset:
	local aim_x = Game.mx + Display.cam_x
	local aim_y = Game.my + Display.cam_y - Display.hud_h
	Player.aim = atan2(aim_x - Player.x, aim_y - Player.y)

	-- Key codes differ per direction because collision offsets differ per sprite:
	for i = 0, 255 do
		if stat(28, i) then
			if i == 26 then
				-- w
				Player.sprite_num = Assets.player_up_sprite
				if not is_solid(Player.x, Player.y - 1) and not is_solid(Player.x + 7, Player.y - 1) then
					Player.y -= 1
				end
			end
			if i == 7 then
				-- d
				Player.sprite_num = Assets.player_right_sprite
				if not is_solid(Player.x + 8, Player.y) and not is_solid(Player.x + 8, Player.y + 7) then
					Player.x += 1
				end
			end
			if i == 22 then
				-- s
				Player.sprite_num = Assets.player_down_sprite
				if not is_solid(Player.x, Player.y + 8) and not is_solid(Player.x + 7, Player.y + 8) then
					Player.y += 1
				end
			end
			if i == 4 then
				-- a
				Player.sprite_num = Assets.player_left_sprite
				if not is_solid(Player.x - 1, Player.y) and not is_solid(Player.x - 1, Player.y + 7) then
					Player.x -= 1
				end
			end
		end
	end

	if Game.mb == 1 and can_shoot_shotgun() then
		fire_shotgun(Player.x + 4, Player.y + 4, Player.aim)
		Shotgun.shoot_cooldown = 50
	end

	detect_item_on_player()
end

function render_player()
	spr(Player.sprite_num, Player.x, Player.y)
end

function god_mode()
	Shotgun.current_rounds = 1000
	Player.health = 100000
end
