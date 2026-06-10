Screen = {
    top_left = {x = 0, y = 0}, 
    height = 128, 
    width = 128
}


Sprites = {
    object_sprite = 0
}


World = {
    gravity = .1,
    ground_y = 112
}

Objects = {
}



function spawnObject(xPos, yPos, Mass)
    add(Objects, {
        xPos = xPos,
        yPos = yPos, 
        Mass = Mass, 
        vX = 0,
        vY = 0,
        grounded = false
    })
end

function updateObjects()
    for object in all(Objects) do
        if not object.grounded then
            object.vY += World.gravity
        end
        object.yPos += object.vY
    end
end

function detectCollisions()
    for object in all(Objects) do
        if object.yPos + 8 >= World.ground_y then
            object.grounded = true
            object.vY *= -1
            object.yPos = World.ground_y - 8
        else
        object.grounded = false
    end
    end
end

function renderObjects()
    for object in all(Objects) do
        spr(Sprites.object_sprite, object.xPos, object.yPos)
    end

end

function renderFloor()
    rectfill(0, 112, 128, 128, 10)
end


function _init()
    spawnObject(60, 10, 10)
end

function _update60()
    detectCollisions()
    updateObjects()
end


function _draw()
    cls()
    renderFloor()
    renderObjects()
end