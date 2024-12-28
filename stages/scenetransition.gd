extends CanvasLayer

@onready var anim_player = $AnimationPlayer

var stop_repeat = true

func change_scene():
	anim_player.play("fade_in")
	SignalManager.lockMenu.emit()
	SignalManager.lockWasd.emit()
	stop_repeat = false

func _on_animation_player_animation_finished(fade_in):
	if stop_repeat == false:
		SignalManager.fade_in_finished.emit()
		anim_player.play("fade_out")
		SignalManager.unlockMenu.emit()
		SignalManager.unlockWasd.emit()
		stop_repeat = true
	else:
		return
