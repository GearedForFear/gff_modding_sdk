extends Button


onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _pressed():
	OS.vsync_enabled = !OS.vsync_enabled
	config.set_value("graphics", "vsync", OS.vsync_enabled)
	config.save("user://config.cfg")
	get_node("/root/RootControl/ButtonPressAudio").play()
