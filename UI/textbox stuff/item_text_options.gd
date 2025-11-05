extends TextButtonOption

var item: Item
var is_empty: bool = false

func _ready():
	SignalManager.closed_choose_option.connect(close_choose_option)
	SignalManager.use_or_toss.connect(use_or_toss)
func _on_pressed():
	GlobalFlags.use_or_toss = true
	GlobalFlags.item_transit = item
	GlobalFlags.text_swaper["item"] = item.item_name
	SignalManager.use_or_toss.emit()
	
	print(GlobalFlags.item_transit)
	GlobalFlags.menu_layer = 3
	GlobalFlags.sfx_1_channel.stream = load("res://battle/snd_select.wav")
	GlobalFlags.sfx_1_channel.play()

func use_or_toss():
	self.focus_mode = FOCUS_NONE
	self.disabled = true

func close_choose_option():
	GlobalFlags.use_or_toss = get_theme_default_base_scale()
	if is_empty == false:
		self.focus_mode = FOCUS_ALL
		self.disabled = false
