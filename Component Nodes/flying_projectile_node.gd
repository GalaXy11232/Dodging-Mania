extends Node
class_name FlyingProjectile

@onready var VIEWPORT_RECT: Vector2 = get_parent().get_viewport_rect().size ## Needs to be child of a Node2D
@onready var PROJECTILE_PATH := preload("res://Main Scene/Attack Nodes/flying_projectile.tscn")

const FADEOUT_TIME := 0.2
## Turned off after reaching destination, before fading out, thus preventing unwanted "random" damaging
var inflict_damage_metaStrIdentif: String = "can_inflict_damage"

signal spawn_projectile

func _on_spawn_projectile(global_pos: Vector2, final_pos: Vector2, wait_time: float, tween_duration: float, rotate_amount: float, fadein_time: float = .2, rotation_linear_type: Tween.TransitionType = Tween.TRANS_BACK, stall_time: float = .075) -> void:
	fadein_time = min(fadein_time, wait_time)
	
	var projectile := PROJECTILE_PATH.instantiate()
	projectile.set_meta(inflict_damage_metaStrIdentif, false)
	
	var projectile_sprite := projectile.get_node("Sprite")
	projectile_sprite.modulate.a = 0
	add_child(projectile)
	
	projectile.global_position = global_pos
	projectile.look_at(final_pos)
	var init_rotation = projectile.rotation
	
	## Rotate with given offset
	projectile.rotate(rotate_amount)
	
	## Play spawn sound
	if projectile.has_node("SFX_appear"): 
		projectile.get_node("SFX_appear").volume_db = -12#-20
		projectile.get_node("SFX_appear").play()
	
	var fadeintwn := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
	var rotatetwn := create_tween().set_ease(Tween.EASE_OUT).set_trans(rotation_linear_type).set_parallel(true)
	fadeintwn.tween_property(projectile_sprite, 'modulate:a', 1, fadein_time)
	rotatetwn.tween_property(projectile, 'rotation', init_rotation, wait_time - stall_time)
	
	await fadeintwn.step_finished
	await rotatetwn.step_finished
	await get_tree().create_timer(stall_time).timeout
	
	## Enable damage
	projectile.set_meta(inflict_damage_metaStrIdentif, true)
	var movetwn := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	movetwn.tween_property(projectile, 'global_position', final_pos, tween_duration)
	
	await movetwn.step_finished
	projectile.set_meta(inflict_damage_metaStrIdentif, false)
	
	## Fadeout tween
	var fadeout := create_tween()
	fadeout.tween_property(projectile_sprite, 'modulate:a', 0, FADEOUT_TIME)
	await fadeout.step_finished
	
	projectile.queue_free()
