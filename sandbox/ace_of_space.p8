pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- movement functions for the enemies
function move_y(enemy)
    enemy.y += enemy.speed
end

function move_zic_zac(enemy)
    enemy.x += enemy.speed
    enemy.y += 1

    if enemy.x > 120 then 
        enemy.speed *= -1 
    end

    if enemy.x < 8 then 
        enemy.speed *= -1 
    end
end

function move_stop_and_horiz(enemy)
    if enemy.y > 48 then
       enemy.x += enemy.speed
       if enemy.x < 0 then enemy.speed *= -1 end
       if enemy.x > 100 then enemy.speed *= -1 end
    else
        enemy.y += 1
    end

end

function move_x(enemy)
    enemy.x += enemy.speed
end

function move_y_and_back(enemy)
    enemy.y += enemy.speed
    if enemy.y > 96 then
        enemy.speed = -enemy.speed 
    end
end

-- creates a new enemy object
function create_enemy(x,y,frame,spd,hp,shots,movement,boss)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.speed = spd
    enemy.move = movement
    enemy.frame = frame
    enemy.hp = hp
    enemy.shots = shots
    enemy.boss = boss
    enemy.blink = false

    -- exceptions for the different movement types
    left_or_right=flr(rnd(2))+1
    if movement == move_zic_zac then 
        if left_or_right == 2 then
            enemy.speed = -spd
        end
    end

    if movement == move_x then 
        if left_or_right == 2 then
            enemy.y = enemy.x
            enemy.x = -8
        else
            enemy.speed = -enemy.speed
            enemy.y = enemy.x
            enemy.x = 128
        end
    end

    return enemy
end

-- creates particle object
function create_particle(type,x,y,dir,size,speed,color)
    p={}
    p.type=type
    p.x=x
    p.y=y
    p.dir=dir
    p.size=size
    p.speed=speed
    p.color=color
    return p
end

-- creates a new projectile object
function create_projectile(x,y,xspd,yspd,bad)
    projectile = {}
    projectile.x = x
    projectile.y = y 
    projectile.xspeed = xspd
    projectile.yspeed = yspd
    projectile.bad = bad

    return projectile
end

function multiple_projectiles(object,positions,bad)
    for i=1,#positions do
        add(projectiles,create_projectile(object.x+positions[i][1],object.y+positions[i][2],positions[i][3],positions[i][4],bad))        
    end 
end

-- creates a new power-up object
function create_powerup(x,y,frame)
    powerup = {}
    powerup.x = x
    powerup.y = y
    powerup.frame = frame

    return powerup
end

-- creates a new text object (for ingame messages)
function create_text(x,y,speed,content,color)
    text = {}
    text.x = x
    text.y = y
    text.speed = speed
    text.content = content
    text.color = color

    return text
end

-- collision detection (with offset on the x-axis)
function collide(obj1,obj2,offset_x,enemey_size) 
    if not enemey_size then enemey_size = 8 end

    if  obj1.x < obj2.x + enemey_size and
        obj1.x + enemey_size - offset_x > obj2.x  and
        obj1.y  < obj2.y + enemey_size  and
        obj1.y + enemey_size   > obj2.y 
    then
        return true
    else
        return false
    end
end

-- converts boolean to int (1,0)
function bool_to_int(bol)
    if bol then return 1 else return 0 end
end    

function _init()
    cos1 = cos function cos(angle) return cos1(angle/(3.1415*2)) end
    sin1 = sin function sin(angle) return sin1(-angle/(3.1415*2)) end

    -- game variables
    game_counter = 0
    game_score = 0
    game_deaths = 0
    game_state = "game"

    -- object variables      
    particles = {}
    projectiles = {}
    stars={}
    enemies={}
    enemy_spawn_freq=250
    enemy_shoot_speed = 2
    enemy_shoot_freq = 50
    enemies_max=4
    movements={move_y,move_zic_zac,move_y_and_back,move_x}
    powerups={}
    powerup_spawn_freq=600
    text_messages={}
    player= {
                x=64,
                y=118,
                hspeed=0,
                vspeed=0,
                max_speed=1,
                hp=1,
                shots=1,
                projectile_offset = 20,
                shield = 0,
                shield_duration = 500
            }
    --add(powerups, create_powerup(64,0,67))
    -- create_enemy(x,y,frame,spd,hp,shots,movement,boss)
    --add(enemies,create_enemy(64,-16,32,1,5,0,move_bounce,true))
