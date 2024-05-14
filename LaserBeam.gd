extends Node2D

const MAX_LENGTH = 2000

@onready var beam = $Beam
@onready var end = $End
@onready var ray_cast = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_local_mouse_position()
	var max_cast_to = mouse_pos.normalized() * MAX_LENGTH
	ray_cast.target_position = max_cast_to
	if ray_cast.is_colliding():
		end.global_position = ray_cast.get_collision_point()
	else:
		end.global_position = ray_cast.target_position
		
	beam.rotation = ray_cast.target_position.angle()
	beam.region_rect.end.x = end.position.length()
