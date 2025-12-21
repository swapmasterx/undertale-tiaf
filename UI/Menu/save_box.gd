extends MarginContainer
var save_pressed = false
@onready var save = %save
@onready var cancel = %cancel
@onready var save_confirmation = %save_confirmation
@onready var item_discription = $uibackdrop2/MarginContainer/item_list/metrics/item_list/item_discription
@onready var item_discription_3 = $uibackdrop2/MarginContainer/item_list/item_discription3
@onready var item_discription_2 = $uibackdrop2/MarginContainer/item_list/metrics/item_list2/item_discription2
@onready var item_discription_4 = $uibackdrop2/MarginContainer/item_list/metrics/item_list3/item_discription_4
@onready var spacer_2 = $uibackdrop2/MarginContainer/item_list/metrics2/spacer2
@onready var spacer = $uibackdrop2/MarginContainer/item_list/metrics2/spacer

func _ready():
	SignalManager.closed_dialog.connect(closed_dialog)
	if GlobalFlags.HasSaved == false:
		item_discription.stat_line = "------"
		item_discription.text = "------"
	
	
func closed_dialog():
	if GlobalFlags.is_saving == true:
		GlobalFlags.text_swaper["name"] = PlayerData.fallen_name
		SignalManager.inv_updated.emit()
		save_confirmation.visible = false
		spacer_2.visible = true
		spacer.visible = true
		save.visible = true
		cancel.visible = true
		self.visible = true
		GlobalFlags.wasd_lock = true
		SignalManager.lockWasd.emit()
		SignalManager.soul_cursor_visible.emit(true)
		save.call_deferred("grab_focus")

func _on_save_pressed():
	if GlobalFlags.HasSaved == false:
		GlobalFlags.HasSaved = true
		item_discription.stat_line = "{name}"
		item_discription.text = "{name}"
	GlobalFlags.save()
	SignalManager.soul_cursor_visible.emit(false)
	save_pressed = true
	save_confirmation.visible = true
	save.visible = false
	cancel.visible = false
	spacer_2.visible = false
	spacer.visible = false
	GlobalFlags.text_swaper["roomname"] = GlobalFlags.roomname
	GlobalFlags.text_swaper["name"] = PlayerData.fallen_name
	
	item_discription.add_theme_color_override("default_color", Color(1.0, 1.0, 0.0, 1.0))
	item_discription_2.add_theme_color_override("default_color", Color(1, 1, 0))
	item_discription_3.add_theme_color_override("default_color", Color(1, 1, 0))
	item_discription_4.add_theme_color_override("default_color", Color(1, 1, 0))
	SignalManager.inv_updated.emit()
	

func _input(event):
	if save_pressed == true:
		if event.is_action_pressed("interact_confirm"):
			save_pressed = false
			close_save_box()

func _on_cancel_pressed():
	
	close_save_box()
	
func close_save_box():
	SignalManager.saved_menu_closed.emit()
	self.visible = false
	GlobalFlags.wasd_lock = false
	SignalManager.soul_cursor_visible.emit(false)
	await get_tree().create_timer(0.07).timeout
	GlobalFlags.is_saving = false
	item_discription.remove_theme_color_override("default_color")
	item_discription_2.remove_theme_color_override("default_color")
	item_discription_3.remove_theme_color_override("default_color")
	item_discription_4.remove_theme_color_override("default_color")
