extends Node2D

@onready var battle_cam = $battle_cam
@onready var fight_1 = $Node2D/option_set/Fight/Fight1
@onready var fight_2 = $Node2D/option_set/Fight/Fight2
@onready var fight_3 = $Node2D/option_set/Fight/Fight3
@onready var act_1 = $Node2D/option_set/Act/Act1
@onready var act_2 = $Node2D/option_set/Act/Act2
@onready var act_3 = $Node2D/option_set/Act/Act3
@onready var mercy_1 = $Node2D/option_set/Mercy/Mercy1
@onready var mercy_2 = $Node2D/option_set/Mercy/Mercy2
@onready var item_a = $Node2D/option_set/Item1/ItemA
@onready var item_b = $Node2D/option_set/Item1/ItemB
@onready var item_c = $Node2D/option_set/Item1/ItemC
@onready var item_d = $Node2D/option_set/Item1/ItemD
@onready var item_e = $Node2D/option_set/Item2/ItemE
@onready var item_f = $Node2D/option_set/Item2/ItemF
@onready var item_g = $Node2D/option_set/Item2/ItemG
@onready var item_h = $Node2D/option_set/Item2/ItemH
@onready var option_set = $Node2D/option_set

@export var animPlayer: AnimationPlayer

var enemy_count: int

var button

var set_battle_option: int = 0

var is_fleeable: bool = true

func _ready():
	option_set.visible = false
	animPlayer.play("fade_in")
	SignalManager.battle_loaded.emit()
	battle_cam.enabled = true



func set_option_context():
	option_set.visible = true
	match set_battle_option:
		#Fight
		0:
			option_set.current_tab = 0
			set_fight_or_act()
			await get_tree().process_frame
			fight_1.call_deferred("grab_focus")
			
		#Act
		1:
			option_set.current_tab = 1
			set_fight_or_act()
			await get_tree().process_frame
			act_1.call_deferred("grab_focus")
		#Item
		2:
			option_set.current_tab = 2
			battle_item_handler()
		#Mercy
		3:
			option_set.current_tab = 4
			set_mercy()
			await get_tree().process_frame
			mercy_1.call_deferred("grab_focus")

func set_fight_or_act():
	fight_2.visible = false
	fight_3.visible = false
	act_2.visible = false
	act_3.visible = false
	fight_1.text = GlobalFlags.battle_lineup[0]
	act_1.text = GlobalFlags.battle_lineup[0]
	
	if GlobalFlags.battle_lineup.size() == 2:
		fight_2.text = GlobalFlags.battle_lineup[1]
		act_2.text = GlobalFlags.battle_lineup[1]
		fight_2.visible = true
		act_2.visible = true
	
	if GlobalFlags.battle_lineup.size() == 3:
		fight_3.text = GlobalFlags.battle_lineup[2]
		act_3.text = GlobalFlags.battle_lineup[2]
		fight_3.visible = true
		act_3.visible = true
	
	if set_battle_option == 1:
		set_act_cont()
		

func set_act_cont():
	act_1.call_deferred("grab_focus")
	
func battle_item_handler():
	var items = PlayerData.inventory
	for i in items.size():
		var itempointer = items[i]
		ItemTable.load_item(itempointer)
		var item = ItemTable.item_loaded
		if items.size() > 0:
			button.text = str(item.item_name)
			button.item = item
	if PlayerData.inventory == []:
		item_a.text = "[NONE]"
	else:
		item_a.text = []

func set_mercy():
	if is_fleeable == false:
		mercy_2.visible = false
		mercy_2.focus_mode = 0
	else:
		mercy_2.visible = true
		mercy_2.focus_mode = 2
