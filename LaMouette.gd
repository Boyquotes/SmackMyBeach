extends Area2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
export (int) var MOVE_SPEED = 75
var aleatoire

func _ready():
	$AnimatedSprite.set_flip_h(true)
	$AnimatedSprite.play("vol")
	pass
	
func _process(delta):
	var input_dir = Vector2()
	input_dir.x = 1.0
	aleatoire = rand_range(0,3)
	position += (delta * MOVE_SPEED) * input_dir

func lezarde(position_emplacement):
	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play("idle")
	position.x = position_emplacement.x
	position.y = position_emplacement.y
	MOVE_SPEED = 0

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
