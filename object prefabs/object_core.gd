extends Node2D

class_name ObjectCore

#0 = unset, 1 = text interactible, 2 = room load trigger
@export_enum("Unset", "Textbox", "SavePoint") var object_type: int
@export var interaction_area: InteractionArea
#@export var text_handler: DialogHandler
@export var dialog_data: DialogData
@onready var text_handlerr = $"../../../DialogHandler"


var interact_counter: int = 0
@export var max_interact: int = 1

func _ready():
	if interaction_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		interaction_area.interact = Callable(self, "_on_interact")
		print(interaction_area.interact)

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

func text_interact():
	print(GlobalFlags.dialogMode)
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data.dialog_set[interact_counter]
		text_handlerr.speech_id = dialog_data.speech_noise_id[interact_counter]
		text_handlerr.char_talk_sprite_id = dialog_data.char_talk_sprite_id[interact_counter]
		#text_handler.char_mood_sprite_id = speech[interact_counter]
		text_handlerr.on_interact()
		if interact_counter < max_interact:
			interact_counter += 1
		
		
	elif GlobalFlags.dialogMode == false:
		print("No dialog handler attached to ", self )

func save_point():
	
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
	
	SaveData.save_game({"current_hp": PlayerData.current_hp, "max_hp": PlayerData.max_hp,
	"LV": PlayerData.LV, "EXP": PlayerData.EXP, "attack": PlayerData.attack, "defence": PlayerData.defence,
	"gold": PlayerData.gold, "equip_weapon": PlayerData.equip_weapon, "equip_armor": PlayerData.equip_armor,
	"fallen_name": PlayerData.fallen_name, "room_num": SaveData.current_room,
	"place_at_x": PlayerData.x, "place_at_y": PlayerData.y, "inventory": PlayerData.inventory})
