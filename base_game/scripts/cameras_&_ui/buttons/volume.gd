extends Button


export var bus_idx: int = 1
export var volume_linear : float = 0.0


func _pressed():
	AudioServer.set_bus_volume_db(bus_idx, linear2db(volume_linear))
	if bus_idx == 1:
		get_node("/root/RootControl").switch_buttons(get_node("../.."), \
				get_node("../../../SoundButtons/EffectsVolume"))
	else:
		get_node("/root/RootControl").switch_buttons(get_node("../.."), \
				get_node("../../../SoundButtons/MusicVolume"))
	get_node("/root/RootControl/ButtonPressAudio").play()
