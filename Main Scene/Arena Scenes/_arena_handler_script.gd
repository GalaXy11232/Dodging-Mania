extends Node2D

const _SONG__FIRE_EMBLEM = preload("res://Songs/fire_emblem_-_untitled_tag_game_KLICKAUD.mp3")
const _SONG__TUTORIAL_PLACEHOLDER = preload("res://Songs/tutorial placeholder.mp3")

@onready var audio_system_node: AudioSystem = $"AudioSystem Node"
@onready var audio_stream_player: AudioStreamPlayer = $"AudioSystem Node/AudioStreamPlayer"

@onready var camera: Camera2D = $Camera
@onready var player: CharacterBody2D = get_node("Player")

@onready var hits_label: Label = $Hits

### === COMPONENT NODES === ###
@onready var song_entrance_node: Node = $"SongNameEntrance Node"
@onready var falling_object_node: FallingObject = $"FallingObject Node"
@onready var flying_projectile_node: FlyingProjectile = $"FlyingProjectile Node"
@onready var wide_falling_object_node: WideFallingBody = $"WideFallingObject Node"
@onready var health_object_spawn_node: HealthObjectSpawn = $"HealthObjectSpawn Node"

var hits: int = 0
var sec_per_beat: float

func _ready() -> void:
	camera.global_position = player.global_position
	camera.zoom = Funcs.__INIT_ZOOMED_CAMERA
	
	hits = 0
	hits_label.text = "Got hit 0 times!"
	
	## Setup sec_per_beat based on song name
	match Funcs.track_name.to_lower():
		'tutorial':
			sec_per_beat = 60.0 / Funcs.__BPM_Tutorial
			audio_system_node.track_name = 'Tutorial'
			audio_system_node.BPM = Funcs.__BPM_Tutorial
			audio_stream_player.stream = _SONG__TUTORIAL_PLACEHOLDER
			
		'fire emblem': 
			sec_per_beat = 60.0 / Funcs.__BPM_FireEmblem
			audio_system_node.track_name = "Fire Emblem"
			audio_system_node.BPM = Funcs.__BPM_FireEmblem
			audio_stream_player.stream = _SONG__FIRE_EMBLEM
		_: 
			sec_per_beat = 0 # stop joc
	
	audio_system_node.emit_signal("ready")

func hit() -> void:
	hits += 1
	hits_label.text = "Got hit %d times!" % hits

#class EventHandler:
	#var falling_object_node: Node
	#var sec_per_beat: float
	#
	#func take_input_array(arr: Array) -> void:
		#var element_identifier: String = arr[0]
		#var data_array: Array = arr[1]
		#
		#match element_identifier:
			#"falling_body": falling_body(data_array)
	#
	#func falling_body(_data_array: Array) -> void:
		#if not is_instance_valid(falling_object_node): return
		#
		## [posx, posy, sec_per_beat, duration1, duration2, stall, fadeout]
		#var pos = randi_range(100, 500)
		#falling_object_node.emit_signal(
			#'spawn_body', 
			#Vector2(pos, pos / 2),  
			#sec_per_beat * 2, 
			#sec_per_beat * 2,
			#.35
		#)

### =====  ACTION COMMANDS  ===== ###
func handle_input_array(arr: Array, iter_count: int = 1) -> void:
	var element_identifier: String = arr[0]
	var data_array: Array = arr[1]
	
	match element_identifier:
		"camera_starter_zoom": camera_starter_zoom(data_array)
		"camera_zoom": camera_zoom(data_array)
		"falling_body": falling_body(data_array, iter_count)
		"wide_falling_body": wide_falling_body(data_array, iter_count)
		"flying_projectile": flying_projectile(data_array, iter_count)
		"healing_item": healing_item(data_array, iter_count)


var zoomtween: Tween
var postween: Tween
## data_array: [zoomin_val, sec_per_beat, duration_multiplier, reversed = false]
func camera_starter_zoom(data_array: Array) -> void:
	var zoomin_value: Vector2 = data_array[0]
	#var sec_per_beat: float = data_array[1]
	var duration_multiplier: float = data_array[1]
	var reversed: bool = false
	
	var init_zoom = camera.zoom
	if len(data_array) >= 3: reversed = data_array[2]
	
	if reversed: 
		var tmp = zoomin_value
		zoomin_value = init_zoom
		init_zoom = tmp
	
	camera.zoom = init_zoom
	
	var screen_center := Vector2(
		get_viewport_rect().size.x / 2, 
		get_viewport_rect().size.y / 2
	)
	
	zoomtween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	postween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	
	zoomtween.tween_property(camera, 'zoom', zoomin_value, sec_per_beat * duration_multiplier)
	postween.tween_property(camera, 'global_position', screen_center, sec_per_beat * duration_multiplier)

