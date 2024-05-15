extends CharacterBody2D

var color
var dir
var speed = 10
var player_near = false
var player
var deviation_angle = PI 
var start_pos
var max_distance = 25
var min_distance = 1
var can_siphon = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(0.5)
	start_pos = global_position
	rotation += randf_range(-deviation_angle,deviation_angle)
	modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_dir = Vector2(cos(rotation),sin(rotation))
	var distance_to_start_pos = global_position.distance_to(start_pos)
	
	var attenuation = clamp(1.0 - distance_to_start_pos / randf_range(min_distance,max_distance), 0.0, 1.0)
	velocity =  move_dir * speed * attenuation
	if player_near and player!= null and can_siphon:
		speed = 100
		dir =  global_position.direction_to(player.global_position)
		velocity = dir * speed
		
	if player != null and int(global_position.distance_to(player.global_position)) <= 0:
		
		queue_free()
	move_and_slide()


func _on_player_detection_body_entered(body):
	player_near = true
	player = body


func _on_timer_timeout():
	can_siphon = true
