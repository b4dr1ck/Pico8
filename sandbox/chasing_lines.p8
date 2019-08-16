pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
    cls()
    gamecounter=0
    x=120
    y=120
    w=0
    h=0
    sizeflag=false
    destx=8
    desty=8
    col=8
    angle=atan2(destx - x, desty - y)
    xspeed=0.25
    yspeed=0.25
    
    
   
end

function _update60()
    if gamecounter > 500 then gamecounter = 0 end
    gamecounter+=1
    
    -- if gamecounter % 1 == 0 then

    -- end
    
    if btn(0) then destx -= 0.5 end
    if btn(1) then destx += 0.5 end
    if btn(2) then desty -= 0.5 end
    if btn(3) then desty += 0.5 end
    
    angle=atan2(destx - x, desty - y)
    
    if angle > 1 then angle = 0 end

    if x > 127 then x = 0 end
    if x < 0 then x = 127 end
    if y > 127 then y = 0 end
    if y < 0 then y = 127 end
    
    x += cos(angle) * xspeed
    y += sin(angle) * yspeed
    
    if destx > 127 then destx = 0 end
    if destx < 0 then destx = 127 end
    if desty > 127 then desty = 0 end
    if desty < 0 then desty = 127 end
    
end

function _draw()
    --cls()
    --print(destx)
    -- print(desty)
    rectfill(x,y,x+h,y+w,col)
    rectfill(destx,desty,destx,desty,7)
	rect(0,0,127,127,7)
end
