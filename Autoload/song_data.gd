extends Node

## If this indicator is used in a __data variable for an action command, the player's property will be used 
const __indicator_ACCORDING_TO_PLAYER := -27
## Indicates that the final position {x, y} must be equal to the initial position {x, y}
const __indicator_FINPOS_INITPOS_EQ := -35

var sec_per_beat := 60.0 / Funcs.__BPM_FireEmblem

var __data_RANDOMPOS_FALLING_NODE := [
	[100, Funcs.__DEFAULT_VIEWPORT_RECT.x - 100], [100, 200],
	__indicator_FINPOS_INITPOS_EQ, Funcs.__DEFAULT_VIEWPORT_RECT.y,
	60.0 / Funcs.__BPM_FireEmblem,
	2,
	2,
	.3,
	.1]
var __data_PlayerXPOS_FALLING_NODE := [
	__indicator_ACCORDING_TO_PLAYER, [100, 200],
	__indicator_FINPOS_INITPOS_EQ, Funcs.__DEFAULT_VIEWPORT_RECT.y,
	60.0 / Funcs.__BPM_FireEmblem,
	2,
	2,
	.3,
	.1]
var __data_PlayerYPOS_SCROLLING_NODE_LR := [
	[100, 200], __indicator_ACCORDING_TO_PLAYER,
	Funcs.__DEFAULT_VIEWPORT_RECT.x, __indicator_FINPOS_INITPOS_EQ,
	60.0 / Funcs.__BPM_FireEmblem,
	2,
	4,
	.3,
	.1,
	deg_to_rad(90),
	'horizontal']
var __data_PlayerYPOS_SCROLLING_NODE_RL := [
	[Funcs.__DEFAULT_VIEWPORT_RECT.x - 100, Funcs.__DEFAULT_VIEWPORT_RECT.x - 200], __indicator_ACCORDING_TO_PLAYER,
	0, __indicator_FINPOS_INITPOS_EQ,
	60.0 / Funcs.__BPM_FireEmblem,
	2,
	4,
	.3,
	.1,
	deg_to_rad(-90),
	'horizontal']

var __data_RANDOMPOS_FALLING_NODE_WIDE := [
	[200, Funcs.__DEFAULT_VIEWPORT_RECT.x - 200], 100,
	__indicator_FINPOS_INITPOS_EQ, Funcs.__DEFAULT_VIEWPORT_RECT.y,
	60.0 / Funcs.__BPM_FireEmblem,
	3,
	4,
	.3,
	.1]
var __data_RANDOMPOS_SCROLLING_NODE_WIDE_LR := [
	100, [Funcs.__DEFAULT_VIEWPORT_RECT.y + 250, Funcs.__DEFAULT_VIEWPORT_RECT.y + 125],
	Funcs.__DEFAULT_VIEWPORT_RECT.x, __indicator_FINPOS_INITPOS_EQ,
	60.0 / Funcs.__BPM_FireEmblem,
	4,
	8,
	.3,
	.1,
	deg_to_rad(90)]
var __data_RANDOMPOS_SCROLLING_NODE_WIDE_RL := [
	Funcs.__DEFAULT_VIEWPORT_RECT.x - 100, [Funcs.__DEFAULT_VIEWPORT_RECT.y + 250, Funcs.__DEFAULT_VIEWPORT_RECT.y + 125],
	0, __indicator_FINPOS_INITPOS_EQ,
	60.0 / Funcs.__BPM_FireEmblem,
	4,
	8,
	.3,
	.1,
	deg_to_rad(90)]


var __data_PlayerPOS_FLYING_PROJ := [
	[100, Funcs.__DEFAULT_VIEWPORT_RECT.x - 100], [100, 200],
	__indicator_ACCORDING_TO_PLAYER, __indicator_ACCORDING_TO_PLAYER, #Funcs.__DEFAULT_VIEWPORT_RECT.y,
	2,
	2,
	deg_to_rad(180)]

