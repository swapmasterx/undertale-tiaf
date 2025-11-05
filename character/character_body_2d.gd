extends CharacterBody2D

# Set by the player if they want to sprint with the key is heald or if they want to toggle it on and off.
@export var sprintToggleMode = true
@export var anim_tree: AnimationTree
@export var anim_player: AnimationPlayer
var SPEED = 400.0
var direction
var playback : AnimationNodeStateMachinePlayback
# Sprint status
var sprintActive = false
@onready var quit = $Camera2D/CanvasLayer/item_discription


func _ready():
	playback = anim_tree["parameters/playback"]

func _process(delta):
	if Input.is_action_pressed("quit"):
		quit.active_quit()
		await get_tree().create_timer(2.5).timeout
		if Input.is_action_pressed("quit"):
			get_tree().quit()
		else:
			pass
	else:
		quit.abort_quit()

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	if GlobalFlags.wasd_lock == false:
		direction = Input.get_vector("left", "right","up","down")
	else:
		playback.travel("idel")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	select_anim()
	update_animation_perams()

func select_anim():
	if direction == Vector2.ZERO:
		playback.travel("idel")
	else:
		playback.travel("walk")

func update_animation_perams():
	if direction == Vector2.ZERO:
		return
	anim_tree["parameters/idel/blend_position"] = direction
	anim_tree["parameters/walk/blend_position"] = direction

func _input(event):
	if GlobalFlags.sprint_enabled == true:
		if Input.is_action_just_pressed("sprint") and sprintActive == true:
			SPEED = 400
			sprintActive = false
		elif Input.is_action_just_pressed("sprint") and sprintActive == false:
			SPEED = 600
			sprintActive = true

#func animspeed(veloc):
	#pass
