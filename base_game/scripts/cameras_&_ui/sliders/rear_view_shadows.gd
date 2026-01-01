extends SettingsSlider


const LABEL_PATH = "../RearViewShadowsLabel"


func _enter_tree():
	value = SettingsManager.get_this().rear_view_shadows


func update_label():
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
	ensure_label_visible(LABEL_PATH)


func _on_LightingSlider_value_changed(value):
	SettingsManager.get_this().rear_view_shadows = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "rear_view_shadows", value)
	config.save("user://config.cfg")
	update_setting()
