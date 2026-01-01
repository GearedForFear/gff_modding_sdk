extends SettingsSlider


const LABEL_PATH = "../RearViewDistanceLabel"
const VALUES := PoolIntArray([25, 50, 75, 100, 200, 300, 400, 500,
		750, 1000, 1500, 2500])


func _enter_tree():
	value = VALUES.find(SettingsManager.get_this().rear_view_distance)


func update_label():
	var label: Label = get_node(LABEL_PATH)
	var converted_value: int = VALUES[value]
	label.text = tr("REAR_VIEW_DISTANCE") + ": " + String(converted_value) + "m"


func _on_RearViewDistanceSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_RearViewDistanceSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	SettingsManager.get_this().rear_view_distance = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "rear_view_distance", converted_value)
	config.save("user://config.cfg")
	update_setting()
