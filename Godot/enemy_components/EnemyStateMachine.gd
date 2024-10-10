extends Node
class_name EnemyStateMachine

@export var itself : CharacterBody2D
@export var current_state : EnemyState
@export var states : Array[EnemyState]
@export var animation_tree : AnimationTree
func _ready():
	print(current_state)
	for child in get_children():
		if(child is EnemyState):
			states.append(child)
			child.itself = itself
			child.playback = animation_tree["parameters/playback"]
			child.connect("interrupt_state", on_state_interrupt_state)
			
func _physics_process(delta):
	if current_state.next_state != null:
		switch_state(current_state.next_state)
	
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move


func switch_state(new_state : EnemyState):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	current_state.on_enter()

func on_state_interrupt_state(new_state : EnemyState):
	switch_state(new_state)


