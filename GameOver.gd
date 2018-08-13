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
	pass


func _on_Restart_pressed():
	get_tree().change_scene("res://Beach.tscn")
