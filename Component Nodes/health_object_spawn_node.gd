extends Node
class_name HealthObjectSpawn

@onready var VIEWPORT_RECT: Vector2 = get_parent().get_viewport_rect().size ## Needs to be child of a Node2D
@onready var identifier_converter: Dictionary = {
	'apple': "res://Main Scene/Heal Nodes/apple.tscn"
}

signal spawn_body

func _on_spawn_body(identifier: String, global_pos: Vector2) -> void:
	if identifier not in identifier_converter.keys(): return
	
	var BODY_PATH = load(identifier_converter[identifier.to_lower()])
	var body = BODY_PATH.instantiate()
	var lifespan = body.get_meta("lifespan")
	add_child(body)
	
	body.global_position = global_pos
	
	await get_tree().create_timer(lifespan).timeout
	if (is_instance_valid(body)): ## May be queue_free()d earlier
		await body.ease_out()
		
		body.idle_tween.set_loops(1)
		body.queue_free()
