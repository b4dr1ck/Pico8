pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
    cls()
    x=64
    y=64
    col=8
    drain_col=2
    counter=30

    drains = {}

    function create_drain(x,y) 
        drain = {}
        drain.x=x
        drain.y=y
        return drain
    end
end

function _update()
    counter+=1
    if counter == 60 then
        add(drains,create_drain(x,y))
    end
    
    if counter > 60 then counter = 0 end

    for i=1,#drains do
        drains[i].y +=0.25
    end

    if btn(0) then
        if x > 1 then
            --col=flr(rnd(16))
            x-=1
        end
    elseif btn(1) then
        if x < 125 then
            --col=flr(rnd(16))
            x+=1
        end
    end
    
    if btn(2) then
        if y > 1 then
            --col=flr(rnd(16))
            y-=1
        end
    elseif btn(3) then
        if y < 125 then
            --col=flr(rnd(16))
            y+=1
        end
    end

end

function _draw()
    rect(0,0,127,127,7)
    for i=1,#drains do
        rectfill(drains[i].x,drains[i].y,drains[i].x+1,drains[i].y+1,drain_col)
    end
    rectfill(x,y,x+1,y+1,col)
end
