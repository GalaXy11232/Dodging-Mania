## FIRE EMBLEM BEATS: [0, 385] -> 386 dt beats
extends Node
class_name AudioSystem

@onready var arena_scene: Node2D = $".."
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer

### === COMPONENT NODES ===
@onready var song_entrance_node: Node = $"../SongNameEntrance Node"
@onready var esc_pause: EscPauseNode = $"../ESC PAUSE"
@onready var end_screen_node: EndScreenNode = $"../End Screen Node"

@export var BPM: float = 212.0
@export var audio_offset: float = 0.0
@export var song_offset: float = 0#107#72#23.0
var last_reported_beat: int = 0

func _ready() -> void: 
	## Setup triggers
	audio_stream.connect('finished', song_finished)
	
	## Camera Entrance
	await get_tree().create_timer(.5).timeout
	arena_scene.handle_input_array(['camera_starter_zoom', [
			Vector2(1, 1),
			60.0 / BPM,
			4
		]])
	await arena_scene.zoomtween.step_finished
	await arena_scene.postween.step_finished
	
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
	#print('beat ', beat_no)
	if beat_no <= 1: song_entrance_node.set_song_label('Fire Emblem', 'from Untitled Tag Game, Roblox')
	if beat_no == 2: song_entrance_node.show_entrance()
	if beat_no == 16: song_entrance_node.hide_entrance()
	
	var songdata_arr: Array = SongData.find_action_by_beat_no(beat_no)
	for data in songdata_arr:
		var iter_count: int = data[len(data) - 1]
		data.pop_back()
		
		arena_scene.handle_input_array(data, iter_count)


func song_finished() -> void:
	#esc_pause.toggle_pause(true)
	#esc_pause.toggle_pausability(false)
	end_screen_node.show_end_screen(arena_scene.hits)

func get_playback_position(audio_player : AudioStreamPlayer) -> float:
	var time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	
	return time
