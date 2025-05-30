class_name Player;extends CharacterBody2D

# Globally accessable variables
# (i aplogise for my difference in writing code); ~ Chris

# Note note: i may need to wait until i have more time, digging into this deeper there are a few
# things i may need to explain and modify, and i am currently feeling fatigue lol 
# I'll need to study this source a lil more. ~ Chris at 3:40 in the morning

## The node used in the overworld.
static var this_node:Player;

# im a little too tired to make a full port atm but im going to make sure the game still runs
## The player's current health.
static var health:int = 20;
## The maximum player's health, determines how high you can heal using items.
static var max_health:int = 20;
## :3
static var love:int = 1;
static var exp:int = 0;

static var attack:float = 10.0;
static var defense:float = 10.0;

static var gold:int = 0;

# Note for the future: maybe make this an enum? not entirely sure what's planned.
static var equip_weapon:String = "none"
static var equip_armor:String = "none"
## Name of the fallen child.
static var fallen_name:String = "Chara"

## Name of the node where the player will be placed. Note: If name is invalid, it will chose the first spawn in the group of spawns.
static var spawn_location:String;

static var inventory:Array = [TEST_ITEM_HEAL_A,TEST_ITEM_HEAL_B,TEST_ITEM_HEAL_A];

const TEST_ITEM_HEAL_A = preload("res://items/repo/test_heal.tres");
const TEST_ITEM_HEAL_B = preload("res://items/repo/test_heal2.tres")

# Set by the player if they want to sprint with the key is heald or if they want to toggle it on and off.
@export var sprintToggleMode = true
@export var anim_tree: AnimationTree


var SPEED = 400.0
var direction
var playback : AnimationNodeStateMachinePlayback
# Sprint status
var sprintActive = false
var slowWalk = false

# Static functions

static func add_item(inv_item):
	if inventory.size() < 8:
		inventory.append(inv_item)
		SignalManager.inv_updated.emit()
	else:
		print("But your inventory was full.")
		return
	
		
static func remove_item(item_removed):
	if inventory.size() > 0:
		inventory.remove_at(item_removed)
		SignalManager.inv_updated.emit()
	else:
		print("But your inventory was empty.")
		return
		
static func health_change(hp_value):
	if hp_value >= 0:
		if health + hp_value >= max_health:
			health = max_health
		else:
			health += hp_value
		GlobalFlags.text_swaper["HPcur"] = health
		SignalManager.inv_updated.emit()
		# So "get_tree()" can't be called from static funcs
		# what's my solution? use an autoload to call it lol
		# this can work with any autoload i just chose interactionmanager because it's the longest.
		await InteractionManager.get_tree().create_timer(0.2).timeout
		GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_heal_c.wav")
		GlobalFlags.sfx_2_channel.play()
	elif hp_value < 0:
		pass

# Node functions

func _notification(what:int)->void:
	match(what):
		# These 4 lines basically ensure that this player object is always accessable globally.
		# The last 2 ensure that we don't keep a dead reference to the node after it's deleted.
		NOTIFICATION_READY:
			Player.this_node = self;
		NOTIFICATION_PREDELETE:
			if(Player.this_node == self): Player.this_node = null;

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
