
extends CharacterBody2D



const SPEED = 20.0
const JUMP_VELOCITY = -400.0



var player
var is_player_near = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_jumpscare = false

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



enum States{
	LURK,
	CHASE,
	INACTIVE,
	HIDE
}
var state = States.INACTIVE
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
	if Input.is_action_just_pressed("sonar") and is_player_near and can_jumpscare and state == States.LURK:
		#state = States.LURK
		$ScreechAudio.play()
		$ScreechCD.start(3)
		state = States.CHASE
		print(state)
		
	
	if player:
		if global_position - player.global_position >=  Vector2.RIGHT: 
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	
		
		#determines sharpness of turn
		update_context_map(player.position, position)
		var sharp_turn = 2.2
		var steering_force = arr[best_direction_index] - velocity
		
		
		#print("Player Spotted")
		if state == States.CHASE:
			if abs(global_position.distance_to(player.global_position)) <= 40 and can_jumpscare:
				$AnimationPlayer.play("bite")
				await $AnimationPlayer.animation_finished
				state = States.HIDE
				velocity = Vector2(0,0)
				can_jumpscare = false

			velocity = velocity + ((steering_force * sharp_turn) * delta)
			position += velocity
			if velocity > Vector2.ZERO:
				$AnimationPlayer.play("swim")
		if state == States.HIDE:
			if can_jumpscare:
				state = States.LURK
			velocity = velocity + ((steering_force * sharp_turn) * (delta / 7))
			position -= velocity
		if state == States.LURK:
			var distance = abs(global_position.distance_to(player.global_position))
			if distance > 80:
				velocity = velocity + ((steering_force * sharp_turn) * delta)
				position += velocity
			else:
				velocity = Vector2.ZERO
				
		print(state)

func _on_player_detection_body_entered(body):
	is_player_near = true 
	can_jumpscare = true
	player = body


func _on_player_detection_body_exited(body):
	is_player_near = false
	player = null


func _on_player_detection_area_entered(area):
	$WarningSprite.visible = false
	if can_jumpscare:
		$ScreechAudio.play()
		state = States.CHASE
		
	

	


func _on_player_detection_area_exited(area):
	$WarningSprite.visible = true


func _on_screech_cd_timeout():
	if player:
		if state == States.CHASE:
			return
		state = States.LURK
	else:
		state = States.INACTIVE
	can_jumpscare = true


func _on_enemy_hitbox_area_entered(area):
	pass
