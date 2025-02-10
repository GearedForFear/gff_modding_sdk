extends Button


export var selection: String = "../../TrackMenu/Buttons/TheCalm"
export(int, 1, 3, 1) var hide_parent = 1
export(int, 1, 3, 1) var show_parent = 1


func _pressed():
	get_node("/root/RootControl/ButtonPressAudio").play()
	var target: Control = self
	for _n in hide_parent:
		target = target.get_parent()
	target.hide()
	target = get_node(selection)
	target.grab_focus()
	for _n in show_parent:
		target = target.get_parent()
	target.show()
