pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
	
function _draw()
	cls()
 for y=0,128 do
 	for x=0,128 do
 	 rectfill(x,y,x,y,flr(rnd(16)))
 	end
 end
end


