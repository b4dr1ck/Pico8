pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function dist(o1,o2)
  return sqrt(((o1.x+4) - o2.x)^2 + (o1.y - o2.y)^2)
end

function _init()
	poke(0x5f2d, 0x1)
 player={
 	x=64,y=64
 }

 ball={
  x=player.x,
  y=player.y,
  xspd=1,
  yspd=1,
	 dx=0,
	 dy=0,
	 r=1,
	 move=false,
 }
 
 mouselock=false
 mouseb=0
 mousex=0
 mousey=0

 maxr=5 
end

function _update60()
  mouseb=stat(34)
  mousex=stat(32)
  mousey=stat(33)
  
  if mouseb == 1 and not mouselock then
   mouselock=true
   ball.move=true
   ball.xspd=1
   ball.yspd=1
   ball.x=player.x
   ball.y=player.y
   ball.dx = stat(32)
   ball.dy = stat(33)
		 angle=atan2(ball.dx-player.x,ball.dy-player.y)
		 distance=flr(dist(player,{x=ball.dx,y=ball.dy}))
		 rsize=(maxr / distance) * 1.5 
		 printh("x"..ball.dx.."y"..ball.dy)
  end

 --gravity+=0.05
 
 if ball.move then
	 ball.r+=rsize
	 if ball.r > maxr then
	  rsize*=-1
	 end
	 if ball.r < 1 then
	  ball.r=1
	 end
	 
	 local movex=cos(angle) * ball.xspd 
	 local movey=sin(angle) * ball.yspd 
	 local remainingx=ball.dx-ball.x
	 local remainingy=ball.dy-ball.y
	 
	 if remainingx^2 + remainingy^2 <= movex^2 + movey^2 then
	  ball.x=ball.dx
	  ball.y=ball.dy
	  ball.xspd=0
	  ball.yspd=0
	  ball.r=1
	  ball.move=false
	  mouselock=false
	 else
	  ball.x+=movex
	  ball.y+=movey
	 end
 end 
end

function _draw()
 cls(12)
 circfill(player.x,player.y,4,7)
 circfill(ball.x,ball.y,ball.r,8)
 
 circfill(mousex,mousey,0,8)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
