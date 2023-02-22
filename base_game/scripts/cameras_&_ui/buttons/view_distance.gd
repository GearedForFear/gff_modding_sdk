extends Button


export var distance: int = 1000.0


func _pressed():
	get_node("/root/RootControl/SettingsManager").view_distance \
			= distance
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ViewDistance"))
	get_node("/root/RootControl/ButtonPressAudio").play()
