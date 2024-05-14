extends PointLight2D

@export_category("Options")
@export var remove_after_timeout = true
@export var timer_length = 2
@export var limited_sonar = true

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AudioStreamPlayer2D.play()
	$Timer.start(timer_length)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if remove_after_timeout:
		queue_free()
