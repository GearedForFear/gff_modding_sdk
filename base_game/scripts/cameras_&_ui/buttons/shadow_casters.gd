extends Button


export var shadow_casters: int = 3


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").shadow_casters \
			= shadow_casters
	config.set_value("graphics", "shadow_casters", shadow_casters)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowCasters"))
	root_control.get_node("ButtonPressAudio").play()
