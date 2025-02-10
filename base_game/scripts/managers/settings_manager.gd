class_name SettingsManager
extends Node


const THE_CALM: Environment = \
		preload("res://resources/environments/the_calm.tres")
const BELOW: Environment = \
		preload("res://resources/environments/below.tres")
const TWISTED: Environment = \
		preload("res://resources/environments/twisted.tres")
const ENVIRONMENTS: Array = [THE_CALM, BELOW, TWISTED]

var resolution: int = 1
var msaa: int = Viewport.MSAA_DISABLED
var reflections: int = 0
var materials: int = 2
var lighting: int = 2
var view_distance: float = 2500.0
var rear_view_distance: float = 200.0
var field_of_view: float = 75.0
var shadow_casters: int = 2
var splits: int = 3
var splits_multiplayer: int = 2
var shadow_resolution: int = 8192
var max_rigid_bodies: int = 100
var mirror_frame_rate: bool = true
var transform_interpolation: bool = true

var split_screen_divisor: int = 1
var to_update: Array


func apply_settings():
	for n in range(to_update.size() - 1, -1, -1):
		var node: Node = to_update[n]
		if is_instance_valid(node):
			node.apply_settings(self)
		else:
			to_update.remove(n)


static func get_this() -> SettingsManager:
	return Global.root_control.get_node("SettingsManager") as SettingsManager


func set_reflections(value: int):
	reflections = value
	THE_CALM.ss_reflections_max_steps = value


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
	if Global.root_control.player_amount == 1:
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
