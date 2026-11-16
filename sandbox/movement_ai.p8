pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function _init()
 player={
  x=64,
  y=64,
  w=8,h=8,
  spd=1,
 }
 
 enemies={
  {
  	x=8,
  	y=8,
  	oldx=0,
  	oldy=0,
  	spd=0.5,
  	col=8,
  	move="chase",
  	spotdist=60,
  	w=8,
  	h=8
  },
  {
  	x=8,
  	y=16,
  	basey=16,
  	spd=1,
  	col=9,
  	amp=15,
  	move="sine",
  	w=8,
  	h=8
  },
  {
  	x=64,
  	y=64,
  	cx=64,
  	cy=64,
  	angle=1,
  	rad=20,
  	col=10,
  	amp=15,
  	move="orbit",
  	w=8,
  	h=8
  },
  {
  	x=120,
  	y=120,
  	spd=0.5,
  	col=12,
  	move="patrol",
  	wpindex=1,
  	waypoints={
  		{x=32,y=48},
   	{x=8,y=12},
   	{x=64,y=90},
   	{x=100,y=28},
  	},
  	w=8,
  	h=8
  },
  {
  	x=48,
  	y=48,
  	angle=0,
  	oldx=0,
  	oldy=0,
  	spd=0.5,
  	col=13,
  	move="wander",
  	w=8,
  	h=8
  },
  {
  	x=88,
  	y=88,
  	angle=0.1,
  	spd=0.5,
  	col=14,
  	move="bouncing",
  	w=8,
  	h=8
  },
  {
  	x=8,
  	y=64,
  	vx=0,
  	vy=0,
  	spd=3,
  	col=15,
  	state="wait",
  	timer=60,
  	angle=0,
  	move="dash",
  	w=8,
  	h=8
  },
  {
  	x=16,
  	y=100,
  	oldx=0,
  	oldy=0,
  	spd=1,
  	col=2,
  	move="flee",
  	spotdist=30,
  	w=8,
  	h=8
  },
 }

end

