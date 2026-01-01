extends SettingsSlider


const LABEL_PATH = "../ShadowResolutionLabel"
const VALUES := PoolIntArray([2048, 4096, 8192, 16384])


func _enter_tree():
	value = VALUES.find(SettingsManager.get_this().shadow_resolution)


func _ready():
	if OS.has_feature("32"):
		max_value = 2


func update_label():
	var label: Label = get_node(LABEL_PATH)
	var converted_value: int = VALUES[value]
	label.text = tr("SHADOW_RES") + ": " + String(converted_value) + " x " \
			+ String(converted_value)


func _on_ShadowResolutionSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ShadowResolutionSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", \
			converted_value)
	SettingsManager.get_this().shadow_resolution = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "shadow_resolution", converted_value)
	config.save("user://config.cfg")
	update_setting()
