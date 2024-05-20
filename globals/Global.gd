extends Node

var first_time = true
#region player stats
var stats = {
	"oxygen": {
		"value": 100,
		"up_price": 250,
		"next_value": 110,
	},
	"hp": {
		"value": 100,
		"up_price": 250,
		"next_value": 110,
	},
	"remote_sonar": {
		"charge": 3,
		"next_charge": 4,
		"range": 0,
		"next_range": 10,
		"up_price": 250,
	},
	"speed_coefficient": {
		"value": 0,
		"up_price": 250,
		"next_value": 5,
	},
	"flag_count": {
		"value": 10,
		"up_price": 250,
		"next_value": 11,
	},
}




#endregion

var curr_mode = "main"
var curr_difficulty = 1

var max_depth = 0
var time_start = 0
var time_end = 0

var inventory = {
	"white" : 0,
	"green" : 0,
	"blue" : 0,
	"orange" : 0,
	"purple" : 0
}

var money = 1000
var curr_quota

signal item_added
signal flag_placed



func generate_quota():
	#index 0-red,1-blue, 2-green
	var mineral_value = [1,2,3,8,5]
	#amount of minerals given to the quota
	var quota = {
		"white" : 0,
		"green" : 0,
		"blue" : 0,
		"orange" : 0,
		"purple" : 0
	}
	# algo that decides randomly what color to require based on diffculty
	var diff_val = min(3 * curr_difficulty, 25)
	while diff_val > 0:
		var rng = randi_range(0,4)
		if (diff_val - mineral_value[rng]) >= 0:
			if !quota[quota.keys()[rng]] > 3:
				diff_val = diff_val - mineral_value[rng]
				quota[quota.keys()[rng]] += 1
			
	print(quota)
	curr_quota = quota
	return quota
		
		
func reset_run_stats():
	inventory = {
	"white" : 0,
	"green" : 0,
	"blue" : 0,
	"orange" : 0,
	"purple" : 0
	}
	max_depth = 0
	time_start = 0
	time_end = 0
