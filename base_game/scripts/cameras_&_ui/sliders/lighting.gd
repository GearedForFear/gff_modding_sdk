extends SettingsSlider


const LABEL_PATH = "../LightingLabel"


func _enter_tree():
	value = SettingsManager.get_this().lighting


func update_label():
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
	ensure_label_visible(LABEL_PATH)


func _on_LightingSlider_value_changed(value):
	SettingsManager.get_this().lighting = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "lighting", value)
	config.save("user://config.cfg")
	update_setting()
