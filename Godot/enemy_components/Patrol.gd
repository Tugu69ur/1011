extends EnemyState

@export var chase_state : EnemyState

@onready var timer := $Timer

var dir = 1
func state_process(delta):
	
	patrol()
	
func on_enter():
	timer.start()
	
	
	
func on_exit():
	pass
func patrol():
	if timer.is_stopped() and dir == 1:
		dir = -1
		itself.direction = Vector2.RIGHT
		timer.start()
		
	if timer.is_stopped() and dir == -1:
		dir = 1
		itself.direction = Vector2.LEFT
		timer.start()


func _on_detect_area_body_entered(body):
	for child in body.get_children():
		if child is PlayerToken:
			get_parent().itself.locked_player = body
			next_state = chase_state	
			
