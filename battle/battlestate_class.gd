## This node controls the entire battle.
class_name BattleState extends Node

## Use this to give the battle a new encounter.
static var packed_encountered:PackedScene

@export var state:State = State.PLAYERCHOICE
@export var encounter:BattleEncounter
@export var gold_pool:int

@export_multiline var player_choice_dialogue:String = "Test Test Test"
var queued_dialogue:PackedStringArray

var action_index:int = 0

@onready var BattleBox:Panel		= %Box
@onready var Dialogue:RichTextLabel	= %Dialogue

@onready var Actions:Control	= %Actions
@onready var Menu:TabContainer	= %Menu

## Each state the battle can be in.
enum State{
	NONE = -1,
	PLAYERCHOICE,
	ATTACKING,
	DIALOGUE,
	ENEMYDIALOGUE,
	BULLETHELL,
	END
}

const BACKUP_WIN_DIALOGUE:String = "YOU WON!\nYou earned 0 EXP and 0 GOLD."

const BOXSIZE_DIALOGUE:Rect2 = Rect2(192.0,344.0,765.0,176.0)
const BOXSIZE_BATTLE:Rect2 = Rect2(488.0,344.0,176.0,176.0)

signal battle_start(battle_state:BattleState)
signal wave_ended(battlestate:BattleState)

func _ready()->void:
	await get_parent().ready
	Menu.visible = false
	encounter.battle_start(self)
	battle_start.emit(self)

func _process(_delta:float)->void:
	match(state):
		State.PLAYERCHOICE:
			var dir_pressed:Vector2i = Vector2i(
				int(Input.is_action_just_pressed("right"))-int(Input.is_action_just_pressed("left")),
				int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up")))
			if(not Menu.visible):
				# There is never more than 4 actions. therefore im hardcoding this unless we add magic maybe idk.
				action_index = wrapi(action_index + dir_pressed.x,0,4)
				if(dir_pressed.x != 0):
					pass # Play Sound
				if(Input.is_action_just_pressed("interact_confirm")):
					Menu.set_current_tab(action_index)
					Menu.visible = true
					Dialogue.text = ""
			else:
				if(Input.is_action_just_pressed("back_cancel")):
					Menu.visible = false
					# Reset Dialogue
					Dialogue.text = player_choice_dialogue
			for i in Actions.get_children():
				i.frame = int(action_index == i.get_index())
		_:
			for i in Actions.get_children():
				i.frame = 0

func queue_dialogue(dialog:PackedStringArray)->void:
	queued_dialogue.append_array(dialog)

## Advances the battle box dialogue.
## If there is no dialogue left, sets the state to ENEMYDIALOGUE
func advance_dialogue()->void:
	if(queued_dialogue.size() == 0):
		set_state(State.ENEMYDIALOGUE)
		return
	var next = queued_dialogue[0]
	queued_dialogue.remove_at(0)

func advance_enemy_dialogue()->void:
	var more_dialogue:bool = false

func set_state(new:State)->void:
	wave_ended.emit(self)
	if(state == State.BULLETHELL):
		set_state(State.PLAYERCHOICE)

func transition_box_to_dialogue()->void:
	transition_box_size(BOXSIZE_DIALOGUE)

func transition_box_to_battle()->void:
	transition_box_size(BOXSIZE_BATTLE)

func transition_box_size(rect:Rect2)->void:
	var tween1 = create_tween()
	var tween2 = create_tween()
	
	tween1.tween_property(BattleBox,"position",rect.position,0.5)
	tween2.tween_property(BattleBox,"size",rect.size,0.5)

func end_wave()->void:
	state = State.PLAYERCHOICE

func set_dialogue(text:String)->void:
	pass

## The player's HP has reached 0
func player_died()->void:
	pass
## All monsters have been spared, killed, or the encounter doesn't exist.
func check_battle_won()->bool:
	if(not is_instance_valid(encounter)): return true
	if(not encounter.monsters_cleared()): return false
	return true
