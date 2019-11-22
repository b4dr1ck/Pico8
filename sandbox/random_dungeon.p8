pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function create_random_dungeon()
    c=0
    while c < passables do
        randx = flr(rnd(max_tiles-2)) + 2
        randy = flr(rnd(max_tiles-2)) + 2
        setflag = false

        if dungeon[randy-1][randx] == 0 then
            setflag=true
        elseif dungeon[randy+1][randx] == 0 then
            setflag=true
        elseif dungeon[randy][randx-1] == 0 then
            setflag=true
        elseif dungeon[randy][randx+1] == 0 then
            setflag=true
        end
        
        if setflag == true then
            dungeon[randy][randx] = 0
            c+=1
        end
    end		
end

function render_dungeon_map()
    rectfill(0,0,max_tiles-1,max_tiles-1,0)
    for y=0,max_tiles-1 do
        for x=0,max_tiles-1 do
            if (dungeon[(y+1)][(x+1)] == 1) then
                rectfill(x,y,x,y,5)
             end
            if (player.x == (x+1) and
                player.y == (y+1)) 
            then
                rectfill(x,y,x,y,8)
            end
        end
    end
end

function render_3d_wall(position)
    if position == "3L" then
        spr(11,5*8,5*8)
        spr(12,5*8,10*8)
        for i=6,9 do
            spr(10,5*8,i*8)
        end
        for x=0,4 do
            for y=5,10 do
                spr(10,x*8,y*8)
            end
        end
    end
    if position == "3R" then
        spr(11,10*8,5*8,1,1,true)
        spr(12,10*8,10*8,1,1,true)
        for i=6,9 do
            spr(10,10*8,i*8)
        end
        for x=11,15 do
            for y=5,10 do
                spr(10,x*8,y*8)
            end
        end
    end
    if position == "3C" then
        for x=5,10  do
            for y=5,10 do
                spr(10,x*8,y*8)
            end
        end
    end
    
    if position == "2L" then
        spr(8,4*8,4*8)
        spr(9,4*8,11*8)
        spr(8,3*8,3*8)
        spr(9,3*8,12*8)
        for i=5,10 do
            spr(7,4*8,i*8)
        end
        for i=4,11 do
            spr(7,3*8,i*8)
        end
        for x=0,2 do
            for y=3,12 do
                spr(7,x*8,y*8)
            end
        end
    end    
    if position == "2R" then
        spr(8,11*8,4*8,1,1,true)
        spr(9,11*8,11*8,1,1,true)
        spr(8,12*8,3*8,1,1,true)
        spr(9,12*8,12*8,1,1,true)
        for i=5,10 do
            spr(7,11*8,i*8)
        end
        for i=4,11 do
            spr(7,12*8,i*8)
        end
        for x=13,15 do
            for y=3,12 do
                spr(7,x*8,y*8)
            end
        end
    end   
    if position == "2C" then
        for x=3,12  do
            for y=3,12 do
                spr(7,x*8,y*8)
            end
        end
    end    
    
    if position == "1L" then
        spr(5,2*8,2*8)
        spr(6,2*8,13*8)
        spr(5,1*8,1*8)
        spr(6,1*8,14*8)
        for i=3,12 do
            spr(4,2*8,i*8)
        end
        for i=2,13 do
            spr(4,1*8,i*8)
        end
        for y=1,14 do
            spr(4,0*8,y*8)
        end
    end     
    if position == "1R" then
        spr(5,13*8,2*8,1,1,true)
        spr(6,13*8,13*8,1,1,true)
        spr(5,14*8,1*8,1,1,true)
        spr(6,14*8,14*8,1,1,true)
        for i=3,12 do
            spr(4,13*8,i*8)
        end
        for i=2,13 do
            spr(4,14*8,i*8)
        end
        for y=1,14 do
            spr(4,15*8,y*8)
        end
    end    
    if position == "1C" then
        for x=1,14  do
            for y=1,14 do
                spr(4,x*8,y*8)
            end
        end
    end   
    
    if position == "0L" then
        spr(2,0*8,0*8)
        spr(3,0*8,15*8)
        
        for i=1,14 do
            spr(1,0*8,i*8)
        end
    end    
    if position == "0R" then
        spr(2,15*8,0*8,1,1,true)
        spr(3,15*8,15*8,1,1,true)
        
        for i=1,14 do
            spr(1,15*8,i*8)
        end
    end