end

function _update60()
    -- reset game counter
    game_counter+=1
    if game_counter > 1000 then game_counter = 1 end

    -- restart game (on game over screen)
    if game_state == "game_over" then
        if btnp(4) then

            player= {
                x=64,
                y=118,
                hspeed=0,
                vspeed=0,
                max_speed=1,
                hp=1,
                shots=1,
                projectile_offset = 20,
                shield = 0,
                shield_duration = 500
            }
            
            enemies={}
            projectiles={}
            game_counter=1
            game_score=0
            game_state="game"
        end
    end

    if game_state == "game" then
        -- player movement: left, right, up, down
        player.hspeed = (bool_to_int(btn(1)) - bool_to_int(btn(0))) * player.max_speed 
        player.vspeed = (bool_to_int(btn(3)) - bool_to_int(btn(2))) * player.max_speed

        player.x += player.hspeed
        player.y += player.vspeed

        -- player shoots
        if btn(5) then
            if game_counter % player.projectile_offset == 0 then
                if player.shots == 1 then
                    add(projectiles,create_projectile(player.x+4,player.y+4,0,5))    
                elseif player.shots == 2 then
                    multiple_projectiles(player,{{2,4,0,5},{6,4,0,5}},false)
                elseif player.shots == 3 then
                    multiple_projectiles(player,{{4,4,1,5},{4,4,0,5},{4,4,-1,5}},false)
                elseif player.shots == 4 then
                    multiple_projectiles(player,{{4,4,-5,0},{4,4,0,5},{4,4,0,-5},{4,4,5,0}},false)
                elseif player.shots == 5 then
                    multiple_projectiles(player,{{4,4,1,5},{4,4,0,5},{4,4,-1,5},{4,4,1,-5},{4,4,-1,-5}},false)
                elseif player.shots == 6 then
                    multiple_projectiles(player,{{2,4,0,5},{6,4,0,5},{2,4,0,-5},{6,4,0,-5},{4,4,-5,0},{4,4,5,0}},false)
                elseif player.shots == 7 then
                    multiple_projectiles(player,{{4,4,1,5},{4,4,0,5},{4,4,-1,5},{4,4,1,-5},{4,4,-1,-5},{4,4,-5,0},{4,4,5,0}},false)
                elseif player.shots == 8 then
                    multiple_projectiles(player,{{4,4,1,5},{4,4,0,5},{4,4,-1,5},{4,4,1,-5},{4,4,-1,-5},{4,4,0,-5},{4,4,-5,0},{4,4,5,0}},false)
                end
            end
        end

        -- player may not leave the area
        player.x = mid(0,120,player.x)
        player.y = mid(0,120,player.y)

        -- player shield durability
        if player.shield == 1 then
            player.shield_duration -= 1
        end

        if player.shield_duration <= 0 then
            player.shield_duration = 500
            player.shield = 0
        end

        -- player dead
        if player.hp == 0 then
            for n=1,30 do
                add(particles,create_particle(circfill,player.x,player.y,flr(rnd(360))+1,flr(rnd(2)),flr(rnd(3))+1,12))
            end
            game_deaths += 1
            game_state="game_over"
        end
    end

    if game_state == "game" or game_state == "game_over" then
        --enemy spawner
        if game_counter % enemy_spawn_freq == 0 then
            e_amount=flr(rnd(enemies_max))+1
            e_speed={0.5,1,1.5,2}
            spawn_boss=flr(rnd(10))+1

            if spawn_boss == 5 then
                add(enemies,create_enemy(64,-32,32,0.5,5,4,move_stop_and_horiz,true)) -- todo: make this random, later
            else
                for e=1,e_amount do
                    add(enemies,create_enemy(flr((flr(rnd(112))+8)/8)*8,-8,flr(rnd(22)+2),e_speed[flr(rnd(4))+1],1,flr(rnd(5)),movements[flr(rnd(#movements))+1]))
                end
            end
        end

        -- enemies
        for enemy in all(enemies) do
            enemy.move(enemy)
            if enemy.y > 127 then del(enemies,enemy) end

            if game_counter % enemy_shoot_freq == 0 then
                if enemy.shots == 1 then
                    add(projectiles,create_projectile(enemy.x+4,enemy.y+4,0,-enemy_shoot_speed,true))
                elseif enemy.shots == 2 then
                    multiple_projectiles(enemy,{{4,4,0,-enemy_shoot_speed},{4,4,0,enemy_shoot_speed}},true)
                elseif enemy.shots == 3 then
                    multiple_projectiles(enemy,{{2,4,0,-enemy_shoot_speed},{6,4,0,-enemy_shoot_speed},{4,4,0,enemy_shoot_speed}},true)
                elseif enemy.shots == 4 then
                    multiple_projectiles(enemy,{{4,4,0,-enemy_shoot_speed},{4,4,-enemy_shoot_speed,0},{4,4,0,enemy_shoot_speed},{4,4,enemy_shoot_speed,0}},true)
                end
            end

            -- if enemy hits the player
            if collide(player,enemy,0)
            then
                if player.shield == 1 then
                    enemy.hp = 0
                else
                    -- player dead
                    player.hp = 0
                end
            end
        end

        --power uo spawner
        if game_counter % powerup_spawn_freq == 0 then
            add(powerups, create_powerup(flr(rnd(112))+8,-8,flr(rnd(4))+64))
        end

        -- powerups
        for powerup in all(powerups) do
            powerup.y += 1
            if powerup.y > 127 then del(powerups,powerup) end

            if player.hp > 0 then
                if collide(player,powerup,0) then
                    -- different types of powerups 
                    if powerup.frame == 64 then
                        add(text_messages, create_text(powerup.x-16,powerup.y,-1,"+ bullets",8))

                        if player.shots < 8 then
                            player.shots += 1
                        end
                    elseif powerup.frame == 65 then
                        add(text_messages, create_text(powerup.x-16,powerup.y,-1,"+ speed",11))

                        if player.max_speed < 3 then
                            player.max_speed += 1
                        end
                    elseif powerup.frame == 66 then
                        add(text_messages, create_text(powerup.x-16,powerup.y,-1,"+ frequency",10))

                        if player.projectile_offset > 5 then
                            player.projectile_offset -= 5
                        end
                    elseif powerup.frame == 67 then
                        add(text_messages, create_text(powerup.x-16,powerup.y,-1,"+ shield",13))

                        if player.shield == 0 then
                            player.shield = 1
                            player.shield_duration = 500
                        end
                    end
                    del(powerups,powerup)
                end
           end
        end

        -- text
        for txt in all(text_messages) do
            txt.y += txt.speed
            if txt.y < -8 then del(text_messages,txt) end
        end

        -- projectiles 
        for projectile in all(projectiles) do
            projectile.y -= projectile.yspeed
            projectile.x -= projectile.xspeed

            if projectile.y < 0 then del(projectiles,projectile) end
            if projectile.y > 127 then del(projectiles,projectile) end

            if projectile.x < 0 then del(projectiles,projectile) end
            if projectile.x > 127 then del(projectiles,projectile) end

            -- enemies projectile hits the player
            if collide(projectile,player,8) then
                if projectile.bad then
                    if player.shield == 1 then
                        del(projectiles,projectile)
                    else
                        -- player dead
                        player.hp = 0
                    end
                end
            end

            -- a projectile hits an enemy
            for enemy in all(enemies) do
                enemy.blink = false
                if  collide(projectile,enemy,8) or (enemy.boss and collide(projectile,enemy,16,16) )
                then
                    if not projectile.bad then
                        enemy.blink = true
                        del(projectiles,projectile) 
                        enemy.hp -= 1
                    end
                end

                -- and the enemy dies
                if enemy.hp <= 0 then
                    -- 1:10 chance to drop a powerup 
                    if flr(rnd(10))+1 == 5 then
                        add(powerups, create_powerup(enemy.x,enemy.y,flr(rnd(4))+64))
                    end
                    -- create particles for the explosion effect
                    if enemy.boss then
                        for n=1,30 do
                            add(particles,create_particle(circfill,enemy.x,enemy.y,flr(rnd(360))+1,flr(rnd(2)),flr(rnd(3))+1,8))
                            add(particles,create_particle(circfill,enemy.x+8,enemy.y,flr(rnd(360))+1,flr(rnd(2)),flr(rnd(3))+1,8))
                            add(particles,create_particle(circfill,enemy.x+8,enemy.y+8,flr(rnd(360))+1,flr(rnd(2)),flr(rnd(3))+1,8))
                        end
                    else
                        for n=1,30 do
                            add(particles,create_particle(circfill,enemy.x,enemy.y,flr(rnd(360))+1,flr(rnd(2)),flr(rnd(3))+1,8))
                        end
                    end
                    del(enemies,enemy)
                    game_score+=1
                end
            end
        end

        -- particles
        for p in all(particles) do
            p.x += cos(p.dir) * p.speed
            p.y += sin(p.dir) * p.speed
            
            if  p.x < 0 or
                p.x > 127 or
                p.y < 0 or
                p.y > 127 
            then
                del(particles,p)
            end
        end

        -- stars (background)
        if game_counter % 5 == 0 then 
            add(stars, create_particle(rectfill,flr(rnd(127)),0,270,1,flr(rnd(6))+1,1))
            add(stars, create_particle(rectfill,flr(rnd(127)),0,270,1,flr(rnd(6))+1,5))
            add(stars, create_particle(rectfill,flr(rnd(127)),0,270,1,flr(rnd(6))+1,6))
        end

        for star in all(stars) do
            star.y += star.speed
            if star.y > 127 then del(stars,star) end
        end
    end
end

function _draw()
    cls()

    if game_state == "game" or game_state == "game_over" then
        -- draw stars
        for i=1,#stars do
            stars[i].type(stars[i].x,stars[i].y,stars[i].x,stars[i].y,stars[i].color)
        end

        -- draw projectiles
        for i=1,#projectiles do
            if projectiles[i].bad then
                circfill(projectiles[i].x,projectiles[i].y,1,10)
                circfill(projectiles[i].x,projectiles[i].y,0,7)
            else
                circfill(projectiles[i].x,projectiles[i].y,1,12)
                circfill(projectiles[i].x,projectiles[i].y,0,7)
            end
        end    

        -- draw enemies
        for enemy in all(enemies) do
            if enemy.blink then
                -- todo: simplify the code
                pal(5,8) 
                pal(14,8) 
                pal(2,8) 
                pal(1,8) 
                pal(13,8) 
                pal(17,8) 
                pal(7,8) 
                pal(6,8) 
            end

            if enemy.boss then

                spr(enemy.frame,enemy.x,enemy.y,2,2)
            else
                spr(enemy.frame,enemy.x,enemy.y)
            end
        end
        pal()
        

        -- draw powerups
        for powerup in all(powerups) do
            spr(powerup.frame,powerup.x,powerup.y)
        end

        -- draw text
        for txt in all(text_messages) do
            print(txt.content,txt.x,txt.y,txt.color)
        end

        -- draw particles
        for p in all(particles) do
            p.type(p.x,p.y,p.size,p.color)
        end

        -- draw score and hud menu
        print("score: " .. game_score,1,1,5)
        print("score: " .. game_score,0,0,7)

        print("deaths: " .. game_deaths,86,1,5)
        print("deaths: " .. game_deaths,86,0,7)
    end
    
    if game_state == "game" then
        -- draw player
        spr(1,player.x,player.y)

        -- draw player shield
        if player.shield == 1 then
            spr(80,player.x - 4,player.y - 4,2,2)
        end
    end

    if game_state == "game_over" then
        line(0,48,128,48,10)
        print("game over",48,56,8)
        print("press 🅾️ to respawn",26,64,7)
        line(0,76,128,76,10)
    end

    -- debug
    --print("proj: " .. #projectiles,1,10,7)
    --print("stars: " .. #stars,1,18,7)
    --print("enem: " .. #enemies,1,26,7)
    --print("count: " .. game_counter,1,34,7)
    --print("powerup: " .. #powerups,1,42,7)
    --print("txt: " .. #text_messages,1,50,7)
end    


__gfx__
000000005005500500567500056666500005500000071000b00b00006000000600666600200000020bbaabb0000280008550055850056005d25dd52d00566500
00000000d051150d0522225065555556005675000d0610d00b7b3b0060d65d0600555500088ee8800b8bb8b0002288000156651050557505d225522d063ba360
007007005056d5055288882575822857056226500015510000bb33b065d11d566005500602a88a20003bb30002cc7c800552255051556515501d610563233236
00077000d516d15d588788856555555652288225765785760b23783b6512715655587555008888000dd55dd02ddd6dd806287260d05d150d2d1d61d252822825
000770000516d150588888855551155558877885115225110bb38830051271505112811502022020d556655d22cc7c2806288260515d151505555550532bb235
00700700d516d15d128888210650056012888821001551000b33333000d11d0050011005800000085055550520dd6d080552255050582505025dd52001333310
00000000dd5115dd05222250050000500d2222d00d0710d0b00b33b0000d5000006666008000000850666605200c700201566510d005600d0025520000155100
000000005dd55dd50056650000510100d0d11d0d00061000000b000b000d5000005555000200002080055008000d600085500558800560080005500000011000
051111500002e200000000ee002e7e2000ded00050056006002222000b7bbbb00000000000000000000000000000000000000000000000000000000000000000
55dddd5507e277e0e0eee20002e7eae000bdbd000505606002e22e20033333300000000000000000000000000000000000000000000000000000000000000000
051551502e27722e22e77e000ea889e005dddd500058e5002eaddae270b7bb070000000000000000000000000000000000000000000000000000000000000000
05867850e2e272e70eaeae2008eeee80056556500058750022dddd22b033330b0000000000000000000000000000000000000000000000000000000000000000
d55dd55d28e2ee820e2e2ee00020202005566550552872652e7575e23007b0030000000000000000000000000000000000000000000000000000000000000000
005165005d7777d5027e22700e00e00e502222050028e2002e5757e2200330020000000000000000000000000000000000000000000000000000000000000000
557557550511115000ee0070070007078020020800156100028ee820300820030000000000000000000000000000000000000000000000000000000000000000
00600600050000500e0000e0e0000e0e000440000005600000288200800330080000000000000000000000000000000000000000000000000000000000000000
02ee22e2e2eee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02e7ddee7e2772000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02e27e27e2272e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee2d22deedd22ee20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
de2edde2e7ede22d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2ee7e2ed2e72eddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d2eee2ed2eed22ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2dd22ee22e2dd2e20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022d2dddd2dddd220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0222222dd22d22200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01555666666555100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555566665555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555556655555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00501000000105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00500000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700007777000077770000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000060060000600600006006000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
700880077003300770099007700dd007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
708ea807703ba307709a790770de7d07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
708ee807703bb307709aa90770deed07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
700880077003300770099007700dd007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000060060000600600006006000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700007777000077770000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e00e700e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e0e2002e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070e0000e070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070e0000e070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e00000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e00000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e00000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e00000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e777777e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400001f0200f06014020010703a000350001b5400f5700f5000430004400205001450017500351002e10014500185001850016500350000a70003700110001000010000100000100006000000000000000000
