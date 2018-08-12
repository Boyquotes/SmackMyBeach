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

signal emplacement

func _ready():
	initial_time = OS.get_ticks_msec()
	$GertrudeTimer.start()
	randomize()

func _process(delta):
	time_score =  floor((OS.get_ticks_msec() - initial_time) / 50) * 10
	$"header/Label".text = "Score: " + str(time_score)
	$"header/stress".value = $"YSort/Player".stressval * 100
	if $"YSort/Player".stressval * 100 == 100:
		get_tree().change_scene("res://GameOver.tscn")

func _on_GertrudeTimer_timeout():
	var array = [LaMouette, Gertrude, Minot, Lola]
	#La femme maillot rouge
	var gertrude = array[randi() % 4].instance()
	$"GertrudePath/GertrudeSpawnLocation".unit_offset = randf()
	gertrude.position = $"GertrudePath/GertrudeSpawnLocation".global_position
	$YSort.add_child(gertrude)
