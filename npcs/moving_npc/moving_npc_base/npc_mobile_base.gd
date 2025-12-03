extends CharacterBody2D

const SPEED = 400.0

@export_enum("none", "toriel", "sans", "papyrus", "undyne") var character: int
@export var anim_tree: AnimationTree
@export var anim_player: AnimationPlayer
@export var direction = Vector2(0,0)
var playback : AnimationNodeStateMachinePlayback
@export var state_of_mood: int = 0
var is_talking: bool = false
var is_backwards: bool = false

func _ready():
	playback = anim_tree["parameters/playback"]
	SignalManager.character_talking.connect(character_speak)

func _physics_process(delta):
	#direction = Input.get_vector("left", "right","up","down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	update_animation_perams()
	select_anim()

func character_speak(char_id, talking):
	if character == char_id:
		print(char_id)
		if talking == true:
			is_talking = true
		elif talking == false:
			is_talking = false

#used for testing npc face swaps
#func _input(event):
	#if Input.is_action_just_pressed("sprint"):
		#if state_of_mood == 0:
			#state_of_mood == 1
		#elif state_of_mood == 1:
			#state_of_mood == 0
			
func select_anim():
	match state_of_mood:
		0:
			if direction == Vector2.ZERO:
				if is_talking == true:
					playback.travel("idel_talk")
				else:
					playback.travel("idel")
			else:
				playback.travel("walk")
		1:
			if direction == Vector2.ZERO:
				if is_talking == true:
					playback.travel("idel_talk_2")
				else:
					playback.travel("idel_2")
			else:
				playback.travel("walk_2")

func update_animation_perams():
	if direction == Vector2.ZERO:
		return
	if is_backwards == true:
		direction = direction*-1
	anim_tree["parameters/idel/blend_position"] = direction
	anim_tree["parameters/walk/blend_position"] = direction
	anim_tree["parameters/idel_talk/blend_position"] = direction
	anim_tree["parameters/idel_2/blend_position"] = direction
	anim_tree["parameters/walk_2/blend_position"] = direction
	anim_tree["parameters/idel_talk_2/blend_position"] = direction
