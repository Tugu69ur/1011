extends Node2D

#var level_custom_data = Global.level_custom_data
func _ready():
	##Player spawn
	#if level_custom_data.mode == "singleplayer":
		var player_spawn_point := $SpawnPointForPlayer/SinglePlayer
		$SamuraiArcher.position = player_spawn_point.position
		
		
	

	#var round_num = level_custom_data.round_num
	#var question_num = level_custom_data.level_num
	#var mode = level_custom_data.mode
	#var sub_mode = level_custom_data.sub_mode
