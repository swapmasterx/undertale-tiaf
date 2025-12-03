extends Sprite2D

@onready var color_rect = $"../../overworld_hazard_filter"
@onready var glow = $glow

func _ready():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(color_rect, "modulate:a", 0, 0.1)
	tween.tween_property(self, "modulate:a", 0, 0.1)
	tween.tween_property(glow, "modulate:a", 0, 0.1)
	color_rect.visible = false
	self.visible = false
	
	SignalManager.enter_overworld_hazard.connect(enter_overworld_hazard)
	SignalManager.exit_overworld_hazard.connect(exit_overworld_hazard)

func enter_overworld_hazard():
	self.visible = true
	color_rect.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(color_rect, "modulate:a", 1, 0.5)
	tween.tween_property(self, "modulate:a", 1, 0.5)
	tween.tween_property(glow, "modulate:a", 1, 0.5)
	
func exit_overworld_hazard():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(color_rect, "modulate:a", 0, 0.5)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_property(glow, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.51).timeout
	self.visible = false
	color_rect.visible = false
