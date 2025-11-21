extends Node

@onready var control: Control = $Control
@onready var background: Polygon2D = $Control/Background
@onready var song_name: Label = $Control/Background/SongName
@onready var author: Label = $Control/Background/Author


## DONT CHANGE THE ORDER OF THE POINTS
@onready var background_w: float = background.polygon[2].distance_to(background.polygon[3]) + poly_offsetX
@onready var background_h: float = background.polygon[0].distance_to(background.polygon[3])
@onready var viewport_rect: Vector2 = get_viewport().size
@onready var posY := viewport_rect.y - background_h - poly_offsetY

const poly_offsetX := 67.0
const poly_offsetY := 60.0

var move_tween: Tween

func _ready() -> void:
	## Position off screen
	background.global_position = Vector2(viewport_rect.x + poly_offsetX, posY)
	background.hide()
	
	#await get_tree().create_timer(1.0).timeout
	#set_song_label('Fire Emblem', 'from Untitled Tag Game, Roblox')
	#await show_entrance()
	#
	#hide_entrance()


func show_entrance(timespan: float = 1.0) -> void:
	background.show()
	if move_tween: move_tween.kill()
	
	move_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	move_tween.tween_property(background, 'global_position', Vector2(viewport_rect.x + poly_offsetX - background_w, posY), timespan)
	await move_tween.step_finished

func hide_entrance(timespan: float = 1.0) -> void:
	if move_tween: move_tween.kill()
	
	move_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	move_tween.tween_property(background, 'global_position', Vector2(viewport_rect.x + poly_offsetX, posY), timespan)
	await move_tween.step_finished
	
	background.hide()


func set_song_label(songnm: String, auth: String) -> void:
	song_name.text = songnm
	author.text = auth
