extends Node

class_name State

@export var can_move := true
signal interrupt_state(new_state : State)

var character : CharacterBody2D
var player : CharacterBody2D
var next_state : State
var previous_state : State
var playback : AnimationNodeStateMachinePlayback
func state_input(event : InputEvent):
	pass

func state_process(delta):
	pass 
	
	
func on_enter():
	pass

func on_exit():
	pass	

