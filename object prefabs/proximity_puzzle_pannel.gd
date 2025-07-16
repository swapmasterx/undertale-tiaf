extends Node2D

@export var load_trigger_area: LoadTriggerArea

@export var on_texture: Texture

@export var off_texture: Texture 

@export var sprite: Sprite2D

@export var switch_state: bool = false

func _ready():
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
			load_trigger_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	pass
		
		


func _on_load_trigger_area_body_entered(body):
	sprite.texture = on_texture


func _on_load_trigger_area_body_exited(body):
	sprite.texture = off_texture