end

function _init()
    showmap=true
    dungeon={}
    player={}
    player.d = 0
    passables=200
    max_tiles=16
    
    player.x = max_tiles/2
    player.y = max_tiles/2

    for y=0,max_tiles do
        add(dungeon,{})
        for x=0,max_tiles do
            add(dungeon[y],1)
        end
    end

    dungeon[max_tiles/2][max_tiles/2] = 0

    -- dungeon[max_tiles/2-1][max_tiles/2] = 0 
    -- dungeon[max_tiles/2-2][max_tiles/2] = 0    
    -- dungeon[max_tiles/2-1][max_tiles/2+1] = 0
    -- dungeon[max_tiles/2-1][max_tiles/2-1] = 0
    -- dungeon[max_tiles/2-3][max_tiles/2] = 0
    -- dungeon[max_tiles/2-3][max_tiles/2-1] = 0
    -- dungeon[max_tiles/2-3][max_tiles/2+1] = 0

    create_random_dungeon()
end

function _update60()
    if btnp(4) then
        showmap=not(showmap) 
    end

    if btnp(2) then
        if player.d == 0 then
			if dungeon[player.y - 1][player.x] == 0 then
				player.y -= 1
			end
		end
		if player.d == 1 then
			if dungeon[player.y][player.x+1] == 0 then
				player.x += 1
			end
		end
		if player.d == 2 then
			if dungeon[player.y+1][player.x] == 0 then
				player.y += 1
			end
		end
		if player.d == 3 then
			if dungeon[player.y][player.x-1] == 0 then
				player.x -= 1
			end
		end
    end
 
    if btnp(3) then
        if player.d == 0 then
			if dungeon[player.y + 1][player.x] == 0 then
				player.y += 1
			end
		end
		if player.d == 1 then
			if dungeon[player.y][player.x-1] == 0 then
				player.x -= 1
			end
		end
		if player.d == 2 then
			if dungeon[player.y-1][player.x] == 0 then
				player.y -= 1
			end
		end
		if player.d == 3 then
			if dungeon[player.y][player.x+1] == 0 then
				player.x += 1
			end
		end
    end
 
    if btnp(0) then
        player.d -= 1
        if player.d < 0 then player.d = 3 end
    end

    if btnp(1) then
        player.d += 1
        if player.d > 3 then player.d = 0 end
    end
end

