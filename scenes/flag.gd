extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_detection_area_entered(area):
	#$Indicator.visible = false
	pass


func _on_player_detection_area_exited(area):
	$Indicator.visible = true
