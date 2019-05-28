pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	function create_part(x,y,d,r,s,c)
		p={}
		p.x=x
		p.y=y
		p.d=d
		p.r=r
		p.s=s
		p.c=c
		return p
	end
	
	cos1 = cos function cos(angle) return cos1(angle/(3.1415*2)) end
	sin1 = sin function sin(angle) return sin1(-angle/(3.1415*2)) end
	
	particles = {}
end

function _update60()
	if btnp(5) then
		cx=flr(rnd(110))+10
		cy=flr(rnd(110))+10
		for n=1,30 do
			add(particles,create_part(cx,cy,flr(rnd(360)),flr(rnd(3)),flr(rnd(3))+1,10))
		end
	end
		
	for p in all(particles) do
		p.x += cos(p.d) * p.s
		p.y += sin(p.d) * p.s
		
		if p.x < 0 or
					p.x > 127 or
					p.y < 0 or
					p.y > 127 
		then
			del(particles,p)
		end
	end
end

function _draw()
 cls()
 
	for p in all(particles) do
		circfill(p.x,p.y,p.r,p.c)
	end
	
	print(#particles)
end
