pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function _init()
	--poke(0x5f2d,0x1) -- mouse

 cy=64 						-- horizon
 h0,h1=64,18 -- half height: near/far edge
 mx,my=0,0			-- top-left map cell (wall texture)
 uw,vh=2,2		 -- map cells to render
 distance=4		-- how may walls you see
 
 leveldesign=[[
11111111
11010011
10000001
11011011
11001001
10011011
11001011
11011001
11111111
]]
	mapdata=create_level_map(leveldesign)
	mapdata[5][3]["floor"] = 5
	mapdata[3][4]["floor"] = 6
	player={
		x=3,
		y=7,
		dir=1,
	} 
	vectors = {
	  {c={0,-1},l={-1,0},r={1,0}},
	  {c={1,0}, l={0,-1},r={0,1}},
	  {c={0,1}, l={1,0}, r={-1,0}},
	  {c={-1,0},l={0,1}, r={0,-1}}
 	}
	
end

function _update60()
 --mousex=stat(32)
 --mousey=stat(33)
  
 -- player movement
 if btnp(➡️) then
  player.dir += 1
  if player.dir > 4 then
  	player.dir = 1
  end
 end
 if btnp(⬅️) then
  player.dir -= 1
  if player.dir < 1 then
  	player.dir = 4
  end
 end
 
 if btnp(⬆️) then
  local cx=player.x+vectors[player.dir].c[1] * 1
  local cy=player.y+vectors[player.dir].c[2] * 1
 	if tonum(mapdata[cy][cx].tile) == 0 then
 		player.x=cx
 		player.y=cy		
 	end
	end
	
 if btnp(⬇️) then
  local cx=player.x-vectors[player.dir].c[1] * 1
  local cy=player.y-vectors[player.dir].c[2] * 1
 	if tonum(mapdata[cy][cx].tile) == 0 then
 		player.x=cx
 		player.y=cy		
 	end
	end
end

function _draw()
	cls()
	
	-- render floor
	rectfill(0,127,127,113,6)
	rectfill(0,113,127,100,13)
	rectfill(0,100,127,95,5)
	rectfill(0,95,127,90,1)
	
	-- render 3d view
	for dist=3,0,-1 do
  local cx=player.x+vectors[player.dir].c[1] * dist
  local cy=player.y+vectors[player.dir].c[2] * dist
  local lx=cx + vectors[player.dir].l[1]
  local ly=cy + vectors[player.dir].l[2]
  local rx=cx + vectors[player.dir].r[1]
  local ry=cy + vectors[player.dir].r[2]
  
  -- check bounds and render walls
  if cx >= 1 and 
  			cx <= #mapdata[1] and
  			cy >= 1 and
  			cy <= #mapdata
  then
  	-- left wall
  	if lx >= 1 and
  	   lx <= #mapdata[1] and
  	   ly >= 1 and
  	   ly <=  #mapdata
  	then
  	 -- floor object
  	 if tonum(mapdata[ly][lx].floor) > 0 then
	 	  	floor(dist,1,tonum(mapdata[ly][lx].floor))
  	 end

  	 if tonum(mapdata[ly][lx].tile) > 0 then
  	  if dist > 0 then
	  	  frontwall(dist-1,1,dist*2,0)
  	  end
  	 	sidewall(dist,1,dist*2,0)	
  	 end
  	end
  	
  	-- right wall
  	if rx >= 1 and
  	   rx <= #mapdata[1] and
  	   ry >= 1 and
  	   ry <=  #mapdata
  	then
  	 -- floor object
  	 if tonum(mapdata[ry][rx].floor) > 0 then
	 	  	floor(dist,-1,tonum(mapdata[ry][rx].floor))
  	 end
 	 	
  	 if tonum(mapdata[ry][rx].tile) > 0 then
  	  if dist > 0 then
	  	  frontwall(dist - 1,-1,dist*2,0)
  	  end
  	 	sidewall(dist,-1,dist*2,0)	
  	 end
  	end
  	
  	-- center wall
 	 -- floor object
  	 if tonum(mapdata[cy][cx].floor) > 0 then
	 	  	floor(dist,0,tonum(mapdata[cy][cx].floor))
  	 end
	 	
  	if tonum(mapdata[cy][cx].tile) > 0 then
			 frontwall(dist - 1,0,dist*2,0)
			end	 				
  end
 end
 
 -- automap
	render_map(mapdata)
	
	-- hud
 print("x:"..player.x.." y:"..player.y.." dir:"..player.dir,16,0,8)	
	
	-- mouse
	--circfill(mousex,mousey,1,8)
	--print("x: "..mousex.." y: " ..mousey)
end

-->8
-- utils
----------------------------------------

