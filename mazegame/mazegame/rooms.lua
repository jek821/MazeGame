touchingExit = false

MainRoom = {
	mapCol = 0,
	mapRow = 0,
	tileW = 18,
	tileH = 14,
	exits = {},
	items = {}
}

StraightHorizontalHallway_toMarket = {
	mapCol = 0,
	mapRow = 15,
	tileW = 16,
	tileH = 7,
	exits = {},
	items = {},
	zombieSpawns = {
		{ tileX = 10, tileY = 19 },
		{ tileX = 12, tileY = 17 },
	},
	zombies = {}
}

add(MainRoom.exits,
	{
		x = 2,
		y = 5,
		dest = StraightHorizontalHallway_toMarket,
		destX = tileToPx(1 - StraightHorizontalHallway_toMarket.mapCol),
		destY =
			tileToPx(19 - StraightHorizontalHallway_toMarket.mapRow),
		destDirection = Assets.playerRightSprite
	})


add(StraightHorizontalHallway_toMarket.exits,
	{ x = 103, y = 20, dest = MainRoom, destX = tileToPx(2), destY = tileToPx(4) })


function initRoom(room)
	room.zombies = {}
	for spawn in all(room.zombieSpawns) do
		add(room.zombies, {
			xPos = (spawn.tileX - room.mapCol) * 8,
			yPos = (spawn.tileY - room.mapRow) * 8,
			health = 300,
			speed = 0.5,
			is_shot = false,
			shot_effect_time = 30,
			shot_time_left = 0
		})
	end
end

function updateExits()
	touchingExit = false
	for e in all(GameState.currentRoom.exits) do
		local ex = tileToPx(e.x)
		local ey = tileToPx(e.y)
		if abs(ex - PlayerState.x) < 8 and abs(ey - PlayerState.y) < 8 then
			touchingExit = true
			executeLocationTransition(e)
			return
		end
	end
end

function executeLocationTransition(exit)
	GameState.locationTransitionScreen = true
	-- Do animation on original location
	--startTransition()
	GameState.currentRoom = exit.dest
	initRoom(GameState.currentRoom)
	PlayerState.x = exit.destX
	PlayerState.y = exit.destY
	PlayerState.spriteNum = exit.destDirection
	-- Do animation on new location
	-- startTransition()
	GameState.locationTransitionScreen = false
end

function renderRoomItems(room)
	for item in all(room.items) do
		spr(item.id, item.x, item.y)
	end
end

function updateCamera()
	local room = GameState.currentRoom
	-- Keep player centered on screen, but stop scrolling before the room edge.
	-- PlayerState.x - 64 puts player in the middle of the 128px screen.
	-- room.tileW * 8 - DisplayState.viewW is how many pixels the camera can scroll before hitting the right edge.
	-- max(0, ...) handles rooms narrower than the screen -- the scroll range would be negative without it:
	DisplayState.camX = mid(0, PlayerState.x - 64, max(0, room.tileW * 8 - DisplayState.viewW))
	DisplayState.camY = mid(0, PlayerState.y - flr(DisplayState.viewH / 2), max(0, room.tileH * 8 - DisplayState.viewH))
end

function renderCurrentRoom()
	local room = GameState.currentRoom
	-- Draw room.tileW x room.tileH tiles starting at map cell (room.mapCol, room.mapRow) at world position (0, 0):
	map(room.mapCol, room.mapRow, 0, 0, room.tileW, room.tileH)
end
