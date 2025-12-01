extends Node
class_name FallingObject

@onready var VIEWPORT_RECT: Vector2 = get_parent().get_viewport_rect().size ## Needs to be child of a Node2D
@onready var BODY_PATH := preload("res://Main Scene/Attack Nodes/falling_body.tscn")

const SPRITE_VERTICAL := "res://Images/brick block.png"
const SPRITE_HORIZONTAL := "res://Images/fireball.png"

class RectShape:
	var shape := RectangleShape2D.new()
	
	func _init(extX, extY) -> void:
		self.shape.size = Vector2(extY, extX)
	

var sprite_identifiers: Dictionary = {
	'vertical': [SPRITE_VERTICAL, RectShape.new(60, 60), Vector2(.053, .053), 0],
	'horizontal': [SPRITE_HORIZONTAL, RectShape.new(100, 55), Vector2(.2, .2), deg_to_rad(-90)]
}

signal spawn_body
signal setup_sprite

## Turned off after reaching destination, before fading out, thus preventing unwanted "random" damaging
var inflict_damage_metaStrIdentif: String = "can_inflict_damage"
var fall_tween: Tween

func _on_spawn_body(global_pos: Vector2, final_pos: Vector2, wait_time: float, tween_duration: float, stall_duration: float = 0, FADEOUT_TIME: float = .4, theta: float = 0, identifier: String = 'vertical') -> void:
	## Setting boundaries to avoid breaking tweening times due to high bpm
	tween_duration = max( 0.6, tween_duration )
	wait_time = max( 0.3, wait_time )
	stall_duration = min(wait_time, stall_duration)
	
	var body = BODY_PATH.instantiate()
	body.set_meta(inflict_damage_metaStrIdentif, false)
	
	var body_sprite := body.get_node("Sprite")
	var collision_box := body.get_node("HitBox/Collision")
	body_sprite.texture = load(sprite_identifiers[identifier.to_lower()][0])
	collision_box.shape = sprite_identifiers[identifier.to_lower()][1].shape
	body_sprite.scale = sprite_identifiers[identifier.to_lower()][2]
	body_sprite.rotation = sprite_identifiers[identifier.to_lower()][3]
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
