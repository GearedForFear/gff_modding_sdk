extends Node


func _ready():
	if OS.get_current_video_driver() != OS.VIDEO_DRIVER_GLES3:
		for n in get_children():
			DeletionManager.add_to_garbage(n)
	
	var timer: Timer
	if name.begins_with("Reverse"):
		timer = get_node("../ReverseHazeTimer")
	else:
		timer = get_node("../HazeTimer")
	timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Timer_timeout():
	for n in get_children():
		n.emitting = false
