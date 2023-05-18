extends Button


export var distance: float = 1000.0

onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _pressed():
	root_control.get_node("SettingsManager").view_distance = distance
	config.set_value("graphics", "view_distance", distance)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ViewDistance"))
	root_control.get_node("ButtonPressAudio").play()
