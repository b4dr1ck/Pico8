pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- utlis
-- USEFULL FUNCTION 
-----------------------------

function _init()
 img=1
 balls={{x=8,y=16,dist=0}}
 balls2={
 	{x=32,y=0,spd=0.5,c=3,w=8,h=8,collide=false},
 	{x=32,y=16,spd=0.5,c=9,w=8,h=8,collide=false},
 	{x=32,y=32,spd=0.5,c=4,w=8,h=8,collide=false},
 	{x=32,y=48,spd=0.5,c=5,w=8,h=8,collide=false},
 	}
 balls3={{x=8,y=64,c=11}}
 boxes={{x=90,y=0,c=7}}
 gametimer=0
 
 -- random numbers
 random={
  rand=rand(5),
  randi=randi(5),
  randb=randb(0,5),
  randbi=randbi(0,5),
 }
 
 colormap=[[
00000000
00089000
00089000
00789700
00789700
00089000
00089000
00000000
]]
 
end

function _update()
 -- global game-timer
	gametimer+=1
	if gametimer > 1000 then
	 gametimer=0
	end
	
	-- create new objects every 60 frame
	if gametimer % 60 == 0 then
 	add(balls,{x=8,y=16,dist=0})	
 	add(balls3,{x=8,y=64,c=11})	
 	add(boxes,{x=90,y=0,c=7})
 end
 
	-----------------------------
 -- animate
 img=animate(img,1,4,0.2,true)

 -- leave_area
 for ball in all(balls) do
	 ball.x+=1
	 if leave_area(ball.x,ball.y,0,0) then
	  del(balls,ball)
	 end
	 
	 -- dist
	 ball.dist=dist({x=8,y=8},ball)
	end
	
	-- isorty
	isorty(balls2)
	for ball in all(balls2) do
	 ball.y+=ball.spd
	 if ball.y > 127 or ball.y < 0 then
	  ball.spd*=-1
	 end
	 ball.collide=false
	end
	
	-- sine-wave
	for ball in all(balls3) do
	 ball.x+=1
	 ball.y = sine_wave(64,ball.y,6,0.5)
	 if leave_area(ball.x,ball.y,0,0) then
	  del(balls3,ball)
	 end
	end
	
	for i=1,#balls2 do
	 for j=i+1,#balls2 do
	  local ball=balls2[i]
	  local ball2=balls2[j]
	  -- aabb collision
	  if aabb(ball,ball2,0) then
	   ball.collide=true
	   ball2.collide=true
	  end
	 end
	end
	
	-- tile collision
	for box in all(boxes) do
	 box.y+=1
  if tile_collision(box.x,box.y,0,0) then
  	box.c=8
  else
   box.c=7
  end	 
	 if leave_area(box.x,box.y,0,0) then
	  del(boxes,box)
	 end
	end
	
end

function _draw()
 cls()
 spr(img,8,8)
 map(0,0)
 
 -- draw image
 draw_img(colormap)
 
 for ball in all(balls) do
 	circfill(ball.x,ball.y,2,8)
 	print(ball.dist,ball.x,ball.y-8,7)
 end
 
 for ball in all(balls2) do
 	if ball.collide then 	
	 	circ(ball.x,ball.y,4,ball.c)
 	else
	 	circfill(ball.x,ball.y,4,ball.c)
 	end 
 end
 
	for ball in all(balls3) do
		circfill(ball.x,ball.y,2,ball.c)
	end
	
	for box in all(boxes) do
	 rectfill(box.x,box.y,box.x+7,box.y+7,box.c)
	end
		
end





-->8
-- animate - sprite animation
-------------------------------
-- * img(n)      current frame
-- * first(n)    first frame
-- * last(n)     last frame
-- * loop(bool)  loop animation
function animate(img,first,last,spd,loop)
 img+=spd
 if img > last + 0.9 then
  if not loop then
   return last 
  end
  img = first
 end
 
 return img
end
-->8
-- positioning

-- leave_area - check if object leaves the map
-------------------------------
-- * x(n) 	  x-position of object
-- * y(n)    y-position of object
-- * mapw(n) widht of the map
-- * maph(h) height of the map
function leave_area(x,y,mapw,maph)
  if x > 128 + mapw or 
     x < 0 or 
     y > 128 + maph or
     y < 0 
  then 
  	return true
  end
  return false
