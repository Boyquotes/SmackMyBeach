extends Node2D

export (PackedScene) var Gertrude
export (PackedScene) var LaMouette

var velocity = Vector2()
var score
var cible = Vector2()
var emplacement_libre = true
var emplacement_libre2 = true
var emplacement_libre3 = true

signal emplacement

func _ready():
	$GertrudeTimer.start()
	randomize()

func _process(delta):
#	print('la')
#	print(emplacement_libre)
#	print('la2')
#	print(emplacement_libre2)
#	print('la3')
#	print(emplacement_libre3)
	pass
	
func _on_GertrudeTimer_timeout():
	#La femme maillot rouge
	var point = rand_range(0,300)
	var gertrude = Gertrude.instance()
	add_child(gertrude)
	gertrude.position = Vector2(gertrude.position.x,point)
	
	#La mouette
	var point2 = rand_range(0,300)
	var lamouette = LaMouette.instance()
	add_child(lamouette)
	lamouette.position = Vector2(lamouette.position.x,point2)

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
			emplacement_libre = false
	pass # replace with function body


func _on_Emplacement2_area_entered(area2):
	if area2.is_in_group('Player'):
		print('le joeur est la')
	if !area2.is_in_group("Player"):
		var position_emplacement = area2.position
	#	print("222")
	#	print(area2)
	#	print(emplacement_libre2)
		if emplacement_libre2:
			area2.lezarde(position_emplacement)
			emplacement_libre2 = false
	pass # replace with function body


func _on_Emplacement3_area_entered(area3):
	if area3.is_in_group('Player'):
		print('le joeur est la')
	if !area3.is_in_group("Player"):
		var position_emplacement = area3.position
	#	print("333")
	#	print(area3)
	#	print(emplacement_libre3)
		if emplacement_libre3:
			area3.lezarde(position_emplacement)
			emplacement_libre3 = false
	pass # replace with function body
