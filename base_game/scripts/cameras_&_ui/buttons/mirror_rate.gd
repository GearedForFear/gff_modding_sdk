extends Button


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	var settings_manager: Node = root_control.get_node("SettingsManager")
	settings_manager.mirror_rate_reduced = !settings_manager.mirror_rate_reduced
	config.set_value("graphics", "mirror_rate_reduced", \
			settings_manager.mirror_rate_reduced)
	config.save("user://config.cfg")
	get_node("/root/RootControl/ButtonPressAudio").play()
