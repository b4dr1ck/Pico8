pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- ghoul in one
-- BY BADRICK

function _init()
 game_state="main"
 
 music(0,2000)
 init_map()
 init_mouse()
	init_player()
	init_obst()
	init_hud()
	
	press_start_y=120
end

function _update60()
 if game_state == "game" then
	 update_mouse()
		update_player()
		update_obst()
		update_hud()
		update_map()
	elseif game_state == "help" then
	 press_start_y = press_start_y + sine_wave(0,0.5,0.05) 
	 if btnp(❎) then
	  game_state="game"
	  music(-1)
	 end
	elseif game_state == "main" then	 press_start_y = press_start_y + sine_wave(0,0.5,0.05) 
	 if btnp(❎) then
	  game_state="help"
	 end
	end
end

function _draw()
 cls()
 
 if game_state == "game" then
	 draw_map()
	 draw_obst()
	 draw_player()
	 draw_obst_foreground()
	 draw_map_foreground()
	 draw_mouse()
	 draw_hud()
	 
	elseif game_state == "help" then
	 print("\^uhow to play?",1,1,7)
	 print("try to reach every hole in each\n"..
	 "level to win the game",1,12,6)
	 
	 spr(54,2,30)
	 print("HOLD \fcleft mb\f5 TO AIM \n"..
	       "AND RELEASE TO SHOOT",14,30,5)
	 
	 print("\^o1ff\f7PRESS ❎ TO START",30,press_start_y,7)      
	 
	 print("\^o7ff\f8hole faild",2,50)
	 print("IF YOU ARE MORE THAN \f83 strokes\f5 \n"..
	       "OVER \f4par\f5 THE HOLE FAILED AND \n"..
	       "THE LEVEL RESTARTS",2,58,5) 

  print("be aware!",2,80,8)	 
	 print("THERE ARE ALSO OTHER THINGS\n"..
	       "THAT KEEP YOU FROM YOUR GOAL!",2,90,5)
	 	 
	elseif game_state == "main" then
	 print("ghoul in one",8,8,8)
	 
	 -- main menu background image
	 local img=[[
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008eeee800e80000e800008eeee80000e80000e800e80000000000000000e800e80000e80000000000008eeee80000e80000880088eeeee80000000
0000000000888888008800008800008888880000880000880088000000000000000088008800008800000000000088888800008800008800888888880000000
0000000088222222008800008800882222288800880000880088000000000000000022008888008800000000008822222288008888008800882222220000000
0000000088000000008800008800880000088800880000880088000000000000000000008888008800000000008800000088008888008800880000000000000
0000000088008888008888888800880000028800880000880088000000000000000008008822888800000000008800000088008822888800888888000000000
0000000088008888008888888800880000008800880000880088000000000060000088008800888800000000008800000088008800888800888888000000000
0000000088002288008822828800880000008800880000880088000600000000000088008800228800000000008800000088008800228800882282000000000
0000000088000088008800808800880000008800880000880088000000000000000088008800008800000000008800000088008800008800880080000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000088000088008800088800880000008800880000880088000000000000000088008800008800000000008800000088008800008800880000000006000
0000000088888888008800028800228888882200228888220088888888000000000088008800008800000000002888888822008800008800888888880000000
0000000088888888008800008800008888880000008888000088888888000700000088008800008800000000000888888800008800008800888888880000000
0000000088882822008800008200002888820000002828000022888822000000000028808200008200000000000288888200008800008200288888220000000
0000000028888200008800008000000282200000000288000000282880000000000008808000002000000000000028822000008800002000022882000000000
0000000002822000008800008000000080000000000028000000020880000000000008208000000000000000000002800000008200000000000888000000000
0000000000800000002800002000000080000000000008000000000280000000000008088000000000000000000000800000008000000000000888000000000
0000000000800000000800000000000080000000000008060000000080000070000002088000000000060000000000800000008000000000000288000000000
0000000000800000008200000000000880000000000008000000000020000000000000028000000000000000000000800000002000000000000082000000000
0000000000800000002000000000000880000000000008000000000000000000060000008000000000000000000000200000000000000000000080000000000
0000000000200000000000000000000820000000000008000000000000000000000000008000000000000000000000000000000000000000000080000000000
0000000000000000000000000000000200000060000002000000000000000000000000002000000000000000000007000000000000000000000080000600000
0060000000000000000000000000000000000000000000000000000000600000000000000000000000600000000000000000000000000000000080000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700006000000000000
0000000000000000000000000000000000000000000000000000000666666666666666666666666600000000000000000000000000000000000000000000000
0000000000000000060000000000000000000000000006666666666666666666666666666666666666666666600000000000000000000000000000000000000
0000000000000000000000000000000000000066666666666666666666666666666666666666666666666666666666660000000000000000000000000000000
00000000000000000000000000000000666666666666666666666666dddddddddddddddddddddddd66666666666666666666000000000000000000600000000
0000000000000000000000000006666666666666666666ddddddddddddddddddddddddddddddddddddddddddd66666666666666600000000000000000000000
000000000000000000000066666666666666666ddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6666666666660000000000000000000
000000000000000000666666666666666dddddddddddddddddddddd111111111111111111111111dddddddddddddddddddddd66666666666000000000000000
000000000000006666666666666ddddddddddddddddddd111111111555555555555555555555555111111111ddddddddddddddddd6666666666600000000000
00000000006666666666ddddddddddddddddddd11111111155555555555555555555555555555555555555511111111dddddddddddddd666666666660000000
00000066666666ddddddddddddddddddd1111111111555555555555555dddddddddddddd555555555555555555555511111dddddddddddddd66666666666000
00666666dddddddddddddddddddd1111111111555555555555555dddddddddddddddddddddddd55555555555555555555551111ddddddddddddd66666666666
666dddddddddddddddddddd111111111155515551555155515ddddddddddddddddddd66ddddddddd155515551555155515551551111dddddddddddd66666666
ddddddddddddddddddd1111111555555555555555555555dddddddddddd66666666666666dddddddddd5555555555555555555555551111dddddddddddd6666
dddddddddddddd111111551555155515551555155515dddddddddddd66666666666666666666dddddddddd155515551555155515551055111111dddddddddd6
dddddddd1111115555555555555555555555555555ddddddddddd66666666666666666666666666ddddddddd55555555555555555550555555551111ddddddd
ddd11111155515551555151515151515151515151ddddddddd6666666666666677666666666666666dddddddd51515151515151515150515151515151111ddd
111555555555555555555555555555555555555ddddddddd66666666666677777777776666666666666dddddddd555555555555555555055555555555555111
5515551555155515551555155515551555155ddddddddd66666666666666777777777766666666666666ddddddddd5151515151515151505151515151515151
555555555555555555555555555555555555dddddddd666666666666777777777777777777666666666666dddddddd555552888855555505555555555555555
15151515151515151515151515151515151ddddddd666666666677777777777777777777777777666666666dddddddd51515128888251505151515151515151
5555555555555555555551555155515551ddddddd66666666777777777777777777777777777777776666666dddddddd5155518888888888888266555155515
151515151515151515151515151515151dddddd66666666777777777777777777777777777777777777666667dddddddd515151888888888888266151515151
55555555555555555555555555555555ddddddd6666666777777777777777777777777777777777777776666666ddddddd51555188888888888266515551555
1515151515151515151515151515151ddddddd6666777777777777777777777777777777777777777777777766666dddddd5151512888888888266151515151
515551555155515551555155515551ddddddd6666777777777777777777777777777777777777777777777777666666ddddd515151528888888266515151515
15151515151515151515151515151dddddddd66667777777777777777777777777777777777777777777777776666666ddddd51515151888888226651515151
5551555155515551555155515551dddddddd6666677777777777777777777777777777777777777777777777766666666ddddd5151515150515156615151515
151515151515151515151515151dddddddd66666777777777777777777777777777777777777777777777777776666666dddddd515151510151516651515151
515151515151515151515151515ddddddd6666677777777777777777777777777777777777777777777777777776666666ddddd151515150515157615151515
15151515151515151515151515ddddddd66666677777777777777777777777777777777777777777777777777776666666dddddd15151510151517651515151
5151515151515151515151515dddddddd666667777777776666666677777777777777777777666666667777777776666666dddddd1515150515157615151515
1115111511122215111511151ddddddd6666677777666666666666666777777777777777766666666666666677777666666dddddd1151110111517651115111
515151515154495151515151dddddddd66667777666666666666666666666666666666666666666666666666667777666666dddddd515150515157615151515
151115111514491115111511dddddddd66667776666666666666666666666666666666666666666666666666666777666666dddddd111510151117611511151
515151515124915151515151dddddddd666777766666600000000006666666666666666666600000000006666667777666666ddddd515101015157615151515
11151115114491111111111dddddddd6667777666000000000000000000666666666666000000000000000000666777766666dddddd11011011111d11111111
51515151514491515151515dddddddd66677776700000000000000000000dd666666660000000000000000000076777766666dddddd10151505151d11151515
15111511154495111511151dddddddd66777766000000000000000000000dd6666666d00000000000000000000066777766666ddddd11111101111d11111111
5151515152495151515151dddddddd66677776000000000000000000000dddddddd66dd0000000000000000000006777766666dddddd5151510151d11151515
1111111114491111111111dddddddd6677777000000000002200000000dddddddddddddd000000002200000000000777776666dddddd1111110011d11111111
5151515114491151115111ddddddd66677770000000000000000202000dddddddddddddd0002020000000000000000777766666ddddd1151105101d11151115
1111111114491111111111ddddddd66677770000000000000000020000dddddddddddddd0000200000000000000000777766666ddddd1111011110d11111111
515151512491515151515ddddddd666677700000000002002222200000dddddddddddddd00000222220020000000000777666666ddddd110511151d11011511
111111114491111111111ddddddd666677710000000000222888220200dddddddddddddd00202288822200000000001777666666ddddd110111111d11101111
115111514491115111511ddddddd6667777110000000000288888200000dddd77dddd7d000002888882000000000011777766666ddddd110111111176110111
111111114490111111111ddddddd6667777111000000002228888220000dddd7777777d00002288882220000000011177776666dddddd110111111176111011
511151024911001151115ddddddd6667777111100000000022888200000ddd77777777d00000288822000000000111177776666dddddd010111111176111011
110000144911665111111dddddd66667777111110000200022222200000dddddddddddd00000222222000200001111177776666dddddd000011111176111011
001111166666555111111dddddd666677777d1111100000000222000200dddddddddddd00200022200000000111111777776666dddddd030000111176111011
000066655555555511111dddddd666677777dd11111111200000200011ddd77dddd777dd110002000002111111111d777776666dddddd000000001176111011
0111555555555555133005ddddd6666677777d1111111111111111111ddd7777777777ddd11111111111111111117d777766666ddddd5003030030076111101
0111155555555555300305ddddd6666677777dd11111111111111111dddd70077770077ddd11111111111111111ddd77776666dddddd5003000000066101101
0111155555555555330000dddddd6666677777dddd1111111111111ddd7000000000000dddd1111111111111ddddd777766666dddddd3303003030066100011
0111155555555555530300dddddd66666777777ddddddddd11111ddddd70000000000007ddddd11111ddddddddddd777766666dddddd0000030003066100031
0011115555555535503000ddddddd66666777777dddddddddddddddddd00000000000000dddddddddddddddddddd7777666666dddddd0030000030006650300
00111155555555355030305ddddddd666667777777ddddddddddddddd7000000000000007ddddddddddddddddddd77766666ddddddd50000303003006653000
00111115555355b35300000ddddddd666667777777777dddddddddddd1100000000000011dddddddddddddddddd777766666ddddddd00000000300336633003
30111115535535b33b03000dddddddd666667777777777777777ddddd11100000000001117dddddddddddddddd777766666dddddddd00000000333116651330
0001111553b5333330030005dddddddd66666777777777777777777dd11111117711111117ddddddddddddddd777766666dddddddd500003000311116651113
00033115533b333030003000ddddddddd6666677777777777777777777111117777111117777ddddddddddd7777766666ddddddddd000000303111005550111
0300303333b33030300000005dddddddd666666677777777777777777d77777dddd77777d777777777777777776666666dddddddd5000000331100005550001
0030030333b30003000003000ddddddddd666666677777777777777777dddddddddddddd777777777777777776666666ddddddddd0000000003000000000000
00000300030003003000000005ddddddddd6666666777777777777777766dddddddddd6677777777777777776666666ddddddddd50000000000300000000303
000000000303000003000303055ddddddddd6666666777777777777777666666666666667777777777777776666666ddddddddd550000000003033003000330
0000300000000000000000000055dddddddddd666666677777777777777666666666666777777777777776666666dddddddddd5500000000000330333333303
00030000003000000000000000055dddddddddd6666666666666777777776666666666777777776666666666666dddddddddd55000000000000030030300030
000000000000000000000000000055dddddddddddd6666666667777777777666666667777777777666666666dddddddddddd550000000000000030030300000
000000000000000000000000000bb55dddddddddddddd6666677777777777666666667777777777766666dddddddddddddd5500000000000000000000000000
000000000000000000000000bb3b33555dddddddddddd6666677777777777766666677777777777766666dddddddddddd555000000000000000000000000000
000000000000000000000000bb3bbb3555555dddddddd6666677777777777777777777777777777766666dddddddd5555550000000000000000000000000000
00000000000000000000000bbbaabbab555555ddddddd6666677777777777777777777777777777766666ddddddd55555500000000000000000000000000000
000000000000000000bbbbbbbbabbbbbb55555ddddddd3633677777777777777777777777777777766666ddddddd55555333300000000000000000000000000
00000000000000bbbbbb3bbbbaaabbb3335555dddd3dd336367777777777777777777777777777776666dddddddd555533333bb000000000000000000000000
0000000000000bbbbbbbbbbbbaaa33333335555dddddd3b3b667777777777dd7777dd77777777773636dddddddd55553333333bb00000000000000000000000
0000000000000bbbbbbbbbbbb3bb33333333555ddddddd336667777777776117777116777773777b366dddddddd55533333333bb00000000000000000000000
00000000000000bbbbbbb333bbbbb33333333555dd3ddd3d666777dd777611166661116777dd777366dd3ddddd55533333333babb0000000000000000000000
0000000b00000000bbbbbbb3bbbbbb333333333555ddddddd63677117771111dddd11117771177666d33dddd5553333333333bbbbbbbaabbb00000000000000
000000000000000000bbbbb33bb3bbbb333333333555ddd33d6666111dd111133111113dd1116666d333dd555bb3333333bbbbaabbbbbabbbbbbb0000000000
00000000b0000000000bbbbbbbbbbbaab333333333555dd33d6666111131111b311111311111666ddd3dd555bbaabbabbbbbbb3aaaaaabbbbbbbbb000000000
0000000000000000000000000bbbbbbaab3333333333555dddd6111111311111311113b11111116dddd555bbbbabbbbbbbb3333baaaaaaaaabbbbb000000000
00000000000000bbb00000000000bbbaabb333333333333dddd1111113b1111131113bb31111111ddddbbbbbbbbbbbb333b3bbbb3abbabaaabbbbb000000000
00000000000000bbb000000000000bbbbbbbbb33333333333311111133b111113111311311111111bbbbbb333333333333333baababbbbbbbbbbb0000000000
00000000000000000000000000000bbbbbbabbbbb33333333333311131311113b1113113111113333bbbb3333333333333333baababb0000000000000000000
0000000000000000000000000000000bbbbbbbb3333bb3333333333333b111131b1131133333333333babb3333333333333aaaabbbbbbb00000000000000000
0000000000000000000000000000000000bbbbb3333bbbb333b333333b3bbb333333333333b3333bbbbbbbb33333333333bbbbbbbbb00000000000000000000
00030000000000000000000000000000000bbbbb3333333bb3bb33b3333bb33333b33333333bbbbbbbbabbbb3333333b33bbbbabbbb000000bbb00000000030
003000000000000000300000000000000000bbbbbbbbb3333b333333333b333bbbb33bbb333bbbbbb333bbbbbbbbbbbbbbbbbbbbbbb0000b000b00000000303
0300000000000000000000000000000000bbbbaaabbabbbbbbbb3b333a3bbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbaaaaaabbbbbbb000000000000000000000033
300000000000000000000003330000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaabbbbbbbbbb00000000bbbbbbbaabbbbbb000000000000000000000000000b
33b000000300000000000000033000000bbbbbbbbbbbb00bbbbbbbbbbbbbbaaaabbbabbbb000000000000000bbbbbbbb0000000000bbbb0000000003000000b
3b0003003b000000000000000000000000bbbbbbbbb000000000bbbbbbbbbbbaabbbbbb00000000bbb000000000000000000000000bbbbb0000000030003303
30000030300000000000000000000000000000000000000000000000000000000000000000b0000bbbb0000000000000000b000000000bbb000000030003000
300000033000000000000000000000000000000000000000000000000000000000000000bbbb00000000000000000000000000000000000000000000b003000
300b000030000000000000000000000000000000000000000000000000000000000000000bbb000000000000000000000000000000000000000000003003000
30030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003003b3003
30330000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303b0030
303300003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033b0030
bb33000033b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033b0300
]]

  draw_img(img)	 
  
  print("BY BADRICK",9,25,7)
  print("\^o1ff\f7PRESS ❎ TO START",30,press_start_y,7)      
 end
