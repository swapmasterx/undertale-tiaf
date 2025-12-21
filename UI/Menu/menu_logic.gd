extends Control

@onready var sub_menu = $sub_menu
@onready var canvas_layer = $".."

@onready var item = $"main_menu/uibackdrop/MarginContainer/VBoxContainer/Item"
@onready var stat = $"main_menu/uibackdrop/MarginContainer/VBoxContainer/Stat"
@onready var magic = $"main_menu/uibackdrop/MarginContainer/VBoxContainer/Magic"
@onready var options = $"main_menu/uibackdrop/MarginContainer/VBoxContainer/Options"
@onready var tab_container = $sub_menu/uibackdrop2/MarginContainer/TabContainer
#@onready var test_button = $"sub_menu/uibackdrop2/MarginContainer/TabContainer/items/item_list/test_button"
@onready var player_soul = $"../player_soul"
@onready var save_box = $"../save_box"



var menu_option_memory

func _ready():
	SignalManager.soul_cursor_visible.emit(false)
	self.visible = false
	menu_option_memory = item
	
	

func _input(event):
	if GlobalFlags.is_saving == false:
		if event.is_action_pressed("menu") && GlobalFlags.menu_lock == false:
			
			SignalManager.inv_updated.emit()
			menu_flag_handler()
		
		if GlobalFlags.text_box_open == false && GlobalFlags.use_or_toss == true && event.is_action_pressed("back_cancel") && GlobalFlags.menu_layer == 3:
		
			SignalManager.closed_choose_option.emit()
			GlobalFlags.set_deferred("menu_layer", 2)
		
		if GlobalFlags.text_box_open == false && event.is_action_pressed("back_cancel") && GlobalFlags.menu_layer == 2 :
			item.focus_mode = FOCUS_ALL
			stat.focus_mode = FOCUS_ALL
			magic.focus_mode = FOCUS_ALL
			options.focus_mode = FOCUS_ALL
			menu_option_memory.grab_focus()
			SignalManager.inv_updated.emit()
			sub_menu.visible = false
			GlobalFlags.menu_layer = 1
			GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_squeakfix.wav")
			GlobalFlags.sfx_1_channel.play()
		
func menu_flag_handler():
	SignalManager.inv_updated.emit()
	GlobalFlags.menu_active = true
	match GlobalFlags.menu_layer:
		0:
			GlobalFlags.blockInteraction = true
			GlobalFlags.wasd_lock = true
			SignalManager.lockWasd.emit()
			self.visible = true
			
			SignalManager.soul_cursor_visible.emit(true)
			
			item.focus_mode = FOCUS_ALL
			stat.focus_mode = FOCUS_ALL
			magic.focus_mode = FOCUS_ALL
			options.focus_mode = FOCUS_ALL
			
			GlobalFlags.menu_layer = 1
			GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_squeakfix.wav")
			GlobalFlags.sfx_1_channel.play()
			menu_option_memory.call_deferred("grab_focus")
		1:
			sub_menu.visible = false
			self.visible = false
			SignalManager.soul_cursor_visible.emit(false)
			GlobalFlags.blockInteraction = false
			GlobalFlags.wasd_lock = false
			GlobalFlags.menu_active = false
			GlobalFlags.menu_layer = 0
			GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_squeakfix.wav")
			GlobalFlags.sfx_1_channel.play()
		_:
			return
		
func _on_item_pressed():
	GlobalFlags.options_mode = false
	menu_option_memory = item
	GlobalFlags.choice_prompt_function = 0
	var test_button = $"sub_menu/uibackdrop2/MarginContainer/TabContainer/items/item_list/test_button"
	if test_button == null:
		GlobalFlags.menu_layer = 0
		GlobalFlags.options_mode = true
		GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_victor.wav")
		GlobalFlags.sfx_2_channel.play()
		
		menu_flag_handler()
		return
		
	test_button.grab_focus()
	enable_submenu(0)
	player_soul.global_position = Vector2(387,117.5)

func _on_stat_pressed():
	menu_option_memory = stat
	enable_submenu(1)

func _on_magic_pressed():
	menu_option_memory = magic
	enable_submenu(2)
	
func _on_options_pressed():
	var master = $sub_menu/uibackdrop2/MarginContainer/TabContainer/options/VBoxContainer/Master
	if master == null:
		return
	enable_submenu(3)
	master.call_deferred("grab_focus")
	menu_option_memory = options
	
func enable_submenu(tab_num):
	GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_select.wav")
	GlobalFlags.sfx_1_channel.play()
	GlobalFlags.menu_layer = 2
	tab_container.current_tab = tab_num
	sub_menu.visible = true
	item.focus_mode = FOCUS_NONE
	stat.focus_mode = FOCUS_NONE
	magic.focus_mode = FOCUS_NONE
	options.focus_mode = FOCUS_NONE

#-------------------------
