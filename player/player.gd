extends CharacterBody2D


const SPEED = 75.0
const JUMP_VELOCITY = -400.0

@onready var remote_sonar_charge = Global.stats["remote_sonar"]["charge"]
@onready var flag_charge = Global.stats["flag_count"]["value"]
@onready var health = Global.stats["hp"]["value"]
@onready var speed_coefficient = Global.stats["speed_coefficient"]["value"]
@onready var max_oxygen = Global.stats["oxygen"]["value"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sonar = preload("res://scenes/sonar_light.tscn")
var flag = preload("res://scenes/flag.tscn")
var caution_played = false

@onready var cd_bar = $"../UI/CanvasLayer/MarginContainer/VBoxContainer2/ProgressBar"
@onready var remote_charge_label = $"../UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/RemoteSonarLabel"
@onready var flag_charge_label = $"../UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/FlagLabel"
@onready var health_label = $"../UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/HealthLabel"
@onready var glitch = $"../UI/CanvasLayer/Glitch"

var hurt_sound = preload("res://assets/sounds/sfx/grunt1-84540.mp3")


func _ready():
	remote_charge_label.text = str("Remote Sonar (r): ", remote_sonar_charge, "x")
	flag_charge_label.text = str("Flags (f): ", flag_charge, "x")


func _input(event):
	if event.is_action_pressed("flag"):
		if flag_charge > 0:
			place_flag()


func _physics_process(delta):
	# Add the gravity.
	if get_parent().name != "SampleWorld":
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
		velocity.x = xdirection * (SPEED + speed_coefficient)
		velocity.y = ydirection * (SPEED + speed_coefficient)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if abs(velocity.x) > 0:
		$AnimationPlayer.play("side")
	elif velocity.y > 0:
		$AnimationPlayer.play("up")
	elif velocity == Vector2.ZERO:
		$AnimationPlayer.play("up")
	
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
		remote_charge_label.text = str("Remote Sonar (R): ", remote_sonar_charge, "x")
	get_parent().add_child(_sonar) 
	_sonar.get_node("AnimationPlayer").play("trigger_sonar")


func place_flag():
	var _flag = flag.instantiate()
	_flag.global_position = global_position
	_flag.get_node("AnimationPlayer").play("bob")
	get_parent().add_child(_flag)
	Global.emit_signal("flag_placed")
	flag_charge -= 1
	flag_charge_label.text = str("Flag (F): " , flag_charge, "x")




func _on_player_hurtbox_area_entered(area):
	
	health -= randi_range(15,25)
	if health <= 25:
		caution_played = false
		glitch.visible = true
	$SFX.stream = hurt_sound
	$SFX.play()
	$BloodParticles.emitting = true
	health_label.text = str("Health: " , health,"%")
