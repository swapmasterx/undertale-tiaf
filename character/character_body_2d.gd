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
@onready var damage_hitbox = $sprite2d/soul/damage_hitbox
@onready var exclaim = $exclaim
@onready var battle_fall_blackout = $battle_fall_blackout
@onready var battle_transition = $battle_transition
@onready var soul_battle = $soul_battle
@onready var soul = $sprite2d/soul
@onready var camera_2d = $Camera2D

@onready var soul_fall_to = $"../soul_fall_to"


func _ready():
	playback = anim_tree["parameters/playback"]
	exclaim.visible = false
	soul_battle.visible = false
	damage_hitbox.monitoring = false
	damage_hitbox.monitorable = false
	SignalManager.overworld_to_battle.connect(battle_fall)
	SignalManager.enter_overworld_hazard.connect(entered_over_hazard)
	SignalManager.exit_overworld_hazard.connect(exited_over_hazard)
	SignalManager.battle_loaded.connect(battle_loaded)

func battle_loaded():
	battle_transition.play("battle_fall_reset")
	
	camera_2d.enabled = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(soul_battle, "modulate:a", 1, 0.1)
	tween.tween_property(soul_battle, "global_position", soul.global_position, 0.1)

func battle_fall(battle_fall_type):
	GlobalFlags.music_channel.stop()
	SignalManager.lockWasd.emit()
	GlobalFlags.menu_lock = true
	match battle_fall_type:
		0:
			battle_transition.play("battle_fall_generic")
		1:
			pass
		2:
			pass
			
#120.393
#573.0
func soul_tween():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(soul_battle, "global_position", soul_fall_to.global_position, 0.5)
	tween.tween_property(soul_battle, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.6).timeout
	GlobalFlags.game_state = 1
	SignalManager.changed_game_state.emit()



func entered_over_hazard():
	damage_hitbox.monitoring = true
	damage_hitbox.monitorable = true
	match PlayerData.overworld_hazard_type:
		0:
			print("no player centered hazard defined")
		1:
			var flowey_prep = preload("res://attacks/other_Flowey/overworld_other_flowey_ruins_attacks.tscn")
			var flowey = flowey_prep.instantiate()
			add_child(flowey)

func exited_over_hazard():
	damage_hitbox.monitoring = false
	damage_hitbox.set_deferred("monitorable", false)

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
	if GlobalFlags.wasd_lock == false && GlobalFlags.overworld_lockdown == false:
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
			SPEED = 350
			sprintActive = false
		elif Input.is_action_just_pressed("sprint") and sprintActive == false:
			SPEED = 550
			sprintActive = true

#func animspeed(veloc):
	#pass
