extends CharacterBody2D

class_name PlayerLocal

const MOVE_SPEED: float = 200.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_id: int = randi_range(100000, 999999)
var is_attacking: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle attack.
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
	
	if is_attacking:
		return  # Prevent movement during attack

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0
		if not $AnimatedSprite2D.is_playing() or $AnimatedSprite2D.animation != "run":
			$AnimatedSprite2D.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not $AnimatedSprite2D.is_playing() or $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
	
	move_and_slide()

func attack():
	is_attacking = true
	$AnimatedSprite2D.play("attack")

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
