extends Button


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	root_control.get_node("Names").hide()
	root_control.get_node("Scores").hide()
	root_control.get_node("CurrentSettings").show()
	root_control.switch_buttons(get_parent(), \
			get_node("../../SettingsButtons/Graphics"))
	root_control.get_node("ButtonPressAudio").play()
