class_name BattleEncounter extends Node2D

@export var battle_intro_text:String = "Test enemy blocks the way!"
@export var battle_text:PackedStringArray = ["Something's happening!"]
## Win text, if this is empty, then the battle will simply fade out.
## {0} is the gold earned. EXP can not be earned by a monster, que undertale lore dump.
@export var win_text:String = "YOU WON!\nYou earned 0 EXP and {0} gold."
## Monster that will be targetted during an attack or action.
var target_monster:int = 0

func battle_start(battlestate:BattleState)->void:
	pass

func set_target_monster_index(value)->void:
	target_monster = value

func monster_fight_used(index:int)->void:
	var monster:BattleMonster = get_child(index)
	if(not (monster is BattleMonster)): return
	if(monster.spared_or_dead): return
	monster.fight_used()

func monster_damage(index:int,damage:int)->void:
	var monster:BattleMonster = get_child(index)
	if(not (monster is BattleMonster)): return
	if(monster.spared_or_dead): return
	monster.take_damage(damage)

func attempt_spare()->void:
	for m:BattleMonster in get_children():
		if(not (m is BattleMonster)): continue
		m.spare_used()

## Returns true if all monsters have died or have been spared.
func monsters_cleared()->bool:
	for monster:BattleMonster in get_children():
		if(not (monster is BattleMonster)): continue
		if(not monster.spared_or_dead): return false
	return true
