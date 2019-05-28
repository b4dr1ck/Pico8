pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function create_star(x,y)
    star = {}
    star.x = x
    star.y = y

    return star
end

function _init()
    game_counter=0
    stars={}

end

function _update60()
    game_counter+=1
    if game_counter > 1000 then game_counter = 0 end

    if game_counter % 5 == 0 then 
        add(stars, create_star(flr(rnd(127)),127))
    end

    for i=1,#stars do
        stars[i].y -= 5
    end

    for n in all(stars) do
        if n.y < 0 then del(stars,n) end
    end

end

function _draw()
    cls()

    print(#stars)
    for i=1,#stars do
        rectfill(stars[i].x,stars[i].y,stars[i].x,stars[i].y,7)
    end
end
