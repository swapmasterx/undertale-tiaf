class_name BattleEncounter extends Node2D

## The mesage that gets pushed during for the beginning battle text.
@export var battle_intro_text:String = "Test enemy blocks the way!"
@export var battle_text:PackedStringArray = ["Something's happening!"]
## Win text, if this is empty, then the battle will simply fade out.
## {0} is the gold earned. EXP can not be earned by a monster, que undertale lore dump.
@export var win_text:String = "YOU WON!\nYou earned 0 EXP and {0} gold."
## Weather or not the flee button should appear.
@export var can_flee:bool = true
## Monster that will be targetted during an attack or action.
var target_monster:int = 0
## The battle state node.
var battlestate:BattleState

## Called by battle state when the battle state has been initialized.
func battle_start(_battlestate:BattleState)->void:
	battlestate = _battlestate
	battlestate.set_dialogue(battle_intro_text)

## Sets the targetted monster.
func set_target_monster_index(value)->void:
	target_monster = value

## Set enemy dialogue here, along with battle box size.
func set_up_bulletsection()->void:
	battlestate.Soul.position = Vector2(576.0,424.0)
	battlestate.Soul.reset_physics_interpolation()
	battlestate.transition_box_to_battle()

## Set up timers, add the bullet spawners, ect.
func start_wave()->void:
	pass
## Called when a wave ends, used to set up the next player choice dialogue.
func end_wave()->void:
	battlestate.set_dialogue(battle_text[randi_range(0,battle_text.size()-1)])

## Fight was used on an enemy (pressed on a position on the battle pussy, but no damage has been delt yet)
func monster_fight_used(index:int)->void:
	var monster:BattleMonster = get_child(index)
	if(not (monster is BattleMonster)): return
	if(monster.spared_or_dead): return
	monster.fight_used()

## Monster has taken damage.
func monster_damage(index:int,damage:int)->void:
	var monster:BattleMonster = get_child(index)
	if(not (monster is BattleMonster)): return
	if(monster.spared_or_dead): return
	monster.take_damage(damage)

## If the monster can be spared, then attempt to spare them.
func attempt_spare()->void:
	for m:BattleMonster in get_children():
		if(not (m is BattleMonster)): continue
		m.spare_used()
	battlestate.set_state(BattleState.State.END if(battlestate.check_battle_won())else BattleState.State.ENEMYDIALOGUE)

## Starts the monsters dialogue state, if no dialogue is present then returns false.
func monsters_dialogue_start()->bool:
	return false

## Returns true if one or more monsters can be spared.
func monsters_can_be_spared()->bool:
	for m:BattleMonster in get_children():
		if(m.can_spare): return true
	return false

## Returns true if all monsters have died or have been spared.
func monsters_cleared()->bool:
	for monster:BattleMonster in get_children():
		if(not (monster is BattleMonster)): continue
		if(not monster.spared_or_dead): return false
	return true
