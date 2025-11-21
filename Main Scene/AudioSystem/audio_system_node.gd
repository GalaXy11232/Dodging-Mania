## FIRE EMBLEM BEATS: [0, 385] -> 386 dt beats
extends Node
class_name AudioSystem

@onready var main_scene: Node2D = $".."
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer
@onready var camera: Camera2D = $"../Camera"
@onready var player: CharacterBody2D = $"../Player"

### === COMPONENT NODES ===
@onready var falling_object_node: FallingObject = $"../FallingObject Node"
@onready var song_entrance_node: Node = $"../SongNameEntrance Node"

const BPM: float = 212.0
var audio_offset: float = 0.0
var song_offset: float = 0#72#23.0
var last_reported_beat: int = 0

func _ready() -> void: 
	## Camera Entrance
	await get_tree().create_timer(.5).timeout
	main_scene.handle_input_array(['camera_starter_zoom', [
			Vector2(1, 1),
			60.0 / BPM,
			4
		]])
	await main_scene.zoomtween.step_finished
	await main_scene.postween.step_finished
	
	## Start the audio
	#audio_stream.volume_db = -10
	audio_stream.play(song_offset)
	
func _physics_process(_delta):
	var sec_per_beat := 60.0 / BPM
	var track_position := get_playback_position(audio_stream)
	var track_position_in_beats := int(floor((track_position + audio_offset) / sec_per_beat))
	
	if last_reported_beat < track_position_in_beats:
		handle_beat(sec_per_beat, last_reported_beat)
		
		last_reported_beat = track_position_in_beats


func handle_beat(sec_per_beat: float, beat_no: int) -> void:
	print('beat ', beat_no)
	if beat_no <= 1: song_entrance_node.set_song_label('Fire Emblem', 'from Untitled Tag Game, Roblox')
	if beat_no == 2: song_entrance_node.show_entrance()
	if beat_no == 16: song_entrance_node.hide_entrance()
	
	var songdata_arr: Array = SongData.find_action_by_beat_no(beat_no)
	for data in songdata_arr:
		var iter_count: int = data[len(data) - 1]
		data.pop_back()
		
		main_scene.handle_input_array(data, iter_count)


func get_playback_position(audio_player : AudioStreamPlayer) -> float:
	var time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	
	return time
