class_name WideFallingBody
extends Node

@onready var VIEWPORT_RECT: Vector2 = get_parent().get_viewport_rect().size ## Needs to be child of a Node2D
@onready var BODY_PATH := preload("res://Main Scene/Attack Nodes/wide_falling_body.tscn")

signal spawn_body

## Turned off after reaching destination, before fading out, thus preventing unwanted "random" damaging
var inflict_damage_metaStrIdentif: String = "can_inflict_damage"
var fall_tween: Tween

func _on_spawn_body(global_pos: Vector2, final_pos: Vector2, wait_time: float, tween_duration: float, stall_duration: float = 0, FADEOUT_TIME: float = .4, theta: float = 0) -> void:
	## Setting boundaries to avoid breaking tweening times due to high bpm
	tween_duration = max( 1, tween_duration )
	wait_time = max( 0.3, wait_time )
	stall_duration = min(wait_time, stall_duration)
	
	var body = BODY_PATH.instantiate()
	body.set_meta(inflict_damage_metaStrIdentif, false)
	
	var body_sprite := body.get_node("Sprite")
	body_sprite.modulate.a = 0
	add_child(body)
	
	body.global_position = global_pos
	body.rotate(theta)
	
	var fadetween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	fadetween.tween_property(body_sprite, 'modulate:a', 1, wait_time - stall_duration)
	await fadetween.step_finished
	if stall_duration:
		await get_tree().create_timer(stall_duration).timeout
	
	## Enable damage
	body.set_meta(inflict_damage_metaStrIdentif, true)
	fall_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	fall_tween.tween_property(body, 'global_position', final_pos, tween_duration)
	
	await fall_tween.step_finished
	body.set_meta(inflict_damage_metaStrIdentif, false)
	
	## Fade out
	fadetween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	fadetween.tween_property(body_sprite, 'modulate:a', 0, FADEOUT_TIME)
	await fadetween.step_finished
	
	body.queue_free()
