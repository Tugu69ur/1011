extends Node
class_name EnemyState

@export var can_move := true
signal interrupt_state(new_state : EnemyState)
var playback : AnimationNodeStateMachinePlayback
var itself : CharacterBody2D
var target : CharacterBody2D
var next_state : EnemyState
var pre_state : EnemyState



func state_process(delta):
	pass
	
func on_enter():
	pass
	
func on_exit():
	pass
