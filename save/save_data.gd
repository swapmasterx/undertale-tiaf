extends Node

var current_room = "res://stages/ruins/dev_test_2.tscn"

const save_file_name: String = "user://file0.json"

const default_save_file: Dictionary = {"current_hp": 30, "max_hp": 30, "LV": 1, "EXP": 0, 
"attack": 10, "defence": 10, "gold": 0, "equip_weapon": "none", "equip_armor": "none", 
"fallen_name": "------", "room_num": "res://stages/ruins/dev_test_2.tscn", "place_at_x": 0, "place_at_y": 0,
"inventory": []}

func save_game(data: Dictionary) -> void:
	var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.WRITE)
	if save_file == null:
		push_error("Error opening save data")
		return
	var string_data: String = JSON.stringify(data)
	save_file.store_line(string_data)
	save_file.close()
	
func load_game() -> Dictionary:
	if FileAccess.file_exists(save_file_name):
		var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.READ)
		if save_file == null:
			push_error("Error reading save data")
		var json = JSON.new()
		
		var string_data: String = save_file.get_line()
		if json.parse(string_data) == OK:
			var data: Dictionary = json.get_data()
			save_file.close()
			SignalManager.inv_updated.emit()
			return data
		push_error("Error, save data is not organized as expected.")
	return default_save_file
