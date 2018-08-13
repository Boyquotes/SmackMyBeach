extends Node2D

var blinks = [ 2, 0.3, 0.5, 0.3  ] 

var blink_id = 0

func _ready():
	pass

func _on_timer_timeout():
	if visible:
		hide()
	else:
		show()
		
	blink_id = (blink_id + 1) % blinks.size()
	
	$timer.wait_time = blinks[blink_id]
	
	$timer.start()
	
