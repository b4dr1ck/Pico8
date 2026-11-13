pico-8 cartridge // http://www.pico-8.com
version 43
__lua__

function randbi(f,t) 
	return flr(rnd(t+1-f))+f
end

function create_path(x1,y1,x2,y2) 
 local path={}

 if x1 < x2 then
		for x=x1,x2 do
		   add(path,{x=x,y=y1})
		end
 else
		for x=x1,x2,-1 do
		   add(path,{x=x,y=y1})
		end
 end

 if y1 < y2 then
	 for y=y1,y2 do
	  add(path,{x=x2,y=y})
	 end
 else
	 for y=y1,y2,-1 do
	  add(path,{x=x2,y=y})
	 end
 end
 
 return path
 
end

function _init()
 rows=6
 cols=6
 tilesize=4
 maxmapw=32
 maxmaph=32
 maxroomw=flr(maxmapw/cols)
 maxroomh=flr(maxmaph/rows)
 lastx=-1
 lasty=-1
 lastw=-1
 lasth=-1
 
 camx=0
 camy=0
 
 rooms={}
 roomindex=0
 paths={}
 roommap={}
 
 player={x=1,y=1}
 
 -- init empty map
 for y=1,maxmaph do
  add(roommap,{})
  for x=1,maxmapw do
			roommap[y][x] = 0
	 end
 end

 -- init rooms-object (with paths)
 for r=1,rows do
  for c=1,cols do
   local w=ceil(randbi(1,maxroomw)) 
   local h=ceil(randbi(1,maxroomh))
   local x=(c-1)*(maxroomw)+1
   local y=(r-1)*(maxroomh)+1
   local offsetx=flr(rnd(maxroomw-w))
   local offsety=flr(rnd(maxroomh-h))
   x=x+offsetx+1
   y=y+offsety+1
   -- debug
   --printh("w:"..w.." h:"..h.." x:"..x.." y:"..y.." lx:"..lastx.." ly:"..lasty)

   add(rooms,{w=w,h=h,x=x,y=y,lastx=lastx,lasty=lasty,index=roomindex})  
   
   -- horizontal path back to last room
   if c > 1 then
				add(paths,create_path(lastx+flr(lastw/2),lasty+flr(lasth/2),x+flr(w/2),y+flr(h/2)))
	  end
	  
	  -- random room index for vertical path
	  if c == cols and r > 1 then
	   local rndroomi=flr(rnd(cols))+1
    local dri=rndroomi+(r-2)*rows	   
	   add(paths,create_path(lastx+flr(lastw/2),lasty+flr(lasth/2),rooms[dri].x+flr(rooms[dri].w/2),rooms[dri].y+flr(rooms[dri].h/2)))
	  end
 
   roomindex+=1
	  lastx = x
   lasty = y
   lastw = w
   lasth = h   
	 end
 end 
 
 -- create map (2d array)
 -- rooms
 for r in all(rooms) do
  for y=r.y,r.y+r.h-1 do
   for x=r.x,r.x+r.w-1 do
    roommap[y][x] = 2
   end
  end
 end
 
 --paths
 for p in all(paths) do
  for pp in all(p) do
	  roommap[pp.y][pp.x] = 1	  
	 end
 end
 
 -- set player to random position
 local hit=false
 while not hit do
  local rx=flr(rnd(maxmapw))+1
  local ry=flr(rnd(maxmapw))+1

  if roommap[ry][rx] != 0 then
   player.x=rx
   player.y=ry
   hit=true
  end
 end
end


function _update60()
 -- restart
 if btnp(❎) then
  _init()
 end
 
 -- move player
 if btnp(➡️) then
  if roommap[player.y][player.x+1] != 0 then
	 	player.x+=1
 	end
 end
 
 if btnp(⬅️) then
  if roommap[player.y][player.x-1] != 0 then
	 	player.x-=1
	 end
 end
 
 if btnp(⬆️) then
	 if roommap[player.y-1][player.x] != 0 then
		 player.y-=1
		end
 end
 
 if btnp(⬇️) then
	 if roommap[player.y+1][player.x] != 0 then
	 	player.y+=1
	 end
 end
 
end

function _draw()
 cls()
 
-- map(0,0)
 camera(camx,camy)
 
 -- render map
 for y=1,#roommap[1] do
  for x=1,#roommap[y] do
   if roommap[y][x] == 0 then
    --mset(x-1,y-1,1)
    rectfill(x*tilesize,y*tilesize,x*tilesize+tilesize-1,y*tilesize+tilesize-1,5)
   end
  end
 end
 
 -- render player
 rectfill(player.x*tilesize,player.y*tilesize,player.x*tilesize+tilesize-1,player.y*tilesize+tilesize-1,8)

-- for r in all(rooms) do
--  rect(r.x*tilesize,r.y*tilesize,(r.x+r.w)*tilesize,(r.y+r.h)*tilesize,8)
--  --print(r.index,r.x*8,r.y*8,8)
-- end
-- 
-- for p in all(paths) do
--  --print(p.index,p[1].x*8,p[1].y*8,9)
--  for pp in all(p) do
--	  rect(pp.x*tilesize,pp.y*tilesize,pp.x*tilesize+tilesize-1,pp.y*tilesize+tilesize-1,9)
--	 end
-- end

end

__gfx__
00000000ddddddd10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d55555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d55555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d55555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d55555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d55555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d55555510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
