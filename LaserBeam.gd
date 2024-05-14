extends Node2D

const MAX_LENGTH = 2000

@onready var beam = $Beam
@onready var end = $End
@onready var ray_cast = $RayCast2D

@export var damage = 0.5
@export var enabled = false

var sound_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled: return
	else:
		if Input.is_action_pressed("laser"):
			visible = true
			if !sound_playing:
				$AudioStreamPlayer2D.play()
				sound_playing = true
			var mouse_pos = get_local_mouse_position()
			var max_cast_to = mouse_pos.normalized() * MAX_LENGTH
			ray_cast.target_position = max_cast_to
			if ray_cast.is_colliding():
				end.global_position = ray_cast.get_collision_point()
				ray_cast.get_collider().health -= damage
			else:
				end.global_position = ray_cast.target_position
				
			beam.rotation = ray_cast.target_position.angle()
			beam.region_rect.end.x = end.position.length()
		else:
			visible = false
			$AudioStreamPlayer2D.stop()
			sound_playing = false
