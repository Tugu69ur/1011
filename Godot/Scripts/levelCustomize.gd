extends Control
@onready var timer = $Timer
var selectedMode =""

var info=[
	preload("res://Vid/Screenshot 2024-09-24 092145.png"),
	preload("res://Vid/2dcombat.jpg"),
	preload("res://Vid/Best-Final-Boss-Fights-In-2D-Platforming-Games.jpg"),
	preload("res://Vid/Gemini_Generated_Image_effinheffinheffi.jpg"),
	preload("res://Vid/fcd4lhhkccj91.jpg"),
	preload("res://Vid/survival109141280jpg-e97a7a_160w.jpg")
]

var character_animations = [
	preload("res://Levels/characters/demon-idle.png"),
	preload("res://Levels/characters/fire-skull.png"),
	preload("res://Levels/characters/gothic-hero-idle.png"),
	preload("res://Levels/characters/Spritesheet.png"),
	preload("res://Levels/characters/sunny-dragon-fly.png")
]

var map_images = [
	preload("res://Levels/maps/gothic-castle-preview.png"),
	preload("res://Levels/maps/mist-forest-background-previewx2.png"),
	preload("res://Levels/maps/night-town-background-previewx2.png"),
	preload("res://Levels/maps/preview-day-platformer.png"),
	preload("res://Levels/maps/preview-sci-fi-environment-tileset.png")
]

var map_infos = [
	"gothic-castle",
	"mist-forest",
	"night-town",
	"platformer",
	"sci-fi-environment"
]

var char_infos = [
	"demon-idle",
	"fire-skull",
	"gothic-hero-idle",
	"Spritesheet",
	"sunny-dragon-fly"
]

var map_scenes = [
	"res://Levels/level_1.tscn",
	"res://levels/maps/mist-forest/mist-forest.tscn",
	"res://Levels/level_3.tscn",
	"res://Levels/level_4.tscn",
	"res://Levels/level_5.tscn"
]

var current_map_index = 0
var current_char_index = 0
var toggledInfo = 0
var selected_mode_sm =""
var selected_mode_be =""
var selected_mode_ps =""
var selected_t2 =""
var map
var selected_map_scene
var selected_char
var round
var q


func _on_next_button_pressed():
	current_map_index += 1
	if current_map_index >= map_images.size():
		current_map_index = 0  
	update_map_preview()

func _on_previous_button_pressed():
	current_map_index -= 1
	if current_map_index < 0:
		current_map_index = map_images.size() - 1  
	update_map_preview()

func update_map_preview():
	$Panel4/MapPreview.texture = map_images[current_map_index]
	$Panel4/info.text = map_infos[current_map_index]

func _on_button_pressed():
	#Map
	selected_map_scene = map_scenes[current_map_index]
	#Character
	selected_char = char_infos[current_char_index]
	#Mode
	if($Panel/Single.button_pressed):
		selected_mode_sm = "SinglePlayer"
		if($Panel/Boss.button_pressed):
			selected_mode_be = "Boss"
		else:
			selected_mode_be = "Endless"
	else :
		selected_mode_sm = "MultiPlayer"
		if($Panel/PvP.button_pressed):
			selected_mode_ps = "PvP"
		else:
			selected_mode_ps = "Survival"
	#Question
	#if($Panel2/DB.button_pressed):
		#Global.level_custom_data["question"]
	#Gameplay
	if($Panel3/turnBased.button_pressed):
		selected_t2 = "TurnBased"
	else:
		selected_t2 = "2D Combat"
	#MapName
	map = $Save.text
	#Round
	round = $Panel6/LineEdit.text
	#Question
	q = $Panel6/LineEdit2.text
	#Add question
	NakamaManager.level_custom_data["selected_map"] = selected_map_scene
	NakamaManager.level_custom_data["selected_char"] = selected_char
	NakamaManager.level_custom_data["selected_mode"] = {
		"SingleMulti": selected_mode_sm,
		"BossEndless": selected_mode_be,
		"PvpSurvival": selected_mode_ps
	}

	# Handle question data
	#if $Panel2/DB.button_pressed:
		#NakamaManager.level_custom_data["question"] = "Your question here"  # Set your question logic here
	
	# Gameplay type
	if $Panel3/turnBased.button_pressed:
		NakamaManager.level_custom_data["gameplay"] = "TurnBased"
	else:
		NakamaManager.level_custom_data["gameplay"] = "2D Combat"
	# Store additional data
	NakamaManager.level_custom_data["map_name"] = $Save.text
	NakamaManager.level_custom_data["round"] = $Panel6/LineEdit.text
	NakamaManager.level_custom_data["question_num"] = $Panel6/LineEdit2.text
	NakamaManager.send_level_data_to_nakama()
	$Panel/Single.button_pressed = false
	$Panel/Boss.button_pressed = false
	$Panel/Endless.button_pressed = false
	$Panel/Multi.button_pressed = false
	$Panel/PvP.button_pressed = false
	$Panel/Survival.button_pressed = false
	$Panel2/DB.button_pressed = false
	$Panel2/DB2.button_pressed = false
	$Panel3/turnBased.button_pressed = false
	$Panel3/dCombat.button_pressed = false
	$Save.text=""
	$Panel6/LineEdit.text=""
	$Panel6/LineEdit2.text=""
