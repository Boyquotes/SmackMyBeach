extends Area2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED
export (int) var MOVE_SPEED = 150
export (int) var SCORE = 500

var target= Vector2()

func _ready():
	MOVE_SPEED *= 0.7 + randf() * 0.6 
	var rect = get_viewport_rect()
	rect.size.y -= 100
	target.x = randf() * rect.size.x + rect.position.x
	target.y = randf() * rect.size.y + rect.position.y
	$AnimatedSprite.play("walk")
	
func _process(delta):
	var input_dir = (target - position).normalized()
	if (input_dir.x < 0):
		$AnimatedSprite.flip_h = true
	position += (delta * MOVE_SPEED) * input_dir
	if ((target - position).length() < 3):
		lezarde()

func lezarde():
	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play("idle")
	MOVE_SPEED = 0

func _on_Visibility_screen_exited():
	queue_free()
	