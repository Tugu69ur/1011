extends Control
@onready var ld: = $Leaderboards
@onready var sp: = $Shop
@onready var pf: = $Profile
@onready var ls: = $Level_Selection

func _process(delta):
	pass
func _on_learn_pressed():
	ls.visible=true
	sp.visible=false
	pf.visible=false
	ld.visible=false
func _on_leaderboards_pressed():
	ls.visible=false
	sp.visible=false
	pf.visible=false
	ld.visible=true
func _on_shop_pressed():
	ls.visible=false
	sp.visible=true
	pf.visible=false
	ld.visible=false
func _on_profile_pressed():
	ls.visible=false
	sp.visible=false
	pf.visible=true
	ld.visible=false
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/play/zavsariin.tscn")
