extends Node2D

#class_name DialogHandler

@onready var textbox_control = $"../player/Camera2D/CanvasLayer/Textbox Control"

var use_cinima_mode: bool = false
var skipable: bool = true


var dialog: Array = []
var speech_id: Array = ["default1","default1"]
var char_talk_sprite_id: Array = [0,0]
var char_mood_sprite_id: Array = [0,0]


func on_interact():
	if GlobalFlags.dialogMode == false:
		textbox_control.speech_n_face_ider(speech_id, char_talk_sprite_id, char_mood_sprite_id)
		textbox_control.start_dialog(use_cinima_mode, dialog)
