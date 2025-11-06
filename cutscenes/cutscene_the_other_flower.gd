extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var cutscene_camera = $CutsceneCamera
@export var interaction_area: InteractionArea
@export var load_trigger_area: LoadTriggerArea
@onready var text_handlerr = $"../../DialogHandler"
@onready var text_box = $"../../player/Camera2D/CanvasLayer/Textbox Control"
@onready var player_camera = $"../../player/Camera2D"
@onready var player = $"../../player"
@export var dialog_data: DialogData
@onready var exclaim = $Exclaim
var dialog_count: int = 0

func _ready():
	SignalManager.closed_dialog.connect(_closed_dialog)
	if interaction_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		interaction_area.interact = Callable(self, "_on_interact")
		print(interaction_area.interact)
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		load_trigger_area.interact = Callable(self, "_on_interact")
	if RoomPersistance.other_flower_cutscene == true:
		self.queue_free()


func _on_interact():
	cutscene_start()
	await get_tree().create_timer(0.1).timeout
	SignalManager.startCutscene.emit()

func _closed_dialog():
	animation_player.play("the_other_flower")
	GlobalFlags.cutscene_mode(true)

func cutscene_start():
	cutscene_camera.enabled = true
	animation_player.play("the_other_flower")
	
func cutscene_end():
	RoomPersistance.other_flower_cutscene = true
	cutscene_camera.enabled = false
	SignalManager.endCutscene.emit()
	SignalManager.enter_overworld_hazard.emit()

func cutscene_close():
	self.queue_free()

func pause_cutscene():
	animation_player.pause()

func adjust_camera():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "global_position", player_camera.global_position, 0.25)

func alert():
	exclaim.visible = true
	GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_b.wav")
	GlobalFlags.sfx_2_channel.play()
	await get_tree().create_timer(1).timeout
	exclaim.visible = false

func dialogue():
	animation_player.pause()
	text_box.character_time = 0.03
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data.dialog_set[dialog_count]
		text_handlerr.speech_id = dialog_data.speech_noise_id[dialog_count]
		text_handlerr.char_talk_sprite_id = dialog_data.char_talk_sprite_id[dialog_count]
		text_handlerr.on_interact()
		dialog_count += 1
		