end
-->8
-- player

function init_player()
	poke(0x5f34,0x2) -- inverted draw operations
	
	ticks=0
	
 player={
 	img=1,
 	x=0,
 	y=0,
 	xspd=0,
 	yspd=0,
 	moving=false,
 	angle=0,
 	maxspd=8,
 	spd=0,
 	w=8,
 	h=8,
 	new_size=8,
 	strokes={},
 	level=1,
 	restart=false,
 	no_fall_anim=false,
 	hole_failed=false,
 	showresult=false,
 }
 
 -- init strokes
 for i=0,#maps do
  add(player.strokes,0)
 end
 
 -- player start
 player.x=maps[player.level].spawn[1]*8
 player.y=maps[player.level].spawn[2]*8
 
 aimline={
  visible=false,
  length=14,
  c=7,
  x1=0,y1=0,x2=2,y2=0,
 }
 
 spot_radius=200
 spot=false
 
 arrow={x=player.x,
 							y=0,
 							visible=true
 							}
 
 slime={}
 playsfx=true
end


function update_player()
 -- ticks-counter (frames)
	ticks+=1
	if ticks > 1000 then
	 ticks=0
	end

	if player.showresult then
	 return
	end
	
 -- holding left mouseb (1)
 if mouse.b == 1 and
    not player.moving and
    not spot
 then
 	mouse.br = 1
 	   
 	if playsfx then
 	 playsfx=false
   sfx(0)
 	end
 	
  -- set player speed and angle
 	player.angle = atan2(mouse.x - (player.x + 4), mouse.y - (player.y + 4))	 	
 	player.spd=min(player.maxspd, player.spd + 0.05)
 	
 	player.xspd = cos(player.angle) * player.spd
 	player.yspd = sin(player.angle) * player.spd
 	 	
 	-- aim line 
		aimline.x1=player.x+4
		aimline.y1=player.y+4
		aimline.x2=player.x+4+cos(player.angle)*(aimline.length)
		aimline.y2=player.y+4+sin(player.angle)*(aimline.length)
	 aimline.visible = true 
		
 end   
 
 -- on mouse release
 if mouse.b == 0 and
    mouse.br == 1
 then
  player.strokes[player.level] += 1
  player.moving = true
  mouse.br = 0
  playsfx=true
  sfx(-1)
  sfx(1)
  
  -- hole failed
  if player.strokes[player.level] > maps[player.level].par + 3 then
  	spot=true
  	player.restart=true
  	player.hole_failed=true
	  sfx(5)
  end
 end
 
 -- direction tiles
 -- right
 local direction_tiles_spd=2
 if tile_collision(player.x,player.y,0,5) and
    mget(flr((player.x+4)/8),flr((player.y+4)/8)) == 108
 then
  player.x+=direction_tiles_spd
  arrow.x = player.x
  arrow.y = 0
 end
 --up
 if tile_collision(player.x,player.y,0,5) and
    mget(flr((player.x+4)/8),flr((player.y+4)/8)) == 109
 then
  player.y-=direction_tiles_spd
  arrow.x = player.x
  arrow.y = 0
 end
 --left
 if tile_collision(player.x,player.y,0,5) and
    mget(flr((player.x+4)/8),flr((player.y+4)/8)) == 110
 then
  player.x-=direction_tiles_spd
  arrow.x = player.x
  arrow.y = 0
 end
 -- down
 if tile_collision(player.x,player.y,0,5) and
    mget(flr((player.x+4)/8),flr((player.y+4)/8)) == 111
 then
  player.y+=direction_tiles_spd
  arrow.x = player.x
  arrow.y = 0
 end
 
 -- tile collision on flag 3 (pits)
 if tile_collision(player.x,player.y,2,3) and not player.restart then
 	spot=true
 	player.restart=true
 	player.spd=0
  sfx(5)
 end
 
 -- tile collision on flag 6 (dead block)
 if tile_collision(player.x,player.y,2,6) and not player.restart then
  	spot=true
  	player.restart=true
  	player.no_fall_anim=true
  	player.spd=0
	  sfx(5)
 end
  
 -- teleporter
 for t in all(maps[player.level].teleporters) do
  if aabb(player,{
  																x=t.x*8,
  																y=t.y*8,
  																w=8,h=8
  																},2) 
  then
   player.x = t.dx * 8
   player.y = t.dy * 8
   sfx(10)
  end
 end
 
 -- trigger
 for t in all(maps[player.level].trigger) do
  if aabb(player,{
  																x=t.x*8,
  																y=t.y*8,
  																w=8,h=8
  																},2)							  
 	then
  	mset(t.dx,t.dy,65)
  	if t.img== 23 then
  	 sfx(9) -- play once
  	end
  	t.img=24
  end
 end

 -- player movement
 if player.moving then
  aimline.visible = false
  arrow.visible = false
  
  local obst_x_collide=false
  local obst_y_collide=false
 
  -- decrease speed
  player.spd=max(0,player.spd-0.1)
  
  player.xspd = cos(player.angle) * player.spd
  player.yspd = sin(player.angle) * player.spd
  
  -- slow down on flag 4 (slow down)
  if tile_collision(player.x,player.y,0,4) then
   player.spd=max(0,player.spd-1)
  end
    
  -- enemies on x-axis
  local enemies=maps[player.level].enemies
  for e in all(enemies) do
   if aabb(
   							{x=player.x+player.xspd,
   							 y=player.y,w=8,h=8},
   							 e,
   							 2) 
   then
   	obst_x_collide=true
   end
  end
    
  -- tile on x-axis
  if tile_collision(player.x + player.xspd, player.y,2,0) or
     obst_x_collide
  then
  	player.xspd = -player.xspd
  	player.angle=0.5 - player.angle
  	sfx(2)
  else
  	player.x+=player.xspd
  end
  
  -- enemies on x-axis
  for e in all(enemies) do
   if aabb(
   							{x=player.x,
   							 y=player.y+player.yspd,w=8,h=8},
   							 e,
   							 2) 
   then
   	obst_y_collide=true
   end
  end

 -- tile y-axis
  if tile_collision(player.x, player.y + player.yspd,2,0) or
     obst_y_collide
  then
  	player.yspd = -player.yspd
  	player.angle = -player.angle
  	sfx(2)
  else
   player.y+=player.yspd
  end
    
		-- creat slime
		local slimex=player.x+4+randbi(-3,3)
		local slimey=player.y+4+randbi(-3,3)
		
		if	not tile_collision(slimex,slimey,0,1) and
		   not tile_collision(slimex,slimey,0,3) and
		   not tile_collision(player.x,player.y,0,5)
		then
	  add(slime,{x=slimex,y=slimey,ttl=600,r=randi(2)})
	 end
  
  -- player not moving
  if player.spd == 0 then
   player.moving = false
   arrow.visible = true
   arrow.x = player.x
   arrow.y = 0
   if player.restart then
    arrow.visible = false
   end
   -- level transition
   if tile_collision(player.x,player.y,2,1) then
	  	spot=true
	  	arrow.visible=false
 	  sfx(3)
   end
  end 
 end
 
 -- spot
 if spot then
  spot_radius-=3
  if spot_radius <= 0 then
    player.no_fall_anim=false

    -- hole failed / reset strokes
    if player.hole_failed then
     player.strokes[player.level] = 0
     player.hole_failed = false
    end

    -- change level
    if not player.restart then
	    player.level += 1 
	   else
    	player.restart=false
	   end
	   
	   -- show result-page after last level
		  if player.level > #maps then
		   player.level = 1
		   player.showresult=true
		  end
		  
		  arrow.visible=true
    player.x=maps[player.level].spawn[1]*8
    player.y=maps[player.level].spawn[2]*8
    player.img=1
		  arrow.x	= player.x

    spot=false
    spot_radius=200
  end
 end
 
 -- arrow update
 if arrow.visible then
	 arrow.y = player.y + sine_wave(arrow.x,4,0.05) - 10
	end

 -- update slime
 for s in all(slime) do
  s.ttl -= 1
  if s.ttl <= 0 then
   del(slime,s)
  end
 end
  
 -- animation
 if player.moving then
  player.img=animate(player.img,1,4,0.1,true)
 end
