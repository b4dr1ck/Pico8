pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	-- player variables
	p=	{	
						x=								64,
						y=								32,
						xspeed=				0,
						accel=					0.25,
						maxspeed=		2,
						jumpspeed=	3,
						yspeed=				0,
						friction=		0.25,
						direction=	false,
						gravity=			0.25,
						on_ground=	true,
						dead=						false,
						frame=					2
				}		
	timer=0 -- for time-events
	music(0)
end

function _update()
 -- if player is dead, return
	if p.dead then
		music(-1)
		if btnp(5) then
			p.dead=false
			_init()
		else
			return
		end
	end
	
	-- game timer handling 
	if timer < 100 then
		timer+=1
	else
		timer=0
	end		

 ------------------------------	
 -- add speed to players x
	p.x += p.xspeed

	-- collision detection
 -- left
	if fget(mget(flr((p.x)/8),flr(p.y/8))) == 1 or
				fget(mget(flr((p.x)/8),flr((p.y+7)/8))) == 1
	then
			p.xspeed = 0
			p.x = ceil(p.x/8)*8
 -- right			
	elseif fget(mget(flr((p.x+8)/8),flr(p.y/8))) == 1 or
								fget(mget(flr((p.x+8)/8),flr((p.y+7)/8))) == 1
	then
			p.xspeed = 0
			p.x = flr(p.x/8)*8
	end

 ------------------------------
 -- gravity
	p.yspeed+=p.gravity

	-- add speed to players y
	p.y += p.yspeed	

	-- collision detection
	-- up
	if fget(mget(flr((p.x)/8),flr(p.y/8))) == 1 or
				fget(mget(flr((p.x+7)/8),flr((p.y)/8))) == 1
	then
			p.yspeed = 0
			p.y = ceil(p.y/8)*8
	-- down
	elseif fget(mget(flr((p.x)/8),flr((p.y+8)/8))) == 1 or
								fget(mget(flr((p.x+7)/8),flr((p.y+8)/8))) == 1
	then
			p.on_ground=true -- player stand on the ground
			p.yspeed = 0
			p.y = flr(p.y/8)*8
	end
	
	-- detect a trap
	if fget(mget(flr((p.x+2)/8),flr((p.y+6)/8))) == 2 or
				fget(mget(flr((p.x+6)/8),flr((p.y+6)/8))) == 2 or
				fget(mget(flr((p.x+2)/8),flr((p.y+2)/8))) == 2 or
				fget(mget(flr((p.x+6)/8),flr((p.y+2)/8))) == 2 or
				fget(mget(flr((p.x+6)/8),flr((p.y+2)/8))) == 2 or
				fget(mget(flr((p.x+6)/8),flr((p.y+6)/8))) == 2 or
				fget(mget(flr((p.x+2)/8),flr((p.y+2)/8))) == 2 or
				fget(mget(flr((p.x+2)/8),flr((p.y+6)/8))) == 2
	then
		sfx(1)
		p.dead=true
	end								
 
 ------------------------------
 -- movement
	-- 	go left
	if btn(0) then
		p.xspeed -= p.accel
		p.xspeed = max(p.xspeed,-p.maxspeed)
		p.direction = true
		-- animation
		if p.on_ground then
 		if p.frame < 3 and timer % 5 == 0 then
 			p.frame+=1
   else
   	p.frame=2
   end
	 end
 end
	-- 	go right
	if btn(1) then
		p.xspeed += p.accel
		p.xspeed = min(p.xspeed,p.maxspeed)
		p.direction = false
		-- animation
		if p.on_ground then
 		if p.frame < 3 and timer % 5 == 0 then
 			p.frame+=1
   else
   	p.frame=2
   end
		end   
	end
	-- jump
	if btnp(5) then
		p.frame=18
		if p.yspeed == 0 and p.on_ground then
			sfx(0)
			p.yspeed = -p.jumpspeed
		end
		p.on_ground=false
	end

	------------------------------
	-- friction, when no button is pressed
	if not btn(0) and not btn(1) then
		if p.on_ground then p.frame=2 end 
		if p.xspeed < 0 then p.xspeed += p.friction end
		if p.xspeed > 0 then p.xspeed -= p.friction end
	end
	
	camera(p.x-64,p.y-64)
	
end

function _draw()
	cls()
	map(0,0,0,0)
	spr(p.frame,p.x,p.y,1,1,p.direction)
	if p.dead then
		rectfill(p.x-64,p.y-64,p.x+64,p.y+64,0)
		print("you are dead",p.x-16,p.y-8,8)
		print("press ❎ to restart",p.x-32,p.y,6)
		spr(64,p.x,p.y-20)
	end
end





__gfx__
00000000666656660244442002444420111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555552444444224444442111111111511151111555555000000000000000000000000000000000000000000000000000000000000000000000000
00700700566666664944c44c494444441111111157515751157766dd000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555559a9424429a94c44c111111115651565111555555000000000000000000000000000000000000000000000000000000000000000000000000
00077000666656664944444449442442111111115651565111111111000000000000000000000000000000000000000000000000000000000000000000000000
00700700555555554444276544442222111111115651565111555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000566666662442222224422765111111115d515d51157766dd000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555552222222222222222111111115d515d5111555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000244442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002444c44c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004944244200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009a94476500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004944422200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000004442222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002220000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02448420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24488442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4948c84c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a948848000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
89488448000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
48482765000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24828652000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
82822882000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101040404040401010404040404010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040404040404040404040404060104040404040404010101010101010101010104040101010101010101010101010101000100000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040404040404040404040404040404040404040404040404010101010104040404040404040401040404010101010101000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101040404040404040404010404010404040404040404040404040404040404040404040404040404040104040101040101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040104040404040401040404040104040404040404040404040401010101010101010101010404040101040101040404040404000004000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040404010404040404040404040104040401040404040404010404010101040406010101010104010101040101040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101040404040401010404040404010101010504040404040404010404040404040401010404040404040404060104040404040400000400040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040404040101010104040404010404010101010404040104040104040404040404040404040405040404040404040101010000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040404040101010104040404040404040401010104040404040404040404040101010104010101040101040404010101000100000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104040401040401010101040404040404040404040404040404010404040501040404040401010101040104040401010101000000010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101040404040401010101040404040404040601040404040401010104010101040404010101040404040404040101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101040404040101010404040404040104040404040404040404040404040404040404040404040404040404040404040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010104040404010404040404040101010104010404040104040404040404040404040404040404040401010104040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101040404040404010505010101010104040405010105050501010505050101010101010505010101050505050101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00020000095700d5701057010570105701b50024700237001d7000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d0000215501d5501a5501655013550105500c55008550075500355001550015500155001550140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011200001a7501d7501d7500000000000187501875000400000001d7501d750187501f750217500000000000000001d7501d750187501d75000000000000000000000217502375000000237501d7501875000000
000d00001b00011000090000200013500105000c50008500075000350001500015000150001500140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000c0000e00010000110000000000000000000d0000c0000e00010000110000d00009000000000d0000c0000e00010000110000200003000040000d0000c0000e00010000110000000000000000000d000
__music__
03 02424344

