extends "res://items/classes/item_class.gd"

class_name Spell


@export var mana_cost: int

#@export_enum("Attack", "Heal", "Buff") var spell_type: int

@export_enum("f_pellets", "vines", "thorns", "sword", "heal") var spell: int