end


function draw_player()
 -- slime
 fillp(0b1010010110100101)
 for s in all(slime) do
  circfill(s.x,s.y,s.r,0xba)
 end
 fillp()

 -- player (ball)
 -- fall animation on holes
 if spot then
  local sx = (flr(player.img) % 16) * 8
  local sy = (flr(player.img) \ 16) * 8
  local dx=maps[player.level].hole[1]*8+2
  local dy=maps[player.level].hole[2]*8+2
  
  if player.restart then
  	dx=player.x
  	dy=player.y
  	if player.no_fall_anim then
  		pal(6,8)
  	end	
  end
  
  if not player.no_fall_anim and
     not player.hole_failed
  then
	  player.new_size -= 0.1
	 end
	 
 	sspr(sx,
 						sy,
 						player.w,
 						player.h,
 						dx,
 						dy,
 						player.new_size,
 						player.new_size
 						)
 else
  -- normal sprite and shadow
	 player.new_size=8
	 ovalfill(player.x-2,player.y+4,player.x+4,player.y+7,1)
	 spr(player.img,player.x,player.y)
	end
	pal()

 -- arrow
 if arrow.visible then
  --print("\^o7ff\f1⬇️",arrow.x,arrow.y,12)
  spr(18,arrow.x,arrow.y)
 end
 
 -- aimline
 if aimline.visible then
   -- charge bar
   rectfill(player.x-1,player.y-5,player.x + 9 , player.y - 3, 0)
   line(player.x,player.y-4,flr(player.x+player.spd),player.y-4,8)

   -- aimline itself
 	 line(aimline.x1,aimline.y1,aimline.x2,aimline.y2,aimline.c)
 end
 
 -- debug
   --print(player.slow,64,0,7)
-- print(player.strokes)
-- print(player.spd)
end
-->8
-- mouse
function init_mouse()
 poke(0x5f2d,0x1)
 mouse={
  b=0,
  bp=0,
  br=0,
  x=0,
  y=0,
 }
end

function update_mouse()
 mouse.x=stat(32) + cam_x
 mouse.y=stat(33) + cam_y
 mouse.b=stat(34)
end

function draw_mouse()
 if not aimline.visible then
	 circfill(mouse.x,mouse.y,0,7)
	end
end
-->8
-- maps

function init_map()
 cam_x=0
 cam_y=0
 maps={
  {
  	name="simple enough?",
  	par=3,
  	x=0,
  	y=0,
  	sizex=0,
  	sizey=0,
  	spawn={2,13},
  	hole={13,2},
  },
  {
  	name="stones on my way",
  	par=3,
  	x=1,
  	y=0,
  	sizex=0,
  	sizey=0,
  	spawn={18,13},
  	hole={23,6},
  },
  {
  	name="two walls",
  	par=3,
  	x=2,
  	y=0,
  	sizex=0,
  	sizey=0,
  	spawn={34,13},
  	hole={34,3},
  },
  {
  	name="larger one",
  	par=4,
  	x=3,
  	y=0,
  	sizex=1,
  	sizey=0,
  	spawn={50,13},
  	hole={75,8},
  	enemies={
	  	{x=552,y=56,xspd=0,yspd=0.25,w=8,h=8,img=5,frames={5,5}}
  	}
  },
  {
  	name="cheesy",
  	par=4,
  	x=5,
  	y=0,
  	sizex=0,
  	sizey=0,
  	spawn={88,14},
  	hole={88,2},
  	enemies={
   	{x=680,y=80,xspd=0.25,yspd=0,w=8,h=8,img=5,frames={5,5}}
  	}
  },
  {
  	name="where to go?",
  	par=5,
  	x=6,
  	y=0,
  	sizex=1,
  	sizey=0,
  	spawn={97,14},
  	hole={117,8},
  	enemies={
   	{x=864,y=56,xspd=0,yspd=0.5,w=8,h=8,img=6,frames={6,6}},
   	{x=912,y=64,xspd=0,yspd=0.5,w=8,h=8,img=6,frames={6,6}}
  	}
  },
  {
  	name="langoliers",
  	par=3,
  	x=0,
  	y=1,
  	sizex=0,
  	sizey=0,
  	spawn={8,24},
  	hole={7,29},
  	enemies={
  	{x=96,y=216,xspd=0.25,yspd=0.25,w=8,h=8,img=7,frames={7,8}},
  	{x=88,y=160,xspd=0.25,yspd=0.25,w=8,h=8,img=7,frames={7,8}},
  	{x=40,y=208,xspd=0.25,yspd=0.25,w=8,h=8,img=7,frames={7,8}},
  	}
  },
  {
  	name="conveyer",
  	par=4,
  	x=1,
  	y=1,
  	sizex=0,
  	sizey=0,
  	spawn={24,30},
  	hole={17,18},
  },
  {
  	name="wormholes",
  	par=4,
  	x=2,
  	y=1,
  	sizex=1,
  	sizey=0,
  	spawn={33,18},
  	hole={42,24},
  	teleporters={
  		{x=46,y=18,dx=34,dy=21,img=19},
  		{x=34,y=30,dx=37,dy=29,img=19},
  		{x=45,y=29,dx=50,dy=19,img=19},
  		{x=62,y=28,dx=37,dy=24,img=19},
  	},
  },
  {
  	name="slaughter house",
  	par=3,
  	x=4,
  	y=1,
  	sizex=0,
  	sizey=0,
  	spawn={65,18},
  	hole={78,30},
  	teleporters={
  		{x=78,y=19,dx=72,dy=26,img=19},
  		{x=72,y=29,dx=65,dy=18,img=19},
 		},
  	enemies={
  	 {x=592,y=136,img=64,yspd=0.5,xspd=0,w=8,h=8,frames={64,64}},
  	 {x=552,y=150,img=64,yspd=0.5,xspd=0,w=8,h=8,frames={64,64}},
  	}
  },
  {
  	name="crosscurrent",
  	par=3,
  	x=5,
  	y=1,
  	sizex=0,
  	sizey=0,
  	spawn={87,30},
  	hole={87,18},
  },
  {
  	name="the roof",
  	par=3,
  	x=6,
  	y=1,
  	sizex=0,
  	sizey=0,
  	spawn={97,30},
  	hole={110,18},
  	enemies={
				{x=864,y=136,xspd=0,yspd=0.5,w=8,h=8,img=5,frames={5,5}},
  	}
  },
  {
  	name="deadly blocks",
  	par=3,
  	x=7,
  	y=1,
  	sizex=0,
  	sizey=0,
  	spawn={113,18},
  	hole={126,18},
  },
  {
  	name="hidden door",
  	par=4,
  	x=0,
  	y=2,
  	sizex=0,
  	sizey=0,
  	spawn={7,40},
  	hole={13,45},
  	teleporters={
  		{x=9,y=46,dx=11,dy=34,img=19},
 		},
  	trigger={
  		{x=3,y=38,img=23,dx=11,dy=42},
  	}
  },
 {
  	name="attracting",
  	par=5,
  	x=1,
  	y=2,
  	sizex=0,
  	sizey=0,
  	spawn={18,34},
  	hole={29,41},
  	magnets={
  		{x=30*8,y=34*8,img=25,w=8,h=8,strength=30},
  		{x=17*8,y=38*8,img=25,w=8,h=8,strength=30},
  		{x=27*8,y=41*8,img=25,w=8,h=8,strength=30},
  	},
  	trigger={
  		{x=24,y=41,img=23,dx=29,dy=44},
  	}
  },
  {
  	name="hell-oh",
  	par=8,
  	x=2,
  	y=2,
  	sizex=1,
  	sizey=0,
  	spawn={33,40},
  	hole={47,39},
  	teleporters={
  		{x=39,y=34,dx=49,dy=46,img=19},
  		{x=53,y=42,dx=33,dy=40,img=19},
  		{x=53,y=39,dx=43,dy=42,img=19},
  		{x=36,y=44,dx=47,dy=34,img=19},
 		},
  	enemies={
				{x=57*8,y=46*8,xspd=0,yspd=0.5,w=8,h=8,img=64,frames={64,64}},
  	},
  	trigger={
  		{x=62,y=34,img=23,dx=47,dy=37},
  	},
  	magnets={
  		{x=33*8,y=46*8,img=25,w=8,h=8,strength=30},
  		{x=33*8,y=42*8,img=25,w=8,h=8,strength=30},
 		}
  },
  {
  	name="the quarters",
  	par=5,
  	x=4,
  	y=2,
  	sizex=0,
  	sizey=0,
  	spawn={78,40},
  	hole={78,46},
  	teleporters={
  		{x=76,y=46,dx=73,dy=35,img=19},
  		{x=78,y=37,dx=65,dy=34,img=19},
  		{x=70,y=46,dx=78,dy=40,img=19},
 		},
  	magnets={
  		{x=70*8,y=34*8,img=25,w=8,h=8,strength=30},
  		{x=69*8,y=44*8,img=25,w=8,h=8,strength=30},
  		},
  	trigger={
  		{x=65,y=46,img=23,dx=78,dy=45},
  	},
  },
  {
  	name="rollercoaster",
  	par=1,
  	x=5,
  	y=2,
  	sizex=0,
  	sizey=0,
  	spawn={81,34},
  	hole={86,42},
  	magnets={
  		{x=90*8,y=43*8,img=25,w=8,h=8,strength=30},
 		}
  },
  {
  	name="skully",
  	par=3,
  	x=6,
  	y=2,
  	sizex=0,
  	sizey=0,
  	spawn={110,45},
  	hole={97,46},
  	magnets={
  		{x=90*8,y=43*8,img=25,w=8,h=8,strength=30},
 		},
  	teleporters={
  		{x=106,y=46,dx=104,dy=35,img=19},
  		{x=103,y=45,dx=100,dy=42,img=19},
 		}
  },
  {
  	name="cannonballs",
  	par=4,
  	x=7,
  	y=2,
  	sizex=0,
  	sizey=0,
  	spawn={113,34},
  	hole={125,45},
  	cannons={
  	 {x=116*8,y=33*8,xspd=0,yspd=2,timer=0,frq=10,base=60},
  	 {x=119*8,y=33*8,xspd=0,yspd=2,timer=0,frq=30,base=60},
  	 {x=122*8,y=33*8,xspd=0,yspd=2,timer=0,frq=50,base=60},
  	 {x=125*8,y=33*8,xspd=0,yspd=2,timer=0,frq=80,base=60}
  	}
  },
  {
  	name="the 'laser'",
  	par=4,
  	x=0,
  	y=3,
  	sizex=0,
  	sizey=0,
  	spawn={1,50},
  	hole={14,50},
  	lasers={
  		{x=8*8,y=56*8,angle=0,move=true},
  	},
  	cannons={
  	 {x=14*8,y=57*8,xspd=-2,yspd=0,timer=0,frq=0,base=100},
  	 {x=14*8,y=62*8,xspd=-2,yspd=0,timer=0,frq=30,base=100},
 	 }
  },
  {
  	name="the abyss",
  	par=3,
  	x=1,
  	y=3,
  	sizex=1,
  	sizey=0,
  	spawn={17,56},
  	hole={17,50},
  	trigger={
  		{x=46,y=56,img=23,dx=18,dy=52},
  	},
  	magnets={
  		{x=27*8,y=59*8,img=25,w=8,h=8,strength=30},
 		},
  	cannons={
  	 {x=23*8,y=50*8,xspd=0,yspd=2,timer=0,frq=10,base=80},
  	 {x=28*8,y=50*8,xspd=0,yspd=2,timer=0,frq=30,base=80},
  	 {x=33*8,y=50*8,xspd=0,yspd=2,timer=0,frq=50,base=80},
  	},
  	teleporters={
  		{x=42,y=49,dx=18,dy=56,img=19},
			}  		
  },
  {
  	name="all in one",
  	par=6,
  	x=3,
  	y=3,
  	sizex=1,
  	sizey=0,
  	spawn={49,50},
  	hole={78,50},
  	lasers={
  		{x=65*8,y=56*8,angle=0,move=true},
  	},
  	cannons={
  	 {x=59*8,y=60*8,xspd=-2,yspd=0,timer=0,frq=0,base=120},
 	 },
  	enemies={
	  	{x=53*8,y=56*8,xspd=0.25,yspd=0.25,w=8,h=8,img=7,frames={7,8}},
  	},
  	trigger={
  		{x=69,y=52,img=23,dx=73,dy=62},
  		{x=69,y=59,img=23,dx=-1,dy=-1},
  		{x=61,y=59,img=23,dx=-1,dy=-1},
  		{x=61,y=52,img=23,dx=-1,dy=-1},
  	},
  	magnets={
  		{x=56*8,y=53*8,img=25,w=8,h=8,strength=30},
 		},
 	},
  { 
 	name="the end...",
 	par=1,
 	x=5,
 	y=3,
 	sizex=1,
 	sizey=0,
 	spawn={81,62},
 	hole={109,56},
 	teleporters={
 		{x=94,y=62,dx=81,dy=50,img=19},
 		{x=94,y=50,dx=97,dy=56,img=19},
		 },
  	cannons={
  	 {x=84*8,y=49*8,xspd=0,yspd=2,timer=0,frq=0,base=120},
  	 {x=90*8,y=49*8,xspd=0,yspd=2,timer=0,frq=0,base=120},
 	 },
	 }
 }
 
	current_level=maps[1]
	flag={
		img=16,
		w=8,h=8,
		x=current_level.hole[1] * 8,
		y=current_level.hole[2] * 8-4
		}
		anim_tiles={}
				
		-- create objects for anim_tiles
		for y=0,64 do
		 for x=0,127 do
		  -- deadly blocks
		  if mget(x,y) == 21 then
		  	add(anim_tiles,{
		  	x=x,y=y,img=21,imgs=21,imge=22})
		  end
		 end
		end
