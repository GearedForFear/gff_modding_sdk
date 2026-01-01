extends SettingsSlider


const LABEL_PATH = "../VSyncLabel"


func _enter_tree():
	value = OS.vsync_enabled


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("V_SYNC")
	var converted_value: bool = bool(value)
	if converted_value:
		label.text += ": " + tr("ON")
	else:
		label.text += ": " + tr("OFF")


func _on_VSyncSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_VSyncSlider_value_changed(value):
	var converted_value: bool = bool(value)
	OS.vsync_enabled = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "vsync", converted_value)
	config.save("user://config.cfg")
	update_setting()
