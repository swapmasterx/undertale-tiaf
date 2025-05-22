extends Node2D

func _ready():
	var dict: Dictionary = SaveData.load_game()
	var scene_to_load = dict["room_num"]
	var pre_load_scene = load(scene_to_load)
	load(scene_to_load)
	var set_load_scene = pre_load_scene.instantiate()
	self.add_child.bind(set_load_scene).call_deferred()
