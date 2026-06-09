cursor_followers = {}
cursor_follower_speed = 2

function add_cursor_follower(id, start_x_pos, start_y_pos)
    cursor_followers.add({
    sprite_id = id,
    x_pos = 0,
    y_pos = 0,
})
end



function update_cursor_followers()
    for cursor_follower in all(cursor_followers) do
        if cursor_follower.x_pos != Game.mx and cursor_follower.y_pos != Game.my then
            -- Get Deltas:
            local dx = cursor_follower.x_pos - Game.mx
            local dy = cursor_follower.y_pos - Game.my
            -- Use pythagorean theorem to get distance 
            local distance = math.sqrt(dx*dx + dy*dy)
            -- adjust cursor_follower position using delta/distance * speed
            cursor_follower.x_pos += dx/distance * cursor_follower_speed
            cursor_follower.y_pos += dy/distance * cursor_follower_speed
        end
    end
end

function render_cursor_followers()
    for cursor_follower in all(cursor_followers) do
        spr(cursor_follower.sprite_id, cursor_follower.x_pos, cursor_follower.y_pos)
    end
end