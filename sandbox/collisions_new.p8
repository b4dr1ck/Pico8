pico-8 cartridge // http://www.pico-8.com
version 33
__lua__

function _init()
	xspeed=0
	yspeed=0
	x=64
	y=64
	maxspeed=1
	acc=1
	col=7
end

function _update60()
	if btn(➡️) then
		if xspeed < maxspeed then
			xspeed+=acc
	 end
	end
	if btn(⬅️) then
		if xspeed > -maxspeed then
			xspeed-=acc
	 end
	end
	
	if btn(⬇️) then
		yspeed = maxspeed
	end
	if btn(⬆️) then
		yspeed = -maxspeed
	end
	
	if not btn(⬅️) and
			 not btn(➡️) and
 	  not btn(⬆️) and
	   not btn(⬇️) then
		if xspeed > 0 then
			xspeed-=acc 
		elseif xspeed < 0 then
			xspeed+=acc
		end
		if yspeed > 0 then
			yspeed-=acc 
		elseif yspeed < 0 then
			yspeed+=acc
		end
	end

	if fget(mget(ceil(x/8),ceil(y/8))) == 1 or
	   fget(mget(ceil((x+7)/8),ceil(y/8))) == 1 or
	   fget(mget(ceil(x/8),ceil((y+7)/8))) == 1 or
	   fget(mget(ceil((x+7)/8),ceil((y+7)/8))) == 1
	then
		col=8
	else
		col=7
	end

	x+=xspeed
	y+=yspeed
	
	
end

function _draw()
	cls()
	print("x: "..x.." y: " ..y)
	print("x: "..ceil(x/8).." y: " ..ceil(y/8))
	print("mget: "..mget(ceil(x/8),ceil(y/8)))
	print("mget: "..mget(ceil((x+8)/8),ceil(y/8)))
	print("fget: " ..fget(mget(ceil((x)/8),ceil(y/8))))
	map(1,1)
	rectfill(x,y,x+7,y+7,col)
end


__gfx__
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666616660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555515550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555515550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700166666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000155555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000155555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000