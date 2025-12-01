extends Node2D

@onready var camera: Camera2D = $Camera

@onready var master_volume_label: HSlider = %MasterVolume
@onready var music_volume_label: HSlider = %MusicVolume
@onready var sfx_volume_label: HSlider = %SFXVolume

## Margin offset to avoid visual errors when moving camera positions
const MARGIN_VECTOR := Vector2(30, 30)

func _ready() -> void:
	## Avoiding possible editor modifications
	camera.offset = Vector2.ZERO
	$ignore.hide()
	
	SaveData.load_options_data()
	master_volume_label.update_label_to_volume()
	music_volume_label.update_label_to_volume()
	sfx_volume_label.update_label_to_volume()

func _on_exit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _go_to_options() -> void:
	camera.position = (Funcs.__DEFAULT_VIEWPORT_RECT + MARGIN_VECTOR) * Vector2.RIGHT

func _go_to_menu() -> void:
	camera.position = Vector2.ZERO
