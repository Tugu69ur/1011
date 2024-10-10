extends State

@export var return_state : State
@onready var timer1 := $Timer
@onready var timer2 := $Timer2
func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		timer1.start()
		if !timer1.is_stopped():
			timer2.start()
		
		

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack_1":
		if timer1.is_stopped():
			next_state = return_state
			playback.travel("move")
		else:
			playback.travel("attack_2")
	if anim_name == "attack_2":
		if timer2.is_stopped():
			next_state = return_state
			playback.travel("move")
		else:
			playback.travel("attack_3")
	if anim_name == "attack_3":
		next_state = return_state
		playback.travel("move")
	if anim_name == "shot":
		Global.shooting = true
		next_state = return_state
		playback.travel("move")
	