end

-- dist - calc distance between two objects
------------------------------
-- * o1(tbl)  object 1 with x,y keys 
-- * o2(tbl)  object 2 with x,y keys 
function dist(o1, o2)
  return sqrt(((o1.x+4) - o2.x)^2 + (o1.y - o2.y)^2)
end

-- isorty - insertion sort, ascending y
-------------------------------
-- * objects(tbl)  array of objects 
--                 to sort by y-axis
function isorty(objects) 
	for n=2,#objects do
		local i=n
		while i>1 and objects[i].y<objects[i-1].y do
			objects[i],objects[i-1]=objects[i-1],objects[i]
			i-=1
		end
	end
end

-- sine_wave 
------------------------------
-- * x(n)			x-position
-- * y(n) 		y-position
-- * amp(n) amplitude
-- * frq(n) frequency
function sine_wave(x,y,amp,frq)
	 local amplitude = amp
	 local frequency = frq
	 local speed = time() * 2
	 
	 return y + sin((x * frequency) + speed) * amplitude
end
-->8
-- collision detection

-- tile_collision - tile collision-detected
-------------------------------
-- * x(n)						x-position
-- * y(n) 					y-position
-- * offset(n) offset for x and y
-- * flag(n)			flag index
function tile_collision(x,y,offset,flag) 
 if has_flag(x+offset,y+offset,flag) or
    has_flag(x+7-offset,y+offset,flag) or
    has_flag(x+offset,y+7-offset,flag) or
    has_flag(x+7-offset,y+7-offset,flag) 
 then	
  return true
 end
 return false
end

-- has_flag - check if a map-tile has a certain flag set
-------------------------------
-- * x(n)				x-position
-- * y(n) 			y-position
-- * flag(n) flag index
function has_flag(x,y,flag) 
	if fget(mget(flr(x/8),flr(y/8)),flag) then
		return true
	end
	
	return false
end

-- aabb - aabb collision detection
-------------------------------
-- * obj1(tbl)		object 1 with x,y,w,h keys
-- * obj2(tbl)		object 2 with x,y,w,h keys
-- * offset(n)		offset
function aabb(obj1,obj2,offset) 
 return(
  obj1.x + offset < obj2.x + obj2.w - offset and
  obj1.x + obj1.w - offset > obj2.x + offset and
  obj1.y + offset < obj2.y + obj2.h - offset and
  obj1.y + obj1.h - offset > obj2.y	+ offset 
 )
end


-->8
-- misc

-- rand/randi - random int between 0,v
-------------------------------
-- * v(n) 	value (exclusive)
function rand(v) 
	return flr(rnd(v))
end

-- * v(n) 	value (inclusive)
function randi(v)
	return flr(rnd(v+1))
end

-- randb/randbi -- random int between f,t
-------------------------------
-- * f(n) 	from value 
-- * t(n) 	to value (exclusive)
function randb(f,t) --exclusive
	return flr(rnd(t-f))+f
end

-- * f(n) 	from value 
-- * t(n) 	to value (inclusive)
function randbi(f,t) 
	return flr(rnd(t+1-f))+f
end
-->8
-- rendering

-- draw_img - draw image of string
-------------------------------
-- * colormap(str) 	a string with color-values separated by newline
function draw_img(colormap)
	local rows=split(colormap,"\n",false)
 for y,r in pairs(rows) do
	 y-=1
	 if r then
	 	local columns=split(r,"",false) 
	 	for x,c in pairs(columns) do
	 	 if c != " " then
		 	 x-=1
		   rectfill(x,y,x,y,"0x"..c)
		  end
	 	end
	 end
 end
end

__gfx__
00000000000ff00000000000000ff000000000006666666100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009ff900000ff000009ff900000ff0006555555100000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700001ff100009ff900001ff100009ff9006555555100000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000f011110f001ff10000111100001ff1006555555100000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000444400f044440f00444400f044440f6555555100000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000c00c0000c00c00f0c00c0f00c00c006555555100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc00000c00c0000c00c0000c00c006555555100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc00000c00c000c0000c000c00c001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
