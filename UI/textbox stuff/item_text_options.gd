extends TextButtonOption

@export var item: Item


func _on_pressed():
	
	GlobalFlags.item_transit = item
	GlobalFlags.text_swaper["item"] = item.item_name
	SignalManager.activate_choose_option.emit()
	
	print(GlobalFlags.item_transit)
	GlobalFlags.menu_layer = 3
	GlobalFlags.sfx_1_channel.stream = load("res://battle/snd_select.wav")
	GlobalFlags.sfx_1_channel.play()
