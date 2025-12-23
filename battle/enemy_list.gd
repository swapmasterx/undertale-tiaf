extends VBoxContainer

@onready var battlestate:BattleState = %BattleState

var enemy_index:int

signal enemy_selected()
signal enemy_selected_index(enemy:int)

const PACKED_LIST_ITEM:PackedScene = preload("res://battle/EnemyName.tscn")

func _ready()->void:
	await battlestate.battle_start
	visibility_changed.connect(update_list)
	var encounter:BattleEncounter = battlestate.encounter
	for i in encounter.get_children():
		var new = PACKED_LIST_ITEM.instantiate()
		new.text = i.name
		add_child(new)

func update_list()->void:
	for i in get_children():
		## Update name color n such.
		pass
