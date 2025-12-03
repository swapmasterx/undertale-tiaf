extends Node2D

func _ready():
	SignalManager.delete_player_tracking_hazard.connect(delete_player_tracking_hazard)
	
func delete_player_tracking_hazard():
	self.queue_free()
