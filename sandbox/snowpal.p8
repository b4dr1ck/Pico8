pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include ../functions.p8

function particle(x,y,spd) 
	p={}
	p.x = x
	p.y = y
	p.spd = spd

	return p
end

function snowflake(x,y,bon,spd,img)
	s={}
	s.img=img
	s.x = x
	s.y = y
	s.bon = bon
	s.spd = spd
	
	return s
end

function wall(x,y,spd,img) 
	w={}
 w.x=x
	w.y=y
	w.yspeed=spd
	w.img=img
	
	return w
end

game_over=false

player={
 x=64,
 y=64,
 xspd=0,
 yspd=0,
 maxspd=2,
 img=16,
 hp=100
}

snowflakes={}
particles={}

levelspd=1
game_timer=0
counter=0
counter2=0
counter3=0
counter2limit=100

walls={}
walls2={}
for i=0,16 do
 rndimg=flr(rnd(3)) + 1
	add(walls,wall(0,i*8,levelspd,rndimg))
 rndimg=flr(rnd(3)) + 1
	add(walls2,wall(120,i*8,levelspd,rndimg))
end

function _update()
 counter+=1
 counter2+=1
 counter3+=1
 game_timer+=1
 
 -- spawner
 if game_timer > 90 then
	 game_timer=0
 end
 
 if game_timer == 45 then
 	player.hp -= 1
 end
 
 if game_timer % 20 == 0 then
 	rndx=flr(rnd(3))-1
 	rndy=flr(rnd(3))-1
 	add(particles,particle(player.x + rndx,player.y + rndy,2))
 	rndx=flr(rnd(3))
 	rndy=flr(rnd(3))
 	add(particles,particle(player.x + rndx,player.y + rndy,2))
 	rndx=flr(rnd(3))+1
 	rndy=flr(rnd(3))+1
 	add(particles,particle(player.x + rndx,player.y + rndy,2))
 end
 
	if counter == 8 then
	 rndimg=flr(rnd(3)) + 1
		add(walls,wall(0,128,levelspd,rndimg))
	 rndimg=flr(rnd(3)) + 1
		add(walls2,wall(120,128,levelspd,rndimg))
		counter=0
	end
	
	if counter2 == counter2limit then
 	counter2limit=flr(rnd(60))+60
	 rndx=flr(rnd(100)) + 1
	 rndblocksize=flr(rnd(4)) + 1
 
	 if rndblocksize == 0 then
			add(walls,wall(rndx,128,levelspd,4))	
			add(walls,wall(rndx+8,128,levelspd,5))	
			add(walls,wall(rndx+16,128,levelspd,6))
	 elseif rndblocksize == 1 then
			add(walls,wall(rndx,128,levelspd,4))	
			add(walls,wall(rndx+8,128,levelspd,6))	
	 elseif rndblocksize == 2 then
 		add(walls,wall(rndx,128,levelspd,7))	
	 elseif rndblocksize == 3 then
			add(walls,wall(rndx,128,levelspd,4))	
			add(walls,wall(rndx+8,128,levelspd,5))	
			add(walls,wall(rndx+16,128,levelspd,5))	
			add(walls,wall(rndx+24,128,levelspd,6))
	 end
		counter2=0	
	end
	
	if counter3 == 200 then
		counter3=0
		randx=flr(rnd(112)) + 8
		add(snowflakes,snowflake(randx,128,10,1,32))
	end
	
	-- create objects and walls
	for s in all(snowflakes) do
		s.y -= s.spd
		s.img = animate(s.img,32,33,10,true)
 	if s.y < -8 then
 		del(snowflakes,s)
 	end
	end
	
 for w in all(walls) do
 	w.y -= w.yspeed
 	if w.y < -8 then
 		del(walls,w)
 	end
 end
 
 for w in all(walls2) do
 	w.y -= w.yspeed
 	if w.y < -8 then
 		del(walls2,w)
 	end
 end
  
 for p in all(particles) do
  p.y -= p.spd
 	if p.y < -8 then
 		del(particles,p)
 	end	
 end 
  
	-- acceleration
	-- 	left
	player.img = 16
 if btn(0) then
  if (player.xspd > -player.maxspd) then
   player.xspd -= 0.125
   player.img=19
  end
 end
 --  right
 if btn(1) then
  if (player.xspd < player.maxspd) then
   player.xspd += 0.125
   player.img=18
  end
 end
 --  up
 if btn(2) then
  if (player.yspd > -player.maxspd) then
   player.yspd -= 0.125
  end
 end
 --  down
 if btn(3) then
  if (player.yspd < player.maxspd) then
   player.yspd += 0.125
  end
 end
 
 -- friction
 --  left
 if not btn(1) then
  if player.xspd > 0 then
   player.xspd -= 0.125
   end
 end
 --  right
 if  not btn(0) then
  if player.xspd < 0 then
   player.xspd += 0.125
   end
 end
 --  up
 if not btn(3) then
  if player.yspd > 0 then
   player.yspd -= 0.125
   end
 end
 --  down
 if not btn(2) then
  if player.yspd < 0 then
   player.yspd += 0.125
   end
 end
  
 -- snowfklakes collision 
 for s in all(snowflakes) do
  if bb_collision(player,s) then
  	player.hp += s.bon
  	if player.hp > 100 then
  		player.hp = 100
  	end
			del(snowflakes,s)  	
  end
 end
 
 -- collisions 
 for w in all(walls) do
	 if bb_collision(player,w) then
	  player.hp-=1
	  player.img = 17
		end
	end
	
 for w in all(walls2) do
	 if bb_collision(player,w) then
	  player.hp-=1
	  player.img = 17
		end
	end
	
	-- add speed to player
 player.x+=player.xspd
 player.y+=player.yspd
 
 -- game over
 if player.hp <= 0 then
 	game_over=true
 	player.hp=0
 end
 
end

function _draw()
	cls(0)
 for w in all(walls) do
		spr(w.img,w.x,w.y)
	end
	
	for w in all(walls2) do
		spr(w.img,w.x,w.y,1,1,true)
	end
	
	for s in all(snowflakes) do
		spr(s.img,s.x,s.y)
	end
	
	-- player
 for p in all(particles) do
 	circfill(p.x,p.y,1,12)
 end
 
	spr(player.img,player.x,player.y)
	
	print("★"..player.hp.."%",1,1,12)

end

__gfx__
00000000112890001122000011289000000008999928898989900000009998000000000000000000000000000000000000000000000000000000000000000000
00000000128800001280000012888890000988288212222822890000098888900000000000000000000000000000000000000000000000000000000000000000
00700700112800001890000022122880009888828211882218888900882888880000000000000000000000000000000000000000000000000000000000000000
00077000182890001890000018212889008882218882822121128880821228880000000000000000000000000000000000000000000000000000000000000000
00077000182289001880000018212888088822828212882182228880882888220000000000000000000000000000000000000000000000000000000000000000
00700700218889002189000021822288088282212112112811822880218288880000000000000000000000000000000000000000000000000000000000000000
00000000111828001118900011182228008882112218828811222880028882100000000000000000000000000000000000000000000000000000000000000000
00000000112180001288800011222880000288228220002800122800002112000000000000000000000000000000000000000000000000000000000000000000
00777700008888000077770000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17777761288888821177777667777711000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61111116888888886611111111111166000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61166116888888886611661111661166000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76677667888888887667766776677667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67777776888888886777777667777776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d7777d0028888200d7777d00d7777d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d66d000028820000d66d0000d66d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0700700700c0c0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c0c0c0000dcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dcd0007ccccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07ccccc7000dcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000dcd0000c0c0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c0c0c0070070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07007007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
