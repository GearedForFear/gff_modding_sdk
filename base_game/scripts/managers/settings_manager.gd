extends Node


var resolution: int = 1
var msaa: int = Viewport.MSAA_DISABLED
var reflections: int = 0
var materials: int = 2
var lighting: int = 2
var mirror_rate_reduced: bool = true
var transform_interpolation: bool = true
var view_distance: float = 1000.0
var rear_view_distance: float = 200.0
var field_of_view: float = 75.0
var shadow_casters: int = 3
var splits: int = 3
var splits_multiplayer: int = 2
var shadow_resolution: int = 8192
var max_rigid_bodies: int = 100

var split_screen_divisor: int = 1


func shadow_distance() -> float:
	var return_value: float
	match shadow_resolution:
		2048:
			return_value = 1_445_000.0
		4096:
			return_value = 2_890_000.0
		8192:
			return_value = 5_780_000.0
		_:
			return_value = 11_560_000.0
	
	var current_splits: int
	if get_node("/root/RootControl").player_amount == 1:
		current_splits = splits
	else:
		current_splits = splits_multiplayer
	match current_splits:
		0:
			return 0.0
		1:
			return_value *= 0.2
		2:
			return_value *= 0.2
	
	return return_value * pow(OS.window_size.y / OS.window_size.x, 2) \
			/ pow(field_of_view, 2)
