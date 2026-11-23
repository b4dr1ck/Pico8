pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function _init()
 init_player()
 init_map()
 init_rod()
 init_particles()
 init_hud()
end

function _update60()
 update_map()
 update_player()
 update_rod()
 update_particles()
 update_hud()
end

function _draw()
 cls()
 draw_map()
 draw_particles()
 draw_player()
 draw_rod()
 draw_hud()
end

-->8
-- player

function init_player()
 player={
  img=2,
  flipimg=false,
  x=64,
  y=64,
  w=8,
  h=8,
  charging=false,
  chargepower=0,
  chargespeed=0.01,
  state="idle",
  speed=1,
 }
 
 items={
  baits={39,40,41,42,43,44},
  hooks={36,37,38},
  rods={32,33,34,35},
  active_bait=1,
  active_hook=1,
  active_rod=1,
 }
 
 boat={
  active=true,
  flipimg=false,
  img=17,
 }
 
end

function update_player()
 --* player movement
 
 --** capture input
 local dx, dy = 0, 0
 if btn(⬅️) then dx -= 1 end
 if btn(➡️) then dx += 1 end
 if btn(⬆️) then dy -= 1 end
 if btn(⬇️) then dy += 1 end

 --** move on x/y-axis
 if not aim_cursor.active and
    not bobber.active and
    not player.charging and
    not fishing_options.active
 then
  player.state="move"
  if dx != 0 then
		 player.x += dx * player.speed
		elseif dy != 0 then
		 player.y += dy * player.speed
		end
 end
 
 --** idle state
 if dx == 0 and dy == 0 then
  player.state="idle"
 end
 
 --** player animations
 if not aim_cursor.active and
			 not fishing_options.active and
			 not bobber.active and
			 not player.charging
 then
  set_player_direction(dx,dy)
 end
 
 --** move aim cursor
 if aim_cursor.active then
  aim_cursor.x += dx * aim_cursor.speed
	 aim_cursor.y += dy * aim_cursor.speed

  --*** player looks to the cursor
  local aim_dx = aim_cursor.x - player.x
  local aim_dy = aim_cursor.y - player.y
  if abs(aim_dx) > abs(aim_dy) then
   set_player_direction(sgn(aim_dx),0)
  elseif aim_dy != 0 then
   set_player_direction(0,sgn(aim_dy))
  elseif aim_dx != 0 then
   set_player_direction(sgn(aim_dx),0)
  end
 end
 
 --* charging 
 --** activate charging on input
 if btnp(❎) and
 			aim_cursor.active and
 			not bobber.active and
 			not player.charging
 then
  aim_cursor.active = false
  player.charging = true
  player.chargepower = 0
 end
 
 --** load charging power
 if player.charging then
  --*** on button ❎ press
  if btn(❎) then
   player.chargepower = min(1,player.chargepower + player.chargespeed)
  --*** on release
  else 
   player.charging = false
     
   local angle = atan2(aim_cursor.x - player.x, aim_cursor.y - player.y)
   local dist = rod.types[items.active_rod].min_dist + ( rod.types[items.active_rod].max_dist -  rod.types[items.active_rod].min_dist) * player.chargepower
   local target_x = player.x + cos(angle) * dist     
   local target_y = player.y + sin(angle) * dist     
   
   --** set bobber
	  cast(player.x, player.y, target_x, target_y)
  end
 end
end


