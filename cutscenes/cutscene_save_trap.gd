extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var cutscene_camera = $CutsceneCamera
@export var interaction_area: InteractionArea
@export var load_trigger_area: LoadTriggerArea
@onready var text_handlerr = $"../../DialogHandler"
@onready var text_box = $"../../player/Camera2D/CanvasLayer/Textbox Control"
@onready var player_camera = $"../../player/Camera2D"
@onready var player_hurtbox = $"../../player/sprite2d/soul/damage_hitbox"
@onready var player = $"../../player"
@export var dialog_data: DialogData
@onready var cornered_spawn = $"cornered spawn"
var trap_sprung: bool = false
var dialog_count: int = 0

func _ready():
	SignalManager.closed_dialog.connect(_closed_dialog)
	SignalManager.saved_menu_closed.connect(_on_finished_saving)
	if RoomPersistance.plot_value >= 5:
		self.queue_free()


func _on_finished_saving():
	trap_sprung = true
	adjust_camera_start()
	await get_tree().create_timer(0.1).timeout
	cutscene_start()
	SignalManager.startCutscene.emit()

func _closed_dialog():
	if trap_sprung == true:
		animation_player.play("cutscene_save_trap")
		GlobalFlags.cutscene_mode(true)

func cutscene_start():
	cutscene_camera.enabled = true
	animation_player.play("cutscene_save_trap")
	
func cutscene_end():
	RoomPersistance.plot_value = 5
	cutscene_camera.enabled = false
	SignalManager.endCutscene.emit()

func cutscene_close():
	self.queue_free()

func pause_cutscene():
	animation_player.pause()

func adjust_camera_start():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "global_position", player_camera.global_position, 0.05)

func adjust_camera_end():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "global_position", player_camera.global_position, 0.25)

func dialogue():
	animation_player.pause()
	text_box.character_time = 0.03
	if text_handlerr && GlobalFlags.dialogMode == false:
		text_handlerr.dialog = dialog_data.dialog_set[dialog_count]
		text_handlerr.speech_id = dialog_data.speech_noise_id[dialog_count]
		text_handlerr.char_talk_sprite_id = dialog_data.char_talk_sprite_id[dialog_count]
		text_handlerr.on_interact()
		dialog_count += 1
		
func cornered_pattern():
	cornered_spawn.global_position = player_hurtbox.global_position
	cornered_spawn.spawn()
