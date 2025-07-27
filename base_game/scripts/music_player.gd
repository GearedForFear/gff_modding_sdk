class_name MusicPlayer
extends AudioStreamPlayer


enum action {STOP = -2, SKIP, PLAY_1, PLAY_2, PLAY_3, PLAY_4}

var themes: Array = [preload("res://resources/music/theme_1.mp3")]
var timer_action: int
var next: AudioStreamMP3


static func get_this() -> MusicPlayer:
	return Global.root_control.get_node("MusicPlayer") as MusicPlayer


func set_playlist(playlist: Array, time: float):
	stream = themes[playlist[0]]
	play()
	timer_action = playlist[1]
	$Timer.wait_time = time
	$Timer.start()
	if timer_action == action.SKIP:
		next = themes[playlist[2]]


func _on_Timer_timeout():
	if is_instance_valid(get_parent().track):
		match timer_action:
			action.STOP:
				if get_parent().track.get_node("GameplayManager/Timer").time_left\
						< 4.0:
					stop()
			action.SKIP:
				stream = next
				play()
