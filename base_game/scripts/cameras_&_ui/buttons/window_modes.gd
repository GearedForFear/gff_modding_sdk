class_name WindowMode
extends StandardButton


export var borderless: bool = false
export var fullscreen: bool = false


func _pressed():
	GlobalAudio.play("ButtonPressAudio")
	
	OS.window_borderless = borderless
	OS.window_fullscreen = fullscreen
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "borderless", borderless)
	config.set_value("graphics", "fullscreen", fullscreen)
	config.save("user://config.cfg")
	
	MenuManager.escape()
