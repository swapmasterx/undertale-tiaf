extends CanvasLayer

var scene_to_load: String = "0"

var set_player_pos: Vector2

var sideScrollModeSet = false

var veticalScrollModeSet = false

@onready var anim_player = $AnimationPlayer

@onready var world_engine = get_tree().get_root().get_node("World_Engine") 

var stop_repeat = true

func change_scene():
	anim_player.play("fade_in")
	GlobalFlags.wasd_lock = true
	SignalManager.lockWasd.emit()
	GlobalFlags.menu_lock = true
	stop_repeat = false

func _on_animation_player_animation_finished(_fade_in):
	if stop_repeat == false:
		anim_finished()
		anim_player.play("fade_out")
		GlobalFlags.wasd_lock = false
		GlobalFlags.menu_lock = false
		stop_repeat = true
	else:
		return

func anim_finished():
	var current_room = get_tree().get_first_node_in_group("room")
	var pre_load_scene = load(scene_to_load)
	var set_load_scene = pre_load_scene.instantiate()
	
	GlobalFlags.room_changing = false
	#PlayerData.place_at_room_transition = set_player_pos
	#get_player.position = set_player_pos
	current_room.queue_free()
	GlobalFlags.sideScrollMode = sideScrollModeSet
	GlobalFlags.veticalScrollMode = veticalScrollModeSet
	
	world_engine.add_child.bind(set_load_scene).call_deferred()
