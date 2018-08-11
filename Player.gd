extends KinematicBody2D

var motion = Vector2()
const SPEED = 130
var screensize

func _ready():
	screensize = get_viewport_rect().size

func _physics_process(delta):
	motion = Vector2()
	# on sort de l application si on appuie sur ESC
	if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		$PlayerSpr.flip_h = false
		$PlayerSpr.play("walk")
	elif Input.is_action_pressed("ui_left"):
		motion.x =-SPEED
		$PlayerSpr.flip_h = true
		$PlayerSpr.play("walk")
	elif Input.is_action_pressed("ui_up"):
		motion.y = -SPEED
		$PlayerSpr.play("walk")
	elif Input.is_action_pressed("ui_down"):
		motion.y = SPEED
		$PlayerSpr.play("walk")
	elif Input.is_action_pressed("ui_attack"):
			print("on attaque")
	else:
		motion.x = 0
		#$PlayerSpr.flip_h = false
		$PlayerSpr.play("idle")
		
	position += motion * delta
	position.x = clamp(position.x, 0, screensize.x-64)
	position.y = clamp(position.y, 0, screensize.y-64)
	move_and_slide(motion)

func _on_Area2D_area_entered(area):
	print("dans mon espace")
	area.queue_free()
	pass # replace with function body
