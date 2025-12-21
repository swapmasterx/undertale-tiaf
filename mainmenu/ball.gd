extends Node

var button_progress:int = 0
var button_combo:PackedInt32Array = [KEY_B,KEY_A,KEY_L,KEY_L]

func _input(event: InputEvent)->void:
	if(button_progress == -1): return
	if(not get_parent().visible): return
	if(not (event is InputEventKey) or event.is_released()): return
	if(event.keycode == button_combo[button_progress]):
		button_progress += 1
		if(button_progress >= button_combo.size()):
			button_progress = -1
			$Chime.play()
