extends Area2D
var damage := 15
@export var speed := 1000
@export var flip_h : bool
@export var direction : Vector2
@onready var timer := $Timer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	timer.start()
	
func _process(delta):
	position += direction * speed * delta
	if direction.x < 0:
		$Sprite2D.flip_h = true

func _on_body_entered(body):
	print(body.name)
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
			speed = 0
			queue_free()

func _on_timer_timeout():
	queue_free()
