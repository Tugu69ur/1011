extends EnemyState

class_name HitState

@export var damageable : Damageable
@export var bot_state_machine : EnemyStateMachine
@export var dead_state : EnemyState
@export var return_state : EnemyState
var taking_damage = false
#func on_enter():
	#playback.travel("hurt")
func _ready():
	damageable.connect("on_hit", on_damageable_hit)




func on_damageable_hit(node : Node, damage_amount : int):
	if (itself.health > 0):
		emit_signal("interrupt_state", return_state)
	elif(itself.health == 0):
		emit_signal("interrupt_state", dead_state)
		next_state = dead_state
#
#func on_exit():
	#playback.travel("move")
		#
	


