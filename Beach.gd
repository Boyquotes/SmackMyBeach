extends Node2D

export (PackedScene) var Gertrude
var score

func _ready():
	print('gooooo')
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
