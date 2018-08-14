extends KinematicBody2D

export var ignore_input = false

var motion = Vector2()
const SPEED = 130
var screensize
var attacking = false
var stressval = 0

var can_move = true

enum PlayerState { STATIC, STANDING, STATIC_UP, WALK, DISABLED }

var state = PlayerState.STATIC

signal hit

func _ready():
	screensize = get_viewport_rect().size
	$PlayerSpr.play("static")

func _process(delta):
	motion = Vector2()
	# on sort de l application si on appuie sur ESC
	if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()
		
	if state == PlayerState.DISABLED or ignore_input:
		return
		
	var has_moved = false
	
	# on traite le kick en premier
	if Input.is_action_pressed("kick") and state in [PlayerState.WALK, PlayerState.STATIC_UP]:
		if not $kickplayer.playing:
			$kickplayer.play()
		has_moved = true
		attacking = true
		
		if $PlayerSpr.animation != "kick":
			$PlayerSpr.play("kick")
		else:
			# si on kick déjà, on skip le début  de l'anim : feedback plus rapide
			$PlayerSpr.frame = 10
		
		if not $kicktimer.is_stopped():
			$kicktimer.stop()
			
		$kicktimer.start()
		
		# recherche des ennemis et destruction
		destroy_ennemies($Tuage.get_overlapping_areas())
		
	
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
			if not $footplayer.playing:
				$footplayer.volume_db = - 15 - randf() * 5
				$footplayer.pitch_scale = 0.8 + randf() * 0.1
				$footplayer.play()
				
			state = PlayerState.WALK
			if not $StaticTimer.is_stopped():
				$StaticTimer.stop()
						
	elif state  == PlayerState.STATIC:
		if Input.is_action_pressed("ui_up"):
			$PlayerSpr.play("standup")
			$upstandplayer.play()
			motion.y -= SPEED
			state = PlayerState.STANDING
		
	if not has_moved:
		if state == PlayerState.WALK:
			$PlayerSpr.play("debout")
			state = PlayerState.STATIC_UP
		elif state == PlayerState.STATIC_UP:
			if $StaticTimer.is_stopped():
				$StaticTimer.start()

			
	# attacking = motion.length() != 0

	position += motion * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 32, screensize.y)
	move_and_slide(motion)
	
	var ennemies = []
	var score_ennemis_espace_vital = 0
	for area in $EspaceVital.get_overlapping_areas():
		if area.is_in_group("ennemis"):
			ennemies.push_back(area)
			score_ennemis_espace_vital += ($"EspaceVital/CollisionShape2D".shape.radius - (area.global_position - global_position).length()) / $"EspaceVital/CollisionShape2D".shape.radius
	score_ennemis_espace_vital = clamp(score_ennemis_espace_vital, 0, 4) / 4
	
	if not attacking:
		stressval -= 0.2 * delta
	stressval += 0.3 * score_ennemis_espace_vital * delta
	stressval = clamp(stressval, 0, 1)
	
	# Red player
	$PlayerSpr.modulate = Color(1.0, 1.0 - score_ennemis_espace_vital, 1.0 - score_ennemis_espace_vital)

func _on_Area2D_area_entered(area):
	if attacking:
		destroy_ennemies([area])
		
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
	$downstandplayer.play()
	
func _on_kicktimer_timeout():
	attacking = false

func enable():
	show()
	state = PlayerState.STATIC
		
func disable():
	hide()
	state = PlayerState.DISABLED
	
func destroy_ennemies(areas):
	var has_destroyed = false
	for area in areas:
		if not area.is_in_group("ennemis"):
			continue
			
		
		var tween = area.get_node("tween")
		
		if not tween:
			tween = Tween.new()
			tween.name = "tween"
			tween.repeat = false
			area.add_child(tween)
			
		if not tween.is_active():
			# on instancie la scène de hit
			# pour le moment, il y a les points, mais on pourrait rajouter du feedback
			has_destroyed = true
			var hit_points = ResourceLoader.load("res://hit_points.tscn")
			var instance = hit_points.instance()
			get_parent().add_child(instance)
			instance.position = Vector2(area.position.x, area.position.y - 50)
			instance.label.text = "%s" % area.SCORE
			instance.animate()
		
		# on fabrique une coordonnée pour éjecter l'objet de l'écran
		# et qui s'autodétuira à cause du callback de visibilité sur celui-ci	
		var dx = 0
		if $PlayerSpr.flip_h:
			dx = - area.position.x - 100
		else:
			dx = screensize.x - area.position.x + 100
		tween.interpolate_property(area, "position", area.position, area.position + Vector2(dx, 0), 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()
			
		# TODO : bouh pas beau ! refactor avec un signal !
		get_parent().get_parent().time_score +=  area.SCORE
		#emit_signal(hit)
		
	return has_destroyed