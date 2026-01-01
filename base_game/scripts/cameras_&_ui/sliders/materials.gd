extends SettingsSlider


const LABEL_PATH = "../MaterialsLabel"


func _enter_tree():
	value = SettingsManager.get_this().materials


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("MATERIALS") + ": "
	match value:
		0.0:
			label.text += tr("LOW_2")
		1.0:
			label.text += tr("LOW")
		2.0:
			label.text += tr("DEFAULT")
	
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		label.text += " (" + tr("GL2_VERSION") + ")"


func _on_MaterialsSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_MaterialsSlider_value_changed(value):
	SettingsManager.get_this().materials = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "materials", value)
	config.save("user://config.cfg")
	update_setting()
