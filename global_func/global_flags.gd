extends Node2D

@export var dev_mode = false

var dialogMode: bool = false

# Set both scroll modes to true for small rooms to fix the camera

# Set to true to lock the camera's vertical movement, like horizontal halls.
# This should be set by the room upon loading into it, not from the character object itself.
var sideScrollMode: bool = true

# Set to true to lock the camera's horizontal movement, like vertical halls.
# This should be set by the room upon loading into it, not from the character object itself.
var veticalScrollMode: bool = false

var room_changing: bool = false
