extends Node2D

@onready var tilemap = $Tiles
@onready var player = $Player
@onready var quota_list = $UI/CanvasLayer/MarginContainer/HBoxContainer/Quota
@onready var meter_arrow = $UI/CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/MeterArrow
@onready var oxygen_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/OxygenLabel
@onready var health_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/HealthLabel
@onready var remote_sonar_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/RemoteSonarLabel
@onready var flag_label = $UI/CanvasLayer/MarginContainer/HBoxContainer/SystemInfo/FlagLabel
@onready var oxygen_warning_player = $UI/OxygenWarningPlayer
@onready var health_warning_player = $UI/HealthWarningPlayer
@onready var cave_generator = $ProcGenTiles/CaveGenerator

@onready var death_screen = $UI/CanvasLayer/DeathScreen



var oxygen
var quota_label = preload("res://scenes/quota_label.tscn")

var quota 
var player_near_exit = false
var curr_depth 
var quota_colors = []
var player_dead = false

func _ready():
	load_world()
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
	oxygen = Global.stats["oxygen"]["value"]
	update_quota()

func _input(event):
	if event.is_action_pressed("interact") and player_near_exit:
		Global.time_end = Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())
		get_tree().change_scene_to_file("res://scenes/home_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $StartingLocation.global_position.y - player.global_position.y > 0:
		curr_depth = 0
	else:
		curr_depth = abs(int($StartingLocation.global_position.y - player.global_position.y) / 10)
	meter_arrow.position.y = max(1,32 * curr_depth / 50)
	if curr_depth > Global.max_depth:
		Global.max_depth = curr_depth
	oxygen -= .40 * delta
	oxygen_label.text = str("Oxygen: " , int(oxygen), "%")
	if oxygen <= 25 and !oxygen_warning_player.is_playing():
		print("X")
		oxygen_warning_player.play("oxygen_warning")
		if !player.caution_played:
			player.get_node("CautionAudio").play()
			player.caution_played = true
	if player.health <= 25 and !health_warning_player.is_playing():
		health_warning_player.play("health_warning")
		if !player.caution_played:
			player.get_node("CautionAudio").play()
			player.caution_played = true
	if oxygen <= 0 and !player_dead or player.health <= 0 and !player_dead:
		player_dead = true
		death_screen.visible = true
		death_screen.get_node("AnimationPlayer").play("death")
	

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


func load_world():
	if Global.curr_mode == "explore" :
		tilemap.clear()
		cave_generator.generate_world()
	elif !cave_generator.active:
		cave_generator.tile_map.clear()



func _on_exit_body_entered(body):
	player_near_exit = true


func _on_death_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")


func _on_death_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_exit_body_exited(body):
	player_near_exit = false
