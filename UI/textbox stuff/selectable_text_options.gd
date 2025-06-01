extends Button

class_name TextButtonOption

@export var focus_entered_sound = "res://battle/snd_squeakfix.wav" 

@export var pressed_sound = "res://battle/snd_select.wav" 

func _on_focus_entered():
	
	GlobalFlags.sfx_1_channel.stream = load(focus_entered_sound)
	GlobalFlags.sfx_1_channel.play()


func _on_pressed():
	GlobalFlags.sfx_1_channel.stream = load(pressed_sound)
	GlobalFlags.sfx_1_channel.play()
