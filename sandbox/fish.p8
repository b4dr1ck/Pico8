pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
 -- spieler (punkt a)
 p = {
  x = 64,
  y = 64,
  dir_x = 0,
  dir_y = 1,
  charging = false,
  charge = 0,
  charge_speed = 0.025
 }

 -- wurf-einstellungen
 cast_cfg = {
  min_dist = 12,
  max_dist = 65
 }

 -- schwimmer / bobber
 bobber = {
  active = false,
  start_x = 0, start_y = 0,
  end_x = 0,   end_y = 0,
  x = 0, y = 0, z = 0,
  t = 0,
  speed = 0.025,
  current_height = 20
 }
end

function _update()
 -- 1. 8-wege-bewegung & richtung erfassen
 local dx, dy = 0, 0
 if btn(0) then dx -= 1 end
 if btn(1) then dx += 1 end
 if btn(2) then dy -= 1 end
 if btn(3) then dy += 1 end

 -- diagonale geschwindigkeit normalisieren
 if dx != 0 and dy != 0 then
  dx *= 0.707
  dy *= 0.707
 end

 if not bobber.active and not p.charging then
  p.x += dx * 1.5
  p.y += dy * 1.5
  
  if dx != 0 or dy != 0 then
   p.dir_x = dx
   p.dir_y = dy
  end
 elseif p.charging and (dx != 0 or dy != 0) then
  -- waehrend des aufladens kann man sich noch drehen
  p.dir_x = dx
  p.dir_y = dy
 end

 -- 2. aufladen starten (mit schutz gegen auto-repeat)
 if btnp(4) and not bobber.active and not p.charging then
  p.charging = true
  p.charge = 0
 end

 -- 3. ladebalken fuellen & bei loslassen abwerfen
 if p.charging then
  if btn(4) then
   p.charge = min(1, p.charge + p.charge_speed)
  else
   p.charging = false
   
   -- zielpunkt b anhand der ladung und blickrichtung berechnen
   local dist = cast_cfg.min_dist + (cast_cfg.max_dist - cast_cfg.min_dist) * p.charge
   local target_x = p.x + p.dir_x * dist
   local target_y = p.y + p.dir_y * dist
   
   cast_a_to_b(p.x, p.y, target_x, target_y)
  end
 end

 -- 4. wurf-animation von a nach b aktualisieren
 if bobber.active then
  bobber.t += bobber.speed
  if bobber.t >= 1 then
   bobber.t = 1
  end

  -- bodenposition (lerp)
  bobber.x = bobber.start_x + (bobber.end_x - bobber.start_x) * bobber.t
  bobber.y = bobber.start_y + (bobber.end_y - bobber.start_y) * bobber.t

  -- flughoehe (-sin wegen pico-8)
  bobber.z = -sin(bobber.t * 0.5) * bobber.current_height
 end

 -- 5. einholen mit taste x/v
 if btnp(5) and bobber.active then
  bobber.active = false
 end
end

function cast_a_to_b(ax, ay, bx, by)
 bobber.active = true
 bobber.t = 0
 bobber.start_x = ax
 bobber.start_y = ay
 bobber.end_x = bx
 bobber.end_y = by

 -- distanz zwischen a und b ermitteln
 local dx = bx - ax
 local dy = by - ay
 local dist = sqrt(dx * dx + dy * dy)
 
 -- flughoehe passt sich automatisch an die wurfweite an
 bobber.current_height = mid(8, dist * 0.45, 35)
end

function _draw()
 cls(3)

 -- spieler (punkt a)
 circfill(p.x, p.y, 4, 12)
 line(p.x, p.y, p.x + p.dir_x * 6, p.y + p.dir_y * 6, 7)

 -- ladebalken ueber dem spieler
 if p.charging then
  local bar_w = 14
  local bx = p.x - bar_w / 2
  local by = p.y - 11
  
  -- dunkler rahmen/hintergrund
  rectfill(bx - 1, by - 1, bx + bar_w + 1, by + 3, 0)
  rectfill(bx, by, bx + bar_w, by + 2, 1)
  
  -- fuellstand (gruen -> gelb -> rot bei maximaler kraft)
  local col = 11
  if p.charge > 0.85 then
   col = 8
  elseif p.charge > 0.5 then
   col = 10
  end
  
  rectfill(bx, by, bx + bar_w * p.charge, by + 2, col)
 end

 -- fliegenden / gelandeten schwimmer zeichnen
 if bobber.active then
  local h_factor = -sin(bobber.t * 0.5)

  -- tiefeneffekt: schatten schrumpft, bobber waechst
  local shadow_r = max(0.5, 2.5 - h_factor * 2)
  local bobber_r = 2 + h_factor * 2

  -- 1. schatten auf der geraden bodenlinie
  circfill(bobber.x, bobber.y, shadow_r, 1)

  -- 2. angelschnur
  line(p.x, p.y - 2, bobber.x, bobber.y - bobber.z, 7)

  -- 3. bobber in der luft
  circfill(bobber.x, bobber.y - bobber.z, bobber_r, 8)
  pset(bobber.x - bobber_r * 0.3, bobber.y - bobber.z - bobber_r * 0.3, 7)
 end

 print("pfeile: bewegen | z: laden/wurf", 4, 4, 7)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
