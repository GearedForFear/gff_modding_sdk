extends HSlider


const LABEL_PATH = "../ShadowSplitsLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "splits", 3)
	root_control.get_node("SettingsManager").splits = value


func _on_ShadowSplitsSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ShadowSplitsSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.splits = value
	settings_manager.apply_settings()
	config.set_value("graphics", "splits", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	label.text = "Shadow Map Splits: " + String(value)
