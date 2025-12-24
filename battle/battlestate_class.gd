## This node controls the entire battle.
class_name BattleState extends Node

# NOTE: im so sorry if this is a mess ;w; - Chris

## Use this to give the battle a new encounter. (unimplimented currently.)
static var packed_encountered:PackedScene
## Resource Path of the last scene you were in. (unimplimented currently.)
static var return_scene:String

## The current state of the batle.
@export var state:State = State.PLAYERCHOICE
## The encounter node used for determining how the battle should play out.
@export var encounter:BattleEncounter
## Gold you are given at the end of a battle.
@export var gold_pool:int

## Displayed when the player is choosing an action.
@export_multiline var player_choice_dialogue:String = "Test Test Test"
## Dialogue to be read out in the battle box. Proceeds to enemy dialogue once dialogue has ran out.
var queued_dialogue:PackedStringArray

## The current button action you're using. Handled here so it remembers the last button you pressed.
var action_index:int = 0

## Timer used to determine when a wave ends.
@onready var WaveTimer:Timer		= %WaveEndTimer
## The soul controlled by the player.
@onready var Soul:CharacterBody2D	= %Soul
## The battle box node that can be resized.
@onready var BattleBox:Panel		= %Box
## The text inside the battle box.
@onready var Dialogue:RichTextLabel	= %Dialogue
## FIGHT, ACT, ITEM, MERCY
@onready var Actions:Control	= %Actions
## Sub-menus for actions listed above.
@onready var Menu:TabContainer	= %Menu

## Each state the battle can be in.
enum State{
	NONE = -1,
	PLAYERCHOICE,
	ATTACKING,
	DIALOGUE,
	ENEMYDIALOGUE,
	BULLETHELL,
	END,
	FLEE
}

const BACKUP_WIN_DIALOGUE:String = "YOU WON!\nYou earned 0 EXP and 0 GOLD."

const BOXSIZE_DIALOGUE:Rect2 = Rect2(192.0,344.0,765.0,176.0)
const BOXSIZE_BATTLE:Rect2 = Rect2(488.0,344.0,176.0,176.0)

signal state_changed(_state:State)
signal battle_start(battle_state:BattleState)
signal wave_started(battle_state)
signal wave_ended(battle_state:BattleState)

signal battle_box_finished_transform()

func _ready()->void:
	await get_parent().ready
	Menu.visible = false
	encounter.battle_start(self)
	set_state(State.PLAYERCHOICE)
	battle_start.emit(self)

func _process(_delta:float)->void:
	match(state):
		State.END:
			pass
		State.DIALOGUE:
			if(Input.is_action_just_pressed("interact_confirm")): advance_dialogue()
		State.ENEMYDIALOGUE:
			if(Input.is_action_just_pressed("interact_confirm")): advance_monster_dialogue()
		State.PLAYERCHOICE:
			var dir_pressed:Vector2i = Vector2i(
				int(Input.is_action_just_pressed("right"))-int(Input.is_action_just_pressed("left")),
				int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up")))
			# Handle action selection.
			if(not Menu.visible):
				# There is never more than 4 actions. therefore im hardcoding this unless we add magic maybe idk.
				action_index = wrapi(action_index + dir_pressed.x,0,4)
				if(dir_pressed.x != 0):
					pass # Play Sound
				if(Input.is_action_just_pressed("interact_confirm")):
					Input.action_release("interact_confirm")
					Menu.set_current_tab(action_index)
					Menu.visible = true
					Dialogue.text = ""
			else:
				# Go back to action menu if back is pressed.
				if(Input.is_action_just_pressed("back_cancel")):
					Menu.visible = false
					# Reset Dialogue
					Dialogue.text = player_choice_dialogue
			# Set frame for each button.
			for i in Actions.get_children():
				i.frame = int(action_index == i.get_index())
		_:
			# Set buttons to off frame.
			for i in Actions.get_children():
				i.frame = 0

## Queues dialogue to add to the battle box.
func queue_dialogue(dialog:PackedStringArray)->void:
	queued_dialogue.append_array(dialog)

## Advances the battle box dialogue.
## If there is no dialogue left, sets the state to ENEMYDIALOGUE
func advance_dialogue()->void:
	if(queued_dialogue.size() == 0):
		Dialogue.text = ""
		set_state(State.ENEMYDIALOGUE)
		return
	var next = queued_dialogue[0]
	queued_dialogue.remove_at(0)
	Dialogue.text = next

## Advances monster dialogue if applicable.
## If monsters no longer have dialogue, then skip to bullet hell.
func advance_monster_dialogue()->void:
	var more_dialogue:bool = false
	if(not more_dialogue):
		set_state(State.BULLETHELL)

## Sets the state and calls specific code to set up states.
func set_state(new:State)->void:
	Menu.visible = false
	Soul.visible = false
	if(state == State.BULLETHELL and new != State.BULLETHELL): 
		encounter.end_wave()
		wave_ended.emit(self)
	# New state has been set.
	state = new
	# Setup actions depending on state.
	match(state):
		State.PLAYERCHOICE:
			Dialogue.text = player_choice_dialogue
		State.DIALOGUE:
			advance_dialogue()
		State.ENEMYDIALOGUE:
			Soul.visible = true
			encounter.set_up_bulletsection()
			advance_monster_dialogue()
		State.BULLETHELL:
			Soul.visible = true
			encounter.start_wave()
			wave_started.emit(self)
			WaveTimer.start()
	
	state_changed.emit(state)

## Changes the battle box size to the dialogue size.
func transition_box_to_dialogue()->void:
	transition_box_size(BOXSIZE_DIALOGUE)

## Changes the battle box size to the default battle size.
func transition_box_to_battle()->void:
	transition_box_size(BOXSIZE_BATTLE)

## Changes the battle box size via tweens to slide it to the new size.
func transition_box_size(rect:Rect2)->void:
	var tween1 = create_tween()
	var tween2 = create_tween()
	
	tween1.tween_property(BattleBox,"position",rect.position,0.5)
	tween2.tween_property(BattleBox,"size",rect.size,0.5)
	
	tween1.finished.connect(battle_box_finished_transform.emit)

## Ends the wave and changes the state to player choice.
func end_wave()->void:
	transition_box_to_dialogue()
	set_state(State.PLAYERCHOICE)

## Set the target monster.
func set_target_monster_index(index:int)->void:
	encounter.set_target_monster_index(index)

## An action was used.
func use_act_action(act:String)->void:
	encounter.get_child(encounter.target_monster).action_used(self,act)

## Sets the dialogue to be shown on player choice.
func set_dialogue(text:String)->void:
	player_choice_dialogue = text

## Called when the player uses mercy. Action is 0 when spare is used.
func use_mercy(action:int)->void:
	if(action == 0):
		encounter.attempt_spare()
	else:
		attempt_flee()

## The player's HP has reached 0
func player_died()->void:
	# Pause for half a second before transitioning to gameover
	# why? I think being able to see what hit you is cool.
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	# queue switching to gameover

## All monsters have been spared, killed, or the encounter doesn't exist.
func check_battle_won()->bool:
	if(not is_instance_valid(encounter)): return true
	if(not encounter.monsters_cleared()): return false
	return true

## The player has attempted to flee. Change the battle state depending on outcome. (unimplimented currently.)
func attempt_flee()->void:
	set_state(State.FLEE)
