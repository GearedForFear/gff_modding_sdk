extends Button


func _pressed():
	get_node("/root/RootControl/Names").hide()
	get_node("/root/RootControl/Scores").hide()
	get_node("/root/RootControl/CurrentSettings").show()
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../SettingsButtons/Graphics"))
	get_node("/root/RootControl/ButtonPressAudio").play()
