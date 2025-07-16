extends Area2D
class_name InteractionArea


var interact: Callable = func():
	pass


func _on_body_entered(_body):
	print(self, "entered")
	InteractionManager.register_area(self)

func _on_body_exited(_body):
	print(self, "left")
	InteractionManager.unregister_area(self)
