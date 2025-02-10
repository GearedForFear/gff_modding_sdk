extends HSlider


const LABEL_PATH = "../TransformInterpolationLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = float(root_control.config.get_value(
			"graphics", "transform_interpolation", true))
	root_control.get_node("SettingsManager").transform_interpolation \
			= bool(value)


func _on_TransformInterpolationSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_TransformInterpolationSlider_value_changed(value):
	var converted_value: bool = bool(value)
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.transform_interpolation = converted_value
	settings_manager.apply_settings()
	config.set_value("graphics", "transform_interpolation", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	if converted_value:
		label.text = "Transform Interpolation: Automatic"
	else:
		label.text = "Transform Interpolation: Always Off"
