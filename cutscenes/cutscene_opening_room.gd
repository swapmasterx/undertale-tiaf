extends Node2D

@onready var cutscene_camera = $CutsceneCamera
@onready var animation_player = $AnimationPlayer
@onready var text_handlerr = $"../../DialogHandler"
@onready var text_box = $"../../player/Camera2D/CanvasLayer/Textbox Control"
@onready var player_camera = $"../../player/Camera2D"
@onready var player = $"../../player"
@export var dialog_data_1: DialogData
var interact_counter: int = 0

func _ready():
	SignalManager.closed_dialog.connect(_closed_dialog)
	if RoomPersistance.opening_cutscene == false:
		cutscene_start()
		await get_tree().create_timer(0.1).timeout
		SignalManager.startCutscene.emit()
	else:
		self.visible = false

func cutscene_start():
	player.visible = false
	cutscene_camera.enabled = true
	animation_player.play("opening_cutscene")
	
func dialogue_1():
	animation_player.pause()
	text_box.character_time = 0.06
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data_1.dialog_set[0]
		text_handlerr.speech_id = dialog_data_1.speech_noise_id[0]
		text_handlerr.char_talk_sprite_id = dialog_data_1.char_talk_sprite_id[0]
		text_handlerr.on_interact()

func _closed_dialog():
	animation_player.play("opening_cutscene")
	GlobalFlags.cutscene_mode(true)

func great_shine():
	GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_great_shine.ogg")
	GlobalFlags.sfx_2_channel.play()

func impact():
	GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_impact.wav")
	GlobalFlags.sfx_2_channel.play()
	
func generate():
	GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/mus_sfx_generate.wav")
	GlobalFlags.sfx_2_channel.play()

func dialogue_2():
	animation_player.pause()
	text_box.character_time = 0.07
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data_1.dialog_set[1]
		text_handlerr.speech_id = dialog_data_1.speech_noise_id[1]
		text_handlerr.char_talk_sprite_id = dialog_data_1.char_talk_sprite_id[1]
		text_handlerr.on_interact()

func dialogue_3():
	animation_player.pause()
	text_box.character_time = 0.03
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data_1.dialog_set[2]
		text_handlerr.speech_id = dialog_data_1.speech_noise_id[2]
		text_handlerr.char_talk_sprite_id = dialog_data_1.char_talk_sprite_id[2]
		text_handlerr.on_interact()

func dialogue_4():
	animation_player.pause()
	text_box.character_time = 0.03
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data_1.dialog_set[3]
		text_handlerr.speech_id = dialog_data_1.speech_noise_id[3]
		text_handlerr.char_talk_sprite_id = dialog_data_1.char_talk_sprite_id[3]
		text_handlerr.on_interact()

func cutscene_end():
	RoomPersistance.opening_cutscene = true
	player.visible = true
	cutscene_camera.enabled = false
	SignalManager.endCutscene.emit()

func adjust_camera():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "global_position", player_camera.global_position, 0.5)
