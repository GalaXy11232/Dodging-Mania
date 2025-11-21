### USED EXCLUSIVELY FOR PLAYER'S INPUT MOVEMENT;
### USES KEYBOARD INPUTS, MULTIPLE RUNNING NODES ARE NOT RECOMMENDED
extends Node
class_name InputMovement

@onready var parent_node: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../Sprite"

const SPRITE_OFFSET_X := 60

@export var SPEED: float = 300.0
@export var SPRINTSPEED: float = 550.0
@export var JUMP_VELOCITY: float = -500.0

const move_animation_FPS := 5.0

var double_jumped: bool = false
var sprinting: bool = false

func _ready() -> void:
	sprite.sprite_frames.set_animation_speed("Move", move_animation_FPS)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed('sprint'): sprinting = true
	else: sprinting = false
	
	if not parent_node.is_on_floor():
		parent_node.velocity += parent_node.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if parent_node.is_on_floor():
			parent_node.velocity.y = JUMP_VELOCITY
		else:
			if not double_jumped:
				parent_node.velocity.y = JUMP_VELOCITY
				double_jumped = true
	
	if parent_node.is_on_floor() and double_jumped: 
		double_jumped = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var crtspeed: float = SPEED
	if sprinting: 
		crtspeed = SPRINTSPEED
		sprite.sprite_frames.set_animation_speed("Move", move_animation_FPS + 5)
	else: 
		sprite.sprite_frames.set_animation_speed("Move", move_animation_FPS)
	
	if direction:
		sprite.play("Move")
		sprite.flip_h = direction < 0
		sprite.position.x = int(direction < 0) * -SPRITE_OFFSET_X
		
		parent_node.velocity.x = direction * crtspeed
	else:
		sprite.play("Idle")
		parent_node.velocity.x = move_toward(parent_node.velocity.x, 0, crtspeed)

	parent_node.move_and_slide()
