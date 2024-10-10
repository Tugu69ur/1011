extends EnemyState

func on_enter():
	playback.travel("die")
	$Timer.start()


func _on_timer_timeout():
	get_parent().get_parent().queue_free()
