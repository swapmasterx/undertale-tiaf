extends CharacterBody2D

@export var is_overworld: bool = true
#@onready var collision_hitbox = $collision_hitbox
#
#@export_enum("Standard", "Gravity_Blue", "Stationary_Green", 
#"Shooty_Yellow", "Web_Purple") var soul_mode: String = "Standard"

#var SPEED = 300.0


func _ready():
	SignalManager.soul_cursor_visible.connect(soul_visibility)
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	SignalManager.soul_cursor_visible.emit(false)
	
func soul_visibility(set_visibility):
	
	if is_overworld == true && GlobalFlags.game_state != 1:
		if set_visibility == true:
			self.visible = true
			return
		if set_visibility == false:
			self.visible = false
			return
	if is_overworld == false && GlobalFlags.game_state == 1:
		if set_visibility == true:
			self.visible = true
			return
		if set_visibility == false:
			self.visible = false
			return



#signal toggles
func _on_focus_changed(node:Control):
	var focused_size = get_viewport().gui_get_focus_owner().size
	var focused_pos = get_viewport().gui_get_focus_owner().global_position
	if GlobalFlags.wasd_lock == true:
		if get_viewport().gui_get_focus_owner() is TextureButton:
			self.global_position = (focused_pos + Vector2(-focused_size.x/7.25,0)) + ((focused_size/2)*0.4)
			
		else:
			self.global_position = (focused_pos + Vector2(-focused_size.x/1.5,0)) + (focused_size/2)
			
