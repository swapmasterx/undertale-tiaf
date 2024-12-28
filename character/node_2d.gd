extends Area2D

@onready var player = $"../CharacterBody2D"

@export var SPEED = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, player.position, SPEED*delta)
