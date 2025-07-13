extends Camera2D

@onready var player = get_parent();
@onready var camera_2d = $"."

@export var SPEED = 10

func set_camera_limits():
	#map = $"../../Room_Core/Map"
	await get_tree().create_timer(0.07).timeout
	print("limits set")
	var map = get_tree().get_first_node_in_group("map_base")
	var map_limits = map.get_used_rect()
	var map_cellsize = map.tile_set.tile_size
	if map != null:
		camera_2d.limit_left = map_limits.position.x * map_cellsize.x
		camera_2d.limit_right = map_limits.end.x * map_cellsize.x
		if GlobalFlags.sideScrollMode == true:
			#camera_2d.limit_top = map_limits.position.y * map_cellsize.y
			#camera_2d.limit_bottom = map_limits.end.y * map_cellsize.y
			camera_2d.limit_top = -540
			camera_2d.limit_bottom = 440
		elif GlobalFlags.sideScrollMode == false:
			camera_2d.limit_top = map_limits.position.y * map_cellsize.y
			camera_2d.limit_bottom = map_limits.end.y * map_cellsize.y
	if map == null: 
		print("No map found")
