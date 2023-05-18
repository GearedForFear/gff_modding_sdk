extends Button


export var msaa: int = 0

onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _pressed():
	root_control.get_node("SettingsManager").msaa = msaa
	config.set_value("graphics", "msaa", msaa)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/MSAA"))
	root_control.get_node("ButtonPressAudio").play()
