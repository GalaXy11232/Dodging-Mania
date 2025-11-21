extends Node

var paused: bool = false

func _ready() -> void:
	$CanvasLayer/Label.visible = paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(_ev: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		get_tree().paused = paused
		$CanvasLayer/Label.visible = paused
