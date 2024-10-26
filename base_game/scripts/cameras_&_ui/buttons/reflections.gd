extends Button


export var reflections: int = 0


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").reflections \
			= reflections
	config.set_value("graphics", "reflections", reflections)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/Reflections"))
	root_control.get_node("ButtonPressAudio").play()
	get_node("/root/RootControl/Precompiler/Viewport/Camera/WorldEnvironment")\
			._ready()
