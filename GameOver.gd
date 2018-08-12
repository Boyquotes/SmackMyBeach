extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var s = " void "

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#var stress = $"YSort/Player"
#	var stress = get_tree().get_root().get_node("Player")
#	print(stress)
	#print($"../YSort/Player".stressval)
	s = get_tree().call_group("Player","getStress")
	print(s)
	#print($"../YSort/Player".getStress())
	#$Label2.text = "Score :" + str(stress)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
