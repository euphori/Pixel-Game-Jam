extends StaticBody2D

var is_player_near = false
@export var text = "harvest(e)"
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.visible =  is_player_near
	if Input.is_action_just_pressed("interact"):
		queue_free()


func _on_player_detection_body_entered(body):
	is_player_near = true


func _on_player_detection_body_exited(body):
	is_player_near = false
