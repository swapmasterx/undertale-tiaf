extends Node2D

@export var scene_to_load: String = "0"

@export var set_player_pos: Vector2

@export var sideScrollModeSet = false

@export var veticalScrollModeSet = false

@export var load_trigger_area: LoadTriggerArea



func _ready():
	
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		load_trigger_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print("entered load zone")
	GlobalFlags.room_changing = true
	Loadscreen.scene_to_load = scene_to_load
	Loadscreen.set_player_pos = set_player_pos
	Loadscreen.sideScrollModeSet = sideScrollModeSet
	Loadscreen.veticalScrollModeSet = veticalScrollModeSet
	Loadscreen.change_scene()
