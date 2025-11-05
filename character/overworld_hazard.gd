extends Control

@onready var player_soul = $"../player_soul"

func _ready():
	self.visible = false
	SignalManager.enter_overworld_hazard.connect(enter_overworld_hazard)
	SignalManager.exit_overworld_hazard.connect(exit_overworld_hazard)

func enter_overworld_hazard():
	self.visible = true

func exit_overworld_hazard():
	self.visible = false
