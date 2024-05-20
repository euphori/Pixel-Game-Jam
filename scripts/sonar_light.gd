extends PointLight2D

@export_category("Options")
@export var remove_after_timeout = true
@export var timer_length = 2
@export var limited_sonar = true

var player 
var ripple = preload("res://scenes/ripple.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointLight2D.visible = false
	if remove_after_timeout:
		$Sprite2D.visible = false
	
	var _ripple = ripple.instantiate()
	#_ripple.global_position = self.global_position
	add_child(_ripple)
	$Timer.start(timer_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !remove_after_timeout:
		pass
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
		var _ripple = ripple.instantiate()
		#_ripple.global_position = self.global_position
		add_child(_ripple)
		$Sprite2D.visible = true
		$RemoteAnimationPlayer.play("beep")