function _draw()
    cls()
    
    map(0,0,0,0,128,128)
    
    if (player.d == 0) then
        if (player.y - 3) >= 1 then
            if dungeon[player.y-3][player.x-1] == 1 then render_3d_wall("3L") end
            if dungeon[player.y-3][player.x+1] == 1 then render_3d_wall("3R") end
            if dungeon[player.y-3][player.x] == 1 then render_3d_wall("3C") end	
        end
        
        if (player.y - 2) >= 1 then
            if dungeon[player.y-2][player.x-1] == 1 then render_3d_wall("2L") end
            if dungeon[player.y-2][player.x+1] == 1 then render_3d_wall("2R") end
            if dungeon[player.y-2][player.x] == 1 then render_3d_wall("2C") end
        end
        
        if dungeon[player.y-1][player.x-1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y-1][player.x+1] == 1 then render_3d_wall("1R") end
        if dungeon[player.y-1][player.x] == 1 then	render_3d_wall("1C") end
        
        if dungeon[player.y][player.x-1] == 1 then render_3d_wall("0L") end
        if dungeon[player.y][player.x+1] == 1 then render_3d_wall("0R") end
        
    elseif (player.d == 1) then
        if dungeon[player.y-1][player.x+3] == 1 then render_3d_wall("3L") end
        if dungeon[player.y+1][player.x+3] == 1 then render_3d_wall("3R") end
        if dungeon[player.y][player.x+3] == 1 then render_3d_wall("3C") end	
        
        if dungeon[player.y-1][player.x+2] == 1 then render_3d_wall("2L") end
        if dungeon[player.y+1][player.x+2] == 1 then render_3d_wall("2R") end
        if dungeon[player.y][player.x+2] == 1 then render_3d_wall("2C") end

        if dungeon[player.y-1][player.x+1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y+1][player.x+1] == 1 then render_3d_wall("1R") end
        if dungeon[player.y][player.x+1] == 1 then	render_3d_wall("1C") end
        
        if dungeon[player.y-1][player.x] == 1 then render_3d_wall("0L") end
        if dungeon[player.y+1][player.x] == 1 then render_3d_wall("0R") end
    elseif (player.d == 2) then
        if (player.y + 3) <= 16 then
            if dungeon[player.y+3][player.x+1] == 1 then render_3d_wall("3L") end
            if dungeon[player.y+3][player.x-1] == 1 then render_3d_wall("3R") end
            if dungeon[player.y+3][player.x] == 1 then render_3d_wall("3C") end	
        end
        
        if (player.y + 2) <= 16 then
            if dungeon[player.y+2][player.x+1] == 1 then render_3d_wall("2L") end
            if dungeon[player.y+2][player.x-1] == 1 then render_3d_wall("2R") end
            if dungeon[player.y+2][player.x] == 1 then render_3d_wall("2C") end
        end
        
        if dungeon[player.y+1][player.x+1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y+1][player.x-1] == 1 then render_3d_wall("1R") end
        if dungeon[player.y+1][player.x] == 1 then	render_3d_wall("1C") end
        
        if dungeon[player.y][player.x+1] == 1 then render_3d_wall("0L") end
        if dungeon[player.y][player.x-1] == 1 then render_3d_wall("0R") end
    elseif (player.d == 3) then
        if dungeon[player.y+1][player.x-3] == 1 then render_3d_wall("3L") end
        if dungeon[player.y-1][player.x-3] == 1 then render_3d_wall("3R") end
        if dungeon[player.y][player.x-3] == 1 then render_3d_wall("3C") end	
        
        if dungeon[player.y+1][player.x-2] == 1 then render_3d_wall("2L") end
        if dungeon[player.y-1][player.x-2] == 1 then render_3d_wall("2R") end
        if dungeon[player.y][player.x-2] == 1 then render_3d_wall("2C") end

        if dungeon[player.y+1][player.x-1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y-1][player.x-1] == 1 then render_3d_wall("1R") end
        if dungeon[player.y][player.x-1] == 1 then	render_3d_wall("1C") end
        
        if dungeon[player.y+1][player.x] == 1 then render_3d_wall("0L") end
        if dungeon[player.y-1][player.x] == 1 then render_3d_wall("0R") end
    end

    if showmap then
        render_dungeon_map()
    end
    
    --debug		
    print("x: ".. player.x .. " y: " .. player.y .. " d: " .. player.d,20,0,7) 
  
end


__gfx__
000000007777777770000000777777776666666660000000666666665555555550000000555555551111111110000000111111112222ddddeeeeddddeeee7777
000000007777777777000000777777706666666666000000666666605555555555000000555555501111111111000000111111102222ddddeeeeddddeeee7777
007007007777777777700000777777006666666666600000666666005555555555500000555555001111111111100000111111002222ddddeeeeddddeeee7777
000770007777777777770000777770006666666666660000666660005555555555550000555550001111111111110000111110002222ddddeeeeddddeeee7777
00077000777777777777700077770000666666666666600066660000555555555555500055550000111111111111100011110000dddd2222ddddeeee7777eeee
00700700777777777777770077700000666666666666660066600000555555555555550055500000111111111111110011100000dddd2222ddddeeee7777eeee
00000000777777777777777077000000666666666666666066000000555555555555555055000000111111111111111011000000dddd2222ddddeeee7777eeee
00000000777777777777777770000000666666666666666660000000555555555555555550000000111111111111111110000000dddd2222ddddeeee7777eeee
22221111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22221111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22221111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22221111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11112222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11112222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11112222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11112222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
