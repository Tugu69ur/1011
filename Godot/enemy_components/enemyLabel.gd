extends Label

@export var state_machine : EnemyStateMachine

func _process(delta):
	text =  "State: " + state_machine.current_state.name

