extends Button


export var distance: float = 200.0


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").rear_view_distance = distance
	config.set_value("graphics", "rear_view_distance", distance)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/RearViewDistance"))
	root_control.get_node("ButtonPressAudio").play()
