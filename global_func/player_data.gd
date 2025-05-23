extends Node2D

var a = load("res://items/repo/test_heal.tres")
var b = load("res://items/repo/test_heal2.tres")

var current_hp: int = 1

var max_hp: int = 30

var LV: int = 1

var EXP: int = 0

var attack: float = 10

var defence: float = 10

var gold: int = 0

var equip_weapon: String = "none"

var equip_armor: String = "none"

var fallen_name: String = "Chara"

var room_num: String 

var x

var y

var place_at: Vector2 = Vector2(0,0)

var place_at_room_transition: Vector2 = Vector2(0,0)

var inventory: Array = [a, b, a]

func _ready():
	var dict: Dictionary = SaveData.load_game()
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
	GlobalFlags.text_swaper["fallen_name"] = fallen_name
	SaveData.current_room = dict["room_num"]
	x = dict["place_at_x"]
	y = dict["place_at_y"]
	place_at = Vector2(x,y)
	GlobalFlags.text_swaper["place_at"] = place_at
	inventory = dict["inventory"]
	GlobalFlags.text_swaper["inventory"] = inventory
	

func add_item(inv_item):
	if inventory.size() < 8:
		inventory.append(inv_item)
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
	if hp_value >= 0:
		if current_hp + hp_value >= max_hp:
			current_hp = max_hp
		else:
			current_hp += hp_value
		GlobalFlags.text_swaper["HPcur"] = current_hp
		SignalManager.inv_updated.emit()
		await get_tree().create_timer(0.2).timeout
		GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_heal_c.wav")
		GlobalFlags.sfx_2_channel.play()
	elif hp_value < 0:
		pass

func _exit_tree():
	SaveData.save_game({"current_hp": current_hp, "max_hp": max_hp, "LV": LV, "EXP": EXP, 
"attack": attack, "defence": defence, "gold": gold, "equip_weapon": equip_weapon, "equip_armor": equip_armor, 
"fallen_name": fallen_name, "room_num": SaveData.current_room, "place_at_x": x, "place_at_y": y, "inventory": inventory})
