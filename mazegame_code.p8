pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function _init()
 poke(0x5f2d,1)
 player = {
	sprite = 7,
	x_pos = 64,
	y_pos = 64,
}

function player:drawPlayer()
	spr(self.sprite, self.x_pos, self.y_pos)
end
end
	

function _update()
	
end


function _draw()
	cls()
	player:drawPlayer()
end