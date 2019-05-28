pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- create an enemy object
function create_enemy(x,y,movement_function) 
    e={}
    e.x = x
    e.y = y
    e.x_speed = 0
    e.y_speed = 0
    e.max_speed = 1
    e.image = 5
    e.direction = true
    e.random_direction = 0
    e.movement = movement_function
    e.open_directions = {}
    e.debug=0
    
    return e
end

-- create a coin object
function create_coin(x,y) 
    c={}
    c.x = x
    c.y = y
    c.image = 9
   
    return c
end

function create_key(x,y,opens)
    k={}
    k.x = x
    k.y = y
    k.image = 11
    k.opens = opens
    
    mset(k.opens[1],k.opens[2],67)
    return k
end

-- animation function
function animate(current_frame,frame_start,frame_end,delay)
    if  game_counter % delay == 0 then
        current_frame += 1
        if current_frame > frame_end then current_frame = frame_start 
        end
    end
    return current_frame
end

-- simple one-direction-bounce
function simple_bounce_x(enemies,i)
    enemies[i].x -= enemies[i].max_speed 
    if (collision.left(enemies[i].x,enemies[i].y,1) or collision.right(enemies[i].x,enemies[i].y,1))
    then 
        enemies[i].max_speed *= -1 
        enemies[i].direction = not enemies[i].direction
    end
end
function simple_bounce_y(enemies,i)
    enemies[i].y -= enemies[i].max_speed 
    if (collision.up(enemies[i].x,enemies[i].y,1) or collision.down(enemies[i].x,enemies[i].y,1))
    then 
        enemies[i].max_speed *= -1 
    end
end

-- -- random enemy movement
-- function random_movement(enemies,i)
--     --enemy ai
--     if enemies[i].x_speed < 0 then
--         --about to collide left
--         if  collision.left(enemies[i].x,enemies[i].y,1) or
--             not collision.up(enemies[i].x,enemies[i].y,1) or
--             not collision.down(enemies[i].x,enemies[i].y,1)     
--         then
--             if collision.up(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,2) end -- can go up?
--             if collision.down(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,3) end -- can go down?
--             if collision.left(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,0) end -- can go left?
--         else
--             add(enemies[i].open_directions,0)
--         end
--     elseif enemies[i].x_speed > 0 then
--         --about to collide right
--         if  collision.right(enemies[i].x,enemies[i].y,1) or
--             not collision.up (enemies[i].x,enemies[i].y,1) or
--             not collision.down (enemies[i].x,enemies[i].y,1) 
--         then
--             if collision.up(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,2) end -- can go up?
--             if collision.down(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,3) end -- can go down?
--             if collision.right(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,1) end -- can go right?
--         else
--             add(enemies[i].open_directions,1)
--         end
--     elseif enemies[i].y_speed < 0 then
--         --about to collide up
--         if  collision.up(enemies[i].x,enemies[i].y,1) or
--             not collision.left (enemies[i].x,enemies[i].y,1) or
--             not collision.right (enemies[i].x,enemies[i].y,1) 
--         then
--             if collision.left(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,0) end -- can go left
--             if collision.right(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,1) end -- can go right
--             if collision.up(enemies[i].x,enemies[i].y,0)  then add(enemies[i].open_directions,2) end -- can go up
--         else
--             add(enemies[i].open_directions,2)
--         end
--     elseif enemies[i].y_speed > 0 then
--         --about to collide down
--         if  collision.down(enemies[i].x,enemies[i].y,1) or
--             not collision.left (enemies[i].x,enemies[i].y,1) or
--             not collision.right (enemies[i].x,enemies[i].y,1) 
--         then
--             if collision.left(enemies[i].x,enemies[i].y,0)  then add(enemies[i].open_directions,0) end  -- can go left
--             if collision.right(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,1) end -- can go right
--             if collision.down(enemies[i].x,enemies[i].y,0) then add(enemies[i].open_directions,3) end -- can go down
--         else
--             add(enemies[i].open_directions,3)
--         end
--     end
    
