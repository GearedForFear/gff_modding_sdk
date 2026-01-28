extends HSlider


const LABEL_PATH_EFFECTS = "../SoundEffectsVolumeLabel"
const LABEL_PATH_MUSIC = "../MusicVolumeLabel"

export(GlobalEnums.AudioBuses) var audio_bus = 1


func _enter_tree():
	value = SettingsManager.get_config().get_value(
			"audio", Audio.bus_to_string(audio_bus), 50)


func update():
	GlobalAudio.play("SliderChangeAudio")
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("audio", Audio.bus_to_string(audio_bus), value)
	config.save("user://config.cfg")
	
	match audio_bus:
		GlobalEnums.AudioBuses.EFFECTS:
			var label: Label = get_node(LABEL_PATH_EFFECTS)
			label.text = tr("FX_VOLUME") + ": " + String(value)
		GlobalEnums.AudioBuses.MUSIC:
			var label: Label = get_node(LABEL_PATH_MUSIC)
			label.text = tr("MUSIC_VOLUME") + ": " + String(value)
	AudioServer.set_bus_volume_db(audio_bus, linear2db(value / 100))


func _on_SoundEffectsVolumeSlider_value_changed(_value):
	update()


func _on_MusicVolumeSlider_value_changed(_value):
	update()
