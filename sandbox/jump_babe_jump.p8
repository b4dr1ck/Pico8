pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- animation function
function animate(current_frame,frame_start,frame_end,delay)
    if  game_counter % delay == 0 then
        current_frame += 1
        if current_frame > frame_end then current_frame = frame_start 
        end
    end
    return current_frame
end

function move_left_right(enemy)
    -- left
    if c.left(1,enemy.x ,enemy.y) then
        enemy.speed *= -1
        enemy.dir = true
    end
    -- right           
    if c.right(1,enemy.x ,enemy.y) then
        enemy.speed *= -1
        enemy.dir = false
    end
end

function create_enemy(x,y,movement)
    e = {}
    e.x = x
    e.y = y
    e.hp = 1
    e.frame = 128
    e.dir = false
    e.speed = 1
    e.movement = movement

    return e
end

function _init()
    -- player variables
    p=  {   
            x= 32,
            y= 64,
            xspeed= 0,
            accel= 0.25,
            maxspeed= 2,
            jumpspeed= 3,
            yspeed= 0,
            friction= 0.25,
            direction= false,
            gravity= 0.25,
            on_ground=true,
            dead= false,
            frame= 64,
            idle= 65,
            jump= 68
        }       
    
 -- collisions
    c= { 
        left=   function(flag,x,y) 
                    if  fget(mget(flr((x)/8),flr((y)/8))) == flag or
                        fget(mget(flr((x)/8),flr((y+7)/8))) == flag
                    then
                        return true
                    else
                        return false
                    end
                end,
        right=  function(flag,x,y) 
                    if  fget(mget(flr((x+8)/8),flr((y)/8))) == flag or
                        fget(mget(flr((x+8)/8),flr((y+7)/8))) == flag
                    then
                        return true
                    else
                        return false
                    end
                end,
        up=     function(flag,x,y) 
                    if  fget(mget(flr((x)/8),flr((y)/8))) == flag or
                        fget(mget(flr((x+7)/8),flr((y)/8))) == flag
                    then
                        return true
                    else
                        return false
                    end
                end,
        down=   function(flag,x,y) 
                    if  fget(mget(flr((x)/8),flr((y+8)/8))) == flag or
                        fget(mget(flr((x+7)/8),flr((y+8)/8))) == flag
                    then
                        return true
                    else
                        return false
                    end
                end
    }

    -- create enemies
    enemies = {}
    add(enemies, create_enemy(23*8,10*8,move_left_right))
 
    game_counter=0 -- time-events
end

function _update()   
    -- game game_counter handling 
    game_counter+=1
    if game_counter > 1000 then game_counter = 0 end

 ------------------------------   
 -- add speed to players x
    p.x += p.xspeed

    -- collision detection
 -- left
    if c.left(1,p.x,p.y) then
        p.xspeed = 0
        p.x = ceil(p.x/8)*8
    end
 -- right           
    if c.right(1,p.x,p.y) then
        p.xspeed = 0
        p.x = flr(p.x/8)*8
    end

    if p.x <= 0 then p.x = 0 end

 ------------------------------
 -- gravity
    p.yspeed += p.gravity

    -- add speed to players y
    p.y += p.yspeed 

    -- collision detection
    -- up
    if c.up(1,p.x,p.y) then
        p.yspeed = 0
        p.y = ceil(p.y/8)*8
    end
    -- down
    if c.down(1,p.x,p.y) then
        p.on_ground=true -- player stand on the ground
        p.yspeed = 0
        p.y = flr(p.y/8)*8
    end
                           
 ------------------------------
 -- movement
    --  go left
    if btn(0) then
        p.xspeed -= p.accel
        p.xspeed = max(p.xspeed,-p.maxspeed)
        p.direction = true
        p.frame = animate(p.frame,64,66,5)
    end
    --  go right
    if btn(1) then
        p.xspeed += p.accel
        p.xspeed = min(p.xspeed,p.maxspeed)
        p.direction = false
        p.frame = animate(p.frame,64,66,5)
    end
    -- jump
    if btnp(5) then
        if p.yspeed == 0 and p.on_ground then
            p.yspeed = -p.jumpspeed
        end
        p.on_ground=false
    end

    -- handle idle and jump animations
    if not p.on_ground then 
        p.frame = p.jump 
    elseif p.xspeed == 0 then 
        p.frame = p.idle 
    end

    ------------------------------
    -- friction, when no button is pressed
    if not btn(0) and not btn(1) then
        if p.xspeed < 0 then p.xspeed += p.friction end
        if p.xspeed > 0 then p.xspeed -= p.friction end
    end

    --------------------------------
    --enemies
    for i=1,#enemies do
        -- player collision
        if  ((p.x >= enemies[i].x and p.x <= enemies[i].x + 7) or
            (p.x + 7 >= enemies[i].x and p.x + 7 <= enemies[i].x + 7)) and 
            p.y + 7 >= enemies[i].y
        then
            if p.yspeed > 0 then
                if enemies[i].hp  > 0 then p.yspeed = -p.jumpspeed end
                enemies[i].hp = 0
                enemies[i].speed = 0
                enemies[i].frame = 130
            end
        end

        enemies[i].movement(enemies[i])

        if enemies[i].hp > 0 then
            enemies[i].frame = animate(e.frame,128,129,5)
            enemies[i].x -= enemies[i].speed
        end


    end

    --------------------------------
    -- camera
    if p.x > 64 then
        camera(p.x-64,0)
    end
