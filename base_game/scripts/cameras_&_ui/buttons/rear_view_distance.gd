extends Button


export var distance: int = 200.0


func _pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance \
			= distance
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/RearViewDistance"))
	get_node("/root/RootControl/ButtonPressAudio").play()
