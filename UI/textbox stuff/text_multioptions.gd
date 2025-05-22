extends TextButtonOption

@onready var choice_options = $"../../.."

@export var option_selected: int

func _on_pressed():
	choice_options._option_chosen(option_selected)
	GlobalFlags.sfx_1_channel.stream = load("res://battle/snd_select.wav")
	GlobalFlags.sfx_1_channel.play()
