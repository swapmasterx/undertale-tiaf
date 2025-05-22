extends Label


@onready var format_text = stat_line.format(GlobalFlags.text_swaper)

@export_multiline var stat_line: String

func _ready():
	SignalManager.inv_updated.connect(_on_inv_updated)
	self.text = format_text

func _on_inv_updated():
	format_text = stat_line.format(GlobalFlags.text_swaper)
	self.text = format_text
