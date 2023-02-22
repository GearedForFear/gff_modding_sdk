extends Button


export var borderless: bool = false
export var fullscreen: bool = false


func _pressed():
	OS.window_borderless = borderless
	OS.window_fullscreen = fullscreen
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/WindowModes"))
	get_node("/root/RootControl/ButtonPressAudio").play()
