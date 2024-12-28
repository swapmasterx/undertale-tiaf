extends Area2D

@export var scene_to_load: PackedScene

@export var set_player_pos: Vector2

@export var sideScrollModeSet = false

@export var veticalScrollModeSet = false

@onready var current_room = get_tree().get_first_node_in_group("room")

@onready var world_engine = get_tree().get_root().get_node("World_Engine") 

func _ready():
	SignalManager.fade_in_finished.connect(_anim_finished)

func _on_body_entered(body):
	print("entered load zone")
	Loadscreen.change_scene()

func _anim_finished():
	var pre_load_scene = scene_to_load.instantiate()
	current_room.queue_free()
	CharacterStats.place_at = set_player_pos
	GlobalFlags.sideScrollMode = sideScrollModeSet
	GlobalFlags.veticalScrollMode = veticalScrollModeSet
	world_engine.add_child.bind(pre_load_scene).call_deferred()
