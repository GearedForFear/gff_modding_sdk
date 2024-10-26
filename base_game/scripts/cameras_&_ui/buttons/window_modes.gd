extends Button


export var borderless: bool = false
export var fullscreen: bool = false


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	OS.window_borderless = borderless
	OS.window_fullscreen = fullscreen
	config.set_value("graphics", "borderless", borderless)
	config.set_value("graphics", "fullscreen", fullscreen)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/WindowModes"))
	root_control.get_node("ButtonPressAudio").play()
