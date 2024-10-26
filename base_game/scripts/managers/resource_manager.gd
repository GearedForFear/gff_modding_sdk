extends Node


const TornadoAudioDefault: String = \
		"res://resources/sounds/world/wind_general_gusty_low_loop_02.wav"
const HalloweenAudio: String = \
		"res://resources/sounds/world/wind_cold_howling_haunted_loop_02.wav"


var tornado_audio: AudioStreamSample


onready var always_loaded: Array = ResourceLoader.load(\
		"res://resources/custom/always_loaded.tres", "Resource").array


func load_resources():
	var date: Dictionary = Time.get_date_dict_from_system()
	if date.day == 31 and date.month == 10:
		tornado_audio = ResourceLoader.load(HalloweenAudio, "AudioStreamSample")
	else:
		tornado_audio = ResourceLoader.load(TornadoAudioDefault,
				"AudioStreamSample")
	
	var resources: Array = Array()
	for n in always_loaded:
		resources.append(ResourceLoader.load(n, "PackedScene"))
	always_loaded.clear()
	always_loaded.append_array(resources)
