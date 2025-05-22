extends Button

class_name TextButtonOption


func _on_focus_entered():
	
	GlobalFlags.sfx_1_channel.stream = load("res://battle/snd_squeakfix.wav")
	GlobalFlags.sfx_1_channel.play()


func _on_pressed():
	GlobalFlags.sfx_1_channel.stream = load("res://battle/snd_select.wav")
	GlobalFlags.sfx_1_channel.play()
