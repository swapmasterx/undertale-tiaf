extends TextureButton

@onready var battle_logic = $"../.."
@onready var fight = %Fight
@onready var act = %Act
@onready var item = %Item
@onready var mercy = %Mercy
@onready var textbox_control = $"../../Node2D/Textbox Control"
@onready var battle_1 = $"../../battle_1"
@onready var battle_2 = $"../../battle_2"
@onready var text_button_1 = $"../../Node2D/VBoxContainer/TextButton1"
@onready var text_button_2 = $"../../Node2D/VBoxContainer/TextButton2"
@onready var text_button_3 = $"../../Node2D/VBoxContainer/TextButton3"
@onready var text_button_4 = $"../../Node2D/VBoxContainer2/TextButton4"
@onready var text_button_5 = $"../../Node2D/VBoxContainer2/TextButton5"
@onready var text_button_6 = $"../../Node2D/VBoxContainer2/TextButton6"

@export_enum("Fight", "Act", "Item", "Mercy") var battle_button_type: String = "Fight"


# Called when the node enters the scene tree for the first time.
func _ready():
	fight.call_deferred("grab_focus")
	reset_text_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("back_cancel") && GlobalFlags.options_mode == true:
		reset_text_buttons()
		match battle_logic.set_battle_option:
			0:
				fight.grab_focus()
				fight.button_pressed = false
			1:
				act.grab_focus()
				act.button_pressed = false
			2:
				item.grab_focus()
				item.button_pressed = false
			3:
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
	battle_1.stream = load("res://sound_effects/snd_squeakfix.wav")
	battle_1.play()

func _on_pressed():
	battle_1.stream = load("res://sound_effects/snd_select.wav")
	GlobalFlags.options_mode = true
	GlobalFlags.first_option_entry = true
	match battle_button_type:
		"Fight":
			battle_logic.set_battle_option = 0
			battle_logic.set_option_context()
		"Act":
			battle_logic.set_battle_option = 1
			battle_logic.set_option_context()
		"Item":
			battle_logic.set_battle_option = 2
			battle_logic.set_option_context()
		"Mercy":
			battle_logic.set_battle_option = 3
			battle_logic.set_option_context()
			
	battle_1.play()
	text_button_1.grab_focus()
	GlobalFlags.first_option_entry = false
