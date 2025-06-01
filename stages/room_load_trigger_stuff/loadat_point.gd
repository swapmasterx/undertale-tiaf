extends Node2D



@export var placepoint: int = 0

func _ready():
	await self.ready
	var get_player = get_tree().get_first_node_in_group("player")
	if PlayerData.load_at_point == placepoint:
		get_player.position = self.position
