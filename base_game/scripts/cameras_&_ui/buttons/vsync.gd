extends Button


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	OS.vsync_enabled = !OS.vsync_enabled
	config.set_value("graphics", "vsync", OS.vsync_enabled)
	config.save("user://config.cfg")
	get_node("/root/RootControl/ButtonPressAudio").play()
