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
    e.random_direction = 1
    e.movement = movement_function
    e.open_directions = {}
    
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

-- animation function
function animate(current_frame,frame_start,frame_end,delay)
    if  game_counter % delay == 0 then
        current_frame += 1
        if current_frame > frame_end then current_frame = frame_start 
        end
    end
    return current_frame
end

function random_movement(enemies,i)
    --enemy ai
    if enemies[i].x_speed < 0 then
        --about to collide left
        if  (fget(mget( flr((enemies[i].x-1) / 8), flr(enemies[i].y / 8))) == 1  and
            fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y+7) / 8))) == 1) or
            (fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y-1) / 8))) == 0 or
            fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y+8) / 8))) == 0)
        then
            -- can go up?
            if fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y-1) / 8))) == 0 and
               fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y-1) / 8))) == 0 
            then
                add(enemies[i].open_directions,2)
            end
            -- can go down?
            if  fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y+8) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y+8) / 8))) == 0 
            then
                add(enemies[i].open_directions,3)
            end
            -- can go further left?
            if  fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y) / 8))) == 0 and
                fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y+7) / 8))) == 0 
            then
                add(enemies[i].open_directions,0)
            end
            
            -- choose random direction
            if #enemies[i].open_directions > 0 
            then  
                enemies[i].random_direction = enemies[i].open_directions[flr(rnd(#enemies[i].open_directions))+1]
                enemies[i].open_directions={}
            else
                enemies[i].random_direction = 1
            end
        end
    elseif enemies[i].x_speed > 0 then
        --about to collide right
        if  (fget(mget( flr((enemies[i].x+8) / 8), flr(enemies[i].y / 8))) == 1  and
            fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y+7) / 8))) == 1) or
            (fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y-1) / 8))) == 0 or
            fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y+8) / 8))) == 0)
        then
            -- can go up?
            if fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y-1) / 8))) == 0 and
               fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y-1) / 8))) == 0 
            then
                add(enemies[i].open_directions,2)
            end
            -- can go down?
            if  fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y+8) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y+8) / 8))) == 0 
            then
                add(enemies[i].open_directions,3)
            end
            -- can go further right?
            if  fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y+7) / 8))) == 0  
            then
                add(enemies[i].open_directions,1)
            end
            
            -- choose random direction
            if #enemies[i].open_directions > 0 
            then  
                enemies[i].random_direction = enemies[i].open_directions[flr(rnd(#enemies[i].open_directions))+1]
                enemies[i].open_directions={}
            else
                enemies[i].random_direction = 0
            end
        end
    elseif enemies[i].y_speed < 0 then
        --about to collide up
        if  (fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y-1)/ 8))) == 1  and
            fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y-1) / 8))) == 1) or
            (fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y+7) / 8))) == 0 or
            fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y+7) / 8))) == 0)
        then
            -- can go left
            if  fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y) / 8))) == 0 and
                fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y+7) / 8))) == 0 
            then
                add(enemies[i].open_directions,0)
            end
            -- can go right
            if  fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y+7) / 8))) == 0 
            then
                add(enemies[i].open_directions,1)
            end
            -- can go up
            if  fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y-1) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y-1) / 8))) == 0 
            then
                add(enemies[i].open_directions,2)
            end
            
            -- choose random direction
            if #enemies[i].open_directions > 0 
            then  
                enemies[i].random_direction = enemies[i].open_directions[flr(rnd(#enemies[i].open_directions))+1]
                enemies[i].open_directions={}
            else
                enemies[i].random_direction = 3
            end
        end
    elseif enemies[i].y_speed > 0 then
        --about to collide down
        if  (fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y+8)/ 8))) == 1  and
            fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y+8) / 8))) == 1) or
            (fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y) / 8))) == 0 or
            fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y) / 8))) == 0)
        then
            -- can go left
            if  fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y) / 8))) == 0 and
                fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y+7) / 8))) == 0 
            then
                add(enemies[i].open_directions,0)
            end
            -- can go right
            if  fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y+7) / 8))) == 0 
            then
                add(enemies[i].open_directions,1)
            end
            -- can go down
            if  fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y+8) / 8))) == 0 and
                fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y+8) / 8))) == 0
            then
                add(enemies[i].open_directions,3)
            end
            
            -- choose random direction
            if #enemies[i].open_directions > 0 
            then  
                enemies[i].random_direction = enemies[i].open_directions[flr(rnd(#enemies[i].open_directions))+1]
                enemies[i].open_directions={}
            else
                enemies[i].random_direction = 2
            end
        end
    end
    
    -- movement handling
    if enemies[i].random_direction == 0 then
        enemies[i].x_speed = -enemies[i].max_speed
        enemies[i].direction = true
        enemies[i].y_speed = 0
    elseif enemies[i].random_direction == 1 then
        enemies[i].x_speed = enemies[i].max_speed
        enemies[i].direction = false
        enemies[i].y_speed = 0
    elseif enemies[i].random_direction == 2 then
        enemies[i].x_speed = 0
        enemies[i].y_speed = -enemies[i].max_speed
    elseif enemies[i].random_direction == 3 then
        enemies[i].x_speed = 0
        enemies[i].y_speed = enemies[i].max_speed
    end
    
    enemies[i].x += enemies[i].x_speed
    enemies[i].y += enemies[i].y_speed

end

-- enemy chasing-movement
-- function chasing_movement(enemies,i) 
    -- if (enemies[i].x - p.x) > 0 and 
        -- fget(mget( flr((enemies[i].x-1) / 8), flr(enemies[i].y / 8))) != 1  and
        -- fget(mget( flr((enemies[i].x-1) / 8), flr((enemies[i].y+7) / 8))) != 1 
    -- then
        -- enemies[i].x -= 0.5 
        -- enemies[i].direction = true
    -- elseif (enemies[i].y - p.y) > 0 and
        -- fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y-1) / 8))) != 1  and
        -- fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y-1) / 8))) != 1  
    -- then
        -- enemies[i].y -= 0.5
    -- elseif (enemies[i].x - p.x) < 0 and 
        -- fget(mget( flr((enemies[i].x+8) / 8), flr(enemies[i].y / 8))) != 1  and
        -- fget(mget( flr((enemies[i].x+8) / 8), flr((enemies[i].y+7) / 8))) != 1  
    -- then
        -- enemies[i].x += 0.5 
        -- enemies[i].direction = false
    -- elseif (enemies[i].y - p.y) < 0 and
        -- fget(mget( flr((enemies[i].x) / 8), flr((enemies[i].y+8) / 8))) != 1  and
        -- fget(mget( flr((enemies[i].x+7) / 8), flr((enemies[i].y+8) / 8))) != 1  
    -- then
        -- enemies[i].y += 0.5
    -- end
