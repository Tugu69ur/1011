extends Area2D
@export var itself : CharacterBody2D
@onready var hitbox := $CollisionShape2D
var damage := 10
var facing_right_pos = Vector2(38, -38)
var facing_left_pos = Vector2(-38, -38)
func _ready():
	monitoring = false
	itself.connect("facing_direction_changed", _on_player_facing_direction_changed)


func _on_player_facing_direction_changed(facing_right : bool):
	if facing_right:
		hitbox.position = facing_right_pos
	else:
		hitbox.position = facing_left_pos


func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(itself.damage)
