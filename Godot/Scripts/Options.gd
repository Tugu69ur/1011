extends Control

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value/5)

func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)

func _on_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1152,648))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_add_q_pressed():
	get_tree().change_scene_to_file("res://Scenes/options/add_question.tscn")

