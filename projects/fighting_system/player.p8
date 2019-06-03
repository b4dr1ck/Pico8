
function weapon(name,min_dmg,max_dmg,effect,bon)
   w={name = name, dmg = {min_dmg,max_dmg},effect=effect,bon=bon}
   return w
end

function armor(name,def,effect,bon)
    a={name = name, def = def,effect=effect,bon=bon}
    return a
end

function item(name,type,effect,desc)
  i = {name = name, type = type, effect = effect,desc = desc}
  return i
end

function condition(name,effect,duration,dmg)
  c = {name = name,effect = effect, duration = duration, dmg = dmg}
  return c
end

function player_defense_total()
  local def_total = 0
  for k,v in pairs(player.equipment) do
    if type(v) == "table" and v.def then
      def_total+=v.def
    end
  end
  return def_total
end

function add_substr_bon_equipment()
    for k,v in pairs(player.equipment) do
      if (v.bon) then
        for k2,v2 in pairs(v.bon) do
          if type(v2) == "table" then
            for k3,v3 in pairs(v2) do
              player.resist[k3][2] = v3
            end
          else
            player.attr[k2][2] = v2
          end
        end
      end
    end
end

player = {
  hp = {100,100},
  mp = {20,20},
  attr= {atk={1,0},def={1,0},mag={1,0},luc={1,0}},
  resist = { fire={0,0}, water={0,0}, wind={0,0}, earth={0,0}, physic={0,0}},
  conditions = {},
  inventory = {},
  equipment = {weapon="", shield="",head="",chest="",feet="",hands=""},
  spells = {}
}

add(player.inventory,item("healing potion","consumable",(function() player.hp[1] += 10 add(logbuffer,{"you consume healing potion",9}) end), "+10hp"))
add(player.inventory,item("hot kebap","consumable",(function() player.hp[1] += 25 add(logbuffer,{"you hot kebap potion",9}) end), "+25hp"))
add(player.inventory,item("mana potion","consumable",(function() player.hp[1] += 5 add(logbuffer,{"mana potion",9}) end), "+5mp"))
player.equipment.weapon = weapon("broad sword",2,6,(function() return end),{atk=2})
player.equipment.shield = armor("wooden shield",1)
player.equipment.head = armor("yankees cap",0,(function() return end),{luc=3,resist={fire=5,water=1}})
player.equipment.chest = armor("KOrN t-shirt",1)
player.equipment.feet = armor("jesus sandals",0)
player.equipment.hands = armor("wooly gloves",0)
add(player.conditions,condition("poisoned",(function() player.hp[1] -= 2 add(logbuffer, {"you take 2 hp dmg",11}) end),5,2))
