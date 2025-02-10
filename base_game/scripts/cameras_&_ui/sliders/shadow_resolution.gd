extends HSlider


const LABEL_PATH = "../ShadowResolutionLabel"
const VALUES := PoolIntArray([2048, 4096, 8192, 16384])


func _enter_tree():
	if OS.has_feature("32"):
		max_value = 2
	var root_control: Control = get_node("/root/RootControl")
	var converted_value: int = root_control.config.get_value(
			"graphics", "shadow_resolution", 8192)
	value = VALUES.find(converted_value)


func _on_ShadowResolutionSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ShadowResolutionSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", \
			converted_value)
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.shadow_resolution = converted_value
	settings_manager.apply_settings()
	config.set_value("graphics", "shadow_resolution", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	label.text = "Shadow Resolution: " + String(converted_value) + " x " \
			+ String(converted_value)
