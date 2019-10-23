pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
	xspeed=0
	yspeed=0
	x=64
	y=8
	max_jump=5
	max_speed=3
end

function _update60()
 yspeed+=0.2
 
 if y>(127 - 6) then
 	yspeed = -max_jump
 	if max_jump > 0 then
	 	max_jump-=1
	 end
 end
 
 y+=yspeed
 
 if btnp(4) then
  max_jump = 5
  yspeed = -max_jump
 end
 
 if btn(0) then
 	if xspeed > -max_speed then
	 	xspeed -= 0.25
	 end
 end
 
 if btn(1) then
 	if xspeed < max_speed then
	 	xspeed += 0.25
	 end
 end
 
 if not btn(0) then
 	if xspeed < 0 then
 		xspeed += 0.25
 	end
 end
 
 if not btn(1) then
 	if xspeed > 0 then
 		xspeed -= 0.25
 	end
 end
 
 x = mid(7,x,120)
 x += xspeed
 
end

function _draw()
	cls()
	print(x)
	print(xspeed)
	circfill(x,y,7,8)
	rect(0,0,127,127,7)
end
__gfx__
00000000001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001dddd100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001d2882d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d28aa82d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d28a782d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001d2882d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001dddd100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000