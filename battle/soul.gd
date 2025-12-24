extends CharacterBody2D

@onready var battlestate = %BattleState

const SLOW_SPEED = 120.0
const SPEED = 240.0

func _physics_process(_delta:float)->void:
	if(battlestate.state != BattleState.State.BULLETHELL): return
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"))
	velocity = (SLOW_SPEED if(Input.is_action_pressed("back_cancel"))else SPEED) * direction
	move_and_slide()
