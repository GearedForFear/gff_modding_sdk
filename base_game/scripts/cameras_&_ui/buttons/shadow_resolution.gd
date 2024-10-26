extends Button


export var shadow_resolution: int = 8192


func _ready():
	if shadow_resolution >= 16384 and OS.has_feature("32"):
		disabled = true


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").shadow_resolution = shadow_resolution
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", \
			shadow_resolution)
	config.set_value("graphics", "shadow_resolution", shadow_resolution)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowRes"))
	root_control.get_node("ButtonPressAudio").play()
