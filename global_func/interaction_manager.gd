extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

#What interaction hit boxes the player is currently in
var active_areas = []

var can_interact = true

func register_load_trigger(area: LoadTriggerArea):
	active_areas.push_back(area)
	if active_areas.size() > 0:
		print(active_areas)
		await active_areas[0].interact.call()
		var index = active_areas.find(area)
		if index != -1:
			active_areas.remove_at(index)
		print(active_areas)

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_dist_to_player)

# Sorts the interaction array list by what is closer to the player incase they are in a dence interactible area
func _dist_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact_confirm") && can_interact:
		print("buh")
		if active_areas.size() > 0:
			can_interact = false
			await active_areas[0].interact.call()
			print(active_areas[0])
			can_interact = true
