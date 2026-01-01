extends SettingsSlider


const LABEL_PATH = "../ShadowCastersLabel"


func _enter_tree():
	value = SettingsManager.get_this().shadow_casters


func update_label():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("SHADOW_CASTERS") + ": "
	match value:
		0.0:
			label.text += tr("LOW_2")
		1.0:
			label.text += tr("LOW")
		2.0:
			label.text += tr("DEFAULT")
		3.0:
			label.text += tr("HIGH")
		4.0:
			label.text += tr("HIGH_2")
		5.0:
			label.text += tr("HIGHEST")


func _on_ShadowCastersSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ShadowCastersSlider_value_changed(value):
	SettingsManager.get_this().shadow_casters = value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "shadow_casters", value)
	config.save("user://config.cfg")
	Global.root_control.propagate_call("update_shadow_casting")
	update_setting()
