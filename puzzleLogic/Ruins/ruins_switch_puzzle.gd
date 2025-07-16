extends Node2D
@onready var decor_b = $"../DecorB"


@export var solution: int

var persistance = RoomPersistance.switch_puzzle

var solved: int

func _ready():
	SignalManager.switchpuzzle.connect(_on_puzzle_checked)
	if persistance == true:
		SignalManager.switchpuzzle.emit()
		print("persisted")


func _on_puzzle_checked():
	solved += 1
	if solved == solution or persistance == true:
		decor_b.erase_cell(Vector2i(16, 1))
		decor_b.erase_cell(Vector2i(16, 2))
		RoomPersistance.switch_puzzle = true
