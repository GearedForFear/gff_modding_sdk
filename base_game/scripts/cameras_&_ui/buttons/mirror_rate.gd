extends Button


onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config
onready var settings_manager: Node = root_control.get_node("SettingsManager")


func _pressed():
	settings_manager.mirror_rate_reduced = !settings_manager.mirror_rate_reduced
	config.set_value("graphics", "mirror_rate_reduced", \
			settings_manager.mirror_rate_reduced)
	config.save("user://config.cfg")
	get_node("/root/RootControl/ButtonPressAudio").play()
