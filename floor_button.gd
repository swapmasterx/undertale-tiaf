extends Node2D

@export var load_trigger_area: LoadTriggerArea

@export var interaction_area: InteractionArea

@export var on_texture: Texture

@export var off_texture: Texture 

@export var sprite: Sprite2D

@export var switch_state: bool = false

#Used to dictate the logic of puzzles. For example with the first ruins puzzle the side
#buttons have a positive value while the center path ones are negitive. 
#The puzzle is "solved" when the player makes a value of 4 by pressing the outer buttons and
# avoiding the inner ones
@export var puzzle: int

#@export var single_press: bool = true
@onready var puzzle_logic = $"../../puzzle_logic_base"



func _ready():
	SignalManager.switchpuzzle.connect(_on_puzzle_checked)
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
			load_trigger_area.interact = Callable(self, "_on_interact")
	if interaction_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
			interaction_area.interact = Callable(self, "_on_interact")
			await self.ready
			sprite.texture = off_texture
			
func _on_puzzle_checked():
	if switch_state == true :
		sprite.texture = off_texture
		switch_state = false
	
func _on_interact():
	if switch_state == false:
		sprite.texture = on_texture
		switch_state = true
		
		GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_test.wav")
		GlobalFlags.sfx_1_channel.play()
		
		if puzzle_logic:
			puzzle_logic.solved += puzzle
			print(puzzle_logic.solved)
		
	#elif switch_state == true:
		#sprite.texture = off_texture
		#switch_state = false
		#GlobalFlags.sfx_1_channel.stream = load("res://sound_effects/snd_test.wav")
		#GlobalFlags.sfx_1_channel.play()
	
	#print("touched the button ", switch_state)
