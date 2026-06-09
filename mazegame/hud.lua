function update_timer()
	Game.current_time = max(0, Game.start_time - flr(time()))
end

function render_hud()
	spr(Assets.coin_sprite, 20, -2)
	print(Player.coins, 28, 0, 11)
	print(Game.current_time, 0, 0, 7)
	spr(Assets.ammo_sprite, 42, -2)
	print(Shotgun.current_rounds, 50, 0, 11)
end
