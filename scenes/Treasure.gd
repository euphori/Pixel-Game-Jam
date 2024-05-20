extends Sprite2D

var player_near
var drop = preload("res://scenes/drop.tscn")



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_detection_body_entered(body):
	player_near = true
	frame = 1
	Global.money = 100000
	for i in 500:
		await get_tree().create_timer(randf_range(0.025,.05)).timeout
		var _drop = drop.instantiate()
		_drop.color = Color.GOLD
		_drop.global_position = global_position
		get_tree().get_root().add_child(_drop)


func _on_player_detection_body_exited(body):
	player_near = false
