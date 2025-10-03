class_name MusicPlayer
extends AudioStreamPlayer


const MENU_MUSIC: MusicState = preload(
		"res://resources/custom/music_states/theme_1/before_intro.tres")
const SECONDS_IN_A_DAY: float = 86400.0

var is_on_vehicle_select := false
var bridge_was_played := false
var spent_ten_minutes_in_menu := false
var round_timer: Timer
var current_state: MusicState = MENU_MUSIC
var next_music_thread := Thread.new()
var next_finish: int


static func get_this() -> MusicPlayer:
	return Global.root_control.get_node("MusicPlayer") as MusicPlayer


func start(start_state: MusicState, round_timer: Timer):
	current_state = start_state
	play_next(false)
	self.round_timer = round_timer
	bridge_was_played = false


func play_next(wait: bool):
	var parameters: Array = [current_state, wait]
	if next_music_thread.start(self, "play_stream", parameters) != OK:
		push_error("Next music thread did not start!")
	$NextStreamTimer.set_time(next_music_thread)


func play_stream(parameters: Array) -> float:
	var state: MusicState = parameters[0]
	if state == null:
		return SECONDS_IN_A_DAY
	bridge_was_played = bridge_was_played or state.bridge
	var wait: bool = parameters[1]
	if wait:
		while next_finish > OS.get_ticks_usec():
			pass
	self.stream = state.audio
	play()
	next_finish = int(OS.get_ticks_usec() + stream.get_length() * 1_000_000)
	return stream.get_length() - 0.04


func _on_MenuTimer_timeout():
	spent_ten_minutes_in_menu = true


func _on_LoadingManager_resources_loaded():
	start(MENU_MUSIC, null)
	while true:
		yield($NextStreamTimer, "timeout")
		current_state = current_state.get_next(self)
		play_next(true)
