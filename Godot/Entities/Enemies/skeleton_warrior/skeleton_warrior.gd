extends CharacterBody2D

class_name Skeleton_warrior

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite :Sprite2D = $SpriteSheet
@onready var animation_tree : AnimationTree = $AnimationTree

@export var damageable : Damageable
@export var bot_state_machine : EnemyStateMachine
@export var health_bar : ProgressBar
@export var weapon_collision : CollisionShape2D
@export var facing_r : bool = true
var locked_player : CharacterBody2D


# Enemy type mob core variables [All variables is in default, Please change it to use]
var health = 30
var damage = 10
var speed = 50
var direction : Vector2 = Vector2.ZERO
var x_old = 1

# Enemy type mob signals
signal on_hit(node: Node, damage_taken : int)
signal facing_direction_changed(facing_right : bool)
signal in_attack_range(yes: bool)


func _ready():
	health_bar.max_value = health
	health_bar.value = health
	if !facing_r:
		direction.x = -1
		emit_signal("facing_direction_changed", true)	
	

func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if direction.x != 0 and bot_state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	
	move_and_slide()
	update_animation_parameter()
	if bot_state_machine.current_state != bot_state_machine.states[2]:
		update_facing_direction()
	
func update_animation_parameter():
	animation_tree.set("parameters/move/blend_position", direction.x)
	
func update_facing_direction():
	if direction.x != x_old:
		if direction.x > 0:
			sprite.flip_h = false
			x_old = 1
			emit_signal("facing_direction_changed", true)
		elif direction.x < 0:
			sprite.flip_h = true
			x_old = -1
			emit_signal("facing_direction_changed", false)
#func update_facing_direction():
	#if direction.x > 0:
		#sprite.flip_h = false
	#elif direction.x < 0:
		#sprite.flip_h = true
	#emit_signal("facing_direction_changed", !sprite.flip_h)
func on_health_changed():
	health_bar.value = health
		
