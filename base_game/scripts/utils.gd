class_name Utils
extends Object


static func random_dictionary_value(dictionary: Dictionary): # -> Variant
	randomize()
	var position: int = randi() % dictionary.size()
	return dictionary.values()[position]


static func audio_bus_to_string(audio_bus: int) -> String:
	match audio_bus:
		GlobalEnums.AudioBuses.EFFECTS:
			return "effects"
		GlobalEnums.AudioBuses.MUSIC:
			return "music"
		_:
			return ""
