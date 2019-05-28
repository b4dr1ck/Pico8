pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
    cls()
    x=64
    y=64
    col=8
    angle=0
    ticks=0.125
    speed=0.5

end

function _update60()
    if btnp(0) then
        angle += ticks
    end

    if btnp(1) then
        angle -= ticks
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
    rect(0,0,127,127,7)
    rectfill(x,y,x+1,y+1,col)
end
