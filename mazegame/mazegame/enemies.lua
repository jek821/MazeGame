-- zombie AI (stub)
-- each zombie: {x, y, health}
-- stored in GameState.zombies






function updateZombiePosition(zombie)
    if zombie.xPos != PlayerState.x or zombie.yPos != PlayerState.y then
        -- get deltas:
        local dx = PlayerState.x - zombie.xPos
        local dy = PlayerState.y - zombie.yPos
        -- use pythagorean theorem to get distance
        local distance = sqrt(dx * dx + dy * dy)
        -- stop at player border instead of overlapping
        if distance <= 8 then return end
        -- adjust zombie position using delta / distance * speed
        local effectiveSpeed = zombie.is_shot and zombie.speed / 3 or zombie.speed
        zombie.xPos += dx / distance * effectiveSpeed
        zombie.yPos += dy / distance * effectiveSpeed
    end
end

function updateZombies(ZombiesTable)
    for z in all(ZombiesTable) do
        if z.health <= 0 then
            del(ZombiesTable, z)
        end
        if getPelletCollision(z.xPos, z.yPos) then
            z.health -= 20
            z.is_shot = true
            z.shot_time_left += z.shot_effect_time
        end
        if z.is_shot then
            z.shot_time_left -= 1
            if z.shot_time_left <= 0 then
                z.is_shot = false
                z.shot_time_left = 0
            end
        end
        updateZombiePosition(z)
    end
end

function renderZombies(ZombiesTable)
    for z in all(ZombiesTable) do
        local sprite = Assets.zombieDLeftSprite -- TODO: pick based on direction
        if z.is_shot then
            for c = 1, 15 do pal(c, 8) end
            spr(sprite, z.xPos - 1, z.yPos)
            spr(sprite, z.xPos + 1, z.yPos)
            spr(sprite, z.xPos, z.yPos - 1)
            spr(sprite, z.xPos, z.yPos + 1)
            pal()
        end
        spr(sprite, z.xPos, z.yPos)
    end
end
