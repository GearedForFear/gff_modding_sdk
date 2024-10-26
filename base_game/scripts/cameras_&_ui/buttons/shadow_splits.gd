extends Button


export var splits: int = 3


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").splits = splits
	config.set_value("graphics", "splits", splits)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowSplits"))
	root_control.get_node("ButtonPressAudio").play()
