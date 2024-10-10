extends Control

@onready var trans = $Transition

func _on_button_pressed():
	trans.play("fade_out")


func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/login/login.tscn")
