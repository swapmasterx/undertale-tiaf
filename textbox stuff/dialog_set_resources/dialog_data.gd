extends Resource

class_name DialogData
#Speech sound id
	#default1, default2, flowey, flowey evil, Asriel

#Talk sprites id
	#none, flowey, Asriel
	
#Talk sprite expression
#0 = default, 1 = looking to the side, 2 = shocked, 3 = happy, 4 = sad, 5 = angry
@export var dialog_set: Array [Array] = [["This is a test to see if this works.",
"But how does this handle multiple lines."],
["What about other sets of dialog.", "Getting spicy with it~"]]

@export var speech_noise_id: Array [Array]  = [["default1","default2"],["flowey", "flowey_evil"]]

@export var char_talk_sprite_id : Array [Array] = [["none","flowey"], ["flowey","none"]]

@export var char_mood_sprite_id : Array [Array] = [[0,0], [1,0]]
