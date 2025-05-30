extends Control

#Foundation of diolog display code from DashNothing. 
@export var is_overworld : bool = true


@onready var nine_patch_rect = $textboxrect
@onready var textbox_control = $"."
@onready var text_scroll_timer = $Text_scroller
@onready var text_slot = $textbox/Text
@onready var speech_sprite = $speech_sprite
@onready var text_sounds = $text_sounds
@onready var textbox_containter = $textbox

# Controls how fast the dialog scrolls by. Shouldn't be changed too much outside DRAMATICLY SPACED SPEECH! (woh)
var character_time = 0.03

# Set false if pressing x shouldn't be able to skip over dialog
var skipable = true

# If player can advance to the next text box in a message chain
var can_advance_segment = false

# Modifies the text display to accomidate a talk sprite and tells the game if it needs to load one.

# Set along side dialog_boxes to indicate which talk sprite is used for each line of dialog.
# A value of 0 is treated as no talk sprite is used
var character_face_id: Array = []

# Set along side dialog_boxes to indicate which expression a given characters talk sprite is in.
# A value of 0 or over the max amount of moods a talk sprite has is treated as the default
var face_mood_id: Array = []

# Set by display_text() to display the given line
var text_to_use = ""
# Tracks the displayed text characters
var letter_index = 0

# Set lines of dialog to play in a given sequence
var dialog_boxes: Array = []
# Which line in a set it is at.
var box_index = 0

# Set along side dialog_boxes to indicate which speach noise is used for each line of dialog
var speechSFX_id: Array = []

signal finished_dispo()

func _ready():
	if is_overworld == false:
		nine_patch_rect.visible = false
	elif is_overworld == true:
		nine_patch_rect.visible = true

func speech_n_face_ider(speech_id: Array, talk_char_id: Array, char_mood_id: Array):
	#stops dialog from being reactivated if its already running
	if GlobalFlags.dialogMode:
		return
	speechSFX_id = speech_id
	character_face_id = talk_char_id 
	face_mood_id = char_mood_id 
	
func start_dialog(use_cinima_mode: bool, boxes: Array):
	#stops dialog from being reactivated if its already running
	if GlobalFlags.dialogDisabled == false:
		if GlobalFlags.dialogMode:
			return
		GlobalFlags.text_box_open = true
		print(GlobalFlags.text_box_open)
		dialog_boxes = boxes
		can_advance_segment = false
		#print(dialog_boxes[box_index])
	
		self.visible = true
		
		print("self visible is", self.visible)
		
		use_talk_sprite()
		display_text(dialog_boxes[box_index])
	
		GlobalFlags.menu_lock = true
		if use_cinima_mode == false:
			print("cinafalse")
			GlobalFlags.wasd_lock = true
		else:
			print("cinatrue")
		GlobalFlags.dialogMode = true
		#GlobalFlags.menu_lock = true
		
	
	

func display_text(text_to_dispo: String):
	text_to_use = text_to_dispo.format(GlobalFlags.text_swaper)
	text_slot.text = ""
	_display_letter()

func _display_letter():
	text_slot.text += text_to_use[letter_index]
	
	match text_to_use[letter_index]:
		" ": 
			pass
		_:
			play_speech_sound()
			
	letter_index += 1
	
	if Input.is_action_pressed("back_cancel"):
		finished_dispo.emit()
		return
	if letter_index >= text_to_use.length():
		finished_dispo.emit()
		return
	
	text_scroll_timer.start(character_time)

func _on_finished_dispo():
	if GlobalFlags.dialogMode == true:
		can_advance_segment = true

func cont_dialog():
	
	can_advance_segment = false
	print(dialog_boxes[box_index])
	use_talk_sprite()
	display_text(dialog_boxes[box_index])


func _unhandled_input(event):
	if skipable == true && GlobalFlags.dialogMode == true && can_advance_segment == false:
		if Input.is_action_pressed("back_cancel"):
			if text_scroll_timer:
				text_scroll_timer.stop()
			text_slot.text = text_to_use
			finished_dispo.emit()
			return
			
	if (event.is_action_pressed("interact_confirm") && GlobalFlags.dialogMode && can_advance_segment):
		box_index += 1
		if box_index < dialog_boxes.size():
			letter_index = 0
			cont_dialog()
			
		elif box_index >= dialog_boxes.size():
			close_dialog_box()
			
			
func close_dialog_box():
	box_index = 0
	letter_index = 0
	speechSFX_id = []
	character_face_id = []
	face_mood_id = []
	same_sound = "none"
	GlobalFlags.text_box_open = false
	if GlobalFlags.menu_active == false:
		GlobalFlags.wasd_lock = false
	if GlobalFlags.menu_active == true:
		SignalManager.closed_choose_option.emit()
	textbox_control.visible = false
	GlobalFlags.dialogMode = false
	can_advance_segment = false
	GlobalFlags.menu_lock = false
	if GlobalFlags.is_saving == true:
		SignalManager.closed_dialog.emit()


func _on_text_scroller_timeout():
	_display_letter()

##################################################################################################
#Used to check if play_speech_sound needs to change what speech sound is in use.
var same_sound = "none"

var speech_in_use = preload("res://sound_effects/SND_TXT1.wav")

func play_speech_sound():
	if same_sound != speechSFX_id[box_index]:
		match speechSFX_id[box_index]:
			"default1":
				speech_in_use = load("res://sound_effects/SND_TXT1.wav")
			"default2":
				speech_in_use = load("res://sound_effects/SND_TXT2.wav")
			"flowey":
				speech_in_use = load("res://sound_effects/snd_floweytalk1.wav")
			"flowey_evil":
				speech_in_use = load("res://sound_effects/snd_floweytalk2.wav")
			"Asriel":
				speech_in_use = load("res://sound_effects/snd_txtasr2.wav")
				
		same_sound = speechSFX_id[box_index]
		text_sounds.stream = speech_in_use
	text_sounds.play()

func use_talk_sprite():
	if character_face_id[box_index] == "none":
		textbox_containter.add_theme_constant_override("margin_left", 80)
		text_slot.custom_minimum_size = Vector2(770,120)
		speech_sprite.visible = false
	elif character_face_id[box_index] != "none":
		textbox_containter.add_theme_constant_override("margin_left", 200)
		text_slot.custom_minimum_size = Vector2(660,120)
		speech_sprite.visible = true
	print(character_face_id[box_index])
	match character_face_id[box_index]:
		"none":
			pass
		"flowey":
			speech_sprite.texture = load("res://sprites/dev/comicfurypageicon.png")
		"Asriel":
			pass
