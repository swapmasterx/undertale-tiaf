extends VBoxContainer

@onready var battlestate:BattleState = %BattleState

signal enemy_selected()
signal enemy_selected_index(enemy:int)

const PACKED_LIST_ITEM:PackedScene = preload("res://battle/EnemyName.tscn")

func _ready()->void:
	await battlestate.battle_start
	visibility_changed.connect(update_list)
	if(battlestate.encounter and not battlestate.encounter.can_flee):
		var node = get_child(1)
		node.queue_free()
	for i:Button in get_children():
		i.pressed.connect(button_pressed)

## Updates the mercy button to appear yellow if a monster can be spared.
func update_list()->void:
	if(visible):
		var i:Control = get_child(0)
		i.grab_focus()
	get_child(0).modulate = Color.YELLOW if(battlestate.encounter.monsters_can_be_spared())else Color.WHITE

func button_pressed()->void:
	var node = get_viewport().gui_get_focus_owner()
	if(node.get_parent() != self): return
	enemy_selected.emit()
	enemy_selected_index.emit(node.get_index())
