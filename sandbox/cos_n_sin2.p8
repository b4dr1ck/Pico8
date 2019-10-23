pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
    cls()
    gamecounter=0
    x=64
    y=64
    w=0
    h=0
				sizeflag=false
    destx=flr(rnd(127))
    desty=flr(rnd(127))
    col=8
    angle=atan2(destx - x, desty - y)
    speed=1
   
end

function _update60()
    if gamecounter > 500 then gamecounter = 0 end
	   gamecounter+=1
    
				if gamecounter % 100 == 0 then
				 col=flr(rnd(15)) + 1
 	   destx=flr(rnd(127))
	    desty=flr(rnd(127))
     angle=atan2(destx - x, desty - y)
     if not sizeflag then
	     w+=1
 	    h+=1
 	   else
 	    w-=1
 	    h-=1
 	   end
 	   
 	   if w > 8 or w < 1 then
 	    sizeflag = not sizeflag
 	   end
				end
    
    if angle > 1 then angle = 0 end

    if x > 127 then x = 0 end
    if x < 0 then x = 127 end
    if y > 127 then y = 0 end
    if y < 0 then y = 127 end

    x += cos(angle) * speed
    y += sin(angle) * speed
    
end

function _draw()
    rectfill(x,y,x+h,y+w,col)
	   rect(0,0,127,127,7)
end
