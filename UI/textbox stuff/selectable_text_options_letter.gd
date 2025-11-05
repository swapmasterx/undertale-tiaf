extends Button

@onready var name_creation = $"../../../.."

@export var Letter: String = "A"

@onready var rich_text_label = $RichTextLabel

@onready var name_entry = $"../../nameEntry"

func _ready():
	rich_text_label.text =  "[shake rate=20.0 level=6 connected=1]"+Letter+"[/shake]"
	rich_text_label.add_theme_color_override("default_color", Color(0.908, 0.908, 0.908, 1.0))

func _on_pressed():
	name_creation.letter = Letter
	SignalManager.inv_updated.emit()


func _on_focus_entered():
	rich_text_label.add_theme_color_override("default_color", Color(1.0, 1.0, 0.0, 1.0))


func _on_focus_exited():
	rich_text_label.add_theme_color_override("default_color", Color(0.908, 0.908, 0.908, 1.0))
