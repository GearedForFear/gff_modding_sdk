class_name Audio
extends Object


static func bus_to_string(audio_bus: int) -> String:
	match audio_bus:
		GlobalEnums.AudioBuses.EFFECTS:
			return "effects"
		GlobalEnums.AudioBuses.MUSIC:
			return "music"
		_:
			return ""
