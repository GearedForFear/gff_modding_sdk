extends SettingsSlider


const LABEL_PATH = "../MaximumRigidBodiesLabel"
const VALUES := PoolIntArray([
		0, 25, 50, 75, 100, 200, 400, 700, 1000, 2000, 10000])


func _enter_tree():
	value = VALUES.find(SettingsManager.get_this().max_rigid_bodies)


func update_label():
	var label: Label = get_node(LABEL_PATH)
	var converted_value: int = VALUES[value]
	label.text = tr("MAX_RIGID_BODIES") + ": " + String(converted_value)


func _on_MaximumRigidBodiesSlider_focus_entered():
	ensure_label_visible(LABEL_PATH)


func _on_MaximumRigidBodiesSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	SettingsManager.get_this().max_rigid_bodies = converted_value
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "max_rigid_bodies", converted_value)
	config.save("user://config.cfg")
	update_setting()
