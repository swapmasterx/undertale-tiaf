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
	GlobalFlags.sideScrollMode = sidescrollMode
	GlobalFlags.roomname = roomname
	if PlayerData.chase_sequence == true:
		SignalManager.enter_overworld_hazard.emit()
	camera.set_camera_limits()
	
func _on_cutscene_start():
	GlobalFlags.cutscene_mode(true)
	
func _on_cutscene_end():
	GlobalFlags.cutscene_mode(false)
