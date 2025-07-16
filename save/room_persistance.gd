extends Node


const save_file_name: String = "user://fileP.json"

const default_save_file: Dictionary = {"first_puzzle": false, "switch_puzzle" : false}

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
	
func _ready():
	var dict: Dictionary = load_game()
	first_puzzle = dict["first_puzzle"]
	switch_puzzle = dict["switch_puzzle"]

#room persistancy

var first_puzzle = false

var switch_puzzle = false
