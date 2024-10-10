extends State

@export var ground_state : State
func _on_animation_tree_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "fall":
		next_state = ground_state