func _on_previous_button_2_pressed():
	current_char_index -= 1
	if current_char_index < 0:
		current_char_index = character_animations.size() - 1
	update_character_preview()

func update_character_preview():
	$Panel4/CharacterPreview.play(str(current_char_index))
	$Panel4/info1.text = char_infos[current_char_index]
	
func _on_next_button_2_pressed():
	current_char_index += 1
	if current_char_index >= character_animations.size():
		current_char_index = 0 
	update_character_preview()

func update_review():
	$Panel5/Info.texture = info[toggledInfo]

func _on_use_db_pressed():
	$qShow.visible = true
	if($Panel2/DB.button_pressed == false):
		$Panel2/DB.button_pressed = true
	if($Panel2/DB2.button_pressed == true):
		$Panel2/DB2.button_pressed=false
	$Panel2/DB2.disabled = true
	$Panel2/CustomQ.disabled = true

func _on_custom_q_pressed():
	$UI.visible = true
	get_tree().change_scene_to_file("res://Scenes/options/add_question.tscn")
	#$Panel2/DB2.disabled = false

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_single_pressed():
	toggledInfo=0
	update_review()
	$Panel5/info.text="シングルプレイヤーは、一人用のゲームモードです。"
	if($Panel/Single.button_pressed == false):
		$Panel/Single.button_pressed = true
		$Panel5/info.text="シングルプレイヤーは、一人用のゲームモードです。"
		toggledInfo=0
		update_review()
	if($Panel/Multi.button_pressed == true):
		$Panel/Multi.button_pressed=false
		$Panel5/info.text="シングルプレイヤーは、一人用のゲームモードです。"
		toggledInfo=0
		update_review()
	if($Panel/PvP.button_pressed == true):
		$Panel/PvP.button_pressed = false
		$Panel/Single.button_pressed=true
		$Panel5/info.text="シングルプレイヤーは、一人用のゲームモードです。"
		toggledInfo=0
		update_review()
	if($Panel/Survival.button_pressed):
		$Panel/Survival.button_pressed = false
		$Panel/Single.button_pressed=true
		$Panel5/info.text="シングルプレイヤーは、一人用のゲームモードです。"
		toggledInfo=0
		update_review()

func _on_boss_pressed():
	if($Panel/Multi.button_pressed != true):
		toggledInfo=2
		update_review()
		$Panel5/info.text="Boss"
		if($Panel/Boss.button_pressed == false):
			$Panel/Boss.button_pressed = true
			toggledInfo=2
			update_review()
			$Panel5/info.text="Boss"
		if($Panel/Endless.button_pressed == true):
			$Panel/Endless.button_pressed=false
			$Panel5/info.text="Boss"
			toggledInfo=2
			update_review()
	else:
		$Panel/Boss.button_pressed = false
