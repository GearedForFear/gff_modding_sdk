extends HSlider


const LABEL_PATH = "../ToggleMirrorLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = float(root_control.config.get_value(\
			"graphics", "mirror_frame_rate", false))
	root_control.get_node("SettingsManager").mirror_frame_rate = bool(value)


func _draw():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("MIRROR_FRAME_RATE")
	var converted_value: bool = bool(value)
	if converted_value:
		label.text += ": " + tr("FULL")
	else:
		label.text += ": " + tr("REDUCED")


func _on_ToggleMirrorSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ToggleMirrorSlider_value_changed(value):
	var converted_value: bool = bool(value)
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.mirror_frame_rate = converted_value
	settings_manager.apply_settings()
	config.set_value("graphics", "mirror_frame_rate", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	_draw()
