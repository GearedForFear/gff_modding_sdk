extends Button


export var resolution: int = 1


func _draw():
	text = String(round(OS.window_size.x / resolution)) + " x " \
			+ String(round(OS.window_size.y / resolution))


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").resolution = resolution
	config.set_value("graphics", "resolution", resolution)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/Resolution"))
	root_control.get_node("ButtonPressAudio").play()
