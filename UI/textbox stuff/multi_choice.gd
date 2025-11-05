extends MarginContainer

@onready var textbox_control = $"../.."
@onready var option_a = $VBoxContainer/HBoxContainer/optionA
@onready var option_b = $VBoxContainer/HBoxContainer/optionB
@onready var option_c = $VBoxContainer/HBoxContainer/optionC
@onready var option_d = $VBoxContainer/HBoxContainer/optionD
@onready var player_soul = $"../../../player_soul"

var dialog_question: String = "{action_ph} the {item}?"
var dialog_responce_a: String = "You consumed the {item}. You recovered {itemHP}."
var dialog_responce_b: String = "You consumed the {item}. Your HP was maxed out."
var dialog_responce_c: String = "You got the {item}."
var dialog_responce_d: String = "You tossed the {item}."
var option_count: int = 2
var enabled = false
#@export_enum("consumeable", "weapon", "armor", "dialog") var option_type


func _ready():
	self.visible = false
	SignalManager.activate_choose_option.connect(_activate_choose_option)

func _activate_choose_option():
	
	enabled = true
	player_soul.visible = false
	match option_count:
		2:
			option_a.focus_mode = FOCUS_ALL
			option_b.focus_mode = FOCUS_ALL
		3:
			option_a.focus_mode = FOCUS_ALL
			option_b.focus_mode = FOCUS_ALL
			option_c.focus_mode = FOCUS_ALL
		4:
			option_a.focus_mode = FOCUS_ALL
			option_b.focus_mode = FOCUS_ALL
			option_c.focus_mode = FOCUS_ALL
			option_d.focus_mode = FOCUS_ALL
			
	match GlobalFlags.choice_prompt_function:
		0:
			GlobalFlags.text_swaper["action_ph"] = "Consume"
			SignalManager.inv_updated.emit()
			textbox_control.speech_n_face_ider(["default1"], ["none"], [0])
			textbox_control.start_dialog(false, [dialog_question])
		1:
			GlobalFlags.text_swaper["action_ph"] = "Take"
			SignalManager.inv_updated.emit()
			textbox_control.speech_n_face_ider(["default1"], ["none"], [0])
			textbox_control.start_dialog(false, [dialog_question])
		2:
			GlobalFlags.text_swaper["action_ph"] = "Toss"
			SignalManager.inv_updated.emit()
			textbox_control.speech_n_face_ider(["default1"], ["none"], [0])
			textbox_control.start_dialog(false, [dialog_question])
	
func _on_textbox_control_finished_dispo():
	if enabled == true:
		self.visible = true
		player_soul.visible = true
		match option_count:
			2:
				option_a.visible = true
				option_b.visible = true
			3:
				option_a.visible = true
				option_b.visible = true
				option_c.visible = true
			4:
				option_a.visible = true
				option_b.visible = true
				option_c.visible = true
				option_d.visible = true
		option_a.call_deferred("grab_focus")

func _option_chosen(option_selected: int):
	GlobalFlags.enable_choice_prompt = false
	
	match option_selected:
		1:
			option_1()
		2:
			option_2()
		3:
			option_3()
		4:
			option_4()
			
func option_1():
	match GlobalFlags.choice_prompt_function:
		0:
			item_type()
			print("option_1 0")
		1:
			obtain_item()
			
		2:
			toss_item()

func option_2():
	match GlobalFlags.choice_prompt_function:
		0:
			_close_choose_option()
		1:
			_close_choose_option()
		2:
			_close_choose_option()

func option_3():
	pass
	
func option_4():
	pass

func obtain_item():
	print("option_1 1")
	PlayerData.add_item(ItemTable.item_loaded_string)
	_close_choose_option()
	textbox_control.speech_n_face_ider(["default1"], ["none"], [0])
	textbox_control.start_dialog(false, [dialog_responce_c])
	GlobalFlags.text_box_open = true

func toss_item():
	var index = GlobalFlags.item_transit
	if index == null:
		print("Item to remove not found")
	else:
		var item = PlayerData.inventory.find(GlobalFlags.item_transit)
		_close_choose_option()
		textbox_control.speech_n_face_ider(["default1"], ["none"], [0])
		textbox_control.start_dialog(false, [dialog_responce_d])
		GlobalFlags.text_box_open = true
		PlayerData.remove_item(item)

func item_type():
	var index = GlobalFlags.item_transit
	if index == null:
		print("Item to remove not found")
	else:
		if index is Consumable:
			var item = PlayerData.inventory.find(GlobalFlags.item_transit)
			_close_choose_option()
			GlobalFlags.text_swaper["itemHP"] = str(GlobalFlags.item_transit.health_restore, " HP")
			textbox_control.speech_n_face_ider(["default1"], ["none"], [0])
			if PlayerData.current_hp + GlobalFlags.item_transit.health_restore < PlayerData.max_hp:
				textbox_control.start_dialog(false, [dialog_responce_a])
			elif PlayerData.current_hp + GlobalFlags.item_transit.health_restore >= PlayerData.max_hp:
				textbox_control.start_dialog(false, [dialog_responce_b])
			GlobalFlags.text_box_open = true
			GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_swallow.wav")
			GlobalFlags.sfx_1_channel.play()
			
			PlayerData.health_change(GlobalFlags.item_transit.health_restore)
			PlayerData.remove_item(item)
		else:
			print("no type set")

func _close_choose_option():
	option_a.visible = false
	option_b.visible = false
	option_c.visible = false
	option_d.visible = false
	
	enabled = false
	option_a.focus_mode = FOCUS_NONE
	option_b.focus_mode = FOCUS_NONE
	option_c.focus_mode = FOCUS_NONE
	option_d.focus_mode = FOCUS_NONE
	textbox_control.close_dialog_box()
	if GlobalFlags.menu_layer == 3:
		GlobalFlags.set_deferred("menu_layer", 2)
	else:
		player_soul.visible = false
	SignalManager.closed_choose_option.emit()
	await get_tree().process_frame
