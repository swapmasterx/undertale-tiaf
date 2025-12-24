extends Control

@onready var battlestate:BattleState = %BattleState

const PACKED_LIST_ITEM:PackedScene = preload("res://battle/EnemyName.tscn")

signal action_selected(String)

func _ready() -> void:
	await battlestate.battle_start
	visibility_changed.connect(update_list)

## Updates the list to show the list of actions that can be performed on this enemy.
func update_list()->void:
	if(visible):
		for i in get_children(): i.queue_free()
		# Get act options from monster
		var new_first
		var monster:BattleMonster = battlestate.encounter.get_child(battlestate.encounter.target_monster)
		for i in monster.act_options:
			var new = PACKED_LIST_ITEM.instantiate()
			new.name = i
			new.text = i
			add_child(new)
			new.pressed.connect(button_pressed)
			if(not new_first): new_first = new
		# Set first index to be focused
		new_first.grab_focus()

func button_pressed()->void:
	var node = get_viewport().gui_get_focus_owner()
	if(node.get_parent() != self): return
	action_selected.emit(node.name)
