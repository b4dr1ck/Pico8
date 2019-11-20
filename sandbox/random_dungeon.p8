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
		line(0,45,45,45,1)
		line(45,45,45,82,1)
		line(45,45,45,82,1)
		line(45,82,0,82,1)
		line(45,45,51,51,1)
		line(45,82,51,76,1)
    end
    if position == "3C" then
		line(45,45,82,45,1)
		line(82,45,82,82,1)
		line(82,82,45,82,1)
		line(45,82,45,45,1)
    end
    if position == "3R" then
		line(82,45,127,45,1)
		line(82,45,82,82,1)
		line(82,82,127,82,1)
		line(82,45,76,51,1)
		line(82,82,76,76,1)
    end
    if position == "2L" then
		line(0,29,29,29,5)
		line(29,29,45,45,5)
		line(45,45,45,82,5)
		line(45,82,29,98,5)
		line(29,98,0,98,5)
    end    
    if position == "2C" then
		line(29,29,98,29,5)
		line(98,29,98,98,5)
		line(98,98,29,98,5)
		line(29,98,29,29,5)
    end    
    if position == "2R" then
		line(82,45,98,29,5)
		line(98,29,127,29,5)
		line(127,98,98,98,5)
		line(98,98,82,82,5)
		line(82,82,82,45,5)
    end    
    
    if position == "1L" then
		line(0,10,10,10,6)
		line(10,10,29,29,6)
		line(29,29,29,98,6)
		line(29,98,10,117,6)
		line(10,117,0,117,6)
    end    
    if position == "1C" then
		line(10,10,117,10,6)
		line(117,10,117,117,6)
		line(117,117,10,117,6)
		line(10,117,10,10,6)
    end    
    if position == "1R" then
		line(98,29,117,10,6)
		line(117,10,127,10,6)
		line(127,117,117,117,6)
		line(117,117,98,98,6)
		line(98,98,98,29,6)
    end    
    
    if position == "0L" then
		line(0,0,10,10,7)
		line(10,10,10,117,7)
		line(10,117,0,127,7)
    end    
    if position == "0R" then
		line(117,10,127,0,7)
		line(127,127,117,117,7)
		line(117,117,117,10,7)
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
    
    if (player.d == 0) then
        if (player.y - 3) >= 1 then
            if dungeon[player.y-3][player.x-1] == 1 then render_3d_wall("3L") end
            if dungeon[player.y-3][player.x] == 1 then render_3d_wall("3C") end	
            if dungeon[player.y-3][player.x+1] == 1 then render_3d_wall("3R") end
        end
        
        if (player.y - 2) >= 1 then
            if dungeon[player.y-2][player.x-1] == 1 then render_3d_wall("2L") end
            if dungeon[player.y-2][player.x] == 1 then render_3d_wall("2C") end
            if dungeon[player.y-2][player.x+1] == 1 then render_3d_wall("2R") end
        end
        
        if dungeon[player.y-1][player.x-1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y-1][player.x] == 1 then	render_3d_wall("1C") end
        if dungeon[player.y-1][player.x+1] == 1 then render_3d_wall("1R") end
        
        if dungeon[player.y][player.x-1] == 1 then render_3d_wall("0L") end
        if dungeon[player.y][player.x+1] == 1 then render_3d_wall("0R") end
    elseif (player.d == 1) then
        if dungeon[player.y-1][player.x+3] == 1 then render_3d_wall("3L") end
        if dungeon[player.y][player.x+3] == 1 then render_3d_wall("3C") end	
        if dungeon[player.y+1][player.x+3] == 1 then render_3d_wall("3R") end
        
        if dungeon[player.y-1][player.x+2] == 1 then render_3d_wall("2L") end
        if dungeon[player.y][player.x+2] == 1 then render_3d_wall("2C") end
        if dungeon[player.y+1][player.x+2] == 1 then render_3d_wall("2R") end

        if dungeon[player.y-1][player.x+1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y][player.x+1] == 1 then	render_3d_wall("1C") end
        if dungeon[player.y+1][player.x+1] == 1 then render_3d_wall("1R") end
        
        if dungeon[player.y-1][player.x] == 1 then render_3d_wall("0L") end
        if dungeon[player.y+1][player.x] == 1 then render_3d_wall("0R") end
    elseif (player.d == 2) then
        if (player.y + 3) <= 16 then
            if dungeon[player.y+3][player.x+1] == 1 then render_3d_wall("3L") end
            if dungeon[player.y+3][player.x] == 1 then render_3d_wall("3C") end	
            if dungeon[player.y+3][player.x-1] == 1 then render_3d_wall("3R") end
        end
        
        if (player.y + 2) <= 16 then
            if dungeon[player.y+2][player.x+1] == 1 then render_3d_wall("2L") end
            if dungeon[player.y+2][player.x] == 1 then render_3d_wall("2C") end
            if dungeon[player.y+2][player.x-1] == 1 then render_3d_wall("2R") end
        end
        
        if dungeon[player.y+1][player.x+1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y+1][player.x] == 1 then	render_3d_wall("1C") end
        if dungeon[player.y+1][player.x-1] == 1 then render_3d_wall("1R") end
        
        if dungeon[player.y][player.x+1] == 1 then render_3d_wall("0L") end
        if dungeon[player.y][player.x-1] == 1 then render_3d_wall("0R") end
    elseif (player.d == 3) then
        if dungeon[player.y+1][player.x-3] == 1 then render_3d_wall("3L") end
        if dungeon[player.y][player.x-3] == 1 then render_3d_wall("3C") end	
        if dungeon[player.y-1][player.x-3] == 1 then render_3d_wall("3R") end
        
        if dungeon[player.y+1][player.x-2] == 1 then render_3d_wall("2L") end
        if dungeon[player.y][player.x-2] == 1 then render_3d_wall("2C") end
        if dungeon[player.y-1][player.x-2] == 1 then render_3d_wall("2R") end

        if dungeon[player.y+1][player.x-1] == 1 then render_3d_wall("1L") end
        if dungeon[player.y][player.x-1] == 1 then	render_3d_wall("1C") end
        if dungeon[player.y-1][player.x-1] == 1 then render_3d_wall("1R") end
        
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
00000000555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555556666666611111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
