extends Control


func _ready():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, 0.1)
	self.visible = false
	SignalManager.enter_overworld_hazard.connect(enter_overworld_hazard)
	SignalManager.exit_overworld_hazard.connect(exit_overworld_hazard)

func enter_overworld_hazard():
	self.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 1, 0.5)
	

func exit_overworld_hazard():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.51).timeout
	self.visible = false
	
