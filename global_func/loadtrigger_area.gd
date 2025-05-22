extends Area2D
class_name LoadTriggerArea


var interact: Callable = func():
	pass


func _on_body_entered(body):
	InteractionManager.register_load_trigger(self)
