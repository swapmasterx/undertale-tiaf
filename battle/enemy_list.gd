extends VBoxContainer

@onready var battlestate:BattleState = %BattleState

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
		new.pressed.connect(button_pressed)

## Updates the list to show if an enemy is out of battle or sparable.
func update_list()->void:
	if(visible):
		var i:Control = get_child(0)
		i.grab_focus()
	for i in get_child_count():
		# Update name color n such.
		var monster:BattleMonster = battlestate.encounter.get_child(i)
		# Goes in order of: Spared, Dead, Can Spare, and Normal.
		get_child(i).modulate = Color.GRAY if(monster.spared_or_dead and monster.can_spare)else \
									Color.BLACK if(monster.spared_or_dead)else Color.YELLOW \
									if(monster.can_spare)else Color.WHITE

func button_pressed()->void:
	var node = get_viewport().gui_get_focus_owner()
	if(node.get_parent() != self): return
	enemy_selected.emit()
	enemy_selected_index.emit(node.get_index())
