pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function _init()
 cy=64 						-- horizon
 h0,h1=64,18 -- half height: near/far edge
 mx,my=0,0			-- top-left map cell (wall texture)
 uw,vh=2,2		 -- map cells to render
 distance=4		-- how may walls you see
 
 leveldesign=[[
11111111
11011011
10000001
11011011
10011011
11001011
11011011
11011011
11111111
]]

 mapdata=create_level_map(leveldesign)
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

function _update()
end

function _draw()
	cls()
	
	for dist=3,0,-1 do
  local cx=player.x+vectors[player.dir].c[1] * dist
  local cy=player.y+vectors[player.dir].c[2] * dist
  local lx=cx + vectors[player.dir].l[1]
  local ly=cy + vectors[player.dir].l[2]
  local rx=cx + vectors[player.dir].r[1]
  local ry=cy + vectors[player.dir].r[2]
  
  -- check bounds and render walls
  if cx >= 0 and 
  			cx < #mapdata[1] and
  			cy >= 0 and
  			cy < #mapdata
  then
  	-- left wall
  	if lx >= 0 and
  	   lx < #mapdata[1] and
  	   ly >= 0 and
  	   ly <  #mapdata
  	then
  	 if tonum(mapdata[ly][lx]) > 0 then
  	  if dist > 0 then
	  	  frontwall(dist - 1,1,2,0)
  	  end
  	 	sidewall(dist,1,2,0)	
  	 end
  	end
  	
  	-- right wall
  	if rx >= 0 and
  	   rx < #mapdata[1] and
  	   ry >= 0 and
  	   ry <  #mapdata
  	then
  	 if tonum(mapdata[ry][rx]) > 0 then
  	  if dist > 0 then
	  	  frontwall(dist - 1,-1,2,0)
  	  end
  	 	sidewall(dist,-1,2,0)	
  	 end
  	end
  	
  	-- center wall
  	if tonum(mapdata[cy][cx]) > 0 then
			 frontwall(dist - 1,0,2,0)
			end	 	
			
  end
 end

		-- z-index 3
--	sidewall(3,1,6,0)
--	sidewall(3,-1,6,0)
 --frontwall(3,0,2,0)
	--frontwall(3,-1,2,0)
 --frontwall(3,1,2,0)
	
		-- z-index 2
--	sidewall(2,1,4,0)
--	sidewall(2,-1,4,0)
 --frontwall(2,0,2,0)
	--frontwall(2,-1,2,0)
 --frontwall(2,1,2,0)
	
	-- z-index 1
--	sidewall(1,1,2,0)
--	sidewall(1,-1,2,0)
 --frontwall(1,0,2,0)
	--frontwall(1,-1,2,0)
 --frontwall(1,1,2,0)
	
	-- z-index 0
--	sidewall(0,1,0,0)
--	sidewall(0,-1,0,0)

	render_map(mapdata)
	
	print("x:"..player.x.." y:"..player.y.." dir:"..player.dir,16,0,7)	
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
	
	-- right
	if dir==1 then
		x0=flr(cx-h0/z0)
		x1=flr(cx-h0/z1)
 -- left
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
		x0=0
		x1=edge
	-- right
	elseif dir == -1 then
		x0=127-edge
		x1=127
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
end

function create_level_map(data) 
 local dataarray={}
 local rows=split(data,"\n",false)
 
 for y=1,#rows do
  local cols=split(rows[y],"",false)
		if #cols > 0 then
			add(dataarray,cols)
		end
 end
 
 return dataarray
end

function render_map(data)
 local size=2
 local colm=1
 local colp=10
  
 for y=1,#data do
  for x=1,#data[y] do
   if data[y][x] == "1" then
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
0000000066666667ddddddd655555556111111150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066666667ddddddd655555556111111150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070066666667ddddddd655555556111111150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777776666666666666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700066676666ddd6dddd55565555111511110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070066676666ddd6dddd55565555111511110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066676666ddd6dddd55565555111511110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777776666666666666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101020203030404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101020203030404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
