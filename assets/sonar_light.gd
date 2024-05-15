extends PointLight2D

@export_category("Options")
@export var remove_after_timeout = true
@export var timer_length = 2
@export var limited_sonar = true

var player 

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointLight2D.visible = false
	if remove_after_timeout:
		$Sprite2D.visible = false
	$Timer.start(timer_length)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(global_position.distance_to(player.global_position))
	if global_position.distance_to(player.global_position) > 400:
		$Beep.volume_db = -20
	elif global_position.distance_to(player.global_position) > 300:
		$Beep.volume_db = -15
	elif global_position.distance_to(player.global_position) > 200:
		$Beep.volume_db = -10
	elif global_position.distance_to(player.global_position) > 100:
		$Beep.volume_db = -5
	else:
		$Beep.volume_db = 0

func _on_timer_timeout():
	
	if remove_after_timeout:
		queue_free()
	else:
		$Sprite2D.visible = true
		$RemoteAnimationPlayer.play("beep")
