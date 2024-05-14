extends Node2D

@onready var tilemap = $Tiles
@onready var meter_label = $UI/CanvasLayer/MarginContainer/VBoxContainer/MeterLabel
@onready var player = $Player


func _ready():
	tilemap.material.light_mode = 2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	meter_label.text = str(abs(int($StartingLocation.global_position.y - player.global_position.y) / 25) ,"m")
