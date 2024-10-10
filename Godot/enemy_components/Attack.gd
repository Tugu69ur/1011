extends EnemyState


@export var return_state : EnemyState
@onready var timer1 = $Timer1
@onready var timer2 = $Timer2
var locked_player : CharacterBody2D
var damage : int

func on_enter():
	timer1.start()
	damage = itself.damage
	locked_player = itself.locked_player
func state_process(delta):
	if abs(itself.position.direction_to(locked_player.position)) > Vector2(0.5, 0):
		itself.direction.x = 0
		
	
	
	
func on_exit():
	pass


			


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack_1":
		if timer1.is_stopped():
			next_state = return_state
			playback.travel("move")
		else:
			playback.travel("attack_2")
			timer2.start()
	if anim_name == "attack_2":
		if timer2.is_stopped():
			next_state = return_state
			playback.travel("move")
		else:
			playback.travel("attack_3")
	if anim_name == "attack_3":
		next_state = return_state
		playback.travel("move")





