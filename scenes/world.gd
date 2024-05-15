extends Node2D

@onready var tilemap = $Tiles
@onready var meter_label = $UI/CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/MeterLabel
@onready var player = $Player
@onready var oxygen_bar = $UI/CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/OxygenProgressBar
@onready var quota_list = $UI/CanvasLayer/MarginContainer/HBoxContainer/QuotaList
var quota_label = preload("res://scenes/quota_label.tscn")

var quota = {
	"red" : 1,
	"green" : 1
}
var player_near_exit = false

var quota_colors = []

func _ready():
	tilemap.material.light_mode = 2
	for i in quota:
		if quota[i] > 0:
			var _quota_label = quota_label.instantiate()
			quota_list.add_child(_quota_label)
			quota_colors.append(_quota_label)
			_quota_label.name = i
			_quota_label.text = i
	Global.connect("item_added" ,update_quota )
	update_quota()
	

func _input(event):
	if event.is_action_pressed("interact") and player_near_exit:
		get_tree().change_scene_to_file("res://scenes/home_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	meter_label.text = str(abs(int($StartingLocation.global_position.y - player.global_position.y) / 15) ,"m")
	oxygen_bar.value -= 0.4 * delta
	

func update_quota():
	for label in quota_colors:
		label.text = str(label.name , " ", Global.inventory[label.name],"/",quota[label.name])


func _on_exit_body_entered(body):
	player_near_exit = true
