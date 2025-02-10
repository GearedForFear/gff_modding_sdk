extends HSlider


const LABEL_PATH = "../ShadowCastersLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "shadow_casters", 2)
	root_control.get_node("SettingsManager").shadow_casters = value


func _on_ShadowCastersSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ShadowCastersSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.shadow_casters = value
	settings_manager.apply_settings()
	config.set_value("graphics", "shadow_casters", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	match value:
		0.0:
			label.text = "Shadow Casters: Extra Low"
		1.0:
			label.text = "Shadow Casters: Low"
		2.0:
			label.text = "Shadow Casters: Default"
		3.0:
			label.text = "Shadow Casters: High"
		4.0:
			label.text = "Shadow Casters: Extra High"
		5.0:
			label.text = "Shadow Casters: Ultimate"
