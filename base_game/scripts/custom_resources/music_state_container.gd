class_name MusicStateContainer
extends Resource


export var value_path: String

var value: MusicState


func get_state() -> MusicState:
	if value == null:
		value = ResourceLoader.load(value_path, "MusicState")
	return value
