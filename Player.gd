extends KinematicBody2D

var motion = Vector2()
const SPEED = 130
var screensize
var attacking = false
var stressval = 0

var can_move = true

enum PlayerState { STATIC, STANDING, STATIC_UP, WALK }

var state = PlayerState.STATIC

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	motion = Vector2()
	# on sort de l application si on appuie sur ESC
	if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()
		
	var has_moved = false
	
	# on traite le kick en premier
	if state in [PlayerState.WALK, PlayerState.STATIC_UP] and Input.is_action_pressed("kick"):
		if not $kickplayer.playing:
			$kickplayer.play()
		has_moved = true
		if $PlayerSpr.animation != "kick":
			$PlayerSpr.play("kick")
		else:
			$PlayerSpr.frame = 0
	
	# traitement des déplacements
	if not has_moved and state in [PlayerState.WALK, PlayerState.STATIC_UP]:
		if Input.is_action_pressed("ui_right"):
			motion.x += SPEED
			$PlayerSpr.flip_h = false
			has_moved = true
			
		if Input.is_action_pressed("ui_left"):
			motion.x -= SPEED
			$PlayerSpr.flip_h = true
			has_moved = true
			
		if Input.is_action_pressed("ui_down"):
			motion.y += SPEED
			has_moved = true
			
		if Input.is_action_pressed("ui_up"):
			motion.y -= SPEED
			has_moved = true
			
		if has_moved:
			$PlayerSpr.play("walk")
			state = PlayerState.WALK
			if not $StaticTimer.is_stopped():
				$StaticTimer.stop()
						
	elif state  == PlayerState.STATIC:
		if Input.is_action_pressed("ui_up"):
			$PlayerSpr.play("standup")
			motion.y -= SPEED
			state = PlayerState.STANDING
		
	if not has_moved:
		if state == PlayerState.WALK:
			$PlayerSpr.play("debout")
			state = PlayerState.STATIC_UP
		elif state == PlayerState.STATIC_UP:
			if $StaticTimer.is_stopped():
				$StaticTimer.start()

			
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
		
func getStress():
	return stressval

func _on_PlayerSpr_animation_finished():
	if $PlayerSpr.animation == "standup":
		state = PlayerState.STATIC_UP
	elif $PlayerSpr.animation == "standdown":
		$PlayerSpr.play("static")
		state = PlayerState.STATIC
		
func _on_StaticTimer_timeout():
	state = PlayerState.STANDING
	$PlayerSpr.play("standdown")
	
