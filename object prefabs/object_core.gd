extends Node2D

class_name ObjectCore

#0 = unset, 1 = text interactible, 2 = room load trigger
@export_enum("Unset", "Textbox", "SavePoint", "Switch") var object_type: int
@export var interaction_area: InteractionArea
@export var load_trigger_area: LoadTriggerArea
#@export var text_handler: DialogHandler
@export var dialog_data: DialogData
@onready var text_handlerr = $"../../../DialogHandler"
@export var itempointer: String

var interact_counter: int = 0
@export var max_interact: int = 1

@export var switch_state: bool = false

@export var on_texture: Texture

@export var off_texture: Texture 

@export_enum("ConsumeItem", "ObtainItem", "DiscardItem", "DialogueBranch") var choice_prompt_type: int

@export var enable_choice_prompt: bool = false

@export var sprite: Sprite2D

func _ready():
	if interaction_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		interaction_area.interact = Callable(self, "_on_interact")
		print(interaction_area.interact)
		if object_type == 3:
			
			await self.ready
			sprite.texture = off_texture
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		load_trigger_area.interact = Callable(self, "_on_interact")

func _on_interact():
	
	if GlobalFlags.blockInteraction == false:
		print("interacted")
		match object_type:
			0:
				print("Object type of ", self, " is unset.")
			1: 
				text_interact()
			2: 
				save_point()
			3: 
				switch()

func text_interact():
	print(GlobalFlags.dialogMode)
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data.dialog_set[interact_counter]
		text_handlerr.speech_id = dialog_data.speech_noise_id[interact_counter]
		text_handlerr.char_talk_sprite_id = dialog_data.char_talk_sprite_id[interact_counter]
		#text_handler.char_mood_sprite_id = speech[interact_counter]
		text_handlerr.on_interact()
		GlobalFlags.enable_choice_prompt = false
		
		if enable_choice_prompt:
			GlobalFlags.enable_choice_prompt = true
			ItemTable.item_loaded_string = itempointer
			ItemTable.load_item(itempointer)
			var item = ItemTable.item_loaded
			
			GlobalFlags.item_transit = item
			GlobalFlags.text_swaper["item"] = item.item_name
			GlobalFlags.choice_prompt_function = choice_prompt_type
			
			
		if interact_counter < max_interact:
			interact_counter += 1
		
		
	elif GlobalFlags.dialogMode == false:
		print("No dialog handler attached to ", self )

func save_point():
	
	if GlobalFlags.is_saving == false:
		if text_handlerr && GlobalFlags.dialogMode == false:
			PlayerData.health_change(999)
			GlobalFlags.is_saving = true
			text_handlerr.dialog = dialog_data.dialog_set[interact_counter]
			text_handlerr.speech_id = dialog_data.speech_noise_id[interact_counter]
			text_handlerr.char_talk_sprite_id = dialog_data.char_talk_sprite_id[interact_counter]
			#text_handler.char_mood_sprite_id = speech[interact_counter]
			text_handlerr.on_interact()
			if interact_counter < max_interact:
				interact_counter += 1
	
	
func switch():
	if switch_state == false:
		sprite.texture = on_texture
		switch_state = true
		GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_switchpull_n.wav")
		GlobalFlags.sfx_1_channel.play()
		SignalManager.switchpuzzle.emit()
	else:
		sprite.texture = off_texture
		switch_state = false
		GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_test.wav")
		GlobalFlags.sfx_1_channel.play()
	#print("touched the lever ", switch_state)