end

function update_map()
 current_level=maps[player.level]
 cam_x = mid(current_level.x*128, player.x - 64, current_level.x*128+(128*current_level.sizex)) 
 cam_y = mid(current_level.y*128, player.y - 64, current_level.y*128+(128*current_level.sizey))
 
 -- update flag position 
	flag.x=current_level.hole[1] * 8
	flag.y=current_level.hole[2] * 8-4
 flag.img=animate(flag.img,16,17,0.05,true)
 
	-- animated tiles
	for a in all(anim_tiles) do
	 a.img=animate(a.img,a.imgs,a.imge,0.1,true)
	end
	
	-- reset trigger
	if player.restart then
	 for t in all(current_level.trigger) do
	  if t.img == 24 then
	   mset(t.dx,t.dy,76)
	   t.img = 23
	  end
	 end
	end
	
end

function draw_map()
 camera(cam_x,cam_y)
 
 -- recolor green
 pal(3,131,1)

 -- draw map
 map(0,0)
 -- spawnpoint
 mset(current_level.spawn[1],
					 current_level.spawn[2],
					 67
					 )
	-- hole
 mset(maps[player.level].hole[1],
				 maps[player.level].hole[2],
				 66
				 )
	-- draw teleporter
	for t in all(maps[player.level].teleporters) do	 
	 t.img=animate(t.img,19,20,0.1,true)
	 spr(t.img,t.x*8,t.y*8)
	end
	
	-- draw flag
	if aabb(player,flag,0) then
		spr(flag.img,flag.x,flag.y-8)
	else
		spr(flag.img,flag.x,flag.y)
	end
	
 -- draw trigger
 for t in all(maps[player.level].trigger) do
  spr(t.img,t.x*8,t.y*8)
 end
	
	-- animated tiles
	for a in all(anim_tiles) do
	 spr(a.img,a.x*8,a.y*8)
	end	

end

function draw_map_foreground()
 map(0,0,0,0,128,64,0x80)
end
-->8
-- hud

local function term(strokes,par) 
 -- albatros 
 if strokes == par - 3 then
	 return {"albatros ","e"}
 end 

 -- eagle
 if strokes == par - 2 then
	 return {"eaglie","c"}
 end 

 -- birdie
 if strokes == par - 1 then
	 return {"birdie","b"}
 end 
 
 -- par
 if strokes == par  then
	 return {"par","4"}
 end 

 -- bogey
 if strokes == par + 1 then
  return {"bogey","9"}
 end
  
 -- double bogey
 if strokes == par + 2 then
  return {"dbl bogey","2"}
 end 
 
 -- triple bogey
 if strokes == par + 3 then
  return {"trbl bogey","8"}
 end 
 
 -- hole failed
 if strokes > par + 3 then
  return {"hole failed","8"}
 end 
 
 return {" ","0"}
end

function result(maps,pageoffset) 
 local result_string=""
 local ind=1
 local score=0
 local maxentries=16
 local startindex=((pageoffset-1)*maxentries)+1
 local endindex=maxentries*pageoffset

 if endindex > #maps then
  endindex=#maps
 end
  
 for i=startindex,endindex do
  
  local termobj=term(player.strokes[i],maps[i].par)

 	result_string = 
 		result_string..
 		"\f1"..maps[i].name..": "..
 		"\f2"..player.strokes[i].."/"..maps[i].par.." "..
 		"\^o0ff\f"..termobj[2]..termobj[1].."\^-o \n"
 end
 
 for i=1,#maps do
		score+=player.strokes[i]
 end

 -- score at the end 
 if pageoffset == 2 then
	 result_string=result_string.."\f0\*a_\ntotal: "..score
 end
 
 return result_string
end


function init_hud()
 pageoffset=1
 bloodstains={}
 x=0
 y=0
 blackscreen={active=true,y=127}
end

function update_hud()

 -- blackscreen on starting game
 if blackscreen.active then
  blackscreen.y-=3
  if blackscreen.y < 0 then
   blackscreen.active=false
  end
 end

 if #bloodstains < 60 then
  x+=randi(5)
  y+=randi(5)
  r=randi(5)
	 add(bloodstains,{x=x,y=y,r=r})
 end
 
	if player.showresult then
	 if btnp(❎) then
			pageoffset+=1
			if pageoffset > 2 then
				pageoffset=1
			end 
	 end
	end
 
end

function draw_hud()
  -- spot 
	circfill(player.x+4,player.y+4,spot_radius,0x1800)
 
 -- reset camera
	camera()
	
	-- result table
	if player.showresult then
		fillp(0b0101101001011010)
		-- back
	 rectfill(0,0,127,127,0x67)
	 fillp()
	 -- frame
	 rect(0,0,127,127,1)
	 -- bloodstains
	 for b in all(bloodstains) do
	  circfill(b.x,b.y,b.r,8)
	 end
	 
	 -- text
		print("\^o8ff\f7game score:",2,2,7)
		print("\*f_",0,5,1)
		print("\*f_",60,5,1)
		print(result(maps,pageoffset),2,12)
		print("PAGE "..pageoffset,100,2,1)
		print("PRESS ❎ TO SWITCH PAGES",2,120,0)
	else
	 print("\^o0ff\f6"..current_level.name,1,1)
	 print("\^o0ff\faSTROKES: \f7" .. player.strokes[player.level].." \faPAR: \f7"..current_level.par,0,121)
  local term_txt=term(player.strokes[player.level],current_level.par)[1]
  local term_col=term(player.strokes[player.level],current_level.par)[2]
	 print("\^o0ff\f"..term_col..term_txt,78,121)
 end
 if blackscreen.active then
	 rectfill(0,0,127,blackscreen.y,0)
	end
  
end
-->8
-- obstacles

function init_obst()
 timer=0
 cannons={}
end

function update_obst()
 timer+=1
 if timer > 1000 then
  timer=0
 end
 
 -- enemies
 local enemies=maps[player.level].enemies
 for o in all(enemies) do
  o.x+=o.xspd
  o.y+=o.yspd
  
  -- tile collision (change direction)
  if tile_collision(o.x,o.y,0,0) then
   if o.xspd > 0 or o.xspd < 0 then
    o.xspd *= -1
   end
   if o.yspd > 0 or o.yspd < 0 then
    o.yspd *= -1
   end
  end
    
  -- delete slime on contact
  for s in all(slime) do
   if aabb(o,{x=s.x,y=s.y,w=8,h=8},0) then
   	del(slime,s)
   end
  end  
    
  -- on player collision - move player
  if aabb(o,player,0) then 
   if o.xspd > 0 then
    player.x-=1
    arrow.x-=1
   end
   if o.xspd < 0 then
    player.x+=1
    arrow.x+=1
   end
   if o.yspd > 0 then
    player.y-=1
    arrow.y-=1
   end
   if o.yspd < 0 then
    player.y+=1
    arrow.y+=1
   end
  end
  
  -- animations
  o.img=animate(o.img,o.frames[1],o.frames[2],0.1,true)
 end
 
 -- magnets
 for m in all(maps[player.level].magnets) do
 	 local angle=atan2((player.x-m.x),(player.y-m.y))
   
  if check_los(player.x,player.y,m.x,m.y,m.strength) then
   -- pull the player to magnet
   if not aabb(player,m,2) then
	   player.x -= cos(angle) * 1
	   player.y -= sin(angle) * 1
	   arrow.x = player.x
	   arrow.y = 0
   end
  end
	 -- animations
	 m.img = animate(m.img,25,28,0.1,true)
 end
 
 -- cannons 
 -- create on timer
 for c in all(maps[player.level].cannons) do 
  c.timer += 1
  if c.timer == c.frq + c.base then
  	add(cannons,{x=c.x,y=c.y,xspd=c.xspd,yspd=c.yspd,w=8,h=8,img=29})
  	sfx(11)
  	c.timer=c.frq
  end
 end
 
 -- update and collision
 for c in all(cannons) do
  c.x+=c.xspd
  c.y+=c.yspd
  if aabb(player,c,0) and not player.restart then
  	spot=true
  	player.restart=true
  	player.no_fall_anim=true
  	player.spd=0
  	sfx(5)
  end
  if tile_collision(c.x,c.y,0,0) then
  	del(cannons,c)
  end
 end
 
 -- laser
 for l in all(maps[player.level].lasers) do
  if l.move then
	  l.angle+=0.001
	  if l.angle > 1 then
	   l.angle=0
	  end
	 end
  sfx(12)
 end
 
