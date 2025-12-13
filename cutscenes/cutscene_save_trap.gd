extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var cutscene_camera = $CutsceneCamera
@onready var text_handlerr = $"../../DialogHandler"
@onready var text_box = $"../../player/Camera2D/CanvasLayer/Textbox Control"
@onready var player_camera = $"../../player/Camera2D"
@onready var player_hurtbox = $"../../player/sprite2d/soul/damage_hitbox"
@onready var player = $"../../player"
@export var dialog_data: DialogData
var trap_sprung: bool = false
var dialog_count: int = 0
@export var load_trigger_area: LoadTriggerArea
var fireball_prep = preload("res://attacks/toriel/fireball_other_flower.tscn")

func _ready():
	if load_trigger_area:
		if GlobalFlags.dev_mode == true:
			print("interaction for ", self, " loaded")
		load_trigger_area.interact = Callable(self, "_on_interact")
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
	SignalManager.endCutscene.emit()
	cutscene_camera.enabled = false

func cutscene_close():
	self.queue_free()

func pause_cutscene():
	animation_player.pause()

func adjust_camera_start():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "global_position", player_camera.global_position, 0.05)

func adjust_camera_end():
	RoomPersistance.plot_value = 5
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
	var cornered_prep = preload("res://attacks/other_Flowey/bullet_trap_overworld.tscn")
	var cornered = cornered_prep.instantiate()
	add_child(cornered)
	var cornered_spawn = $"bullet_trap/cornered spawn"
	var cornered_close = $"bullet_trap/cornered_close in"
	cornered_spawn.global_position = player_hurtbox.global_position
	cornered_close.global_position = player_hurtbox.global_position
	cornered_spawn.spawn()

func close_in():
	var cornered_trap = $"bullet_trap"
	Spawning.clear_all_offscreen_bullets()
	Spawning.clear_all_bullets()
	Spawning.reset()
	cornered_trap.queue_free()
	await get_tree().process_frame
	var cornered_prep = preload("res://attacks/other_Flowey/bullet_trap_overworld.tscn")
	var cornered = cornered_prep.instantiate()
	add_child(cornered)
	var cornered_close = $"bullet_trap/cornered_close in"
	cornered_close.global_position = player_hurtbox.global_position
	cornered_close.spawn()

func _on_interact():
	Spawning.clear_all_offscreen_bullets()
	Spawning.clear_all_bullets()
	Spawning.reset()
	GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_ehurt1.wav")
	GlobalFlags.sfx_2_channel.play()

func fire_ball_the_flower():
	var fireball = fireball_prep.instantiate()
	fireball.global_position = Vector2(0, -100)
	add_child(fireball)

func turn_player_to_toriel():
	player.direction = Vector2(0, 0.001)
	await get_tree().process_frame
	player.direction = Vector2(0,0)


func _on_load_triggerfireballtarget_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	await get_tree().process_frame
	Spawning.clear_all_offscreen_bullets()
	Spawning.clear_all_bullets()
	Spawning.reset()
	GlobalFlags.sfx_2_channel.stream = load("res://sound_effects/snd_ehurt1.wav")
	GlobalFlags.sfx_2_channel.play()
