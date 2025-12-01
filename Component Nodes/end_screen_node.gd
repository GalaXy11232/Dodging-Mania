extends Node
class_name EndScreenNode

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var color_rect: ColorRect = $CanvasLayer/Control/MarginContainer/ColorRect
@onready var number_of_hits_label: Label = %"Number of hits"
@onready var score_label: Label = %Score
@onready var highscore_label: Label = %Highscore

@onready var esc_pause: EscPauseNode = $"../ESC PAUSE"
@onready var player: CharacterBody2D = $"../Player"

const TEXT_NUMBEROFHITS := "Number of hits: "
const TEXT_SCORE := "Total score: "

func _ready() -> void:
	highscore_label.visible = false
	Funcs.set_label_pivot_offset_by_text(highscore_label, "New highscore!")
	
	canvas_layer.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_end_screen(hits: int) -> void:
	esc_pause.toggle_pausability(false) ## Remove capability of pausing
	#get_tree().paused = true ## Pause the game for good measure 
	## Ive got another idea -- dont pause the game but immobilize the player
	
	# 哦皮肤是哦恐怕反对恐怕但是佛龛是 
	# ^^^ bro wwhat
	
	## Check if score is a new PB to see if it's worth to save
	var saved_score = SaveData.load_score(Funcs.track_savefile)
	var current_score := compute_score_by_hits(hits)
	
	if (float(saved_score) < float(current_score)):
		highscore_label.visible = true
		SaveData.save_score(Funcs.track_savefile, current_score)
	
	player.get_node("InputMovement Node").immobilize(true, false)
	
	number_of_hits_label.text = TEXT_NUMBEROFHITS + str(hits)
	score_label.text = TEXT_SCORE + str(current_score)
	
	toggle_visibility(true)

## Mainly for rotating highscore_label
const HIGHSCORE_LABEL_ANGLE := -15.0
const MAX_ROTATION_INDEX_VALUE := 1000000000
const ANGLE_AMP := 0.05
const ROTATION_AMP := 10
func get_next_index(i) -> int:
	if i >= MAX_ROTATION_INDEX_VALUE: return 0
	return i + 1

var rotation_index: float = 0
func _physics_process(delta: float) -> void:
	rotation_index = get_next_index(rotation_index)
	highscore_label.rotation_degrees = HIGHSCORE_LABEL_ANGLE + sin(rotation_index * ANGLE_AMP) * ROTATION_AMP

func _on_main_menu_pressed() -> void:
	get_tree().paused = false ## Avoid process_mode PAUSED bugs
	get_tree().change_scene_to_file("res://Main Scene/main_menu.tscn")


func toggle_visibility(value: bool = !canvas_layer.visible) -> void:
	canvas_layer.visible = value

func compute_score_by_hits(hit_no: int) -> int:
	var arbitrary := 1000
	var total := 10000
	
	return total - hit_no * arbitrary
