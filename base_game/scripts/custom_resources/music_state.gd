class_name MusicState
extends Resource


enum GuardOperations {NULL, IS_ON_VEHICLE_SELECT, BRIDGE_WAS_PLAYED,
		SPENT_TEN_MINUTES_IN_MENU, TIMER_IS_BEFORE}

export var audio: AudioStream
export var default_next: Resource
export var bridge := false

export var next_1: Resource
export(GuardOperations) var guard_operation_1: int = GuardOperations.NULL
export(float, 0, 100) var guard_time_1: float = 100.0

export var next_2: Resource
export(GuardOperations) var guard_operation_2: int = GuardOperations.NULL
export(float, 0, 100) var guard_time_2: float = 100.0


func get_state() -> MusicState:
	return self


func get_next(music_player: AudioStreamPlayer)\
		-> MusicState:
	if default_next == null:
		return null
	if check(guard_operation_1, guard_time_1, music_player):
		return next_1.get_state()
	if check(guard_operation_2, guard_time_2, music_player):
		return next_2.get_state()
	return default_next.get_state()


func check(guard_operation: int, guard_time: float,
		music_player: AudioStreamPlayer) -> bool:
	match guard_operation:
		GuardOperations.NULL:
			return false
		GuardOperations.IS_ON_VEHICLE_SELECT:
			return music_player.is_on_vehicle_select
		GuardOperations.BRIDGE_WAS_PLAYED:
			return music_player.bridge_was_played
		GuardOperations.SPENT_TEN_MINUTES_IN_MENU:
			return music_player.spent_ten_minutes_in_menu
		GuardOperations.TIMER_IS_BEFORE:
			var timer: Timer = music_player.round_timer
			return is_instance_valid(timer) and timer.time_left > guard_time
		_:
			push_error("Invalid guard operation")
			return false
