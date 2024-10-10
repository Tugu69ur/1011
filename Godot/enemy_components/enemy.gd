extends CharacterBody2D

class_name Enemy

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
var health = 100
var damage = 10
var speed = 50
var direction : Vector2 = Vector2.ZERO

# Enemy type mob signals
signal on_hit(node: Node, damage_taken : int)
signal facing_direction_changed(facing_right : bool)


func _ready():
	if !facing_r:
		emit_signal("facing_direction_changed", true)

	



func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if direction.x != 0 and bot_state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	
	move_and_slide()
	
	if bot_state_machine.current_state != bot_state_machine.states[4]:
		update_facing_direction()
	

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	emit_signal("facing_direction_changed", !sprite.flip_h)


	
