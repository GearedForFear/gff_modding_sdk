extends HSlider


const LABEL_PATH = "../MaterialsLabel"


func _enter_tree():
	yield(get_tree(), "idle_frame")
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "materials", 2)
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		max_value = 2.0
	else:
		max_value = 1.0
	root_control.get_node("SettingsManager").materials = value


func _on_MaterialsSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_MaterialsSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.materials = value
	root_control.get_node("MaterialManager").update_settings()
	config.set_value("graphics", "materials", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	match value:
		0.0:
			label.text = "Materials: Extra Low"
		1.0:
			label.text = "Materials: Low"
		2.0:
			label.text = "Materials: Default"
