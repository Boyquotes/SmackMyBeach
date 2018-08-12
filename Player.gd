extends KinematicBody2D

var motion = Vector2()
const SPEED = 130
var screensize
var attacking = false
var stressval = 0

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	motion = Vector2()
	# on sort de l application si on appuie sur ESC
	if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()
	
	$PlayerSpr.play("idle")
	if Input.is_action_pressed("ui_right"):
		motion.x += SPEED
		$PlayerSpr.flip_h = false
		$PlayerSpr.play("walk")
	if Input.is_action_pressed("ui_left"):
		motion.x -= SPEED
		$PlayerSpr.flip_h = true
		$PlayerSpr.play("walk")
	if Input.is_action_pressed("ui_up"):
		motion.y -= SPEED
		$PlayerSpr.play("walk")
	if Input.is_action_pressed("ui_down"):
		motion.y += SPEED
		$PlayerSpr.play("walk")
	
	attacking = motion.length() != 0

	position += motion * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 32, screensize.y)
	move_and_slide(motion)
	
	var areas = $EspaceVital.get_overlapping_areas()
	var ennemies = []
	var score_ennemis_espace_vital = 0
	for area in areas:
		if area.is_in_group("ennemis"):
			ennemies.push_back(area)
			score_ennemis_espace_vital += ($"EspaceVital/CollisionShape2D".shape.radius - (area.global_position - global_position).length()) / $"EspaceVital/CollisionShape2D".shape.radius
	score_ennemis_espace_vital = clamp(score_ennemis_espace_vital, 0, 4) / 4
	
	if (!attacking):
		stressval -= 0.2 * delta
	stressval += 0.3 * score_ennemis_espace_vital * delta
	stressval = clamp(stressval, 0, 1)
	
	# Red player
	$PlayerSpr.modulate = Color(1.0, 1.0 - score_ennemis_espace_vital, 1.0 - score_ennemis_espace_vital)

func _on_Area2D_area_entered(area):
	if (attacking):
		area.queue_free()
