extends Node

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	lockWasd.connect(lockWASD)
	enter_overworld_hazard.connect(enter_overworld_hazard_func)
	exit_overworld_hazard.connect(exit_overworld_hazard_func)



signal inv_updated()

#Signals game state changes
signal changed_game_state()

#To toggle player controls during dialog or cutscenes
signal lockWasd()

func lockWASD():
	GlobalFlags.wasd_lock = true 
	player.direction = Vector2(0,0)

signal unlockWasd()

signal lockMenu()

signal unlockMenu()

signal startCutscene()

signal endCutscene()

#Used to set state for overworld attacks
signal enter_overworld_hazard()

func enter_overworld_hazard_func():
	GlobalFlags.menu_lock = true
	GlobalFlags.overworld_hazard = true

signal exit_overworld_hazard()

func exit_overworld_hazard_func():
	GlobalFlags.menu_lock = false
	GlobalFlags.overworld_hazard = false
	delete_player_tracking_hazard.emit()

signal delete_player_tracking_hazard()
#tells the game that you got hurt
signal damaged()

#Used to set game state and when its changing.
signal overworld_to_battle(int)

signal battle_loaded()

signal fake_world_transition_mode()

#menu signals
signal activate_choose_option()

signal use_or_toss()

signal closed_choose_option()

signal closed_dialog()

signal save_activate()

signal get_item()

#switch/button signal
signal switchpuzzle()

signal switchon(int)

signal switchoff(int)

#used to make talk sprites and applicable overworld sprites animate during dialogue
signal character_talking(int, bool)

#used to tell when a save point box has been closed
signal saved_menu_closed
