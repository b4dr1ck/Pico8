
function weapon(name,min_dmg,max_dmg)
   w={name = name, dmg = {min_dmg,max_dmg}}
   return w
end

function armor(name,def)
    a={name = name, def = def}
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

player = {
  hp = {100,100},
  mp = {20,20},
  attr= {atk=1,def=1,mag=1,luc=1},
  resist = { fire=0, water=0, wind=0, earth=0, physic=0},
  conditions = {},
  inventory = {},
  equipment = {weapon="", shield="",head="",chest="",feet="",hands=""},
  spells = {}
}

add(player.inventory,item("healing potion","consumable",(function() player.hp[1] += 10 add(logbuffer,{"you consume healing potion",9}) end), "+10hp"))
add(player.inventory,item("hot kebap","consumable",(function() player.hp[1] += 25 add(logbuffer,{"you hot kebap potion",9}) end), "+25hp"))
add(player.inventory,item("mana potion","consumable",(function() player.hp[1] += 5 add(logbuffer,{"mana potion",9}) end), "+5mp"))
player.equipment.weapon = weapon("broad sword",2,6)
player.equipment.shield = armor("wooden shield",1)
player.equipment.head = armor("yankees cap",0)
player.equipment.chest = armor("KOrN t-shirt",1)
player.equipment.feet = armor("jesus sandals",0)
player.equipment.hands = armor("wooly gloves",0)
add(player.conditions,condition("poisoned",(function() player.hp[1] -= 2 add(logbuffer, {"you take 2 hp dmg",11}) end),5,2))
