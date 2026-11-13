pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- sprite animation
function animate(current_frame,frame_start,frame_end,speed,loop)
 if not loop then
  if current_frame == frame_end then
   return current_frame
  end
	end
        
	if game_timer % speed == 0 then
  current_frame += 1
  if current_frame > frame_end then 
  	current_frame = frame_start 
  end
 end
 
 return current_frame
end

-- bounding-box collision detection
function bb_collision(obj1, obj2) 
 if obj1.x < obj2.x + 7 and
  		obj1.x + 7> obj2.x  and
  		obj1.y < obj2.y + 7 and
  		obj1.y + 7 > obj2.y 
 then
  return true
 end
 
 return false
end

-- 4-side collision detection
collision= { 
	left=function(flag,x,y)
							if fget(mget(flr((x)/8),flr((y)/8))) == flag or
          fget(mget(flr((x)/8),flr((y+7)/8))) == flag
      	then
       	return true
							end
       return false
    	 end,
	right=function(flag,x,y) 
	       if fget(mget(flr((x+8)/8),flr((y)/8))) == flag or
	       	  fget(mget(flr((x+8)/8),flr((y+7)/8))) == flag
	      then
	       return true
	      end
	      return false
    		end,
 up=function(flag,x,y) 
				 if fget(mget(flr((x)/8),flr((y)/8))) == flag or
        fget(mget(flr((x+7)/8),flr((y)/8))) == flag
     then
      return true
     end
     return false
    end,
	down=function(flag,x,y) 
    	  if fget(mget(flr((x)/8),flr((y+8)/8))) == flag or
          fget(mget(flr((x+7)/8),flr((y+8)/8))) == flag
       then
        return true
							end
       return false
 	    end
}


__gfx__
00000000009999000099990000999900009999000099990000999900000000000000000000000000000000000000000000000000000000000000000000000000
00000000099aa990099aa990099aa990099aa990099aa990099aa990000000000000000000000000000000000000000000000000000000000000000000000000
00700700991991999999199999999919999999999199999999919999000000000000000000000000000000000000000000000000000000000000000000000000
00077000999999999999999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000
00077000999999999999999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000
00700700919999199919999999991999999999999991999999999199000000000000000000000000000000000000000000000000000000000000000000000000
00000000091111900991111009999110099999900119999001111990000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000099990000999900009999000099990000999900000000000000000000000000000000000000000000000000000000000000000000000000
