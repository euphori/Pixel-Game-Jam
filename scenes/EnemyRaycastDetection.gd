extends Node2D


@onready var raycasts = [
	$RayCastUp,
	$RayCastUpRight,
	$RayCastRight,
	$RayCastDownRight,
	$RayCastDown,
	$RayCastDownLeft,
	$RayCastLeft,
	$RayCastUpLeft
]

var enabled = false
var distances = [0,0,0,0,0,0,0,0]
var collision_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		for i in range(8):
			if raycasts[i].is_colliding():
				var origin = raycasts[i].global_transform.origin
				var collision_point = raycasts[i].get_collision_point()
				var distance = origin.distance_to(collision_point)
				distances[i] = distance
			else:
				distances[i] = 0
				
		collision_count = distances.size() - distances.count(0)
	
