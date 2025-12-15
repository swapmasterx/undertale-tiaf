extends TextureButton

@onready var battle_logic = $"../.."
@onready var fight = %Fight
@onready var act = %Act
@onready var item = %Item
@onready var mercy = %Mercy
@onready var textbox_control = $"../../Node2D/Textbox Control"
@onready var battle_1 = $"../../battle_1"
@onready var battle_2 = $"../../battle_2"
@onready var option_set = $"../../Node2D/option_set"

@export_enum("Fight", "Act", "Item", "Mercy") var battle_button_type: String = "Fight"


# Called when the node enters the scene tree for the first time.
func _ready():
	fight.call_deferred("grab_focus")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("back_cancel") && GlobalFlags.options_mode == true:
		option_set.visible = false
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
	
	GlobalFlags.first_option_entry = false
