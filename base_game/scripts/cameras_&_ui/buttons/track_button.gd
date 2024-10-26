extends Button


export var track_path: String = "res://scenes/world/tracks/downpour.tscn"


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	root_control.switch_buttons(get_parent(), \
			get_node("../../PlayerButtons/OnePlayer"))
	root_control.get_node("ButtonPressAudio").play()
	if root_control.track_path != track_path:
		root_control.track_mutex.lock()
		root_control.track_path = track_path
		var thread: Thread = root_control.thread
		if not thread.is_alive():
			thread.wait_to_finish()
			if thread.start(root_control, "prepare") != OK:
				push_error("Thread did not start!")
		root_control.track_mutex.unlock()
