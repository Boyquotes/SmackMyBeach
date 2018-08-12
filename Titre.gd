extends Node2D

func _input(event):
	if event.is_action("kick"):
		get_tree().change_scene("res://Beach.tscn")
