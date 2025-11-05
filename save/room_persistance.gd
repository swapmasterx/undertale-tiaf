extends Node


const save_file_name: String = "user://fileP.json"

const default_save_file: Dictionary = {"opening_cutscene_played": false,
"first_puzzle": false, "switch_puzzle" : false,
"candy_counter": 0, "save_question": false, "spike_question": false, "other_flower_cutscene": false}

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
	load_the_game()
	
func load_the_game():
	var dict: Dictionary = load_game()
	first_puzzle = dict["first_puzzle"]
	switch_puzzle = dict["switch_puzzle"]
	candy_counter = dict["candy_counter"]
	opening_cutscene = dict["opening_cutscene_played"]
	save_question = dict["save_question"]
	spike_question = dict["spike_question"]
	other_flower_cutscene = dict["other_flower_cutscene"]

#room persistancy

var opening_cutscene = false

var first_puzzle = false

var switch_puzzle = false

var candy_counter: int = 0

var save_question = false

var spike_question = false

var other_flower_cutscene = false
