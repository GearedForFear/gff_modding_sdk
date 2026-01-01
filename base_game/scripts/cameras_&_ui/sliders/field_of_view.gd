extends SettingsSlider


const LABEL_PATH = "../Label"


func _enter_tree():
	value = SettingsManager.get_this().field_of_view
	update_label()


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("FIELD_OF_VIEW") + ": " + String(value) + "°"


func _on_HSlider_value_changed(value):
	GlobalAudio.play("SliderChangeAudio")
	SettingsManager.get_this().field_of_view = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "field_of_view", value)
	config.save("user://config.cfg")
	update_setting()
