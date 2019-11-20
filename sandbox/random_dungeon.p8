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
                spr(7,x*8,y*8)
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
                spr(7,x*8,y*8)
            end
        end
    end
    if position == "3C" then
        for x=5,10  do
            for y=5,10 do
                spr(7,x*8,y*8)
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
                spr(4,x*8,y*8)
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
                spr(4,x*8,y*8)
            end
        end
    end   
    if position == "2C" then
        for x=3,12  do
            for y=3,12 do
                spr(4,x*8,y*8)
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
            spr(1,0*8,y*8)
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
            spr(1,15*8,y*8)
        end
    end    
    if position == "1C" then
        for x=1,14  do
            for y=1,14 do
                spr(1,x*8,y*8)
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
    showmap=false
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
    
    rectfill(0,8*8,16*8,16*8,2)
    -- rectfill(0,8*8,16*8,9*8,1)
    -- rectfill(0,15*8,16*8,16*8,4)
    -- for i=0,15 do
        -- spr(17,i*8,9*8,1,1)
    -- end
    -- for i=0,15 do
        -- spr(19,i*8,14*8,1,1)
    -- end
    
    
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
00000000777777777000000077777777666666666000000066666666555555555000000055555555111111111000000011111111000000000000000000000000
00000000777777777700000077777770666666666600000066666660555555555500000055555550111111111100000011111110000000000000000000000000
00700700777777777770000077777700666666666660000066666600555555555550000055555500111111111110000011111100000000000000000000000000
00077000777777777777000077777000666666666666000066666000555555555555000055555000111111111111000011111000000000000000000000000000
00077000777777777777700077770000666666666666600066660000555555555555500055550000111111111111100011110000000000000000000000000000
00700700777777777777770077700000666666666666660066600000555555555555550055500000111111111111110011100000000000000000000000000000
00000000777777777777777077000000666666666666666066000000555555555555555055000000111111111111111011000000000000000000000000000000
00000000777777777777777770000000666666666666666660000000555555555555555550000000111111111111111110000000000000000000000000000000
00000000111111112212222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000211121122222212242222224000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111112222222222224222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000122211222222224222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000211111122422222244222442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000212122222222422224442224000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222224422242244444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222244444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040407070b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040407070a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040407070a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040407070a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040407070a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040407070c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040709000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0106000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