func camera_zoom(data_array: Array) -> void:
	#var sec_per_beat := 60.0 / Funcs.__BPM_FireEmblem
	
	var zoomin_value: float = data_array[0]
	var pos_offset: Vector2 = data_array[1]
	var zoom_time: float = data_array[2]
	
	var init_zoom := Vector2(1, 1)
	camera.zoom = Vector2(zoomin_value, zoomin_value)
	
	if zoomtween: zoomtween.kill()
	zoomtween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	zoomtween.tween_property(camera, 'zoom', init_zoom, zoom_time * sec_per_beat)
	
	await zoomtween.step_finished

func healing_item(data_array: Array, iter_count: int = 1) -> void:
	#var sec_per_beat: float = 60 / Funcs.__BPM_FireEmblem
	for i in range(iter_count):
		var identifier: String = data_array[0]
		var posx = data_array[1]
		var posy = data_array[2]
		
		## Check for random positons
		if posx is Array or posy is Array: 
			randomize()
			var randomed: float
			if posx is Array: 
				randomed = randf_range(posx[0], posx[1])
				posx = randomed
			if posy is Array:
				randomed = randf_range(posy[0], posy[1])
				posy = randomed
		
		## Check for player corresponding positions
		if posx == SongData.__indicator_ACCORDING_TO_PLAYER: posx = player.global_position.x
		if posy == SongData.__indicator_ACCORDING_TO_PLAYER: posy = player.global_position.y
		
		health_object_spawn_node.emit_signal(
				'spawn_body', 
				identifier,
				Vector2(posx, posy)
			)
		
		await get_tree().create_timer(sec_per_beat / iter_count).timeout

		

## data_array: [posx, posy, finx, finy sec_per_beat, fadein_multiplier, move_duration_multiplier, stall, fadeout, rotationangle]
func falling_body(data_array: Array, iter_count: int = 1) -> void:
	for i in range(iter_count):
		var posx = data_array[0]
		var posy = data_array[1]
		var finx = data_array[2]
		var finy = data_array[3]
		#var sec_per_beat: float = data_array[4]
		var fadein_multip: float = data_array[4]
		var move_multip: float = data_array[5]
		var stall_duration: float = 0
		var fadeout_duration: float = .4
		var rotation_angle: float = 0
		var identifier: String = 'vertical'
		
		## Check for random positions
		if posx is Array or posy is Array or finx is Array or finy is Array: 
			randomize()
			var randomed: float
			if posx is Array: 
				randomed = randf_range(posx[0], posx[1])
				posx = randomed
			if posy is Array:
				randomed = randf_range(posy[0], posy[1])
				posy = randomed
			
			if finx is Array: 
				randomed = randf_range(finx[0], finx[1])
				finx = randomed
			if finy is Array:
				randomed = randf_range(finy[0], finy[1])
				finy = randomed
		
		## Check for position equivalences
		if finx == SongData.__indicator_FINPOS_INITPOS_EQ: finx = posx
		if finy == SongData.__indicator_FINPOS_INITPOS_EQ: finy = posy
		
		## Check for player corresponding positions
		if posx == SongData.__indicator_ACCORDING_TO_PLAYER: posx = player.global_position.x
		if posy == SongData.__indicator_ACCORDING_TO_PLAYER: posy = player.global_position.y
		if finx == SongData.__indicator_ACCORDING_TO_PLAYER: finx = player.global_position.x
		if finy == SongData.__indicator_ACCORDING_TO_PLAYER: finy = player.global_position.y
		
		if len(data_array) >= 7: 
			stall_duration = data_array[6]
		if len(data_array) >= 8:
			fadeout_duration = data_array[7]
		if len(data_array) >= 9:
			rotation_angle = data_array[8]
		if len(data_array) >= 10:
			identifier = data_array[9]
		
		falling_object_node.emit_signal(
				'spawn_body', 
				Vector2(posx, posy),  
				Vector2(finx, finy),
				sec_per_beat * fadein_multip, 
				sec_per_beat * move_multip,
				stall_duration,
				fadeout_duration,
				rotation_angle,
				identifier
			)
		
		await get_tree().create_timer(sec_per_beat / iter_count).timeout