end

function _draw()
    cls()
    rectfill(0,0,1024,127,12)
    map(0,0,0,0)
    spr(p.frame,p.x,p.y,1,1,p.direction)
    for i=1,#enemies do
        spr(enemies[i].frame,enemies[i].x,enemies[i].y,1,1,enemies[i].dir)
    end
    --debug
    --print(p.yspeed,p.x-60,0,8)
end





__gfx__
000000003bb3b3bb4494d549eddddddd0000000ed000000000000000dddddddda9494222333333330000bb330000b3333333333333333333333b00003b3333b0
0000000033333333d5494d44eddddddd000000eddd00000000000000dddddddd944949223b3333330000b33b0000b3b333333333333b33b33b3b0000333333b0
007007005454444554544445eddddddd00000eddddd0000000000000dddddddda4944222b333333300000b33000b3b33333333333b33333bb3b00000333b33b0
00077000944d4494944d4494eddddddd0000eddddddd000000000000dddddddda4a4492233b33333000000b3000b333333333333333b3b3333b0000033bbb3b0
000770004d444d444d444d44eddddddd000eddddddddd000000ed000dddddddda4492422b33333b30000000b0000b3b3333333333bb3333bbb000000333333b0
0070070045d494d445d494d4eddddddd00eddddddddddd0000eddd00dddddddd944444420b33b3330000000000000b33333333333333bbb000000000333b3b00
000000004d4d445d4d4d445deddddddd0eddddddddddddd00eddddd0dddddddd9494a42200bbbbbb00000000000bb33333333333bbbb00000000000033b33b00
000000004454494444544944edddddddedddddddddddddddeddddddddddddddda44494220000000000000000000b3b333333333300000000000000003333b000
33333333666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333655555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333b33b3655555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3333b33655555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b333b655555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b33bbb33655555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bb000bb655555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00900002000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900020000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004042b300b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a092000b0b301000700d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009040000b331b100797d9d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009402000b3b10000700d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a420000b310000030030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00029200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00094000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00094200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00944200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09494200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999900099999000999990000000000099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09acac0009acac0009acac000000000009acac000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099aaa00099aaa00099aaa0000000000099aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
088880000888800008888000000000000a8880a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08a88a00088a8a00088a80a000000000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111000011110000111100000000000411111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04001000010010000100400000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004000040040000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e888ee00888ee800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ae8ea200e8ea2800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
028e828008e828800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012221e002221e800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e121e800121e88028e28e2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000000000000000b0c080c0f0000000000000000000a09080d0e0000000000000000000000000000000000000a0910080d0e000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000a09080d0e0000000000000000000000080000000000000000000000000000000000000000000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000800000600000000000006000000080000000000000000000000000000000000000000000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000006000000000800000300000000000003000000080000000600000000000000000000000000000000000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003000000000800000300000000000003000000080000000300000000000000000000000000000000000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000c003c0c0c00008c0c003c00000c0c0c003000000080000000300000000000000000000000000000000000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000c00305c000c008c0c0030000c00000c003000000080000000300000000000000000004050000003f00000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000c003070000c008c0c003000020c0001111110000080000000300000000000000001111110000000000000000080000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000c0030700c00008c0000300003021c00003050000080000040705000000002100000003070000000000002000080000001111111111000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000c00307c0c0c008c0c00300010101c0c003070000080000030707200000000100000407070500000000003000082200000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1030700c3c208c0010101010202222203070000082100030707300001000200040707070705002100000101010100000000000000001100000000000407080705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d021d0d103070022d20101010202020202010101010101010101010101010101000200030107070107000100000202020200000000000000000000000000000307080707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010102020202020202020202020202020202020202020202000200030207070207050200000202020200000000000000000000110000000307080707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202000204070207070207070200000202020200000000000000000000000000000307080707050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202000207070207070207070200000202020200000000000000000000000022000307080707072200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202000207070207070207070205000202020200000000000000000000000001010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00020000095700d5701057010570105701b50024700237001d7000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d0000215501d5501a5501655013550105500c55008550075500355001550015500155001550140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200001a7501d7501d7500000000000187501875000400000001d7501d750187501f750217500000000000000001d7501d750187501d75000000000000000000000217502375000000237501d7501875000000
000d00001b00011000090000200013500105000c50008500075000350001500015000150001500140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000c0000e00010000110000000000000000000d0000c0000e00010000110000d00009000000000d0000c0000e00010000110000200003000040000d0000c0000e00010000110000000000000000000d000
__music__
03 02424344

