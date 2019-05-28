pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
x=32
y=32
collide=false
end

function _update()
	
	if btn(0) and pget(x-1,y) == 0 then
		x-=1
	elseif btn(1) and pget(x+1,y) == 0 then
		x+=1
	elseif btn(2) and pget(x,y-1) == 0 then
		y-=1
	elseif btn(3) and pget(x,y+1) == 0 then
		y+=1
	end
end

function _draw()
	cls()
	map(0,0,0,0)
	spr(1,x,y)
	print("x:"..x.." y:"..y,0,8)
end


__gfx__
00000000800000005555555500000000500555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555500000000500005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000005555555500000000550000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000005555555500555500555550050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000005555555500555500555550050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000005555555500000000555000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555500000000555005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555500000000555005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003000002020402000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000202020302000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000002020402000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000020402000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
