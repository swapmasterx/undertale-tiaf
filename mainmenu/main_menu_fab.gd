extends Node2D

@onready var instructions = $CanvasLayer/TabContainer/instructions
@onready var startgame = $CanvasLayer/TabContainer/instructions/VBoxContainer/startgame
@onready var settings = $CanvasLayer/TabContainer/instructions/VBoxContainer/settings
@onready var tab_container = $CanvasLayer/TabContainer
@onready var title_card = $CanvasLayer/TabContainer/titleCard
@onready var zor_enter = $CanvasLayer/TabContainer/titleCard/ZorEnter
@onready var quit = $CanvasLayer/TabContainer/nameCreation/MarginContainer/VBoxContainer/HBoxContainer/Quit
@onready var done = $CanvasLayer/TabContainer/nameCreation/MarginContainer/VBoxContainer/HBoxContainer/done_name
@onready var back_space = $CanvasLayer/TabContainer/nameCreation/MarginContainer/VBoxContainer/HBoxContainer/BackSpace
@onready var master = $CanvasLayer/TabContainer/Settings/MarginContainer/HBoxContainer/VBoxContainer/Master
@onready var name_entryfinal = $CanvasLayer/TabContainer/confirm_name/nameEntryfinal
@onready var animation_player = $AnimationPlayer
@onready var animation_player_2 = $AnimationPlayer2
@onready var name_creation = $CanvasLayer/TabContainer/nameCreation
@onready var confirm_box = $CanvasLayer/TabContainer/confirm_name/confirm_box
@onready var no = $CanvasLayer/TabContainer/confirm_name/confirm_box/VBoxContainer/HBoxContainer/no
@onready var whitefade_obj = $CanvasLayer/whitefadeObj
@onready var whitefade = $whitefade
@onready var continuation = $CanvasLayer/TabContainer/activeSave/save_box/MarginContainer/item_list/metrics2/Continuation
@onready var no_to_reset = $CanvasLayer/TabContainer/resetConfirmation/confirm_box/VBoxContainer/HBoxContainer/noToReset

func _ready():
	ready_or_reset()
	
func ready_or_reset():
	zor_enter.visible = false
	tab_container.current_tab = 0
	GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/mus_intronoise.ogg")
	GlobalFlags.sfx_1_channel.play()
	await get_tree().create_timer(4.0).timeout
	zor_enter.visible = true

func _input(event):
	if title_card.visible == true:
		if event.is_action_pressed("interact_confirm"):
			GlobalFlags.music_channel.stream = load("res://music/Start Menu.wav")
			GlobalFlags.music_channel.play()
			if GlobalFlags.HasSaved == false:
				tab_container.current_tab = 1
				title_card.visible = false
				startgame.disabled = false
				settings.disabled = false
				startgame.call_deferred("grab_focus")
			else:
				tab_container.current_tab = 5
				continuation.call_deferred("grab_focus")
				


func _on_startgame_pressed():
	tab_container.current_tab = 2
	quit.disabled = false
	done.disabled = false
	back_space.disabled = false
	back_space.call_deferred("grab_focus")

func _on_settings_pressed():
	tab_container.current_tab = 3
	master.call_deferred("grab_focus")

func _on_quit_pressed():
	get_tree().quit()


func _on_done_settings_pressed():
	if GlobalFlags.HasSaved == false:
		tab_container.current_tab = 1
		startgame.call_deferred("grab_focus")
	else:
		tab_container.current_tab = 5
		continuation.call_deferred("grab_focus")


func _on_done_name_pressed():
	if name_creation.nameArray.is_empty():
		return
	tab_container.current_tab = 4
	name_entryfinal.text = name_creation.nameClean
	animation_player.play("text shake")
	animation_player_2.play("enlarge")
	no.call_deferred("grab_focus")
	
func _on_no_pressed():
	tab_container.current_tab = 2
	back_space.call_deferred("grab_focus")


func _on_yes_pressed():
	PlayerData.fallen_name = name_creation.nameClean
	print(PlayerData.name)
	
	confirm_box.visible = false
	GlobalFlags.music_channel.stop()
	whitefade_obj.visible = true
	whitefade.play("fade_to_white")

	GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/mus_cymbal.ogg")
	GlobalFlags.sfx_1_channel.play()
	
	GlobalFlags.game_state = 0
	await get_tree().create_timer(4.6).timeout
	name_entryfinal.visible = false
	SignalManager.changed_game_state.emit()
	await get_tree().create_timer(0.5).timeout
	GlobalFlags.text_swaper["name"] = name_creation.nameClean
	SignalManager.inv_updated.emit()
	self.queue_free()


func _on_continuation_pressed():
	GlobalFlags.music_channel.stop()
	GlobalFlags.game_state = 0
	SignalManager.changed_game_state.emit()
	GlobalFlags.text_swaper["name"] = name_creation.nameClean
	SignalManager.inv_updated.emit()
	self.queue_free()


func _on_reset_pressed():
	tab_container.current_tab = 6
	no_to_reset.call_deferred("grab_focus")


func _on_no_to_reset_pressed():
	tab_container.current_tab = 5
	continuation.call_deferred("grab_focus")


func _on_yes_to_reset_pressed():
	GlobalFlags.HasSaved = false
	DirAccess.remove_absolute("user://file0.json")
	DirAccess.remove_absolute("user://fileP.json")
	PlayerData.load_the_game()
	RoomPersistance.load_the_game()
	GlobalFlags.music_channel.stop()
	ready_or_reset()
