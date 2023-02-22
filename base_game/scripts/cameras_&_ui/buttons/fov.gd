extends Button


export var field_of_view: int = 75


func _pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view \
			= field_of_view
	get_node("/root/RootControl").switch_buttons(get_node("../.."), \
			get_node("../../../GraphicsButtons/FieldOfView"))
	get_node("/root/RootControl/ButtonPressAudio").play()
