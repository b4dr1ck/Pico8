
-- hud menu variables
cmdact=1
itemact=1
cmdlist={"atk","eva","spl","inv","eqi","sta","esc"}
cmddesc={"attack the enemy", "evade en enemy","show spellbook",
         "show inventory","show equipment","show player stats" ,"escape the fight"}
logbuffer={}
hud_mode=""

-- draws the command list (the active command ist WHITE)
function draw_hud_commands()
  for i=1,#cmdlist do
    cmdcolor = 5
    if cmdact == i then cmdcolor = 7 end
    print(cmdlist[i],(i-1)*18 + 3,120,cmdcolor)
  end
  print(cmddesc[cmdact],3,112,7)
end

-- draws the hud menu for the player stats
function draw_hud_stats()
  print("hp: ("..player.hp[1].."/"..player.hp[2]..")" ..
         "\nmp: ("..player.mp[1].."/"..player.mp[2]..")",3,3,7)
  line(0,16,127,16,6)
  print("atk: "..player.attr.atk.. "\ndef: "..player.attr.def..
        "\nmag: "..player.attr.mag.. "\nluc: "..player.attr.luc,3,19,7)
  line(0,44,127,44,6)
  print("fir: "..player.resist.fire.. "\nwat: "..player.resist.water..
        "\nwin: "..player.resist.wind.. "\near: "..player.resist.earth,3,47,7)
  line(0,74,127,74,6)
  if #player.conditions == 0 then print("no conditions",3,77,7) end
  for i=1,#player.conditions do
    print(player.conditions[i],3,((i-1)*6)+77,7)
  end
end

-- draws the hud menu for the players equipment
function draw_hud_equipment()
  print("weapon: "..player.equipment.weapon .. "(?)"..
        "\nshield: "..player.equipment.shield .. "(?)",3,3,7)
  line(0,16,127,16,6)
  print("head:  "..player.equipment.head .. "(?)"..
        "\nchest: "..player.equipment.chest .. "(?)"..
        "\nhands: "..player.equipment.hands .. "(?)"..
        "\nfeet:  "..player.equipment.feet .. "(?)",3,19,7)
  line(0,44,127,44,6)
end

-- draws the hud menu for the player inventory or spells
function draw_hud_items(itemlist)
  local line_pos_y = 0
  local items_max = 17
  local page = ceil(itemact/items_max)
  local items_start = items_max * (page - 1) + 1

  for i=items_start, items_max * page do
    local color = 5
    if i == itemact then color = 7 end
    if itemlist[i] then
      print(itemlist[i],3,(line_pos_y * 6) + 3,color)
      line_pos_y+=1
    end
  end

end
-- toogle through the items of the inventory or the spell hud
function toggle_item_list()
  local itemlist
  if hud_mode == "inv" then
    itemlist = player.inventory
  elseif hud_mode == "spl" then
    itemlist = player.spells
  else
    return
  end

  if btnp(3) then
    itemact+=1
  end
  if btnp(2) then
    itemact-=1
  end
  if itemact > #itemlist then itemact = 1 end
  if itemact < 1 then itemact = #itemlist end
end

-- toggles between the command list by pressing the left
-- and right keys
function toggle_hud_cmd()
  if btnp(0) then
    cmdact-=1
    hud_mode=""
    itemact=1
  end
  if btnp(1) then
    cmdact+=1
    hud_mode=""
    itemact=1
  end
  if cmdact > #cmdlist then cmdact = 1 end
  if cmdact < 1 then cmdact = #cmdlist end
  hud_mode = cmdlist[cmdact] 
  --if btnp(4) then hud_mode = cmdlist[cmdact] end
end

-- state machine for the hud menus
function handle_hud_menu()
  if hud_mode == "sta" then draw_hud_stats() end
  if hud_mode == "eqi" then draw_hud_equipment() end
  if hud_mode == "inv" then draw_hud_items(player.inventory) end
  if hud_mode == "spl" then draw_hud_items(player.spells) end
end

-- draws the basic hud menu interface (background hud)
function draw_hud_basic()
  rect(0,0,127,127,6)
  rect(1,1,126,126,13)
  line(0,118,127,118,6)
  line(0,110,127,110,6)
end
