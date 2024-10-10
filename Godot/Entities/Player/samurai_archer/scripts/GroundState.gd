extends State

class_name GroundState
@export var air_state : State
@export var attack_state : State
@export var jump_velocity := -300.0


func state_input(event : InputEvent):
	if event.is_action_pressed("up"):
		jump()
	if event.is_action_pressed("attack"):
		attack()
	if event.is_action_pressed("shot"):
		shot()
func state_process(delta):
	if !character.is_on_floor():
		next_state = air_state
		
func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel("jump")
func attack():
	next_state = attack_state
	playback.travel("attack_1")
func shot():
	next_state = attack_state
	playback.travel("shot")
