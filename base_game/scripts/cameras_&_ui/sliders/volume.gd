extends HSlider


const LABEL_PATH_EFFECTS = "../SoundEffectsVolumeLabel"
const LABEL_PATH_MUSIC = "../MusicVolumeLabel"

enum AUDIO_BUSES {MASTER, EFFECTS, MUSIC}

export(AUDIO_BUSES) var audio_bus = 1


func _enter_tree():
	AudioServer.set_bus_volume_db(audio_bus, 0.0)
	yield(get_tree(), "idle_frame")
	var root_control: Control = get_node("/root/RootControl")
	match audio_bus:
		AUDIO_BUSES.EFFECTS:
			value = root_control.config.get_value("audio", "sound", 50)
		AUDIO_BUSES.MUSIC:
			value = root_control.config.get_value("audio", "music", 50)
	AudioServer.set_bus_volume_db(audio_bus, linear2db(value / 100))


func update():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SliderChangeAudio").play()
	match audio_bus:
		AUDIO_BUSES.EFFECTS:
			var label: Label = get_node(LABEL_PATH_EFFECTS)
			config.set_value("audio", "sound", value)
			label.text = tr("FX_VOLUME") + ": " + String(value)
		AUDIO_BUSES.MUSIC:
			var label: Label = get_node(LABEL_PATH_MUSIC)
			config.set_value("audio", "music", value)
			label.text = "Music coming in the Future"
			label.text = tr("MUSIC_VOLUME") + ": " + String(value)
	AudioServer.set_bus_volume_db(audio_bus, linear2db(value / 100))
	config.save("user://config.cfg")


func _on_SoundEffectsVolumeSlider_value_changed(_value):
	update()


func _on_MusicVolumeSlider_value_changed(_value):
	update()


func _on_SoundMenu_visibility_changed():
	update()
