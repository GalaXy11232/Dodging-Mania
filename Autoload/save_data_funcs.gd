extends Node

## ==================== SCORE RELATED ====================
const MAP_SCORES_DIR := "user://"
const __map_FIRE_EMBLEM_SAVEFILE := "FireEmblem.score"
const __map_TUTORIAL_SAVEFILE := "tutorial.score"

func save_score(map_name: String, score: Variant) -> void:
	var savefile = FileAccess.open(MAP_SCORES_DIR + map_name, FileAccess.WRITE)
	savefile.store_string(str(score))
	savefile.close()

func load_score(map_name: String) -> Variant:
	if FileAccess.file_exists(MAP_SCORES_DIR + map_name):
		var savefile := FileAccess.open(MAP_SCORES_DIR + map_name, FileAccess.READ)
		var ret_score := savefile.get_as_text()
		savefile.close()
		
		return ret_score
	
	## Save file does not exist; create a new blank one instead
	else:
		save_score(map_name, 0)
		return 'Never played'


## ==================== OPTIONS RELATED ====================
const OPTIONS_FILEDIR := "user://options.data"
var master_volume: float
var music_volume: float
var sfx_volume: float

func update_audio_by_name(bus_name: String, value: float) -> void:
	match bus_name:
		"Master": master_volume = value
		"Music": music_volume = value
		"SFX": sfx_volume = value
		_: return

func save_options_data() -> void:
	print("da ma da")
	var file = FileAccess.open(OPTIONS_FILEDIR, FileAccess.WRITE)
	file.store_var(master_volume)
	file.store_var(music_volume)
	file.store_var(sfx_volume)
	
	file.close()
	
	## Make this functon a coroutine to avoid saving corruptions
	await get_tree().create_timer(.05).timeout 
	return

func load_options_data() -> void:
	if FileAccess.file_exists(OPTIONS_FILEDIR):
		var file = FileAccess.open(OPTIONS_FILEDIR, FileAccess.READ)
		
		## Handle audio buses
		master_volume = file.get_var(master_volume)
		music_volume = file.get_var(music_volume)
		sfx_volume = file.get_var(sfx_volume)
		
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), master_volume)
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), music_volume)
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), sfx_volume)
		

		file.close()
	
	else:
		master_volume = 1.0
		music_volume = 1.0
		sfx_volume = 1.0
