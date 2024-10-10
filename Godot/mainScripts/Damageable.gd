extends Node
class_name Damageable
signal  on_hit(node: Node, damage_taken : int)

@export var health := 30:
	get:
		return health
	set(value):
		Global.emit_signal("on_health_changed", get_parent(), value - health)
		health = value

func hit(damage : int):
	health -= damage
	print("damaged by 10")
	emit_signal("on_hit", get_parent(),damage)

		


func _on_timer_timeout():
	get_parent().queue_free()
