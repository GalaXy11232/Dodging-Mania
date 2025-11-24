extends Node
class_name EndScreenNode

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var color_rect: ColorRect = $CanvasLayer/Control/MarginContainer/ColorRect
@onready var number_of_hits_label: Label = %"Number of hits"
@onready var score_label: Label = %Score

@onready var esc_pause: EscPauseNode = $"../ESC PAUSE"
@onready var player: CharacterBody2D = $"../Player"

const TEXT_NUMBEROFHITS := "Number of hits: "
const TEXT_SCORE := "Total score: "

var score: int
var number_of_hits: int

func _ready() -> void:
	canvas_layer.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	score = 0
	number_of_hits = 0


func show_end_screen(hits: int) -> void:
	esc_pause.toggle_pausability(false) ## Remove capability of pausing
	#get_tree().paused = true ## Pause the game for good measure 
	## Ive got another idea -- dont pause the game but immobilize the player
	
	# 哦皮肤是哦恐怕反对恐怕但是佛龛是 
	# ^^^ bro wwhat
	
	player.get_node("InputMovement Node").immobilize(true, false)
	
	number_of_hits_label.text = TEXT_NUMBEROFHITS + str(hits)
	score_label.text = TEXT_SCORE + str(compute_score_by_hits(hits))
	
	toggle_visibility(true)

func _on_main_menu_pressed() -> void:
	get_tree().paused = false ## Avoid process_mode PAUSED bugs
	get_tree().change_scene_to_file("res://Main Scene/main_menu.tscn")


func toggle_visibility(value: bool = !canvas_layer.visible) -> void:
	canvas_layer.visible = value

func compute_score_by_hits(hit_no: int) -> int:
	const arbitrary := 1000
	const total := 10000
	
	return total - hit_no * arbitrary
