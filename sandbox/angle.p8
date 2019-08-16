pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init() 
 function new_box()
  box={}
  box.x=flr(rnd(100))+10
  box.y=flr(rnd(100))+10
  box.angle=flr(rnd(359))
  box.xspeed=2
  box.yspeed=2
  box.color = flr(rnd(15))+1
  box.size = flr(rnd(7))+1
  return box
 end

 amount=10
 boxes={}
	cos1 = cos function cos(angle) return cos1(angle/(3.1415*2)) end
	sin1 = sin function sin(angle) return sin1(-angle/(3.1415*2)) end
	
	for i=1,amount do
  add(boxes,new_box())
 end
end

function _update60()
 if btnp(4) then
	 add(boxes,new_box())
 end

 if btnp(5) then
	 del(boxes,boxes[#boxes])
 end


 for box in all(boxes) do
	 box.x = box.x + cos(box.angle) * box.xspeed
	 box.y = box.y + sin(box.angle) * box.yspeed
	 
	 if box.x > 127 - box.size or box.x < box.size then 
		 box.xspeed *= -1 
		end
	 if box.y > 127 - box.size or box.y < box.size then 
		 box.yspeed *= -1 
		end
		
 end
end

function _draw()
 cls()
 print("boxes: " .. #boxes,0,0,7)
	for box in all(boxes) do
	 rectfill(box.x,box.y,box.x+box.size,box.y+box.size,box.color)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
