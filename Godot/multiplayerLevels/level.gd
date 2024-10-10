extends Node2D

var spawnpoints
@export var PlayerScene : PackedScene
var arrow_scene = preload("res://Entities/Player/arrow.tscn")
var character

func _ready():
	spawnpoints = $SpawnPointForPlayer.get_children()
	var index = 0
	var keys = NakamaMultiplayer.Players.keys()
	keys.sort()
	
	for i in keys:
		var instancePlayer = PlayerScene.instantiate()
		instancePlayer.name = str(NakamaMultiplayer.Players[i].name)
		
		if NakamaMultiplayer.Players[i].name == Global.local_player_id:
			character = instancePlayer
		
		print(instancePlayer.name)
		add_child(instancePlayer)
		instancePlayer.global_position = spawnpoints[index].global_position
		index += 1

func _process(_delta):
	if Global.shooting:
		Global.shooting = false
		var arrow = arrow_scene.instantiate()
		# Arrow position and direction based on the player's facing direction
		if character.direction.x > 0:
			arrow.position = Vector2(character.position.x + 30, character.position.y + 10)
			arrow.direction = Vector2.RIGHT
		elif character.direction.x < 0:
			arrow.position = Vector2(character.position.x - 30, character.position.y + 10)
			arrow.direction = Vector2.LEFT
		$Projectiles.add_child(arrow)
	Global.player_pos = character.position
