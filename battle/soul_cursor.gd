extends CharacterBody2D

#@onready var collision_hitbox = $collision_hitbox
#
#@export_enum("Standard", "Gravity_Blue", "Stationary_Green", 
#"Shooty_Yellow", "Web_Purple") var soul_mode: String = "Standard"

#var SPEED = 300.0


func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	

#func _physics_process(delta):
	## Get the input direction and handle the movement/deceleration.
	#if GlobalFlags.wasd_lock == false:
		#collision_hitbox.disabled = false
		#match soul_mode:
			#"Standard":
				#standard_soul_mode()
			#"Gravity_Blue":
				#pass
			#"Stationary_Green":
				#pass
			#"Shooty_Yellow":
				#pass
			#"Web_Purple":
				#pass
#
	#else:
		#collision_hitbox.disabled = true
		#velocity.x = 0
		#velocity.y = 0
	#
	#
	#move_and_slide()
	#
#
#
#func standard_soul_mode():
	#var direction = Input.get_vector("left", "right","up","down")
	#if direction:
		#velocity = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	

#signal toggles
func _on_focus_changed(node:Control):
	var focused_size = get_viewport().gui_get_focus_owner().size
	var focused_pos = get_viewport().gui_get_focus_owner().global_position
	if GlobalFlags.wasd_lock == true:
		if get_viewport().gui_get_focus_owner() is TextureButton:
			self.global_position = (focused_pos + Vector2(-focused_size.x/7.25,0)) + ((focused_size/2)*0.4)

		else:
			self.global_position = (focused_pos + Vector2(-focused_size.x/1.5,0)) + (focused_size/2)
			
