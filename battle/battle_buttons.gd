extends TextureButton

@onready var battle_sfx = $"../../battle_music/battle_sfx"
@onready var fight = %Fight
@onready var act = %Act
@onready var item = %Item
@onready var mercy = %Mercy
@onready var text_button_1 = $"../../Node2D/VBoxContainer/TextButton1"
@onready var text_button_2 = $"../../Node2D/VBoxContainer/TextButton2"
@onready var text_button_3 = $"../../Node2D/VBoxContainer/TextButton3"
@onready var text_button_4 = $"../../Node2D/VBoxContainer2/TextButton4"
@onready var text_button_5 = $"../../Node2D/VBoxContainer2/TextButton5"
@onready var text_button_6 = $"../../Node2D/VBoxContainer2/TextButton6"
@onready var textbox_control = $"../../Node2D/Textbox Control"

@export_enum("Fight", "Act", "Item", "Mercy") var battle_button_type: String = "Fight"


# Called when the node enters the scene tree for the first time.
func _ready():
	fight.grab_focus()
	reset_text_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("back_cancel") && GlobalFlags.options_mode == true:
		reset_text_buttons()
		match GlobalFlags.set_battle_option:
			[0]:
				fight.grab_focus()
				fight.button_pressed = false
			[1]:
				act.grab_focus()
				act.button_pressed = false
			[2]:
				item.grab_focus()
				item.button_pressed = false
			[3]:
				mercy.grab_focus()
				mercy.button_pressed = false
		
		GlobalFlags.options_mode = false

func reset_text_buttons():
	text_button_1.focus_mode = FOCUS_NONE
	text_button_2.focus_mode = FOCUS_NONE
	text_button_3.focus_mode = FOCUS_NONE
	text_button_4.focus_mode = FOCUS_NONE
	text_button_5.focus_mode = FOCUS_NONE
	text_button_6.focus_mode = FOCUS_NONE
	text_button_1.text = "　"
	text_button_2.text = "　"
	text_button_3.text = "　"
	text_button_4.text = "　"
	text_button_5.text = "　"
	text_button_6.text = "　"

func _on_focus_entered():
	battle_sfx.stream = load("res://battle/snd_squeakfix.wav")
	battle_sfx.play()

#func _input(event):
	#if event.is_action_pressed("interact_confirm"):
		#pressed()

func _on_pressed():
	battle_sfx.stream = load("res://battle/snd_select.wav")
	match battle_button_type:
		"Fight":
			GlobalFlags.set_battle_option = [0]
			set_fight_or_act()
		"Act":
			GlobalFlags.set_battle_option = [1]
			set_fight_or_act()
		"Item":
			GlobalFlags.set_battle_option = [2]
			set_item()
		"Mercy":
			GlobalFlags.set_battle_option = [3]
			set_mercy()
			
	battle_sfx.play()
	text_button_1.grab_focus()

#func pressed():
	#battle_sfx.stream = load("res://battle/snd_select.wav")
	#match battle_button_type:
		#"Fight":
			#GlobalFlags.set_battle_option = [0]
			#set_fight_or_act()
		#"Act":
			#GlobalFlags.set_battle_option = [1]
			#set_fight_or_act()
		#"Item":
			#GlobalFlags.set_battle_option = [2]
			#set_item()
		#"Mercy":
			#GlobalFlags.set_battle_option = [3]
			#set_mercy()
			#
	#battle_sfx.play()
	#text_button_1.grab_focus()

func set_fight_or_act():
	text_button_1.text = GlobalFlags.battle_lineup[0]
	text_button_1.focus_mode = FOCUS_ALL
	text_button_2.text = GlobalFlags.battle_lineup[1]
	if GlobalFlags.battle_lineup[1] != "":
		text_button_2.focus_mode = FOCUS_ALL
	text_button_3.text = GlobalFlags.battle_lineup[2]
	if GlobalFlags.battle_lineup[2] != "":
		text_button_3.focus_mode = FOCUS_ALL
	
	if GlobalFlags.set_battle_option == [1]:
		set_act_cont()

func set_act_cont():
	pass
	
func set_item():
	text_button_1.focus_mode = FOCUS_ALL
	if GlobalFlags.items == []:
		text_button_1.text = "[NONE]"
	else:
		text_button_1.text = []
	text_button_3.text = "ITEM 1/8"

func set_mercy():
	text_button_1.text = "Spare"
	text_button_1.focus_mode = FOCUS_ALL
	text_button_2.text = "Flee"
	text_button_2.focus_mode = FOCUS_ALL
