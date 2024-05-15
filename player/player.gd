extends CharacterBody2D


const SPEED = 75.0
const JUMP_VELOCITY = -400.0

var remote_sonar_charge = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sonar = preload("res://scenes/sonar_light.tscn")

@onready var cd_bar = $"../UI/CanvasLayer/MarginContainer/VBoxContainer2/ProgressBar"
@onready var remote_charge_label = $"../UI/CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/RemoteChargeLabel"

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if cd_bar.value < 100:
		cd_bar.value += 50 * delta
	if Input.is_action_just_pressed("sonar") and cd_bar.value >= 100:
		scan_area(false)
	if Input.is_action_just_pressed("remote_sonar") and remote_sonar_charge > 0:
		remote_sonar_charge -= 1
		scan_area(true)
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



func scan_area(is_remote):
	var existing_sonar = get_tree().get_nodes_in_group("sonar")
	#for i in existing_sonar:
		#i.queue_free()
	var _sonar = sonar.instantiate()
	_sonar.global_position = self.global_position
	_sonar.player = self
	if !is_remote:
		cd_bar.value = 0
	else:
		_sonar.remove_after_timeout = false
		remote_charge_label.text = str("Remote Sensor: ", remote_sonar_charge)
	get_parent().add_child(_sonar) 
	_sonar.get_node("AnimationPlayer").play("trigger_sonar")




