extends Node2D

func _input(event):
	if event.is_action("kick"):
		get_tree().change_scene("res://Beach.tscn")


func _on_Tween_tween_step(object, key, elapsed, value):
	pass # replace with function body
