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
@onready var item_list = $Node2D/option_set/Item1/Item_list
@onready var selectable_text_option = preload("res://UI/textbox stuff/item_text_options.tscn")

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
	SignalManager.soul_cursor_visible.emit(true)
	SignalManager.player_turn_finished.connect(player_turn_finished)
	battle_cam.enabled = true

func player_turn_finished():
	option_set.visible = false
	match set_battle_option:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass

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
			#await get_tree().process_frame
			#item_a.call_deferred("grab_focus")
		#Mercy
		3:
			option_set.current_tab = 3
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
	for n in item_list.get_children():
		item_list.remove_child(n)
		n.queue_free()
		
	var empty_slots = 8 - items.size()
	for i in items.size():
		button = selectable_text_option.instantiate()
		var itempointer = items[i]
		ItemTable.load_item(itempointer)
		var item = ItemTable.item_loaded
		if items.size() > 0:
			button.focus_entered.connect(_on_button_focus_entered.bind(button));
			button.text = str(item.item_name)
			button.focus_mode = 2
			button.item = item
			button.overworld = false
		else:
			button.text = "[null]"
		button.set_name("test_button")
		

		item_list.add_child(button, true)
		var test_button = $Node2D/option_set/Item1/Item_list/test_button
		if test_button == null:
			return
		await get_tree().process_frame
		test_button.call_deferred("grab_focus")
		
	if items.size() < 8:
		for i in empty_slots:
			button = selectable_text_option.instantiate()
			button.is_empty = true
			button.text = "[NONE]"
			button.focus_mode = 0
			
			button.add_theme_color_override("font_color", Color(0.45, 0.45, 0.45))
			item_list.add_child(button)
			
func _on_button_focus_entered(B: Button):
	pass
	#item_discription.text = B.item.item_discription

func set_mercy():
	if is_fleeable == false:
		mercy_2.visible = false
		mercy_2.focus_mode = 0
	else:
		mercy_2.visible = true
		mercy_2.focus_mode = 2
