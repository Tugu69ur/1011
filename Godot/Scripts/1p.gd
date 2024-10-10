extends Control

func _ready():
	pass 

func _process(delta):
	pass

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
