extends TextureProgressBar

func _ready():
	SignalManager.inv_updated.connect(hp_update)

func hp_update():
	self.value = PlayerData.current_hp
