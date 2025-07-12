extends Node2D

#class_name DialogHandler

@onready var textbox_control = null

var use_cinima_mode: bool = false
var skipable: bool = true


var dialog: Array = []
var speech_id: Array = ["default1","default1"]
var char_talk_sprite_id: Array = [0,0]
var char_mood_sprite_id: Array = [0,0]


func on_interact():
	# This is a stupid dumb hack that shouldn't have worked but godot has let me win because i am super smart and sexy ~ ChrisFurry
	if(not is_instance_valid(textbox_control)): textbox_control = Player.this_node.get_node("Camera2D/CanvasLayer/Textbox Control")
	if GlobalFlags.dialogMode == false:
		textbox_control.speech_n_face_ider(speech_id, char_talk_sprite_id, char_mood_sprite_id)
		textbox_control.start_dialog(use_cinima_mode, dialog)
