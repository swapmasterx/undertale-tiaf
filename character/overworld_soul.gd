extends Sprite2D

@onready var character_body_2d = $"../../.."
@onready var overworld_soul_layer = $".."

func _ready():
	SignalManager.enter_overworld_hazard.connect(enter_overworld_hazard)
	SignalManager.exit_overworld_hazard.connect(exit_overworld_hazard)

func enter_overworld_hazard():
	overworld_soul_layer.visible = true

func exit_overworld_hazard():
	overworld_soul_layer.visible = false

func _physics_process(delta):
	self.global_position = Vector2(character_body_2d.global_position)+Vector2(0,-50)
