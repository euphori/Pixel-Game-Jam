
extends CharacterBody2D



const SPEED = 20.0
const JUMP_VELOCITY = -400.0
const LURK_SPEED_MULT = 2
var raycast_detection

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

var playing_lurk_sound = false

enum States{
	LURK,
	CHASE,
	INACTIVE,
	HIDE
}

var state = States.INACTIVE
var wall_direction_index = 0
var can_attack = true
#custom functions
func update_context_map(player_position, current_position):
	#function normalizes vector automatically
	var vector_to_player = current_position.direction_to(player_position)
	
	#populate interest array using vector dot product
	for i in range(8):
		interest_array[i] = vector_to_player.dot(arr[i])
	
	if state == States.HIDE:
		interest_array[wall_direction_index] += 5

	
	for i in range(8):
		context_map[i] = interest_array[i] - danger_array[i]
		if i == 0:
			best_direction_index = 0
		elif context_map[i] > context_map[best_direction_index]:
			#for some reason subtracting one makes it more accurate 

			best_direction_index = i - 1
			

func process_wall_direction():
	var distances = raycast_detection.distances
	var closest_direction_index = 0
	for i in range(8):
		if distances[i] == 0:
			continue
		if distances[i] < distances[closest_direction_index]:
			closest_direction_index = i
	wall_direction_index = closest_direction_index

func move_within_wall():
	if raycast_detection.collision_count > 4 and raycast_detection.collision_count < 8:
		var distances = raycast_detection.distances
		var out_index = 0
		for i in range(8):
			if distances[i] == 0:
				interest_array[i] += 5

#godot functions
func _physics_process(delta):
	if Input.is_action_just_pressed("sonar") and is_player_near and state == States.LURK:
		#state = States.LURK
		$ScreechAudio.play()
		$ScreechCD.start(30)
		state = States.CHASE
		
	
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
		if state == States.CHASE and !player.is_dead:
			if abs(global_position.distance_to(player.global_position)) <= 40  and can_attack:
				if global_position - player.global_position >=  Vector2.RIGHT: 
					$AnimationPlayer.play("bite_left")
				else:
					$AnimationPlayer.play("bite_right")
				
				await $AnimationPlayer.animation_finished
				$AttackCD.start(3)
				can_attack = false
				velocity = Vector2(0,0)
				can_jumpscare = false
				process_wall_direction()
			elif abs(global_position.distance_to(player.global_position)) >= 120:
				state = States.HIDE
			velocity = velocity + ((steering_force * sharp_turn) * delta)
			position += velocity
			if velocity > Vector2.ZERO:
				$AnimationPlayer.play("swim")
		if state == States.HIDE:
			if can_jumpscare:
				state = States.LURK
			velocity = velocity + ((steering_force * sharp_turn) * (delta / 3))
			position += velocity 
		if state == States.LURK:
			if not playing_lurk_sound:
				playing_lurk_sound = true
				$LurkAudio.play()
				$LurkAudioCD.start(randi_range(5,15))
			var distance = abs(global_position.distance_to(player.global_position))
			if distance > 80:
				velocity = velocity + ((steering_force * sharp_turn) * delta)
				position += velocity * LURK_SPEED_MULT
			else:
				velocity = Vector2.ZERO

func _on_player_detection_body_entered(body):
	is_player_near = true 
	player = body
	state = States.LURK
	if !raycast_detection:
		raycast_detection = $RaycastDetection
		raycast_detection.enabled = true


func _on_player_detection_body_exited(body):
	is_player_near = false
	player = null
	raycast_detection.enabled = false
	raycast_detection = null


func _on_player_detection_area_entered(area):
	$WarningSprite.visible = false
	if can_jumpscare:
		can_jumpscare = false
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





func _on_lurk_audio_cd_timeout():
	playing_lurk_sound = false


func _on_attack_cd_timeout():
	can_attack = true
