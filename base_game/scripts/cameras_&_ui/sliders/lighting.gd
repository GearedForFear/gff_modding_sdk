extends HSlider


const LABEL_PATH = "../LightingLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "lighting", 2)
	root_control.get_node("SettingsManager").lighting = value


func _draw():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("LIGHTING") + ": "
	match value:
		0.0:
			label.text += tr("LOW_2")
		1.0:
			label.text += tr("LOW")
		2.0:
			label.text += tr("DEFAULT")


func _on_LightingSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_LightingSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.lighting = value
	settings_manager.apply_settings()
	config.set_value("graphics", "lighting", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	_draw()
