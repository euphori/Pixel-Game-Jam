extends VBoxContainer

@onready var time_result_label = $VBoxContainer/TimeContainer/TimeResultLabel
@onready var max_depth_label = $VBoxContainer/MaxDepthContainer/MaxDepthLabel
@onready var quota_result_label = $VBoxContainer/QuotaContainer/QuotaResultLabel
@onready var gold_earned_label = $VBoxContainer/EarnedContainer/GoldEarnedLabel
@onready var mineral_container = $VBoxContainer/ExtraMinerals/MineralContainer
@onready var extra_minerals = $VBoxContainer/ExtraMinerals
@onready var time_container = $VBoxContainer/TimeContainer
@onready var max_depth_container = $VBoxContainer/MaxDepthContainer
@onready var quota_container = $VBoxContainer/QuotaContainer
@onready var earned_container = $VBoxContainer/EarnedContainer


@onready var sfx = $"../../../SFX"


var elapsed_time
@onready var extra_mineral = {
	"white" : 0,
	"green" : 0,
	"blue" : 0,
	"orange" : 0,
	"purple" : 0
}

@onready var mineral_icons = {
	"white" : $VBoxContainer/ExtraMinerals/MineralContainer/WhiteIcon,
	"green" : $VBoxContainer/ExtraMinerals/MineralContainer/GreenIcon,
	"blue" : $VBoxContainer/ExtraMinerals/MineralContainer/BlueIcon,
	"purple" : $VBoxContainer/ExtraMinerals/MineralContainer/PurpleIcon,
	"orange" : $VBoxContainer/ExtraMinerals/MineralContainer/OrangeIcon
}
var gold_earned = 0
var quota_completed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	elapsed_time = Global.time_end - Global.time_start 
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	time_result_label.text = str(str(minutes).pad_zeros(2), ":",str(seconds).pad_zeros(2))
	max_depth_label.text = str(Global.max_depth, "m")
	gold_earned_label.text = str(gold_earned)
	initialize_screen()
	#for i in mineral_container.get_children():
		#i.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func check_quota():
	for i in Global.curr_quota:
		if  !Global.inventory[i] >= Global.curr_quota[i]:
			quota_completed = false
			return
		else:
			extra_mineral[i] += Global.inventory[i] - Global.curr_quota[i]
			Global.inventory[i] = 0
	gold_earned += 100
	quota_completed = true


func calc_extra_mineral():
	for mineral in extra_mineral:
		for i in extra_mineral[mineral]:
			match mineral:
				"white" : 
					gold_earned += 10 * extra_mineral["white"]
				"green" : 
					gold_earned += 25 * extra_mineral["green"]
				"blue" : 
					gold_earned += 50 * extra_mineral["blue"]
				"orange" : 
					gold_earned += 200 * extra_mineral["orange"]
				"purple" : 
					gold_earned += 100 * extra_mineral["orange"]
				
			var icon = mineral_icons[mineral].duplicate()
			icon.show()
			mineral_container.add_child(icon)
			sfx.stream = load("res://assets/sounds/sfx/beep-6-96243.mp3")
			sfx.play()
			await get_tree().create_timer(0.25).timeout
			

func show_container():
	sfx.stream = load("res://assets/sounds/sfx/click-button-140881.mp3")
	sfx.play()
	await get_tree().create_timer(0.50).timeout
	
	
func initialize_screen():
	time_container.visible = true
	await show_container()
	max_depth_container.visible = true
	await show_container()
	check_quota()
	quota_result_label.text = "completed" if quota_completed else "failed"
	quota_container.visible = true
	await show_container()
	$VBoxContainer/ExtraLabel.visible = true
	extra_minerals.visible = true
	calc_extra_mineral()
	await show_container()
	gold_earned_label.text = str(gold_earned)
	earned_container.show()
	sfx.stream = load("res://assets/sounds/sfx/coin-donation-2-180438.mp3")
	sfx.play()
	$ContinueButton.show()
	Global.money += gold_earned if quota_completed else 0