-- end

function _init()
    p={}
    p.x = 64
    p.y = 8
    p.x_dest = 64
    p.y_dest = 8
    p.image = 1
    p.score = 0
    p.direction = true
    
    enemies={}
	--add(enemies,create_enemy(112,96,random_movement))
    add(enemies,create_enemy(53,96,random_movement))
    
    coins={}
    add(coins,create_coin(64,24))
    add(coins,create_coin(72,24))
    add(coins,create_coin(80,24))
    add(coins,create_coin(88,24))
    add(coins,create_coin(96,24))
    add(coins,create_coin(104,24))
    add(coins,create_coin(48,24))
    add(coins,create_coin(40,24))
    add(coins,create_coin(32,24))
    add(coins,create_coin(24,24))
    add(coins,create_coin(16,24))
    
    game_counter = 1
    game_state = "game"
end

function _update()

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
        
        -- player animations
        if p.x != p.x_dest or p.y != p.y_dest then
            p.image = animate(p.image,1,4,5)    
        end
        -------------------------------------------------------------
        
        -- traps handling
        
        -- collision-detection
        if fget(mget( flr(p.x+7) / 8, p.y / 8)) == 2 then
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
            if flr(enemies[i].x) == p.x and flr(enemies[i].y) == p.y 
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
   end
   
    if game_state == "game_over" then
        if btnp(5) then _init() end
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
        
        -- draw player
        spr(p.image,p.x,p.y,1,1,p.direction)
        
        -- draw enemies
        for i=1,#enemies do
            spr(enemies[i].image,enemies[i].x,enemies[i].y,1,1,enemies[i].direction)
        end
    end
    
    if game_state == "game_over" then
        map(0,0,0,0,128,128)
        rectfill(0,40,218,72,0)
        print("game over",40,48,8)  
        print("press ❎ to restart",24,56,7)
    end
    
    -- hud menu
    rectfill(0,0,40,7,0)
    print("score: " .. p.score,0,0,7)
    
    -- draw debug
    --print("x: " .. p.x .. " y: " .. p.y,1,1,10)
    --print("x: " .. enemies[i].x .. " y: " .. enemies[i].y)
end


__gfx__
0000000003b3bb300000000000000000000000000888888800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d666666d03b3bb300000000003b3bb308888e7e808888888000000000888888800899800000a80000000000000000000000000000000000000000000
00700700667c667cd666666d03b3bb30d666666d88a988898888e7e8088888888888e7e80097a900000790000000000000000000000000000000000000000000
0007700066c18ec1667c667cd666666d667c667c8811888188a988898888e7e888a98889009aa900000790000000000000000000000000000000000000000000
00077000666688dd66c18ec1667c667c66c18ec1888888888811888188a9888988118881009aa900000790000000000000000000000000000000000000000000
007007006661775d666688dd66c18ec1666688dd88818118888888888811888188888888009aa900000790000000000000000000000000000000000000000000
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
11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55515555707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555551505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55515555070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555551050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000000000000040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000404040404140404040404040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000040000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040404040404040400040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040000000004000000040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040004040404000400040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040004000000000400040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000400040004000404000400040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040400040004000400000400040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000040000000400040000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040400040400040004040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000000000004040004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040400040404040404000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000004000000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
