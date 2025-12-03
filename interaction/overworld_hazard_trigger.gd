extends Node2D

@export var is_exit_hazard: bool = false
@export var load_trigger_area: LoadTriggerArea
@export var player_tracking_hazard: int = 0
@export var is_chase: bool = false

func _ready():
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		load_trigger_area.interact = Callable(self, "_on_interact")
		
func _on_interact():
	if is_exit_hazard == false:
		PlayerData.overworld_hazard_type = player_tracking_hazard
		PlayerData.chase_sequence = is_chase
		SignalManager.enter_overworld_hazard.emit()
	elif is_exit_hazard == true:
		PlayerData.overworld_hazard_type = 0
		PlayerData.chase_sequence = false
		SignalManager.exit_overworld_hazard.emit()
