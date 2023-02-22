extends Button


export var selection: String = "../../GraphicsButtons/WindowModes"


func _pressed():
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node(selection))
	get_node("/root/RootControl/ButtonPressAudio").play()
