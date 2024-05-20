extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Instructions.visible = false
	$CanvasLayer/Menu.visible = true
	$CanvasLayer/Settings.visible = false
	$CanvasLayer/Sprite2D.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_play_button_pressed():
	$CanvasLayer/Cover2.visible = false
	$CanvasLayer/Instructions.visible = true
	$CanvasLayer/Menu.visible = false
	


func _on_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)


func _on_settings_back_button_pressed():
	$CanvasLayer/Instructions.visible = false
	$CanvasLayer/Menu.visible = true
	$CanvasLayer/Settings.visible = false
	$CanvasLayer/Cover2.visible = true

func _on_settings_button_pressed():
	$CanvasLayer/Cover2.visible = false
	$CanvasLayer/Instructions.visible = false
	$CanvasLayer/Menu.visible = false
	$CanvasLayer/Settings.visible = true


func _on_exit_button_pressed():
	get_tree().quit()
