extends Button


export var msaa: int = 0


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	root_control.get_node("SettingsManager").msaa = msaa
	config.set_value("graphics", "msaa", msaa)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/MSAA"))
	root_control.get_node("ButtonPressAudio").play()


func _on_MSAA8x_focus_entered():
	get_node("../../Warning").text = "Needs more than 8GB of VRAM at 4K"
	get_node("../../Warning").show()


func _on_MSAA8x_focus_exited():
	get_node("../../Warning").hide()


func _on_MSAA16x_focus_entered():
	get_node("../../Warning").text = "Needs more than 8GB of VRAM at 1440p"
	get_node("../../Warning").show()


func _on_MSAA16x_focus_exited():
	get_node("../../Warning").hide()
