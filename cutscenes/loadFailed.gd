extends RichTextLabel

func loadfailed():
	self.visible = true
	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 2)
