extends CharacterBody2D
class_name Player
@export var speed := 200.0
@export var jump_strength := 300.0 

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var animation = $AnimationPlayer

signal facing_direction_changed(facing_right : bool)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.ZERO

func _ready():
	animation_tree.active = true
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0 
		direction = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_just_pressed("attack") and is_on_floor():
			animation.play("attack_1")
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y -= jump_strength 
		if direction.x != 0 :
			velocity.x = direction.x * speed
			animation.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			animation.play("idle")
		move_and_slide()  
		update_animation_parameter()
		update_facing_direction()

func update_animation_parameter():
	if direction.length() > 0:
		animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	emit_signal("facing_direction_changed", !sprite.flip_h)
