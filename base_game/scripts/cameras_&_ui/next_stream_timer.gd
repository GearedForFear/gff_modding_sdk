class_name NextStreamTimer
extends Timer


onready var time_to_next_mix: float = AudioServer.get_time_to_next_mix()


func set_time(wait_time: float):
	self.wait_time = wait_time - time_to_next_mix
	start()


func refresh():
	time_to_next_mix = AudioServer.get_time_to_next_mix()
