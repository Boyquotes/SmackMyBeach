extends Node2D

export (PackedScene) var Gertrude
export (PackedScene) var LaMouette
export (PackedScene) var Minot
export (PackedScene) var Lola
#export (PackedScene) var Poissons
#export (PackedScene) var Requin


var count = 0
var velocity = Vector2()
var score = 100
var cible = Vector2()
var emplacement_libre = true
var emplacement_libre2 = true
var emplacement_libre3 = true

var time_score
var initial_time

var gertrude_count = 0
var gertrude_wait = 1
var gertude_initial = 1

enum BeachState { RUNNING, GAME_OVER }

var state = BeachState.RUNNING

signal emplacement

func _ready():
	initial_time = OS.get_ticks_msec()
	$GertrudeTimer.start()
	randomize()

func _process(delta):
	if not state == BeachState.GAME_OVER:
		time_score =  floor((OS.get_ticks_msec() - initial_time) / 50) * 10
		$"header/Label".text = "Score: " + str(time_score)
		$"header/stress".value = $"YSort/Player".stressval * 100
	else:
		if Input.is_action_pressed("kick"):
			get_tree().change_scene("res://Beach.tscn")
	
	if $"YSort/Player".stressval * 100 == 100:
		state = BeachState.GAME_OVER
		$YSort/Player.disable()
		$gameovertimer.start()
		$gameoverlabel.show()

func _on_GertrudeTimer_timeout():
	var array = [LaMouette, Gertrude, Minot, Lola]
	#La femme maillot rouge
	var gertrude = array[randi() % 4].instance()
	$"GertrudePath/GertrudeSpawnLocation".unit_offset = randf()
	gertrude.position = $"GertrudePath/GertrudeSpawnLocation".global_position
	$YSort.add_child(gertrude)

	gertrude_count += 1
	
	if gertrude_count % 10 and gertrude_wait > 0.1:
		gertrude_wait -= 0.05 * gertrude_count / 100
		$GertrudeTimer.wait_time = gertrude_wait
	elif gertrude_wait <= 0.1:
		if gertude_initial > 0.1:
			gertude_initial -= 0.1
		gertrude_wait = gertude_initial
		$GertrudeTimer.wait_time = gertude_initial
		

func _on_seaplayer_finished():
	$seaplayer.play()

func _on_seagulltimer_timeout():
	# print("_on_seagulltimer_timeout")
	$seagullplayer.play()
	$seagulltimer.wait_time = 110 + randf() * 30
	$seagulltimer.start()


func _on_gameovertimer_timeout():
	get_tree().change_scene("res://GameOver.tscn")
