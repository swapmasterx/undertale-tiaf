extends RichTextLabel



func active_quit():
	self.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 4)
	
func abort_quit():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.1)
	self.visible = false
