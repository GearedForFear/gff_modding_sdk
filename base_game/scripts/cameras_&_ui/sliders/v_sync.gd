extends HSlider


const LABEL_PATH = "../VSyncLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = float(root_control.config.get_value("graphics", "vsync", true))
	OS.vsync_enabled = bool(value)


func _draw():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("V_SYNC")
	var converted_value: bool = bool(value)
	if converted_value:
		label.text += ": " + tr("ON")
	else:
		label.text += ": " + tr("OFF")


func _on_VSyncSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_VSyncSlider_value_changed(value):
	var converted_value: bool = bool(value)
	OS.vsync_enabled = converted_value
	var root_control: Control = get_node("/root/RootControl")
	var config: ConfigFile = root_control.config
	config.set_value("graphics", "vsync", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	