end

function draw_obst()
 local enemies=maps[player.level].enemies
 for o in all(enemies) do
	 ovalfill(o.x-2,o.y+4,o.x+4,o.y+7,1)
  spr(o.img,o.x,o.y)
 end
 
 -- magnets
 for m in all(maps[player.level].magnets) do
  ovalfill(m.x-2,m.y+4,m.x+4,m.y+7,1)
 	spr(m.img,m.x,m.y)
 end
end

function draw_obst_foreground()
 -- cannons
 for c in all(cannons) do
  spr(c.img,c.x,c.y)
 end
 
 -- lasers
 for l in all(maps[player.level].lasers) do
  local ray = create_ray(l.x,l.y,l.angle)
  line(l.x+4,l.y+4,ray.dx,ray.dy,8)  
  spr(30,l.x,l.y)
 end
end
-->8
-- utils

------------------------------
-- sprite animations
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

------------------------------
-- tile collision 
function tile_collision(x,y,offset,flag,size) 
 if not size then
  size=7
 end
 
 if has_flag(x+offset,y+offset,flag) or
    has_flag(x+size-offset,y+offset,flag) or
    has_flag(x+offset,y+size-offset,flag) or
    has_flag(x+size-offset,y+size-offset,flag) 
 then	
  return true
 end
 return false
end

function has_flag(x,y,flag) 
	if fget(mget(flr(x/8),flr(y/8)),flag) then
		return true
	end
	
	return false
end 

-- aabb collisison
function aabb(obj1,obj2,offset) 
 return(
  obj1.x + offset < obj2.x + obj2.w - offset and
  obj1.x + obj1.w - offset > obj2.x + offset and
  obj1.y + offset < obj2.y + obj2.h - offset and
  obj1.y + obj1.h - offset > obj2.y	+ offset 
 )
end

------------------------------
-- sine wave
function sine_wave(x,amp,frq)
	 local amplitude = amp
	 local frequency = frq
	 local speed = time() * 2
	 
	 return sin((x * frequency) + speed) * amplitude
end

------------------------------
-- random
function randi(v)
	return flr(rnd(v+1))
end

function randbi(f,t) 
	return flr(rnd(t+1-f))+f
end

------------------------------
-- distance
function dist(o1,o2)
  return sqrt(((o1.x+4) - o2.x)^2 + (o1.y - o2.y)^2)
end

-- line of sight
function check_los(x1, y1, x2, y2 ,maxdist)
  local dx = x2 - x1
  local dy = y2 - y1
  if abs(dx) > maxdist or abs(dy) > maxdist then
    return false
  end
  
  local dist_sq = dx*dx + dy*dy
  if dist_sq > maxdist*maxdist then
    return false
  end
  local dist = sqrt(dist_sq)
  
  if dist > maxdist then
   return false
  end  
  
  -- if they are practically on top of each other, avoid dividing by zero
  if dist == 0 then return true end
  
  -- normalize the step vectors
  -- we step by 4 pixels at a time to be fast yet precise
  local step = 4 
  local step_x = (dx / dist) * step
  local step_y = (dy / dist) * step
  
  local curr_x = x1
  local curr_y = y1
  local checked_dist = 0
  
  -- march from enemy to player
  while checked_dist < dist do
    -- convert screen pixels to map tile coordinates (divide by 8)
    local tile_x = flr(curr_x / 8)
    local tile_y = flr(curr_y / 8)
    
    -- look up what sprite is at this map location
    local tile_sprite = mget(tile_x, tile_y)
    
    -- check if that sprite has flag 0 enabled (wall flag)
    if fget(tile_sprite, 0) then
      return false -- path blocked by a wall!
    end
    
    -- advance the point forward along the ray path
    curr_x += step_x
    curr_y += step_y
    checked_dist += step
  end
  
  return true -- path is completely clear!
end


-- ray
function create_ray(x,y,angle) 
 
 while not tile_collision(x,y,0,0,1) do
  x+=cos(angle)*1
  y+=sin(angle)*1
  
  if aabb(player,{x=x,y=y,w=1,h=1},0) then
  	if not spot then
		  sfx(5)
		 end
		 
  	spot=true
  	player.restart=true
  	player.no_fall_anim=true
  	player.spd=0
	  
   return {dx=x,dy=y}
  end

  if tile_collision(x,y,0,0,1) then
   return {dx=x,dy=y}
  end
 end
 
 return {dx=x,dy=y}
end

-- * colormap(str) 	a string with color-values separated by newline
function draw_img(colormap)
	local rows=split(colormap,"\n",false)
 for y,r in pairs(rows) do
	 y-=1
	 if r then
	 	local columns=split(r,"",false) 
	 	for x,c in pairs(columns) do
	 	 if c != " " then
		 	 x-=1
		   rectfill(x,y,x,y,"0x"..c)
		  end
	 	end
	 end
 end
end

