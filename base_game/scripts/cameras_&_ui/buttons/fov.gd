extends Button


export var field_of_view: int = 75


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").field_of_view = field_of_view
	config.set_value("graphics", "field_of_view", field_of_view)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_node("../.."), \
			get_node("../../../GraphicsButtons/FieldOfView"))
	root_control.get_node("ButtonPressAudio").play()
