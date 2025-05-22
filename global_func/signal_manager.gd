extends Node

signal inv_updated()

#To toggle player controls during dialog or cutscenes
signal lockWasd()

signal unlockWasd()

signal lockMenu()

signal unlockMenu()

#Used to set game state and when its changing.
signal overworld_mode()

signal world_transition_mode()

signal fake_world_transition_mode()

signal battle_mode()

#menu signals
signal activate_choose_option()

signal closed_choose_option()
