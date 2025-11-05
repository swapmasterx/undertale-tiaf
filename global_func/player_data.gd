extends Node2D

var load_at_point: int = 0

var current_hp: int = 1

var max_hp: int = 30

var LV: int = 1

var EXP: int = 0

var attack: float = 10

var defence: float = 10

var gold: int = 0

var inv_frames: float = 1.0

var is_inv: bool = false

var equip_weapon: String = "none"

var equip_armor: String = "none"

var fallen_name: String = "------"

var room_num: String 

var x

var y

var place_at: Vector2 = Vector2(0,0)

var place_at_room_transition: Vector2 = Vector2(0,0)

var inventory: Array = []

var master_volume: float
var sfx_volume: float
var music_volume: float

func _ready():
	load_the_game()
	SignalManager.damaged.connect(on_damaged)

func load_the_game():
	var dict: Dictionary = SaveData.load_game()
	master_volume = dict["master_volume"]
	sfx_volume = dict["sfx_volume"]
	music_volume = dict["music_volume"]
	GlobalFlags.HasSaved = dict["has_saved"]
	current_hp = dict["current_hp"]
	GlobalFlags.text_swaper["HPcur"] = current_hp
	max_hp = dict["max_hp"]
	GlobalFlags.text_swaper["max_hp"] = max_hp
	LV = dict["LV"]
	GlobalFlags.text_swaper["LV"] = LV
	EXP = dict["EXP"]
	GlobalFlags.text_swaper["EXP"] = EXP
	attack = dict["attack"]
	GlobalFlags.text_swaper["attack"] = attack
	defence = dict["defence"]
	GlobalFlags.text_swaper["defence"] = defence
	gold = dict["gold"]
	GlobalFlags.text_swaper["gold"] = gold
	equip_weapon = dict["equip_weapon"]
	GlobalFlags.text_swaper["equip_weapon"] = equip_weapon
	equip_armor = dict["equip_armor"]
	GlobalFlags.text_swaper["equip_armor"] = equip_armor
	fallen_name = dict["fallen_name"]
	GlobalFlags.text_swaper["name"] = fallen_name
	SaveData.current_room = dict["room_num"]
	x = dict["place_at_x"]
	y = dict["place_at_y"]
	place_at = Vector2(x,y)
	GlobalFlags.text_swaper["place_at"] = place_at
	inventory = dict["inventory"]
	GlobalFlags.text_swaper["inventory"] = inventory
	GlobalFlags.roomname = dict["room_name"]
	GlobalFlags.text_swaper["roomname"] = GlobalFlags.roomname
	
	

func add_item(inv_item):
	SignalManager.get_item.emit()
	print("item added")
	if inventory.size() < 8:
		inventory.append(inv_item)
		await get_tree().process_frame
		SignalManager.inv_updated.emit()
	else:
		print("But your inventory was full.")
		return
	
		
func remove_item(item_removed):
	if inventory.size() > 0:
		inventory.remove_at(item_removed)
		SignalManager.inv_updated.emit()
	else:
		print("But your inventory was empty.")
		return
		
func health_change(hp_value):
	if hp_value > 0:
		hp_math(hp_value)
		GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_heal_c.wav")
		GlobalFlags.sfx_2_channel.play()
	elif hp_value < 0 && is_inv == false:
		hp_math(hp_value)
		SignalManager.damaged.emit()
		GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_hurt1.wav")
		GlobalFlags.sfx_2_channel.play()
	
	

func hp_math(hp_value):
	if current_hp + hp_value >= max_hp:
		current_hp = max_hp
	else:
		current_hp += hp_value
	GlobalFlags.text_swaper["HPcur"] = current_hp
	SignalManager.inv_updated.emit()
	
func on_damaged():
	is_inv = true
	await get_tree().create_timer(inv_frames).timeout
	is_inv = false

func _exit_tree():
	load_at_point = 0
