extends Node


#region player stats
var player_max_oxygen = 100
var player_max_hp = 100
#endregion

var curr_difficulty = 3

var max_depth = 0
var time_start = 0
var time_end = 0

var inventory = {
	"red" : 0,
	"blue" : 0,
	"green" : 0
}
var money = 100
var curr_quota

signal item_added



func generate_quota():
	#index 0-red,1-blue, 2-green
	var mineral_value = [4,2,1]
	#amount of minerals given to the quota
	var quota = {
		"red": 0,
		"blue": 0,
		"green" : 0
	}
	# algo that decides randomly what color to require based on diffculty
	var diff_val = curr_difficulty
	while diff_val > 0:
		var rng = randi_range(0,2)
		
		if (diff_val - mineral_value[rng]) >= 0:
			diff_val = diff_val - mineral_value[rng]
			quota[quota.keys()[rng]] += 1
	
	curr_quota = quota
	return quota
		
		
func reset_run_stats():
	inventory = {
	"red" : 0,
	"blue" : 0,
	"green" : 0
	}
	max_depth = 0
	time_start = 0
	time_end = 0
