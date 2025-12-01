extends Node
class_name HealthNode

@onready var healthbar: ProgressBar = $Healthbar
@onready var parent_node: CharacterBody2D = get_parent()
@onready var parent_sprite: AnimatedSprite2D = parent_node.get_node("Sprite")
@onready var arena_node: Node2D = parent_node.get_parent() 

@export var max_health: float = 100.0
@export var hitbox_node: Area2D

const INVULNERABILITY_BLINKS := 6

var health: float = max_health
var POS_OFFSET := Vector2(-38, -45)

var invulnerable: bool = false
var cooldown_timer: Timer
var cooldown_time: float = 2.0

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_cooldown_timeout)
	add_child(cooldown_timer)
	
	if is_instance_valid(hitbox_node):
		hitbox_node.area_entered.connect(_area_entered)
	healthbar.value = health
	healthbar.max_value = max_health
	

func _physics_process(_delta: float) -> void:
	healthbar.position = parent_node.position + POS_OFFSET
	healthbar.value = health
	
	if health <= 0:
		print("Stop joc gata")
		parent_node.queue_free()
		
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	
	if area_parent.is_in_group('damage') and not invulnerable and (area_parent.get_meta("can_inflict_damage") == true):
		damage(area_parent.get_meta('damage_points'))
		damage_text('-' + str(Funcs.fixed_intfloat_decimal(area_parent.get_meta('damage_points'))))
		damage_cooldown()
		
		## Blink while invulnerable
		invulnerability_blink()  
	
	if area_parent.is_in_group("heal") and area_parent.can_be_consumed:
		damage_text('+' + str(Funcs.fixed_intfloat_decimal(Funcs.clampL(health + area_parent.get_meta('heal_points'), max_health) - health)), Funcs.GREEN)
		heal(area_parent.get_meta('heal_points'))
		if "idle_tween" in area_parent.get_parent():
			area_parent.idle_tween.set_loops(1)
			area_parent.idle_tween.kill()
		area_parent.queue_free()


func damage(value: float) -> void: 
	health -= value
	arena_node.hit()
	
func heal(value: float) -> void:
	health = Funcs.clampL(health + value, max_health)

func damage_cooldown() -> void:
	invulnerable = true
	cooldown_timer.start()

func _cooldown_timeout() -> void: 
	invulnerable = false


func damage_text(text: String, color: Color = Color(1, 0, 0, 1)) -> void:
	const yOffset = -85;
	var dmg_label := Label.new()
	dmg_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	dmg_label.z_index = 10
	
	var label_lettings := LabelSettings.new()
	label_lettings.font_size = 35
	label_lettings.font_color = color
	
	dmg_label.label_settings = label_lettings
	dmg_label.text = text
	
	parent_node.add_child(dmg_label)
	dmg_label.global_position = parent_node.global_position
	dmg_label.global_position.y += yOffset
	
	var movetween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel(false)
	var fadetween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	movetween.tween_property(dmg_label, 'position', dmg_label.position + Vector2(0, -60), 1.5)
	fadetween.tween_property(dmg_label, 'modulate:a', 0, 1)
	
	await fadetween.step_finished
	
	dmg_label.queue_free()

func invulnerability_blink() -> void:
	var time_between_blinks := float(cooldown_time) / (2 * INVULNERABILITY_BLINKS) # times 2 for both appearing/disappearing
	
	for iter in range(INVULNERABILITY_BLINKS):
		parent_sprite.visible = false
		await get_tree().create_timer(time_between_blinks).timeout
		
		parent_sprite.visible = true
		await get_tree().create_timer(time_between_blinks).timeout
	
	## Avoid visual bugs
	parent_sprite.visible = true 
