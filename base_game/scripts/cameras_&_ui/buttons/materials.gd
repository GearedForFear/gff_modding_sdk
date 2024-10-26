extends Button


export var materials: int = 2


func _ready():
	if materials >= 2 and OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		disabled = true


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	get_parent().hide()
	while root_control.thread.is_alive():
		yield(get_tree(), "idle_frame")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").materials \
			= materials
	config.set_value("graphics", "materials", materials)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/Materials"))
	root_control.get_node("ButtonPressAudio").play()
	root_control.get_node("MaterialManager").update_settings()
