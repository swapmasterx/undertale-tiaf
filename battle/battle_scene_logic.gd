extends Node2D

@onready var battle_cam = $battle_cam
@onready var text_button_1 = $Node2D/VBoxContainer/TextButton1
@onready var text_button_2 = $Node2D/VBoxContainer/TextButton2
@onready var text_button_3 = $Node2D/VBoxContainer/TextButton3
@onready var text_button_4 = $Node2D/VBoxContainer2/TextButton4
@onready var text_button_5 = $Node2D/VBoxContainer2/TextButton5
@onready var text_button_6 = $Node2D/VBoxContainer2/TextButton6

@export var animPlayer: AnimationPlayer

var set_battle_option: int = 0

var is_fleeable: bool = true

func _ready():
	animPlayer.play("fade_in")
	SignalManager.battle_loaded.emit()
	battle_cam.enabled = true

func battle_item_handler():
	text_button_1.focus_mode = 2
	if PlayerData.items == []:
		text_button_1.text = "[NONE]"
	else:
		text_button_1.text = []
	text_button_3.text = "ITEM 1/8"

func set_option_context():
	match set_battle_option:
		#Fight
		0:
			pass
		#Act
		1:
			pass
		#Item
		2:
			pass
		#Mercy
		3:
			set_mercy()

func set_fight_or_act():
	text_button_1.text = GlobalFlags.battle_lineup[0]
	text_button_1.focus_mode = 2
	text_button_2.text = GlobalFlags.battle_lineup[1]
	if GlobalFlags.battle_lineup[1] != "":
		text_button_2.focus_mode = 2
	text_button_3.text = GlobalFlags.battle_lineup[2]
	if GlobalFlags.battle_lineup[2] != "":
		text_button_3.focus_mode = 2
	
	if GlobalFlags.set_battle_option == 1:
		set_act_cont()

func set_act_cont():
	pass
	

func set_mercy():
	text_button_1.text = "Spare"
	text_button_1.focus_mode = 2
	if is_fleeable == true:
		text_button_2.text = "Flee"
		text_button_2.focus_mode = 2


func _on_text_button_1_pressed():
	text_choice_selected(0)

func _on_text_button_2_pressed():
	text_choice_selected(1)

func _on_text_button_3_pressed():
	text_choice_selected(3)

func _on_text_button_4_pressed():
	text_choice_selected(4)

func _on_text_button_5_pressed():
	text_choice_selected(5)

func _on_text_button_6_pressed():
	text_choice_selected(6)

func text_choice_selected(choice_option):
	match set_battle_option:
		#Fight
		0:
			fight_options(choice_option)
		#Act
		1:
			act_options_select_target(choice_option)
		#Item
		2:
			item_options(choice_option)
		#Mercy
		3:
			mercy_options(choice_option)

func fight_options(choice_option):
	match choice_option:
		0:
			pass
		1:
			pass
		2:
			pass
		_:
			print("Option chosen exceeds bounds for the Fight option")

func act_options_select_target(choice_option):
	match choice_option:
		0:
			pass
		1:
			pass
		2:
			pass
		_:
			print("Option chosen exceeds bounds for the Act option")

func item_options(choice_option):
	match choice_option:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
		_:
			print("Option chosen exceeds bounds for the Item option")

func mercy_options(choice_option):
	match choice_option:
		0:
			pass
		1:
			pass
		_:
			print("Option chosen exceeds bounds for the Mercy option")
