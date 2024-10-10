extends Control

var char_infos = [
	"demon-idle",
	"fire-skull",
	"gothic-hero-idle",
	"Spritesheet",
	"sunny-dragon-fly"
]

var character_animations = [
	preload("res://Levels/characters/demon-idle.png"),
	preload("res://Levels/characters/fire-skull.png"),
	preload("res://Levels/characters/gothic-hero-idle.png"),
	preload("res://Levels/characters/Spritesheet.png"),
	preload("res://Levels/characters/sunny-dragon-fly.png")
]

var current_char_index = 0
var toggledInfo = 0

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
