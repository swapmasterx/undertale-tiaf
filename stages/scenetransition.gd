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
	GlobalFlags.menu_lock = true
	stop_repeat = false

func _on_animation_player_animation_finished(fade_in):
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
	
	var get_player = get_tree().get_first_node_in_group("player")
	var pre_load_scene = load(scene_to_load)
	var set_load_scene = pre_load_scene.instantiate()
	
	GlobalFlags.room_changing = false
	current_room.queue_free()
	GlobalFlags.sideScrollMode = sideScrollModeSet
	GlobalFlags.veticalScrollMode = veticalScrollModeSet
	
	world_engine.add_child.bind(set_load_scene).call_deferred()
	# Wait for the new scene to be loaded.
	await set_load_scene.ready;
	# Okay so for easier testing, if no spawnpoints are available it will just put the player at 0,0
	if(not is_instance_valid(set_load_scene.get_node_or_null("SpawnPoints"))):
		Player.this_node.global_position = Vector2();
		return
	if(set_load_scene.get_node_or_null("SpawnPoints").get_children().size() == 0):
		Player.this_node.global_position = Vector2();
		return
	# Attempt to get the spawn location.
	var location_to_use = set_load_scene.get_node_or_null("SpawnPoints/"+Player.spawn_location);
	if(not is_instance_valid(location_to_use)):
		# Attempt to get the first spawn as a backup, otherwise quit execution.
		location_to_use = set_load_scene.get_node("SpawnPoints").get_child(0);
		if(not is_instance_valid(location_to_use)): return;
	# And hope it's not an invalid node lol
	Player.this_node.global_position = location_to_use.global_position;
	# Personally not how i would handle something like this, but it works so whatevs lol
