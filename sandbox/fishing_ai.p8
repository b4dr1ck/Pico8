pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
 -- spieler-daten
 p = {
  x = 64,
  y = 64,
  dir_x = 0,
  dir_y = 1,
  charging = false,
  charge = 0,       -- 0.0 bis 1.0
  charge_speed = 0.025
 }

 -- wurf-einstellungen
 cast_cfg = {
  min_dist = 15,
  max_dist = 65,
  min_height = 10,
  max_height = 30
 }

 -- koeder / schwimmer
 bobber = {
  active = false,
  start_x = 0, start_y = 0,
  end_x = 0,   end_y = 0,
  x = 0, y = 0, z = 0,
  t = 0,
  speed = 0.03,
  current_height = 20
 }
end

function _update()
 local dx, dy = 0, 0
 if btn(0) then dx -= 1 end
 if btn(1) then dx += 1 end
 if btn(2) then dy -= 1 end
 if btn(3) then dy += 1 end

 if dx != 0 and dy != 0 then
  dx *= 0.707
  dy *= 0.707
 end

 -- spieler bewegen (nur wenn weder geladen noch geworfen wird)
 if not bobber.active and not p.charging then
  p.x += dx * 1.5
  p.y += dy * 1.5
  
  if dx != 0 or dy != 0 then
   p.dir_x = dx
   p.dir_y = dy
  end
 elseif p.charging and (dx != 0 or dy != 0) then
  -- waehrend dem aufladen darf man sich noch drehen, aber nicht laufen
  p.dir_x = dx
  p.dir_y = dy
 end

 -- 1. aufladen starten (nur wenn nicht schon geladen wird!)
 if btnp(4) and not bobber.active and not p.charging then
  p.charging = true
  p.charge = 0
 end
 
 -- 2. waehrend des haltens aufladen
 if p.charging then
  if btn(4) then
   -- wert erhoehen, maximal 1.0
   p.charge = min(1, p.charge + p.charge_speed)
  else
   -- taste wurde losgelassen -> wurf ausloesen!
   p.charging = false
   
   -- distanz und hoehe anhand der ladung berechnen
   local dist = cast_cfg.min_dist + (cast_cfg.max_dist - cast_cfg.min_dist) * p.charge
   local height = cast_cfg.min_height + (cast_cfg.max_height - cast_cfg.min_height) * p.charge
   
   cast_rod(dist, height)
  end
 end

 -- 3. wurf-animation aktualisieren
 if bobber.active then
  bobber.t += bobber.speed
  if bobber.t >= 1 then
   bobber.t = 1
  end

  bobber.x = bobber.start_x + (bobber.end_x - bobber.start_x) * bobber.t
  bobber.y = bobber.start_y + (bobber.end_y - bobber.start_y) * bobber.t
  bobber.z = sin(bobber.t * 0.5) * bobber.current_height
 end
 
 -- einholen mit taste x/v
 if btnp(5) and bobber.active then
  bobber.active = false
 end
end

function cast_rod(distance, height)
 bobber.active = true
 bobber.t = 0
 bobber.current_height = height
 bobber.start_x = p.x
 bobber.start_y = p.y
 bobber.end_x = p.x + p.dir_x * distance
 bobber.end_y = p.y + p.dir_y * distance
end

function _draw()
 cls(3)

 -- spieler zeichnen
 circfill(p.x, p.y, 4, 12)
 line(p.x, p.y, p.x + p.dir_x * 6, p.y + p.dir_y * 6, 7)

 -- ladebalken ueber dem spieler anzeigen
 if p.charging then
  local bar_w = 12
  local bx = p.x - bar_w / 2
  local by = p.y - 10
  
  -- hintergrund des balkens
  rectfill(bx, by, bx + bar_w, by + 2, 1)
  -- fuellung (wechselt auf gelb/rot bei voller ladung)
  local col = p.charge >= 0.95 and 9 or 11
  rectfill(bx, by, bx + bar_w * p.charge, by + 2, col)
 end

 if bobber.active then
  -- minus vor sin(), weil pico-8 sin(0.25) = -1 liefert!
  local h_factor = -sin(bobber.t * 0.5)

  -- radien dynamisch berechnen
  local shadow_r = max(0.5, 2.5 - h_factor * 2) -- schrumpft von 2.5 auf 0.5
  local bobber_r = 2 + h_factor * 2             -- waechst von 2 auf 4

  -- 1. schatten am boden (wird kleiner in der hoehe)
  circfill(bobber.x, bobber.y, shadow_r, 1)

  -- 2. angelschnur
  line(p.x, p.y - 2, bobber.x, bobber.y - bobber.z, 7)

  -- 3. koeder in der luft (wird groesser in der hoehe)
  circfill(bobber.x, bobber.y - bobber.z, bobber_r, 8)
  
  -- glanzpunkt
  pset(bobber.x - bobber_r * 0.3, bobber.y - bobber.z - bobber_r * 0.3, 7)
 end


end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
