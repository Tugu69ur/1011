extends EnemyState

@export var bot_state_machine : EnemyStateMachine
@export var attack_state : EnemyState
var locked_player : CharacterBody2D

func on_enter():
	locked_player = itself.locked_player
	itself.speed += 20
	
func state_process(delta):
	itself.direction = (locked_player.position - itself.position).normalized()

	if abs(itself.position.direction_to(locked_player.position)) < Vector2(0.5, 0):
		itself.direction.x = 0
		playback.travel("attack_1")
		next_state = attack_state



	

	
func on_exit():
	itself.speed -= 20



		

	
	


