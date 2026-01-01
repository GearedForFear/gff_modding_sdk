extends SettingsSlider


const LABEL_PATH = "../ShadowSplitsLabel"


func _enter_tree():
	value = SettingsManager.get_this().splits


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("SHADOW_SPLITS") + ": " + String(value)


func _on_ShadowSplitsSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ShadowSplitsSlider_value_changed(value):
	SettingsManager.get_this().splits = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "splits", value)
	config.save("user://config.cfg")
	update_setting()