__gfx__
0000000000d66d0000d67d5005d11d5005d76d00002222000422224000444400004444002882221188221333333112a9982129822a9218983312893300000000
000000000d7777d00d6116d55d7667d55d6116d002eeee20426666240449a4400449a440298882219982213333122988a8228a9a89821a983211898300000000
00700700d676676dd771867dd661166dd768177d2222222226611662428448244284482422a999818aa92213312a9822298998899a822a8288228a9800000000
00077000611dd116676d7161718778171617d67622eeee2226175162422442244224422411288a9211288a211228a921129a82222898892299a8998200000000
0007700071877817676d7161611dd1161617d6762a2222a2261551620449a4400449a4402228a9982228a9212298898212a88211129a8221889aa82100000000
00700700d661166dd771867dd676676dd768177d492ee2942671166205d656d005d656d09889989a9889989228a228a931229aa82289a2132189982200000000
000000005d7667d50d6116d50d7777d05d6116d0441221444e6666e4465d656441111114a9a8228aa9a8228a89a1289833122899889221333288a98300000000
0000000005d11d5000d67d5000d66d0005d76d0006444460002ee2004499a944465d65642892128928921289898129a2333122889a2113333321893300000000
0882700000027000000000000011110000dddd00899999988aaaaaa8400000000000000200000000000000000000000000000000001111000000000000000000
88226000008260000000000001cccc100d1111d098888889a888888a240000000000002407600760007676000670067000676700015511100066660000000000
0222600008226000077777701cddddc1d1cccc1d899889988aa88aa8024000000000024008200d100082d10001d00280001d280015665111667dd76600000000
0000600000206000078888701cd11dc1d1cddc1d89a88a988aa88aa8662466666666246608200d100082d10001d00280001d28001576511177d77d7700000000
0000100000001000072882701cd11dc1d1cddc1d98899889a88aa88a611241166112411608200d100082d10001d00280001d280011551111667dd76600000000
0000100000001000007887001cddddc1d1cccc1d998aa899aa8aa8aa677777766777777608881110008811000111888000118800111111115566665500000000
00006000000060000007700001cccc100d1111d0898888988a8888a8555555555555555500881100000810000011880000018000011111100055550000000000
0000600000006000000000000011110000dddd00889aa98888aaaa88555555555555555500000000000000000000000000000000001111000000000000000000
33333833338888888888883383333333888888883333383334343443334333333333333344343343343443443333333334333333000000000000000000000000
33333333338388888888888338333333888888888833833343434344333333444433333324223423324324423343434343334333000000000000000000000000
33388388833388888883883383338383888888888333333332442423433344233244333344434343343432243344244333342243000000000000000000000000
33833338338338888833883383333833888888883333838344242434333424344344433334242443334242433422424433334433000000000000000000000000
33333888333338888338333388833333888888883833383322424243334242433424243343424333334424343444422343433333000000000000000000000000
33388888333888888838333388883338888888883888333334444334343434444442444332443333334444233243444433324333000000000000000000000000
38888888333333833333833388883833888888883338338342432242324322422422242344333433333334443422423334333334000000000000000000000000
33888888333333333383333388888833888888883383333834344344343343444434434433333333333333333434434333333342000000000000000000000000
3333333b333333333bbbb3bbbbb3bb33333333333b3bbab300006000000000000000000000000000000000000000000000000000000000000000000000000000
b3b3b33333b33bb33b3bbbabbabbbb3333b33333bbbbbbbb00006000000000000000000000000000000000000000000000000000000000000000000000000000
333333333333333b3b3b33bbbba3b3b3b333b3b3bababbbb00d757d0000000000000000000000000000000000000000000000000000000000000000000000000
33a3b3b333b3babb33b3b3b3ba333333b3b33333bb33bbab00665660000000000000000000000000000000000000000000000000000000000000000000000000
333a33b3333333bb33333b3bbb3b3b333bb3a333bb3b33bb00551550000000000000000000000000000000000000000000000000000000000000000000000000
3b3b33333b3b33bb3b3b333bbbb33333bbbbb333bbabbb3b00777770000000000000000000000000000000000000000000000000000000000000000000000000
33b33ab33333bbab33333b33b3b33333bab33b3bb3bbab3300677760000000000000000000000000000000000000000000000000000000000000000000000000
b33b333333bb3bbb33b33333bb333333bbbbbbb3bbbbb3bb00677760000000000000000000000000000000000000000000000000000000000000000000000000
ddddddd1333333333355553333666633555555555555555555d66d553333333355505555558585855bbb5b555555555566666666dddddddd555b55b533333333
d555555133333333351111533d3333d3111111111111111111d66d11399999931111011111112211111b13111110011155555555d555555d1a31131a11111111
d5555551333333335100001563377336515555555101010551155155344444435100505081588855515ba5955150055550101015d555555d51ba55b301010101
d55555513333333310000001637777361111111116060601111551113255552310111001111121211113b1311110011150606065d555555d113111b110101010
d55555513333333300000000637777365555155556d6d6d55515515532555523505510555588888555b935b55556655550606065d555555db5531b5500000000
d55555513333333300000000633773361111111111111111111551113444444310111011122211111139aa311111111150707075d555555d3111b11100000000
d555555133333333300000033d3333d33333333333333333331551333332233333333333333333333bbbba9b3333333350707075dddddddd3333333300000000
111111113333333333000033336666333333333333333333331551331114433333333333333333333333bbb93333333350606065111111113333333300000000
3333333333333333333333333333333333333333333333333333333333333333333383833333333333333333333b333334333333333333333333333337373733
33d6653333333b33333666333333173333166633337333333366663333fff333333333333388333383833838331b333a14333233333333333336633367376767
35666d533b43b33b33676663333316633161d163166333333d5555d33fff7f333383388338888833333333833333331b33333433343332433335533337373337
5d66d6dd3343b34333060663333163333316663333163333351510533f81f13333383833388888883382388333333333333314333423234336d55d6367676767
dddd6d1133b4b343116067d3331633333161d16333316333310155533ff89f113382883338888888333832333a333b3332333333343243323555555337333737
155d111331bb4433116d6d331663333333166633333316633515105328811f218388283388888883333333831b331b3314333343311241433331133367676767
31111133111bb43333333333316333333161d1633333163335155553222222883383833333888833328333333333333333343143333333333335533337373737
33333333333333333333333333333333333333333333333315555553388888833838333333333333333338333333333333143333333333331115533333676763
15533333333333333333333333333000000333330003b3333333300000000000333b333300000000b3b3333333333333cc333333333c1333333333111111cccc
3333335d333bb33333b3333333b333000033b3330003b3333333330000000000333bb333000000003b333b3a33343333cccc3333333c1333333311111111cccc
333331553333b333333333333b333330033333330033333333b33300330333003b333333000001001b3333b333343333cccccc3333cc1133331111113111ccc3
3dd6333333b3333333b33333333b333333b3333300333b333333330033333333333333b300000000333331b334233333cccccccc33cc1133111111113111ccc3
1555333333333b3333333b333333333333333333003333b33333b10033b3b333333333330100000033b3a33333432333111111113ccc1113cccccccc3311cc33
33333d63333b33311333333333b3b3333b3333b3003b33b33b333000333333331113311300000000333b333331122243111111333ccc111333cccccc3311cc33
3333155333333310013333333333333333b333330013333333b33300333b3b330001100100001000331b33333333333311113333cccc11113333cccc3331c333
15533333333331000013b33333333333333333330003333333333100333333330000000000000000333333333333333311333333cccc1111333333cc3331c333
333333333333a93333333333555555553333333333333333333333333333333333333383ddddddd5131313131d6776d3ddddddd5333333333333333300000000
332242333a3a33a33536535511d66d11333abb3333566533333338383333833333666333d6777765313131313d6776d1d5666615333333333443333300000000
321111233a933933333d56335122225533a33333314444133388d333333333833666e283d7777775131313131d6776d3d6666665333a333a3349333300000000
3400004333393a93353333531124421133b3ab3332165123838268d33f88883386658088d7777775313131313d6776d1d66666653a33a3a33324933300000000
342242933aa9a94a33563d335524425533ba33b33424424333268683ffff28833d760288d7777775131313131d6776d3d6666665393393a33332433300000000
4424494233aa9493533333351124421133bab33335144153882266239ff8888388d22888d7777775313131313d6776d1d6666665393393933332493300000000
22499494333aa9493d535dd33333333333bb3b3314265243388222683388883388888888d6777765131313131d6776d3d5666615191191933332449900000000
333243333a333933335333533333333311bb333311244233388888883883333333888833555555553131313111d66d3155555555333333331122924900000000
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
044444044444444444440444444444040444544444444444445444e4444444040444444444444451514444445444443744445444444451514444444444844404
04444464e44490444454c0d054444404044444b444444444b444444444b444040484644444444444a444444444644404044444b44444b4e444b4a444b4444404
04575704868626e5a614040303140704044314141514728214a614c214c214040405141414141414515151571435141455141457515151c2141414d614141404
04430303034390d714f5e014f5f5f5040414b5c6c6c6c6c6c6c6c6c6c6c6f60404c2b090909090909090909090a01404041414031414140314141414a6140304
041414049696566214e50414144314040433c2c2c2c2c2c2c2a28214b5c21404040314979714a61451424251519514141487515142425114c2c514d614141404
045303535353c0a014151414f5f514040404040404040404040404040404f60404c290c21412424242422214c29014040414141413535353031353534314a604
04f5f504d6d6566514c20414135343040404040404040404040404a614621404041497979797141414514242425151525151424242511414c51414d614141404
0453234303534390472727f5142714040444444494444444444444444444f60404149014c2141242422214c21490140404535353331514141403141423431404
04f5f504d6d65692a614049797979704044444444444544444444414149214040414979797971414a65142424242510451424242425115d514b614d614151404
04533323235333c0a01427271427150404f6e6e6e6e6e6e6e6e6e6e6e6e6e6040414901414141452521414141490140404471414141414b51414a61414234304
041414641414040404040497979797040414031414141414141414141414e7040414a79797a714621452514251512212425151425152141414c6c6d6c6c61404
045303535353534390142714b090900404f604040404040404040404040404040414903251141414141414510290140404040404f40404f40404f40404145304
0447141403030454445404a7a7a7b70404033314150404040404040404040404041414a7a7141414141451514232141412424251511414c5141414d614a61404
04535353035333b090a004b0d014140404f6444444444444448444444444440404c29042321414b0a01414024290b5040444444414e444146444144444145304
041414133314041414c504c21414140404141414144444444444444404444404041414141414c2c2515142514252751414024251425151771414b6d6a626b504
04535353535333905190a0d0b514b50404c6c6c6c6c6c6c6c6c6c6c6c6c6f60404c29042221414d0c01414124290140404151403141414141413535353533304
04141553437404d51414046282141404041414140314030303135343041414040404040404045151515151515151515151515151515151515104040404041504
04535333b090909090d08614147262040404040404041414040404040404f60404c2c09090a014141414b09090d0a60404261413035353535353533314b51404
041414233314641414140404040404040414051403031343142353530414140404141414141414e5141414525142424242515214c2141414141414143646a604
045333b0d002429090a014747292140404515151510482c204a444444444f6040414c21514c0a01414b0d047b514a60404979797970404f40404f40404f40404
040514061414141414a604629214e5040497979797040404040404040414140404c21447141414f4c2140606514242424251141414726262626282141514c204
0406149002326712429005146214140404d636515104040404a666969696f6040414c214c2c29014149015a6a6a6a60404b7a7a7a744a41464441444e4534404
0406140403140404040404c21414140404a7a7a7a744444444444444640404040406061414c2c2060606c2145251424251521414726292c21462621414626204
04060242424242422290a6146214140404d6665151543764541696969696f6040482e5656514901414901414a6b5a60404141423034314141414141413534304
041414041443444437440414141414040415140606d714e614e614e61406140404140606060606d7d7d714171451424251626262629214145214a26262629204
0406751242222212b0d01414a262040404d6669696969696969696969696f604046262a6c215901414901414a603140404141414142353535353535353535304
0414140413533314141404a61414140404071414d70606e614e614e614141404041414c2c2c214d7d7d7141414525151521414c2141414c21414c214c2141404
040602424225025290528714a657140404d6e6e6e6e6e6e6e6e6e6e6e6e6e6040462c2c21514c09090d08686b514b50404141414141414141414142353535304
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404140404140404140404
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404049090909090909090909090909090909004040404040404040404040404040404
044444440444445444444444a4444404045444041696960496969696049696969604169696969696962614169696960404446444b4b444644404944444908444
546454444444449044044444a444440404444444b44444444444b444444444049090909090909090909090909090909004000000000000000000000000000000
04140614045757031465141414726204041427049696969696969696969696969696969696969696965614669696960404626214a61414145704141414c09090
90909090909090d01404e0050303140404a6141414141414031414c2141406049090900404909090909090909090909004000000000000000000000000000000
04140614041414141414726262921404042727049696969696969696969696969696969656669696965655669696960404626262141414a61404b51404040451
1452145104040414140414140314c504041414a61414141414141406c21414049090900451040490909090909090909004000000000000000000000000000000
04140614041414a614146214141414040404c40496969696968696969696969696969696969696969656146696969604045714a2628214b5c504141404d4b514
1412521495d404751404141414141404900404041404040403041404040414060490900414515104049090909090909004000000000000000000000000000000
041406140414051414146214e5140304045106669696969696969696969696969696969696969696965615669696960404047414146214141404141404141414
1414123232140414850414b6b09090049004a7a71404a70414041404a7a7041404040404d5144551510404909090909004000000000000000000000000000000
041406140414a6c50314a262821414040414066696969696969696969696969696969676767676969656f56696965104045714c5c29214c21404141551141446
14f4143632325115140403149065e504900414141404140414041404141404140451515114c21414145151040490909004000000000000000000000000000000
041406145714c5c514c5c514a282140404140614767676767676767676767676767646051445473676761476767676040414147292c214141404141414141414
030603141242425252041414902727049004a614350414041404b50414140414041414c514c214c2142574515104909004000000000000000000000000000000
04140614141714c514c5141414621404043406e6e6e6e614e6e6e6e614e6e6e6e6143514141414141414b5b514b51404041472621414c2145704141414b514f4
060606f4141242321404d51490a01404900404041404b504a6041404b51404140414c214c2c2c214c21414141414049004000000000000000000000000000000
041406140303c5c5c5c5c5141462140404868686868686868686b514a61486868686268555140516868614868686860404d6d6d6040404040404141451141414
03060314149551423204c214c090a0049004a7a714041404b5041404a6b504b50414c2c2c2c2c214141414515104909004000000000000000000000000000000
041406141414c5c5c5c51414146214040436969696969696969646a6b536969696969686868686969646f5669696510404146214644444444404141404d71426
14f41416141404424204141414c090049004141414041404c2045504251404140451515114c5c214d55151040490909004000000000000000000000000000000
04140614031414040404047414621404041496969696969696965614b5669696969696969696969696562566969696040414621414c514140604141404d41414
1414141495d40442420414c214059004900414b5140414041404c204141404140404040414141451510404909090909004000000000000000000000000000000
04140614c514d514141414c262924304041696e73696969696962686861696969696969696969696965665669696960404146214141414060627272704040451
141495510404041222041403141490049004040414048204040414040404a7140490900414515104049090909090909004000000000000000000000000000000
04140614141414c214c2c2c21413530404969626169696969696969696969696969696969696969696561466969696040414a262626262620604141447141597
9797979777a5145214041414b090d00404a7a7a7c2a792a7a7a714a7a7a714049090900451040490909090909090909004000000000000000000000000000000
041406c514b514141414141413535304049696969696969696969696969696969696969696969696964614369696960404c514b6141414141404571414141497
979797971414871414c414149014c204041414141414c214141414141414b5049090900404909090909090909090909004000000000000000000000000000000
04040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
04040404040404040404040404040404040404040404040404040404040404049090909090909090909090909090909004000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008eeee800e80000e800008eeee80000e80000e800e80000000000000000e800e80000e80000000000008eeee80000e80000880088eeeee800000000
00000000008888880088000088000088888800008800008800880000000000000000880088000088000000000000888888000088000088008888888800000000
00000000882222220088000088008822222888008800008800880000000000000000220088880088000000000088222222880088880088008822222200000000
00000000880000000088000088008800000888008800008800880000000000000000000088880088000000000088000000880088880088008800000000000000
00000000880088880088888888008800000288008800008800880000000000000000080088228888000000000088000000880088228888008888880000000000
00000000880088880088888888008800000088008800008800880000000000600000880088008888000000000088000000880088008888008888880000000000
00000000880022880088228288008800000088008800008800880006000000000000880088002288000000000088000000880088002288008822820000000000
00000000880000880088008088008800000088008800008800880000000000000000880088000088000000000088000000880088000088008800800000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880000880088000888008800000088008800008800880000000000000000880088000088000000000088000000880088000088008800000000060000
00000000888888880088000288002288888822002288882200888888880000000000880088000088000000000028888888220088000088008888888800000000
00000000888888880088000088000088888800000088880000888888880007000000880088000088000000000008888888000088000088008888888800000000
00000000888828220088000082000028888200000028280000228888220000000000288082000082000000000002888882000088000082002888882200000000
00000000288882000088000080000002822000000002880000002828800000000000088080000020000000000000288220000088000020000228820000000000
00000000028220000088000080000000800000000000280000000208800000000000082080000000000000000000028000000082000000000008880000000000
00000000008000000028000020000000800000000000080000000002800000000000080880000000000000000000008000000080000000000008880000000000
00000000008000000008000000000000800000000000080600000000800000700000020880000000000600000000008000000080000000000002880000000000
00000000008000000082000000000008800000000000080000000000200000000000000280000000000000000000008000000020000000000000820000000000
00000000008000000020000000000008800000000000080000000000000000000600000080000000000000000000002000000000000000000000800000000000
00000000002000000000000000000008200000000000080000000000000000000000000080000000000000000000000000000000000000000000800000000000
00000000000000000000000000000002000000600000020000000000000000000000000020000000000000000000070000000000000000000000800006000000
00600000000000000000000000000000000000000000000000000000006000000000000000000000006000000000000000000000000000000000800000000000
00000000077007070000077000770770077007770077070700000000000000000000000000000000000000000000000000000000000000000000200000000000
00000000077007770000077007070707070700700700077000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070700070000070707770707077000700700070700000000000000000000000000000000000000000000000000000000000007000060000000000000
00000000077707700000077707070770070707770077070700000006666666666666666666666666000000000000000000000000000000000000000000000000
00000000000000000600000000000000000000000000066666666666666666666666666666666666666666666000000000000000000000000000000000000000
00000000000000000000000000000000000000666666666666666666666666666666666666666666666666666666666600000000000000000000000000000000
00000000000000000000000000000000666666666666666666666666dddddddddddddddddddddddd666666666666666666660000000000000000006000000000
0000000000000000000000000006666666666666666666ddddddddddddddddddddddddddddddddddddddddddd666666666666666000000000000000000000000
000000000000000000000066666666666666666ddddddddddddddddddddddddddddddddddddddddddddddddddddddddd66666666666600000000000000000000
000000000000000000666666666666666dddddddddddddddddddddd111111111111111111111111dddddddddddddddddddddd666666666660000000000000000
000000000000006666666666666ddddddddddddddddddd111111111555555555555555555555555111111111ddddddddddddddddd66666666666000000000000
00000000006666666666ddddddddddddddddddd11111111155555555555555555555555555555555555555511111111dddddddddddddd6666666666600000000
00000066666666ddddddddddddddddddd1111111111555555555555555dddddddddddddd555555555555555555555511111dddddddddddddd666666666660000
00666666dddddddddddddddddddd1111111111555555555555555dddddddddddddddddddddddd55555555555555555555551111ddddddddddddd666666666660
666dddddddddddddddddddd111111111155515551555155515ddddddddddddddddddd66ddddddddd155515551555155515551551111dddddddddddd666666660
ddddddddddddddddddd1111111555555555555555555555dddddddddddd66666666666666dddddddddd5555555555555555555555551111dddddddddddd66660
dddddddddddddd111111551555155515551555155515dddddddddddd66666666666666666666dddddddddd155515551555155515551055111111dddddddddd60
dddddddd1111115555555555555555555555555555ddddddddddd66666666666666666666666666ddddddddd55555555555555555550555555551111ddddddd0
ddd11111155515551555151515151515151515151ddddddddd6666666666666677666666666666666dddddddd51515151515151515150515151515151111ddd0
111555555555555555555555555555555555555ddddddddd66666666666677777777776666666666666dddddddd5555555555555555550555555555555551110
5515551555155515551555155515551555155ddddddddd66666666666666777777777766666666666666ddddddddd51515151515151515051515151515151510
555555555555555555555555555555555555dddddddd666666666666777777777777777777666666666666dddddddd5555528888555555055555555555555550
15151515151515151515151515151515151ddddddd666666666677777777777777777777777777666666666dddddddd515151288882515051515151515151510
5555555555555555555551555155515551ddddddd66666666777777777777777777777777777777776666666dddddddd51555188888888888882665551555150
151515151515151515151515151515151dddddd66666666777777777777777777777777777777777777666667dddddddd5151518888888888882661515151510
55555555555555555555555555555555ddddddd6666666777777777777777777777777777777777777776666666ddddddd515551888888888882665155515550
1515151515151515151515151515151ddddddd6666777777777777777777777777777777777777777777777766666dddddd51515128888888882661515151510
515551555155515551555155515551ddddddd6666777777777777777777777777777777777777777777777777666666ddddd5151515288888882665151515150
15151515151515151515151515151dddddddd66667777777777777777777777777777777777777777777777776666666ddddd515151518888882266515151510
5551555155515551555155515551dddddddd6666677777777777777777777777777777777777777777777777766666666ddddd51515151505151566151515150
151515151515151515151515151dddddddd66666777777777777777777777777777777777777777777777777776666666dddddd5151515101515166515151510
515151515151515151515151515ddddddd6666677777777777777777777777777777777777777777777777777776666666ddddd1515151505151576151515150
15151515151515151515151515ddddddd66666677777777777777777777777777777777777777777777777777776666666dddddd151515101515176515151510
5151515151515151515151515dddddddd666667777777776666666677777777777777777777666666667777777776666666dddddd15151505151576151515150
1115111511122215111511151ddddddd6666677777666666666666666777777777777777766666666666666677777666666dddddd11511101115176511151110
515151515154495151515151dddddddd66667777666666666666666666666666666666666666666666666666667777666666dddddd5151505151576151515150
151115111514491115111511dddddddd66667776666666666666666666666666666666666666666666666666666777666666dddddd1115101511176115111510
515151515124915151515151dddddddd666777766666600000000006666666666666666666600000000006666667777666666ddddd5151010151576151515150
11151115114491111111111dddddddd6667777666000000000000000000666666666666000000000000000000666777766666dddddd11011011111d111111110
51515151514491515151515dddddddd66677776700000000000000000000dd666666660000000000000000000076777766666dddddd10151505151d111515150
15111511154495111511151dddddddd66777766000000000000000000000dd6666666d00000000000000000000066777766666ddddd11111101111d111111110
5151515152495151515151dddddddd66677776000000000000000000000dddddddd66dd0000000000000000000006777766666dddddd5151510151d111515150
1111111114491111111111dddddddd6677777000000000002200000000dddddddddddddd000000002200000000000777776666dddddd1111110011d111111110
5151515114491151115111ddddddd66677770000000000000000202000dddddddddddddd0002020000000000000000777766666ddddd1151105101d111511150
1111111114491111111111ddddddd66677770000000000000000020000dddddddddddddd0000200000000000000000777766666ddddd1111011110d111111110
515151512491515151515ddddddd666677700000000002002222200000dddddddddddddd00000222220020000000000777666666ddddd110511151d110115110
111111114491111111111ddddddd666677710000000000222888220200dddddddddddddd00202288822200000000001777666666ddddd110111111d111011110
115111514491115111511ddddddd6667777110000000000288888200000dddd77dddd7d000002888882000000000011777766666ddddd1101111111761101110
111111114490111111111ddddddd6667777111000000002228888220000dddd7777777d00002288882220000000011177776666dddddd1101111111761110110
511151024911001151115ddddddd6667777111100000000022888200000ddd77777777d00000288822000000000111177776666dddddd0101111111761110110
110000144911665111111dddddd66667777111110000200022222200000dddddddddddd00000222222000200001111177776666dddddd0000111111761110110
001111166666555111111dddddd666677777d1111100000000222000200dddddddddddd00200022200000000111111777776666dddddd0300001111761110110
000066655555555511111dddddd666677777dd11111111200000200011ddd77dddd777dd110002000002111111111d777776666dddddd0000000011761110110
0111555555555555133005ddddd6666677777d1111111111111111111ddd7777777777ddd11111111111111111117d777766666ddddd50030300300761111010
0111155555555555300305ddddd6666677777dd11111111111111111dddd70077770077ddd11111111111111111ddd77776666dddddd50030000000661011010
0111155555555555330000dddddd6666677777dddd1111111111111ddd7000000000000dddd1111111111111ddddd777766666dddddd33030030300661000110
0111155555555555530300dddddd66666777777ddddddddd11111ddddd70000000000007ddddd11111ddddddddddd777766666dddddd00000300030661000310
0011115555555535503000ddddddd66666777777dddddddddddddddddd00000000000000dddddddddddddddddddd7777666666dddddd00300000300066503000
00111155555555355030305ddddddd666667777777ddddddddddddddd7000000000000007ddddddddddddddddddd77766666ddddddd500003030030066530000
00111115555355b35300000ddddddd666667777777777dddddddddddd1100000000000011dddddddddddddddddd777766666ddddddd000000003003366330030
30111115535535b33b03000dddddddd666667777777777777777ddddd11100000000001117dddddddddddddddd777766666dddddddd000000003331166513300
0001111553b5333330030005dddddddd66666777777777777777777dd11111117711111117ddddddddddddddd777766666dddddddd5000030003111166511130
00033115533b333030003000ddddddddd6666677777777777777777777111117777111117777ddddddddddd7777766666ddddddddd0000003031110055501110
0300303333b33030300000005dddddddd666666677777777777777777d77777dddd77777d777777777777777776666666dddddddd50000003311000055500010
0030030333b30003000003000ddddddddd666666677777777777777777dddddddddddddd777777777777777776666666ddddddddd00000000030000000000000
00000300030003003000000005ddddddddd6666666777777777777777766dddddddddd6677777777777777776666666ddddddddd500000000003000000003030
000000000303000003000303055ddddddddd6666666777777777777777666666666666667777777777777776666666ddddddddd5500000000030330030003300
0000300000000000000000000055dddddddddd666666677777777777777666666666666777777777777776666666dddddddddd55000000000003303333333030
00030000003000000000000000055dddddddddd6666666666666777777776666666666777777776666666666666dddddddddd550000000000000300303000300
000000000000000000000000000055dddddddddddd6666666667777777777666666667777777777666666666dddddddddddd5500000000000000300303000000
000000000000000000000000000bb55dddddddddddddd6666677777777777666666667777777777766666dddddddddddddd55000000000000000000000000000
000000000000000000000000bb3b33555dddddddddddd6666677777777777766666677777777777766666dddddddddddd5550000000000000000000000000000
000000000000000000000000bb3bbb3555555dddddddd6666677777777777777777777777777777766666dddddddd55555500000000000000000000000000000
00000000000000000000000bbbaabbab555555ddddddd6666677777777777777777777777777777766666ddddddd555555000000000000000000000000000000
000000000000000000bbbbbbbbabbbbbb55555ddddddd3633677777777777777777777777777777766666ddddddd555553333000000000000000000000000000
00000000000000bbbbbb3bbbbaaabbb3335555dddd3dd336367777777777777777777777777777776666dddddddd555533333bb0000000000000000000000000
0000000000000bbbbbbbbbbbbaaa33333335555dddddd3b3b667777777777dd7777dd77777777773636dddddddd55553333333bb000000000000000000000000
0000000000000bbbbbbbbbbbb3bb33333333555ddddddd336667777777776117777116777773777b366dddddddd55533333333bb000000000000000000000000
00000000000000bbbbbbb333bbbbb33333333555dd3ddd3d666777dd777611166661116777dd777366dd3ddddd55533333333babb00000000000000000000000
0000000b00000000bbbbbbb3bbbbbb333333333555ddddddd63677117771111dddd11117771177666d33dddd5553333333333bbbbbbbaabbb000000000000000
000000000000000000bbbbb33bb3bbbb333333333555ddd33d6666111dd111133111113dd1116666d333dd555bb3333333bbbbaabbbbbabbbbbbb00000000000
00000000b0000000000bbbbbbbbbbbaab333333333555dd33d6666111131111b311111311111666ddd3dd555bbaabbabbbbbbb3aaaaaabbbbbbbbb0000000000
0000000000000000000000000bbbbbbaab3333333333555dddd6111111311111311113b11111116dddd555bbbbabbbbbbbb3333baaaaaaaaabbbbb0000000000
00000000000000bbb00000000000bbbaabb333333333333dddd1111113b1111131113bb31111111ddddbbbbbbbbbbbb333b3bbbb3abbabaaabbbbb0000000000
00000000000000bbb000000000000bbbbbbbbb33333333333311111133b111113111311311111111bbbbbb333333333333333baababbbbbbbbbbb00000000000
00000000000000000000000000000bbbbbbabbbbb33333333333311131311113b1113113111113333bbbb3333333333333333baababb00000000000000000000
0000000000000000000000000000000bbbbbbbb3333bb3333333333333b111131b1131133333333333babb3333333333333aaaabbbbbbb000000000000000000
0000000000000000000000000000000000bbbbb3333bbbb333b333333b3bbb333333333333b3333bbbbbbbb33333333333bbbbbbbbb000000000000000000000
00030000000000000000000000000000000bbbbb3333333bb3bb33111111133333b33333333bbbbbbbbabbbb3333333b33bbbbabbbb000000bbb000000000300
003000000000000000300000000000111111111111111111113331177777113bb1111111113bbb11111111111111111111bbbbbbbbb0000b000b000000003030
03000000000000000000000000000117717711777117711771bb3177171771bbb177711771bbb117717771177177117771bbbbb0000000000000000000000330
30000000000000000000000333000171717171771171117111bbb177717771aaa117117171bb0171111711717171711711b000000000000000000000000000b0
33b00000030000000000000003300177717711711111711171bbb177171771aaab1711717100011171171177717711171000000000bbbb0000000003000000b0
3b0003003b000000000000000000017111717117717711771100b117777711baab1711771100017711171171717171171000000000bbbbb00000000300033030
30000030300000000000000000000111011111111111111110000011111110000011111110b001111b11111111111111100b000000000bbb0000000300030000
300000033000000000000000000000000000000000000000000000000000000000000000bbbb00000000000000000000000000000000000000000000b0030000
300b000030000000000000000000000000000000000000000000000000000000000000000bbb0000000000000000000000000000000000000000000030030000
30030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003003b30030
30330000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303b00300
303300003b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033b00300
bb33000033b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033b03000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000004040404040400000000000004040000001010101000100000000000000000000000000000000000000000000000000000000000000000001000204000000000000000001000008010000000000010000000000000001100000000000000000000800002020202001000000000100000080000181000101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
4044444544464444444e4644454444404044444544444444444444444544444040464445444444444444444445444640404444444544444446444844444544444044444445444e444446444444444440406969454e444444464e44444469694040444444444444444b447373444b444444444444444444444444444444444440
4041414126414141414141414141414040414141414141515d41414141584140402c2c2626262c262650262626284140406041415b41415b414141414141414140415b4141416041412c412c415841404069696541412a26265b61686263694040404040404040415d2c2c2c412c414040404040404040404040404040404040
402c5c41264141415241415c415c4140404141412c414141414141505841414040262c262c41415d41414141582a26404041414141414141412726262641414140414141415b414141414126262626404069696550412c2629416669655b694040444440444444414141412c4141414444444944444444444e44444440444440
40414141264141414141414151414140404150414141415b41414141414150404026262626404040404040404040404040415154412c4141407e412a265c41414041515c4141414141272626292c414040696965516168686868626764686940405b4140505c6b41684040404028412740404040405041415641414146416b40
40555b412a284141414141414141584040414141415b414127262626262841404026262c414644444e44444448444440404141412c412c274041412c4f26414140414141415c4141264041415b41414040696965416669696969655f6669694040416a405341416169694540454141404540454445412c414f412c4141414140
40414141412a28414141414141414140404141524141504126414141412a2640402626414141272626262626285557404041415c5d41412640415d415e264141444141416041412729405b412c415b40406969654163646763676426666969404041414057416669696965444141414041405b41272841414141415e40414140
4041414141412a2841414141415d414040415041414141272941502c4141414040412a2626262951564141472a2841404041512c2c414126404160412c26262c41415741415141264140415b415b41404069645b616862415b2c41506669694040414140414140676767644141415b4441444141262640412c415d4f40414140
404141415441412a28412c415b414140404141415c414126414141414141414040415e41412c414152412c415026414040414141534127294041412c412a264141415a4141412726414041415b415b4040695241666965415c41414f6669694040604140545540416a41415141414141414127262626404156272841405b4140
404151415b414141264141414141414040415b4141504126414141414153414040412b50414141412c415a414126414040415541414126414041514156412a26412c41414141264141405b745b5c41404069544163676441272626266367674040414141415940414160604040404040404040404040405b4f26262c40414140
40414141414141412a2841414141414040284141414127294150412b4159414040414141412c41414141412c4126414040414141412726414041412b4f2c412640412c4141272941414040404040404040696250414153272629602c2c292740404160604152404160415b46444444444e444444444e46414126262946414140
404141412c415b41412641414141414040262626262629414141414141415740404040404040404040404141272941404041412726262941404141412c41606040262626262941414140444444444e4040696965262c41262961686261686840405141404040405f414141514141415b4158414126412641412a26415d415b40
404141414141414141264153414141404041414150415b2c414174414150414040444444444444444e464127295141404026262941414141464141606060604140415c4141415b4141405e5156415e4040696965616862264166696566696940406041404040404040404040404040404f4040404040404040402a262c414140
4041414141414127262941414141414040415c41414141414141414141415d40404141272626282c414127294153414040414141514160414141606041414141404141604141414141442c5e265629404069696566696526416367646669694040414144444b4444444448444444444a5a44444444444444444441412c414140
404141414127262941414141414141404041414141414141414141414141414040412b41412a26262c414141412b4140407e414141414141606041604141524140514141415c4141414141414141414040696964636764262c41415d63696940404160414141414141415b4141416a4141414141412c60602c606041412c4140
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
404645444444444e4444444444454640404444464446696944444444454444404044444e444a4444444444444444444040444444444444444444444440404040404444444444464545464444444e4440404544444446444444464444444544404046444444444445734544444444464040444444444544464644404444444440
40414141414141414141414141414140402c2c6c6c6c6969626862415e565e40404141414141415441416a4141414140402c41412c41416f6f6f6f6f404040404041415a41414141415b414141414740406f6f6f6f5f4141415f6f6f6f6f6f4040415e41512c2c2c294141414141414040416b41414141415b41402024234140
40415b41412c2c2c2c5b4151416a41404041416c6c6c69696969655b415241404041414141514141414141576a4141404041272841412c6f6f6f6f6f4040404040415341412c2c2c41412c2c55414140406f6f6f6f6f4141416f6f6f6f6f6f40404141412c2c4141414141514160414040416a415b4141415b41404121224140
4041414141414141412c4141416b4140406f6f2c4166696964676441415b41404040404040404040404040404040404040412a29716b416f6f6f6f6f404040404075415b414141412c2c2c4141414140406f606f6f6f6f416f6f6f6f6f6f6f404079797979797979797c79797979794040404041414160604040401541254140
4041415b414040404040402c5c414140406f6f2c2c666d404040404040404040404444444046444444444e444444464040412c2c2c416669696969694040404040404040404040404040404040404040406f6f6f6f6f6f6f6f6f6f6f6f6f6f404079797a79797979797c79797a79794040797979797979797979404120242340
4041414141444b444b44402c41417440406f6f2c2c636d444449444544444440404141614050417056415e415e4150404072414141606669696969694040404040444446404444737344444046444440406f6f6f6f6f6f6f6f6f6f6f6f6f6f404079797979797979797c797979797940407a7a7a7a7a7a7a7a7a402024234140
40412c41412c2c41414140412c4141404051414141416d41416060414141504040415b63405c2c41414141414172414040414141746063676767676740404040407e704140755b202341754041566840406f6f6f6f6f6f6f6f6f6f6f6f6f6f40407b7a7a7a7a7c7c7c7c7a7a7a7a7b40407d4141414141416060402124242340
40412c2c41412c41414140514141414040416a415b41415d415c41606041414040414141402c5d2c41417241415b4140404171606060404040404040404040404041415b405a762424775c4041416740406f6f6f6f6f6f406f6f6f5c6f6f6f404041412c41607c7c7c7c41416a6a5b4040411515151515151560402520241540
4041412c41412c2c4141402b262c4140406f6f41416b41414141415060415d4040414141402c2c29417260724161624040414160415044444444444444444440407241414041202424237640415b4140406f6f6f6f6f6f406f6f6f6f6f6f6f404079797979797c797979797979797940405b5541414141417d60402024227840
4041412c2c41412c2c2c40552a262840406f6f4170272841412c2c2a60604140405f5f5f4041416a4141604141636540404172724141417575757541416a414040414151405c215721245a4041414140406f6f6f6f516f6f6f6f6f6f6f6f6f404079797a79797c79797979797a79794040414141414158416041402124234140
404141412c40404040404041412c2940406f6f4040404028414141415b606040404141414040404040404040404040404060726a6a414141417541415b6a4140404171414041257824225a406a50414040416f6f6f6f6f6f6f6f6f6f6f6f41404079797979797c79797979797979794040797979797979797979404121224140
40416041414044444444442c41415240406f6f2c2c5640292c2c2c4141416040406b416a40444444444573454444444040414141414141414141415b5b5b4140405141414023254121225940714141404060416f6f6f6f6f6f6f6f6f6f415540407b7a7a7a7a7b7a7a7b7a7a7a7a7b404040407a7a7a7a7a4040401541252540
404141414140414141412c4141554140402c26262c4140412c2c2c5541416040404141414041746060606041414141404041754141415b6a415b6a5b5b4141404041415b404040412740404041416a40404141416f6f6f6f6f6f6f6f41606040406041412c2c4141416041515b416740406a6a415b41415a5a41535725594140
404141414140604141414f5441415840402c26602c2c40414141414141414140405b4141406060604141414141412c4040757575414141416a41414141416a4040414141414141412a2626262629414040752c2c2726282c2726282c2c2c75404041272c2c2c604141414175685b6a40407d7d7d5b4159415a25414125774140
4040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040
__sfx__
004200000b730127401975020760257702a7002a7002a7001f7002270022700237003170031700307003070030700307003070025700297002c7002f70032700377003c7003f7003f7003f7003f7000070000700
0002000024770207701c760197601575012750107500e7500c7500b75009750087400774006730067300671001700017000070000700007000070000700007000070000700007000070000700007000070000700
0001000013770117700f7700c7700a770077700477000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000800000b7500b7500e7500f7500f75011750127501375015750187501b7501e75022750267502b75030750377503b7502a7002e70033700347001c7001370019000160000f0000a00002000000000000000000
000100002e55021550175500f55007550035500155001550045000050000500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000270401f04018030140300f0300b0400804006040040500306001070000700007000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001900000b7500b7500b750000500e7500e75019750010502a75001050217501d750147501775020750237502931035310233102f310000500c050000500c050233102d3101e31029310000500a050000500a050
961900000b7500b7500b750000500e7500e75019750010502a75001050217501d750147501775020750237502931035310233102f310000500c050000500c050233102d3101e31029310000500a050000500a050
000600000000000000000000000000070000000000000000000700000000000000000007000000000000000000070000000000000000000700000000000000000007000000000000000000070000000000000000
00010000106500f6500e6500d6500d6500e6500f650116501365016650196501e65021650276502e65035650396503a6502f0003000031000330003400035000360003700038000390003a0003a0003b0003f000
0002000013350103500c3500d35010350183501d3501e3501a3500e3500a3500e350173501f350263502e350303502d350233501b35015350173501d350273503235032350313502b3501f3501b3500030000300
000300001767014670106700c650096500765005650026300063000620056000c6001060006600006002a6002f600376003960000600006000060000600006000060000600006000060000600006000060000600
d60f00080b6200b6200b6200b6200b6200b6200b6200b6203f6003f6003e6003e6003e6003e600066000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
__music__
01 06474344
00 08424344
00 07424344
02 08424344

