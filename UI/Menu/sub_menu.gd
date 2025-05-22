extends MarginContainer


@onready var selectable_text_option = preload("res://UI/textbox stuff/item_text_options.tscn")
@onready var item_list = $uibackdrop2/MarginContainer/TabContainer/items/item_list
@onready var item_discription = $uibackdrop2/MarginContainer/TabContainer/items/item_details/item_discription

var items = PlayerData.inventory
var button

func _ready():
	SignalManager.closed_choose_option.connect(_close_choose_option)
	SignalManager.inv_updated.connect(_on_inv_updated)
	_create_action_lists()
	
func _create_action_lists():
	InputMap.load_from_project_settings()
	_create_item_list()
	_create_settings_list()
	
func _create_item_list():
	for n in item_list.get_children():
		item_list.remove_child(n)
		n.queue_free()
		
	var empty_slots = 8 - items.size()
	
	for i in items.size():
		button = selectable_text_option.instantiate()
		var item = items[i]
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
			
			button.text = "[NONE]"
			button.focus_mode = FOCUS_NONE
			button.add_theme_color_override("font_color", Color(0.45, 0.45, 0.45))
			item_list.add_child(button)

func _on_inv_updated():
	_create_item_list()

func _on_button_focus_entered(B: Button):
	item_discription.text = B.item.item_discription

func _create_settings_list():
	pass

func _close_choose_option():
	var test_button = $"uibackdrop2/MarginContainer/TabContainer/items/item_list/test_button"
	if test_button == null:
		return
	test_button.grab_focus()
