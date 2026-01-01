extends SettingsSlider


const LABEL_PATH = "../ViewDistanceLabel"
const VALUES := PoolIntArray([100, 200, 300, 400, 500, 750, 1000, 1500, 2500])


func _enter_tree():
	value = VALUES.find(SettingsManager.get_this().view_distance)


func update_label():
	var label: Label = get_node(LABEL_PATH)
	var converted_value: int = VALUES[value]
	label.text = tr("VIEW_DISTANCE") + ": " + String(converted_value) + "m"


func _on_ViewDistanceSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_ViewDistanceSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	SettingsManager.get_this().view_distance = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "view_distance", converted_value)
	config.save("user://config.cfg")
	update_setting()
