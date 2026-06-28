touchingExit = false

MainRoom = {
   mapCol = 0,
   mapRow = 0,
   tileW = 18,
   tileH = 14,
   exits = {},
   items = {},
   zombies = {}
}

StraightHorizontalHallway_toMarket = {
   mapCol = 0,
   mapRow = 15,
   tileW = 16,
   tileH = 7,
   exits = {},
   items = {},
   zombies = {},
   zombieSpawns = {
      { tileX = 10, tileY = 19 },
      { tileX = 12, tileY = 17 },
   }
}

add(MainRoom.exits,
   {
      x = 2,
      y = 5,
      dest = StraightHorizontalHallway_toMarket,
      destX = tileToPx(1 - StraightHorizontalHallway_toMarket.mapCol),
      destY = tileToPx(19 - StraightHorizontalHallway_toMarket.mapRow),
      destDirection = Assets.playerRightSprite
   })

add(StraightHorizontalHallway_toMarket.exits,
   { x = 103, y = 20, dest = MainRoom, destX = tileToPx(2), destY = tileToPx(4),
      destDirection = Assets.playerDownSprite })

global function initRoom(room: Room)
   room.zombies = {}
   for spawn in all(room.zombieSpawns) do
      add(room.zombies, makeZombie(
         (spawn.tileX - room.mapCol) * 8,
         (spawn.tileY - room.mapRow) * 8
      ))
   end
end

global function updateExits()
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

global function executeLocationTransition(exit: Exit)
   GameState.locationTransitionScreen = true
   -- Do animation on original location
   GameState.currentRoom = exit.dest
   initRoom(GameState.currentRoom)
   PlayerState.x = exit.destX
   PlayerState.y = exit.destY
   PlayerState.spriteNum = exit.destDirection
   -- Do animation on new location
   GameState.locationTransitionScreen = false
end

global function renderRoomItems(room: Room)
   for item in all(room.items) do
      spr(item.id, item.x, item.y)
   end
end

global function updateCamera()
   local room = GameState.currentRoom
   -- Keep player centered on screen, but stop scrolling before the room edge.
   DisplayState.camX = mid(0, PlayerState.x - 64, max(0, room.tileW * 8 - DisplayState.viewW))
   DisplayState.camY = mid(0, PlayerState.y - flr(DisplayState.viewH / 2), max(0, room.tileH * 8 - DisplayState.viewH))
end

global function renderCurrentRoom()
   local room = GameState.currentRoom
   -- Draw the room's tiles starting at map cell (mapCol, mapRow) at world (0,0):
   map(room.mapCol, room.mapRow, 0, 0, room.tileW, room.tileH)
end
