extends CharacterBody2D


var SPEED = 400.0

# Set by the player if they want to sprint with the key is heald or if they want to toggle it on and off.
@export var sprintToggleMode = true

#Locks wasd and menu open respectfully 
var movementLock = false
var menuLock = false

# Sprint status
var sprintActive = false

func _ready():
	SignalManager.lockMenu.connect(_on_lock_menu)
	SignalManager.unlockMenu.connect(_on_unlock_menu)
	SignalManager.lockWasd.connect(_on_lock_wasd)
	SignalManager.unlockWasd.connect(_on_unlock_wasd)

func _process(delta):
	if Input.is_action_pressed("quit"):
		await get_tree().create_timer(2.5).timeout
		if Input.is_action_pressed("quit"):
			get_tree().quit()
		else:
			pass

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	if movementLock == false:
		var direction = Input.get_vector("left", "right","up","down")
		sprintToggle()
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func sprintToggle():
	
	if sprintToggleMode == true:
		if Input.is_action_just_pressed("sprint") and sprintActive == false:
			SPEED = 600
			sprintActive = true
		elif Input.is_action_just_pressed("sprint") and sprintActive == true:
			SPEED = 400
			sprintActive = false
			
	if sprintToggleMode == false:
		if Input.is_action_pressed("sprint"):
			SPEED = 600
			sprintActive = true
		else:
			SPEED = 400
			sprintActive = false


func open_close_menu():
	if menuLock == false:
		pass

func _on_lock_menu():
	menuLock = true


func _on_lock_wasd():
	movementLock = true


func _on_unlock_menu():
	menuLock = false


func _on_unlock_wasd():
	movementLock = false
