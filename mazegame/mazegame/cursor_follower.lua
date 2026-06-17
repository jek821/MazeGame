cursorFollowers = {}
cursorFollowerSpeed = 2

function addCursorFollower(id)
    cursorFollowers.add({
        spriteId = id,
        xPos = 0,
        yPos = 0,
    })
end

function updateCursorFollowers()
    for cursorFollower in all(cursorFollowers) do
        if cursorFollower.xPos != GameState.mx and cursorFollower.yPos != GameState.my then
            -- Get Deltas:
            local dx = cursorFollower.xPos - GameState.mx
            local dy = cursorFollower.yPos - GameState.my
            -- Use pythagorean theorem to get distance
            local distance = sqrt(dx * dx + dy * dy)
            -- adjust cursor_follower position using delta/distance * speed
            cursorFollower.xPos += dx / distance * cursorFollowerSpeed
            cursorFollower.yPos += dy / distance * cursorFollowerSpeed
        end
    end
end

function renderCursorFollowers()
    for cursorFollower in all(cursorFollowers) do
        spr(cursorFollower.spriteId, cursorFollower.xPos, cursorFollower.yPos)
    end
end
