extends Button

@onready var score_label: Label = $"Score Label"

@export_group("Labeling data")
@export var button_text: String
@export var font_size: int = 32

@export_group("")
@export var track_name: String ## Used to set Funcs.track_name, identifying which action_dict and music to be played
@export var arena_scene_path: String ## Changes the scene to the corresponding arena path
@export var savefile_path: String ## Must be set in order to correctly grab the score fom the corresponding save file

func _ready() -> void:
	## Check for empty button string
	if len(button_text) == 0:
		button_text = track_name
	
	self.text = button_text
	self.font_size = font_size
	
	## TBD
	var score_text := str(SaveData.load_score(savefile_path))
	if score_text.to_lower() == 'never played' or score_text == '0':
		score_label.text = "Never played"
	else:
		score_label.text = "Score: " + score_text

func _on_pressed() -> void:
	Funcs.track_name = track_name
	Funcs.track_savefile = savefile_path
	
	await SaveData.save_options_data()
	get_tree().change_scene_to_file(arena_scene_path)
