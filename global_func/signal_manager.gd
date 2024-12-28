extends Node

#To toggle player controls during dialog or cutscenes
signal lockWasd()

signal unlockWasd()

signal lockMenu()

signal unlockMenu()

#Used to set game state and when its changing.
signal overworld_mode()

signal world_transition_mode()

signal battle_mode()

#For room transition states
signal fade_in_finished()
