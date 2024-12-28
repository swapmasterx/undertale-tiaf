extends Node2D

@onready var camera = $"../player/Camera2D"
@onready var player = $"../player"



func _ready():
	await get_tree().create_timer(0.07).timeout
	player.global_position = CharacterStats.place_at
	print(player.global_position)
	camera.set_camera_limits()
