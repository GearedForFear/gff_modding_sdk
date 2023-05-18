extends Button


export var bus_idx: int = 1
export var volume_linear : float = 0.0

onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _pressed():
	AudioServer.set_bus_volume_db(bus_idx, linear2db(volume_linear))
	if bus_idx == 1:
		config.set_value("audio", "sound", volume_linear)
		root_control.switch_buttons(get_node("../.."), \
				get_node("../../../SoundButtons/EffectsVolume"))
	else:
		config.set_value("audio", "music", volume_linear)
		root_control.switch_buttons(get_node("../.."), \
				get_node("../../../SoundButtons/MusicVolume"))
	config.save("user://config.cfg")
	root_control.get_node("ButtonPressAudio").play()
