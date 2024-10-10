extends Area2D
var damage := 10
@export var player : Player
@onready var Hitbox := $CollisionShape2D
func _ready():
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)
func _on_body_entered(body):
	print(body.name)
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)

func _on_player_facing_direction_changed(facing_right : bool):
	if facing_right:
		Hitbox.position = Hitbox.facing_right
	else:
		Hitbox.position = Hitbox.facing_left
		

