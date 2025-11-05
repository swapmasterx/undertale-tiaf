extends Node2D

@onready var camera = $"../player/Camera2D"
@onready var player = $"../player"
#@onready var tranistionSpot = $"Scripted Events/transitionSpot"

@export var sidescrollMode = false
@export var roomname: String


func _ready():
	SignalManager.startCutscene.connect(_on_cutscene_start)
	SignalManager.endCutscene.connect(_on_cutscene_end)
	await get_tree().create_timer(0.07).timeout
	#player.position = Vector2(0,0)d
	print(player.global_position)
	GlobalFlags.sideScrollMode = sidescrollMode
	GlobalFlags.roomname = roomname
	
	#SignalManager.inv_updated.emit()
	camera.set_camera_limits()
	print(GlobalFlags.roomname)
	
func _on_cutscene_start():
	GlobalFlags.cutscene_mode(true)
	
func _on_cutscene_end():
	GlobalFlags.cutscene_mode(false)
