extends Area2D


func _ready():
	var itself = get_parent()
	itself.connect("facing_direction_changed", change_pos)

func change_pos(facing_right : bool):
	if facing_right:
		rotation_degrees = 0
	else:
		rotation_degrees = 170


