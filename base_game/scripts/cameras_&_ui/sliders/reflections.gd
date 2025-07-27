class_name Reflections
extends HSlider


const SELF_PATH = "AspectRatioContainer/AdvancedMenu/Sliders/VBoxContainer/ReflectionsSlider"
const LABEL_PATH = "../ReflectionsLabel"


func _enter_tree():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		var root_control: Control = Global.root_control
		value = convert_to_slider_value(root_control.config.get_value("graphics", \
				"reflections", 0))
		_on_ReflectionsSlider_value_changed(value)
	else:
		editable = false
		var label: Label = get_node(LABEL_PATH)
		label.text = "Reflections: Incompatible"


func _draw():
	update_text()


static func update_text():
	var base_value: int = get_reflections_base()
	var label: Label = get_this().get_node(LABEL_PATH)
	if base_value == 0:
		label.text = label.tr("SSR_OFF")
	else:
		label.text = label.tr("SSR") + ": " + String(base_value)
		var max_steps: int = get_reflections_clamped()
		if base_value > max_steps:
			label.text += " (" + label.tr("SSR_CAP") + " " + String(max_steps) \
					+ ")"


func convert_to_slider_value(var x: int) -> int:
	if x == 0:
		return 0
	var return_value: int = 1
	while return_value != 11:
		if pow(2, return_value + 4) == x:
			break
		return_value += 1
	return return_value


static func get_this() -> Reflections:
	return Global.root_control.get_node_or_null(SELF_PATH) as Reflections


static func get_reflections_base() -> int:
	var settings_manager: SettingsManager = SettingsManager.get_this()
	if settings_manager == null:
		return -1
	return settings_manager.reflections


static func get_reflections_clamped() -> int:
	var settings_manager: SettingsManager = SettingsManager.get_this()
	if settings_manager == null:
		return -1
	return int(min(OS.window_size.x / settings_manager.resolution / 4, \
			settings_manager.reflections))


static func update_reflections():
	if get_this() == null:
		return
	var max_steps: int = get_reflections_clamped()
	for n in SettingsManager.ENVIRONMENTS:
		n.ss_reflections_max_steps = max_steps
		n.ss_reflections_enabled = max_steps != 0
	update_text()


func _on_ReflectionsSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ReflectionsSlider_value_changed(value):
	var converted_value: int
	if value == 0:
		converted_value = 0
	else:
		converted_value = pow(2, value + 4)
	
	var root_control: Control = Global.root_control
	var settings_manager: SettingsManager = root_control.get_node(\
			"SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.reflections = converted_value
	settings_manager.apply_settings()
	update_reflections()
	config.set_value("graphics", "reflections", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	root_control.get_node("Precompiler").start()
