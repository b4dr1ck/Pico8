pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

-- create new ball object
function new_ball(img,x,y,h,w,spd)
 return {
  img = img,
  x = x,
  y = y,
  h = h,
  w = w,
  speedx = spd,
  speedy = spd
 }
end

-- aabb collision
function collision(obj1,obj2,offset) 
 return(
  obj1.x + offset < obj2.x + obj2.w - offset and
  obj1.x + obj1.w - offset > obj2.x + offset and
  obj1.y + offset < obj2.y + obj2.h - offset and
  obj1.y + obj1.h - offset > obj2.y	+ offset 
 )

end

function _init()
 poke(0x5f2d, 0x1) -- enable mouse
 
 mouse_clicked=0
	balls={}					
end

function _update60()
 -- mouse coordinates
 mousex=stat(32)
 mousey=stat(33)
 mouseb=stat(34)
 
 -- mouse clicked lmb: create ball
 if mouse_clicked == 1 then
  
  if mousex < 120 and
     mousex > 4 and
     mousey < 120 and
     mousey > 4
  then
  	local img=flr(rnd(5)) + 1  
  
	 	add(balls,new_ball(img,mousex-4,mousey-4,8,8,1))	
	 else
	 	sfx(2)
	 end
 end

 if mouseb == 1
 then
  mouse_clicked+=1
 elseif mouseb == 0 then
	 mouse_clicked=0	
 end

 -- ball movement
 -- and collisions
 for ball in all(balls) do
 
  -- destroy ball on rmb
  if mouseb == 2 then
   local mouseobj = {
    x=mousex,y=mousey,w=1,h=1
   }
   
   if collision(ball,mouseobj,0) then
    del(balls,ball)
    sfx(2)
   end 
  end
 
  -- speed x
 	ball.x+=1*ball.speedx
 	
 	-- out of border
		if ball.x > 128 - ball.w or 
					ball.x < 0 
		then
		 ball.speedx *= -1
   sfx(0)
		end
		
		-- speed y
		ball.y+=1*ball.speedy
		
		-- out of border
		if ball.y > 128 - ball.h or
		   ball.y < 0 
		then
		 ball.speedy *= -1
		 sfx(0)		
		end
		
		-- collide other ball
		for ball2 in all(balls) do
		 if ball2 != ball then
			 if collision(ball,ball2,2) then
			  -- center-to-center vector decides collision axis
			  local dx = (ball.x+ball.w/2) - (ball2.x+ball2.w/2)
			  local dy = (ball.y+ball.h/2) - (ball2.y+ball2.h/2)

			  if abs(dx) > abs(dy) then
			   -- side-on hit: only flip if still moving toward each other
			   if (dx < 0 and ball.speedx > 0) or (dx > 0 and ball.speedx < 0) then
			    ball.speedx *= -1
			   end
			   if (dx > 0 and ball2.speedx > 0) or (dx < 0 and ball2.speedx < 0) then
			    ball2.speedx *= -1
			   end
			  else
			   -- top/bottom hit
			   if (dy < 0 and ball.speedy > 0) or (dy > 0 and ball.speedy < 0) then
			    ball.speedy *= -1
			   end
			   if (dy > 0 and ball2.speedy > 0) or (dy < 0 and ball2.speedy < 0) then
			    ball2.speedy *= -1
			   end
			  end
			  sfx(0)
			 end
		 end
		end
		
	end 
end

function _draw()
 cls(0)
 
-- fillp(0b0101101001011010)
 fillp(0b0011001111001100)
 rectfill(0,0,127,127,0x01)
 fillp(0)
 
 -- balls
 for ball in all(balls) do
	 spr(ball.img,ball.x,ball.y)
	end
	
	-- mouse cursor
 rectfill(mousex,mousey,mousex,mousey,8)
 
 print("balls: "..#balls,0,0,7)
end
__gfx__
000000000088880000bbbb0000cccc0000aaaa0000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008ee88200baabb300c77ccd00affaa900d66dd5000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007008efee882ba7aabb3c7777ccdaf7ffaa9d6766dd500000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700081ee8182b1aab1b3c177c1cda1ffa1a9d166d1d500000000000000000000000000000000000000000000000000000000000000000000000000000000
000770008e888e22babbba33c7ccc7dda7aaa799d6ddd65500000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888221bbbbb335cccccdd1aaaaa994ddddd55100000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002222210033333500ddddd10099999400555551000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000012210000533500001dd100004994000015510000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00000000160701506014060130601206012060100600f0500e0500d0500c0500b0500a0500a050090500905008050080500705005050060500505004050030500305002050020500205001050000500105001050
000100001215012150111501015010150101500f1500f1500f1500e1500d1500b1500a15009150081500815007150061500515005150041500315003150021500115000150001500015000150001500015000150
0001000014050100500d0500c0500a0500905008050070500605006050060500605006050060500605006050070500805009040090400a0300b0300d0300e0300f0301003012030160301a0301e030210302a030
000100001435012350103500f3500e3500d3500c3500b3500a3500935007350073500635005350053500435004350033500235002350023500235001350013500135001350013500135001350003500035000350
