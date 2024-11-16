extends Node


#var tick_times: Array
#var frame_times: Array


func _physics_process(_delta):
	pass#get_parent().move_child(self, get_parent().get_child_count() - 1)
#	tick_times.append(OS.get_ticks_usec() - get_node("../StartTime").time)
#	if tick_times.size() == 100:
#		var time: int = 0
#		for n in tick_times:
#			time += n
#		tick_times.clear()
#		print("Tick: " + String(time / 100))


func _process(_delta):
	pass#frame_times.append(OS.get_ticks_usec() - get_node("../StartTime").time)
#	if frame_times.size() == 100:
#		var time: int = 0
#		for n in frame_times:
#			time += n
#		frame_times.clear()
#		print("Frame: " + String(time / 100))
