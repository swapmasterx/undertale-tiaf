extends Node2D

@export var interaction_area: InteractionArea
@export var load_trigger_area: LoadTriggerArea
@onready var walking_comment = $".."
@export_enum("opening_cutscene", "save_question", "spike_question") var save_flag: int

func _ready():
	match save_flag:
		0:
			if RoomPersistance.opening_cutscene == true:
				walking_comment.queue_free()
		1:
			if RoomPersistance.save_question == true:
				walking_comment.queue_free()
		2:
			if RoomPersistance.spike_question == true:
				walking_comment.queue_free()
		
	if interaction_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		interaction_area.interact = Callable(self, "_on_interact")
		print(interaction_area.interact)
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		load_trigger_area.interact = Callable(self, "_on_interact")

func _on_interact():
	
	match save_flag:
		0:
			RoomPersistance.opening_cutscene = true
		1:
			
			RoomPersistance.save_question = true
		2:
			
			RoomPersistance.spike_question = true
	
	walking_comment.queue_free()
