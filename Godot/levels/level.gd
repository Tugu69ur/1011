extends Node2D

var spawnpoints
@export var playerScene : PackedScene

func _ready():
	spawnpoints = get_tree().get_nodes_in_group("SpawnPoint")
	var index = 0
	var keys = NakamaMultiplayer.Players.keys()
	keys.sort()
	for i in keys:
		var instancedPlayer = playerScene.instantiate()
		instancedPlayer.name = str(NakamaMultiplayer.Players[i].name)
		
		add_child(instancedPlayer)
		
		instancedPlayer.global_position = spawnpoints[index].global_position
		
		index += 1
	pass # Replace with function body.
func _process(_delta):
		#if Global.shooting:
			#Global.shooting = false
			#var arrow = arrow_scene.instantiate()
			#if character.direction.x > 0:
				#arrow.position = Vector2(character.position.x + 30, character.position.y + 10)
				#arrow.direction = Vector2.RIGHT
			#elif character.direction.x < 0:
				#arrow.position = Vector2(character.position.x - 30, character.position.y + 10)
				#arrow.direction = Vector2.LEFT
			#$Projectiles.add_child(arrow)
		#Global.player_pos = character.position
	pass

