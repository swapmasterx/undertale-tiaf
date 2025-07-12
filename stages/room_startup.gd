extends Node2D

@onready var camera = $"../Player/Camera2D"
@onready var player = $"../Player"
#@onready var tranistionSpot = $"Scripted Events/transitionSpot"

@export var sidescrollMode = false
@export var roomname: String


func _ready():
	await get_tree().create_timer(0.07).timeout
	#player.position = Vector2(0,0)d
	print(player.global_position)
	GlobalFlags.sideScrollMode = sidescrollMode
	GlobalFlags.roomname = roomname
	camera.set_camera_limits()
	
