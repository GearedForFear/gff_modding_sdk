extends HSlider


const LABEL_PATH = "../MaximumRigidBodiesLabel"
const VALUES := PoolIntArray([
		0, 25, 50, 75, 100, 200, 400, 700, 1000, 2000, 10000])


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	var converted_value: int = root_control.config.get_value(
			"graphics", "max_rigid_bodies", 100)
	value = VALUES.find(converted_value)
	root_control.get_node("SettingsManager").max_rigid_bodies = converted_value


func _draw():
	var label: Label = get_node(LABEL_PATH)
	var converted_value: int = VALUES[value]
	label.text = tr("MAX_RIGID_BODIES") + ": " + String(converted_value)


func _on_MaximumRigidBodiesSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_MaximumRigidBodiesSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.max_rigid_bodies = converted_value
	settings_manager.apply_settings()
	config.set_value("graphics", "max_rigid_bodies", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	_draw()
