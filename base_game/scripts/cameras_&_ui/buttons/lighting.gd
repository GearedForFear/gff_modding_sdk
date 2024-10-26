extends Button


export var lighting: int = 2


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").lighting \
			= lighting
	config.set_value("graphics", "lighting", lighting)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/Lighting"))
	root_control.get_node("ButtonPressAudio").play()
