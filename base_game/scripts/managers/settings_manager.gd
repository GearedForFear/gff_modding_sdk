class_name SettingsManager
extends Node


const THE_CALM: Environment = \
		preload("res://resources/environments/the_calm.tres")
const PILLARS: Environment = \
		preload("res://resources/environments/pillars.tres")
const BELOW: Environment = \
		preload("res://resources/environments/below.tres")
const TWISTED: Environment = \
		preload("res://resources/environments/twisted.tres")
const ENVIRONMENTS: Array = [THE_CALM, PILLARS, BELOW, TWISTED]

var config: ConfigFile = ConfigFile.new()
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
var rear_view_shadows: int = 0
var max_rigid_bodies: int = 100
var mirror_frame_rate: bool = true
var transform_interpolation: bool = true

var split_screen_divisor: int = 1
var to_update: Array


func start():
	config.load("user://config.cfg")
	field_of_view = config.get_value("graphics", "field_of_view", 75)
	OS.window_borderless = config.get_value("graphics", "borderless", false)
	OS.window_fullscreen = config.get_value("graphics", "fullscreen", true)
	for n in [1, 2]:
		var volume: float = config.get_value(
				"audio", Utils.audio_bus_to_string(n), 50)
		AudioServer.set_bus_volume_db(n, linear2db(volume / 100))
	var language: String = config.get_value("ui", "language", "")
	if language == "":
		language = OS.get_locale_language()
	TranslationServer.set_locale(language)
	msaa = config.get_value("graphics", "msaa", 0)
	reflections = config.get_value("graphics", "reflections", 0)
	
	lighting = config.get_value("graphics", "lighting", 2)
	view_distance = config.get_value("graphics", "view_distance", 2500)
	rear_view_distance = config.get_value("graphics", "rear_view_distance", 200)
	shadow_casters = config.get_value("graphics", "shadow_casters", 2)
	splits = config.get_value("graphics", "splits", 3)
	splits_multiplayer = config.get_value("graphics", "splits_multiplayer", 2)
	shadow_resolution = config.get_value("graphics", "shadow_resolution", 8192)
	rear_view_shadows = config.get_value("graphics", "rear_view_shadows", 0)
	max_rigid_bodies = config.get_value("graphics", "max_rigid_bodies", 100)
	OS.vsync_enabled = config.get_value("graphics", "vsync", true)
	mirror_frame_rate = config.get_value("graphics", "mirror_frame_rate", false)


static func apply_settings():
	var this: SettingsManager = get_this()
	var nodes_to_update: Array = this.to_update
	for n in range(nodes_to_update.size() - 1, -1, -1):
		var node: Node = nodes_to_update[n]
		if is_instance_valid(node):
			node.apply_settings(this)
		else:
			nodes_to_update.remove(n)


static func get_this() -> SettingsManager:
	return Global.root_control.get_node("SettingsManager") as SettingsManager


static func get_config() -> ConfigFile:
	return get_this().config


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
