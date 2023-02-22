extends Button


export var msaa: int = 0


func _pressed():
	get_node("/root/RootControl/SettingsManager").msaa = msaa
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/MSAA"))
	get_node("/root/RootControl/ButtonPressAudio").play()
