extends HSlider


const LABEL_PATH = "../Label"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "field_of_view", 75)
	root_control.get_node("SettingsManager").field_of_view = value


func _on_AntiAliasingSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: SettingsManager = root_control.get_node(\
			"SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.field_of_view = value
	settings_manager.apply_settings()
	config.set_value("graphics", "field_of_view", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	label.text = "Field of View: " + String(value) + "°"