function draw_player()
	--* player
	local sine_y=player.y + sin(time()*1.0) * 2 
	
	--** shadow
	--*** boat and player
	local sprboatx,sprboaty = get_spr_ind(boat.img)
	local sprplayerx,sprplayery = get_spr_ind(player.img)
	pal(color_new(1))
 sspr(sprboatx,sprboaty,8,8,player.x,sine_y+4,8,8,false,false)
 sspr(sprplayerx,sprplayery,8,8,player.x,sine_y+6,8,8,false,true)
 pal()
 --*** rod
 if aim_cursor.active or bobber.active then
	 line(player.x+rod.xoffset,sine_y+4,player.x+rod.xoffset,sine_y+18,1)
 end
  
	--** boat sprite
	spr(boat.img,player.x,sine_y+2,1,1,boat.flipimg)
	
	--** player sprite
	spr(player.img,player.x,sine_y,1,1,player.flipimg)

 --** rod sprite
 if aim_cursor.active or 
 			bobber.active or
 			player.charging
 then
  if player.charging then
	  line(player.x+rod.xoffset+rod.chargexoffset,sine_y-4+rod.chargeyoffset,player.x+rod.xoffset,sine_y+4,4)	
  else
	  line(player.x+rod.xoffset,sine_y-4,player.x+rod.xoffset,sine_y+4,4)
  end 
 end

	--* charging bar
	if player.charging then
	 local bar_w = 14
  local bx = player.x+4 - bar_w / 2
  local by = player.y - 11
  local col = 11
  
  if player.chargepower > 0.85 then
   col = 8
  elseif player.chargepower > 0.5 then
   col = 10
  end
  
  rectfill(bx - 1, by - 1, bx + bar_w + 1, by + 3, 0)
  rectfill(bx, by, bx + bar_w, by + 2, 1)
  rectfill(bx, by, bx + bar_w * player.chargepower, by + 2, col)
	end
end

----------------------------------

--* set player direction
function set_player_direction(dx,dy)
 if dx > 0 then
  player.img=4
  boat.img=16
  player.flipimg=false
  boat.flipimg=false
  rod.xoffset=7
  rod.chargexoffset=-4
  rod.chargeyoffset=0
 elseif dx < 0 then
  player.img=4
  boat.img=16
  player.flipimg=true
  boat.flipimg=true
  rod.xoffset=0
  rod.chargexoffset=4
  rod.chargeyoffset=0
 elseif dy > 0 then
  player.img=2
  boat.img=17
  player.flipimg=false
  boat.flipimg=false
  rod.xoffset=0
  rod.chargexoffset=0
  rod.chargeyoffset=4
 elseif dy < 0 then
  player.img=3
  boat.img=18
  player.flipimg=false
  boat.flipimg=false
  rod.xoffset=7
  rod.chargexoffset=0
  rod.chargeyoffset=4
 end
end

--* cast
--** set the bobber for the casting
function cast(x1, y1, x2, y2)
 bobber.active = true
 bobber.timer = 0
 bobber.x1 = x1
 bobber.y1 = y1
 bobber.x2 = x2
 bobber.y2 = y2

 local dx = x2 - x1
 local dy = y2 - y1
 local dist = sqrt(dx * dx + dy * dy)
 
 bobber.height = mid(8, dist * 0.45, 35)
end

-->8
-- fishing rod

function init_rod()
 rod={
  types={
   {min_dist=12,max_dist=32},
   {min_dist=12,max_dist=48},
   {min_dist=12,max_dist=64},
   {min_dist=12,max_dist=96}
  },
  xoffset=0,
  chargexoffset=0,
  chargeyoffset=0,
 }
 
 bobber={
  active=false,
  x=0,y=0,z=0,x1=0,y1=0,x2=0,y2=0,
	 timer=0,
	 state="idle",
	 speed=0.025,
	 height=20,
	}
	-- flfags
	spawn_waterring=true
end

function update_rod()
 --* bobber
 if bobber.active then
  bobber.timer += bobber.speed
  if bobber.timer >= 1 then
   bobber.timer = 1
  end
  
  bobber.state="throw"
  
  --** set x/y/z coordinates
  bobber.x = bobber.x1 + (bobber.x2 - bobber.x1) * bobber.timer
  bobber.y = bobber.y1 + (bobber.y2 - bobber.y1) * bobber.timer
  bobber.z = -sin(bobber.timer * 0.5) * bobber.height
  
  --** reaches end
  if bobber.x == bobber.x2 and
     bobber.y == bobber.y2 
  then
   bobber.state="idle"
   if spawn_waterring then
	   add(water_rings,new_ring(bobber.x,bobber.y,2,0.1))
	   spawn_waterring=false
	  end
  end 
 end
   
 --** reset bobber
 if btnp(🅾️) and bobber.active then
  bobber.active = false
	 spawn_waterring=true
 end
