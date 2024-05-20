extends Node2D

var mineral = preload("res://scenes/minerals.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_minerals():
	for marker in get_children():
		var _mineral = mineral.instantiate()
		_mineral.global_position = marker.global_position
		
		var rng = randi_range(0,min(Global.curr_difficulty, 3))
		if rng == 0 or rng == 1 :
			get_parent().add_child(_mineral)
