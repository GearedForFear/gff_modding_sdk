extends Button


export var resolution: int = 1


func _draw():
	text = String(round(OS.window_size.x / resolution)) + " x " \
			+ String(round(OS.window_size.y / resolution))


func _pressed():
	get_node("/root/RootControl/SettingsManager").resolution = resolution
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/Resolution"))
	get_node("/root/RootControl/ButtonPressAudio").play()
