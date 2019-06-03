pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
 x=64
 y=64
 w=7
 h=7
 x_speed=0
 y_speed=0
 max_speed=3
end

function _update60()
 -- movement
 -- 	left
 if btn(0) then
  if (x_speed < max_speed) then
   x_speed -= 0.125
  end
 end
 --  right
 if btn(1) then
  if (x_speed < max_speed) then
   x_speed += 0.125
  end
 end
 --  up
 if btn(2) then
  if (y_speed < max_speed) then
   y_speed -= 0.125
  end
 end
 --  down
 if btn(3) then
  if (y_speed < max_speed) then
   y_speed += 0.125
  end
 end
 
 -- friction
 --  left
 if not btn(1) then
  if x_speed > 0 then
   x_speed -= 0.125
   end
 end
 --  right
 if  not btn(0) then
  if x_speed < 0 then
   x_speed += 0.125
   end
 end
 --  up
 if not btn(3) then
  if y_speed > 0 then
   y_speed -= 0.125
   end
 end
 --  down
 if  not btn(2) then
  if y_speed < 0 then
   y_speed += 0.125
   end
 end
 
 -- add speed to x and y
 x+=x_speed
 y+=y_speed
 
 
 -- collision
 --  left
 if x < 0 then
--   while x <0  do
--   	x+=1 
--   end
--			x_speed=0
   x_speed = max_speed
 end
 --  right
 if x >120 then
--   while x > 120 do
--   	x-=1
--   end
--   x_speed = 0
		x_speed = -max_speed
 end
 --  up
 if y < 0 then
--   while y <0  do
--   	y+=1 
--   end
--   y_speed = 0
		y_speed = max_speed
 end
 --  down
 if y >120 then
--   while y > 120 do
--   	y-=1
--   end
--   y_speed = 0
		y_speed = -max_speed
 end
end

function _draw()
	cls(7)
	rectfill(x,y,x+w,y+h,8)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
