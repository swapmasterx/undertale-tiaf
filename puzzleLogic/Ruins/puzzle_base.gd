extends Node2D

#class_name PuzzleLogic

@onready var decor_b = $"../DecorB"


@export var solution: int

var persistance = RoomPersistance.first_puzzle

var solved: int

func _ready():
	SignalManager.switchpuzzle.connect(_on_puzzle_checked)
	if persistance == true:
		SignalManager.switchpuzzle.emit()

func _on_puzzle_checked():
	if solved == solution or persistance == true:
		decor_b.erase_cell(Vector2i(-2, -4))
		decor_b.erase_cell(Vector2i(-1, -4))
		RoomPersistance.first_puzzle = true
	solved = 0
