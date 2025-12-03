extends Button

class_name TextButtonOption

@export var focus_entered_sound = "res://sound_effects/snd_squeakfix.wav"

@export var pressed_sound = "res://sound_effects/snd_select.wav"



func _on_focus_entered():
	if GlobalFlags.first_option_entry == false:
		GlobalFlags.sfx_1_channel.stream = load(focus_entered_sound)
		GlobalFlags.sfx_1_channel.play()


func _on_pressed():
	GlobalFlags.first_option_entry = true
	GlobalFlags.sfx_1_channel.stream = load(pressed_sound)
	GlobalFlags.sfx_1_channel.play()
	GlobalFlags.first_option_entry = false
