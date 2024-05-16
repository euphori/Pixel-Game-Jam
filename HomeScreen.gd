extends Control

@onready var result_screen = $CanvasLayer/ResultContainer
@onready var upgrade_screen = $CanvasLayer/UpgradeContainer


func _ready():
	result_screen.visible = true
	upgrade_screen.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_button_pressed():
	result_screen.visible = false
	upgrade_screen.visible = true



func _on_upgrade_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
