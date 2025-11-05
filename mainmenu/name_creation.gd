extends Control

@onready var nameEntry = $MarginContainer/VBoxContainer/nameEntry
var nameClean
var nameArray = []
var letter = "A"

func _ready():
	SignalManager.inv_updated.connect(addLetter)
	
	
func addLetter():
	if nameArray.size() <= 5:
		nameArray.append(letter)
	var s = array_to_string(nameArray)
	nameEntry.text = s
	nameClean = s
func array_to_string(namearr: Array) -> String:
	var s = ""
	for i in namearr:
		s += str(i)
	return s

func _on_back_space_pressed():
	if nameArray.size() >= 1:
		nameArray.pop_back()
		var s = array_to_string(nameArray)
		nameEntry.text = s
		nameClean = s
