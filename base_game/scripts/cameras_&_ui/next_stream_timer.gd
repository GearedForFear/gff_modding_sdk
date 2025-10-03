class_name NextStreamTimer
extends Timer


func set_time(thread: Thread):
	stop()
	while thread.is_alive():
		yield(get_tree(), "idle_frame")
	self.wait_time = thread.wait_to_finish()
	start()
