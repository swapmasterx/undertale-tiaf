extends Node2D

@onready var camera = $"../player/Camera2D"
@onready var player = $"../player"
@onready var tranistionSpot = $"Scripted Events/transitionSpot"



func _ready():
	await get_tree().create_timer(0.07).timeout
	#player.position = Vector2(0,0)d
	print(player.global_position)
	camera.set_camera_limits()
