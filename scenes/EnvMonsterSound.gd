extends Node2D

@export var time_before_trigger = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(time_before_trigger)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	#$AudioStreamPlayer2D.play()
	pass

func _on_player_detection_body_entered(body):
	$AudioStreamPlayer2D.play()
	queue_free()
