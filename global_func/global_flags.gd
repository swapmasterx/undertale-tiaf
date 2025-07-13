extends Node2D

@export var dev_mode = false

@onready var sfx_1_channel = get_tree().get_first_node_in_group("sfx_1")

@onready var sfx_2_channel = get_tree().get_first_node_in_group("sfx_2")

@onready var music_channel = get_tree().get_first_node_in_group("music")

var roomname: String = "-------"

var time_played: String = "00:00"

@onready var text_swaper = {"LVnum": PlayerData.LV, "HPcur": PlayerData.current_hp,
"HPmax": PlayerData.max_hp, "Gnum": PlayerData.gold, "PlayerATK": PlayerData.attack,
"PlayerDEF": PlayerData.defence, "name": PlayerData.fallen_name, "weapon": PlayerData.equip_weapon,
"armor": PlayerData.equip_armor,
"exp": PlayerData.EXP, "item": item_transit.item_name, "action_ph": "Consume", 
"roomname": roomname, "time_played": time_played}

var is_saving = false

var item_transit = preload("res://items/repo/test_heal.tres")

var dialogMode: bool = false

var dialogDisabled: bool = false

var blockInteraction: bool = false

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

var set_battle_option: Array = ["fight", "act", "item", "mercy"]

var battle_lineup: Array = ["A", "B", ""]

var battle_acts: Array = ["a","b","c","d","e","f"]

var items: Array = []

# 0 = no menu, 1 = overworld c menu, 2 = overworld c menu after option has been selected
# 3 = selecting option box 

var menu_layer: int = 0

func save():
	
	SaveData.save_game({"current_hp": PlayerData.current_hp, "max_hp": PlayerData.max_hp,
	"LV": PlayerData.LV, "EXP": PlayerData.EXP, "attack": PlayerData.attack, "defence": PlayerData.defence,
	"gold": PlayerData.gold, "equip_weapon": PlayerData.equip_weapon, "equip_armor": PlayerData.equip_armor,
	"fallen_name": PlayerData.fallen_name, "room_num": SaveData.current_room,
	"place_at_x": PlayerData.x, "place_at_y": PlayerData.y, "inventory": PlayerData.inventory})
	

func cutscene_mode(on_or_off: bool):
	var cutscene_active:bool = false
	cutscene_active = on_or_off
	if cutscene_active == true:
		blockInteraction = true
		wasd_lock = true
		menu_lock = true
		
	if cutscene_active == false:
		blockInteraction = false
		wasd_lock = false
		menu_lock = false
		
