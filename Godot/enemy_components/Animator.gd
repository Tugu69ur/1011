extends Node
@export var itself : CharacterBody2D
@export var anim_sprite : AnimatedSprite2D
@export var bot_state_machine : EnemyStateMachine
var n := "1"
func _process(delta):
	animation_switcher(bot_state_machine.current_state)
	
func animation_switcher(current_state : EnemyState):
	match current_state.name:
		"Patrol":
			anim_sprite.play("walk", 1.5)
		"Chase":
			anim_sprite.play("walk", 2)
		"Hit":
			anim_sprite.play("defend")
		"Attack":
			attack()
		"Dead":
			anim_sprite.play("die")
	
func attack():
	anim_sprite.play("attack_"+n)


func _on_animated_sprite_2d_animation_finished():
	if anim_sprite.animation == "attack_1":
		n = "2"
	if anim_sprite.animation == "attack_2":
		n = "3"
	if anim_sprite.animation == "attack_3":
		n = "1"
