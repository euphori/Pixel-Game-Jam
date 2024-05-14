extends Node2D

@onready var tilemap = $Tiles



func _ready():
	tilemap.material.light_mode = 2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
