extends Camera2D

@onready var player = $"../CharacterBody2D"
@onready var camera_2d = $"."
@onready var map = get_tree().get_first_node_in_group("map_base")



@export var SPEED = 10

#func _ready():
	#set_camera_limits()

func _process(delta):
	position = lerp(position, player.position, SPEED*delta)

func set_camera_limits():
	#map = $"../../Room_Core/Map"
	print("limits set")
	map = get_tree().get_first_node_in_group("map_base")
	var map_limits = map.get_used_rect()
	var map_cellsize = map.tile_set.tile_size
	
	camera_2d.limit_left = map_limits.position.x * map_cellsize.x
	camera_2d.limit_right = map_limits.end.x * map_cellsize.x
	if GlobalFlags.sideScrollMode == true:
		camera_2d.limit_top = -540
		camera_2d.limit_bottom = 440
	elif GlobalFlags.sideScrollMode == false:
		camera_2d.limit_top = map_limits.position.y * map_cellsize.y
		camera_2d.limit_bottom = map_limits.end.y * map_cellsize.y
