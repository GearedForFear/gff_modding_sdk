extends Button


export var splits_multiplayer: int = 2


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").splits_multiplayer = splits_multiplayer
	config.set_value("graphics", "splits_multiplayer", splits_multiplayer)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowSplitsMultiplayer"))
	root_control.get_node("ButtonPressAudio").play()
