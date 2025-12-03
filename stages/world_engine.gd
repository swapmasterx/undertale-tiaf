extends Node2D

var main_menu = preload("res://mainmenu/main_menu_fab.tscn")

func _ready():
	SignalManager.changed_game_state.connect(changed_game_state)
	set_state()
	
func changed_game_state():
	set_state()

func set_state():
	match GlobalFlags.game_state:
		#overworld after title screen (THAT IS THE ONLY CASE THIS SHOULD BE SET)
		0:
			var dict: Dictionary = SaveData.load_game()
			var scene_to_load = dict["room_num"]
			var pre_load_scene = load(scene_to_load)
			load(scene_to_load)
			var set_load_scene = pre_load_scene.instantiate()
			self.add_child.bind(set_load_scene).call_deferred()
			GlobalFlags.wasd_lock = false
			GlobalFlags.menu_lock = false
		#battle
		1:
			#var get_room = get_tree().get_first_node_in_group("room")
			#get_room.queue_free()
			GlobalFlags.overworld_lockdown = true
			SignalManager.lockWasd.emit()
			GlobalFlags.menu_lock = true
			var scene_to_load = "res://battle/battle_scene.tscn"
			var pre_load_scene = load(scene_to_load)
			var set_load_scene = pre_load_scene.instantiate()
			self.add_child.bind(set_load_scene).call_deferred()
		#title screen
		2:
			GlobalFlags.wasd_lock = true
			SignalManager.lockWasd.emit()
			GlobalFlags.menu_lock = true
			var set_load_scene = main_menu.instantiate()
			self.add_child.bind(set_load_scene).call_deferred()
		#overworld after battle
		3:
			GlobalFlags.wasd_lock = false
			GlobalFlags.menu_lock = false
