pico-8 cartridge // http://www.pico-8.com
version 33
__lua__

function _init()
	
	enemies={}
	
	--create a new enemy-object
	function new_enemy(x,y,xspd,yspd,maxspd,img,flipx)
		local obj={}
		obj.x = x 
		obj.y = y
		obj.xspd = xspd
		obj.yspd = yspd
		obj.maxspd = maxspd
		obj.img = img
		obj.flipx = flipx
		return obj
	end
 
 --add enemies to the enemies-container
 add(enemies,
 			new_enemy(0,0,0,0,0.5,1,false)
 			)
 add(enemies,
 			new_enemy(127,127,0,0,0.25,2,false)
 			)
 add(enemies,
 			new_enemy(0,127,0,0,0.75,3,false)
 			)
 add(enemies,
 			new_enemy(127,0,0,0,1,4,false)
 			)
	
	-- player vars
	x=64
	y=64
	flipx=false
	size=7
	
	-- bounding-box collision-detection
	function bb_col(ex,ey,x,y,size)
		if ex < x + size and
					ex + size > x and
					ey < y + size and
					ey + size > y then
			return true
		else
			return false
		end
	end
end

function _update60()
 -- movement-control
	if btn(⬅️) then 
		x-=1
		flipx=true
	end
	if btn(➡️) then 
		x+=1
		flipx=false
	end
	if btn(⬆️) then 
		y-=1
	end
	if btn(⬇️) then 
		y+=1
	end
	
	-- leaving the area
	if x > 127 then x = 0 end
	if x < 0 then x = 127 end
	if y > 127 then y = 0 end
	if y < 0 then y = 127 end
	
	-- enemy movemnt-control
	for e in all(enemies) do
		
		a=atan2(x-e.x,y-e.y)
		e.xspd=cos(a) * e.maxspd
		e.yspd=sin(a) * e.maxspd
		
		-- enemy collision
		if not bb_col(e.x,e.y,x,y,size)
		then	
	  e.x += e.xspd
	  e.y += e.yspd
		end
		
		-- enemy flip x
		if e.x < x then
			e.flipx = false
		else
			e.flipx = true
		end
		
		-- check collision between each enemy
		for e1 in all(enemies) do
			if e != e1 then
				if bb_col(e.x,e.y,e1.x,e1.y,size)
				then
					if not bb_col(e1.x,e1.y,x,y,size)
					then	
						a1=atan2(e.x-e1.x,e.y-e1.y)
						e1.xspd=cos(a1) * e1.maxspd
						e1.yspd=sin(a1) * e1.maxspd
						e1.x -= e1.xspd
						e1.y -= e1.yspd
					end
				end
			end
		end
	end
end

function _draw()
	cls()
	-- draw player
	spr(5,x,y,1,1,flipx)
	-- draw enemies
	for e in all(enemies) do
		spr(e.img,e.x,e.y,1,1,e.flipx)
		
		-- z-index for player
		if e.y < y then
			spr(5,x,y,1,1,flipx)		
		end
		
	end
	
	
	
end
__gfx__
000000000033330000333300003333000033330000fff7f000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000038b8000038b8000038b8000038b8000ffc1f1000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700003bbb00003bbb00003bbb00003bbb0009f4444000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700005333353333333900d3333d3013333130994fff000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000335555533399999333ddddd3331111130882444000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700335555500999999333ddddd033111110ff88222f00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001111110022222200444444005555550ff88888f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011001100220022004400440055005500110011000000000000000000000000000000000000000000000000000000000000000000000000000000000
