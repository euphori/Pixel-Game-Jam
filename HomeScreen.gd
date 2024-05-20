extends Control

@onready var result_screen = $CanvasLayer/ResultContainer
@onready var upgrade_screen = $CanvasLayer/UpgradeContainer
@onready var menu = $CanvasLayer/Menu

var purchase_sound = preload("res://assets/sounds/sfx/coin-donation-2-180438.mp3")
var bgm = [
	preload("res://assets/sounds/music/One Man Symphony - Wreckage (Free) - 04 A Different Kind Of Journey (Main Theme).mp3"),
	preload("res://assets/sounds/music/One Man Symphony - Wreckage (Free) - 08 Setting Out To Take A Step Forward (Exploration Theme 01).mp3"),
	preload("res://assets/sounds/music/One Man Symphony - Wreckage (Free) - 09 Isolation (Exploration Theme 02) - Loops.mp3")
	]

func _ready():
	result_screen.visible = true
	upgrade_screen.visible = false
	menu.visible = false
	$BGM.stream = bgm[randi_range(0,2)]
	$BGM.volume_db -= 18
	$BGM.play()
	#$CanvasLayer/MarginContainer/ResultScreen/VBoxContainer/Mineral/ResultLabel.text = str(Global.inventory["red"]/2)
	#$CanvasLayer/MarginContainer/ResultScreen/VBoxContainer/Mineral2/ResultLabel.text = str(Global.inventory["blue"]/2)
	#$CanvasLayer/MarginContainer/ResultScreen/VBoxContainer/Mineral3/ResultLabel.text = str(Global.inventory["green"]/2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_button_pressed():
	result_screen.visible = false
	upgrade_screen.visible = false
	menu.visible = true


func _on_upgrade_continue_button_pressed():
	result_screen.visible = false
	upgrade_screen.visible = false
	menu.visible = true


func update_upgrades():
	if upgrade_screen.visible:
		$SFX.stream = purchase_sound
		$SFX.play()
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade/Panel/Description.text = "Increases \nCharge {charge} > {next_charge}\nRange {range}% > {next_range}%".format(Global.stats["remote_sonar"])
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade/Cost.text = "{up_price}G".format(Global.stats["remote_sonar"])
	
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade2/Panel/Description.text = "Capacity {value} > {next_value}".format(Global.stats["oxygen"])
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade2/Cost.text = "{up_price}G".format(Global.stats["oxygen"])
	
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade3/Panel/Description.text = "{value} > {next_value}".format(Global.stats["speed_coefficient"])
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade3/Cost.text = "{up_price}G".format(Global.stats["speed_coefficient"])
	
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade4/Panel/Description.text = "HP {value} > {next_value}".format(Global.stats["hp"])
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade4/Cost.text = "{up_price}G".format(Global.stats["hp"])
	
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade5/Panel/Description.text = "Charge {value} > {next_value}".format(Global.stats["flag_count"])
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrade5/Cost.text = "{up_price}G".format(Global.stats["flag_count"])
	$CanvasLayer/UpgradeContainer/VBoxContainer/HBoxContainer2/MoneyLabel.text = str("MONEY: ", Global.money)

func _on_up_sonar_button_pressed():
	if Global.money >= Global.stats["remote_sonar"]["up_price"]:
		Global.money -= Global.stats["remote_sonar"]["up_price"]
		Global.stats["remote_sonar"]["up_price"] += 250
		Global.stats["remote_sonar"]["charge"] += 1
		Global.stats["remote_sonar"]["next_charge"] += 1
		Global.stats["remote_sonar"]["range"] += 10
		Global.stats["remote_sonar"]["next_range"] += 10
		update_upgrades()
		
	
func _on_up_oxygen_button_pressed():
	if Global.money >= Global.stats["oxygen"]["up_price"]:
		Global.money -= Global.stats["oxygen"]["up_price"]
		Global.stats["oxygen"]["up_price"] += 250
		Global.stats["oxygen"]["value"] += 10
		Global.stats["oxygen"]["next_value"] += 10
		update_upgrades()

func _on_up_speed_button_pressed():
	if Global.money >= Global.stats["speed_coefficient"]["up_price"]:
		Global.money -= Global.stats["speed_coefficient"]["up_price"]
		Global.stats["speed_coefficient"]["up_price"] += 250
		Global.stats["speed_coefficient"]["value"] += 5
		Global.stats["speed_coefficient"]["next_value"] += 5
		update_upgrades()

func _on_up_health_button_pressed():
	if Global.money >= Global.stats["hp"]["up_price"]:
		Global.money -= Global.stats["hp"]["up_price"]
		Global.stats["hp"]["up_price"] += 250
		Global.stats["hp"]["value"] += 10
		Global.stats["hp"]["next_value"] += 10
		update_upgrades()

func _on_up_flag_button_pressed():
	if Global.money >= Global.stats["flag_count"]["up_price"]:
		Global.money -= Global.stats["flag_count"]["up_price"]
		Global.stats["flag_count"]["up_price"] += 250
		Global.stats["flag_count"]["value"] += 1
		Global.stats["flag_count"]["next_value"] += 1
		update_upgrades()


func _on_play_main_button_pressed():
	Global.curr_mode = "main"
	Global.curr_difficulty = min(Global.curr_difficulty + 1,10)
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_browse_shop_button_pressed():
	result_screen.visible = false
	upgrade_screen.visible = true
	menu.visible = false
	update_upgrades()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_play_exploration_button_pressed():
	Global.curr_difficulty += 5
	Global.curr_mode = "explore"
	get_tree().change_scene_to_file("res://scenes/world.tscn")
