extends HSlider


const LABEL_PATH = "../RearViewShadowsLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "rear_view_shadows", 0)
	root_control.get_node("SettingsManager").rear_view_shadows = value


func _draw():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("REAR_VIEW_SHADOWS") + ": "
	match value:
		0.0:
			label.text += tr("ALWAYS_OFF")
		1.0:
			label.text += tr("SINGLEPLAYER_ONLY")
		2.0:
			label.text += tr("ALWAYS_ON")


func _on_LightingSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_LightingSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.rear_view_shadows = value
	settings_manager.apply_settings()
	config.set_value("graphics", "rear_view_shadows", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	_draw()
