extends HSlider


const LABEL_PATH = "../ToggleMirrorLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = float(root_control.config.get_value(\
			"graphics", "mirror_frame_rate", false))
	root_control.get_node("SettingsManager").mirror_frame_rate = bool(value)


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
	var label: Label = get_node(LABEL_PATH)
	if converted_value:
		label.text = "Rear View Mirror Frame Rate (Multiplayer): Full"
	else:
		label.text = "Rear View Mirror Frame Rate (Multiplayer): Reduced"
