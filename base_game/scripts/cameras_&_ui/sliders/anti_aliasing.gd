extends SettingsSlider


const LABEL_PATH = "../AntiAliasingLabel"


func _enter_tree():
	value = SettingsManager.get_this().msaa


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("AA") + ": "
	match value:
		0.0:
			label.text += tr("AA_LOWEST")
		1.0:
			label.text += "2x MSAA"
		2.0:
			label.text += "4x MSAA"
		3.0:
			label.text += "8x MSAA"
		4.0:
			label.text += "16x HSAA"


func _on_AntiAliasingSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_AntiAliasingSlider_value_changed(value):
	SettingsManager.get_this().msaa = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "msaa", value)
	config.save("user://config.cfg")
	update_setting()
