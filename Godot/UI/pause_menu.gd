extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	$PanelContainer/VBoxContainer/resume.disabled = true
	$PanelContainer/VBoxContainer/restart.disabled = true
	$PanelContainer/VBoxContainer/quit.disabled = true
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
		$PanelContainer/VBoxContainer/resume.disabled = false
		$PanelContainer/VBoxContainer/restart.disabled = false
		$PanelContainer/VBoxContainer/quit.disabled = false
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
	
func _on_quit_pressed():
	get_tree().quit()
		

func _process(delta):
	testEsc()


