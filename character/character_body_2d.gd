extends CharacterBody2D

# Set by the player if they want to sprint with the key is heald or if they want to toggle it on and off.
@export var sprintToggleMode = true
@export var anim_tree: AnimationTree


var SPEED = 400.0
var direction
var playback : AnimationNodeStateMachinePlayback
# Sprint status
var sprintActive = false
var slowWalk = false

func _ready():
	playback = anim_tree["parameters/playback"]

func _process(delta):
	if Input.is_action_pressed("quit"):
		await get_tree().create_timer(2.5).timeout
		if Input.is_action_pressed("quit"):
			get_tree().quit()
		else:
			pass

func _physics_process(delta):
	
	direction = Input.get_vector("left", "right","up","down")
	# Get the input direction and handle the movement/deceleration.
	if GlobalFlags.wasd_lock == false:
		sprintToggle()
		if sprintActive == true:
			SPEED = 600
		elif sprintActive == false:
			SPEED = 400
			
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		move_and_slide()
		select_anim()
		update_animation_perams()
	else:
		velocity.x = 0
		velocity.y = 0
		playback.travel("idel")
	

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

func sprintToggle():
	if  Input.is_action_pressed("slow_walk") and sprintActive == false:
		sprintActive = false
		SPEED = 200
		
	if sprintToggleMode == true:
		if Input.is_action_just_pressed("sprint") and sprintActive == false:
			sprintActive = true
		elif Input.is_action_just_pressed("sprint") and sprintActive == true:
			sprintActive = false
			
	if sprintToggleMode == false:
		if Input.is_action_pressed("sprint"):
			sprintActive = true
		else:
			sprintActive = false
