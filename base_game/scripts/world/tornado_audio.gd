extends AudioStreamPlayer3D


const HalloweenAudio: AudioStreamSample = preload(\
		"res://resources/sounds/world/wind_cold_howling_haunted_loop_02.wav")


func _enter_tree():
	var date: Dictionary = Time.get_date_dict_from_system()
	if date.day == 31 and date.month == 10:
		stream = HalloweenAudio
