extends Node2D

@export var depth_level = 1




# Called when the node enters the scene tree for the first time.
func _ready():

	for mineral in get_children():
		var sum_of_weight = 0
		for i in mineral.mineral_rarity_weight:
			sum_of_weight += mineral.mineral_rarity_weight[i]
		var rng = randi_range(0,sum_of_weight)
		for i in mineral.mineral_rarity_weight:
			if rng < mineral.mineral_rarity_weight[i]:
				mineral.type = i
				mineral.update_visual()
				break
			rng -= mineral.mineral_rarity_weight[i]
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
