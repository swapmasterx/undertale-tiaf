extends MarginContainer


@onready var selectable_text_option = preload("res://UI/textbox stuff/item_text_options.tscn")
@onready var item_list = $uibackdrop2/MarginContainer/TabContainer/items/item_list
@onready var item_discription = $uibackdrop2/MarginContainer/TabContainer/items/item_details/item_discription
@onready var use = $uibackdrop2/MarginContainer/TabContainer/items/item_details/HBoxContainer/Use
@onready var toss = $uibackdrop2/MarginContainer/TabContainer/items/item_details/HBoxContainer/Toss


var button

func _ready():
	use.focus_mode = FOCUS_NONE
	use.disabled = true
	toss.focus_mode = FOCUS_NONE
	toss.disabled = true
	SignalManager.closed_choose_option.connect(_close_choose_option)
	SignalManager.inv_updated.connect(_on_inv_updated)
	SignalManager.use_or_toss.connect(_use_or_toss)
	_create_action_lists()
	
func _create_action_lists():
	InputMap.load_from_project_settings()
	_create_item_list()
	_create_settings_list()
	
func _create_item_list():
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
			button.focus_mode = FOCUS_ALL
			button.item = item
		else:
			button.text = "[null]"
		button.set_name("test_button")
		
		item_list.add_child(button, true)
	
	if items.size() < 8:
		for i in empty_slots:
			button = selectable_text_option.instantiate()
			button.is_empty = true
			button.text = "[NONE]"
			button.focus_mode = FOCUS_NONE
			
			button.add_theme_color_override("font_color", Color(0.45, 0.45, 0.45))
			item_list.add_child(button)

func _on_inv_updated():
	_create_item_list()

func _on_button_focus_entered(B: Button):
	item_discription.text = B.item.item_discription

func _use_or_toss():
	use.focus_mode = FOCUS_ALL
	use.disabled = false
	toss.focus_mode = FOCUS_ALL
	toss.disabled = false
	use.grab_focus()
	
func _on_use_pressed():
	use.focus_mode = FOCUS_NONE
	use.disabled = true
	toss.focus_mode = FOCUS_NONE
	toss.disabled = true
	GlobalFlags.choice_prompt_function = 0
	SignalManager.activate_choose_option.emit()
	
func _on_toss_pressed():
	use.focus_mode = FOCUS_NONE
	use.disabled = true
	toss.focus_mode = FOCUS_NONE
	toss.disabled = true
	GlobalFlags.choice_prompt_function = 2
	SignalManager.activate_choose_option.emit()
	
func _create_settings_list():
	pass

func _close_choose_option():
	use.focus_mode = FOCUS_NONE
	use.disabled = true
	toss.focus_mode = FOCUS_NONE
	toss.disabled = true
	var test_button = $"uibackdrop2/MarginContainer/TabContainer/items/item_list/".get_node_or_null("test_button")
	if test_button == null:
		return
	test_button.focus_mode = FOCUS_ALL
	test_button.grab_focus()
