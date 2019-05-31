
enemy = {
  name = "evil dude",
  hp = {60,60},
  mp = {20,20},
  attr= {atk=1,def=1,mag=1,luc=1},
  resist = { fire=0, water=0, wind=0, earth=0, physic=0},
  conditions = {},
  inventory = {},
  equipment = {weapon="", shield=""},
  spells = {},
  drops = {}
}

enemy.equipment.weapon = weapon("rusty knife",1,8)
enemy.equipment.shield = armor("wooden shield",1)
