extends SettingsSlider


const LABEL_PATH = "../ShadowSplitsMultiplayerLabel"


func _enter_tree():
	value = SettingsManager.get_this().splits_multiplayer


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("SHADOW_SPLITS_MP") + ": " + String(value)


func _on_ShadowSplitsMultiplayerSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ShadowSplitsMultiplayerSlider_value_changed(value):
	SettingsManager.get_this().splits_multiplayer = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "splits_multiplayer", value)
	config.save("user://config.cfg")
	update_setting()
