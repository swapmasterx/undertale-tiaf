extends "res://items/classes/item_class.gd"

class_name Weapon

@export var attack: float

@export_enum("1_bar", "2_bar", "4_bar") var attack_style: int

@export var crit_mult: float = 1
