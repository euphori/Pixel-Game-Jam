
extends CharacterBody2D



const SPEED = 100.0
const JUMP_VELOCITY = -400.0



var player
var is_player_near = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var played_jumpscare = false

#direction vector array
#corresponds to up,       upper right,         right,    downward right,      down,     downward left,     left,         upper left
var arr = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]


#reference video https://www.youtube.com/watch?v=-y3MOsBetow
#to calculate which direction is more interesting for AI
var interest_array = [0,0,0,0,0,0,0,0]
#to calculate which directions to avoid
var danger_array = [0,0,0,0,0,0,0,0]
#decides which direction AI goes to
var context_map = [0,0,0,0,0,0,0,0]
var best_direction_index = 0

#custom functions
func update_context_map(player_position, current_position):
	#function normalizes vector automatically
	var vector_to_player = current_position.direction_to(player_position)
	
	#populate interest array using vector dot product
	for i in range(8):
		interest_array[i] = vector_to_player.dot(arr[i])
	for i in range(8):
		context_map[i] = interest_array[i] - danger_array[i]
		if i == 0:
			best_direction_index = 0
		elif context_map[i] > context_map[best_direction_index]:
			#for some reason subtracting one makes it more accurate 
			best_direction_index = i - 1
	
	


#godot functions
func _physics_process(delta):
	if Input.is_action_just_pressed("sonar") and is_player_near and !played_jumpscare:
		$AudioStreamPlayer2D.play()
	
	if player:
		#print("Player Spotted")
		update_context_map(player.position, position)
		#determines sharpness of turn
		var sharp_turn = 2.2
		var steering_force = arr[best_direction_index] - velocity
		velocity = velocity + ((steering_force * sharp_turn) * delta)
		position += velocity
		




func _on_player_detection_body_entered(body):
	is_player_near = true
	player = body


func _on_player_detection_body_exited(body):
	is_player_near = false
	player = null


func _on_player_detection_area_entered(area):
	$WarningSprite.visible = false
	if !played_jumpscare:
		$AudioStreamPlayer2D.play()
		played_jumpscare = true
	


func _on_player_detection_area_exited(area):
	$WarningSprite.visible = true
