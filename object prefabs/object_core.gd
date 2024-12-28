extends Node2D

class_name ObjectCore

#0 = unset, 1 = text interactible
@export var object_type: int = 0
@export var interaction_area: InteractionArea
@export var text_handler: DialogHandler
@export var dialog_data: DialogData

var interact_counter: int = 0
@export var max_interact: int = 1

func _ready():
	if interaction_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	match object_type:
		0:
			print("Object type of ", self, " is unset.")
		1: 
			text_interact()

func text_interact():
	#picks the dialog set id in an array. If an object has different dialog on reinteraction there will be a
	#counter value that loops at the final line so as to not cause a crash from a null dialog set search.
	if GlobalFlags.dev_mode == true:
		print(self, " is text object.")
	if text_handler && GlobalFlags.dialogMode == false:
		
		#print(dialog_data.dialog[interact_counter])
		text_handler.dialog = dialog_data.dialog_set[interact_counter]
		text_handler.speech_id = dialog_data.speech_noise_id[interact_counter]
		text_handler.char_talk_sprite_id = dialog_data.char_talk_sprite_id[interact_counter]
		#text_handler.char_mood_sprite_id = speech[interact_counter]
		text_handler.on_interact()
		if interact_counter < max_interact:
			interact_counter += 1
			
	elif GlobalFlags.dialogMode == false:
		print("No dialog handler attached to ", self )