function _update60()
	-- player
	local ix = 0
 local iy = 0
	if (btn(0)) ix -= 1 -- left
 if (btn(1)) ix += 1 -- right
 if (btn(2)) iy -= 1 -- up
 if (btn(3)) iy += 1 -- down
	
	-- diagonal magic
 if (ix != 0 and iy != 0) then
    ix *= 0.70710678
    iy *= 0.70710678
 end
  
 player.x += ix * player.spd
 player.y += iy * player.spd
 
 -- leave area - wrap
 warppos=warp(player.x,player.y)
	player.x = warppos.x 
	player.y = warppos.y
 
 -- enemies
 for e in all(enemies) do

	 ----------------------------
  -- chasing player
 	if e.move == "chase" then
 	 local dx = player.x - e.x
 	 local dy = player.y - e.y
 	 local dist = sqrt(dx^2 + dy^2)
 	 
 	 if dist < e.spotdist then
	 	 e.oldx = e.x
	 	 e.x += (dx / dist) * e.spd
	 	 if aabb(e,player,0) then
	 	  e.x = e.oldx
	 	 end
	 	 
	 	 e.oldy = e.y
	 	 e.y += (dy / dist) * e.spd
	 	 if aabb(e,player,0) then
	 	  e.y = e.oldy
	 	 end
	 	end
	 	
	 ----------------------------
  -- fleeing
 	elseif e.move == "flee" then
 	 local dx = player.x - e.x
 	 local dy = player.y - e.y
 	 local dist = sqrt(dx^2 + dy^2)
 	 
 	 if dist < e.spotdist then
	 	 e.oldx = e.x
	 	 e.x -= (dx / dist) * e.spd
	 	 if aabb(e,player,0) then
	 	  e.x = e.oldx
	 	 end
	 	 if e.x > 120 or e.x < 0 then
	 	  e.x = e.oldx
	 	 end
	 	 
	 	 e.oldy = e.y
	 	 e.y -= (dy / dist) * e.spd
	 	 if aabb(e,player,0) then
	 	  e.y = e.oldy
	 	 end
	 	 if e.y > 120 or e.y < 0 then
	 	  e.y = e.oldy
	 	 end
	 	end
	 	 	
	 ----------------------------	
	 -- sine wave
	 elseif e.move == "sine" then
	 	e.x+=e.spd
	 	e.y = e.basey + sin(t() * 0.5) * e.amp	 	
	 	
	 	if e.x > 127 do
	 	 e.x = -8
	 	end
	 ----------------------------	
	 -- circular movement
	 elseif e.move == "orbit" then
	  
	  e.angle += 0.01
	  e.x = e.cx + cos(e.angle) * e.rad
	  e.y = e.cy + sin(e.angle) * e.rad
	 
	 ----------------------------	
	 -- patrol movement
	 elseif e.move == "patrol" then
	 	local target = e.waypoints[e.wpindex]
	 	local dx = target.x - e.x
	 	local dy = target.y - e.y
   local dist = sqrt(dx^2 + dy^2)
   
	 	if dist < 2 then
	 	 e.wpindex = (e.wpindex % #e.waypoints) + 1
	 	else
	 	 e.x += (dx / dist) * e.spd
	 	 e.y += (dy / dist) * e.spd
	 	end

	 ----------------------------	
	 -- wandering / bouncing
	 elseif e.move == "wander" or 
								 e.move == "bouncing" then

	  if e.move == "wander" then
				e.angle += (rnd(0.04) - 0.02)
			end
			
			e.x += cos(e.angle) * e.spd	
			e.y += sin(e.angle) * e.spd	
			
			if e.x < 0 or e.x > 120 then e.angle = 0.5 - e.angle end
			if e.y < 0 or e.y > 120 then e.angle = -e.angle end	 
			
 	----------------------------
 	-- dash
		elseif e.move == "dash" then
			if e.state == "wait" then
		 	e.timer -= 1 
			 if e.timer <= 0 then
			  e.angle = atan2(player.x - e.x, player.y - e.y)
			  e.vx = cos(e.angle) * e.spd
			  e.vy = sin(e.angle) * e.spd
			  e.state = "dash"
			  e.timer = 30
		 	end
			elseif e.state == "dash" then
			 e.x += e.vx
			 e.y += e.vy
			 e.timer -= 1
		 	if e.timer <= 0 then
			  e.state = "wait"
			  e.timer = 120
		  end
	  end
  end
 end
end

function _draw()
 cls()
 
 -- background
 for y=0,15 do
  for x=0,15 do
   rect(x*8,y*8,x*8+7,y*8+7,1)
  end
 end
 
 -- player
 print("player",player.x,player.y-6,7)
 rect(player.x,player.y,player.x+player.w-1,player.y+player.h-1,11)
 
 -- enemies
 for e in all(enemies) do
  rectfill(e.x,e.y,e.x+7,e.y+7,e.col)
  if e.move == "patrol" then
   local target = e.waypoints[e.wpindex]
   line(e.x+4,e.y+4,target.x,target.y,7)
  end
  print(e.move,e.x,e.y-6,7)
 end
end


-->8
-- utils

function aabb(obj1,obj2,offset) 
 return(
  obj1.x + offset < obj2.x + obj2.w - offset and
  obj1.x + obj1.w - offset > obj2.x + offset and
  obj1.y + offset < obj2.y + obj2.h - offset and
  obj1.y + obj1.h - offset > obj2.y	+ offset 
 )
end

function warp(x,y) 
 _x=x
 _y=y
 
 if x > 128 then
  _x = -8
 end
 if x < -8 then
  _x = 128
 end
 
 if y > 128 then
  _y = -8
 end
 if y < -8 then
  _y = 128
 end
 
 return {x=_x,y=_y}
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
