extends Node2D

@export var dialog_swap_a: DialogData
@export var dialog_swap_b: DialogData
@export var dialog_swap_c: DialogData

@onready var puzzle_hint = $"../Interactibles/puzzle_hint"
@onready var decor_b_1 = $"../DecorB/DecorB1"
@onready var decor_c = $"../DecorC"

func _ready():
	SignalManager.get_item.connect(on_item_get)
	if RoomPersistance.candy_counter >= 3:
		puzzle_hint.dialog_data =  dialog_swap_c
		puzzle_hint.enable_choice_prompt = false
		decor_b_1.visible = false
		decor_c.visible = true
	
func on_item_get():
	match RoomPersistance.candy_counter:
		0:
			RoomPersistance.candy_counter = 1 
			puzzle_hint.dialog_data = dialog_swap_a
		1:
			RoomPersistance.candy_counter = 2
			puzzle_hint.dialog_data =  dialog_swap_b
		2:
			RoomPersistance.candy_counter = 3
			puzzle_hint.dialog_data =  dialog_swap_c
			puzzle_hint.enable_choice_prompt = false
			decor_b_1.visible = false
			decor_c.visible = true
		3:
			pass
		_:
			push_error("Candy tracker indexed out of bounds.")