end


function draw_rod()
 --* bobber
 if bobber.active then
  local h_factor = -sin(bobber.timer * 0.5)
  local bobber_r = 2 + h_factor * 2
  
  --** shadow
  local shadow_r = max(0.5, 2.5 - h_factor * 2)
  if bobber.state == "throw" then	  
	  circfill(bobber.x, bobber.y, shadow_r, 1)
  end
  
  --** fishing line
  local sag = 0
 	local player_sine_y=player.y + sin(time()*1.0) * 2 
  if bobber.state == "idle" then
   sag = 8 + sin(time() * 0.5) * 1
  end
  
  --*** shadow
  draw_fishing_line(player.x+rod.xoffset,player_sine_y+18, bobber.x, bobber.y - bobber.z, sag, 1)
  --*** line
  draw_fishing_line(player.x+rod.xoffset,player_sine_y-4, bobber.x, bobber.y - bobber.z, sag, 7)
  
  --** boober ball
  local bobber_y=bobber.y - bobber.z
  if bobber.state == "idle" then
   bobber_y=bobber.y2 + sin(time() * 0.5) * 1
  end
  
  circfill(bobber.x, bobber_y, bobber_r, 8)
  pset(bobber.x - bobber_r * 0.3, bobber_y -1, 7)
 end
end


-------------------------------
--* draw_fishing_line
--** draw fishing line with larp
function draw_fishing_line(x1, y1, x2, y2, sag, col)
 if sag <= 0 then
  line(x1, y1, x2, y2, col)
  return
 end

 local cx = (x1 + x2) / 2
 local cy = (y1 + y2) / 2 + sag

 local steps = 8
 local prev_x, prev_y = x1, y1

 for i = 1, steps do
  local t = i / steps
  local inv_t = 1 - t
  
  local nx = inv_t * inv_t * x1 + 2 * inv_t * t * cx + t * t * x2
  local ny = inv_t * inv_t * y1 + 2 * inv_t * t * cy + t * t * y2
  
  line(prev_x, prev_y, nx, ny, col)
  prev_x, prev_y = nx, ny
 end
end

-->8
--particles

function init_particles()
 water_rings={}
end

function update_particles()
 --* water rings
 for wr in all(water_rings) do
 	wr.r+=wr.speed
  wr.timer+=1
  if wr.timer > 120 then
   del(water_rings,wr)
  end
 end
 
end

function draw_particles()
 --* water rings
 local col=7
 for wr in all(water_rings) do
  if wr.r > 10 then
   col=13
  end
	 circ(wr.x,wr.y,wr.r,col)
 end
end

----------------------------
--* create new ring object
function new_ring(x,y,r,spd)
  return {
	  x=x,
	  y=y,
	  r=r,
	  timer=0,
	  speed=spd,
  }
end
-->8
--hud
function init_hud()
 aim_cursor={
  active=false,
  x=player.x,
  y=player.y+8,
  img=1,
  speed=1,
 }
 
 select_cursor={
  category=1,
  catname={"rod","hook","bait"}
 }
 
 fishing_options={
  active=false,
 }
 
end

