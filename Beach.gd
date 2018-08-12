extends Node2D

export (PackedScene) var Gertrude
export (PackedScene) var LaMouette

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
	var poste = get_node("YSort/Poste")
	print("play animation")
	poste.get_node("AnimationPlayer").play("explosionPoste")
	randomize()

func _process(delta):
	time_score =  floor((OS.get_ticks_msec() - initial_time) / 50) * 10
	$"header/Label".text = "Score: " + str(time_score) 
	
	$"header/stress".value = $"YSort/Player".stressval * 100

func moins_de_place():
	score -= 1
	#get_node("HUD/Vie").text = str(score)
	

func _on_GertrudeTimer_timeout():
	
	var array = [LaMouette, Gertrude]
	#La femme maillot rouge
	var gertrude = array[randi() % 2].instance()
	$"GertrudePath/GertrudeSpawnLocation".unit_offset = randf()
	gertrude.position = $"GertrudePath/GertrudeSpawnLocation".global_position
	$YSort.add_child(gertrude)
	
	count += 1
	if count == 5:
		moins_de_place()
		count = 0
	# Set the LaMouette's direction perpendicular to the path direction.
	#for i in range(0,400):
		#lamouette.position = Vector2(i,100)
	
	#lamouette.position = Vector2(400,10)
	# Set the LaMouette's position to a random location.
	#lamouette.move_and_slide($GertrudePath/GertrudeSpawnLocation.position)
	# Add some randomness to the direction.

	# lamouette.rotation = direction
	# Choose the velocity.
#func _on_Beach_emplacement():
#	print("prends l'emplacement")
#	#emit_signal("stopLaMouette")
#	pass # replace with function body
#
#
#func _on_Beach_stopLaMouette():
#	#$LaMouette.alors()
#	print("_on_stopLaMouette")
#	pass # replace with function body

func _on_Emplacement_area_entered(area):
	if area.is_in_group('Player'):
		print('le joeur est la')
	if !area.is_in_group("Player"):
		var position_emplacement = area.position
	#	print("111")
	#	print(area)
	#	print(emplacement_libre)
		if emplacement_libre:
			area.lezarde(position_emplacement)
			moins_de_place()
			emplacement_libre = false
	pass # replace with function body
