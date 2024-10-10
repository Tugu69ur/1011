extends State

class_name Air_state

@export var landing_state : State
@export var double_jump_velocity := -250
var has_double_jumped := false
func state_process(delta):
	if character.is_on_floor():
		next_state = landing_state
		
func state_input(event : InputEvent):
	if event.is_action_pressed("up") and !has_double_jumped:
		double_jump()
func on_exit():
	if next_state == landing_state:
		playback.travel("fall")
		has_double_jumped = false


func double_jump():
	character.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel("double_jump")
	
