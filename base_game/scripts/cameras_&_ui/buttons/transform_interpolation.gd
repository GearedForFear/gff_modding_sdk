extends Button


onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config
onready var settings_manager: Node = root_control.get_node("SettingsManager")


func _pressed():
	settings_manager.transform_interpolation \
			= !settings_manager.transform_interpolation
	config.set_value("graphics", "transform_interpolation", \
			settings_manager.transform_interpolation)
	config.save("user://config.cfg")
	get_node("/root/RootControl/ButtonPressAudio").play()
