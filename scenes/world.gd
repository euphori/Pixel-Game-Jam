extends Node2D

@onready var tilemap = $Tiles
@onready var player = $Player
@onready var quota_list = $UI/CanvasLayer/MarginContainer/HBoxContainer/Quota
@onready var meter_arrow = $UI/CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/MeterArrow
@onready var oxygen_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/OxygenLabel
@onready var health_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/HealthLabel
@onready var remote_sonar_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/RemoteSonarLabel
@onready var warning_animation_player = $UI/WarningAnimationPlayer



var oxygen
var quota_label = preload("res://scenes/quota_label.tscn")

var quota 
var player_near_exit = false
var curr_depth 
var quota_colors = []

func _ready():
	Global.reset_run_stats()
	quota = Global.generate_quota()
	Global.time_start = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
	
	
	tilemap.material.light_mode = 2
	for i in quota:
		if quota[i] > 0:
			var _quota_label = quota_label.instantiate()
			quota_list.add_child(_quota_label)
			quota_colors.append(_quota_label)
			_quota_label.name = i
			_quota_label.text = i
	Global.connect("item_added" ,update_quota )
	oxygen = Global.player_max_oxygen
	update_quota()

func _input(event):
	if event.is_action_pressed("interact") and player_near_exit:
		Global.time_end = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
		get_tree().change_scene_to_file("res://scenes/home_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	curr_depth = abs(int($StartingLocation.global_position.y - player.global_position.y) / 10)
	#print(curr_depth)
	meter_arrow.position.y = max(1,32 * curr_depth / 50)
	if curr_depth > Global.max_depth:
		Global.max_depth = curr_depth
	oxygen -= 0.4 * delta
	oxygen_label.text = str("Oxygen: " , int(oxygen), "%")
	if oxygen <= 25 and !warning_animation_player.current_animation == null:
		warning_animation_player.play("oxygen_warning")
	elif oxygen <= 0:
		pass
	else:
		warning_animation_player.stop()
		$UI/CanvasLayer/MarginContainer/VBoxContainer2/Panel/OxygenWarningLabel.visible = false
	

func update_quota():
	#if data == "green":
		##why does this add 2?
		#Global.inventory["green"] += 1
	#elif data == "red":
		##why does this add 2?
		#Global.inventory["red"] += 1
		#
	print("Inventory: ", Global.inventory)
	for label in quota_colors:
		label.text = str( Global.inventory[label.name],"/",quota[label.name], " ", label.name)

func _on_exit_body_entered(body):
	player_near_exit = true
