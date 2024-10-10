extends Node
var level_custom_data = {
	#"map_name": "",
	#"mode": "",
	#"sub_mode": "",
	#"player_character": "",
	#"round_num": 3,
	#"question_num" : 3,
}
var shooting := false
signal on_health_changed(node: Node, amount_changed: int)
var player_pos : Vector2
