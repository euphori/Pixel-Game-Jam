extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_player_near = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var played_jumpscare = false



func _physics_process(delta):
	if Input.is_action_just_pressed("sonar") and is_player_near:
		print("X")
		$AudioStreamPlayer2D.play()





func _on_player_detection_body_entered(body):
	is_player_near = true


func _on_player_detection_body_exited(body):
	is_player_near = false


func _on_player_detection_area_entered(area):
	if !played_jumpscare:
		$AudioStreamPlayer2D.play()
		played_jumpscare = true
	
