extends Node2D

@export var dev_mode = false

@onready var sfx_1_channel = get_tree().get_first_node_in_group("sfx_1")

@onready var sfx_2_channel = get_tree().get_first_node_in_group("sfx_2")

@onready var music_channel = get_tree().get_first_node_in_group("music")

var battle_lineup: Array

var time_played: String = "00:00"

@onready var text_swaper = {"LVnum": PlayerData.LV, "HPcur": PlayerData.current_hp,
"HPmax": PlayerData.max_hp, "Gnum": PlayerData.gold, "PlayerATK": PlayerData.attack,
"PlayerDEF": PlayerData.defence, "name": PlayerData.fallen_name, "weapon": PlayerData.equip_weapon,
"armor": PlayerData.equip_armor,
"exp": PlayerData.EXP, "item": "test_heal", "action_ph": "Consume", 
"room_name": roomname, "time_played": time_played}

var roomname: String

var HasSaved: bool = false

var is_saving = false

#0 = overworld, 1 = battle, 2 = main menu
var game_state: int = 2

var sprint_enabled: bool = true

#Set true if a choice promt should appear when a set of text boxes are closed.
var enable_choice_prompt = false

#Sets the behaviour of how the multiple choice prompts operate
	#Set in Object core and
var choice_prompt_function: int

var item_transit = preload("res://items/repo/test_heal.tres")

var dialogMode: bool = false

var dialogDisabled: bool = false

var blockInteraction: bool = false

var overworld_lockdown: bool = false

var wasd_lock: bool = false

var menu_lock: bool = false

var menu_active: bool = false

var text_box_open: bool = false
# Set both scroll modes to true for small rooms to fix the camera

# Set to true to lock the camera's vertical movement, like horizontal halls.
# This should be set by the room upon loading into it, not from the character object itself.
var sideScrollMode: bool = true

# Set to true to lock the camera's horizontal movement, like vertical halls.
# This should be set by the room upon loading into it, not from the character object itself.
var veticalScrollMode: bool = false

var room_changing: bool = false

#enabled when text options are in play. Does not include battle buttons (Fight, act ect)
var options_mode: bool = false

# 0 = no menu, 1 = overworld c menu, 2 = overworld c menu after option has been selected
# 3 = selecting option box 

var menu_layer: int = 0

#Use to disable the option change sound when a button is selected to jump to it
var first_option_entry: bool = false

var use_or_toss: bool = false

var overworld_hazard: bool = false

func save():
	
	SaveData.save_game({"current_hp": PlayerData.current_hp, "max_hp": PlayerData.max_hp,
	"LV": PlayerData.LV, "EXP": PlayerData.EXP, "attack": PlayerData.attack, "defence": PlayerData.defence,
	"gold": PlayerData.gold, "equip_weapon": PlayerData.equip_weapon, "equip_armor": PlayerData.equip_armor,
	"fallen_name": PlayerData.fallen_name, "room_num": SaveData.current_room,
	"place_at_x": PlayerData.x, "place_at_y": PlayerData.y, "inventory": PlayerData.inventory,
	"room_name": roomname, "b": PlayerData.master_volume, "sfx_volume": PlayerData.sfx_volume, 
	"master_volume": PlayerData.master_volume, "music_volume": PlayerData.music_volume,
	"has_saved": HasSaved})
	
	RoomPersistance.save_game({"opening_cutscene_played": RoomPersistance.opening_cutscene,
	"first_puzzle": RoomPersistance.first_puzzle,
	"switch_puzzle" : RoomPersistance.switch_puzzle, "candy_counter": RoomPersistance.candy_counter,
	"save_question": RoomPersistance.save_question,
	"spike_question": RoomPersistance.spike_question,
	"other_flower_cutscene": RoomPersistance.other_flower_cutscene,
	"plot_value": RoomPersistance.plot_value})
var cutscene_active: bool = false

func cutscene_mode(on_or_off: bool):
	cutscene_active = on_or_off
	if on_or_off == true:
		blockInteraction = true
		wasd_lock = true
		SignalManager.lockWasd.emit()
		menu_lock = true
		
	if on_or_off == false:
		blockInteraction = false
		wasd_lock = false
		menu_lock = false
		
