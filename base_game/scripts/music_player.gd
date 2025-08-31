class_name MusicPlayer
extends AudioStreamPlayer


const MENU_MUSIC: MusicState = preload(
		"res://resources/custom/music_states/theme_1/before_intro.tres")

var is_on_vehicle_select := false
var bridge_was_played := false
var spent_ten_minutes_in_menu := false
var round_timer: Timer
var current_state: MusicState = MENU_MUSIC


func _ready():
	var next_stream_timer: NextStreamTimer = $NextStreamTimer
	next_stream_timer.set_time(stream.get_length())
	while true:
		next_stream_timer.start()
		yield(next_stream_timer, "timeout")
		var time_to_next_stream: float = play_next()
		next_stream_timer.set_time(time_to_next_stream)


static func get_this() -> MusicPlayer:
	return Global.root_control.get_node("MusicPlayer") as MusicPlayer


func start(start_state: MusicState, round_timer: Timer):
	current_state = start_state
	stream = current_state.audio
	self.round_timer = round_timer
	var next_stream_timer: NextStreamTimer = $NextStreamTimer
	$NextStreamTimer.refresh()
	next_stream_timer.set_time(stream.get_length())
	play()


func play_next() -> float:
	var next: MusicState = current_state.get_next(self)
	if next == null:
		return 86400.0
	elif not next.resource_name == "repeat":
		bridge_was_played = bridge_was_played or current_state.bridge
		current_state = next
	stream = current_state.audio
	play()
	return stream.get_length()


func _on_MenuTimer_timeout():
	spent_ten_minutes_in_menu = true
