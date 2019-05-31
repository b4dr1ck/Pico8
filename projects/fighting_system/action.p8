
function handle_player_mode()
  if player_mode == "attack" then cmd_attack() end
  if player_mode == "escape" then cmd_escape() end
  if player_mode == "use_item" then cmd_use_item() end
end

function cmd_attack()
  player_check_conditions()
  player_attack()
  enemy_attack()
  player_mode = ""
  check_values()
end

function cmd_use_item()
  player_check_conditions()
  player_use_item()
  enemy_attack()
  player_mode = ""
  check_values()
end

function cmd_escape()
  player_check_conditions()
  player_escape()
  enemy_attack()
  player_mode = ""
  check_values()
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

function player_check_conditions()
  for i=1,#player.conditions do
    add(logbuffer,{"you are " .. player.conditions[i].name,11})
    player.conditions[i].effect()
    player.conditions[i].duration -= 1
    if player.conditions[i].duration == 0 then del( player.conditions, player.conditions[i]) end
  end
end

function player_use_item()
  if player.inventory[itemact].type == "consumable" then
    player.inventory[itemact].effect()
    check_values()
    cmdact=1
    del(player.inventory, player.inventory[itemact])
  end
end

function player_attack()
  local dmg = flr(rnd(player.equipment.weapon.dmg[2] * player.equipment.weapon.dmg[1] - player.equipment.weapon.dmg[1] + 1)) + player.equipment.weapon.dmg[1]
  dmg += player.attr.atk - enemy.equipment.shield.def - enemy.attr.def
  if dmg <= 0 then dmg = 1 end

  enemy.hp[1] -= dmg
  add(logbuffer,{"you attack for " .. dmg .. "hp", 7})
end

function enemy_attack()
  local dmg = flr(rnd(enemy.equipment.weapon.dmg[2] * enemy.equipment.weapon.dmg[1] - enemy.equipment.weapon.dmg[1] + 1)) + enemy.equipment.weapon.dmg[1]
  dmg += enemy.attr.atk - player_defense_total() - player.attr.def
  if dmg <= 0 then dmg = 1 end

  player.hp[1] -= dmg
  add(logbuffer,{"enemy attacks for " .. dmg .. "hp", 8})
end

function player_escape()
  local chance_to_esc = 20
  add(logbuffer,{"you try to flee", 7})
  if flr(rnd(chance_to_esc-player.attr.luc + 1)) + player.attr.luc == chance_to_esc then
    add(logbuffer,{"it works!", 7})
  else
    add(logbuffer,{"it fails...", 7})
  end
  player_mode=""
end

function check_values()
  if player.hp[1] > player.hp[2] then player.hp[1] = player.hp[2] end
  if player.mp[1] > player.mp[2] then player.mp[1] = player.mp[2] end
  if player.hp[1] <= 0 then
    player_mode="dead"
    hud_mode="dead"
    add(logbuffer,{"you died",7})
  end
end
