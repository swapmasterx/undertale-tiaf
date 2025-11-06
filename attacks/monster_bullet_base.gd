extends RigidBody2D

class_name GenericProjectile

#Desides if a bullet should despawn when it impacts the player. 
@export var persistent: bool = false
#How much time in seconds that a bullet inflicts invincibility. 
@export var inv_frames: float = 1
#damage a projectile deals to the player
@export var impact_damage : float = -5
#time before a projectile despawns after it first appears
@export var bullet_lifetime : float = 5

func _ready():
	set_as_top_level(true)
	await get_tree().create_timer(bullet_lifetime).timeout
	print("projectile timed out")
	queue_free()

func _on_area_2d_area_entered(hit_obj):
	if hit_obj.is_in_group("hurt_box") && PlayerData.is_inv == false:
		PlayerData.inv_frames = inv_frames
		PlayerData.health_change(impact_damage)
		if persistent == false:
			queue_free()

func _on_body_entered(body):
	print("bullet hit hit a wall")
	queue_free()
