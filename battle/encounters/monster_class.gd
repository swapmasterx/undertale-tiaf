class_name BattleMonster extends Node2D

## If true, the monster has been killed or spared, and can no longer be interacted with.
## If "can_spare" is set to true, then this monster has been spared.
@export var spared_or_dead:bool = false
## If true, the monster is able to be spared.
@export var can_spare:bool = false
## Health.
@export var health:int = 100
## Maximum health, used for health bar.
@export var health_max:int = 100
## Attack, used in player damage calculation.
@export var attack:int = 1
## Defense, used in damage calculation
@export var defense:int = 1
## Gold to give on death
@export var gold:int = 10

@export var act_options:PackedStringArray = ["CHECK"]

@export_multiline var check_dialogue:String = "Edit this so you can have better check text!"


## Dialogue used when the enemy is talking.
var queued_dialogue:PackedStringArray

## Emitted when the enemy is damaged.
signal damaged(num:int)
## Emitted when the enemy is killed.
signal killed()
## Emitted when the enemy is spared.
signal spared()

## Returns the dialogue that will display when you use CHECK on this enemy.
func get_check_dialogue()->PackedStringArray:
	return ["%s - ATK %d DEF %d\n%s" % [name,attack,defense,check_dialogue]]

## Gives the list of act options to the battle object.
func get_act_options()->PackedStringArray:
	return act_options

## Notifies the monster that spare has been used on them.
func spare_used()->void:
	if(can_spare):
		spared_or_dead = true
		spared.emit()

## Tells the monster an action was used, the monster then can set the battle state.
## If the battle state is not set, the action will do nothing.
func action_used(battlestate:BattleState,option:String)->void:
	match(option):
		"CHECK":
			battlestate.set_state(BattleState.State.DIALOGUE)

## The player has attempted to attack the monster.
func fight_used()->void:
	pass

## Allows the monster to take damage.
func take_damage(damage:int)->void:
	damaged.emit(damage)
	health -= damage
	if(health <= 0):
		health = 0
		spared_or_dead = true
		can_spare = false
		killed.emit()
