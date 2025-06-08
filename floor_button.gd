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
		await self.ready
		sprite.texture = off_texture

func _on_interact():
	if switch_state == false:
		sprite.texture = on_texture
		switch_state = true
	else:
		sprite.texture = off_texture
		switch_state = false
	print("touched the button ", switch_state)
