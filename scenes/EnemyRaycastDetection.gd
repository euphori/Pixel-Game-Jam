extends Node2D


var raycasts = [RayCast2D,RayCast2D,RayCast2D,RayCast2D,RayCast2D,RayCast2D,RayCast2D,RayCast2D]
var enabled = false
var distances = [0,0,0,0,0,0,0,0]

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

func enable_collisions():
	raycasts[0] = $RayCastUp
	raycasts[1] = $RayCastUpRight
	raycasts[2] = $RayCastRight
	raycasts[3] = $RayCastDownRight
	raycasts[4] = $RayCastDown
	raycasts[5] = $RayCastDownLeft
	raycasts[6] = $RayCastLeft
	raycasts[7] = $RayCastUpLeft
	enabled = true
