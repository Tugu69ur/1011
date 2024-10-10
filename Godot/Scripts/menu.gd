extends Control

func _ready():
	pass

func _on_exit_pressed():
	get_tree().quit()


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options/options.tscn")


func _on_level_customize_pressed():
	get_tree().change_scene_to_file("res://Scenes/create_level/level_customize.tscn")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/play/zavsariin.tscn")
