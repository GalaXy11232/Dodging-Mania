extends Node
class_name EscPauseNode

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var resume: Button = $CanvasLayer/Resume
@onready var main_menu: Button = $"CanvasLayer/Main Menu"

var paused: bool = false
var is_pausable: bool = true

func _ready() -> void:
	canvas_layer.visible = paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(_ev: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and is_pausable:
		toggle_pause()


func _on_resume_pressed() -> void:
	toggle_pause()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false ## Avoid process_mode PAUSED bugs
	get_tree().change_scene_to_file("res://Main Scene/main_menu.tscn")


func toggle_pause(value: bool = !paused) -> void:
	paused = value
	get_tree().paused = paused
	canvas_layer.visible = paused

func toggle_pausability(value: bool = !is_pausable) -> void:
	is_pausable = value
