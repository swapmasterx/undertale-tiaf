extends Node2D

var main_menu = preload("res://mainmenu/main_menu_fab.tscn")

func _ready():
	SignalManager.changed_game_state.connect(changed_game_state)
	set_state()
	
func changed_game_state():
	set_state()

func set_state():
	match GlobalFlags.game_state:
		0:
			var dict: Dictionary = SaveData.load_game()
			var scene_to_load = dict["room_num"]
			var pre_load_scene = load(scene_to_load)
			load(scene_to_load)
			var set_load_scene = pre_load_scene.instantiate()
			self.add_child.bind(set_load_scene).call_deferred()
			GlobalFlags.wasd_lock = false
			GlobalFlags.menu_lock = false
		1:
			pass
		2:
			GlobalFlags.wasd_lock = true
			SignalManager.lockWasd.emit()
			GlobalFlags.menu_lock = true
			var set_load_scene = main_menu.instantiate()
			self.add_child.bind(set_load_scene).call_deferred()
