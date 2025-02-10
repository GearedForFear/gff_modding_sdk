extends Button


export var borderless: bool = false
export var fullscreen: bool = false


func _enter_tree():
	var config: ConfigFile = get_node("/root/RootControl").config
	OS.window_borderless = config.get_value("graphics", "borderless", false)
	OS.window_fullscreen = config.get_value("graphics", "fullscreen", true)


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	OS.window_borderless = borderless
	OS.window_fullscreen = fullscreen
	config.set_value("graphics", "borderless", borderless)
	config.set_value("graphics", "fullscreen", fullscreen)
	config.save("user://config.cfg")
	get_node("../..").hide()
	get_node("../../../OptionsMenu/Buttons/WindowMode").grab_focus()
	get_node("../../../OptionsMenu").show()
	root_control.get_node("ButtonPressAudio").play()
