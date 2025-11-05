extends HSlider

@export var bus_name: String
#@export_enum("Master", "SFX", "Music") var bus_load

var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	await get_tree().create_timer(0.07).timeout
	print(bus_index)
	match bus_index:
		1:
			self.value = PlayerData.master_volume
		2:
			self.value = PlayerData.sfx_volume
		3:
			self.value = PlayerData.music_volume
	
	
func _on_value_changed(value: float):
	
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	match bus_index:
		1:
			PlayerData.master_volume = value
		2:
			PlayerData.sfx_volume = value
			AudioServer.set_bus_volume_db(4, linear_to_db(value))
		3:
			PlayerData.music_volume = value
		
	
