pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function create_circ(x,y,r,rm,move_function)
	c={}
	c.x = x
	c.y = y
	c.r = r
	c.rm = rm
	c.s = 2
	c.m = move_function
	return c
end

function idle(obj,dir)
	return
end

function move_rand(obj,dir)
	obj.x += cos(dir) * 3
	obj.y += sin(dir) * 3
end

function _init()
	circles = {}
end

function _update60()
	if btn(5) then
		add(circles, create_circ(64,64,1,5,idle))
		add(circles, create_circ(64,64,1,20,move_rand))
	end
	
	for c in all(circles) do
		c.r += c.s
		if c.r > c.rm then c.s *= -1 end
		c.m(c,1)
	end
	
end

function _draw()
	cls()
	for c in all(circles) do
		circfill(c.x,c.y,c.r,10)
	end
end

