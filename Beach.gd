extends Node2D

export (PackedScene) var Gertrude
export (PackedScene) var LaMouette

var velocity = Vector2()
var score
var cible = Vector2()
var libre = true

signal emplacement
signal stopLaMouette

func _ready():
	print('gooooo')
	get_parent().connect("stopLaMouette", self, "_on_stopLaMouette")
	$GertrudeTimer.start()
	randomize()

func _on_GertrudeTimer_timeout():
	print("gertrude timeout")
	# Choose a random location on Path2D.
	$GertrudePath/GertrudeSpawnLocation.set_offset(randi())
	# Create a Gertrude instance and add it to the scene.
	var gertrude = Gertrude.instance()
	add_child(gertrude)
	# Set the Gertrude's direction perpendicular to the path direction.
	var direction = $GertrudePath/GertrudeSpawnLocation.rotation + PI / 2
	# Set the Gertrude's position to a random location.
	gertrude.position = $GertrudePath/GertrudeSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	gertrude.rotation = direction
	# Choose the velocity.
	gertrude.set_linear_velocity(Vector2(rand_range(gertrude.MIN_SPEED, gertrude.MAX_SPEED), 0).rotated(direction))
	
	#La mouette
	# Choose a random location on Path2D.
	var point = rand_range(0,300)
	var lamouette = LaMouette.instance()
	add_child(lamouette)
	lamouette.position = Vector2(lamouette.position.x,point)

	# Set the LaMouette's direction perpendicular to the path direction.
	#for i in range(0,400):
		#lamouette.position = Vector2(i,100)
	
	#lamouette.position = Vector2(400,10)
	# Set the LaMouette's position to a random location.
	#lamouette.move_and_slide($GertrudePath/GertrudeSpawnLocation.position)
	# Add some randomness to the direction.

	# lamouette.rotation = direction
	# Choose the velocity.


func _on_Emplacement_area_entered(area):
	var position_emplacement = area.position
#	print(position_emplacement)
	
	#area.queue_free()
	print(libre)
#	print("on est la")
#	emit_signal("emplacement")
	if libre:
		area.lezarde(position_emplacement)
#		emit_signal("stopLaMouette")
	libre = false
	pass # replace with function body


func _on_Beach_emplacement():
	print("prends l'emplacement")
	emit_signal("stopLaMouette")
	pass # replace with function body


func _on_Beach_stopLaMouette():
	#$LaMouette.alors()
	print("_on_stopLaMouette")
	pass # replace with function body
