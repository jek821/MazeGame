Sprites = {
    cursor = 1, 
    cursorFollower = 2
}


GameState = {
    mx = 0,
    my = 0
}

screen = {
    width = 128,
    height = 128
}

function updateMouse()
    GameState.mx = stat(32)
    GameState.my = stat(33)
end

function renderMouse()
    spr(Sprites.cursor, GameState.mx, GameState.my)
end

function _init()
    addRandomCursorFollowers(10)
    poke(0x5F2D, 1)
end

function _update60()
    updateMouse()
    updateCursorFollowers()
end 


function _draw()
    cls()
    renderMouse()
    renderCursorFollowers()
end