func _on_endless_pressed():
	if($Panel/Multi.button_pressed != true):
		toggledInfo=3
		update_review()
		$Panel5/info.text="Endless"
		if($Panel/Endless.button_pressed == false):
			$Panel/Endless.button_pressed = true
			toggledInfo=3
			update_review()
			$Panel5/info.text="Endless"
		if($Panel/Boss.button_pressed == true):
			$Panel/Boss.button_pressed=false
			$Panel5/info.text="Endless"
			toggledInfo=3
			update_review()
	else:
		$Panel/Endless.button_pressed = false
		
func _on_multi_pressed():
	toggledInfo=1
	update_review()
	$Panel5/info.text="マルチプレイヤーは、複数人で遊ぶゲームモードです。"
	if($Panel/Multi.button_pressed == false):
		$Panel/Multi.button_pressed=true
		$Panel5/info.text="マルチプレイヤーは、複数人で遊ぶゲームモードです。"
		toggledInfo=1
		update_review()
	if($Panel/Single.button_pressed == true):
		$Panel/Single.button_pressed = false
		$Panel5/info.text="マルチプレイヤーは、複数人で遊ぶゲームモードです。"
		toggledInfo=1
		update_review()
	if($Panel/Boss.button_pressed == true):
		$Panel/Boss.button_pressed = false
		$Panel/Multi.button_pressed=true
		$Panel5/info.text="マルチプレイヤーは、複数人で遊ぶゲームモードです。"
		toggledInfo=1
		update_review()
	if($Panel/Endless.button_pressed == true):
		$Panel/Endless.button_pressed = false
		$Panel/Multi.button_pressed=true
		$Panel5/info.text="マルチプレイヤーは、複数人で遊ぶゲームモードです。"
		toggledInfo=1
		update_review()

func _on_pv_p_pressed():
	if($Panel/Single.button_pressed != true):
		$Panel5/info.text="Hamtaigaa."
		toggledInfo=4
		update_review()
		if($Panel/PvP.button_pressed == false):
			$Panel/PvP.button_pressed = true
			toggledInfo=4
			update_review()
			$Panel5/info.text="Hamtaigaa."
		if($Panel/Survival.button_pressed == true):
			$Panel/Survival.button_pressed=false
			$Panel5/info.text="Hamtaigaa."
			toggledInfo=4
			update_review()
	else:
		$Panel/PvP.button_pressed = false

func _on_survival_pressed():
	if($Panel/Single.button_pressed != true):
		$Panel5/info.text="Medal3."
		toggledInfo=5
		update_review()
		if($Panel/Survival.button_pressed == false):
			$Panel/Survival.button_pressed = true
			toggledInfo=5
			update_review()
			$Panel5/info.text="Medal3."
		if($Panel/PvP.button_pressed == true):
			$Panel/PvP.button_pressed=false
			$Panel5/info.text="Medal3."
			toggledInfo=5
			update_review()
	else:
		$Panel/Survival.button_pressed = false

func _on_db_pressed():
	if($Panel2/DB.button_pressed == false):
		$Panel2/DB.button_pressed = true
	if($Panel2/DB2.button_pressed == true):
		$Panel2/DB2.button_pressed=false
		
func _on_db_2_pressed():
	if($Panel2/DB2.button_pressed == false):
		$Panel2/DB2.button_pressed = true
	if($Panel2/DB.button_pressed == true):
		$Panel2/DB.button_pressed=false


func _on_turn_based_pressed():
	if($Panel3/turnBased.button_pressed == false):
		$Panel3/turnBased.button_pressed = true
	if($Panel3/dCombat.button_pressed == true):
		$Panel3/dCombat.button_pressed=false

func _on_d_combat_pressed():
	if($Panel3/turnBased.button_pressed == true):
		$Panel3/turnBased.button_pressed = false
	if($Panel3/dCombat.button_pressed == false):
		$Panel3/dCombat.button_pressed=true

