class_name Reflections
extends SettingsSlider


const LABEL_PATH = "../ReflectionsLabel"


func _enter_tree():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		value = convert_to_slider_value(SettingsManager.get_config().get_value(
				"graphics", "reflections", 0))
	else:
		editable = false
		var label: Label = get_node(LABEL_PATH)
		label.text = "Reflections: Incompatible"


func update_label():
	var true_value: int = SettingsManager.get_this().reflections
	var label: Label = get_node(LABEL_PATH)
	if true_value == 0:
		label.text = label.tr("SSR_OFF")
	else:
		label.text = label.tr("SSR") + ": " + String(true_value)
		var max_steps: int = get_reflections_clamped()
		if true_value > max_steps:
			label.text += " (" + label.tr("SSR_CAP") + " " + String(max_steps) \
					+ ")"


func convert_to_slider_value(var true_value: int) -> int:
	if true_value == 0:
		return 0
	var return_value: int = 1
	while return_value != 11:
		if pow(2, return_value + 4) == true_value:
			break
		return_value += 1
	return return_value


func convert_to_true_value(var slider_value: int) -> int:
	if slider_value == 0:
		return 0
	else:
		return int(pow(2, slider_value + 4))


static func get_reflections_clamped() -> int:
	var settings_manager: SettingsManager = SettingsManager.get_this()
	if settings_manager == null:
		return -1
	return int(min(OS.window_size.x / settings_manager.resolution / 4, \
			settings_manager.reflections))


static func update_reflections():
	var max_steps: int = get_reflections_clamped()
	for n in SettingsManager.ENVIRONMENTS:
		n.ss_reflections_max_steps = max_steps
		n.ss_reflections_enabled = max_steps != 0


func _on_ReflectionsSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ReflectionsSlider_value_changed(value):
	var converted_value: int = convert_to_true_value(value)
	SettingsManager.get_this().reflections = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "reflections", converted_value)
	config.save("user://config.cfg")
	update_reflections()
	update_setting()
