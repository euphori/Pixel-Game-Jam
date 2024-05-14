extends CharacterBody2D


const SPEED = 75.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sonar = preload("res://scenes/sonar_light.tscn")

@onready var cd_bar = $"../UI/CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar"

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if cd_bar.value < 100:
		cd_bar.value += 50 * delta
	if Input.is_action_just_pressed("sonar") and cd_bar.value >= 100:
		scan_area()
		
	var xdirection = Input.get_axis("movement_left", "movement_right")
	var ydirection = Input.get_axis("movement_up", "movement_down")
	if xdirection || ydirection:
		if velocity.x >= 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		velocity.x = xdirection * SPEED
		velocity.y = ydirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)


	move_and_slide()



func scan_area():
	cd_bar.value = 0
	print(cd_bar.value)
	var existing_sonar = get_tree().get_nodes_in_group("sonar")
	#for i in existing_sonar:
		#i.queue_free()
	var _sonar = sonar.instantiate()
	_sonar.global_position = self.global_position
	get_parent().add_child(_sonar) 
	_sonar.get_node("AnimationPlayer").play("trigger_sonar")




