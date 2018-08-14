# scène de représentation des points
extends Node2D

onready var label = $label

func _ready():
	pass
	
func animate():
	
	$tween.interpolate_property($label, "rect_position", $label.rect_position, $label.rect_position + Vector2(0, -50), $timer.wait_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
	
func _on_timer_timeout():
	queue_free()
