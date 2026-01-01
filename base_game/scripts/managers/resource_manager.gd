class_name ResourceManager
extends Node


const TORNADO_AUDIO_DEFAULT: String = \
		"res://resources/sounds/world/wind_general_gusty_low_loop_02.wav"
const HALLOWEEN_AUDIO: String = \
		"res://resources/sounds/world/wind_cold_howling_haunted_loop_02.wav"

var tornado_audio: AudioStreamSample

onready var always_loaded: Array = ResourceLoader.load(\
		"res://resources/custom/always_loaded.tres", "Resource").array


func load_resources():
	var date: Dictionary = Time.get_date_dict_from_system()
	if date.day == 31 and date.month == 10:
		tornado_audio = ResourceLoader.load(HALLOWEEN_AUDIO,
				"AudioStreamSample")
	else:
		tornado_audio = ResourceLoader.load(TORNADO_AUDIO_DEFAULT,
				"AudioStreamSample")
	
	var resources: Array = Array()
	for n in always_loaded:
		resources.append(ResourceLoader.load(n, "PackedScene"))
	always_loaded.clear()
	always_loaded.append_array(resources)


static func get_this() -> ResourceManager:
	return Global.root_control.get_node("ResourceManager") as ResourceManager