function update_hud()
 --* aim cursor
 --** toggle aim cursor
 if btnp(🅾️) and 
 			not bobber.active
 then
 	aim_cursor.active = not aim_cursor.active
 	aim_cursor.x=player.x
 	aim_cursor.y=player.y+8
 end
 
 --** toggle options menu
 if btnp(❎) and
			 not bobber.active and
    not player.charging and
			 not aim_cursor.active
	then
		fishing_options.active=not fishing_options.active		  	
 end
 
 --** control select cursor
 if fishing_options.active then
  local dx, dy = 0, 0
	 if btnp(⬅️) then dx -= 1 end
	 if btnp(➡️) then dx += 1 end
	 if btnp(⬆️) then dy -= 1 end
	 if btnp(⬇️) then dy += 1 end
  
  --*** up/down
  if dy != 0 then
   printh(dy)
   select_cursor.category+=dy
   if select_cursor.category > 3 then
    select_cursor.category=1
   end
   if select_cursor.category < 1 then
    select_cursor.category=3
   end
 	end

  --*** right/left
  if dx != 0 then
   local catname=select_cursor.catname[select_cursor.category]
  	items["active_"..catname]+=dx 
  	if items["active_"..catname] > #items[catname.."s"] then
		 	items["active_"..catname]=1
  	end
  	if items["active_"..catname] < 1 then
		 	items["active_"..catname]=#items[catname.."s"]
  	end
  end
 end
end

function draw_hud()
 --* aim cursor
 if aim_cursor.active then
  spr(aim_cursor.img,aim_cursor.x,aim_cursor.y)
 end
 
	--** fishing options
	if fishing_options.active then
	 local xoffset=108+camx
	
	 --*** menu box
 	rectfill(xoffset,camy,xoffset+20,camy+64,5)
 	rect(xoffset,camy,xoffset+19,camy+65,6)
 	
		--*** items
		--**** rod
  print("\^o1ff\f7rod",xoffset+2,camy+2,7)		
  rectfill(xoffset+6,camy+10,xoffset+13,camy+17,0)  
  if select_cursor.category==1 then
	  rect(xoffset+5,camy+9,xoffset+14,camy+18,11)
	 end
  spr(items.rods[items.active_rod],xoffset+6,camy+10)
  --**** hook
  print("\^o1ff\f7hook",xoffset+2,camy+22,7)		
  rectfill(xoffset+6,camy+30,xoffset+13,camy+37,0)  
  if select_cursor.category==2 then
	  rect(xoffset+5,camy+29,xoffset+14,camy+38,11)
	 end
  spr(items.hooks[items.active_hook],xoffset+6,camy+30)
  --**** bait
  print("\^o1ff\f7bait",xoffset+2,camy+42,7)		
  rectfill(xoffset+6,camy+50,xoffset+13,camy+57,0)  
  if select_cursor.category==3 then
	  rect(xoffset+5,camy+49,xoffset+14,camy+58,11)
	 end
  spr(items.baits[items.active_bait],xoffset+6,camy+50) 
	end

 --* help
 if not aim_cursor.active and 
 			not player.charging and
 			not bobber.active and
 			not fishing_options.active
 then
	 print("\f0⬅️➡️⬆️⬇️\f1 TO MOVE\n"..
	 						"\f0❎\f1 FISHING OPTIONS\n"..
	 						"\f0🅾️\f1 START FISHING",
	 						2+camx,108+camy,1)
 elseif aim_cursor.active and 
 							not player.charging and
 							not bobber.active
 then
	 print("\f0⬅️➡️⬆️⬇️\f1 MOVE CURSOR\n"..
	 					"\f0🅾️\f1 TO CANCEL\n"..
 	      "\f0❎\f1 TO CAST",
 	      2+camx,108+camy,1)
	elseif player.charging then
 	print("HOLD \f0❎\f1",2+camx,120+camy,1)
 elseif bobber.active and bobber.state == "idle" then
 	print("\f0🅾️\f1 TO CANCEL FISHING",2+camx,120+camy,1)
 elseif fishing_options.active then 	
  print("\f0⬆️⬇️\f1 SELECT CATEGORY\n"..
						  "\f0⬅️➡️\f1 SELECT ITEM",
					   2+camx,114+camy,1)
	end
end
-->8
--map

function init_map()
 camx=0
 camy=0
end

function update_map()
 --* camera
 camx = mid(0, player.x - 64, 128) 
 camy = mid(0, player.y - 64, 0)
 end