var __data_APPLE_RANDOMPOS := [
	'apple', 
	[100, Funcs.__DEFAULT_VIEWPORT_RECT.x - 100], 
	[Funcs.__DEFAULT_VIEWPORT_RECT.y - 300, Funcs.__DEFAULT_VIEWPORT_RECT.y - 100]]

var __data_CAMERA_ZOOM1_025_4s := [1.025, Vector2(0, 0), 4]
var __data_CAMERA_ZOOM1_050_8s := [1.05, Vector2(0, 0), 8]

## The main component of storing action commands according to given beat number;
## Each action command is stored as an integer or as an interval;
## Each element of the value array is structured as [beat_no / beat_interval, object_data_array]
var ACTION_DICTIONARY: Dictionary = {
	'camera_zoom': [
		#[7, __data_CAMERA_ZOOM1_025], [15, __data_CAMERA_ZOOM1_025], [23, __data_CAMERA_ZOOM1_025], [31, __data_CAMERA_ZOOM1_025], [39, __data_CAMERA_ZOOM1_025], 
		[1, __data_CAMERA_ZOOM1_025_4s], [[staticIntInterval.new(7, 39), 8, true], __data_CAMERA_ZOOM1_025_4s],
		[[staticIntInterval.new(47, 59), 2], __data_CAMERA_ZOOM1_025_4s], [[staticIntInterval.new(63, 86), 2], __data_CAMERA_ZOOM1_025_4s],
		[[staticIntInterval.new(143, 195), 4, true], __data_CAMERA_ZOOM1_025_4s],
		[199, __data_CAMERA_ZOOM1_050_8s],
		[[staticIntInterval.new(263, 331), 4, true], __data_CAMERA_ZOOM1_025_4s],
	],
	
	'healing_item': [
		[[staticIntInterval.new(25, 225), 50, true], __data_APPLE_RANDOMPOS],
		[[staticIntInterval.new(270, 320), 15, true], __data_APPLE_RANDOMPOS]
	],
	
	'falling_body': [
		[[staticIntInterval.new(1, 40), 4, true], __data_RANDOMPOS_FALLING_NODE],
		[[staticIntInterval.new(47, 59), 8], randomArrayData.new([__data_PlayerYPOS_SCROLLING_NODE_LR, __data_PlayerYPOS_SCROLLING_NODE_RL])],
		[[staticIntInterval.new(63, 86), 8], randomArrayData.new([__data_PlayerYPOS_SCROLLING_NODE_LR, __data_PlayerYPOS_SCROLLING_NODE_RL])],
		[88, [150, Funcs.__DEFAULT_VIEWPORT_RECT.y - 75, Funcs.__DEFAULT_VIEWPORT_RECT.x, __indicator_FINPOS_INITPOS_EQ, 60.0 / Funcs.__BPM_FireEmblem, 3, 4, .3, .1, deg_to_rad(90)]],
		[91, [150, Funcs.__DEFAULT_VIEWPORT_RECT.y - 150, Funcs.__DEFAULT_VIEWPORT_RECT.x, __indicator_FINPOS_INITPOS_EQ, 60.0 / Funcs.__BPM_FireEmblem, 3, 4, .3, .1, deg_to_rad(90)]],
		[88, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 150, Funcs.__DEFAULT_VIEWPORT_RECT.y - 75, 0, __indicator_FINPOS_INITPOS_EQ, 60.0 / Funcs.__BPM_FireEmblem, 3, 4, .3, .1, deg_to_rad(-90)]],
		[91, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 150, Funcs.__DEFAULT_VIEWPORT_RECT.y - 150, 0, __indicator_FINPOS_INITPOS_EQ, 60.0 / Funcs.__BPM_FireEmblem, 3, 4, .3, .1, deg_to_rad(-90)]],
		
		[[staticIntInterval.new(95, 139), 4, true], randomArrayData.new([__data_PlayerYPOS_SCROLLING_NODE_LR, __data_PlayerYPOS_SCROLLING_NODE_RL])],
		[[staticIntInterval.new(199, 223), 2, true], __data_RANDOMPOS_FALLING_NODE],
		[[staticIntInterval.new(227, 228), 1.0/3], __data_RANDOMPOS_FALLING_NODE],
		[227, __data_PlayerYPOS_SCROLLING_NODE_LR], [228, __data_PlayerYPOS_SCROLLING_NODE_RL],
		
		[[staticIntInterval.new(159, 198), 4, true], randomArrayData.new([__data_PlayerYPOS_SCROLLING_NODE_LR, __data_PlayerYPOS_SCROLLING_NODE_RL])],
		[[staticIntInterval.new(159, 198), 4, true], __data_RANDOMPOS_FALLING_NODE],
		[[staticIntInterval.new(231, 258), 2, true], __data_RANDOMPOS_FALLING_NODE],
		
		[[staticIntInterval.new(263, 321), 2, true], __data_RANDOMPOS_FALLING_NODE],
		[[staticIntInterval.new(331, Funcs.__LAST_BEAT_FireEmblem), 4, true], __data_RANDOMPOS_FALLING_NODE],
		
		[351, __data_PlayerYPOS_SCROLLING_NODE_LR],
		[352, __data_PlayerYPOS_SCROLLING_NODE_RL],
		
	],
	
	'flying_projectile' : [
		[23, __data_PlayerPOS_FLYING_PROJ], [31, __data_PlayerPOS_FLYING_PROJ], [39, __data_PlayerPOS_FLYING_PROJ],
		[[staticIntInterval.new(47, 59), 4], __data_PlayerPOS_FLYING_PROJ],
		[[staticIntInterval.new(63, 80), 4], __data_PlayerPOS_FLYING_PROJ],
		
		## Static attack
		[84, [150, 150, 500, Funcs.__DEFAULT_VIEWPORT_RECT.y, 6, 2, deg_to_rad(270)]],
		[85, [300, 150, 750, Funcs.__DEFAULT_VIEWPORT_RECT.y, 6, 2, deg_to_rad(270)]], 
		[86, [450, 150, 1000, Funcs.__DEFAULT_VIEWPORT_RECT.y, 7, 2, deg_to_rad(270)]], 
		[87, [600, 150, 1250, Funcs.__DEFAULT_VIEWPORT_RECT.y, 7, 2, deg_to_rad(270)]], 
		[84, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 150, 150, Funcs.__DEFAULT_VIEWPORT_RECT.x - 500, Funcs.__DEFAULT_VIEWPORT_RECT.y, 6, 2, deg_to_rad(270)]],
		[85, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 300, 150, Funcs.__DEFAULT_VIEWPORT_RECT.x - 750, Funcs.__DEFAULT_VIEWPORT_RECT.y, 6, 2, deg_to_rad(270)]],
		[86, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 450, 150, Funcs.__DEFAULT_VIEWPORT_RECT.x - 1000, Funcs.__DEFAULT_VIEWPORT_RECT.y, 7, 2, deg_to_rad(270)]],
		[87, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 600, 150, Funcs.__DEFAULT_VIEWPORT_RECT.x - 1250, Funcs.__DEFAULT_VIEWPORT_RECT.y, 7, 2, deg_to_rad(270)]],
		
		[115, __data_PlayerPOS_FLYING_PROJ], [116, __data_PlayerPOS_FLYING_PROJ], 
		
		[242, [150, 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[243, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 150, 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[244, [Funcs.__DEFAULT_VIEWPORT_RECT.x / 2, 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[258, [150, 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[259, [Funcs.__DEFAULT_VIEWPORT_RECT.x / 2, 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[260, [Funcs.__DEFAULT_VIEWPORT_RECT.x - 150, 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		
		[137, __data_PlayerPOS_FLYING_PROJ], [139, __data_PlayerPOS_FLYING_PROJ], [140, __data_PlayerPOS_FLYING_PROJ],
		
		[[staticIntInterval.new(181, 185), 2, true], __data_PlayerPOS_FLYING_PROJ],
		[189, __data_PlayerPOS_FLYING_PROJ],
		[[staticIntInterval.new(192, 196), 1], __data_PlayerPOS_FLYING_PROJ],
		
		[[staticIntInterval.new(289, 292), 1], __data_PlayerPOS_FLYING_PROJ],
		[[staticIntInterval.new(321, 321), .25], [[Funcs.__DEFAULT_VIEWPORT_RECT.x - 450, Funcs.__DEFAULT_VIEWPORT_RECT.x - 150], 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[[staticIntInterval.new(323, 323), .25], [[150, 450], 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		[[staticIntInterval.new(325, 328), .25], [[Funcs.__DEFAULT_VIEWPORT_RECT.x / 2 - 100, Funcs.__DEFAULT_VIEWPORT_RECT.x / 2 + 100], 150, __indicator_ACCORDING_TO_PLAYER, Funcs.__DEFAULT_VIEWPORT_RECT.y, 2, 2, deg_to_rad(270)]],
		
		[373, __data_PlayerPOS_FLYING_PROJ], [375, __data_PlayerPOS_FLYING_PROJ], [376, __data_PlayerPOS_FLYING_PROJ],
		
	],
	
	'wide_falling_body': [
		[[staticIntInterval.new(96, 143), 8], __data_RANDOMPOS_FALLING_NODE_WIDE],
		[[staticIntInterval.new(263, 327), 8, true], __data_RANDOMPOS_FALLING_NODE_WIDE],
		
		[[staticIntInterval.new(143, 198), 8, true], randomArrayData.new([__data_RANDOMPOS_SCROLLING_NODE_WIDE_LR, __data_RANDOMPOS_SCROLLING_NODE_WIDE_RL])],
		[[staticIntInterval.new(267, 327), 8, true], randomArrayData.new([__data_RANDOMPOS_SCROLLING_NODE_WIDE_LR, __data_RANDOMPOS_SCROLLING_NODE_WIDE_RL])]
		
	]
}


func find_action_by_beat_no(beat_no: int) -> Array:
	var ret_arr: Array = []
	var values: Array = ACTION_DICTIONARY.values()
	
	for val_arr in values:
		for elem_arr in val_arr:
			var elem = elem_arr[0]
			var data_arr = elem_arr[1]
			
			## Check directly for beat_no or if it's inside an interval
			if (elem is Array and elem[0] is staticIntInterval and elem[0].is_inside(beat_no)):
				if elem is Array and elem[1] is int or elem[1] is float:
					
					if len(elem) > 2 and elem[2] == true: ## If actions are meant to fire at beat: minimumOfInterval + k*beat, k = {1,2,3...}
						if (beat_no - elem[0].get_left_end()) % elem[1] == 0: ## Second if for clarity (/j)
							var action: String = ACTION_DICTIONARY.keys()[ACTION_DICTIONARY.values().find(val_arr)]
							var times_per_sec_beat: float = elem[1]
							var iter_count: int = 1
							
							if (1.0 / times_per_sec_beat > 1): 
								iter_count = int(1.0 / times_per_sec_beat)
							
							## Check for randomized data_arrays
							if data_arr is randomArrayData: 
								data_arr = data_arr.select_random() # Obtain a randomly selected element from array data
							
							ret_arr.push_back([action, data_arr, iter_count])
					elif elem[1] is float or (beat_no % elem[1] == 0):
						var action: String = ACTION_DICTIONARY.keys()[ACTION_DICTIONARY.values().find(val_arr)]
						var times_per_sec_beat: float = elem[1]
						var iter_count: int = 1
						
						if (1.0 / times_per_sec_beat > 1): 
							iter_count = int(1.0 / times_per_sec_beat)
						
						## Check for randomized data_arrays
						if data_arr is randomArrayData: 
							data_arr = data_arr.select_random() # Obtain a randomly selected element from array data
						
						ret_arr.push_back([action, data_arr, iter_count])
			
			elif elem is int and elem == beat_no:
				var action: String = ACTION_DICTIONARY.keys()[ACTION_DICTIONARY.values().find(val_arr)]
				
				## Check for randomized data_arrays
				if data_arr is randomArrayData: 
					data_arr = data_arr.select_random() # Obtain a randomly selected element from array data
				
				ret_arr.push_back([action, data_arr, 1])
	
	return ret_arr
