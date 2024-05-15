extends Control

@onready var result_screen = $CanvasLayer/MarginContainer/ResultScreen
@onready var upgrade_screen = $CanvasLayer/MarginContainer/UpgradeScreen


func _ready():
	result_screen.visible = true
	upgrade_screen.visible = false
	
	$CanvasLayer/MarginContainer/ResultScreen/VBoxContainer/Mineral/ResultLabel.text = str(Global.inventory["red"]/2)
	$CanvasLayer/MarginContainer/ResultScreen/VBoxContainer/Mineral2/ResultLabel.text = str(Global.inventory["blue"]/2)
	$CanvasLayer/MarginContainer/ResultScreen/VBoxContainer/Mineral3/ResultLabel.text = str(Global.inventory["green"]/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_button_pressed():
	result_screen.visible = false
	upgrade_screen.visible = true


func _on_skip_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
