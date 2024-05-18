extends VBoxContainer

@onready var time_result_label = $VBoxContainer/Time/TimeResultLabel
@onready var max_depth_label = $VBoxContainer/MaxDepth/MaxDepthLabel
@onready var quota_result_label = $VBoxContainer/Quota/QuotaResultLabel
@onready var extra_red_label = $VBoxContainer/RedMineral/ExtraRedLabel
@onready var extra_blue_label = $VBoxContainer/BlueMineral/ExtraBlueLabel
@onready var extra_green_label = $VBoxContainer/GreenMineral/ExtraGreenLabel
@onready var gold_earned_label = $VBoxContainer/Earned/GoldEarnedLabel


var elapsed_time
@onready var extra_mineral = {
	"green" : 0,
	"red": 0,
	"blue" : 0
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
	check_quota()
	quota_result_label.text = "completed" if quota_completed else "failed"
	calc_extra_mineral()
	gold_earned_label.text = str(gold_earned)
	Global.money += gold_earned if quota_completed else 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func check_quota():
	for i in Global.curr_quota:
		if  !Global.inventory[i] >= Global.curr_quota[i]:
			hide_extra_labels()
			quota_completed = false
			return
		else:
			extra_mineral[i] += Global.inventory[i] - Global.curr_quota[i]
			Global.inventory[i] = 0
	gold_earned += 100

	quota_completed = true


func calc_extra_mineral():
	for mineral in extra_mineral:
		match mineral:
			"red":
				gold_earned += 100 * extra_mineral["red"]
			"blue":
				gold_earned += 50 * extra_mineral["blue"]
			"green":
				gold_earned += 25 * extra_mineral["green"]
	extra_blue_label.text = str(extra_mineral["blue"])
	extra_red_label.text = str(extra_mineral["red"])
	extra_green_label.text = str(extra_mineral["green"])

func hide_extra_labels():
	$VBoxContainer/ExtraLabel.visible = false
	$VBoxContainer/RedMineral.visible = false
	$VBoxContainer/BlueMineral.visible = false
	$VBoxContainer/GreenMineral.visible = false