--     -- choose random direction
--     if #enemies[i].open_directions > 0 
--     then  
--         enemies[i].random_direction = enemies[i].open_directions[flr(rnd(#enemies[i].open_directions))+1]
--         enemies[i].open_directions={}
--     else
--         if enemies[i].x_speed < 0 then enemies[i].random_direction = 1 end
--         if enemies[i].x_speed > 0 then enemies[i].random_direction = 0 end
--         if enemies[i].y_speed < 0 then enemies[i].random_direction = 3 end
--         if enemies[i].y_speed > 0 then enemies[i].random_direction = 2 end
--     end

--     -- movement handling
--     if enemies[i].random_direction == 0 then
--         enemies[i].x_speed = -enemies[i].max_speed
--         enemies[i].direction = true
--         enemies[i].y_speed = 0
--     elseif enemies[i].random_direction == 1 then
--         enemies[i].x_speed = enemies[i].max_speed
--         enemies[i].direction = false
--         enemies[i].y_speed = 0
--     elseif enemies[i].random_direction == 2 then
--         enemies[i].x_speed = 0
--         enemies[i].y_speed = -enemies[i].max_speed
--     elseif enemies[i].random_direction == 3 then
--         enemies[i].x_speed = 0
--         enemies[i].y_speed = enemies[i].max_speed
--     end
    
--     enemies[i].x += enemies[i].x_speed
--     enemies[i].y += enemies[i].y_speed
-- end

-- enemy chasing-movement
-- function chasing_movement(enemies,i) 
--     if (enemies[i].x - p.x) > 0 and not collision.left(enemies[i].x,enemies[i].y,1) 
--     then
--         enemies[i].x -= enemies[i].max_speed 
--         enemies[i].direction = true
--     elseif (enemies[i].y - p.y) > 0 and not collision.up(enemies[i].x,enemies[i].y,1) 
--     then
--         enemies[i].y -= enemies[i].max_speed
--     elseif (enemies[i].x - p.x) < 0 and not collision.right (enemies[i].x,enemies[i].y,1) 
--     then
--         enemies[i].x += enemies[i].max_speed
--         enemies[i].direction = false
--     elseif (enemies[i].y - p.y) < 0 and not collision.down (enemies[i].x,enemies[i].y,1) 
--     then
--         enemies[i].y += enemies[i].max_speed
--     end
-- end

function create_level(level)
    local x = 1
    local y = 2
    color(8) 
    for i=0,#level/3-1 do
        local count = sub(level,i*3+ 1, i*3+ 2) 
        local element = sub(level,i*3+3,i*3+3)
        count = tonum(count)
        i+=1
        for c=1,tonum(count) do
            if (element == "c") then
                add(coins,create_coin((x-1)*8+camera_offset_x,y*8+camera_offset_y)) 
            end
            if (element == "e") then
                add(enemies,create_enemy((x-1)*8+camera_offset_x,y*8+camera_offset_y,simple_bounce_y))
            end
            if (element == "f") then
                add(enemies,create_enemy((x-1)*8+camera_offset_x,y*8+camera_offset_y,simple_bounce_x))
            end

            x+=1
            if (x > 16) then 
                x = 1
                y+=1
            end
        end
    end
end

--------------------------------------------------------------

function _init()
    p={}
    p.x = 64
    p.y = 16
    p.x_dest = 64
    p.y_dest = 16
    p.image = 1
    p.score = 0
    p.direction = true

    collision = { 
        left =  function(x,y,flag) 
                    if  (fget(mget( flr((x-1) / 8), flr(y / 8))) == flag  and
                        fget(mget( flr((x-1) / 8), flr((y+7) / 8))) == flag) 
                    then
                        return true
                    else 
                        return false
                    end
                end,   
        right = function(x,y,flag) 
                    if  (fget(mget( flr((x+8) / 8), flr(y / 8))) == flag  and
                        fget(mget( flr((x+8) / 8), flr((y+7) / 8))) == flag) 
                    then
                        return true
                    else 
                        return false
                    end
                end,  
        up =    function(x,y,flag) 
                    if  (fget(mget( flr((x) / 8), flr((y-1)/ 8))) == flag  and
                        fget(mget( flr((x+7) / 8), flr((y-1) / 8))) == flag) 
                    then
                        return true
                    else 
                        return false
                    end
                end,
        down =  function(x,y,flag) 
                    if  (fget(mget( flr((x) / 8), flr((y+8)/ 8))) == flag  and
                        fget(mget( flr((x+7) / 8), flr((y+8) / 8))) == flag) 
                    then
                        return true
                    else 
                        return false
                    end
                end
        }
    
    current_level = 0
    camera_offset_x=0
    camera_offset_y=0

    coins={}
    enemies={}
    keys={}
    enemies={}



    game_counter = 1
    game_state = "game"
end

function _update()

    -- level manager
    if flr(p.x/128) + 1 != current_level 
    then
        if flr(p.x/128) + 1 == 1 then
            level_string=   "16x"..
                            "01x01c01x01c12x" ..
                            "01x01c01x10c01x01c01x" ..
                            "01x01c04x01c07x01c01x" ..
                            "01x01c01x04c01x01x06c01x" ..
                            "01x01c01x01c05x01c06x" ..
                            "01x01c01x05c01x06c01x" ..
                            "16x" ..
                            "16x" ..
                            "16x" ..
                            "16x" ..
                            "16x" ..
                            "01x01e12x01f01x"
            add(keys,create_key(8*8,6*8,{15,2}))
        elseif flr(p.x/128) + 1 == 2 then
            mset(15,2,67)
            level_string=   "03x12c01x" .. 
                            "16x" ..
                            "02x01f10c03x" ..
                            "16x" ..
                            "01x08c01f06x" ..
                            "16x" ..
                            "02x11c03x" ..
                            "16x" ..
                            "01x08c01f06x" ..
                            "16x" ..
                            "02x01f10c03x" ..
                            "16x" ..
                            "01x13c02x"

            add(keys,create_key(30*8,14*8,{31,2}))
        elseif flr(p.x/128) + 1 == 3 then
            mset(31,2,67)
            level_string=   "16x"
        end
        
        create_level(level_string)
        current_level=flr(p.x/128)+1
    end

    -- game restart on pressing x on game_over screen
    if game_state == "game_over" then
        if btnp(5) then _init() end
    end

    -- game_counter reset
    game_counter+=1
    if game_counter > 100 then game_counter = 1 end
    
    if game_state == "game" then
        -------------------------------------------------------------
        
        -- player handling
        -- key- and collision-detection - 4 directions
        if p.x == p.x_dest and  p.y == p.y_dest then
            if btn(1) and fget(mget( (p.x+8) / 8, p.y / 8)) != 1 then
                p.x_dest += 8
                p.direction = false
            elseif btn(0) and fget(mget( (p.x-8) / 8, p.y / 8)) != 1 then
                p.x_dest -= 8
                p.direction = true
            elseif btn(3) and fget(mget( p.x / 8, (p.y+8) / 8)) != 1 then
                p.y_dest += 8
            elseif btn(2) and fget(mget( p.x / 8, (p.y -8) / 8)) != 1 then
                p.y_dest -= 8
            else
                p.image = 1
            end
        end
       
        -- smooth movement on x and y axis
        if p.x < p.x_dest then
            p.x += 1
        elseif p.x > p.x_dest then
            p.x -= 1
        end
        
        if p.y < p.y_dest then
            p.y += 1
        elseif p.y > p.y_dest then
            p.y -= 1
        end

        -- set camera
        camera_offset_x = flr(p.x/128) * 128
        camera(camera_offset_x,camera_offset_y)
        
        -- player animations
        if p.x != p.x_dest or p.y != p.y_dest then
            p.image = animate(p.image,1,4,5)    
        end
        -------------------------------------------------------------
        
        -- traps handling
        
        -- collision-detection
        if fget(mget( flr(p.x+4) / 8, flr(p.y+4) / 8)) == 2 
        then
            game_state="game_over"
        end
        -------------------------------------------------------------
        
        -- enemy handling
        for i=1,#enemies do
        
            -- movement
            -- chasing_movement(enemies,i)
            enemies[i].movement(enemies,i)

            -- animations
            enemies[i].image =  animate(enemies[i].image,5,8,5) 
            
            -- collision-detection
            if  flr(enemies[i].x) >= p.x and flr(enemies[i].y) >= p.y and  
                flr(enemies[i].x) < p.x + 4 and flr(enemies[i].y) < p.y + 4   
            then
                game_state="game_over"
            end
        end
        -------------------------------------------------------------
        
        -- coins handling
        for i=1,#coins do
            coins[i].image =  animate(coins[i].image,9,10,5) 
            
            -- collision-detection
            if flr(coins[i].x) == p.x and flr(coins[i].y) == p.y 
            then
                coins[i].x = -8
                coins[i].y = -8
                p.score+=1
            end
        end
        -------------------------------------------------------------

        -- keys handling
        for i=1,#keys do

            -- collision-detection
            if flr(keys[i].x) == p.x and flr(keys[i].y) == p.y 
            then
                keys[i].x = -8
                keys[i].y = -8
                mset(keys[i].opens[1],keys[i].opens[2],0)
            end
        end
        -------------------------------------------------------------
   end
   
end

function _draw()
    cls()
       
   if game_state == "game" then
        -- draw map
        map(0,0,0,0,128,128)
        
        -- draw coins
        for i=1,#coins do
            spr(coins[i].image,coins[i].x,coins[i].y)
        end

        -- draw keys
        for i=1,#keys do
            spr(keys[i].image,keys[i].x,keys[i].y)
        end
        
        -- draw player
        spr(p.image,p.x,p.y,1,1,p.direction)
        
        -- draw enemies
        for i=1,#enemies do
            spr(enemies[i].image,enemies[i].x,enemies[i].y,1,1,enemies[i].direction)
        end
    end
    
    if game_state == "game_over" then
        map(0,0,0,0,128,128)
        rectfill(camera_offset_x,camera_offset_y,camera_offset_x+128,camera_offset_y+128,0)
        print("game over",camera_offset_x+45,camera_offset_y+48,8)  
        print("press ❎ to restart",camera_offset_x+24,camera_offset_y+56,7)
    end
    
    -- hud menu
    rectfill(camera_offset_x,camera_offset_y,camera_offset_x+128,7,0)
    print("score: " .. p.score .. "   lvl:" .. current_level ,camera_offset_x,camera_offset_y,7)
    
    -- draw debug
    --print("x: " .. p.x .. " y: " .. p.y,1,1,10)
    --print("x: " .. enemies[i].x .. " y: " .. enemies[i].y)
end

__gfx__
0000000003b3bb300000000000000000000000000888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d666666d03b3bb300000000003b3bb308888e7e808888888000000000888888800899800000a80000000000000000000000000000000000000000000
00700700667c667cd666666d03b3bb30d666666d88a988898888e7e8088888888888e7e80097a90000079000a0a0087800000000000000000000000000000000
0007700066c18ec1667c667cd666666d667c667c8811888188a988898888e7e888a98889009aa9000007900099900a0a00000000000000000000000000000000
00077000666688dd66c18ec1667c667c66c18ec1888888888811888188a9888988118881009aa90000079000aaa7a90900000000000000000000000000000000
007007006661775d666688dd66c18ec1666688dd88818118888888888811888188888888009aa900000790000000089800000000000000000000000000000000
000000006666666dd661775dd66688ddd661775d28ee7ee288e181128888888888e1811200899800000a80000000000000000000000000000000000000000000
00000000d666666ddd66666dddd1775ddd66666d2e2ee2222e2e7e222e21e1122e2e7e2200000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000005444444567777776222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55515555707070704222222460505056eee2eeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111606060604256652460d0d0d6222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555551505050504251152460606066eeeeeee20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000004251152460606066222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55515555070707074255552460d0d0d6eee2eeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111060606064222222460505056222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555551050505055444444567777776eeeeeee20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404040404040404044444444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4240404040404040404040404040404242444444444444444444444444444442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040404040404040404040004044444444444444444444444444440044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400000000000000000000041004044000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000404040400040404040404040004044004444444444440044444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000410000000040000000000000004044000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040404040400040404040404044444444444444444444444444440044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4200400000000000400000000000004242000000000000000000000000000042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000404040404040404040404040004044004444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000000000410000004044000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040404040404040004040004044444444444444440044444444440044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400000000000000000000041004044000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000404040404040004040404040004044004444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000000000000000004044000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4240404040404040404040404040404242444444444444444444444444444442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