## data_array: [posx, posy, finx, finy sec_per_beat, fadein_multiplier, move_duration_multiplier, stall, fadeout, rotationangle]
func wide_falling_body(data_array: Array, iter_count: int = 1) -> void:
	for i in range(iter_count):
		var posx = data_array[0]
		var posy = data_array[1]
		var finx = data_array[2]
		var finy = data_array[3]
		#var sec_per_beat: float = data_array[4]
		var fadein_multip: float = data_array[4]
		var move_multip: float = data_array[5]
		var stall_duration: float = 0
		var fadeout_duration: float = .4
		var rotation_angle: float = 0
		
		## Check for random positions
		if posx is Array or posy is Array or finx is Array or finy is Array: 
			randomize()
			var randomed: float
			if posx is Array: 
				randomed = randf_range(posx[0], posx[1])
				posx = randomed
			if posy is Array:
				randomed = randf_range(posy[0], posy[1])
				posy = randomed
			
			if finx is Array: 
				randomed = randf_range(finx[0], finx[1])
				finx = randomed
			if finy is Array:
				randomed = randf_range(finy[0], finy[1])
				finy = randomed
		
		## Check for position equivalences
		if finx == SongData.__indicator_FINPOS_INITPOS_EQ: finx = posx
		if finy == SongData.__indicator_FINPOS_INITPOS_EQ: finy = posy
		
		## Check for player corresponding positions
		if posx == SongData.__indicator_ACCORDING_TO_PLAYER: posx = player.global_position.x
		if posy == SongData.__indicator_ACCORDING_TO_PLAYER: posy = player.global_position.y
		if finx == SongData.__indicator_ACCORDING_TO_PLAYER: finx = player.global_position.x
		if finy == SongData.__indicator_ACCORDING_TO_PLAYER: finy = player.global_position.y
		
		if len(data_array) >= 7: 
			stall_duration = data_array[6]
		if len(data_array) >= 8:
			fadeout_duration = data_array[7]
		if len(data_array) >= 9:
			rotation_angle = data_array[8]
		
		wide_falling_object_node.emit_signal(
				'spawn_body', 
				Vector2(posx, posy),  
				Vector2(finx, finy),
				sec_per_beat * fadein_multip, 
				sec_per_beat * move_multip,
				stall_duration,
				fadeout_duration,
				rotation_angle
			)
		
		await get_tree().create_timer(sec_per_beat / iter_count).timeout


## data_array: [posx, posy, finx, finy, Wait_time_multip, tween_duration_multip, rotate_amount, fadein_time: float = .2, rotation_linear_type: Tween.TransitionType = Tween.TRANS_BACK]
func flying_projectile(data_array: Array, iter_count: int = 1) -> void:
	for i in range(iter_count):
		#var sec_per_beat := 60.0 / Funcs.__BPM_FireEmblem
		
		var posx = data_array[0]
		var posy = data_array[1]
		var finx = data_array[2]
		var finy = data_array[3]
		var wait_time_multip: float = data_array[4]
		var tween_duration_multip: float = data_array[5]
		var rotate_amount: float = data_array[6]
		var fadein_time: float = .4
		var rotation_linear_type: Tween.TransitionType = Tween.TRANS_BACK
		var stall_time: float = .075
		
			## Check for random positions
		if posx is Array or posy is Array or finx is Array or finy is Array: 
			randomize()
			var randomed: float
			if posx is Array: 
				randomed = randf_range(posx[0], posx[1])
				posx = randomed
			if posy is Array:
				randomed = randf_range(posy[0], posy[1])
				posy = randomed
			
			if finx is Array: 
				randomed = randf_range(finx[0], finx[1])
				finx = randomed
			if finy is Array:
				randomed = randf_range(finy[0], finy[1])
				finy = randomed
		
		## Check for position equivalences
		if finx == SongData.__indicator_FINPOS_INITPOS_EQ: finx = posx
		if finy == SongData.__indicator_FINPOS_INITPOS_EQ: finy = posy
		
		## Check for player corresponding positions
		if posx == SongData.__indicator_ACCORDING_TO_PLAYER: posx = player.global_position.x
		if posy == SongData.__indicator_ACCORDING_TO_PLAYER: posy = player.global_position.y
		if finx == SongData.__indicator_ACCORDING_TO_PLAYER: finx = player.global_position.x
		if finy == SongData.__indicator_ACCORDING_TO_PLAYER: finy = player.global_position.y

		if len(data_array) >= 8:
			fadein_time = data_array[7]
		if len(data_array) >= 9:
			rotation_linear_type = data_array[8]
		if len(data_array) >= 10:
			stall_time = data_array[9]

		flying_projectile_node.emit_signal(
			'spawn_projectile',
			Vector2(posx, posy),  
			Vector2(finx, finy),
			sec_per_beat * wait_time_multip, 
			sec_per_beat * tween_duration_multip,
			rotate_amount,
			fadein_time,
			rotation_linear_type,
			stall_time
		)
		
		await get_tree().create_timer(sec_per_beat / iter_count).timeout