function draw_map()
 map(0,0)
 camera(camx,camy)
end
-->8
-- utils

--* sprite index
function get_spr_ind(sp)
 return (sp % 16) * 8, (sp \ 16) * 8
end

--* recolor all colors
function color_new(col)
 return {
  [0]=col, [1]=col, [2]=col, [3]=col,
  [4]=col, [5]=col, [6]=col, [7]=col,
  [8]=col, [9]=col, [10]=col, [11]=col,
  [12]=col, [13]=col, [14]=col, [15]=col
	}
end

--* sprite animations
function animate(img,first,last,spd,loop)
 if img < last + 1 - spd then
  img+=spd
  
  if not loop then
   return last 
  end
  
 else
   img = first
 end
 return img
end
__gfx__
000000000000000000f7ff0000f7ff0000f7ff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000f1ff1f00ffffff00ffff1f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700820000280effffe00ffffff00fffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000800220080f9999f00ffffff00ffff9900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000800220080f9119f00ffeeff00fff91100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070082000028899999988effffe8088f99900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000888800ff8888ff88888888088888ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ff2222fff222222f028888ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000499999944999999400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000422222244222222400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000411111144111111400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49999994424444244244442400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41111114424444244244442400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999411111144111111400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444499999944999999400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222220024444204444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00640000006d00000068000000630000000000000000000000000000000000000000000000000000000000000000000000100010000000000000000000000000
00640000006d000000680000006300000000000000000000000005000e0000000007f00000000000000aa0000000300000010100000000000000000000000000
007040000070d00000708000007030000000060000000500000006000200000000f99f000004a900009a7a000003030000055000000000000000000000000000
006048650060d16500608265006039650000060000000600000006000072e0000097f90000499a00009aaa00bbaaab3111288211000000000000000000000000
006048800060d11000608220006039900006050000000600000006000000022e00f99f00024a99000099aa001131113300887800000000000000000000000000
0070200000702000007020000070200000005100006005000600050000072e000097f90002444400009999000030030001887811000000000000000000000000
0060020000600200006002000060020000000000000551000500010002e002e00009900000000000000000000300300010288200000000000000000000000000
00700200007002000070020000700200000000000000000000565000000000000000000000000000000000000000000000288200000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc333b3b33333bb333333b33b3b33b33333b33b33333333333c3333333c333333bccccc333111111113333433333333333cccccccc00000000
ccccccccccc5d6cc3b33333b3b3333333b3333b3333b33b33b33b33a333b33b3333b33b3c43b333bccccc33a1111111133393433399999934924492400000000
cccccccccc5667ccb33344433333444333343333333333333333333b333b33b33333b333c2333333ccccc33b1111111142443332344444434924492400000000
ccccccccc55d665c333422224444222222224444222243b33333333333333333c443b333c1433333cccc33331111111133422934342422434924492400000000
ccccccccc5ddddd53322111122221111111122221111233b3a33b3333a333333c22333b3cc233a33cccc33331111111142342433344444439999999900000000
ccccccccc155dd55b311cccc1111cccccccc1111cccc11333b33b3333b333333c11333b3cc133b33cc333a33111111113443432333322333c2ccccc200000000
cccccccccc11111133cccccccccccccccccccccccccccc3333b3333b333333b3cc33b333cc33333333333b331111111133349344333443331211111200000000
ccccccccccc111cc34cccccccccccccccccccccccccccc4333b3333b333333b3cc333333c333333b3b33333b1111111134333333311441131111111100000000
__map__
4243434344434343434546464746424444434444444546424445474244454646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404044434444404040404040404044404040434040404946000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404847000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404040404040404040404040404041404040404040404040404040404040464d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404040404e4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404946000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404546000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404049000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404a46000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404746000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040414040404040404846000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404140404040404040404040404040404040404040404040404040404946000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40404040404040404040404040404040404040404040404040404040404a4647000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