-- sidewall(zindex,dir,texture_x,texture_y)
--  * z-index: how far is the wall in the distance
--  * dir: left or right (1,-1)
--  * texture_x,_y: the map-cell (x,y) to render
function sidewall(zindex,dir,texture_x,texture_y)
	local zfar=h0/h1
	local z0=1+(zfar-1)*zindex/distance
	local z1=1+(zfar-1)*(zindex+1)/distance
	local cx=63.5
	local x0,x1
		
	-- left
	if dir==1 then
		x0=flr(cx-h0/z0)
		x1=flr(cx-h0/z1)
 --right
	else
		x0=127-flr(cx-h0/z0)
		x1=127-flr(cx-h0/z1)
	end

	for x=x0,x1,dir do
		if x>=0 and x<=127 then
			local h=abs(x-cx)
			local z=h0/h
			local t=(z-z0)/(z1-z0)
			local u=texture_x+uw*t
			tline(x,cy-h,x,cy+h,u,texture_y,0,vh/(2*h))
		end
	end
	
	-- object
--	local x=ceil(x0+(x1-x0)/2)		
--	local y=127-x
--	circfill(x,y,1,8)	  
--	circfill(x,64,1,8)	  
--	circfill(x,x,1,8)	  
end

-- frontwall(zindex,dir,texture_x,texture_y)
--  * z-index: how far is the wall in the distance
--  * dir: left or right or center (1,-1,0)
--  * texture_x,_y: the map-cel
function frontwall(zindex,dir,texture_x,texture_y)
	local zfar=h0/h1
	local z=1+(zfar-1)*(zindex+1)/distance
	local cx=64
	local h=h0/z
	local edge=flr(cx-h0/z)
	local x0,x1

	-- left
	if dir==1 then
		x0=-32+zindex*8
		x1=edge
	-- right
	elseif dir == -1 then
		x0=127-edge
		x1=127+(32-zindex*8)
	-- center
	elseif dir == 0 then
		x0=flr(cx-h)
		x1=flr(cx+h)
	end
	for x=x0,x1 do
		local t=(x-x0)/(x1-x0)
		local u=texture_x+uw*t
		tline(x,cy-h,x,cy+h,u,texture_y,0,vh/(2*h))
	end
	
	-- object
--	 if dir == 1 then
--  	circfill(zindex*8,cy+h,1,9)
--  	circfill(zindex*8,64,1,9)
--  	circfill(zindex*8,cy-h,1,9)
--		elseif dir == -1 then
--  	circfill(127-zindex*8,cy+h,1,9)
--  	circfill(127-zindex*8,64,1,9)
--  	circfill(127-zindex*8,cy-h,1,9)
--		elseif dir == 0 then
--  	circfill(64,cy+h,1,9)
--  	circfill(64,64,1,9)
--  	circfill(64,cy-h,1,9)
--		end
end

--	floor(zindex,dir,sprite)
--  * z-index: how far is the wall in the distance
--  * dir: left or right or center (1,-1,0)
--  * sprite: sprite to render (index)
function floor(zindex,dir,sprite)
	local zfar=h0/h1
	local cx=64
	local z0=1+(zfar-1)*zindex/distance
	local z1=1+(zfar-1)*(zindex+1)/distance
	local scale=(h0/z0+h0/z1)/2
	local depth=(z0+z1)/8
	local size=max(1,flr(8/depth))
	local y=(cy-2)+scale
	local x=cx
	local sx=(sprite%16)*8
	local sy=flr(sprite/16)*8
	
	if dir == 1 then
		x=zindex*8
	elseif dir == -1 then
		x=127-zindex*8
	end
	
	--circfill(x,y,1,10)
	sspr(sx,sy,8,8,x-size/2,y-size/2,size,size)
end

-- create_level_map(data) 
--		* data: mapdata as a string bitfield with newlines
function create_level_map(data) 
 local dataarray={}
 local rows=split(data,"\n",false)
 
 for y=1,#rows do
  local cols=split(rows[y],"",false)
		if #cols > 0 then
		 for c=1,#cols do
		 	cols[c] = {floor=0,tile=cols[c]}
		 end
			add(dataarray,cols)
		end
 end
 
 return dataarray
end

-- render_map(data)
-- 	* data: 2d array of the mapdata
function render_map(data)
 local size=2
 local colm=7
 local colp=8
  
 for y=1,#data do
  for x=1,#data[y] do
   if data[y][x].tile == "1" then
    local x = x - 1
    local y = y - 1
	   rectfill(x*size,y*size,x*size+1,y*size+1,colm)
	  end
	  if x == player.x and y == player.y then
    local x = x - 1
    local y = y - 1
	  	rectfill(x*size,y*size,x*size+1,y*size+1,colp)
	  end 
  end
 end
end

__gfx__
0000000066666667ddddddd655555556111111150004000008800082000000000000000000000000000000000000000000000000000000000000000000000000
0000000066666667ddddddd655555556111111150009400028e80888000000000000000000000000000000000000000000000000000000000000000000000000
0070070066666667ddddddd65555555611111115002942008e7e8888000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777776666666666666666555555550042224088e88888000000000000000000000000000000000000000000000000000000000000000000000000
0007700066676666ddd6dddd55565555111511110299442008888880000000000000000000000000000000000000000000000000000000000000000000000000
0070070066676666ddd6dddd55565555111511114422224402888820000000000000000000000000000000000000000000000000000000000000000000000000
0000000066676666ddd6dddd55565555111511112944444200888800000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777776666666666666666555555551299442111188111000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101020203030404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101020203030404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
