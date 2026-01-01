extends SettingsSlider


const LABEL_PATH = "../ToggleMirrorLabel"


func _enter_tree():
	value = SettingsManager.get_this().splits_multiplayer


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("MIRROR_FRAME_RATE")
	var converted_value: bool = bool(value)
	if converted_value:
		label.text += ": " + tr("FULL")
	else:
		label.text += ": " + tr("REDUCED")


func _on_ToggleMirrorSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ToggleMirrorSlider_value_changed(value):
	var converted_value: bool = bool(value)
	SettingsManager.get_this().mirror_frame_rate = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "mirror_frame_rate", converted_value)
	config.save("user://config.cfg")
	update_setting()
